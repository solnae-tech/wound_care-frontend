import 'package:flutter/material.dart';
import '../screens/chat/chat_screen.dart';

/// Drop this widget into any Scaffold's [floatingActionButton] property
/// to get the global chat assistant FAB.
class ChatFab extends StatelessWidget {
  const ChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'chat_fab',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
      },
      backgroundColor: const Color(0xFF53D1C1), // Brighter teal for better contrast
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: const Icon(Icons.health_and_safety_outlined, color: Colors.white, size: 28),
    );
  }
}
