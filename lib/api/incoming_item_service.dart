import 'package:dio/dio.dart';
import '../api/api_client.dart';

class IncomingItemService {
  final Dio _dio = ApiClient.getDio();

  Future<List<dynamic>> getIncomingItems(String token) async {
    try {
      final response = await _dio.get('/incoming-items',
      options: Options(headers: {
        'Authorization' : 'Bearer $token',
      }));

      if (response.statusCode == 200) {
        print("Data incoming items: ${response.data}");
        return response.data;
      }
    } catch (e) {
      print("Error fetching incoming items: $e");
    }

    return [];
  }

  Future<Map<String, dynamic>?> getIncomingItemById(String token, String incomingItemId) async {
    try {
      final response = await _dio.get('/incoming-items/$incomingItemId', options: Options(headers: {
        'Authorization' : 'Bearer $token',
      }));

      if (response.statusCode == 200) {
        print("Data incoming item: ${response.data}");
        return response.data as Map<String,dynamic>;
      }
    } catch (e) {
      print("Error fetching incoming item by id: $e");
    }

    return null;
  }

  Future<Response?> createIncomingItem(String token, Map<String, dynamic> incomingItemData) async {
    try {
      return await _dio.post('/incoming-items/', data: incomingItemData, options: Options(headers: {
        'Authorization' : 'Bearer $token',
        'Content-Type' : 'application/json',
      }));
    } on DioException catch (e) {
      print("Error create incoming item: ${e.response?.statusCode} - ${e.message}");
      return e.response;
    }
  }

  Future<Response> updateIncomingItem(String token, String incomingItemId, Map<String, dynamic> incomingItemData) async {
    try {
      return await _dio.put('/incoming-items/$incomingItemId', data: incomingItemData, options: Options(
        headers: {
          'Authorization' : 'Bearer $token',
        }
      ));
    } catch (e) {
      print("Error updating incoming: $e");
      return Response(requestOptions: RequestOptions(path: ''), statusCode: 500);
    }
  }

  Future<Response> deleteIncomingItem(String token, String incomingItemId) async {
    return await _dio.delete('/incoming-items/$incomingItemId',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }
}