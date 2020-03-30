import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  static const String apiKey = 'AIzaSyDPr2zdAFmxDePNbvBl5fphQIqi8hblZRo';

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (token != null) {
      return _userId;
    }
    return null;
  }

  Future<void> authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    const url = 'signUp';
    return authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    const url = 'signInWithPassword';
    return authenticate(email, password, url);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _authTimer.cancel();
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
