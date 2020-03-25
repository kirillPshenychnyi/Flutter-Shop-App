import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/model/providers/orders.dart' as data;

class OrderItem extends StatefulWidget {
  final data.OrderItem item;

  OrderItem(this.item);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.item.price}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.item.date)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
                height: min(widget.item.amount * 20.0 + 10, 200),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListView(
                    children: widget.item.products
                        .map((item) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  item.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${item.quantity}x \$${item.price}',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ))
                        .toList()))
        ],
      ),
    );
  }
}
