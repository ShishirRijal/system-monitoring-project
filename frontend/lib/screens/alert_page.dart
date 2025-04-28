import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:system_monitoring_project/models/alert.dart';
import 'package:system_monitoring_project/providers/system_data_provider.dart';
import 'package:system_monitoring_project/theme/app_theme.dart';
import 'package:system_monitoring_project/widgets/nav_sidebar.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Danger', 'Warning', 'Info'];

  @override
  void initState() {
    super.initState();
    // Fetch data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SystemDataProvider>(context, listen: false).refreshData();
    });
  }

  List<Alert> _filterAlerts(List<Alert> alerts, String filter) {
    if (filter == 'All') return alerts;

    return alerts.where((alert) {
      switch (filter) {
        case 'Danger':
          return alert.message.contains('Danger');
        case 'Warning':
          return alert.message.contains('Warning');
        case 'Info':
          return !alert.message.contains('Danger') &&
              !alert.message.contains('Warning');
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation sidebar
          const NavSidebar(currentPage: 'alerts'),

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
                  if (dataProvider.isLoading && dataProvider.alerts.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4ECDC4),
                      ),
                    );
                  }

                  // Show error state
                  if (dataProvider.error != null &&
                      dataProvider.alerts.isEmpty) {
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
                            'Error loading alerts',
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

                  final filteredAlerts = _filterAlerts(
                    dataProvider.alerts,
                    _selectedFilter,
                  );

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
                                Icons.notifications_active_outlined,
                                color: Color(0xFFFF9F1C),
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'System Alerts',
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

                      // Alert stats
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            children: [
                              _buildStatCard(
                                'Total Alerts',
                                dataProvider.alerts.length.toString(),
                                Icons.assessment_outlined,
                                const Color(0xFF4ECDC4),
                              ),
                              const SizedBox(width: 24),
                              _buildStatCard(
                                'Warnings',
                                dataProvider.warningCount.toString(),
                                Icons.warning_amber_outlined,
                                const Color(0xFFFF9F1C),
                              ),
                              const SizedBox(width: 24),
                              _buildStatCard(
                                'Danger Alerts',
                                dataProvider.dangerCount.toString(),
                                Icons.error_outline,
                                const Color(0xFFFF6B6B),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Filter options
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            children: [
                              Text(
                                'FILTER BY:',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 2,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Wrap(
                                spacing: 12,
                                children:
                                    _filters.map((filter) {
                                      final isSelected =
                                          _selectedFilter == filter;
                                      return FilterChip(
                                        label: Text(filter),
                                        selected: isSelected,
                                        showCheckmark: false,
                                        onSelected: (selected) {
                                          setState(() {
                                            _selectedFilter = filter;
                                          });
                                        },
                                        backgroundColor: const Color(
                                          0xFF1D1E33,
                                        ),
                                        selectedColor: _getFilterColor(
                                          filter,
                                        ).withOpacity(0.2),
                                        labelStyle: TextStyle(
                                          color:
                                              isSelected
                                                  ? _getFilterColor(filter)
                                                  : Colors.white70,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          side: BorderSide(
                                            color:
                                                isSelected
                                                    ? _getFilterColor(filter)
                                                    : Colors.transparent,
                                            width: 1,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => dataProvider.refreshData(),
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white70,
                                ),
                                tooltip: 'Refresh Alerts',
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Alert list
                      SliverPadding(
                        padding: const EdgeInsets.all(24),
                        sliver:
                            filteredAlerts.isEmpty
                                ? SliverToBoxAdapter(
                                  child: Container(
                                    height: 200,
                                    decoration: AppDecorations.glassCard,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.notifications_off_outlined,
                                            color: Colors.white30,
                                            size: 48,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No alerts found',
                                            style: AppTextStyles.sectionTitle
                                                .copyWith(
                                                  color: Colors.white30,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                : SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    final alert = filteredAlerts[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _buildAlertCard(alert),
                                    );
                                  }, childCount: filteredAlerts.length),
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // copilot hel

  Widget _buildAlertCard(Alert alert) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: alert.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alert.color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(alert.icon, color: alert.color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.message,
                  style: TextStyle(
                    color: alert.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(alert.createdAt),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'Danger':
        return const Color(0xFFFF6B6B);
      case 'Warning':
        return const Color(0xFFFF9F1C);
      case 'Info':
        return const Color(0xFF4ECDC4);
      default:
        return Colors.white70;
    }
  }
}
