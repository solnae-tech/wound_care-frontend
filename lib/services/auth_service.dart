import '../models/user_model.dart';

class AuthService {
  // Singleton pattern for mock persistence
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> signup(String name, String phone, String email, String password) async {
    // Mock signup delay
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      fullName: name,
      phoneNumber: phone,
      email: email,
      password: password,
    );
  }

  Future<bool> verifyOtp(String otp) async {
    // Mock OTP verification (randomly say "123456" is valid)
    await Future.delayed(const Duration(seconds: 1));
    return otp == "111111"; // For testing simplicity
  }

  Future<void> updateProfile(String location, MedicalStats stats) async {
    if (_currentUser != null) {
      _currentUser!.location = location;
      _currentUser!.medicalStats = stats;
      _isLoggedIn = true;
    }
  }

  Future<bool> login(String identifier, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock login verification
    if (_currentUser != null && 
       (_currentUser!.email == identifier || _currentUser!.phoneNumber == identifier) &&
       _currentUser!.password == password) {
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
  }
}
