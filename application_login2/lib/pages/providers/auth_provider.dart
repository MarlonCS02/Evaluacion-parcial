import 'package:flutter/material.dart';
import '../UserStatus/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser?.isActive ?? false;

  void login(User user) {
    user.login();
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser?.logout();
    _currentUser = null;
    notifyListeners();
  }
}