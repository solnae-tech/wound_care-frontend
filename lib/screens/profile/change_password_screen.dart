import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  
  bool _isLoading = false;
  bool _obOld = true;
  bool _obNew = true;
  bool _obConfirm = true;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final success = await AuthService().updatePassword(
      _oldCtrl.text,
      _newCtrl.text,
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Password updated securely.'), backgroundColor: Color(0xFF338880))
         );
         Navigator.pop(context);
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Incorrect current password.'), backgroundColor: Colors.red)
         );
      }
    }
  }

  InputDecoration _inputDec(String label, bool isObscured, VoidCallback toggle) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9EA7AD)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E7E8))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF338880), width: 2)),
      suffixIcon: IconButton(
        icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF9EA7AD)),
        onPressed: toggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(color: Color(0xFF0A1F2D), fontWeight: FontWeight.bold, fontSize: 16)),
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
              const Text('Update your credentials to keep your account safe.', style: TextStyle(color: Color(0xFF5A6B74), fontSize: 14)),
              const Gap(32),
              
              TextFormField(
                controller: _oldCtrl,
                obscureText: _obOld,
                decoration: _inputDec('Current Password', _obOld, () => setState(() => _obOld = !_obOld)),
                style: const TextStyle(color: Color(0xFF0A1F2D)),
                validator: (v) => v!.isEmpty ? 'Enter current password' : null,
              ),
              const Gap(16),
              
              TextFormField(
                controller: _newCtrl,
                obscureText: _obNew,
                decoration: _inputDec('New Password', _obNew, () => setState(() => _obNew = !_obNew)),
                style: const TextStyle(color: Color(0xFF0A1F2D)),
                validator: (v) {
                  if (v!.isEmpty) return 'Enter new password';
                  if (v.length < 6) return 'Must be at least 6 characters';
                  return null;
                },
              ),
              const Gap(16),
              
              TextFormField(
                controller: _confirmCtrl,
                obscureText: _obConfirm,
                decoration: _inputDec('Confirm New Password', _obConfirm, () => setState(() => _obConfirm = !_obConfirm)),
                style: const TextStyle(color: Color(0xFF0A1F2D)),
                validator: (v) {
                  if (v != _newCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const Gap(48),
              
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF338880),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Update Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
