import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool showTrend;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.showTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showTrend && trend != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  trend == 'up'
                      ? Icons.arrow_upward
                      : trend == 'down'
                      ? Icons.arrow_downward
                      : Icons.remove,
                  color: _getTrendColor(trend!),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _getTrendText(trend!),
                  style: TextStyle(
                    color: _getTrendColor(trend!),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return const Color(0xFFFF6B6B); // Red for upward trend (negative)
      case 'down':
        return const Color(0xFF4ECDC4); // Teal for downward trend (positive)
      case 'stable':
      default:
        return Colors.white70; // White for stable trend (neutral)
    }
  }

  String _getTrendText(String trend) {
    switch (trend) {
      case 'up':
        return 'Increasing';
      case 'down':
        return 'Decreasing';
      case 'stable':
      default:
        return 'Stable';
    }
  }
}
