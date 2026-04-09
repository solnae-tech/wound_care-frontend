import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../services/auth_service.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  
  String? _bloodType;
  String? _bpStatus = 'No';
  String? _sugarStatus = 'No';
  bool _isLoading = false;

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    final u = AuthService().currentUser;
    if (u != null) {
      _fullNameCtrl.text = u.fullName;
      _phoneCtrl.text = u.phoneNumber;
      _locationCtrl.text = u.location ?? '';
      final ms = u.medicalStats;
      if (ms != null) {
        _weightCtrl.text = ms.weight.replaceAll(RegExp(r'[^0-9.]'), '');
        _heightCtrl.text = ms.height.replaceAll(RegExp(r'[^0-9.]'), '');
        _bpStatus = ms.bloodPressure == 'Yes' ? 'Yes' : 'No';
        _sugarStatus = ms.bloodSugar == 'Yes' ? 'Yes' : 'No';
        if (_bloodTypes.contains(ms.bloodType)) {
          _bloodType = ms.bloodType;
        }
      }
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final success = await AuthService().updatePersonalDetails(
      fullName: _fullNameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      bloodType: _bloodType ?? 'Unknown',
      height: '${_heightCtrl.text.trim()} cm',
      weight: '${_weightCtrl.text.trim()} kg',
      bloodPressure: _bpStatus ?? 'No',
      bloodSugar: _sugarStatus ?? 'No',
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Personal details updated successfully!'), backgroundColor: Color(0xFF338880))
         );
         Navigator.pop(context, true); // true indicates a refresh is needed
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Failed to update details.'), backgroundColor: Colors.red)
         );
      }
    }
  }

  InputDecoration _inputDec(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9EA7AD)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E7E8))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF338880), width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = AuthService().currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text('Personal Details', style: TextStyle(color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF338880)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('GENERAL INFO', style: TextStyle(color: Color(0xFF9EA7AD), fontWeight: FontWeight.bold, fontSize: 11)),
              const Gap(16),
              TextFormField(
                controller: _fullNameCtrl,
                decoration: _inputDec('Full Name'),
                style: const TextStyle(color: Color(0xFF0A1F2D)),
                validator: (v) => v!.trim().isEmpty ? 'Enter your name' : null,
              ),
              const Gap(16),
              TextFormField(
                controller: _phoneCtrl,
                decoration: _inputDec('Phone Number'),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Color(0xFF0A1F2D)),
                validator: (v) => v!.trim().isEmpty ? 'Enter your phone number' : null,
              ),
              const Gap(16),
              TextFormField(
                initialValue: email,
                enabled: false,
                decoration: _inputDec('Email Address').copyWith(
                  fillColor: const Color(0xFFF0F4F4),
                ),
                style: const TextStyle(color: Color(0xFF5A6B74)),
              ),
              const Gap(16),
              TextFormField(
                controller: _locationCtrl,
                decoration: _inputDec('Location'),
                style: const TextStyle(color: Color(0xFF0A1F2D)),
                validator: (v) => v!.trim().isEmpty ? 'Enter your location' : null,
              ),
              const Gap(32),
              const Text('MEDICAL PROFILE', style: TextStyle(color: Color(0xFF9EA7AD), fontWeight: FontWeight.bold, fontSize: 11)),
              const Gap(16),
              DropdownButtonFormField<String>(
                initialValue: _bloodType,
                style: const TextStyle(color: Color(0xFF0A1F2D)),
                dropdownColor: Colors.white,
                decoration: _inputDec('Blood Type'),
                items: _bloodTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _bloodType = v),
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightCtrl,
                      decoration: _inputDec('Height (cm)'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Color(0xFF0A1F2D)),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: TextFormField(
                      controller: _weightCtrl,
                      decoration: _inputDec('Weight (kg)'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Color(0xFF0A1F2D)),
                    ),
                  ),
                ],
              ),
              const Gap(16),
               Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _bpStatus,
                      style: const TextStyle(color: Color(0xFF0A1F2D)),
                      dropdownColor: Colors.white,
                      decoration: _inputDec('High BP?'),
                      items: ['Yes', 'No'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setState(() => _bpStatus = v),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _sugarStatus,
                      style: const TextStyle(color: Color(0xFF0A1F2D)),
                      dropdownColor: Colors.white,
                      decoration: _inputDec('Diabetic?'),
                      items: ['Yes', 'No'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setState(() => _sugarStatus = v),
                    ),
                  ),
                ],
              ),
              const Gap(48),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF338880),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
