import 'package:flutter/material.dart';

class CartItem {
  final String userId;       // Payee's ID
  final int priceInCents;    // Price per unit
  int quantity;              // Number of units

  CartItem({
    required this.userId,
    required this.priceInCents,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {}; // key: userId

  Map<String, CartItem> get items => _items;

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  int get totalPriceInCents =>
      _items.values.fold(0, (sum, item) => sum + (item.priceInCents * item.quantity));

  void addItem({required String userId, required int priceInCents}) {
    if (_items.containsKey(userId)) {
      _items[userId]!.quantity += 1;
    } else {
      _items[userId] = CartItem(userId: userId, priceInCents: priceInCents);
    }
    notifyListeners();
  }

  void updateQuantity(String userId, int quantity) {
    if (_items.containsKey(userId)) {
      _items[userId]!.quantity = quantity;
      notifyListeners();
    }
  }

  void removeItem(String userId) {
    _items.remove(userId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
