import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProduct(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit,
                  color: Theme.of(context).textTheme.title.color),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.ROUTE, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                Provider.of<Products>(context).remove(id).catchError((erro) {
                  scaffold.showSnackBar(SnackBar(
                      content: Text('Failed to remove item!'),
                      duration: Duration(seconds: 1)));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
