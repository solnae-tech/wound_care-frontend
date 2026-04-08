import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../services/wound_service.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

enum _SenderType { user, bot }
enum _MessageType { text, woundCard }

class _ChatMessage {
  final _SenderType sender;
  final _MessageType type;
  final String text;
  final String? cardTitle;
  final String? cardBody;
  final String? cardButton;
  final DateTime timestamp;

  _ChatMessage({
    required this.sender,
    required this.text,
    this.type = _MessageType.text,
    this.cardTitle,
    this.cardBody,
    this.cardButton,
  }) : timestamp = DateTime.now();
}

// ─── Mock data ────────────────────────────────────────────────────────────────
// TODO: Replace with API endpoint when ready.

final Map<String, List<_ChatMessage>> _mockHistories = {
  'general': [
    _ChatMessage(
      sender: _SenderType.bot,
      text: 'Hello Karthik! I can help with general health questions or you can select a specific wound above to get tailored advice.',
    ),
  ],
  '1': [ // ID 1 corresponds to Left Knee Abrasion in mock WoundService
    _ChatMessage(
      sender: _SenderType.bot,
      text: 'Let\'s talk about your Left Knee Abrasion. How is the pain today?',
    ),
    _ChatMessage(sender: _SenderType.user, text: 'Is my wound healing normally?'),
    _ChatMessage(
      sender: _SenderType.bot,
      text: 'Based on your data, your score improved to 74. The mild redness today is worth monitoring.',
    ),
    _ChatMessage(sender: _SenderType.user, text: 'Should I see a doctor?'),
    _ChatMessage(
      sender: _SenderType.bot,
      text: 'This looks like a wound-related issue.',
      type: _MessageType.woundCard,
      cardTitle: '⚠️  This looks like a wound-related issue.',
      cardBody: 'I\'ve found signs worth reviewing in your latest analysis.',
      cardButton: 'View Wound Analysis  →',
    ),
  ]
};

// ─── Screen ───────────────────────────────────────────────────────────────────

class ChatScreen extends StatefulWidget {
  final String? initialWoundId;
  const ChatScreen({super.key, this.initialWoundId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Map<String, List<_ChatMessage>> _histories;
  late String _activeContextId;
  
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Copy mock histories so we can modify them
    _histories = {
      for (var entry in _mockHistories.entries)
        entry.key: List.from(entry.value)
    };
    _activeContextId = widget.initialWoundId ?? 'general';
    if (!_histories.containsKey(_activeContextId)) {
       _histories[_activeContextId] = [
         _ChatMessage(sender: _SenderType.bot, text: 'Hello! I am ready to help you with this wound case.')
       ];
    }
  }

  List<_ChatMessage> get _activeMessages => _histories[_activeContextId]!;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();

    setState(() {
      _activeMessages.add(_ChatMessage(sender: _SenderType.user, text: text.trim()));
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate bot response delay
    // TODO: Replace with actual API call.
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _activeMessages.add(_ChatMessage(
        sender: _SenderType.bot,
        text: _activeContextId == 'general' 
            ? 'For general queries, please contact our support team.'
            : 'I\'m analysing your data now. For personalised advice, please consult your assigned doctor.',
      ));
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'AI Assistant',
              style: TextStyle(
                  color: Color(0xFF0A1F2D),
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            Text(
              'General queries · Wound guidance',
              style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 11),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF9EA7AD)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Context Selector ─────────────────────────────────
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: const Color(0xFFE0E7E8))),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                _buildContextChip('general', 'General Medical'),
                ...WoundService().wounds.map((w) => _buildContextChip(w.id, w.title)),
              ],
            ),
          ),
          
          // ── Chat list ──────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _activeMessages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isTyping && i == _activeMessages.length) {
                  return _TypingBubble();
                }
                return _MessageBubble(message: _activeMessages[i]);
              },
            ),
          ),

          // ── Input bar ──────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Row(
              children: [
                const Icon(Icons.mic_none_rounded,
                    color: Color(0xFF9EA7AD), size: 24),
                const Gap(10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FCFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE0E7E8)),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle:
                            TextStyle(color: Color(0xFF9EA7AD), fontSize: 14),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                          color: Color(0xFF0A1F2D), fontSize: 14),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const Gap(10),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF338880),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_upward_rounded,
                        color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextChip(String id, String label) {
    final isActive = _activeContextId == id;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
           setState(() {
             _activeContextId = id;
             if (!_histories.containsKey(id)) {
                _histories[id] = [
                  _ChatMessage(sender: _SenderType.bot, text: 'Hello! You have switched context to $label. How can I assist you with this today?')
                ];
             }
           });
           Future.delayed(const Duration(milliseconds: 50), _scrollToBottom);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF338880) : const Color(0xFFF0F4F4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? const Color(0xFF338880) : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF5A6B74),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ─── Message Bubble ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  bool get _isUser => message.sender == _SenderType.user;

  @override
  Widget build(BuildContext context) {
    if (message.type == _MessageType.woundCard) {
      return _WoundCardBubble(message: message);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isUser) _BotAvatar(),
          if (!_isUser) const Gap(8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isUser
                    ? const Color(0xFF338880)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(_isUser ? 20 : 4),
                  bottomRight: Radius.circular(_isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: _isUser ? Colors.white : const Color(0xFF0A1F2D),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ),
          ),
          if (_isUser) const Gap(8),
        ],
      ),
    );
  }
}

class _WoundCardBubble extends StatelessWidget {
  final _ChatMessage message;
  const _WoundCardBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _BotAvatar(),
          const Gap(8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFE6A817), size: 18),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          message.cardTitle ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A1F2D),
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    message.cardBody ?? '',
                    style: const TextStyle(
                        color: Color(0xFF5A6B74), fontSize: 13, height: 1.4),
                  ),
                  const Gap(12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF338880),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      child: Text(message.cardButton ?? 'View'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFF338880),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.health_and_safety_outlined,
          color: Colors.white, size: 18),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _BotAvatar(),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: List.generate(3, (i) => _Dot(delay: i * 200)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: -5).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOut,
    ));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Transform.translate(
          offset: Offset(0, _anim.value),
          child: const CircleAvatar(
              radius: 4, backgroundColor: Color(0xFF9EA7AD)),
        ),
      ),
    );
  }
}
