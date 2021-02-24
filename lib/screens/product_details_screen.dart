import 'dart:core';

import 'package:flutter/material.dart';
import 'package:online_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = 'product-details';


  @override
  Widget build(BuildContext context) {
    var productId = ModalRoute.of(context).settings.arguments as String;

    final product = Provider.of<ProductsProvider>(context, listen: false)
        .getProduct(productId);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(product.title),
            background: Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 10,
          ),
          Text(
            '\$${product.price}',
            style: TextStyle(color: Colors.black, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              '${product.description} ${product.description} ${product.description}${product.description}${product.description}${product.description}${product.description}${product.description}${product.description}${product.description} ${product.description} ${product.description} ${product.description} ${product.description}',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
          ),

        ]))
      ],
    ));
  }
}
