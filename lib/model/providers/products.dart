import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shop_app/model/providers/exceptions/http_exception.dart';

import 'product.dart';

import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String _token;

  List<Product> _products = [];

  List<Product> get items {
    return [..._products];
  }

  int get size {
    return _products.length;
  }

  List<Product> get favouriteItems {
    return _products.where((item) => item.isFavourite).toList();
  }

  Products(this._token, this._products);

  Future<void> fetch() async {
    try {
      final String _url =
          'https://flutter-shop-app-46df4.firebaseio.com/products.json?auth=$_token';

      final data = await http.get(_url);
      final fetched = json.decode(data.body) as Map<String, dynamic>;
      _products.clear();

      if (fetched != null) {
        fetched.forEach((key, value) {
          _products.add(
            Product(
                id: key,
                title: value['title'],
                isFavourite: value['isFavorite'],
                description: value['description'],
                imageUrl: value['imageUrl'],
                price: value['price']),
          );
        });
        notifyListeners();
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addItem(
      String title, String description, String imageUrl, double price) async {
    try {
      final String _url =
          'https://flutter-shop-app-46df4.firebaseio.com/products.json?auth=$_token';

      var response = await http.post(_url,
          body: json.encode({
            'title': title,
            'description': description,
            'price': price,
            'imageUrl': imageUrl,
            'isFavorite': false
          }));

      _products.add(Product(
          id: json.decode(response.body)['name'],
          description: description,
          title: title,
          price: price,
          imageUrl: imageUrl));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(String id, String title, String description,
      String imageUrl, double price) async {
    int idx = _products.indexWhere((product) => product.id == id);

    assert(idx != -1);

    final url =
        'https://flutter-shop-app-46df4.firebaseio.com/products/$id.json?auth=$_token';
    print('update $imageUrl');
    await http.patch(url,
        body: json.encode({
          'title': title,
          'description': description,
          'price': price,
          'imageUrl': imageUrl
        }));

    _products[idx] = Product(
        id: id,
        description: description,
        title: title,
        price: price,
        isFavourite: _products[idx].isFavourite,
        imageUrl: imageUrl);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    final deleteURL =
        'https://flutter-shop-app-46df4.firebaseio.com/products/$id.json';

    final response = await http.delete(deleteURL);

    if (response.statusCode >= 400) {
      throw HttpException('Failed to delete the product');
    }

    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}
