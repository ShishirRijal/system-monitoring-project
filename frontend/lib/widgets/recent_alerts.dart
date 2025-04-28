import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:system_monitoring_project/models/alert.dart';
import 'package:system_monitoring_project/theme/app_theme.dart';

class RecentAlertsWidget extends StatelessWidget {
  final List<Alert> alerts;

  const RecentAlertsWidget({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Container(
        height: 120,
        decoration: AppDecorations.glassCard,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                color: Colors.white30,
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                'No recent alerts',
                style: TextStyle(color: Colors.white30, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: AppDecorations.glassCard,
      child: Column(
        children: [
          ...alerts.map((alert) => _buildAlertItem(alert)).toList(),
          if (alerts.length > 3)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white10, width: 1),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/alerts');
                },
                child: const Text(
                  'View all alerts',
                  style: TextStyle(
                    color: Color(0xFF8555FD),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(Alert alert) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: alert.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_getAlertIcon(alert), color: alert.color, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "alert.title",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _formatAlertTime(alert.createdAt),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  IconData _getAlertIcon(Alert alert) {
    if (alert.message.contains('Danger')) {
      return Icons.error_outline;
    } else if (alert.message.contains('Warning')) {
      return Icons.warning_amber_outlined;
    } else {
      return Icons.info_outline;
    }
  }

  String _formatAlertTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(timestamp);
    }
  }
}
