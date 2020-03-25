import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/model/providers/orders.dart' as data;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String ROUTE = '/Orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: ListViewWidget(),
      drawer: AppDrawer(),
    );
  }
}

class ListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<data.Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(
              child: Text('An error occured'),
            );
          }
          return Consumer<data.Orders>(
              builder: (ctx, orders, child) => ListView.builder(
                    itemCount: orders.size,
                    itemBuilder: (context, idx) => OrderItem(orders.items[idx]),
                  ));
        });
  }
}
