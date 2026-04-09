enum WoundStatus { healing, closed, infected }

class AlertModel {
  final String title;
  final String message;
  final String severity;

  AlertModel({required this.title, required this.message, required this.severity});

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      severity: json['severity'] ?? 'info',
    );
  }
}

class WoundLog {
  final int score;
  final String note;
  final DateTime date;
  final String? imageUrl;
  
  WoundLog({
    required this.score,
    required this.note,
    required this.date,
    this.imageUrl,
  });
}

class WoundModel {
  final String id;
  final String title;
  final String description;
  final DateTime updatedAt;
  final int healingPercentage;
  final WoundStatus status;
  final String imageUrl;
  final List<WoundLog> logs;
  final String? alertMessage;

  WoundModel({
    required this.id,
    required this.title,
    required this.description,
    required this.updatedAt,
    required this.healingPercentage,
    required this.status,
    required this.imageUrl,
    required this.logs,
    this.alertMessage,
  });

  factory WoundModel.fromDashboardJson(Map<String, dynamic> json) {
    return WoundModel(
      id: json['wound_id']?.toString() ?? '',
      title: json['wound_name'] ?? 'Wound',
      description: '',
      updatedAt: DateTime.now(), // placeholder as dashboard doesn't provide it
      healingPercentage: 0, // placeholder
      status: _parseStatus(json['status']),
      imageUrl: 'https://picsum.photos/200?random=${json['wound_id']}',
      logs: [],
    );
  }

  static WoundStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'healing': return WoundStatus.healing;
      case 'closed': return WoundStatus.closed;
      case 'infected': return WoundStatus.infected;
      default: return WoundStatus.healing;
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
