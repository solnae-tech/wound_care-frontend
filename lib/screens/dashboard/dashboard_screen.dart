import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/wound_model.dart';
import '../../services/wound_service.dart';
import '../../services/auth_service.dart';
import 'profile_screen.dart';
import '../premium_screen.dart';
import '../doctors/doctors_screen.dart';
import '../../widgets/chat_fab.dart';
import '../wounds/add_wound_screen.dart';
import '../notifications_screen.dart';
import '../about_us_screen.dart';
import '../landing_screen.dart';
import '../wounds/wound_progress_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final WoundService _woundService = WoundService();
  final AuthService _authService = AuthService();

  void _onProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _addNewWound() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddWoundScreen()),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeWound = _woundService.activeWound;
    final wounds = _woundService.wounds;
    final user = _authService.currentUser;

    return Scaffold(
      floatingActionButton: const ChatFab(),
      drawer: _AppDrawer(
        authService: _authService,
        onLogout: () async {
          await _authService.logout();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LandingScreen()),
              (route) => false,
            );
          }
        },
      ),
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF338880)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'WoundCare',
          style: TextStyle(
            color: Color(0xFF338880),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationsScreen()),
              );
            },
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF5A6B74)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _onProfileTap,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF338880),
                child: user?.fullName != null && user!.fullName.isNotEmpty
                    ? Text(
                        user.fullName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    : const Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${(user?.fullName.isNotEmpty == true) ? user!.fullName.split(' ')[0] : 'User'}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A1F2D),
              ),
            ),
            const Gap(8),
            const Text(
              'Here is your recovery summary for today.',
              style: TextStyle(color: Color(0xFF5A6B74), fontSize: 14),
            ),
            const Gap(24),
            _buildAlertCard(),
            const Gap(24),
            if (activeWound != null) _buildActiveCaseCard(activeWound),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Wounds',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D)),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(color: Color(0xFF338880))),
                ),
              ],
            ),
            const Gap(12),
            ...wounds.map((wound) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildWoundListItem(wound),
            )),
            const Gap(40),
            Center(
              child: SizedBox(
                width: 240,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _addNewWound,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('New Wound', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF338880),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: const Color(0xFF338880).withAlpha(76),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            // Doctors tab — premium gate
            if (_authService.isPremium) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoctorsScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumScreen()),
              );
            }
          } else if (index == 2) {
            _onProfileTap();
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF338880),
        unselectedItemColor: const Color(0xFF9EA7AD),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), activeIcon: Icon(Icons.medical_services), label: 'DOCTORS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }

  Widget _buildAlertCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAEA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD1D1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_rounded, color: Color(0xFFB3261E)),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Increased Redness Detected',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB3261E), fontSize: 15),
                ),
                const Gap(4),
                Text(
                  'Your recent wound shows signs of potential inflammation. Contact your doctor if pain increases.',
                  style: TextStyle(color: const Color(0xFFB3261E).withAlpha(204), fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.close, size: 18, color: Color(0xFFB3261E)),
        ],
      ),
    );
  }

  Widget _buildActiveCaseCard(WoundModel wound) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => WoundProgressScreen(wound: wound)));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ACTIVE CASE', style: TextStyle(color: Color(0xFF9EA7AD), fontWeight: FontWeight.bold, fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEEF7FF), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  wound.status.name.toUpperCase(),
                  style: const TextStyle(color: Color(0xFF338880), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(
            wound.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D)),
          ),
          Text('Last scan: ${wound.timeAgo}', style: const TextStyle(color: Color(0xFF5A6B74))),
          const Gap(24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('${wound.healingPercentage}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF338880))),
              const Text('/100', style: TextStyle(fontSize: 18, color: Color(0xFF9EA7AD))),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    wound.healingPercentage == 100 ? 'Healed' : 'Healing',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D)),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: 140,
                    child: LinearProgressIndicator(
                      value: wound.healingPercentage / 100,
                      backgroundColor: const Color(0xFFE0E7E8),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF338880)),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildWoundListItem(WoundModel wound) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => WoundProgressScreen(wound: wound)));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(wound.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wound.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
                const Gap(4),
                Text(
                  'Updated ${wound.timeAgo} • ${wound.healingPercentage}% Healed',
                  style: const TextStyle(color: Color(0xFF5A6B74), fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9EA7AD)),
        ],
      ),
      ),
    );
  }
}

// ─── App Drawer ───────────────────────────────────────────────────────────────

class _AppDrawer extends StatelessWidget {
  final AuthService authService;
  final Future<void> Function() onLogout;

  const _AppDrawer({required this.authService, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;
    final name = (user?.fullName.isNotEmpty == true) ? user!.fullName : 'User';
    final email = user?.email ?? '';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF338880),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withAlpha(40),
                    child: Text(
                      name.substring(0, name.length.clamp(0, 2)).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  const Gap(12),
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  if (email.isNotEmpty)
                    Text(email,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  if (authService.isPremium)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(220),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('⭐ PREMIUM',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                ],
              ),
            ),

            // ── Menu items ───────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationsScreen()));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Go Premium',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PremiumScreen()));
                    },
                  ),
                  const Divider(height: 24, indent: 20, endIndent: 20),
                  _DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AboutUsScreen()));
                    },
                  ),
                ],
              ),
            ),

            // ── Logout ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                tileColor: const Color(0xFFFFEAEA),
                leading: const Icon(Icons.logout_rounded,
                    color: Color(0xFFB3261E)),
                title: const Text('Logout',
                    style: TextStyle(
                        color: Color(0xFFB3261E),
                        fontWeight: FontWeight.bold)),
                onTap: () async {
                  Navigator.pop(context); // close drawer
                  await onLogout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Icon(icon, color: const Color(0xFF338880)),
      title: Text(label,
          style: const TextStyle(
              color: Color(0xFF0A1F2D),
              fontWeight: FontWeight.w600,
              fontSize: 14)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
