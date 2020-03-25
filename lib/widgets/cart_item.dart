import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final String productId;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.quantity,
      @required this.price});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16)),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Dissmiss confirmation'),
                  content: Text('Are you sure you want to cancel this order ?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    )
                  ],
                ));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                  child: FittedBox(
                child: Padding(
                    padding: EdgeInsets.all(8), child: Text('\$$price')),
              )),
              title: Text(title),
              subtitle: Text('Total \$${price * quantity}'),
              trailing: Text('${quantity}x'),
            ),
          ),
        ),
      ),
    );
  }
}
