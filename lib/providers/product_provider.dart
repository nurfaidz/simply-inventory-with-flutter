import 'package:flutter/material.dart';
import '../api/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<dynamic> _products = [];
  bool _isLoading = false;

  List<dynamic> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> getProducts(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _productService.getProducts(token);
      if (response.statusCode == 200) {
        _products = response.data;
      }
    } catch(e) {
      print("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createProduct(String token, Map<String, dynamic> productData) async {
    try {
      final response = await _productService.createProduct(token, productData);
      if (response.statusCode == 201) {
        _products.add(response.data);
        notifyListeners();
      }
    } catch(e) {
      print("Error adding product: $e");
    }
  }

  Future<void> updateProduct(String token, String productId, Map<String, dynamic> productData) async {
    try {
      final response = await _productService.updateProduct(token, productId, productData);
      if (response.statusCode == 200) {
        final index = _products.indexWhere((product) => product['_id'] == productId);
        _products[index] = response.data;
        notifyListeners();
      }
    } catch(e) {
      print("Error updating product: $e");
    }
  }

  Future<void> deleteProduct(String token, String productId) async {
    try {
      await _productService.deleteProduct(token, productId);
      _products.removeWhere((product) => product['_id'] == productId);
      notifyListeners();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }
}