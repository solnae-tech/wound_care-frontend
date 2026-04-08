import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

enum _NotifType { alert, recommendation, appointment, analysis, upload, premium }

class _Notification {
  final _NotifType type;
  final String title;
  final String body;
  final String timeLabel;
  final bool isUnread;
  const _Notification({
    required this.type,
    required this.title,
    required this.body,
    required this.timeLabel,
    this.isUnread = false,
  });
}

// ─── Static mock data ─────────────────────────────────────────────────────────
// TODO: Remove static data and replace with API fetch when endpoint is ready.
// Endpoint should return paginated notifications for the authenticated user.

const _todayNotifs = <_Notification>[
  _Notification(
    type: _NotifType.alert,
    title: 'Wound Alert',
    body: 'Redness increased on Left Knee. Consider consulting a doctor.',
    timeLabel: '2 hours ago',
    isUnread: true,
  ),
  _Notification(
    type: _NotifType.recommendation,
    title: 'Recommendation Received',
    body: 'Dr. Ramesh has sent new treatment instructions.',
    timeLabel: '5 hours ago',
    isUnread: true,
  ),
  _Notification(
    type: _NotifType.appointment,
    title: 'Appointment Reminder',
    body: 'Your call with Dr. Ramesh is in 10 minutes.',
    timeLabel: 'Yesterday, 10:20 AM',
  ),
  _Notification(
    type: _NotifType.analysis,
    title: 'Analysis Complete',
    body: 'Your wound score improved to 74. View your results.',
    timeLabel: 'Yesterday, 8:45 AM',
  ),
];

const _earlierNotifs = <_Notification>[
  _Notification(
    type: _NotifType.upload,
    title: 'Upload Reminder',
    body: "Don't forget to log today's wound photo.",
    timeLabel: 'Mar 30',
  ),
  _Notification(
    type: _NotifType.premium,
    title: 'Premium Activated',
    body: 'Welcome to Premium! Doctor access is now enabled.',
    timeLabel: 'Mar 28',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTab = 0;
  final _tabs = const ['All', 'Alerts', 'Appointments', 'Messages'];

  List<_Notification> _filtered(List<_Notification> source) {
    if (_selectedTab == 0) return source;
    return source.where((n) {
      switch (_selectedTab) {
        case 1: return n.type == _NotifType.alert || n.type == _NotifType.recommendation;
        case 2: return n.type == _NotifType.appointment;
        case 3: return false; // no message type in mock
        default: return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final today   = _filtered(_todayNotifs);
    final earlier = _filtered(_earlierNotifs);

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
        title: const Text('Notifications',
            style: TextStyle(
                color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read',
                style: TextStyle(
                    color: Color(0xFF338880),
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tab bar ─────────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final sel = _selectedTab == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: sel
                              ? const Color(0xFF338880)
                              : const Color(0xFFF0F4F4),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(_tabs[i],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? Colors.white
                                  : const Color(0xFF5A6B74),
                            )),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── Notification list ────────────────────────────────────────────────
          Expanded(
            child: (today.isEmpty && earlier.isEmpty)
                ? _EmptyState()
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    children: [
                      if (today.isNotEmpty) ...[
                        _SectionLabel('TODAY'),
                        const Gap(8),
                        ...today.map((n) => _NotifCard(notif: n)),
                        const Gap(16),
                      ],
                      if (earlier.isNotEmpty) ...[
                        _SectionLabel('EARLIER'),
                        const Gap(8),
                        ...earlier.map((n) => _NotifCard(notif: n)),
                        const Gap(24),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9EA7AD),
                letterSpacing: 0.8)),
      );
}

class _NotifCard extends StatelessWidget {
  final _Notification notif;
  const _NotifCard({required this.notif});

  _TypeStyle get _style => _typeStyle(notif.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notif.isUnread
            ? _style.bgColor.withAlpha(40)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: notif.isUnread
            ? Border(
                left: BorderSide(color: _style.accentColor, width: 3.5))
            : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _style.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_style.icon, color: _style.accentColor, size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(notif.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0A1F2D))),
                    ),
                    if (notif.isUnread)
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: _style.accentColor,
                              shape: BoxShape.circle)),
                  ],
                ),
                const Gap(4),
                Text(notif.body,
                    style: const TextStyle(
                        color: Color(0xFF5A6B74),
                        fontSize: 13,
                        height: 1.4)),
                const Gap(6),
                Text(notif.timeLabel,
                    style: const TextStyle(
                        color: Color(0xFF9EA7AD), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF338880).withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_outlined,
                color: Color(0xFF338880), size: 40),
          ),
          const Gap(16),
          const Text('No notifications',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF0A1F2D))),
          const Gap(6),
          const Text('You\'re all caught up!',
              style: TextStyle(color: Color(0xFF9EA7AD))),
        ],
      ),
    );
  }
}

// ─── Type styling ─────────────────────────────────────────────────────────────

class _TypeStyle {
  final IconData icon;
  final Color accentColor;
  final Color bgColor;
  const _TypeStyle(this.icon, this.accentColor, this.bgColor);
}

_TypeStyle _typeStyle(_NotifType type) {
  switch (type) {
    case _NotifType.alert:
      return const _TypeStyle(
          Icons.warning_amber_rounded,
          Color(0xFFB3261E),
          Color(0xFFFFEAEA));
    case _NotifType.recommendation:
      return const _TypeStyle(
          Icons.medical_services_outlined,
          Color(0xFF338880),
          Color(0xFFE0F7F5));
    case _NotifType.appointment:
      return const _TypeStyle(
          Icons.calendar_today_outlined,
          Color(0xFF1565C0),
          Color(0xFFE3F2FD));
    case _NotifType.analysis:
      return const _TypeStyle(
          Icons.check_circle_outline,
          Color(0xFF2E7D32),
          Color(0xFFE8F5E9));
    case _NotifType.upload:
      return const _TypeStyle(
          Icons.notifications_active_outlined,
          Color(0xFFF57C00),
          Color(0xFFFFF3E0));
    case _NotifType.premium:
      return const _TypeStyle(
          Icons.workspace_premium_outlined,
          Color(0xFF6A1B9A),
          Color(0xFFF3E5F5));
  }
}
