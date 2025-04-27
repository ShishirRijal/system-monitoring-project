package com.np.shishirrijal.system_monitoring.scheduler;


import com.np.shishirrijal.system_monitoring.model.SystemSnapshot;
import com.np.shishirrijal.system_monitoring.model.Alert;
import com.np.shishirrijal.system_monitoring.repository.AlertRepository;
import com.np.shishirrijal.system_monitoring.repository.SystemSnapshotRepository;
import com.np.shishirrijal.system_monitoring.service.SystemMonitorService;import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MonitoringScheduler {

    private final SystemMonitorService monitorService;
    private final SystemSnapshotRepository snapshotRepository;
    private final AlertRepository alertRepository;


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

        // Check for alerts
        if (cpu > 80.0) {
            Alert alert = new Alert();
            alert.setMessage("High CPU Usage: " + cpu + "%");
            alertRepository.save(alert);
            System.out.println("🚨 " + alert.getMessage());
        }
        if (memoryPercentage > 90.0) {
            Alert alert = new Alert();
            alert.setMessage("High Memory Usage: " + memoryPercentage + "%");
            alertRepository.save(alert);
            System.out.println("🚨 " + alert.getMessage());
        }

        // Log stats
        System.out.println("CPU Usage: " + cpu + "%");
        System.out.println("Memory Used: " + memory / (1024 * 1024) + " MB");
    }
}