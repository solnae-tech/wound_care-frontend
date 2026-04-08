enum WoundStatus { healing, closed, infected }

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

  String get timeAgo {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
