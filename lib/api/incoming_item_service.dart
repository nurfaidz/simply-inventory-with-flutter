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

  Future<Response> getIncomingItemById(String token, String incomingItemId) async {
    return await _dio.get('/incoming-items/$incomingItemId', options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> createIncomingItem(String token, Map<String, dynamic> data) async {
    return await _dio.post('incoming-items', data: data, options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> updateIncomingItem(String token, String incomingItemId, Map<String, dynamic> data) async {
    return await _dio.put('/incoming-items/$incomingItemId', data: data, options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> deleteIncomingItem(String token, String incomingItemId) async {
    return await _dio.delete('/incoming-items/$incomingItemId',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }
}