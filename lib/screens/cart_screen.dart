import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/model/providers/cart.dart' show Cart;
import 'package:shop_app/model/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class CartScreen extends StatelessWidget {
  static const String ROUTE = "/CART_SCREEN";

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    final values = cart.items.values.toList();
    final keys = cart.items.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totatPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .title
                                .color)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  new SubmitOdersButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.count,
            itemBuilder: (context, idx) {
              var item = values[idx];
              return CartItem(
                id: item.id,
                productId: keys[idx],
                price: item.price,
                title: item.title,
                quantity: item.quantity,
              );
            },
          ))
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}

class SubmitOdersButton extends StatefulWidget {
  const SubmitOdersButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _SubmitOdersButtonState createState() => _SubmitOdersButtonState();
}

class _SubmitOdersButtonState extends State<SubmitOdersButton> {
  bool _isSubmiting = false;

  void _setSubmiting(bool state) {
    setState(() {
      _isSubmiting = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldState state = Scaffold.of(context);
    return FlatButton(
      child: _isSubmiting
          ? CircularProgressIndicator()
          : Text('Order now',
              style: TextStyle(color: Theme.of(context).primaryColor)),
      onPressed: widget.cart.items.isEmpty || _isSubmiting
          ? null
          : () async {
              _setSubmiting(true);
              Provider.of<Orders>(context, listen: false)
                  .addItem(
                      widget.cart.items.values.toList(), widget.cart.totatPrice)
                  .then((onValue) {
                widget.cart.clear();
                _setSubmiting(false);
              }).catchError((_) {
                _setSubmiting(false);
                state.showSnackBar(SnackBar(
                  content: Text('Something went wrong'),
                ));
              });
            },
    );
  }
}
