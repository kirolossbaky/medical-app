import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medication.dart';
import '../models/pharmacy.dart';

class MedicationService {
  final String baseUrl = 'YOUR_API_BASE_URL'; // Replace with your actual API URL

  Future<List<Pharmacy>> searchPharmacy(String medicationName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pharmacies?medication=$medicationName'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Pharmacy.fromJson(json)).toList();
      }
      throw Exception('Failed to search pharmacies');
    } catch (e) {
      throw Exception('Error searching pharmacies: $e');
    }
  }

  Future<Map<String, dynamic>> searchDrugInfo(String drugName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/drugs?name=$drugName'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to fetch drug information');
    } catch (e) {
      throw Exception('Error fetching drug information: $e');
    }
  }

  Future<bool> verifyMedicationBarcode(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/verify?barcode=$barcode'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['isValid'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> analyzeDrugInteractions(List<Medication> medications) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/interactions'),
        body: json.encode({
          'medications': medications.map((m) => m.toJson()).toList(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item.toString()).toList();
      }
      throw Exception('Failed to analyze drug interactions');
    } catch (e) {
      throw Exception('Error analyzing drug interactions: $e');
    }
  }
}
