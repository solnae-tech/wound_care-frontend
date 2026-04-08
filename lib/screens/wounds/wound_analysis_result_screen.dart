import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../doctors/doctors_screen.dart';
import '../../services/wound_service.dart';

class WoundAnalysisResultScreen extends StatelessWidget {
  final String woundTitle;
  final String causeDesc;
  final String? existingWoundId;

  const WoundAnalysisResultScreen({
    super.key,
    required this.woundTitle,
    required this.causeDesc,
    this.existingWoundId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF338880)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('AI Analysis',
            style: TextStyle(
                color: Color(0xFF0A1F2D),
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF338880)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            // ── Main Score Card ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 16,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?q=80&w=2669&auto=format&fit=crop'), // placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(woundTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A1F2D),
                                  fontSize: 14)),
                          const Text('Today',
                              style: TextStyle(
                                  color: Color(0xFF9EA7AD), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const Gap(32),

                  // Score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('74',
                          style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF338880),
                              height: 1)),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6, left: 2),
                        child: Text('/100',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF5A6B74),
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const Gap(4),
                  const Text('Healing Score',
                      style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 12)),
                  const Gap(20),

                  // Gauge
                  SizedBox(
                    height: 120, // adjusted height
                    width: 200,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Arc background
                        CustomPaint(
                          size: const Size(200, 100),
                          painter: _GaugePainter(score: 74),
                        ),
                        // Badge
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0), // orange tint
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Moderate Healing',
                                style: TextStyle(
                                    color: Color(0xFFE65100),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // ── Grid Cards ───────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _GridBox(
                    label: 'WOUND SIZE',
                    value: '4.2 cm²',
                    subtext: '↘ 8% from last entry',
                    subColor: const Color(0xFF338880),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: _GridBox(
                    label: 'INFECTION RISK',
                    value: 'Moderate',
                    valueColor: const Color(0xFFB9772C),
                    isProgress: true,
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 10,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('COLOR ANALYSIS',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5A6B74),
                                letterSpacing: 0.5)),
                        const Gap(6),
                        const Text('Redness\npresent',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A1F2D),
                                height: 1.2)),
                        const Gap(12),
                        Row(
                          children: [
                            _ColorSwatch(const Color(0xFFE57373)),
                            const Gap(4),
                            _ColorSwatch(const Color(0xFFFFCDD2)),
                            const Gap(4),
                            _ColorSwatch(const Color(0xFFEF9A9A)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: _GridBox(
                    label: 'HEALING RATE',
                    value: 'Steady',
                    valueColor: const Color(0xFF338880),
                    subtext: '↑ On Track',
                    subColor: const Color(0xFF338880),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // ── AI Summary ───────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
                border: const Border(
                  left: BorderSide(color: Color(0xFF338880), width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('AI SUMMARY',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A6B74),
                          letterSpacing: 0.5)),
                  Gap(12),
                  Text(
                    'Redness has slightly increased from your last entry. Some yellowish discharge detected — monitor closely over next 48 hours.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0A1F2D),
                        height: 1.5),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // ── Alert Card ───────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline,
                      color: Color(0xFFD32F2F), size: 20),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Signs of possible infection detected. Consider consulting a doctor.',
                          style: TextStyle(
                              color: Color(0xFF0A1F2D),
                              fontSize: 13,
                              height: 1.4),
                        ),
                        const Gap(8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const DoctorsScreen()),
                            );
                          },
                          child: const Text('View Doctors',
                              style: TextStyle(
                                  color: Color(0xFF338880),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── CTA ───────────────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: ElevatedButton(
            onPressed: () {
              // Save to global list
              if (existingWoundId != null) {
                WoundService().updateWound(existingWoundId!, woundTitle, causeDesc);
                Navigator.of(context)..pop()..pop();
              } else {
                WoundService().addWound(woundTitle, causeDesc);
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF338880),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.save_outlined, size: 20),
                Gap(8),
                Text('Save to Timeline',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _GridBox extends StatelessWidget {
  final String label;
  final String value;
  final String? subtext;
  final Color? valueColor;
  final Color? subColor;
  final bool isProgress;

  const _GridBox({
    required this.label,
    required this.value,
    this.subtext,
    this.valueColor,
    this.subColor,
    this.isProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A6B74),
                  letterSpacing: 0.5)),
          const Gap(10),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? const Color(0xFF0A1F2D))),
          if (subtext != null) ...[
            const Gap(10),
            Text(subtext!,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: subColor ?? const Color(0xFF9EA7AD))),
          ],
          if (isProgress) ...[
            const Gap(12),
            Stack(
              children: [
                Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(2))),
                Container(
                    height: 4,
                    width: 60, // approx moderate progress
                    decoration: BoxDecoration(
                        color: const Color(0xFFB9772C),
                        borderRadius: BorderRadius.circular(2))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  const _ColorSwatch(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ─── Gauge Painter ────────────────────────────────────────────────────────────

class _GaugePainter extends CustomPainter {
  final int score;
  _GaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Background Arc
    final bgPaint = Paint()
      ..color = const Color(0xFFEEF5F5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // start sweeping from 180 deg (left)
      pi, // sweep 180 deg (half circle)
      false,
      bgPaint,
    );

    // No colored arc in the design, just the needle pointing to the score
    // The gauge spans from pi (0 score) to 2*pi (100 score)
    // Angle mapping: score 0 = pi, score 100 = 2*pi
    final angle = pi + (score / 100.0) * pi;

    final tipLength = radius - 15;
    final tailLength = 0.0;

    final tipX = center.dx + tipLength * cos(angle);
    final tipY = center.dy + tipLength * sin(angle);

    final tailX = center.dx + tailLength * cos(angle);
    final tailY = center.dy + tailLength * sin(angle);

    // Draw needle line
    final needlePaint = Paint()
      ..color = const Color(0xFF0A1F2D)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(tailX, tailY), Offset(tipX, tipY), needlePaint);

    // Draw center dot
    final dotPaint = Paint()..color = const Color(0xFF0A1F2D);
    canvas.drawCircle(center, 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
