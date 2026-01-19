import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/shared_prefs.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  User? _user;
  User? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> loadUser() async {
    _user = await SharedPrefs.getUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final user = await _service.login(email, password);
    if (user != null) {
      _user = user;
      await SharedPrefs.saveUser(user);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _user = null;
    await SharedPrefs.clear();
    notifyListeners();
  }
}
