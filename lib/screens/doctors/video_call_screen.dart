import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'doctor_detail_screen.dart';

class VideoCallScreen extends StatelessWidget {
  final DoctorDetailArgs doctor;
  final String slot;
  
  const VideoCallScreen({super.key, required this.doctor, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam_off, size: 64, color: Colors.white54),
                const Gap(16),
                const Text('Video Call Simulation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const Gap(8),
                Text('Connecting to ${doctor.name}...', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Positioned(
            top: 48,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
