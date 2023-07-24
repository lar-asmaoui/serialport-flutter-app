import 'package:flutter/foundation.dart';
import 'package:weight_calculator/models/cart_item.dart';

class CartController extends ChangeNotifier {
  final _items = [];
  get items => _items;

  void addBag(weight) {
    if (weight <= 0.0) {
      return;
    }
    CartItem newCartItem = CartItem(
      id: DateTime.now().toString(),
      weight: weight,
    );
    _items.add(newCartItem);
    notifyListeners();
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  double get totalWeight {
    double total = 0;
    for (var item in items) {
      total += item.weight;
    }

    return total;
  }
}
