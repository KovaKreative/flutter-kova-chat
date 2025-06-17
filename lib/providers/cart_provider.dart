import 'package:flutter/material.dart';

class CartItem {
  final String user; // This will be replaced with the Stripe ID at checkout
  final int priceInCents;
  int quantity;

  CartItem({required this.user, required this.priceInCents, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {'user': user, 'priceInCents': priceInCents, 'quantity': quantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      user: json['user'],
      priceInCents: json['priceInCents'],
      quantity: json['quantity'] ?? 1,
    );
  }
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  int get totalPriceInCents => _items.values.fold(
    0,
    (sum, item) => sum + (item.priceInCents * item.quantity),
  );

  void addItem({required String user, required int priceInCents}) {
    if (_items.containsKey(user)) {
      _items[user]!.quantity += 1;
    } else {
      _items[user] = CartItem(user: user, priceInCents: priceInCents);
    }
    notifyListeners();
  }

  void updateQuantity(String user, int quantity) {
    if (_items.containsKey(user)) {
      _items[user]!.quantity = quantity;
      notifyListeners();
    }
  }

  void removeItem(String user) {
    _items.remove(user);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
