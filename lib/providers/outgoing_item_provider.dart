import 'package:flutter/material.dart';
import '../api/outgoing_item_service.dart';

class OutgoingItemProvider with ChangeNotifier {
  final OutgoingItemService _outgoingItemService = OutgoingItemService();
  List<dynamic> _outgoingItems = [];
  Map<String, dynamic>? _incomingItemDetail;
  bool _isLoading = true;

  List<dynamic> get outgoingItems => _outgoingItems;
  Map<String, dynamic>? get incomingItemDetail => _incomingItemDetail;
  bool get isLoading => _isLoading;

  Future<void> getOutgoingItems(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> response = await _outgoingItemService.getOutgoingItems(token);
      print('Outgoing items: $response');
      _outgoingItems = response;
    } catch (e) {
      print('Error fetching outgoing items: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getOutgoingItemById(String token, String outgoingItemId) async {
    try {
      final response = await _outgoingItemService.getOutgoingItemById(token, outgoingItemId);
      if (response.statusCode == 200) {
        _outgoingItems.add(response.data);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching outgoing item by id: $e');
    }
  }

  Future<void> createOutgoingItem(String token, Map<String, dynamic> outgoingItemData) async {
    try {
      final response = await _outgoingItemService.createOutgoingItem(token, outgoingItemData);
      if (response.statusCode == 201) {
        _outgoingItems.add(response.data);
        notifyListeners();
      }
    } catch (e) {
      print('Error adding outgoing item: $e');
    }
  }

  Future<void> updateOutgoingItem(String token, String outgoingItemId, Map<String, dynamic> outgoingItemData) async {
    try {
      final response = await _outgoingItemService.updateOutgoingItem(token, outgoingItemId, outgoingItemData);

      if (response.statusCode == 200) {
        final index = _outgoingItems.indexWhere((outgoingItem) => outgoingItem['_id'] == outgoingItemId);
        _outgoingItems[index] = response.data;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating outgoing item: $e');
    }
  }

  Future<void> deleteOutgoingItem(String token, String outgoingItemId) async {
    try {
      await _outgoingItemService.deleteOutgoingItem(token, outgoingItemId);
      _outgoingItems.removeWhere((outgoingItem) => outgoingItem['_id'] == outgoingItemId);
      notifyListeners();
    } catch (e) {
      print('Error deleting outgoing item: $e');
    }
  }
}
