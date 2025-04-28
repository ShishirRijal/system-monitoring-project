package com.np.shishirrijal.system_monitoring.scheduler;


import com.np.shishirrijal.system_monitoring.model.SystemSnapshot;
import com.np.shishirrijal.system_monitoring.model.Alert;
import com.np.shishirrijal.system_monitoring.repository.AlertRepository;
import com.np.shishirrijal.system_monitoring.repository.SystemSnapshotRepository;
import com.np.shishirrijal.system_monitoring.service.SystemMonitorService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Service
 public class MonitoringScheduler {
    private final SystemMonitorService monitorService;
    private final SystemSnapshotRepository snapshotRepository;
    private final AlertRepository alertRepository;
    public MonitoringScheduler(SystemMonitorService monitorService,
                               SystemSnapshotRepository snapshotRepository,
                               AlertRepository alertRepository) {
        this.monitorService = monitorService;
        this.snapshotRepository = snapshotRepository;
        this.alertRepository = alertRepository;
    }

    private static final Logger logger = LoggerFactory.getLogger(MonitoringScheduler.class);



    @Scheduled(fixedRate = 5000) // Every 5 seconds
    public void pollSystemStats() {
        // Collect stats
        double cpu = monitorService.getCpuUsage();
        long memory = monitorService.getUsedMemory();
        double memoryPercentage = monitorService.getMemoryUsagePercentage();

        // Save snapshot
        SystemSnapshot snapshot = new SystemSnapshot();
        snapshot.setCpuUsage(cpu);
        snapshot.setMemoryUsage(memory);
        snapshotRepository.save(snapshot);

        logger.info("CPU Usage: {}%", cpu);
        logger.info("Memory Usage: {}%", memoryPercentage);

        // Check for high CPU usage alert
        if (cpu > 80.0) {
            Alert alert = new Alert();
            alert.setMessage("Danger: High CPU Usage: " + cpu + "%");
            alertRepository.save(alert);
            logger.error("🚨 Danger: High CPU Usage: {}%", cpu);
        } else if (cpu > 20.0) {
            Alert alert = new Alert();
            alert.setMessage("Warning: CPU Usage: " + cpu + "%");
            alertRepository.save(alert);
            logger.warn("⚠️ Warning: CPU Usage: {}%", cpu);
        }

        // Check for high memory usage alert
        if (memoryPercentage > 90.0) {
            Alert alert = new Alert();
            alert.setMessage("Danger: High Memory Usage: " + memoryPercentage + "%");
            alertRepository.save(alert);
            logger.error("🚨 Danger: High Memory Usage: {}%", memoryPercentage);
        } else if (memoryPercentage > 65.0) {
            Alert alert = new Alert();
            alert.setMessage("Warning: Memory Usage: " + memoryPercentage + "%");
            alertRepository.save(alert);
            logger.warn("⚠️ Warning: Memory Usage: {}%", memoryPercentage);
        }

        // Lower limit alerts for CPU usage (e.g., below 10%)
        if (cpu < 10.0) {
            Alert alert = new Alert();
            alert.setMessage("Low CPU Usage: " + cpu + "%");
            alertRepository.save(alert);
            logger.info("💡 Low CPU Usage: {}%", cpu);
        }

        // Lower limit alerts for memory usage (e.g., below 30%)
        if (memoryPercentage < 30.0) {
            Alert alert = new Alert();
            alert.setMessage("Low Memory Usage: " + memoryPercentage + "%");
            alertRepository.save(alert);
            logger.info("💡 Low Memory Usage: {}%", memoryPercentage);
        }

        // Log stats
        System.out.println("CPU Usage: " + cpu + "%");
        logger.info("Memory Used: {} MB", memory / (1024 * 1024));
    }
}