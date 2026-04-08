import 'package:flutter/material.dart';

class MyWoundsScreen extends StatelessWidget {
  const MyWoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wounds', style: TextStyle(color: Color(0xFF0A1F2D))),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Color(0xFF338880)),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Wounds History Feature Coming Soon', style: TextStyle(color: Color(0xFF9EA7AD))),
      ),
    );
  }
}
