import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _bpStatus = 'No';
  String _sugarStatus = 'No';
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _selectedBloodType = 'Select Blood Type';

  @override
  void initState() {
    super.initState();
    final user = AuthService().currentUser;
    if (user != null) {
      _nameController.text = user.fullName;
      _phoneController.text = user.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF338880)),
        title: const Text(
          'Complete Profile',
          style: TextStyle(color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STEP 1 OF 2: BASIC INFO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A6B74),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Gap(8),
                  LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: const Color(0xFF53D1C1).withAlpha(25),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF338880)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Contact Details'),
                  const Gap(16),
                  _buildLabel('FULL NAME'),
                  _buildInputField(_nameController),
                  const Gap(16),
                  _buildLabel('PHONE NUMBER'),
                  _buildInputField(_phoneController, prefix: '+91 '),
                  const Gap(16),
                  _buildLabel('LOCATION/ADDRESS'),
                  _buildInputField(_addressController, maxLines: 3),
                  const Gap(32),
                  _buildSectionTitle('Medical Stats'),
                  const Gap(16),
                  _buildLabel('BLOOD TYPE'),
                  _buildBloodTypeDropdown(),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('HIGH BP?'),
                            _buildBooleanDropdown(_bpStatus, (v) => setState(() => _bpStatus = v!)),
                          ],
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('DIABETIC?'),
                            _buildBooleanDropdown(_sugarStatus, (v) => setState(() => _sugarStatus = v!)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('WEIGHT'),
                            _buildInputField(_weightController, hint: 'kg'),
                          ],
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('HEIGHT'),
                            _buildInputField(_heightController, hint: 'cm'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF7FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF338880)),
                        Gap(12),
                        Expanded(
                          child: Text(
                            'This information helps our AI provide more accurate healing insights.',
                            style: TextStyle(color: Color(0xFF5A6B74), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF338880),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Save & Continue', style: TextStyle(fontWeight: FontWeight.bold)),
                          Gap(8),
                          Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A1F2D),
          ),
        ),
        const Gap(8),
        const CircleAvatar(radius: 2, backgroundColor: Color(0xFF53D1C1)),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5A6B74),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, {String? hint, String? prefix, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E7E8)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          prefixText: prefix,
          hintStyle: const TextStyle(color: Color(0xFF9EA7AD)),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBloodTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E7E8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBloodType,
          isExpanded: true,
          icon: const Icon(Icons.unfold_more, color: Color(0xFF5A6B74)),
          items: <String>['Select Blood Type', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: value == 'Select Blood Type' ? const Color(0xFF9EA7AD) : const Color(0xFF0A1F2D))),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedBloodType = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBooleanDropdown(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E7E8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.unfold_more, color: Color(0xFF5A6B74)),
          items: <String>['Yes', 'No'].map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: const TextStyle(color: Color(0xFF0A1F2D))),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _handleSave() async {
    final stats = MedicalStats(
      bloodType: _selectedBloodType,
      bloodPressure: _bpStatus,
      bloodSugar: _sugarStatus,
      weight: _weightController.text,
      height: _heightController.text,
    );
    
    await AuthService().updateProfile(_addressController.text, stats);
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    }
  }
}
