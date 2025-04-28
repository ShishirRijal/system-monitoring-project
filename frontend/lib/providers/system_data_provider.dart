import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:system_monitoring_project/models/alert.dart';
import 'package:system_monitoring_project/models/system_snapshot.dart';

class SystemDataProvider with ChangeNotifier {
  List<SystemSnapshot> _snapshots = [];
  List<Alert> _alerts = [];
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;

  // Base URL for the Spring Boot API
  final String _baseUrl = 'http://localhost:8080/api';

  SystemDataProvider() {
    // Initialize by fetching data
    refreshData();

    // Set up periodic refresh every 5 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      refreshData();
    });
  }

  List<SystemSnapshot> get snapshots => _snapshots;
  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // CPU usage stats
  double get currentCpuUsage =>
      _snapshots.isNotEmpty ? _snapshots.last.cpuUsage : 0.0;

  // Memory usage stats
  double get currentMemoryUsagePercent {
    if (_snapshots.isEmpty) return 0.0;
    // Convert bytes to percentage (assuming total memory is known)
    // For demo, we'll use the raw value and format in the UI
    return _snapshots.last.memoryUsage /
        (1024 * 1024 * 1024) *
        100; // Convert to GB percentage
  }

  // Trends over time
  List<double> get cpuUsageTrend {
    return _snapshots.map((snapshot) => snapshot.cpuUsage).toList();
  }

  List<double> get memoryUsageTrend {
    return _snapshots
        .map((snapshot) => snapshot.memoryUsage / (1024 * 1024 * 1024) * 100)
        .toList(); // Convert to GB percentage
  }

  // Alert statistics
  int get warningCount {
    return _alerts.where((alert) => alert.message.contains('Warning')).length;
  }

  int get dangerCount {
    return _alerts.where((alert) => alert.message.contains('Danger')).length;
  }

  int get infoCount {
    return _alerts
        .where(
          (alert) =>
              !alert.message.contains('Warning') &&
              !alert.message.contains('Danger'),
        )
        .length;
  }

  // Fetch both snapshots and alerts
  Future<void> refreshData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([fetchSnapshots(), fetchAlerts()]);
    } catch (e) {
      _error = 'Failed to fetch data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSnapshots() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/snapshots'));

      if (response.statusCode == 200) {
        final List<dynamic> snapshotsJson = json.decode(response.body);
        _snapshots =
            snapshotsJson.map((json) => SystemSnapshot.fromJson(json)).toList();

        // Sort by creation date
        _snapshots.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        // Keep only the most recent 50 snapshots for performance
        if (_snapshots.length > 50) {
          _snapshots = _snapshots.sublist(_snapshots.length - 50);
        }
      } else {
        throw Exception('Failed to load snapshots: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching snapshots: $e');
      }
      throw e;
    }
  }

  Future<void> fetchAlerts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/alerts'));

      if (response.statusCode == 200) {
        final List<dynamic> alertsJson = json.decode(response.body);
        _alerts = alertsJson.map((json) => Alert.fromJson(json)).toList();

        // Sort by creation date (newest first)
        _alerts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        throw Exception('Failed to load alerts: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching alerts: $e');
      }
      throw e;
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
