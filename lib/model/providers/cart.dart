import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get count {
    return _items.length;
  }

  double get totatPrice {
    double total = 0;

    _items.forEach((id, item) => total += item.price * item.quantity);

    return total;
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items[id].quantity++;
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }

    if (_items[id].quantity > 1) {
      _items.update(
          id,
          (item) => CartItem(
              id: item.id,
              title: item.title,
              price: item.price,
              quantity: item.quantity - 1));
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
