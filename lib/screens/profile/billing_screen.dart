import 'package:flutter/material.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing & Payments', style: TextStyle(color: Color(0xFF0A1F2D))),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Color(0xFF338880)),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Billing & Payments Coming Soon', style: TextStyle(color: Color(0xFF9EA7AD))),
      ),
    );
  }
}
