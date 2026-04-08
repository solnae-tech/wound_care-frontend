import '../models/wound_model.dart';

class WoundService {
  static final WoundService _instance = WoundService._internal();
  factory WoundService() => _instance;
  WoundService._internal() {
    // Initial dummy data
    _wounds = [
      WoundModel(
        id: '1',
        title: 'Left Knee Abrasion',
        description: 'Scrape from a fall during evening run.',
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        healingPercentage: 74,
        status: WoundStatus.healing,
        imageUrl: 'https://picsum.photos/200?random=1',
        logs: [
          WoundLog(score: 74, date: DateTime.now(), note: 'Moderate healing, minimal redness present at the distal edge.', imageUrl: 'https://picsum.photos/200?random=1'),
          WoundLog(score: 60, date: DateTime.now().subtract(const Duration(days: 2)), note: 'Healing progressing steadily.', imageUrl: 'https://picsum.photos/200?random=10'),
          WoundLog(score: 49, date: DateTime.now().subtract(const Duration(days: 4)), note: 'Redness and swelling noticeable.', imageUrl: 'https://picsum.photos/200?random=11'),
          WoundLog(score: 32, date: DateTime.now().subtract(const Duration(days: 6)), note: 'Initial wound registered. Fresh abrasion, painful.', imageUrl: 'https://picsum.photos/200?random=12'),
        ],
        alertMessage: 'Increased Redness Detected|Your recent wound shows signs of potential inflammation. Contact your doctor if pain increases.',
      ),
      WoundModel(
        id: '2',
        title: 'Right Forearm Cut',
        description: 'Small kitchen knife cut.',
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
        healingPercentage: 100,
        status: WoundStatus.closed,
        imageUrl: 'https://picsum.photos/200?random=2',
        logs: [
           WoundLog(score: 100, date: DateTime.now().subtract(const Duration(days: 12)), note: 'Fully healed.', imageUrl: 'https://picsum.photos/200?random=2'),
        ],
      ),
    ];
  }

  List<WoundModel> _wounds = [];

  List<WoundModel> get wounds => _wounds;

  void addWound(String title, String description) {
    _wounds.insert(0, WoundModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      updatedAt: DateTime.now(),
      healingPercentage: 0,
      status: WoundStatus.healing,
      imageUrl: 'https://picsum.photos/200?random=${_wounds.length + 1}',
      logs: [
        WoundLog(
          score: 0,
          date: DateTime.now(),
          note: description.isNotEmpty ? description : 'Initial entry for $title.',
          imageUrl: 'https://picsum.photos/200?random=${_wounds.length + 1}',
        ),
      ],
    ));
  }

  WoundModel? get activeWound {
    return _wounds.firstWhere((w) => w.status == WoundStatus.healing, orElse: () => _wounds.first);
  }

  void updateWound(String id, String title, String description) {
    final index = _wounds.indexWhere((w) => w.id == id);
    if (index != -1) {
      final old = _wounds[index];
      final newHealing = (old.healingPercentage + 8).clamp(0, 100);
      
      final updatedLogs = List<WoundLog>.from(old.logs);
      updatedLogs.insert(0, WoundLog(
        score: newHealing,
        date: DateTime.now(),
        note: description.isNotEmpty ? description : 'Routine log update.',
        imageUrl: old.imageUrl,
      ));

      _wounds[index] = WoundModel(
        id: old.id,
        title: title, 
        description: description,
        updatedAt: DateTime.now(),
        healingPercentage: newHealing,
        status: newHealing == 100 ? WoundStatus.closed : old.status,
        imageUrl: old.imageUrl,
        logs: updatedLogs,
      );
    }
  }
}
