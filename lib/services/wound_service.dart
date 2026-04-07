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
      ),
      WoundModel(
        id: '2',
        title: 'Right Forearm Cut',
        description: 'Small kitchen knife cut.',
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
        healingPercentage: 100,
        status: WoundStatus.closed,
        imageUrl: 'https://picsum.photos/200?random=2',
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
    ));
  }

  WoundModel? get activeWound {
    return _wounds.firstWhere((w) => w.status == WoundStatus.healing, orElse: () => _wounds.first);
  }

  void updateWound(String id, String title, String description) {
    final index = _wounds.indexWhere((w) => w.id == id);
    if (index != -1) {
      final old = _wounds[index];
      // Simulate an improvement in healing percentage
      final newHealing = (old.healingPercentage + 8).clamp(0, 100);
      _wounds[index] = WoundModel(
        id: old.id,
        title: title, // although normally we wouldn't rename a wound
        description: description,
        updatedAt: DateTime.now(),
        healingPercentage: newHealing,
        status: newHealing == 100 ? WoundStatus.closed : old.status,
        imageUrl: old.imageUrl,
      );
    }
  }
}
