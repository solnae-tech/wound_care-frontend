import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Color(0xFF338880)),
        title: const Text(
          'WoundCare',
          style: TextStyle(
            color: Color(0xFF338880),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF5A6B74)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _onProfileTap,
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=karthik'),
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
            _buildAlertCard(),
            const Gap(24),
            _buildActiveCaseCard(),
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
            _buildWoundListItem(
              'Left Knee Abrasion',
              'Updated 2h ago • 74% Healed',
              'https://picsum.photos/100?random=1',
            ),
            const Gap(12),
            _buildWoundListItem(
              'Right Forearm Cut',
              'Closed 12 days ago • 100% Healed',
              'https://picsum.photos/100?random=2',
            ),
            const Gap(40),
            Center(
              child: SizedBox(
                width: 240,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
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
          if (index == 3) {
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
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'CHAT'),
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
                  'Left Knee Abrasion shows signs of potential inflammation. Contact your doctor if pain increases.',
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

  Widget _buildActiveCaseCard() {
    return Container(
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
                child: const Text('HEALING', style: TextStyle(color: Color(0xFF338880), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Gap(12),
          const Text(
            'Left Knee Abrasion',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D)),
          ),
          const Text('Last scan: 2 hours ago', style: TextStyle(color: Color(0xFF5A6B74))),
          const Gap(24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text('74', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF338880))),
              const Text('/100', style: TextStyle(fontSize: 18, color: Color(0xFF9EA7AD))),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Moderate Healing', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
                  const Gap(8),
                  SizedBox(
                    width: 140,
                    child: LinearProgressIndicator(
                      value: 0.74,
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
    );
  }

  Widget _buildWoundListItem(String title, String subtitle, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
                const Gap(4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF5A6B74), fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9EA7AD)),
        ],
      ),
    );
  }
}
