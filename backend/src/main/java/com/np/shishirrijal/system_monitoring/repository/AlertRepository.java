package com.np.shishirrijal.system_monitoring.repository;


import com.np.shishirrijal.system_monitoring.model.Alert;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AlertRepository extends JpaRepository<Alert, Long> {
}