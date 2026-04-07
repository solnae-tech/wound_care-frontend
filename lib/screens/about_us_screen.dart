import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF338880), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('About WoundCare',
            style: TextStyle(
                color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Badge ─────────────────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF338880),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.circle, color: Colors.white, size: 7),
                  Gap(6),
                  Text('CLINICAL SANCTUARY',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8)),
                ],
              ),
            ),
            const Gap(20),

            // ── Mission heading ────────────────────────────────────────────
            const Text('Our Mission',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A1F2D),
                    height: 1.1)),
            const Gap(18),
            const Text(
              'We are bridging the gap between clinical excellence and home '
              'convenience. Our mission is to provide hospital-grade wound '
              'diagnostics and management directly to your living room, ensuring '
              'every patient receives the "Sanctuary" experience of specialized healing.',
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5A6B74),
                  height: 1.7),
            ),
            const Gap(28),

            // ── Hero image placeholder ─────────────────────────────────────
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A7A72), Color(0xFF338880)],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative circles
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(15),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -10,
                    bottom: -15,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(10),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.health_and_safety_outlined,
                          color: Colors.white, size: 56),
                      Gap(8),
                      Text('Hospital-Grade Care at Home',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(36),

            // ── Value cards ────────────────────────────────────────────────
            _ValueCard(
              icon: Icons.biotech_outlined,
              title: 'Precision',
              body: 'AI-driven analysis for accurate monitoring. We use '
                  'multi-spectral imaging to detect early signs of infection '
                  'before they become visible to the human eye.',
            ),
            const Gap(16),
            _ValueCard(
              icon: Icons.badge_outlined,
              title: 'Care',
              body: 'Connecting patients with top specialists. Our network '
                  'includes board-certified vascular surgeons and wound care '
                  'nurses available for instant review.',
            ),
            const Gap(16),
            _ValueCard(
              icon: Icons.verified_user_outlined,
              title: 'Trust',
              body: 'HIPAA-compliant and medically verified protocols. Every '
                  'byte of your data is encrypted with military-grade standards '
                  'to ensure absolute privacy.',
            ),
            const Gap(36),

            // ── Team section ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F5F4), Color(0xFFD0EEEC)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team icon row
                  Row(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF338880)
                              .withAlpha(40 + i * 30),
                          child: Icon(Icons.person,
                              color: const Color(0xFF338880),
                              size: 22),
                        ),
                      ),
                    ),
                  ),
                  const Gap(18),
                  const Text('The Team',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A1F2D))),
                  const Gap(10),
                  const Text(
                    'WoundCare is powered by a synergy of world-class medical '
                    'advisors from Johns Hopkins and lead engineers from top '
                    'health-tech startups. Together, we translate complex '
                    'clinical data into simple, actionable patient insights.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5A6B74),
                        height: 1.6),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // ── Technology section ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF338880),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Our Technology',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Gap(14),
                  const Text(
                    'At the heart of our platform lies advanced computer vision '
                    'algorithms that measure wound surface area and depth with '
                    'sub-millimeter precision. Combined with secure decentralized '
                    'data storage, we provide a permanent, unalterable record of '
                    'your healing journey.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        height: 1.6),
                  ),
                  const Gap(20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _TechChip('NEURAL ANALYSIS'),
                      _TechChip('END-TO-END ENCRYPTION'),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(32),

            // ── Version ───────────────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  const Text('VERSION 2.4.0 (2026)',
                      style: TextStyle(
                          color: Color(0xFF9EA7AD),
                          fontSize: 11,
                          letterSpacing: 0.8)),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == 2
                              ? const Color(0xFF338880)
                              : const Color(0xFFCDD5D8),
                        ),
                      ),
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

// ─── Value card ───────────────────────────────────────────────────────────────

class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _ValueCard(
      {required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF338880), size: 24),
          ),
          const Gap(14),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF0A1F2D))),
          const Gap(8),
          Text(body,
              style: const TextStyle(
                  color: Color(0xFF5A6B74), fontSize: 13, height: 1.6)),
        ],
      ),
    );
  }
}

// ─── Tech chip ────────────────────────────────────────────────────────────────

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(80)),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
    );
  }
}
