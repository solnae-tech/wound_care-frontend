import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/wound_model.dart';
import '../chat/chat_screen.dart';
import 'add_wound_screen.dart';
import 'wound_comparison_screen.dart';
import '../../services/wound_service.dart';

class WoundProgressScreen extends StatefulWidget {
  final WoundModel wound;
  
  const WoundProgressScreen({super.key, required this.wound});

  @override
  State<WoundProgressScreen> createState() => _WoundProgressScreenState();
}

class _WoundProgressScreenState extends State<WoundProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final currentWound = WoundService().wounds.firstWhere((w) => w.id == widget.wound.id, orElse: () => widget.wound);

    final timelineData = currentWound.logs.asMap().entries.map((e) {
      final log = e.value;
      final diff = DateTime.now().difference(log.date).inDays;
      return _TimelineEntry(
         day: currentWound.logs.length - e.key, // inverse indexing since 0 is newest
         dateInfo: diff == 0 ? 'Today' : (diff == 1 ? 'Yesterday' : '$diff days ago'),
         score: log.score,
         image: log.imageUrl,
         note: log.note,
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF338880)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Progress: ${currentWound.title}',
            style: const TextStyle(
                color: Color(0xFF338880),
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF5A6B74)),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(initialWoundId: currentWound.id)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF5A6B74)),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Chart Card ──────────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('HEALING SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A6B74), letterSpacing: 0.5)),
                            Container(
                              decoration: BoxDecoration(color: const Color(0xFFF0F4F4), borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  _TabBtn('7D', active: true),
                                  _TabBtn('14D', active: false),
                                  _TabBtn('30D', active: false),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(30),
                        
                        // Fake Chart Area
                        SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: _ChartPainter(targetScore: currentWound.healingPercentage),
                          ),
                        ),
                        const Gap(24),
                        
                        // Badges
                        Row(
                          children: [
                            _StatusBadge(label: 'Improving', color: const Color(0xFF338880), filled: true),
                            const Gap(8),
                            _StatusBadge(label: 'Moderate', color: const Color(0xFFB9772C), filled: false),
                            const Gap(8),
                            _StatusBadge(label: 'Critical', color: const Color(0xFFD32F2F), filled: false),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  const Text('ENTRY TIMELINE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A6B74), letterSpacing: 0.5)),
                  const Gap(16),
                ],
              ),
            ),
          ),
          
          // ── Timeline List ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final entry = timelineData[index];
                  final isLast = index == timelineData.length - 1;
                  return InkWell(
                    onTap: () {
                      final baseLog = currentWound.logs.last;
                      final targetLog = currentWound.logs[index];
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => WoundComparisonScreen(
                          wound: currentWound,
                          baseLog: baseLog,
                          baseDay: 1, // baseline is Day 1
                          targetLog: targetLog,
                          targetDay: entry.day,
                        ),
                      ));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _TimelineRow(entry: entry, isLast: isLast),
                    ),
                  );
                },
                childCount: timelineData.length,
              ),
            ),
          ),
          
          // Load more
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('Load more', style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFF0A1F2D).withAlpha(180))),
              ),
            ),
          ),
          
          // Bottom padding for FAB space
          const SliverToBoxAdapter(child: Gap(80)),
        ],
      ),
      
      // ── FAB ────────────────────────────────────────────────────────────
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton.icon(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => AddWoundScreen(existingWound: currentWound)));
            if (mounted) setState(() {});
          },
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Today\'s Log Wound', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF338880),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            shadowColor: const Color(0xFF338880).withAlpha(100),
          ),
        ),
      ),
    );
  }
}

class _TimelineEntry {
  final int day;
  final String? dateInfo;
  final int score;
  final String? image;
  final String note;
  _TimelineEntry({required this.day, this.dateInfo, required this.score, this.image, required this.note});
}

class _TimelineRow extends StatelessWidget {
  final _TimelineEntry entry;
  final bool isLast;
  
  const _TimelineRow({required this.entry, required this.isLast});

  Color _getScoreColor(int score) {
    if (score >= 70) return const Color(0xFF338880);
    if (score >= 40) return const Color(0xFFEE9A4D);
    return const Color(0xFFD32F2F);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(entry.score);
    final bool isDull = entry.score <= 35 && entry.image == null; // dimming the older one out similar to design
    final cLine = isDull ? const Color(0xFFE0E7E8) : color;
    final txtColor = isDull ? const Color(0xFF9EA7AD) : const Color(0xFF0A1F2D);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline graphics
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: cLine, shape: BoxShape.circle),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: const Color(0xFFE0E7E8)),
                  ),
              ],
            ),
          ),
          const Gap(12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Day ${entry.day}${entry.dateInfo != null ? ' — ${entry.dateInfo}' : ''}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: txtColor, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                        child: Text('Score: ${entry.score}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  if (entry.image != null) ...[
                    const Gap(12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(entry.image!, width: 80, height: 80, fit: BoxFit.cover),
                    ),
                  ],
                  const Gap(12),
                  Text(entry.note, style: const TextStyle(color: Color(0xFF5A6B74), fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool active;
  const _TabBtn(this.label, {required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: active ? BoxDecoration(color: const Color(0xFF338880), borderRadius: BorderRadius.circular(20)) : null,
      child: Text(label, style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: active ? Colors.white : const Color(0xFF5A6B74),
      )),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  const _StatusBadge({required this.label, required this.color, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? color : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(
        color: filled ? Colors.white : color,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      )),
    );
  }
}

// Simple chart painter mock
class _ChartPainter extends CustomPainter {
  final int targetScore;
  _ChartPainter({required this.targetScore});

  @override
  void paint(Canvas canvas, Size size) {
    // grid lines
    final pLine = Paint()..color = const Color(0xFFEEF5F5)..style = PaintingStyle.stroke..strokeWidth = 1;
    final dashY1 = size.height * 0.2;
    final dashY2 = size.height * 0.8;
    canvas.drawLine(Offset(0, dashY1), Offset(size.width, dashY1), pLine);
    canvas.drawLine(Offset(0, dashY2), Offset(size.width, dashY2), pLine);
    
    // Draw line
    final path = Path();
    path.moveTo(0, size.height * 0.85); // day 1
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.75, size.width * 0.5, size.height * 0.5); // mid
    path.lineTo(size.width, size.height * 0.15); // end

    final linePaint = Paint()
      ..color = const Color(0xFF338880)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
      
    canvas.drawPath(path, linePaint);
    
    // Fill under line
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [const Color(0xFF338880).withAlpha(50), Colors.white.withAlpha(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
    canvas.drawPath(fillPath, fillPaint);
    
    // End dot
    final dotPaint = Paint()..color = const Color(0xFF338880);
    final dotPaintLight = Paint()..color = const Color(0xFF338880).withAlpha(50);
    canvas.drawCircle(Offset(size.width, size.height * 0.15), 8, dotPaintLight);
    canvas.drawCircle(Offset(size.width, size.height * 0.15), 4, dotPaint);

    // Labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final days = ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7'];
    final step = size.width / (days.length - 1);
    
    for (int i = 0; i < days.length; i++) {
        textPainter.text = TextSpan(text: days[i], style: const TextStyle(color: Color(0xFF9EA7AD), fontSize: 9));
        textPainter.layout();
        textPainter.paint(canvas, Offset(i * step - textPainter.width / 2, size.height + 10));
    }

    // Score label on the very end dot
    final scorePaint = Paint()..color = const Color(0xFF338880)..style = PaintingStyle.fill;
    final rRect = RRect.fromRectAndRadius(Rect.fromLTWH(size.width - 16, 0, 24, 16), const Radius.circular(8));
    canvas.drawRRect(rRect, scorePaint);
    
    textPainter.text = TextSpan(text: '$targetScore', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 16 + (24 - textPainter.width)/2, (16 - textPainter.height)/2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
