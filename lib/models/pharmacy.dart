class Pharmacy {
  final String pharmacyId;
  final String name;
  final String address;
  final Map<String, int> stock;

  Pharmacy({
    required this.pharmacyId,
    required this.name,
    required this.address,
    required this.stock,
  });

  int checkStock(String medicationName) {
    return stock[medicationName] ?? 0;
  }

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      pharmacyId: json['pharmacyId'],
      name: json['name'],
      address: json['address'],
      stock: Map<String, int>.from(json['stock']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pharmacyId': pharmacyId,
      'name': name,
      'address': address,
      'stock': stock,
    };
  }
}
