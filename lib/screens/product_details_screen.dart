import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/product.dart';
import 'package:shop_app/model/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String ROUTE = "/ProductDetailScreen";

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context, listen: false);
    final id = ModalRoute.of(context).settings.arguments as String;
    Product product = products.findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 300,
              width: double.infinity,
              child: Image.network(product.imageUrl, fit: BoxFit.cover)),
          SizedBox(
            width: 24,
          ),
            Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 24, left: 16, bottom: 16),
                  child: Text(product.title,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Anton',
                          fontStyle: FontStyle.italic))),
          Divider(
            thickness: 2.0,
          ),
          Container(
              padding: EdgeInsets.only(left: 16,),
              alignment: Alignment.centerLeft,
              child: Text(product.description,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nano')))
        ],
      ),
    );
  }
}
