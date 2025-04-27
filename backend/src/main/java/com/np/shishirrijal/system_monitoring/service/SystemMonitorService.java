package com.np.shishirrijal.system_monitoring.service;



import lombok.RequiredArgsConstructor;
import oshi.SystemInfo;
import oshi.hardware.CentralProcessor;
import oshi.hardware.GlobalMemory;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SystemMonitorService {

    private final SystemInfo systemInfo = new SystemInfo();
    private long[] prevTicks; // Store previous CPU ticks

    public double getCpuUsage() {
        CentralProcessor processor = systemInfo.getHardware().getProcessor();
        if (prevTicks == null) {
            prevTicks = processor.getSystemCpuLoadTicks();
            try {
                Thread.sleep(1000); // Wait 1 second for initial ticks
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
        double cpuLoad = processor.getSystemCpuLoadBetweenTicks(prevTicks) * 100;
        prevTicks = processor.getSystemCpuLoadTicks();
        return Math.round(cpuLoad * 100.0) / 100.0; // Round to 2 decimals
    }

    public long getUsedMemory() {
        GlobalMemory memory = systemInfo.getHardware().getMemory();
        long totalMemory = memory.getTotal();
        long availableMemory = memory.getAvailable();
        return totalMemory - availableMemory;
    }

    public long getTotalMemory() {
        return systemInfo.getHardware().getMemory().getTotal();
    }

    public double getMemoryUsagePercentage() {
        long usedMemory = getUsedMemory();
        long totalMemory = getTotalMemory();
        return Math.round((double) usedMemory / totalMemory * 100 * 100.0) / 100.0;
    }
}