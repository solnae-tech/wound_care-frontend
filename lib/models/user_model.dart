class UserModel {
  int? id;
  String fullName;
  String phoneNumber;
  String email;
  String? password;
  String? location;
  MedicalStats? medicalStats;
  bool isPremium;

  final DateTime createdAt;

  UserModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.createdAt,
    this.password,
    this.location,
    this.medicalStats,
    this.isPremium = false,
  });
}

class MedicalStats {
  String bloodType;
  String bloodPressure;
  String bloodSugar;
  String weight;
  String height;

  MedicalStats({
    required this.bloodType,
    required this.bloodPressure,
    required this.bloodSugar,
    required this.weight,
    required this.height,
  });
}
