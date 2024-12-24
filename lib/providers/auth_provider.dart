import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _authService.login(email, password);
      if (success) {
        // TODO: Fetch and set user data
        _user = User(
          userId: 'dummy_id',
          name: 'Test User',
          email: email,
          phoneNumber: '',
          medicationList: [],
        );
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      return await _authService.register(name, email, password);
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = await _authService.getToken();
    if (token != null) {
      // TODO: Fetch and set user data
      _user = User(
        userId: 'dummy_id',
        name: 'Test User',
        email: 'test@example.com',
        phoneNumber: '',
        medicationList: [],
      );
      notifyListeners();
    }
  }
}
