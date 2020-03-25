import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/model/providers/cart.dart';

import 'package:http/http.dart' as http;

class OrderItem {
  OrderItem({this.id, this.products, this.price, this.date});

  int get amount {
    return products.length;
  }

  String id;
  List<CartItem> products;
  double price;
  DateTime date;
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  String _token = '';

  List<OrderItem> get items {
    return [..._items];
  }

  int get size {
    return _items.length;
  }

  Orders(this._token, this._items);

  Future<void> fetchOrders() async {
    if (_items.isNotEmpty) {
      return;
    }

    try {
      final url =
          'https://flutter-shop-app-46df4.firebaseio.com/orders.json?auth=$_token';

      final data = await http.get(url);
      final fetched = json.decode(data.body) as Map<String, dynamic>;
      print(fetched.toString());
      _items.clear();

      if (fetched != null) {
        fetched.forEach((key, value) {
          List<dynamic> items = value['items'];
          List<CartItem> cartItems = items
              .map((dynamic item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  title: item['title'],
                  quantity: item['quantity']))
              .toList();

          _items.add(OrderItem(
              id: key,
              price: value['price'],
              products: cartItems,
              date: DateTime.parse(value['date'])));

          _items = _items.reversed.toList();
        });
        notifyListeners();
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addItem(List<CartItem> items, double price) async {
    final timeStamp = DateTime.now();

    try {
      final url =
          'https://flutter-shop-app-46df4.firebaseio.com/orders.json?auth=$_token';

      final response = await http.post(url,
          body: json.encode({
            'price': price,
            'date': timeStamp.toIso8601String(),
            'items': items
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'quantity': item.quantity,
                      'price': item.price,
                    })
                .toList()
          }));
      print('responce : ' + response.body);
      _items.add(OrderItem(
          id: json.decode(response.body)['name'],
          price: price,
          date: DateTime.now(),
          products: items));
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
