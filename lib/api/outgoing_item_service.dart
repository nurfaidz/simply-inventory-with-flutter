import 'package:dio/dio.dart';
import '../api/api_client.dart';

class OutgoingItemService {
  final Dio _dio = ApiClient.getDio();

  Future<Response> getOutgoingItems(String token) async {
    return await _dio.get('/outgoing-items', options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> getOutgoingItemById(String token, String outgoingItemId) async {
    return await _dio.get('/outgoing-items/$outgoingItemId', options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> createOutgoingItem(String token, Map<String, dynamic> data) async {
    return await _dio.post('/outgoing-items', data: data, options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> updateOutgoingItem(String token, String outgoingItemId, Map<String, dynamic> data) async {
    return await _dio.put('/outgoin-items/$outgoingItemId', data: data, options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> deleteOutgoingItem(String token, String outgoingItemId) async {
    return await _dio.delete('/outgoing-items/$outgoingItemId', options: Options(headers: {'Authorization': 'Bearer $token'}));
    }
}