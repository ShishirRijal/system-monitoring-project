import 'package:flutter/material.dart';

enum AlertSeverity { info, warning, danger }

class Alert {
  final int id;
  final String message;
  final DateTime createdAt;

  Alert({required this.id, required this.message, required this.createdAt});

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Determine severity based on message content
  AlertSeverity get severity {
    if (message.contains('Danger')) {
      return AlertSeverity.danger;
    } else if (message.contains('Warning')) {
      return AlertSeverity.warning;
    } else {
      return AlertSeverity.info;
    }
  }

  // Get color based on severity
  Color get color {
    switch (severity) {
      case AlertSeverity.danger:
        return const Color(0xFFFF6B6B);
      case AlertSeverity.warning:
        return const Color(0xFFFF9F1C);
      case AlertSeverity.info:
        return const Color(0xFF4ECDC4);
    }
  }

  // Get icon based on severity
  IconData get icon {
    switch (severity) {
      case AlertSeverity.danger:
        return Icons.error_outline;
      case AlertSeverity.warning:
        return Icons.warning_amber_outlined;
      case AlertSeverity.info:
        return Icons.info_outline;
    }
  }
}
