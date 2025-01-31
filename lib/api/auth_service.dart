import 'package:dio/dio.dart';
import '../api/api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.getDio();

  Future<Response> register(String username, String email, String password) async {
    return await _dio.post('/users/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<Response> login(String email, String password) async {
    return await _dio
        .post('/users/login', data: {'email': email, 'password': password});
  }
}
