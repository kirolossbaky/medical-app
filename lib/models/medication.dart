class Medication {
  final int? medicationId;
  final String name;
  final String activeIngredients;
  final String dosage;
  final String manufacturer;
  final DateTime? expiryDate;
  final String? instructions;
  final String? sideEffects;

  Medication({
    this.medicationId,
    required this.name,
    required this.activeIngredients,
    required this.dosage,
    required this.manufacturer,
    this.expiryDate,
    this.instructions,
    this.sideEffects,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicationId': medicationId,
      'name': name,
      'activeIngredients': activeIngredients,
      'dosage': dosage,
      'manufacturer': manufacturer,
      'expiryDate': expiryDate?.toIso8601String(),
      'instructions': instructions,
      'sideEffects': sideEffects,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      medicationId: json['medicationId'] as int?,
      name: json['name'] as String,
      activeIngredients: json['activeIngredients'] as String,
      dosage: json['dosage'] as String,
      manufacturer: json['manufacturer'] as String,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      instructions: json['instructions'] as String?,
      sideEffects: json['sideEffects'] as String?,
    );
  }
}
