import 'package:flutter/material.dart';
import 'package:online_shop/providers/auth_provider.dart';
import 'package:online_shop/providers/cart_provider.dart';
import 'package:online_shop/providers/orders_provider.dart';
import 'package:online_shop/providers/products_provider.dart';
import 'package:online_shop/routes.dart';
import 'package:online_shop/screens/cart_screen.dart';
import 'package:online_shop/screens/edit_product_screen.dart';
import 'package:online_shop/screens/orders_screen.dart';
import 'package:online_shop/screens/product_details_screen.dart';
import 'package:online_shop/screens/products_overview_screen.dart';
import 'package:online_shop/screens/splash_screen.dart';
import 'package:online_shop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: null,
          update: (ctx, auth, previousProducts) => ProductsProvider(auth.token,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: null,
          update: (ctx, auth, previousOrders) => OrdersProvider(
              auth.token, previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.deepPurple, accentColor: Colors.deepOrange),
          home: auth.isAuth
              ? ProductsOverViewScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authResult) {
                    return authResult.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen();
                  }),
          routes: routes,
        ),
      ),
    );
  }
}
