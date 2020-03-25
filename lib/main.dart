import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/auth.dart';
import 'package:shop_app/model/providers/orders.dart';
import 'package:shop_app/model/providers/product.dart';
import 'package:shop_app/model/providers/products.dart';
import 'package:shop_app/model/providers/cart.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';

import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (ctx) => Products("", []),
              update: (ctx, auth, prev) =>
                  Products(auth.token, prev == null ? [] : prev.items)),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders("", []),
            update: (ctx, auth, prev) => Orders(auth.token, prev == null ? [] : prev.items),
          )
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                  title: 'MyShop',
                  theme: ThemeData(
                      primarySwatch: Colors.deepOrange,
                      accentColor: Colors.pink,
                      fontFamily: "Anton"),
                  home: auth.isAuthanticated
                      ? ProductOverviewScreen()
                      : AuthScreen(),
                  routes: {
                    ProductDetailsScreen.ROUTE: (ctx) => ProductDetailsScreen(),
                    OrdersScreen.ROUTE: (ctx) => OrdersScreen(),
                    CartScreen.ROUTE: (ctx) => CartScreen(),
                    UserProductsScreen.ROUTE: (ctx) => UserProductsScreen(),
                    EditProductScreen.ROUTE: (ctx) => EditProductScreen()
                  },
                )));
  }
}
