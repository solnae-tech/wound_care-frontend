import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'onboarding_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF53D1C1),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF53D1C1).withAlpha(76),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/medical_kit_logo.png',
                      fit:     BoxFit.contain,
                    ),
                  ),
                  const Gap(40),
                  const Text(
                    'WoundCare',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1F2D),
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    'TRACK. HEAL. RECOVER.',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1.2,
                      color: Color(0xFF5A6B74),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: 40,
              right: 40,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      value: 0.45,
                      backgroundColor: Color(0xFFE0E7E8),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF338880)),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
