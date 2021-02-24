import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:online_shop/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  bool get isAuth => token != null;


  String get userId => _userId;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  Future<void> signUp(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAsJlP314-3Rlal5fn3ymjA7DJFnErUjzs';
    try {
      var jsonBody = {
        'email': email,
        'password': password,
        'returnSecureToken': true
      };

      var response = await http.post(url, body: jsonEncode(jsonBody));
      var responseDate = jsonDecode(response.body);
      if (responseDate['error'] != null) {
        throw HttpException(responseDate['error']['message']);
      }
      _token = responseDate['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseDate['expiresIn'])));
      _userId = responseDate['localId'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signIn(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAsJlP314-3Rlal5fn3ymjA7DJFnErUjzs';

    try {
      var jsonBody = {
        'email': email,
        'password': password,
        'returnSecureToken': true
      };

      var response = await http.post(url, body: jsonEncode(jsonBody));
      var responseDate = jsonDecode(response.body);

      if (responseDate['error'] != null) {
        throw HttpException(responseDate['error']['message']);
      }
      _token = responseDate['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseDate['expiresIn'])));
      _userId = responseDate['localId'];
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
  void logout(){
    _userId = null;
    _expiryDate = null;
    _token = null;
    notifyListeners();
  }
}
