import 'package:shared_preferences/shared_preferences.dart';
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
  }

  // ── Save helpers ─────────────────────────────────────────────────────────────
  Future<void> _saveUser() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    final u = _currentUser!;
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
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      fullName:    name,
      phoneNumber: phone,
      email:       email,
      password:    password,
      createdAt:   DateTime.now(),
    );
    await _saveUser();
  }

  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == '111111'; // For testing — replace with API
  }

  Future<void> updateProfile(String location, MedicalStats stats) async {
    if (_currentUser != null) {
      _currentUser!.location     = location;
      _currentUser!.medicalStats = stats;
      _isLoggedIn                = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_Keys.isLoggedIn, true);
      await _saveUser();
    }
  }

  Future<bool> login(String identifier, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // Ensure local data is loaded
    if (!_initialised) await init();

    if (_currentUser != null &&
        (_currentUser!.email == identifier.trim() ||
         _currentUser!.phoneNumber == identifier.trim()) &&
        _currentUser!.password == password) {
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_Keys.isLoggedIn, true);
      return true;
    }
    return false;
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
    await Future.delayed(const Duration(milliseconds: 600)); // mock delay
    if (_currentUser == null) return false;
    
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
       _currentUser!.medicalStats!.height = height;
       _currentUser!.medicalStats!.weight = weight;
       _currentUser!.medicalStats!.bloodPressure = bloodPressure;
       _currentUser!.medicalStats!.bloodSugar = bloodSugar;
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

  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_Keys.isLoggedIn, false);
  }

  Future<void> clearAll() async {
    _currentUser = null;
    _isLoggedIn  = false;
    _initialised = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
