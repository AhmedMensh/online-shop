import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_shop/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  final authToken;
  ProductsProvider(this.authToken ,this._items);
  List<Product> get favoriteItems {
    return items.where((element) => element.isFavorite).toList();
  }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> getProductsFromServer() async {
    final url =
        'https://online-shop-50c8c-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      print(responseBody);
      final List<Product> loadedProducts = [];
      responseBody.forEach((productId, productData) {
        loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description:
                "High quality product with a good price i really recommended",
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
            price: productData['price']));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://online-shop-50c8c-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    var body = json.encode({
      'title': product.title,
      'id': product.id,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    });
    try {
      final response = await http.post(url, body: body);

      Map<String, dynamic> responseBody = json.decode(response.body);
      product.id = responseBody['name'];
      _items.add(product);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> editProduct(Product product) async {
    final url =
        'https://online-shop-50c8c-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken';
    var jsonBody = {
      'title': product.title,
      'price': product.price,
      'imageUrl': product.imageUrl,
    };

      await http.patch(url, body: jsonEncode(jsonBody));
      _items.removeWhere((element) => element.id == product.id);
      _items.add(product);
      notifyListeners();

  }

  void deleteProduct(String productId) {
    var existingProductIndex = _items.indexWhere((element) => element.id == productId);
    var existingProduct = _items[existingProductIndex];
    final url =
        'https://online-shop-50c8c-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';

    http.delete(url).catchError((_){
      _items.insert(existingProductIndex, existingProduct);
    });

    notifyListeners();
  }

  Product getProduct(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }
}
