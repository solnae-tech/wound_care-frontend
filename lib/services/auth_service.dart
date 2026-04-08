import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_model.dart';

/// Keys used for local storage
class _Keys {
  static const fullName     = 'user_fullName';
  static const phoneNumber  = 'user_phoneNumber';
  static const email        = 'user_email';
  static const password     = 'user_password';
  static const location     = 'user_location';
  static const createdAt    = 'user_createdAt';
  static const isPremium    = 'user_isPremium';
  static const isLoggedIn   = 'user_isLoggedIn';
  static const token        = 'user_jwt_token';
  static const userId       = 'user_db_id';
  // MedicalStats
  static const bloodType    = 'med_bloodType';
  static const bloodPressure= 'med_bloodPressure';
  static const bloodSugar   = 'med_bloodSugar';
  static const weight       = 'med_weight';
  static const height       = 'med_height';
}

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  String? pendingEmail;
  int? pendingId;
  String? authToken;
  bool _isLoggedIn = false;
  bool _initialised = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isPremium => _currentUser?.isPremium ?? false;

  // ── Init (call once from main.dart) ─────────────────────────────────────────
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString(_Keys.email);
    if (email == null) return; // no saved user

    final createdAtMs = prefs.getInt(_Keys.createdAt);

    MedicalStats? stats;
    final bt = prefs.getString(_Keys.bloodType);
    if (bt != null) {
      stats = MedicalStats(
        bloodType:     bt,
        bloodPressure: prefs.getString(_Keys.bloodPressure) ?? '',
        bloodSugar:    prefs.getString(_Keys.bloodSugar) ?? '',
        weight:        prefs.getString(_Keys.weight) ?? '',
        height:        prefs.getString(_Keys.height) ?? '',
      );
    }

    _currentUser = UserModel(
      id:          prefs.getInt(_Keys.userId),
      fullName:    prefs.getString(_Keys.fullName) ?? '',
      phoneNumber: prefs.getString(_Keys.phoneNumber) ?? '',
      email:       email,
      password:    prefs.getString(_Keys.password),
      location:    prefs.getString(_Keys.location),
      createdAt:   createdAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(createdAtMs)
          : DateTime.now(),
      isPremium:   prefs.getBool(_Keys.isPremium) ?? false,
      medicalStats: stats,
    );

    _isLoggedIn = prefs.getBool(_Keys.isLoggedIn) ?? false;
    authToken = prefs.getString(_Keys.token);

    // If logged in, fetch latest profile to stay in sync
    if (_isLoggedIn && _currentUser?.id != null) {
      fetchProfile();
    }
  }

  // ── Save helpers ─────────────────────────────────────────────────────────────
  Future<void> _saveUser() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    final u = _currentUser!;
    if (u.id != null) await prefs.setInt(_Keys.userId, u.id!);
    await prefs.setString(_Keys.fullName,    u.fullName);
    await prefs.setString(_Keys.phoneNumber, u.phoneNumber);
    await prefs.setString(_Keys.email,       u.email);
    await prefs.setString(_Keys.password,    u.password ?? '');
    await prefs.setInt   (_Keys.createdAt,   u.createdAt.millisecondsSinceEpoch);
    await prefs.setBool  (_Keys.isPremium,   u.isPremium);
    if (u.location != null) {
      await prefs.setString(_Keys.location,  u.location!);
    }
    if (u.medicalStats != null) {
      final s = u.medicalStats!;
      await prefs.setString(_Keys.bloodType,     s.bloodType);
      await prefs.setString(_Keys.bloodPressure, s.bloodPressure);
      await prefs.setString(_Keys.bloodSugar,    s.bloodSugar);
      await prefs.setString(_Keys.weight,        s.weight);
      await prefs.setString(_Keys.height,        s.height);
    }
  }

  // ── Auth methods ──────────────────────────────────────────────────────────────
  Future<void> signup(
      String name, String phone, String email, String password) async {
    final url = Uri.parse('https://wound-care-auth-service.onrender.com/api/auth/register');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullName": name,
          "email": email,
          "phoneNumber": phone,
          "password": password,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        // Successful registration, backend usually routes to OTP block.
        pendingEmail = email;
        if (data['id'] != null) pendingId = data['id'];
        
        // Save local mock instance to simulate smooth behavior temporarily
        _currentUser = UserModel(
          fullName:    name,
          phoneNumber: phone,
          email:       email,
          password:    password,
          createdAt:   DateTime.now(),
        );
        await _saveUser();
      } else {
        final Map<String, dynamic> errData = jsonDecode(response.body);
        final String errorMsg = errData['message'] ?? 'Network request failed';
        throw Exception(errorMsg);
      }
    } catch (e) {
      // Re-throw standardized exception mapping
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (pendingEmail == null) return false;

    final url = Uri.parse('https://wound-care-auth-service.onrender.com/api/auth/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": pendingEmail,
          "otpCode": otp
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        
        // Cache JWT Token
        if (data['token'] != null) {
          authToken = data['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_Keys.token, authToken!);
        }

        // Extract dynamic ID mapped from the recent backend update
        final int? backendId = data['user_id'] ?? data['id'] ?? pendingId;
        if (backendId != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(_Keys.userId, backendId);
        }

        _currentUser ??= UserModel(
          id: backendId,
          fullName: data['fullName'] ?? 'User',
          phoneNumber: '+910000000000',
          email: pendingEmail!,
          password: 'mocked_password',
          createdAt: DateTime.now(),
        );
        _isLoggedIn = true;
        await _saveUser();

        pendingEmail = null;
        pendingId = null;
        return true;
      } else {
        final Map<String, dynamic> errData = jsonDecode(response.body);
        final String errorMsg = errData['message'] ?? 'Invalid OTP code';
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updateProfile(String location, MedicalStats stats) async {
    if (_currentUser == null) return;
    
    // We execute the HTTP mapping first securely
    if (_currentUser!.id != null && authToken != null) {
      final url = Uri.parse('https://wound-care-patient-service.onrender.com/profiles/\${_currentUser!.id}');
      
      try {
        final Map<String, dynamic> payload = {
          "id": _currentUser!.id,
          "user_id": _currentUser!.id,
          "full_name": _currentUser!.fullName,
          "phone_number": _currentUser!.phoneNumber,
          "location": location,
          "blood_type": stats.bloodType,
          "blood_pressure": stats.bloodPressure.toLowerCase() == 'yes',
          "blood_sugar": stats.bloodSugar.toLowerCase() == 'yes',
          "weight": double.tryParse(stats.weight) ?? 0,
          "height": double.tryParse(stats.height) ?? 0,
        };

        final response = await http.patch(
          url, // This handles the new endpoint hookups logic
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer \$authToken'
          },
          body: jsonEncode(payload),
        );

        if (response.statusCode >= 400) {
           final Map<String, dynamic> errData = jsonDecode(response.body);
           throw Exception(errData['message'] ?? 'Profile update failed');
        }
      } catch (e) {
        throw Exception(e.toString().replaceAll('Exception: ', ''));
      }
    }

    _currentUser!.location     = location;
    _currentUser!.medicalStats = stats;
    _isLoggedIn                = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_Keys.isLoggedIn, true);
    await _saveUser();
  }

  Future<bool> login(String identifier, String password) async {
    final url = Uri.parse('https://wound-care-auth-service.onrender.com/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": identifier, "password": password}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        pendingEmail = identifier;
        if (data['id'] != null) pendingId = data['id'];
        return true;
      } else {
        final Map<String, dynamic> errData = jsonDecode(response.body);
        throw Exception(errData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    if (authToken != null) {
      final url = Uri.parse('https://wound-care-auth-service.onrender.com/api/auth/logout');
      try {
        await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        // Log error but continue with local logout
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    authToken = null;
    _isLoggedIn = false;
  }

  Future<void> googleLogin() async {
    final url = Uri.parse('https://wound-care-auth-service.onrender.com/api/auth/google');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch Google Login URL');
    }
  }

  Future<void> fetchProfile() async {
    if (_currentUser?.id == null || authToken == null) return;
    
    final url = Uri.parse('https://wound-care-patient-service.onrender.com/profiles/${_currentUser!.id}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        _currentUser!.fullName = data['full_name'] ?? _currentUser!.fullName;
        _currentUser!.phoneNumber = data['phone_number'] ?? _currentUser!.phoneNumber;
        _currentUser!.location = data['location'] ?? _currentUser!.location;
        
        _currentUser!.medicalStats = MedicalStats(
          bloodType: data['blood_type'] ?? '',
          bloodPressure: (data['blood_pressure'] == true) ? 'Yes' : 'No',
          bloodSugar: (data['blood_sugar'] == true) ? 'Yes' : 'No',
          weight: data['weight']?.toString() ?? '0',
          height: data['height']?.toString() ?? '0',
        );
        
        await _saveUser();
      }
    } catch (e) {
      // Handle error gracefully
    }
  }

  Future<void> upgradeToPremium() async {
    await Future.delayed(const Duration(seconds: 1)); // mock network delay
    if (_currentUser != null) {
      _currentUser!.isPremium = true;
      await _saveUser();
    }
  }

  // ── Profile Updates ──────────────────────────────────────────────────────────

  Future<bool> updatePersonalDetails({
    required String fullName,
    required String phoneNumber,
    required String bloodType,
    required String height,
    required String weight,
    required String bloodPressure,
    required String bloodSugar,
  }) async {
    if (_currentUser == null) return false;

    // Send HTTP Update
    if (_currentUser!.id != null && authToken != null) {
      final url = Uri.parse('https://wound-care-patient-service.onrender.com/profiles/${_currentUser!.id}');
      
      try {
        final Map<String, dynamic> payload = {
          "id": _currentUser!.id,
          "user_id": _currentUser!.id,
          "full_name": fullName,
          "phone_number": phoneNumber,
          "location": _currentUser!.location ?? 'Unknown',
          "blood_type": bloodType,
          "blood_pressure": bloodPressure.toLowerCase() == 'yes',
          "blood_sugar": bloodSugar.toLowerCase() == 'yes',
          "weight": double.tryParse(weight) ?? 0,
          "height": double.tryParse(height) ?? 0,
        };

        final response = await http.patch(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken'
          },
          body: jsonEncode(payload),
        );

        if (response.statusCode >= 400) {
           final Map<String, dynamic> errData = jsonDecode(response.body);
           throw Exception(errData['message'] ?? 'Profile details update failed');
        }
      } catch (e) {
        throw Exception(e.toString().replaceAll('Exception: ', ''));
      }
    }
    
    _currentUser!.fullName = fullName;
    _currentUser!.phoneNumber = phoneNumber;
    if (_currentUser!.medicalStats == null) {
       _currentUser!.medicalStats = MedicalStats(
           bloodType: bloodType,
           bloodPressure: bloodPressure,
           bloodSugar: bloodSugar,
           weight: weight,
           height: height,
       );
    } else {
       _currentUser!.medicalStats!.bloodType = bloodType;
       _currentUser!.medicalStats!.bloodPressure = bloodPressure;
       _currentUser!.medicalStats!.bloodSugar = bloodSugar;
       _currentUser!.medicalStats!.weight = weight;
       _currentUser!.medicalStats!.height = height;
    }
    await _saveUser();
    return true;
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 600)); // mock delay
    if (_currentUser == null) return false;
    
    // In mock, compare with what's stored or a standard default
    final stored = _currentUser!.password ?? 'password123';
    if (oldPassword != stored) {
      return false; // Wrong old password
    }
    
    _currentUser!.password = newPassword;
    await _saveUser();
    return true;
  }



  Future<void> clearAll() async {
    _currentUser = null;
    _isLoggedIn  = false;
    _initialised = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
