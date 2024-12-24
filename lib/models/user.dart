class User {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final List<Medication> medicationList;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.medicationList,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      medicationList: (json['medicationList'] as List)
          .map((med) => Medication.fromJson(med))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'medicationList': medicationList.map((med) => med.toJson()).toList(),
    };
  }
}

class Medication {
  final String medicationId;
  final String name;
  final String activeIngredients;
  final String dosage;
  final String sideEffects;
  final DateTime expiryDate;
  final String manufacturer;
  final String contraindications;

  Medication({
    required this.medicationId,
    required this.name,
    required this.activeIngredients,
    required this.dosage,
    required this.sideEffects,
    required this.expiryDate,
    required this.manufacturer,
    required this.contraindications,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      medicationId: json['medicationId'],
      name: json['name'],
      activeIngredients: json['activeIngredients'],
      dosage: json['dosage'],
      sideEffects: json['sideEffects'],
      expiryDate: DateTime.parse(json['expiryDate']),
      manufacturer: json['manufacturer'],
      contraindications: json['contraindications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationId': medicationId,
      'name': name,
      'activeIngredients': activeIngredients,
      'dosage': dosage,
      'sideEffects': sideEffects,
      'expiryDate': expiryDate.toIso8601String(),
      'manufacturer': manufacturer,
      'contraindications': contraindications,
    };
  }
}
