import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:online_shop/models/cart_item.dart';
import 'package:online_shop/models/order_item.dart';
import 'package:http/http.dart' as http;
import 'package:online_shop/models/product.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final authToken;
  OrdersProvider(this.authToken , this._orders);
  Future<void> getOrdersFromServer() async {
    final url =
        'https://online-shop-50c8c-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      print(responseBody);
      final List<OrderItem> loadedOrders = [];
      responseBody.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>).map((item) =>
            CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity'])
          ).toList(),
        ));
        _orders = loadedOrders;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> products, double totalAmount) async {
    final timeStamp = DateTime.now();
    final url =
        'https://online-shop-50c8c-default-rtdb.firebaseio.com/orders.json?auth=$authToken';

    var body = json.encode({
      'products': products
          .map((cp) => {
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              })
          .toList(),
      'amount': totalAmount,
      'date': timeStamp.toIso8601String(),
    });
    try {
      final response = await http.post(url, body: body);
      print(response.body);
      _orders.insert(
          0,
          OrderItem(
              id: DateTime.now().toString(),
              amount: totalAmount,
              products: products,
              dateTime: timeStamp));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
