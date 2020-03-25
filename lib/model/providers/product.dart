import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/model/providers/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toogleIsFavourite(String token) async {
    try {
      String url = 'https://flutter-shop-app-46df4.firebaseio.com/products/$id.json?auth=$token';

      await http.patch(url, body: json.encode({'isFavorite': !isFavourite}));
      isFavourite = !isFavourite;
      notifyListeners();
    } catch (exception) {
      throw new HttpException('Update failed');
    }
  }
}
