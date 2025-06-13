import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;

  CartItem({required this.id, required this.name, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  void addItem(CartItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id] = CartItem(
        id: item.id,
        name: item.name,
        quantity: _items[item.id]!.quantity + 1,
      );
    } else {
      _items[item.id] = item;
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      _items[id] = CartItem(
        id: id,
        name: _items[id]!.name,
        quantity: quantity,
      );
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
