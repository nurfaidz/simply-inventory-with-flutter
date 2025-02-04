import 'package:flutter/material.dart';
import '../api/auth_service.dart';

class AuthProvider with ChangeNotifier{
  final AuthService _authService = AuthService();
  String? _token;

  String? get token => _token;

  Future<bool> register(String username, String email, String password) async {
    bool success = await _authService.register(username, email, password);
    if (success) {
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> login(String email, String password) async {
    String? token = await _authService.login(email, password);
    if (token != null) {
      _token = token;
      notifyListeners();
      return true;
    }

    return false;
  }
}