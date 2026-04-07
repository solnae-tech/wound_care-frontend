import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'booking_confirmed_screen.dart';

// ─── Model passed from DoctorsScreen ─────────────────────────────────────────

class DoctorDetailArgs {
  final String name;
  final String specialty;
  final String degree;
  final String hospital;
  final double rating;
  final int reviews;
  final String imageUrl;
  final int experience;
  final int cases;
  final int positive;
  final int fee;

  const DoctorDetailArgs({
    required this.name,
    required this.specialty,
    required this.degree,
    required this.hospital,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.experience,
    required this.cases,
    required this.positive,
    required this.fee,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class DoctorDetailScreen extends StatefulWidget {
  final DoctorDetailArgs doctor;
  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  // Appointment type: 0 = Video Call, 1 = In Person
  int _appointmentType = 0;

  // Date selection — starts from today
  late DateTime _baseDate;
  int _selectedDay = 0; // index into 7-day range

  // Time slot
  String? _selectedSlot;

  // TODO: Replace with API-fetched slots for the selected date/doctor
  static const _allSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM',
    '10:30 AM', '11:00 AM', '11:30 AM',
  ];
  // Simulate one busy slot
  static const _busySlots = {'10:30 AM'};

  @override
  void initState() {
    super.initState();
    _baseDate = DateTime.now();
  }

  DateTime get _selectedDate => _baseDate.add(Duration(days: _selectedDay));

  String _weekday(int offset) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final d = _baseDate.add(Duration(days: offset));
    return days[d.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;

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
        title: const Text('Book Appointment',
            style: TextStyle(
                color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor Profile Card ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(7),
                      blurRadius: 16,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: const Color(0xFFE0F7F5),
                        backgroundImage: doc.imageUrl.isNotEmpty
                            ? NetworkImage(doc.imageUrl)
                            : null,
                        child: doc.imageUrl.isEmpty
                            ? const Icon(Icons.person,
                                color: Color(0xFF338880), size: 42)
                            : null,
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Text(doc.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF0A1F2D))),
                  const Gap(2),
                  Text('${doc.specialty} · ${doc.degree}',
                      style: const TextStyle(
                          color: Color(0xFF5A6B74), fontSize: 13)),
                  const Gap(2),
                  Text(doc.hospital,
                      style: const TextStyle(
                          color: Color(0xFF9EA7AD), fontSize: 12)),
                  const Gap(10),
                  // Stars + rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(5, (i) {
                        if (i < doc.rating.floor()) {
                          return const Icon(Icons.star,
                              color: Colors.amber, size: 16);
                        } else if (i < doc.rating) {
                          return const Icon(Icons.star_half,
                              color: Colors.amber, size: 16);
                        }
                        return const Icon(Icons.star_border,
                            color: Colors.amber, size: 16);
                      }),
                      const Gap(6),
                      Text('${doc.rating}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF338880))),
                      Text(' (${doc.reviews} reviews)',
                          style: const TextStyle(
                              color: Color(0xFF9EA7AD), fontSize: 12)),
                    ],
                  ),
                  const Gap(16),
                  // Stats row
                  Row(
                    children: [
                      _StatBox(value: '${doc.experience} yrs', label: 'EXPERIENCE'),
                      _StatBox(value: '${doc.cases}', label: 'CASES'),
                      _StatBox(value: '${doc.positive}%', label: 'POSITIVE'),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(24),

            // ── Appointment Type ─────────────────────────────────────────
            const Text('Select Appointment Type',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0A1F2D))),
            const Gap(12),
            Row(
              children: [
                _TypeCard(
                  icon: Icons.videocam_outlined,
                  label: 'Video Call',
                  selected: _appointmentType == 0,
                  onTap: () => setState(() => _appointmentType = 0),
                ),
                const Gap(12),
                _TypeCard(
                  icon: Icons.location_on_outlined,
                  label: 'In Person',
                  selected: _appointmentType == 1,
                  onTap: () => setState(() => _appointmentType = 1),
                ),
              ],
            ),
            const Gap(24),

            // ── Date Selector ────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Date',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0A1F2D))),
                Text(
                  '${_monthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: const TextStyle(
                      color: Color(0xFF338880),
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),
            const Gap(12),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (_, i) {
                  final date = _baseDate.add(Duration(days: i));
                  final sel = _selectedDay == i;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedDay = i;
                      _selectedSlot = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 52,
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFF338880)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: sel
                                ? const Color(0xFF338880)
                                : const Color(0xFFE0E7E8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_weekday(i),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: sel
                                      ? Colors.white70
                                      : const Color(0xFF9EA7AD),
                                  fontWeight: FontWeight.w600)),
                          const Gap(4),
                          Text('${date.day}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: sel
                                      ? Colors.white
                                      : const Color(0xFF0A1F2D))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(24),

            // ── Time Slots ───────────────────────────────────────────────
            const Text('Available Slots',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0A1F2D))),
            const Gap(12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.6,
              ),
              itemCount: _allSlots.length,
              itemBuilder: (_, i) {
                final slot = _allSlots[i];
                final busy = _busySlots.contains(slot);
                final sel = _selectedSlot == slot;
                return GestureDetector(
                  onTap: busy ? null : () => setState(() => _selectedSlot = slot),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: busy
                          ? const Color(0xFFF8FCFC)
                          : sel
                              ? const Color(0xFF338880)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: busy
                              ? const Color(0xFFE0E7E8)
                              : sel
                                  ? const Color(0xFF338880)
                                  : const Color(0xFFE0E7E8)),
                    ),
                    child: Center(
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: busy
                              ? const Color(0xFFCDD5D8)
                              : sel
                                  ? Colors.white
                                  : const Color(0xFF0A1F2D),
                          decoration: busy
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const Gap(24),

            // ── Fee ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 10,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Consultation fee',
                      style: TextStyle(
                          color: Color(0xFF5A6B74),
                          fontWeight: FontWeight.w500)),
                  Text('₹${doc.fee}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0A1F2D))),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── Confirm Booking CTA ────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: ElevatedButton(
            onPressed: _selectedSlot == null
                ? null
                : () {
                    // TODO: POST booking to API endpoint
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingConfirmedScreen(
                          doctor: doc,
                          slot: _selectedSlot!,
                          date: _selectedDate,
                          appointmentType: _appointmentType,
                          bookingId: 'WC20260401-0923',
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF338880),
              disabledBackgroundColor: const Color(0xFFCDD5D8),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Confirm Booking',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Gap(6),
                Icon(Icons.chevron_right, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int m) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[m];
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0A1F2D))),
            const Gap(2),
            Text(label,
                style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF9EA7AD),
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TypeCard(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFF338880)
                  : const Color(0xFFE0E7E8),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected
                      ? const Color(0xFF338880)
                      : const Color(0xFF9EA7AD),
                  size: 28),
              const Gap(6),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? const Color(0xFF338880)
                          : const Color(0xFF5A6B74))),
            ],
          ),
        ),
      ),
    );
  }
}
