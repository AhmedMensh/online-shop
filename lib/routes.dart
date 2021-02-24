import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/user_product_screen.dart';

final Map<String,WidgetBuilder> routes = {
  ProductDetailsScreen.ROUTE_NAME: (ctx) => ProductDetailsScreen(),
  CartScreen.ROUTE_NAME: (ctx) => CartScreen(),
  OrdersScreen.ROUTE_NAME: (ctx) => OrdersScreen(),
  UserProductsScreen.ROUT_NAME: (ctx) => UserProductsScreen(),
  EditProductScreen.ROUTE_NAME: (ctx) => EditProductScreen(),
  AuthScreen.routeName: (ctx) => AuthScreen(),
};