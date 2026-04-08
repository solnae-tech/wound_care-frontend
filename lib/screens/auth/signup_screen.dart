import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../services/auth_service.dart';
import 'otp_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF0A1F2D)),
        title: const Text(
          'WoundCare',
          style: TextStyle(
            color: Color(0xFF338880),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A1F2D),
              ),
            ),
            const Gap(8),
            const Text(
              'Join thousands recovering smarter',
              style: TextStyle(
                color: Color(0xFF5A6B74),
                fontSize: 16,
              ),
            ),
            const Gap(32),
            _buildTextField(
              'Full Name', 
              _nameController,
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter your full name' : null,
            ),
            const Gap(16),
            _buildPhoneField(),
            const Gap(16),
            _buildTextField(
              'Email Address', 
              _emailController,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Enter a valid email';
                return null;
              },
            ),
            const Gap(16),
            _buildTextField(
              'Password', 
              _passwordController, 
              isPassword: true,
              validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
            ),
            const Gap(16),
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  activeColor: const Color(0xFF53D1C1),
                  onChanged: (val) {
                    setState(() {
                      _agreedToTerms = val ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I agree to ',
                      style: TextStyle(color: Color(0xFF5A6B74)),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(color: Color(0xFF338880), fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: Color(0xFF338880), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap(32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53D1C1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const Gap(32),
            const Center(
              child: Text(
                'or continue with',
                style: TextStyle(color: Color(0xFF9EA7AD)),
              ),
            ),
            const Gap(16),
            _buildSocialButton('Continue with Google', 'assets/images/google_logo.png', onTap: () async {
              try {
                await AuthService().googleLogin();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(color: Color(0xFF5A6B74)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Color(0xFF338880), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF9EA7AD)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E7E8))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF338880), width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
        suffixIcon: isPassword ? const Icon(Icons.visibility_outlined, color: Color(0xFF9EA7AD)) : null,
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Enter your phone number';
        if (v.trim().length < 10) return 'Invalid phone number';
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Phone Number',
        hintStyle: const TextStyle(color: Color(0xFF9EA7AD)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Container(
          width: 60,
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: Color(0xFFE0E7E8))),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('+91', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1F2D))),
              Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF0A1F2D)),
            ],
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E7E8))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF338880), width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
      ),
    );
  }

  Widget _buildSocialButton(String label, String iconPath, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E7E8)),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.g_mobiledata, size: 32, color: Colors.blue), // Placeholder for Google Icon
              const Gap(8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1F2D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms of Service.'), backgroundColor: Color(0xFFB3261E)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final phoneString = '+91${_phoneController.text.trim()}';
      await AuthService().signup(
        _nameController.text.trim(),
        phoneString,
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OtpScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFB3261E),
          ),
        );
      }
    }
  }
}
