import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _username;

  String? get username => _username;
  bool get isLoggedIn => _username != null;

  void login(String username) {
    _username = username;
    notifyListeners();
  }

  void logout() {
    _username = null;
    notifyListeners();
  }
}
