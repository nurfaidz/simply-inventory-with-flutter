import 'package:flutter/material.dart';
import '../api/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<dynamic> _products = [];
  Map<String, dynamic>? _productDetail;
  bool _isLoading = false;

  List<dynamic> get products => _products;
  Map<String, dynamic>? get productDetail => _productDetail;
  bool get isLoading => _isLoading;

  Future<void> getProducts(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> response = await _productService.getProducts(token);
      print("Products: $response");
      _products = response;
    } catch(e) {
      print("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getProductById(String token, String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _productService.getProductById(token, productId);
      if (response != null) {
        _productDetail = response;
      } else {
        _productDetail = null;
      }
    } catch(e) {
      print("Error fetching product: $e");
      _productDetail = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createProduct(String token, Map<String, dynamic> productData) async {
    try {
      final response = await _productService.createProduct(token, productData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _products.add(response.data);
        notifyListeners();
        return true;
      }
    } catch(e) {
      print("Error adding product: $e");
    }
    return false;
  }

  Future<bool> updateProduct(String token, String productId, Map<String, dynamic> productData) async {
    try {
      final response = await _productService.updateProduct(token, productId, productData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final index = _products.indexWhere((product) => product['_id'] == productId);
        if (index != -1) {
          _products[index] = response.data;
          notifyListeners();
        }

        return true;
      }
    } catch(e) {
      print("Error updating product: $e");
    }

    return false;
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