import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Dio getDio() {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    return dio;
  }
}