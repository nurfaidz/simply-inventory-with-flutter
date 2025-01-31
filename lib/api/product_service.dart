import 'package:dio/dio.dart';
import '../api/api_client.dart';

class ProductService {
  final Dio _dio = ApiClient.getDio();

  Future<Response> getProducts(String token) async {
    return await _dio.get('/products',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  Future<Response> getProductById(String token, String productId) async {
    return await _dio.get('/products/$productId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  Future<Response> createProduct(
      String token, Map<String, dynamic> productData) async {
    return await _dio.post('/products/',
        data: productData,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> updateProduct(
      String token, String productId, Map<String, dynamic> productData) async {
    return await _dio.put('/products/$productId',
        data: productData,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> deleteProduct(String token, String productId) async {
    return await _dio.delete('/products/$productId',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }
}
