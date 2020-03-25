import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/cart.dart';
import 'package:shop_app/model/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum Filter { All, Favourites }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _selectFavs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton<Filter>(
            onSelected: (Filter selected) {
              setState(() => _selectFavs = selected == Filter.Favourites);
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: PopupMenuItem(
                  child: Text("Show all"),
                  value: Filter.All,
                ),
              ),
              PopupMenuItem(
                child: PopupMenuItem(
                  child: Text("Show Favourites"),
                  value: Filter.Favourites,
                ),
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(value: cart.count.toString(), child: ch),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.ROUTE);
              },
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false).fetch(),
          builder: (ctx, state) {
            if (state.connectionState == ConnectionState.active) {
              return Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(
                child: Text('Error ocurred'),
              );
            } else {
              return Consumer<Products>(
                builder: (_, __, ___) => ProductsGrid(_selectFavs),
              );
            }
          }),
      drawer: AppDrawer(),
    );
  }
}
