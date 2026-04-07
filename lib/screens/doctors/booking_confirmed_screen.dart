import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'doctor_detail_screen.dart';
import 'doctor_report_screen.dart';
import 'video_call_screen.dart';

class BookingConfirmedScreen extends StatelessWidget {
  final DoctorDetailArgs doctor;
  final String slot;
  final DateTime date;
  final int appointmentType; // 0 = Video Call, 1 = In Person
  final String bookingId;

  const BookingConfirmedScreen({
    super.key,
    required this.doctor,
    required this.slot,
    required this.date,
    required this.appointmentType,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    final apptLabel =
        appointmentType == 0 ? 'Video Consultation' : 'In-Person Consultation';
    final dateStr = _formatDate(date);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF338880), size: 20),
          onPressed: () =>
              Navigator.of(context).popUntil((r) => r.isFirst),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [
              // ── Success icon ────────────────────────────────────────────
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF338880),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF338880).withAlpha(70),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child:
                    const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const Gap(20),
              const Text('Booking Confirmed!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1F2D))),
              const Gap(6),
              const Text('Your appointment has been scheduled',
                  style:
                      TextStyle(color: Color(0xFF9EA7AD), fontSize: 13)),
              const Gap(28),

              // ── Details card ────────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(6),
                        blurRadius: 16,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.calendar_today_outlined,
                      iconBg: const Color(0xFFE3F2FD),
                      iconColor: const Color(0xFF1565C0),
                      title: 'DATE & TIME',
                      main: dateStr,
                      sub: slot,
                      subColor: const Color(0xFF338880),
                    ),
                    _Divider(),
                    _DetailRow(
                      imageUrl: doctor.imageUrl,
                      title: doctor.name,
                      main: doctor.name,
                      sub: doctor.specialty,
                      iconBg: const Color(0xFFE0F7F5),
                      iconColor: const Color(0xFF338880),
                    ),
                    _Divider(),
                    _DetailRow(
                      icon: Icons.videocam_outlined,
                      iconBg: const Color(0xFFE8F5F4),
                      iconColor: const Color(0xFF338880),
                      title: apptLabel,
                      main: apptLabel,
                      sub: doctor.hospital,
                    ),
                    _Divider(),
                    _DetailRow(
                      icon: Icons.account_balance_wallet_outlined,
                      iconBg: const Color(0xFFFFF3E0),
                      iconColor: const Color(0xFFF57C00),
                      title: 'Payment',
                      main: 'Payment',
                      sub: '₹${doctor.fee} Paid',
                      subColor: const Color(0xFF338880),
                      subBold: true,
                    ),
                    _Divider(),
                    _DetailRow(
                      icon: Icons.fingerprint,
                      iconBg: const Color(0xFFF3E5F5),
                      iconColor: const Color(0xFF6A1B9A),
                      title: 'Booking ID',
                      main: 'Booking ID',
                      sub: '#$bookingId',
                      subColor: const Color(0xFF338880),
                    ),
                  ],
                ),
              ),
              const Gap(20),

              // ── Info notice ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7F5),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: const Color(0xFF338880).withAlpha(50)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.info_outline,
                        color: Color(0xFF338880), size: 18),
                    Gap(10),
                    Expanded(
                      child: Text(
                        "You'll receive a reminder 10 minutes before your call. "
                        'Join from the app at the scheduled time.',
                        style: TextStyle(
                            color: Color(0xFF338880),
                            fontSize: 12,
                            height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(28),

              // ── Actions ─────────────────────────────────────────────────
              OutlinedButton(
                onPressed: () {
                  // TODO: Fetch doctor report from API
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoctorReportScreen(doctor: doctor),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF338880),
                  side: const BorderSide(
                      color: Color(0xFF338880), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size.fromHeight(52),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                child: const Text('See the Doctor report'),
              ),
              const Gap(12),
              ElevatedButton(
                onPressed: appointmentType == 0
                    ? () {
                        // TODO: Replace with real video call SDK / URL
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                VideoCallScreen(doctor: doctor, slot: slot),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF338880),
                  disabledBackgroundColor: const Color(0xFF9EA7AD),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                child: const Text('Video call'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const weekdays = [
      '', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
      'Saturday', 'Sunday'
    ];
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${weekdays[d.weekday]}, ${months[d.month]} ${d.day}, ${d.year}';
  }
}

// ─── Detail row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData? icon;
  final String? imageUrl;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String main;
  final String sub;
  final Color subColor;
  final bool subBold;

  const _DetailRow({
    this.icon,
    this.imageUrl,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.main,
    required this.sub,
    this.subColor = const Color(0xFF5A6B74),
    this.subBold = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      iconWidget = CircleAvatar(
        radius: 20,
        backgroundColor: iconBg,
        backgroundImage: NetworkImage(imageUrl!),
      );
    } else {
      iconWidget = Container(
        width: 40,
        height: 40,
        decoration:
            BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 20),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          iconWidget,
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // If main == title it's a label+value layout
                if (main == title && icon != null) ...[
                  Text(title,
                      style: const TextStyle(
                          color: Color(0xFF9EA7AD),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4)),
                  const Gap(2),
                  Text(sub,
                      style: TextStyle(
                          fontWeight: subBold
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 14,
                          color: subColor)),
                ] else ...[
                  Text(main,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0A1F2D))),
                  const Gap(2),
                  Text(sub,
                      style: TextStyle(
                          color: subColor,
                          fontSize: 12)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 20, endIndent: 20, thickness: 0.8,
          color: Color(0xFFF0F4F4));
}
