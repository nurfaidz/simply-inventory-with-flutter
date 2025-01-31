import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:8080';

  static Dio getDio() {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    return dio;
  }
}