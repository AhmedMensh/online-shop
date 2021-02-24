import 'package:flutter/material.dart';
import 'package:online_shop/models/product.dart';
import 'package:online_shop/providers/cart_provider.dart';
import 'package:online_shop/providers/products_provider.dart';
import 'package:online_shop/screens/cart_screen.dart';
import 'package:online_shop/widgets/badge.dart';
import 'package:online_shop/widgets/drawer.dart';
import 'package:online_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorite, All }

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var showOnlyFavorite = false;
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {

    if(isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context)
          .getProductsFromServer()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    final products = showOnlyFavorite
        ? productsProvider.favoriteItems
        : productsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.All)
                    showOnlyFavorite = false;
                  else
                    showOnlyFavorite = true;
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorite'),
                      value: FilterOptions.Favorite,
                    ),
                    PopupMenuItem(
                      child: Text('Show All '),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<CartProvider>(
              builder: (_, cart, child) => Badge(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.ROUTE_NAME);
                    },
                    icon: Icon(Icons.shopping_cart),
                  ),
                  value: '${cart.cartCount}')),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3 / 2),
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: products[index], child: ProductItem())),
    );
  }
}
