import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_monitoring_project/providers/system_data_provider.dart';
import 'package:system_monitoring_project/theme/app_theme.dart';
import 'package:system_monitoring_project/widgets/metric_card.dart';
import 'package:system_monitoring_project/widgets/nav_sidebar.dart';
import 'package:system_monitoring_project/widgets/performance_chart.dart';
import 'package:system_monitoring_project/widgets/recent_alerts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SystemDataProvider>(context, listen: false).refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation sidebar
          const NavSidebar(currentPage: 'dashboard'),

          // Main content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E21), Color(0xFF090B16)],
                ),
              ),
              child: Consumer<SystemDataProvider>(
                builder: (context, dataProvider, child) {
                  // Show loading state
                  if (dataProvider.isLoading &&
                      dataProvider.snapshots.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4ECDC4),
                      ),
                    );
                  }

                  // Show error state
                  if (dataProvider.error != null &&
                      dataProvider.snapshots.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFFF6B6B),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading data',
                            style: AppTextStyles.sectionTitle,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dataProvider.error!,
                            style: AppTextStyles.chartLabel,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => dataProvider.refreshData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4ECDC4),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      // App bar
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: const Color(
                          0xFF0A0E21,
                        ).withOpacity(0.7),
                        expandedHeight: 120,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Row(
                            children: [
                              const Icon(
                                Icons.dashboard_outlined,
                                color: Color(0xFF4ECDC4),
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'System Dashboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (dataProvider.isLoading)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF4ECDC4),
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                          centerTitle: false,
                          titlePadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),

                      // Dashboard content
                      SliverPadding(
                        padding: const EdgeInsets.all(24),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // System status overview
                              Text(
                                'SYSTEM STATUS',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 2,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Metric cards
                              Row(
                                children: [
                                  Expanded(
                                    child: MetricCard(
                                      title: 'CPU USAGE',
                                      value:
                                          '${dataProvider.currentCpuUsage.toStringAsFixed(1)}%',
                                      icon: Icons.memory,
                                      color: _getCpuStatusColor(
                                        dataProvider.currentCpuUsage,
                                      ),
                                      trend: dataProvider.cpuUsageTrend.join(
                                        ', ',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: MetricCard(
                                      title: 'MEMORY USAGE',
                                      value: _formatMemoryValue(
                                        dataProvider.snapshots.isNotEmpty
                                            ? dataProvider
                                                .snapshots
                                                .last
                                                .memoryUsage
                                            : 0,
                                      ),
                                      icon: Icons.storage,
                                      color: _getMemoryStatusColor(
                                        dataProvider.currentMemoryUsagePercent,
                                      ),
                                      trend: dataProvider.cpuUsageTrend.join(
                                        ', ',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: MetricCard(
                                      title: 'ACTIVE ALERTS',
                                      value: '${dataProvider.alerts.length}',
                                      icon: Icons.notifications_active,
                                      color: _getAlertStatusColor(
                                        dataProvider.alerts.length,
                                      ),
                                      showTrend: false,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Performance charts
                              Text(
                                'PERFORMANCE TRENDS',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 2,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 300,
                                padding: const EdgeInsets.all(20),
                                decoration: AppDecorations.glassCard,
                                child: PerformanceChart(
                                  snapshots: dataProvider.snapshots,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Recent alerts
                              Row(
                                children: [
                                  Text(
                                    'RECENT ALERTS',
                                    style: AppTextStyles.sectionTitle.copyWith(
                                      color: Colors.white70,
                                      letterSpacing: 2,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF8555FD,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF8555FD,
                                        ).withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF8555FD),
                                          size: 12,
                                        ),
                                        const SizedBox(width: 6),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/alerts',
                                            );
                                          },
                                          child: const Text(
                                            'View All',
                                            style: TextStyle(
                                              color: Color(0xFF8555FD),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              RecentAlertsWidget(
                                alerts: dataProvider.alerts.take(5).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for determining status colors
  Color _getCpuStatusColor(double value) {
    if (value > 80) {
      return const Color(0xFFFF6B6B); // Red for danger
    } else if (value > 50) {
      return const Color(0xFFFF9F1C); // Orange for warning
    } else {
      return const Color(0xFF4ECDC4); // Teal for normal
    }
  }

  Color _getMemoryStatusColor(double value) {
    if (value > 90) {
      return const Color(0xFFFF6B6B); // Red for danger
    } else if (value > 65) {
      return const Color(0xFFFF9F1C); // Orange for warning
    } else {
      return const Color(0xFF4ECDC4); // Teal for normal
    }
  }

  Color _getAlertStatusColor(int count) {
    if (count > 10) {
      return const Color(0xFFFF6B6B); // Red for many alerts
    } else if (count > 5) {
      return const Color(0xFFFF9F1C); // Orange for some alerts
    } else {
      return const Color(0xFF4ECDC4); // Teal for few/no alerts
    }
  }

  String _formatMemoryValue(int memoryBytes) {
    double memoryGB = memoryBytes / (1024 * 1024 * 1024);
    return '${memoryGB.toStringAsFixed(2)} GB';
  }
}
