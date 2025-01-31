import 'package:flutter/material.dart';
import '../api/auth_service.dart';

class AuthProvider with ChangeNotifier{
  final AuthService _authService = AuthService();

  Future<void> register(String username, String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      if (response.statusCode == 200) {
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      if (response.statusCode == 200) {
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}