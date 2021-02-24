import 'package:flutter/material.dart';
import 'package:online_shop/providers/products_provider.dart';
import 'package:online_shop/widgets/drawer.dart';
import 'package:online_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const ROUT_NAME = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.ROUTE_NAME);
          })
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsProvider.items.length,
            itemBuilder: (_, i) => UserProductItem(
                productsProvider.items[i].id,
                productsProvider.items[i].title,
                productsProvider.items[i].imageUrl)),
      ),
    );
  }
}
