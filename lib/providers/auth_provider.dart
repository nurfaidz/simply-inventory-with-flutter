import 'package:flutter/material.dart';
import '../api/auth_service.dart';

class AuthProvider with ChangeNotifier{
  final AuthService _authService = AuthService();
  String? _token;
  String? get token => _token;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  Future<bool> register(String username, String email, String password) async {
    bool success = await _authService.register(username, email, password);
    if (success) {
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> login(String email, String password) async {
    Map<String, dynamic>? response = await _authService.login(email, password);

    if (response != null) {
      _token = response['token'];
      _user = response['user'];
      notifyListeners();
      return true;
    }

    return false;
  }
}