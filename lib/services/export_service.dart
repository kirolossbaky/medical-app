import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class ExportService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<String> exportData() async {
    try {
      // Fetch all data
      final medications = await _databaseHelper.getMedications();
      final schedules = await _databaseHelper.getSchedules();
      final prescriptions = await _databaseHelper.getPrescriptions();

      // Create export data structure
      final exportData = {
        'exportDate': DateTime.now().toIso8601String(),
        'medications': medications.map((m) => m.toJson()).toList(),
        'schedules': schedules.map((s) => s.toJson()).toList(),
        'prescriptions': prescriptions,
      };

      // Create export file
      final directory = await getApplicationDocumentsDirectory();
      final date = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/medical_data_$date.json';

      // Write to file
      final file = File(filePath);
      await file.writeAsString(jsonEncode(exportData));

      return filePath;
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  Future<String> exportToPDF() async {
    try {
      // Fetch all data
      final medications = await _databaseHelper.getMedications();
      final schedules = await _databaseHelper.getSchedules();
      final prescriptions = await _databaseHelper.getPrescriptions();

      // TODO: Implement PDF generation
      // This would require a PDF generation package like pdf or printing
      
      final directory = await getApplicationDocumentsDirectory();
      final date = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/medical_report_$date.pdf';

      return filePath;
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  Future<Map<String, dynamic>> importData(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  Future<String> generateCSVReport() async {
    try {
      final medications = await _databaseHelper.getMedications();
      final directory = await getApplicationDocumentsDirectory();
      final date = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/medications_$date.csv';

      final file = File(filePath);
      final buffer = StringBuffer();

      // Write headers
      buffer.writeln('Name,Active Ingredients,Dosage,Manufacturer,Expiry Date');

      // Write data
      for (final med in medications) {
        buffer.writeln(
          '${med.name},${med.activeIngredients},${med.dosage},${med.manufacturer},${med.expiryDate}',
        );
      }

      await file.writeAsString(buffer.toString());
      return filePath;
    } catch (e) {
      throw Exception('Failed to generate CSV report: $e');
    }
  }
}
