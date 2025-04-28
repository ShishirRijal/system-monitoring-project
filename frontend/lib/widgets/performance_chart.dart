import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PerformanceChart extends StatelessWidget {
  final List<dynamic> snapshots;

  const PerformanceChart({super.key, required this.snapshots});

  @override
  Widget build(BuildContext context) {
    if (snapshots.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(color: Colors.white10, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(color: Colors.white10, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: snapshots.length > 10 ? 10 : snapshots.length.toDouble() - 1,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          // CPU line
          LineChartBarData(
            spots: _getCpuSpots(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFF4ECDC4), Color(0xFF8555FD)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4ECDC4).withOpacity(0.3),
                  const Color(0xFF8555FD).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Memory line
          LineChartBarData(
            spots: _getMemorySpots(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9F1C), Color(0xFFFF6B6B)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF9F1C).withOpacity(0.3),
                  const Color(0xFFFF6B6B).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: const Color(0xFF1D1E33).withOpacity(0.8),
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
              return lineBarsSpot.map((spot) {
                final String name = spot.barIndex == 0 ? 'CPU' : 'Memory';
                return LineTooltipItem(
                  '$name: ${spot.y.toStringAsFixed(1)}%',
                  TextStyle(
                    color:
                        spot.barIndex == 0
                            ? const Color(0xFF4ECDC4)
                            : const Color(0xFFFF9F1C),
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getCpuSpots() {
    // Use only the most recent 10 snapshots
    int startIdx = snapshots.length > 10 ? snapshots.length - 10 : 0;
    List displayData = snapshots.sublist(startIdx);

    List<FlSpot> spots = [];
    for (int i = 0; i < displayData.length; i++) {
      spots.add(FlSpot(i.toDouble(), displayData[i].cpuUsage));
    }
    return spots;
  }

  List<FlSpot> _getMemorySpots() {
    // Calculate memory percentage (assuming 16GB total memory for example)
    // This should be adjusted based on actual system specs
    const totalMemoryBytes = 16.0 * 1024 * 1024 * 1024; // 16 GB in bytes

    // Use only the most recent 10 snapshots
    int startIdx = snapshots.length > 10 ? snapshots.length - 10 : 0;
    List displayData = snapshots.sublist(startIdx);

    List<FlSpot> spots = [];
    for (int i = 0; i < displayData.length; i++) {
      final memoryPercentage =
          (displayData[i].memoryUsage / totalMemoryBytes) * 100;
      spots.add(FlSpot(i.toDouble(), memoryPercentage.clamp(0, 100)));
    }
    return spots;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    // Only show a few time labels to avoid crowding
    if (value.toInt() % 2 != 0) {
      return Container();
    }

    // Get the timestamp for this data point
    int idx = value.toInt();
    if (idx >= snapshots.length || idx < 0) {
      return Container();
    }

    String timeLabel = DateFormat('HH:mm:ss').format(snapshots[idx].createdAt);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        timeLabel,
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Text(
      '${value.toInt()}%',
      style: const TextStyle(color: Colors.white54, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}
