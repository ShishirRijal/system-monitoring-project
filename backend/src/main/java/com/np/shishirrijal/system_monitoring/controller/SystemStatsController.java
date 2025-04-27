package com.np.shishirrijal.system_monitoring.controller;



import com.np.shishirrijal.system_monitoring.model.SystemSnapshot;
import com.np.shishirrijal.system_monitoring.model.Alert;

import com.np.shishirrijal.system_monitoring.repository.AlertRepository;
import com.np.shishirrijal.system_monitoring.repository.SystemSnapshotRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor

public class SystemStatsController{

    private final SystemSnapshotRepository snapshotRepository;
    private final AlertRepository alertRepository;

    @GetMapping("/snapshots")
    public List<SystemSnapshot> getSnapshots() {
        return snapshotRepository.findAll();
    }

    @GetMapping("/alerts")
    public List<Alert> getAlerts() {
        return alertRepository.findAll();
    }
}
