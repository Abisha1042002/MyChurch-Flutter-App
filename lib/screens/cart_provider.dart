import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void updateQuantity(Map<String, dynamic> product, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(product);
    } else {
      final index = _cartItems.indexWhere((item) => item['id'] == product['id']);
      if (index != -1) {
        _cartItems[index]['quantity'] = newQuantity;
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}