import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.getDio();

  Future<bool> register(String username, String email, String password) async {
    try {
      Response response = await _dio.post('/users/register', data: {
        'username' : username,
        'email' : email,
        'password' : password,
      });

      if (response.statusCode == 201) {
        return true;
      }
    } on DioException catch (e) {
      print("Register error: ${e.response?.data}");
    }

    return false;
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      Response response = await _dio.post('/users/login', data: {
        'email' : email,
        'password' : password,
      });

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);

        return {
          'token' : response.data['token'],
          'user' : response.data['user'],
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Login error: ${e.response?.data}");
      } else {
        print("Login error: ${e.message}");
      }
    }

    return null;
  }

  Future<bool> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return false;
      }

      Response response = await _dio.post('/users/logout', options: Options(
        headers: {
          'Authorization' : 'Bearer $token',
        }
      ));

      if (response.statusCode == 200) {
        await prefs.remove('token');
        return true;
      }

      return false;
    } catch (e) {
        print("Logout error: $e");
        return false;
    }
  }
}
