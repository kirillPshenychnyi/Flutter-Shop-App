import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product.dart';

class UserProductsScreen extends StatelessWidget {
  static const String ROUTE = '/USER_PRODUCTS';

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetch();
  }

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.ROUTE);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (
              _,
              idx,
            ) =>
                Column(
                  children: <Widget>[
                    UserProduct(products[idx].id, products[idx].title, products[idx].imageUrl),
                    Divider()
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
