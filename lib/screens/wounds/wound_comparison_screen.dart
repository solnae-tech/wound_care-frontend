import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/wound_model.dart';

class WoundComparisonScreen extends StatefulWidget {
  final WoundModel wound;
  final WoundLog baseLog;
  final int baseDay;
  final WoundLog targetLog;
  final int targetDay;

  const WoundComparisonScreen({
    super.key,
    required this.wound,
    required this.baseLog,
    required this.baseDay,
    required this.targetLog,
    required this.targetDay,
  });

  @override
  State<WoundComparisonScreen> createState() => _WoundComparisonScreenState();
}

class _WoundComparisonScreenState extends State<WoundComparisonScreen> {
  // Date formatting helper
  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    // Generate derived stats
    final scoreDelta = widget.targetLog.score - widget.baseLog.score;
    final scoreStr = scoreDelta >= 0 ? '+$scoreDelta' : '$scoreDelta';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF338880)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Before vs After',
            style: TextStyle(
                color: Color(0xFF338880),
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF5A6B74)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Top Date Switcher Bar ──────────────────────────────────────────
            Row(
              children: [
                Expanded(child: _DateCard(day: widget.baseDay, dateStr: _formatDate(widget.baseLog.date))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.compare_arrows_rounded, color: Color(0xFF338880), size: 20),
                  ),
                ),
                Expanded(child: _DateCard(day: widget.targetDay, dateStr: _formatDate(widget.targetLog.date))),
              ],
            ),
            const Gap(24),

            // ── Split Image Slider ───────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SplitImageSlider(
                  baseImage: widget.baseLog.imageUrl ?? widget.targetLog.imageUrl ?? '',
                  baseBadge: 'DAY ${widget.baseDay}',
                  baseScore: widget.baseLog.score,
                  targetImage: widget.targetLog.imageUrl ?? widget.baseLog.imageUrl ?? '',
                  targetBadge: 'DAY ${widget.targetDay}',
                  targetScore: widget.targetLog.score,
                ),
              ),
            ),
            const Gap(24),

            // ── Stats Row ───────────────────────────────────────────────────
            Row(
              children: [
                Expanded(child: _StatBox('SIZE', '↓ 28%', const Color(0xFF338880))),
                const Gap(12),
                Expanded(child: _StatBox('SCORE', '↑ $scoreStr', const Color(0xFF338880))),
                const Gap(12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F8FB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A6B74))),
                        const Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.shield_outlined, color: Color(0xFF338880), size: 14),
                            Gap(4),
                            Text('Safe', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF338880))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap(24),

            // ── AI Insight Box ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0E7E8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Color(0xFF338880), size: 20),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AI CLINICAL INSIGHT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF338880), letterSpacing: 0.5)),
                        const Gap(8),
                        Text(
                          'Wound has improved significantly over the timeframe. Size reduced by roughly 28%. Redness thoroughly decreased. Continue current dressing routine.',
                          style: TextStyle(fontSize: 13, color: const Color(0xFF0A1F2D).withAlpha(200), height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _DateCard extends StatelessWidget {
  final int day;
  final String dateStr;
  const _DateCard({required this.day, required this.dateStr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E7E8)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF338880)),
              const Gap(6),
              Text('DAY $day', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF5A6B74))),
            ],
          ),
          const Gap(6),
          Text(dateStr, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valColor;
  const _StatBox(this.label, this.value, this.valColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A6B74))),
          const Gap(8),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: valColor)),
        ],
      ),
    );
  }
}

// ─── Split Image Slider ────────────────────────────────────────────────────────

class SplitImageSlider extends StatefulWidget {
  final String baseImage;
  final String targetImage;
  final String baseBadge;
  final String targetBadge;
  final int baseScore;
  final int targetScore;

  const SplitImageSlider({
    super.key,
    required this.baseImage,
    required this.targetImage,
    required this.baseBadge,
    required this.targetBadge,
    required this.baseScore,
    required this.targetScore,
  });

  @override
  State<SplitImageSlider> createState() => _SplitImageSliderState();
}

class _SplitImageSliderState extends State<SplitImageSlider> {
  double _fraction = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _fraction += details.delta.dx / width;
              _fraction = _fraction.clamp(0.0, 1.0);
            });
          },
          child: Stack(
            children: [
              // Underneath: TARGET IMAGE (Right image)
              SizedBox(
                width: width,
                height: height,
                child: _buildImagery(widget.targetImage, widget.targetBadge, widget.targetScore, isLeft: false),
              ),

              // On top: BASE IMAGE (Left image) masked
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: _fraction,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: _buildImagery(widget.baseImage, widget.baseBadge, widget.baseScore, isLeft: true),
                  ),
                ),
              ),

              // Slider Handle Line
              Positioned(
                left: width * _fraction - 2,
                top: 0,
                bottom: 0,
                child: Container(width: 4, color: Colors.white),
              ),

              // Slider Handle Bullet
              Positioned(
                left: width * _fraction - 14,
                top: height / 2 - 14,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: const Icon(Icons.unfold_more, size: 16, color: Color(0xFF338880)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagery(String imgUrl, String badge, int score, {required bool isLeft}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(imgUrl, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFFCDD5D8),
            child: const Icon(Icons.broken_image, color: Colors.white, size: 40),
          ),
        ),
        // Dark gradient at bottom to read score
        Positioned(
          bottom: 0, left: 0, right: 0,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withAlpha(120), Colors.transparent],
              ),
            ),
          ),
        ),
        // Badge text (top corner)
        Positioned(
          top: 16,
          left: isLeft ? 16 : null,
          right: isLeft ? null : 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1F2D).withAlpha(150),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
        // Score pill (bottom corner)
        Positioned(
          bottom: 16,
          left: isLeft ? 16 : null,
          right: isLeft ? null : 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isLeft ? const Color(0xFFFFF0F0) : const Color(0xFF00695C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Score: $score', style: TextStyle(
              color: isLeft ? const Color(0xFFB3261E) : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            )),
          ),
        ),
      ],
    );
  }
}
