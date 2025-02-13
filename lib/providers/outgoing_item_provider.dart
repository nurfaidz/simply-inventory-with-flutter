import 'package:flutter/material.dart';
import '../api/outgoing_item_service.dart';

class OutgoingItemProvider with ChangeNotifier {
  final OutgoingItemService _outgoingItemService = OutgoingItemService();

  List<dynamic> _outgoingItems = [];
  Map<String, dynamic>? _outgoingItemDetail;
  bool _isLoading = false;

  List<dynamic> get outgoingItems => _outgoingItems;
  Map<String, dynamic>? get outgoingItemDetail => _outgoingItemDetail;
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
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _outgoingItemService.getOutgoingItemById(token, outgoingItemId);
      if (response != null) {
        _outgoingItemDetail = response;
      } else {
        _outgoingItemDetail = null;
      }
    } catch (e) {
      print('Error fetching outgoing item by id: $e');
      _outgoingItemDetail = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createOutgoingItem(String token, Map<String, dynamic> outgoingItemData) async {
    try {
      final response = await _outgoingItemService.createOutgoingItem(token, outgoingItemData);

      print('Response: $response');

      if (response != null && response.statusCode == 200) {
        _outgoingItems.add(response.data);
        notifyListeners();
        return true;
      } else {
        return false;
      }

    } catch (e) {
      print('Error creating outgoing item: $e');
      return false;
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
