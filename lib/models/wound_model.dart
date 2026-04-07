enum WoundStatus { healing, closed, infected }

class WoundModel {
  final String id;
  final String title;
  final String description;
  final DateTime updatedAt;
  final int healingPercentage;
  final WoundStatus status;
  final String imageUrl;

  WoundModel({
    required this.id,
    required this.title,
    required this.description,
    required this.updatedAt,
    required this.healingPercentage,
    required this.status,
    required this.imageUrl,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
