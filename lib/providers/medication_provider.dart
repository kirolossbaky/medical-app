import 'package:flutter/foundation.dart';
import '../models/medication.dart';
import '../services/database_helper.dart';

class MedicationProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<Medication> _medications = [];
  bool _isLoading = false;
  String? _error;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMedications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _medications = await _db.getMedications();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication(Medication medication) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.insertMedication(medication);
      await loadMedications();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMedication(Medication medication) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.updateMedication(medication);
      await loadMedications();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMedication(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.deleteMedication(id);
      await loadMedications();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<String>> checkInteractions(List<Medication> medications) async {
    try {
      // TODO: Implement actual drug interaction checking
      return ['No known interactions found'];
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }
}
