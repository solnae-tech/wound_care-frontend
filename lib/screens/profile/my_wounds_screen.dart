import 'package:flutter/material.dart';
import '../../services/wound_service.dart';
import '../../models/wound_model.dart';
import '../wounds/wound_progress_screen.dart';
import 'package:gap/gap.dart';

class MyWoundsScreen extends StatelessWidget {
  const MyWoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wounds = WoundService().wounds;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text('My Wounds', style: TextStyle(color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Color(0xFF338880)),
        elevation: 0,
        centerTitle: true,
      ),
      body: wounds.isEmpty
          ? const Center(
              child: Text('No wounds tracked yet', style: TextStyle(color: Color(0xFF9EA7AD))),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: wounds.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (context, index) {
                final wound = wounds[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => WoundProgressScreen(wound: wound)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            wound.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: const Color(0xFFE0E7E8),
                              child: const Icon(Icons.healing, color: Color(0xFF338880)),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(wound.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
                              const Gap(4),
                              Text(
                                'Status: ${wound.status.name.toUpperCase()}',
                                style: TextStyle(
                                  color: wound.status == WoundStatus.healing ? const Color(0xFF338880) : const Color(0xFF9EA7AD),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Color(0xFF9EA7AD)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
