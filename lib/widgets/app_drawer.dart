import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget tile(
      BuildContext context, IconData iconData, String title, String route) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          tile(context, Icons.shop, 'Shop', '/'), 
          tile(context, Icons.payment, 'Orders', OrdersScreen.ROUTE),
          tile(context, Icons.payment, 'My Products', UserProductsScreen.ROUTE),
        ],
      ),
    );
  }
}
