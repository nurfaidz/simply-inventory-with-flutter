import 'package:dio/dio.dart';
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
}
