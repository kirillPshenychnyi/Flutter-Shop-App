import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/auth.dart';
import 'package:shop_app/model/providers/cart.dart';

import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/model/providers/product.dart';

class ProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context, listen: false);
    Cart cart = Provider.of<Cart>(context, listen: false);

    ScaffoldState scaffoldState = Scaffold.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailsScreen.ROUTE, arguments: product.id),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Container(
              width: 60, child: FittedBox(fit: BoxFit.contain, child: Text(product.title))),
          leading: Consumer<Product>(
            builder: (context, innerProduct, _) => IconButton(
              icon: Icon(innerProduct.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toogleIsFavourite(Provider.of<Auth>(context, listen: false).token).catchError(
                  (error) {
                    scaffoldState.showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                      )
                    );
                  } 
                );
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Item has been added!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
