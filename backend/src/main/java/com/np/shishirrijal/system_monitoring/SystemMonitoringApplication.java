package com.np.shishirrijal.system_monitoring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class SystemMonitoringApplication {

	public static void main(String[] args) {
		SpringApplication.run(SystemMonitoringApplication.class, args);
	}

}
