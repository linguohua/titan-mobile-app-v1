import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _isLoggedIn = false;
  bool _isPrivacySigned = true;

  String get username => _username;
  String get password => _password;
  bool get isLoggedIn => !_isLoggedIn;
  bool get isPrivacySigned => _isPrivacySigned;

  void changePrivacy() {
    _isPrivacySigned = !_isPrivacySigned;
    notifyListeners();
  }

  AuthProvider() {
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _password = prefs.getString('password') ?? '';
    _isLoggedIn = _username.isNotEmpty && _password.isNotEmpty;
    notifyListeners();
  }

  // save login information
  Future<void> login(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    _username = username;
    _password = password;
    _isLoggedIn = true;
    notifyListeners();
  }

  //clear login information
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    _username = '';
    _password = '';
    _isLoggedIn = false;
    notifyListeners();
  }
}
