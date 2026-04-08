import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'doctors/doctors_screen.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isAnnual = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _handleUpgrade() async {
    setState(() => _isLoading = true);
    await _authService.upgradeToPremium();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DoctorsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF338880), Color(0xFF53D1C1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(38),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 38),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Upgrade to Premium',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Unlock doctor consultations and\nadvanced features',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),

            // ── Feature Table ────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: Text('WHAT YOU GET',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9EA7AD), letterSpacing: 0.8)),
                        ),
                        SizedBox(
                          width: 55,
                          child: Text('Free', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Color(0xFF9EA7AD))),
                        ),
                        SizedBox(
                          width: 72,
                          child: Text('Premium', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF338880))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 4),
                    ..._features.map((f) => _FeatureRow(feature: f)),
                    const SizedBox(height: 28),

                    // ── Plan Selector ────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isAnnual = false),
                            child: _PlanCard(
                              label: 'Monthly',
                              price: '₹299',
                              sub: '/mo',
                              isSelected: !_isAnnual,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isAnnual = true),
                            child: _PlanCard(
                              label: 'Annual',
                              price: '₹2,880',
                              sub: '/yr',
                              badge: 'SAVE 20%',
                              recommended: true,
                              isSelected: _isAnnual,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── CTA ────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleUpgrade,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF338880),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: const Color(0xFF338880).withAlpha(76),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                            : Text(
                                'Continue with ${_isAnnual ? "Annual" : "Monthly"}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'Cancel anytime · Secure payment',
                        style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data ────────────────────────────────────────────────────────────────────

class _Feature {
  final IconData icon;
  final String label;
  final bool free;
  final bool premium;
  const _Feature(this.icon, this.label, {required this.free, required this.premium});
}

const _features = [
  _Feature(Icons.monitor_heart_outlined, 'Daily wound tracking', free: true, premium: true),
  _Feature(Icons.analytics_outlined, 'AI analysis & scoring', free: true, premium: true),
  _Feature(Icons.chat_bubble_outline, 'AI chatbot', free: true, premium: true),
  _Feature(Icons.medical_services_outlined, 'Doctor consultations', free: false, premium: true),
  _Feature(Icons.videocam_outlined, 'Video call with doctor', free: false, premium: true),
  _Feature(Icons.calendar_today_outlined, 'Appointment booking', free: false, premium: true),
];

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final _Feature feature;
  const _FeatureRow({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(feature.icon, size: 20, color: const Color(0xFF5A6B74)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(feature.label,
                style: const TextStyle(fontSize: 13, color: Color(0xFF0A1F2D))),
          ),
          SizedBox(
            width: 55,
            child: Center(
              child: feature.free
                  ? const Icon(Icons.check_circle_outline, color: Color(0xFF9EA7AD), size: 20)
                  : const Icon(Icons.close, color: Color(0xFFCDD5D8), size: 18),
            ),
          ),
          SizedBox(
            width: 72,
            child: Center(
              child: feature.premium
                  ? const Icon(Icons.check_circle, color: Color(0xFF338880), size: 20)
                  : const Icon(Icons.close, color: Color(0xFFCDD5D8), size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String label;
  final String price;
  final String sub;
  final String? badge;
  final bool recommended;
  final bool isSelected;

  const _PlanCard({
    required this.label,
    required this.price,
    required this.sub,
    this.badge,
    this.recommended = false,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF0FBFA) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF338880) : const Color(0xFFE0E7E8),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isSelected ? const Color(0xFF338880) : const Color(0xFF5A6B74))),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF0A1F2D))),
                  Text(sub,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF9EA7AD))),
                ],
              ),
              if (recommended) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF338880),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('RECOMMENDED',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: -10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF53D1C1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(badge!,
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}
