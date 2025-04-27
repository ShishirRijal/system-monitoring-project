package com.np.shishirrijal.system_monitoring.repository;

import com.np.shishirrijal.system_monitoring.model.SystemSnapshot;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SystemSnapshotRepository extends JpaRepository<SystemSnapshot, Long> {
}
