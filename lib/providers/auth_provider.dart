import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../features/user_crud/models/user_model.dart';
import '../features/register/services/auth_service.dart';
import '../utils/shared_prefs.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  bool _tokenExpired = false;

  bool get tokenExpired => _tokenExpired;
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

  void checkResponse(BuildContext context, http.Response response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      _tokenExpired = true;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session habis, silakan login kembali"),
          backgroundColor: Colors.red,
        ),
      );

      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session ok"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> logout() async {
    _user = null;
    await SharedPrefs.clear();
    notifyListeners();
  }
}
