class UserModel {
  String fullName;
  String phoneNumber;
  String email;
  String? password;
  String? location;
  MedicalStats? medicalStats;

  UserModel({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.password,
    this.location,
    this.medicalStats,
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
