import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../services/auth_service.dart';
import 'signup_screen.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Gap(80),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF53D1C1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.emergency_outlined, color: Colors.white, size: 40),
                ),
              ),
              const Gap(24),
              const Text(
                'WoundCare',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF338880),
                ),
              ),
              const Gap(48),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1F2D),
                ),
              ),
              const Gap(8),
              const Text(
                'Login to continue your healing journey',
                style: TextStyle(color: Color(0xFF5A6B74)),
              ),
              const Gap(40),
              _buildTextField('Phone or Email', _identifierController),
              const Gap(16),
              _buildTextField('Password', _passwordController, isPassword: true),
              const Gap(8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'FORGOT PASSWORD?',
                    style: TextStyle(
                      color: Color(0xFF338880),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF338880),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const Gap(32),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: Color(0xFF9EA7AD))),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const Gap(32),
              _buildSocialButton('Continue with Google'),
              const Gap(48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account? ', style: TextStyle(color: Color(0xFF5A6B74))),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Color(0xFF338880), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Gap(32),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF9EA7AD)),
                  Gap(4),
                  Text('HIPAA COMPLIANT', style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 10)),
                  Gap(16),
                  Icon(Icons.lock_outline, size: 14, color: Color(0xFF9EA7AD)),
                  Gap(4),
                  Text('256-BIT ENCRYPTION', style: TextStyle(color: Color(0xFF9EA7AD), fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Color(0xFF9EA7AD)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          border: InputBorder.none,
          suffixIcon: isPassword ? const Icon(Icons.visibility_outlined, color: Color(0xFF9EA7AD)) : null,
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label) {
    return Container(
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
            const Icon(Icons.g_mobiledata, size: 32, color: Colors.blue),
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
    );
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    bool success = await AuthService().login(
      _identifierController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials. Please signup first.')),
      );
    }
  }
}
