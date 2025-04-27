package com.np.shishirrijal.system_monitoring.model;


import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "system_snapshot")
@Data
public class SystemSnapshot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "cpu_usage")
    private Double cpuUsage;

    @Column(name = "memory_usage")
    private Long memoryUsage;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
}