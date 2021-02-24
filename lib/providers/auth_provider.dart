import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:online_shop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final prefs = await SharedPreferences.getInstance();
      final userDate = jsonEncode({
        'token' : _token,
        'userID': _userId,
        'expiryDate' : _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userDate);

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
      final prefs = await SharedPreferences.getInstance();
      final userDate = jsonEncode({
        'token' : _token,
        'userID': _userId,
        'expiryDate' : _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userDate);

    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> autoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) return false;

    final userDate = jsonDecode(prefs.getString('userData'));
    _expiryDate = DateTime.parse(userDate['expiryDate']);
    if(_expiryDate.isBefore(DateTime.now())) return false;

    _userId = userDate['userId'];
    _token = userDate['token'];
    notifyListeners();
    return true;

  }
  void logout() async{
    _userId = null;
    _expiryDate = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('userData')) {
      prefs.remove('userData');
    }
    notifyListeners();
  }
}
