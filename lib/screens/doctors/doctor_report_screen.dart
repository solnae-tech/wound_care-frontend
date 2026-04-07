import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'doctor_detail_screen.dart';

class DoctorReportScreen extends StatelessWidget {
  final DoctorDetailArgs doctor;
  
  const DoctorReportScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text('Doctor Report', style: TextStyle(color: Color(0xFF0A1F2D))),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF338880), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description_outlined, size: 64, color: Color(0xFFCDD5D8)),
            const Gap(16),
            const Text('No Report Available Yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
            const Gap(8),
            Text('Report from ${doctor.name} will appear here.', style: const TextStyle(color: Color(0xFF9EA7AD))),
          ],
        ),
      ),
    );
  }
}
