import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ─── Step Model ───────────────────────────────────────────────────────────────

enum _StepStatus { pending, inProgress, done }

class _AnalysisStep {
  final String label;
  _StepStatus status = _StepStatus.pending;
  _AnalysisStep(this.label);
}

// ─── Screen ───────────────────────────────────────────────────────────────────

/// Shows animated step-by-step progress while the backend analyses the wound.
///
/// Pass [analysisFuture] — the screen stays open until it completes, then
/// calls [onComplete] with the result.
///
/// TODO: Replace [analysisFuture] with your actual API call Future.
class WoundAnalysisLoadingScreen extends StatefulWidget {
  /// The backend API future to await.
  /// When it completes, [onComplete] is called.
  final Future<dynamic> analysisFuture;
  final void Function(dynamic result) onComplete;

  const WoundAnalysisLoadingScreen({
    super.key,
    required this.analysisFuture,
    required this.onComplete,
  });

  @override
  State<WoundAnalysisLoadingScreen> createState() =>
      _WoundAnalysisLoadingScreenState();
}

class _WoundAnalysisLoadingScreenState
    extends State<WoundAnalysisLoadingScreen>
    with TickerProviderStateMixin {

  // Outer pulse rings
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // Inner icon spin
  late AnimationController _spinCtrl;

  // Step timings (millis after screen opens)
  static const _stepDelays = [0, 1200, 4500, 7000];

  final List<_AnalysisStep> _steps = [
    _AnalysisStep('Image uploaded successfully'),
    _AnalysisStep('Running computer vision analysis...'),
    _AnalysisStep('Calculating healing score'),
    _AnalysisStep('Generating insights'),
  ];

  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();

    // Pulse animation
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Spin animation for in-progress icon
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    // Sequence steps
    for (int i = 0; i < _steps.length; i++) {
      final idx = i;
      _timers.add(Timer(Duration(milliseconds: _stepDelays[idx]), () {
        if (!mounted) return;
        setState(() {
          if (idx > 0) _steps[idx - 1].status = _StepStatus.done;
          _steps[idx].status = _StepStatus.inProgress;
        });
      }));
    }

    // Await actual API future
    widget.analysisFuture.then((result) {
      if (!mounted) return;
      // Mark all done
      setState(() {
        for (final s in _steps) {
          s.status = _StepStatus.done;
        }
      });
      // Brief pause so user sees all ticks, then call onComplete
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) widget.onComplete(result);
      });
    }).catchError((e) {
      if (mounted) widget.onComplete(null);
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _spinCtrl.dispose();
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent back during analysis
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FCFC),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Animated icon ──────────────────────────────
                        _PulsingIcon(
                            pulseAnim: _pulseAnim, spinCtrl: _spinCtrl),
                        const Gap(36),

                        // ── Title ──────────────────────────────────────
                        const Text(
                          'Analyzing Your Wound',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A1F2D),
                          ),
                        ),
                        const Gap(12),
                        const Text(
                          'Our AI is examining your image for infection\nindicators, wound size, and healing progress.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5A6B74),
                            height: 1.5,
                          ),
                        ),
                        const Gap(40),

                        // ── Steps ──────────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(7),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              for (int i = 0; i < _steps.length; i++) ...[
                                _StepRow(
                                    step: _steps[i], spinCtrl: _spinCtrl),
                                if (i < _steps.length - 1)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 13),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        height: 16,
                                        child: VerticalDivider(
                                            color: Color(0xFFE0E7E8),
                                            thickness: 1.5,
                                            width: 1),
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                        const Gap(20),

                        // ── ETA notice ─────────────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.schedule_outlined,
                                  size: 15, color: Color(0xFF5A6B74)),
                              Gap(6),
                              Text(
                                'This usually takes 8–12 seconds',
                                style: TextStyle(
                                    color: Color(0xFF5A6B74), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Footer ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.verified_user_outlined,
                        size: 13, color: Color(0xFF9EA7AD)),
                    Gap(6),
                    Text(
                      'SECURE HIPAA COMPLIANT ANALYSIS',
                      style: TextStyle(
                          color: Color(0xFF9EA7AD),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _PulsingIcon extends StatelessWidget {
  final Animation<double> pulseAnim;
  final AnimationController spinCtrl;
  const _PulsingIcon({required this.pulseAnim, required this.spinCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnim,
      builder: (context, child) => SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Transform.scale(
              scale: pulseAnim.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFF53D1C1).withAlpha(60), width: 2),
                ),
              ),
            ),
            // Middle ring
            Transform.scale(
              scale: pulseAnim.value * 0.82,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFF53D1C1).withAlpha(110), width: 2),
                ),
              ),
            ),
            // Inner filled circle with icon
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: Color(0xFF338880),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.health_and_safety_outlined,
                  color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final _AnalysisStep step;
  final AnimationController spinCtrl;
  const _StepRow({required this.step, required this.spinCtrl});

  @override
  Widget build(BuildContext context) {
    Widget leading;
    TextStyle labelStyle;

    switch (step.status) {
      case _StepStatus.done:
        leading = Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
              color: Color(0xFF338880), shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 15),
        );
        labelStyle = const TextStyle(
            color: Color(0xFF0A1F2D),
            fontWeight: FontWeight.bold,
            fontSize: 14);
        break;

      case _StepStatus.inProgress:
        leading = AnimatedBuilder(
          animation: spinCtrl,
          builder: (_, child) => Transform.rotate(
            angle: spinCtrl.value * 6.28,
            child: child,
          ),
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF338880)),
              backgroundColor: const Color(0xFF338880).withAlpha(30),
            ),
          ),
        );
        labelStyle = const TextStyle(
            color: Color(0xFF0A1F2D),
            fontWeight: FontWeight.bold,
            fontSize: 14);
        break;

      case _StepStatus.pending:
        leading = Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFCDD5D8), width: 2),
          ),
        );
        labelStyle = const TextStyle(color: Color(0xFF9EA7AD), fontSize: 14);
        break;
    }

    return Row(
      children: [
        leading,
        const Gap(14),
        Expanded(
          child: Text(step.label, style: labelStyle),
        ),
      ],
    );
  }
}
