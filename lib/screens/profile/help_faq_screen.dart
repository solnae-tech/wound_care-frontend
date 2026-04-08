import 'package:flutter/material.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ', style: TextStyle(color: Color(0xFF0A1F2D))),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Color(0xFF338880)),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Help & FAQ Center Coming Soon', style: TextStyle(color: Color(0xFF9EA7AD))),
      ),
    );
  }
}
