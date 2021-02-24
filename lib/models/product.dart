import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavorite = false});

  void toggleFavorite(String token) async {
    final url =
        'https://online-shop-50c8c-default-rtdb.firebaseio.com/products/$id.json?auth=$token';

    await http.patch(url,
        body: jsonEncode({
          'isFavorite': !isFavorite,
        }));
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
