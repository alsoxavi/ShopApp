import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';
import '../widgets/order_screen_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Orders',
          ),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                // Error handling logic
                return Center(
                  child: Text('An error ocurred!'),
                );
              } else {
                return Consumer<OrdersProvider>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, i) => OrderScreenItem(
                      orderData.orders[i],
                    ),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          },
        ));
  }
}

// @override //REEMPLAZADO POR FUTURE BUILDER
  // void initState() {
  //   _isLoading = true;
  //   Provider.of<OrdersProvider>(context, listen: false).fetchOrders().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }