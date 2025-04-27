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
    private Double cpuUsage;
    private Long memoryUsage;
    private LocalDateTime createdAt = LocalDateTime.now();
}
