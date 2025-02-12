import 'package:flutter/material.dart';
import '../api/incoming_item_service.dart';

class IncomingItemProvider with ChangeNotifier {
  final IncomingItemService _incomingItemService = IncomingItemService();

  List<dynamic> _incomingItems = [];
  Map<String, dynamic>? _incomingItemDetail;
  bool _isLoading = false;

  List<dynamic> get incomingItems => _incomingItems;
  Map<String, dynamic>? get incomingItemDetail => _incomingItemDetail;
  bool get isLoading => _isLoading;

  Future<void> getIncomingItems(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> response =
          await _incomingItemService.getIncomingItems(token);
      print("Incoming items: $response");
      _incomingItems = response;
    } catch (e) {
      print('Error fetching incoming items: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getIncomingItemById(String token, String incomingItemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _incomingItemService.getIncomingItemById(token, incomingItemId);
      if (response != null) {
        _incomingItemDetail = response;
      } else {
        _incomingItemDetail = null;
      }
    } catch (e) {
      print('Error fetching incoming item by id: $e');
      _incomingItemDetail = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createIncomingItem(
      String token, Map<String, dynamic> incomingItemData) async {
    try {
      final response = await _incomingItemService.createIncomingItem(
          token, incomingItemData);

      if (response != null && response.statusCode == 200) {
        _incomingItems.add(response.data);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error adding incoming item: $e.response');
    }
    return false;
  }

  Future<void> updateIncomingItem(String token, String incomingItemId,
      Map<String, dynamic> incomingItemData) async {
    try {
      final response = await _incomingItemService.updateIncomingItem(
          token, incomingItemId, incomingItemData);
      if (response.statusCode == 200) {
        final index = _incomingItems.indexWhere(
            (incomingItem) => incomingItem['_id'] == incomingItemId);
        _incomingItems[index] = response.data;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating incoming item: $e');
    }
  }

  Future<void> deleteIncomingItem(String token, String incomingItemId) async {
    try {
      await _incomingItemService.deleteIncomingItem(token, incomingItemId);
      _incomingItems
          .removeWhere((incomingItem) => incomingItem['_id'] == incomingItemId);
      notifyListeners();
    } catch (e) {
      print('Error deleting incoming item: $e');
    }
  }
}
