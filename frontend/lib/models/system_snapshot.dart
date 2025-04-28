class SystemSnapshot {
  final int id;
  final double cpuUsage;
  final int memoryUsage; // in bytes
  final DateTime createdAt;

  SystemSnapshot({
    required this.id,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.createdAt,
  });

  factory SystemSnapshot.fromJson(Map<String, dynamic> json) {
    return SystemSnapshot(
      id: json['id'],
      cpuUsage: json['cpuUsage'].toDouble(),
      memoryUsage: json['memoryUsage'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Helper method to convert memory to more readable format
  String get formattedMemory {
    double sizeInMB = memoryUsage / (1024 * 1024);
    if (sizeInMB < 1024) {
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else {
      return '${(sizeInMB / 1024).toStringAsFixed(2)} GB';
    }
  }
}
