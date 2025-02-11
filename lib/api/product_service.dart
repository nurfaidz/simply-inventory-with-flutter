import 'package:dio/dio.dart';
import '../api/api_client.dart';

class ProductService {
  final Dio _dio = ApiClient.getDio();

  Future<List<dynamic>> getProducts(String token) async {
    try {
      final response = await _dio.get('/products',
          options: Options(headers: {
            'Authorization' : 'Bearer $token',
          }));

      if (response.statusCode == 200) {
        print("Data products: ${response.data}");
        return response.data;
      }
    } catch(e) {
      print("Error fetching products: $e");
    }

    return [];
  }

  Future<Map<String, dynamic>?> getProductById(String token, String productId) async {
    try {
      final response = await _dio.get('/products/$productId', options: Options(headers: {
        'Authorization' : 'Bearer $token',
      }));

      if (response.statusCode == 200) {
        print("Data product: ${response.data}");
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching product: $e");
    }

    return null;
  }

  Future<Response> createProduct(
      String token, Map<String, dynamic> productData) async {
    try {
      return await _dio.post('/products/', data: productData, options: Options(headers: {
        'Authorization' : 'Bearer $token',
      }));
    } catch (e) {
      print("Error adding product: $e");
    }

    return Response(requestOptions: RequestOptions(path: ''));
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
