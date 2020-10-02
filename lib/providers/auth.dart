import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _email;
  String _name;
  int _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get email {
    return _email;
  }

  String get name {
    return _name;
  }

  int get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String name, String password) async {
    final url = 'http://10.0.2.2:8000/api/user/create/';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'name': name,
            'password': password,
          },
        ),
        headers: {'Content-Type': 'application/json'},
      );
      final v_email = json.decode(response.body)['email'];

      final token_response = await http.post(
        'http://10.0.2.2:8000/api/user/token/',
        body: json.encode(
          {
            'email': v_email,
            'password': password,
          },
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (token_response.statusCode == 400) {
        throw HttpException('message');
      }
      final responseData = json.decode(token_response.body);
      _token = responseData['token'];
      _email = responseData['user']['email'];
      _name = responseData['user']['name'];
      _userId = responseData['user']['id'];
      // print(_userId);

      // print(responseData);

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'email': _email,
          'userId': _userId,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String name, String password) async {
    return _authenticate(email, name, password);
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      'http://10.0.2.2:8000/api/user/token/',
      body: json.encode(
        {
          'email': email,
          'password': password,
        },
      ),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 400) {
      throw HttpException(responseData['non_field_errors'][0]);
    }
    _token = responseData['token'];
    _email = responseData['user']['email'];
    _name = responseData['user']['name'];
    _userId = responseData['user']['id'];

    // print(_email);

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': _token,
        'email': _email,
        'userId': _userId,
      },
    );
    prefs.setString('userData', userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _token = extractedUserData['token'];
    _email = extractedUserData['email'];
    _userId = extractedUserData['userId'];

    notifyListeners();
    // _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _email = null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}
