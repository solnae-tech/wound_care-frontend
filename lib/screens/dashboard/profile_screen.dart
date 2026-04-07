import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/wound_service.dart';
import '../auth/login_screen.dart';
import '../../widgets/chat_fab.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final woundService = WoundService();
    final activeWound = woundService.activeWound;

    return Scaffold(
      floatingActionButton: const ChatFab(),
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF338880)),
        title: const Text(
          'Profile',
          style: TextStyle(color: Color(0xFF338880), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(user),
            const Gap(24),
            _buildStatsRow(
              wounds: woundService.wounds.length.toString(),
              days: user != null ? (DateTime.now().difference(user.createdAt).inDays + 1).toString() : '1',
              score: activeWound?.healingPercentage.toString() ?? '0',
            ),
            const Gap(24),
            if (user?.medicalStats != null) ...[
              _buildMedicalProfileSection(user!.medicalStats!),
              const Gap(16),
            ],
            _buildMenuSection('ACCOUNT', [
              _MenuItem(Icons.person_outline, 'Personal Details'),
              _MenuItem(Icons.lock_outline, 'Change Password'),
              _MenuItem(Icons.notifications_none, 'Notifications'),
            ]),
            const Gap(16),
            _buildMenuSection('HEALTH', [
              _MenuItem(Icons.healing_outlined, 'My Wounds'),
              _MenuItem(Icons.calendar_today_outlined, 'Appointments'),
              _MenuItem(Icons.history, 'Medical History'),
            ]),
            const Gap(16),
            _buildMenuSection('PREMIUM', [
              _MenuItem(Icons.workspace_premium_outlined, 'Premium Plan', trailing: _buildActiveTag()),
              _MenuItem(Icons.account_balance_wallet_outlined, 'Billing & Payments'),
            ]),
            const Gap(16),
            _buildMenuSection('SUPPORT', [
              _MenuItem(Icons.help_outline, 'Help & FAQ'),
              _MenuItem(Icons.star_outline, 'Rate the App'),
              _MenuItem(Icons.info_outline, 'About WoundCare'),
            ]),
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () async {
                  await AuthService().logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    String memberSince = 'March 2026';
    if (user != null) {
      memberSince = DateFormat('MMMM yyyy').format(user.createdAt);
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF338880),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    user?.fullName != null && user!.fullName.isNotEmpty
                        ? user.fullName!.substring(0, user.fullName!.length.clamp(0, 2)).toUpperCase()
                        : 'WC',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFF53D1C1), shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            user?.fullName ?? 'Karthik Raj',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D)),
          ),
          const Gap(4),
          Text(
            user?.phoneNumber ?? '+91 98765 43210',
            style: const TextStyle(color: Color(0xFF5A6B74)),
          ),
          Text(
            'Member since $memberSince',
            style: const TextStyle(color: Color(0xFF9EA7AD), fontSize: 12),
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEAEA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium, color: Color(0xFFB3261E), size: 16),
                Gap(8),
                Text('Premium Member', style: TextStyle(color: Color(0xFFB3261E), fontWeight: FontWeight.bold)),
                Gap(8),
                CircleAvatar(radius: 3, backgroundColor: Color(0xFF338880)),
                Gap(8),
                Text('ACTIVE', style: TextStyle(color: Color(0xFF338880), fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow({required String wounds, required String days, required String score}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatItem('WOUNDS', wounds, 'Tracked'),
          const Gap(12),
          _buildStatItem('DAYS', days, 'Logged'),
          const Gap(12),
          _buildStatItem('SCORE', score, 'Current'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String sublabel) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF7FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF5A6B74), fontWeight: FontWeight.bold)),
            const Gap(4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
            Text(sublabel, style: const TextStyle(fontSize: 10, color: Color(0xFF9EA7AD))),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalProfileSection(dynamic stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text('MEDICAL PROFILE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9EA7AD))),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildMedicalStatTile('Blood Type', stats.bloodType, Icons.bloodtype, Colors.red),
              const Divider(height: 24, thickness: 0.5),
              _buildMedicalStatTile('Blood Pressure', stats.bloodPressure, Icons.speed, Colors.orange),
              const Divider(height: 24, thickness: 0.5),
              _buildMedicalStatTile('Weight', stats.weight, Icons.monitor_weight, Colors.blue),
              const Divider(height: 24, thickness: 0.5),
              _buildMedicalStatTile('Height', stats.height, Icons.height, Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalStatTile(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 20),
        ),
        const Gap(16),
        Text(label, style: const TextStyle(color: Color(0xFF5A6B74))),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9EA7AD))),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items.map((item) => _buildMenuItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return ListTile(
      leading: Icon(item.icon, color: const Color(0xFF5A6B74)),
      title: Text(item.title, style: const TextStyle(color: Color(0xFF0A1F2D))),
      trailing: item.trailing ?? const Icon(Icons.chevron_right, color: Color(0xFF9EA7AD)),
      onTap: () {},
    );
  }

  Widget _buildActiveTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFEEF7FF), borderRadius: BorderRadius.circular(20)),
      child: const Text('ACTIVE', style: TextStyle(color: Color(0xFF338880), fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  _MenuItem(this.icon, this.title, {this.trailing});
}
