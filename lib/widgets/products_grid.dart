import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/products.dart';
import 'package:shop_app/widgets/product_view.dart';

class ProductsGrid extends StatelessWidget {
  final bool selectFavs;
  
  ProductsGrid(this.selectFavs);
  
  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    final productsList = selectFavs ? products.favouriteItems : products.items;

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemBuilder: (ctx, idx) {
        return ChangeNotifierProvider.value(
          value: productsList[idx],
          child: ProductView(),
        );
      },
      itemCount: productsList.length,
    );
  }
}
