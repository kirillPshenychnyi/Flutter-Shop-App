import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exceptions/auth_expcetion.dart';

class Auth with ChangeNotifier {
  static const String API_KEY = "AIzaSyDc-NeAVnfWKnVkUU_Ua64RpOgEQjW_xSY";

  DateTime _expirationDate;
  String _idToken;
  String _userId;

  bool get isAuthanticated {
    return token != null;
  }

  String get token {
    return _isValidToken() ? _idToken : null;
  }

  bool _isValidToken() {
    return _expirationDate != null && _expirationDate.isAfter(DateTime.now());
  }

  Future _performAuthRequest(
      String email, String password, String urlSegment) async {
    try {
      String url = "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$API_KEY";
      
      print('posting: $url');

      final response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$API_KEY",
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseBody = json.decode(response.body);

      if (responseBody['error'] != null) {
        throw new AuthExpception(responseBody['error']['message']);
      }

      final data = json.decode(response.body);

      print(data);

      _idToken = data['idToken'];
      _userId = data['localId'];

      _expirationDate =
          DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));

      notifyListeners();
    } catch (exception) {
      throw exception;
    }
  }

  Future<void> signup(String email, String password) async {
    return _performAuthRequest(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _performAuthRequest(email, password, "signInWithPassword");
  }
}
