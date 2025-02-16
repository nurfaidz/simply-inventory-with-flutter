import 'package:dio/dio.dart';
import '../api/api_client.dart';

class OutgoingItemService {
  final Dio _dio = ApiClient.getDio();

  Future<List<dynamic>> getOutgoingItems(String token) async {
    try {
      final response = await _dio.get('/outgoing-items', options: Options(headers: {
        'Authorization' : 'Bearer $token',
      }));

      if (response.statusCode == 200) {
        print("Data outgoing items: ${response.data}");
        return response.data;
      }
    } catch (e) {
      print("Error fetching outgoing items: $e");
    }

    return [];
  }

  Future<Map<String, dynamic>?> getOutgoingItemById(String token, String outgoingItemId) async {
    try {
      final response = await _dio.get('/outgoing-items/$outgoingItemId', options: Options(headers: {
        'Authorization' : 'Bearer $token',
      }));

      if (response.statusCode == 200) {
        print("Data outgoing item: ${response.data}");
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching outgoing item by id: $e");
    }

    return null;
  }

  Future<Response?> createOutgoingItem(String token, Map<String, dynamic> outgoingItemData) async {
    try {
      return await _dio.post('/outgoing-items/', data: outgoingItemData, options: Options(
        headers: {
          'Authorization' : 'Bearer $token',
          'Content-Type' : 'application/json',
        }
      ));
    } on DioException catch (e) {
      print("Error create outgoing item: ${e.response?.statusCode} - ${e.message}");
      return e.response;
    }
  }

  Future<Response> updateOutgoingItem(String token, String outgoingItemId, Map<String, dynamic> outgoingItemData) async {
    try {
      return await _dio.put('/outgoing-items/$outgoingItemId', data: outgoingItemData, options: Options(
        headers: {
          'Authorization' : 'Bearer $token',
        }
      ));
    } catch (e) {
      print("Error updating outgoing: $e");
      return Response(requestOptions: RequestOptions(path: ''), statusCode: 500);
    }
  }

  Future<Response> deleteOutgoingItem(String token, String outgoingItemId) async {
    return await _dio.delete('/outgoing-items/$outgoingItemId', options: Options(headers: {'Authorization': 'Bearer $token'}));
    }
}