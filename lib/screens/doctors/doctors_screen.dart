import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/chat_fab.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All Doctors', 'Dermatology', 'Vascular'];

  final List<_Doctor> _doctors = const [
    _Doctor(
      name: 'Dr. Ramesh Kumar',
      specialty: 'Lead Wound Specialist',
      rating: 4.9,
      nextSlot: 'Next: 10:30 AM',
      isOnline: true,
      imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      filterIndex: 0,
    ),
    _Doctor(
      name: 'Dr. Sarah Chen',
      specialty: 'Dermatologist',
      rating: 4.7,
      nextSlot: 'Next: 02:15 PM',
      isOnline: true,
      imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      filterIndex: 1,
    ),
    _Doctor(
      name: 'Dr. Marcus Thorne',
      specialty: 'Vascular Specialist',
      rating: 5.0,
      nextSlot: 'Next: Tomorrow',
      isOnline: true,
      imageUrl: 'https://randomuser.me/api/portraits/men/65.jpg',
      filterIndex: 2,
    ),
  ];

  List<_Doctor> get _filtered =>
      _selectedFilter == 0 ? _doctors : _doctors.where((d) => d.filterIndex == _selectedFilter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ChatFab(),
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF338880), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Doctors',
          style: TextStyle(color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF5A6B74)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Premium Banner ──────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF338880), Color(0xFF53D1C1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(38),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 22),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('PREMIUM MEMBER',
                          style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                      Gap(2),
                      Text('Priority Care Active',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF338880),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  child: const Text('View\nBenefits',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // ── Search Bar ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0E7E8)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Color(0xFF9EA7AD), size: 20),
                        Gap(10),
                        Text('Search by name or specialty...',
                            style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const Gap(10),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE0E7E8)),
                  ),
                  child: const Icon(Icons.tune_rounded, color: Color(0xFF338880), size: 20),
                ),
              ],
            ),
          ),

          // ── Filter Chips ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: List.generate(_filters.length, (i) {
                final selected = _selectedFilter == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF338880) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? const Color(0xFF338880) : const Color(0xFFE0E7E8),
                        ),
                      ),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : const Color(0xFF5A6B74),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // ── Title ───────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text('Available Specialists',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
          ),

          // ── Doctor List ─────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (_, i) => _DoctorCard(doctor: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data ────────────────────────────────────────────────────────────────────

class _Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String nextSlot;
  final bool isOnline;
  final String imageUrl;
  final int filterIndex;
  const _Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.nextSlot,
    required this.isOnline,
    required this.imageUrl,
    required this.filterIndex,
  });
}

// ─── Doctor Card Widget ───────────────────────────────────────────────────────

class _DoctorCard extends StatelessWidget {
  final _Doctor doctor;
  const _DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with rating badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  doctor.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: const Color(0xFFE0F7F5),
                    child: const Icon(Icons.person, color: Color(0xFF338880), size: 36),
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF338880),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 11),
                        const SizedBox(width: 2),
                        Text(
                          doctor.rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(doctor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D), fontSize: 15)),
                    ),
                    const Icon(Icons.favorite_border, size: 20, color: Color(0xFF9EA7AD)),
                  ],
                ),
                const Gap(2),
                Text(doctor.specialty,
                    style: const TextStyle(color: Color(0xFF338880), fontSize: 12, fontWeight: FontWeight.w600)),
                const Gap(6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 13, color: Color(0xFF9EA7AD)),
                    const SizedBox(width: 4),
                    Text(doctor.nextSlot, style: const TextStyle(color: Color(0xFF9EA7AD), fontSize: 12)),
                    const Spacer(),
                    if (doctor.isOnline)
                      Row(
                        children: [
                          Container(
                            width: 7, height: 7,
                            decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                          const Text('Online', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                  ],
                ),
                const Gap(10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF338880),
                          side: const BorderSide(color: Color(0xFF338880)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Details'),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF338880),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 0,
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Book'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
