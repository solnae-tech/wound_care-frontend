import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'wound_analysis_loading_screen.dart';
import 'wound_analysis_result_screen.dart';
import '../../models/wound_model.dart';

class AddWoundScreen extends StatefulWidget {
  final WoundModel? existingWound;
  const AddWoundScreen({super.key, this.existingWound});

  @override
  State<AddWoundScreen> createState() => _AddWoundScreenState();
}

class _AddWoundScreenState extends State<AddWoundScreen> {
  // ── Controllers ─────────────────────────────────────────────────────────────
  final TextEditingController _causeController = TextEditingController();

  // ── State ───────────────────────────────────────────────────────────────────
  String? _selectedLocation;
  double _painLevel = 3;
  final Set<String> _selectedSymptoms = {};
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // ── Static options ───────────────────────────────────────────────────────────
  static const List<String> _bodyLocations = [
    'Head', 'Forehead', 'Face', 'Nose', 'Ear (Left)', 'Ear (Right)',
    'Jaw', 'Neck', 'Shoulder (Left)', 'Shoulder (Right)',
    'Upper Arm (Left)', 'Upper Arm (Right)',
    'Elbow (Left)', 'Elbow (Right)',
    'Forearm (Left)', 'Forearm (Right)',
    'Wrist (Left)', 'Wrist (Right)',
    'Hand (Left)', 'Hand (Right)',
    'Finger(s) – Left', 'Finger(s) – Right',
    'Chest', 'Abdomen', 'Rib Area', 'Back (Upper)', 'Back (Lower)',
    'Hip (Left)', 'Hip (Right)',
    'Thigh (Left)', 'Thigh (Right)',
    'Knee (Left)', 'Knee (Right)',
    'Shin / Lower Leg (Left)', 'Shin / Lower Leg (Right)',
    'Ankle (Left)', 'Ankle (Right)',
    'Foot (Left)', 'Foot (Right)',
    'Toe(s) – Left', 'Toe(s) – Right',
  ];

  static const List<String> _symptomOptions = [
    'Redness', 'Swelling', 'Discharge / Pus', 'Bleeding',
    'Itching', 'Burning', 'Numbness', 'Fever', 'Odour', 'Skin Darkening',
  ];

  static const List<String> _causeOptions = [
    'Cut / Laceration', 'Burn', 'Abrasion / Scrape', 'Puncture',
    'Surgical', 'Pressure sore', 'Bite', 'Diabetic ulcer', 'Other',
  ];

  // ── Helpers ──────────────────────────────────────────────────────────────────
  String get _painEmoji {
    if (_painLevel <= 2) return '😊';
    if (_painLevel <= 4) return '😐';
    if (_painLevel <= 6) return '😟';
    if (_painLevel <= 8) return '😣';
    return '😭';
  }

  Color get _painColor {
    if (_painLevel <= 2) return const Color(0xFF4CAF50);
    if (_painLevel <= 4) return const Color(0xFFFFB300);
    if (_painLevel <= 6) return const Color(0xFFFF7043);
    return const Color(0xFFB3261E);
  }

  String get _painLabel {
    if (_painLevel <= 2) return 'No Pain';
    if (_painLevel <= 4) return 'Mild';
    if (_painLevel <= 6) return 'Moderate';
    if (_painLevel <= 8) return 'Severe';
    return 'Worst Pain';
  }

  bool get _isValid {
    if (widget.existingWound != null) return true;
    return _causeController.text.trim().isNotEmpty && _selectedLocation != null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE0E7E8),
                      borderRadius: BorderRadius.circular(2))),
              const Gap(20),
              const Text('Add Wound Photo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,
                      color: Color(0xFF0A1F2D))),
              const Gap(20),
              Row(
                children: [
                  Expanded(child: _ImageSourceTile(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
                  )),
                  const Gap(12),
                  Expanded(child: _ImageSourceTile(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _causeController.dispose();
    super.dispose();
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
        title: Text(widget.existingWound != null ? 'Log Progress' : 'Add New Wound',
            style: const TextStyle(
                color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: 0.33,
            backgroundColor: const Color(0xFFE0E7E8),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF338880)),
            minHeight: 3,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('Step 1 of 3  ·  Wound Details'),
                  const Gap(20),

                  // ── 1. Cause ─────────────────────────────────────────────
                  if (widget.existingWound == null) ...[
                    _FieldCard(
                      icon: Icons.crisis_alert_outlined,
                      title: 'Cause of Wound',
                      required: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _causeOptions.map((cause) {
                              final selected = _causeController.text == cause;
                              return GestureDetector(
                                onTap: () => setState(
                                    () => _causeController.text = cause),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF338880)
                                        : const Color(0xFFF0F4F4),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? const Color(0xFF338880)
                                          : const Color(0xFFE0E7E8),
                                    ),
                                  ),
                                  child: Text(cause,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: selected
                                            ? Colors.white
                                            : const Color(0xFF5A6B74),
                                      )),
                                ),
                              );
                            }).toList(),
                          ),
                          const Gap(12),
                          TextField(
                            controller: _causeController,
                            onChanged: (_) => setState(() {}),
                            decoration: _inputDecoration('Describe the cause...'),
                            style: const TextStyle(
                                color: Color(0xFF0A1F2D), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                  ],

                  // ── 2. Location ───────────────────────────────────────────
                  if (widget.existingWound == null) ...[
                    _FieldCard(
                      icon: Icons.location_on_outlined,
                      title: 'Location on Body',
                      required: true,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedLocation,
                        isExpanded: true,
                        decoration: _inputDecoration('Select body area'),
                        dropdownColor: Colors.white,
                        items: _bodyLocations
                            .map((loc) => DropdownMenuItem(
                                  value: loc,
                                  child: Text(loc,
                                      style: const TextStyle(
                                          color: Color(0xFF0A1F2D),
                                          fontSize: 14)),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedLocation = v),
                        style: const TextStyle(
                            color: Color(0xFF0A1F2D), fontSize: 14),
                        icon: const Icon(Icons.expand_more_rounded,
                            color: Color(0xFF338880)),
                      ),
                    ),
                    const Gap(16),
                  ],

                  // ── 3. Pain Level ─────────────────────────────────────────
                  _FieldCard(
                    icon: Icons.sentiment_dissatisfied_outlined,
                    title: 'Pain Level',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_painEmoji,
                                style: const TextStyle(fontSize: 36)),
                            const Gap(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_painLevel.toInt()} / 10',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: _painColor),
                                ),
                                Text(_painLabel,
                                    style: const TextStyle(
                                        color: Color(0xFF5A6B74),
                                        fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        const Gap(8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 22),
                            activeTrackColor: _painColor,
                            inactiveTrackColor: const Color(0xFFE0E7E8),
                            thumbColor: _painColor,
                            overlayColor: _painColor.withAlpha(30),
                          ),
                          child: Slider(
                            min: 0,
                            max: 10,
                            divisions: 10,
                            value: _painLevel,
                            onChanged: (v) =>
                                setState(() => _painLevel = v),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('0', style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 11)),
                            Text('5', style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 11)),
                            Text('10', style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // ── 4. Symptoms ───────────────────────────────────────────
                  _FieldCard(
                    icon: Icons.monitor_heart_outlined,
                    title: 'Symptoms',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _symptomOptions.map((s) {
                        final selected = _selectedSymptoms.contains(s);
                        return GestureDetector(
                          onTap: () => setState(() => selected
                              ? _selectedSymptoms.remove(s)
                              : _selectedSymptoms.add(s)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF338880).withAlpha(20)
                                  : const Color(0xFFF0F4F4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF338880)
                                    : const Color(0xFFE0E7E8),
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (selected) ...[
                                  const Icon(Icons.check_circle,
                                      size: 14, color: Color(0xFF338880)),
                                  const SizedBox(width: 4),
                                ],
                                Text(s,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: selected
                                          ? const Color(0xFF338880)
                                          : const Color(0xFF5A6B74),
                                    )),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Gap(16),

                  // ── 5. Photo ──────────────────────────────────────────────
                  _FieldCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'Wound Photo',
                    child: GestureDetector(
                      onTap: _showImageSourceSheet,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: _pickedImage == null
                              ? const Color(0xFFF0F4F4)
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _pickedImage == null
                                ? const Color(0xFFCDD5D8)
                                : const Color(0xFF338880),
                            width: _pickedImage == null ? 1.5 : 2,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _pickedImage != null
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(_pickedImage!,
                                      fit: BoxFit.cover),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => setState(
                                          () => _pickedImage = null),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle),
                                        child: const Icon(Icons.close,
                                            color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF338880)
                                          .withAlpha(20),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Color(0xFF338880),
                                        size: 30),
                                  ),
                                  const Gap(12),
                                  const Text('Tap to add a photo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF338880))),
                                  const Gap(4),
                                  const Text(
                                      'Camera or Gallery',
                                      style: TextStyle(
                                          color: Color(0xFF9EA7AD),
                                          fontSize: 12)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Next Button ──────────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: _isValid
                ? () {
                    // TODO: Replace the Future.delayed below with your real API call.
                    // e.g. analysisFuture: WoundApiService().analyzeWound(...)
                    final mockApiFuture =
                        Future.delayed(const Duration(seconds: 10), () => {'score': 72});

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WoundAnalysisLoadingScreen(
                          analysisFuture: mockApiFuture,
                          onComplete: (result) {
                            // Replace the loading screen and add wound screen with the result screen
                            Navigator.pushReplacement(
                              context,
                              // Push result screen
                              MaterialPageRoute(
                                builder: (_) => WoundAnalysisResultScreen(
                                  woundTitle: widget.existingWound?.title ?? (_selectedLocation ?? 'New Wound'),
                                  causeDesc: widget.existingWound?.description ?? _causeController.text,
                                  existingWoundId: widget.existingWound?.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF338880),
              disabledBackgroundColor: const Color(0xFFCDD5D8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Next'),
                Gap(8),
                Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9EA7AD),
            letterSpacing: 0.6),
      );
}

class _FieldCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final bool required;
  const _FieldCard({
    required this.icon,
    required this.title,
    required this.child,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF338880).withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF338880), size: 18),
              ),
              const Gap(10),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF0A1F2D))),
              if (required) ...[
                const Gap(4),
                const Text('*',
                    style: TextStyle(color: Color(0xFFB3261E), fontSize: 16)),
              ],
            ],
          ),
          const Gap(16),
          child,
        ],
      ),
    );
  }
}

class _ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ImageSourceTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E7E8)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF338880), size: 28),
            const Gap(8),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF338880))),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF9EA7AD), fontSize: 14),
    filled: true,
    fillColor: const Color(0xFFF0F4F4),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E7E8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E7E8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF338880), width: 1.5),
    ),
  );
}
