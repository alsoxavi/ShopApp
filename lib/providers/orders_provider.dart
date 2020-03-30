import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './shopping_cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<ShoppingCartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }  
  final String authToken;

  OrdersProvider(this.authToken, this._orders);

  Future<void> addOrder(List<ShoppingCartItem> cartProducts, double total) async {
    final url = 'https://shopflutterapp.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': double.parse(total.toStringAsFixed(2)),
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          },
        ),
      );

      final newOrder = OrderItem(
        id: json.decode(response.body)['name'],
        amount: double.parse(total.toStringAsFixed(2)),
        dateTime: timestamp,
        products: cartProducts,
      );

      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchOrders() async {
    final url = 'https://shopflutterapp.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) return;

      List<OrderItem> loadedOrders = [];

      data.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => ShoppingCartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
