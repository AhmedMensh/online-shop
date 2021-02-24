import 'package:flutter/material.dart';
import 'package:online_shop/providers/auth_provider.dart';
import 'package:online_shop/screens/auth_screen.dart';
import 'package:online_shop/screens/orders_screen.dart';
import 'package:online_shop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text('Hello'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.ROUTE_NAME);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.list),
          title: Text('Manage Products'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.ROUT_NAME);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
           Provider.of<AuthProvider>(context,listen: false).logout();
          },
        )
      ],
    ));
  }
}
