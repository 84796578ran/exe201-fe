import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _currentUser;
  String _userRole = ''; // 'provider', 'admin', or 'user'

  Map<String, dynamic>? get currentUser => _currentUser;
  String get userRole => _userRole;

  void setUser(Map<String, dynamic> user, String role) {
    _currentUser = user;
    _userRole = role;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    _userRole = '';
    notifyListeners();
  }

  bool get isProvider => _userRole == 'provider';
  bool get isAdmin => _userRole == 'admin';
} 