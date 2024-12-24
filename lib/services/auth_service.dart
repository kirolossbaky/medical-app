import 'package:shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toJson().toString());
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<bool> login(String email, String password) async {
    try {
      // TODO: Implement actual API login
      await Future.delayed(const Duration(seconds: 1));
      await saveToken('dummy_token');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      // TODO: Implement actual API registration
      await Future.delayed(const Duration(seconds: 1));
      await saveToken('dummy_token');
      return true;
    } catch (e) {
      return false;
    }
  }
}
