import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _username;

  String? get username => _username;
  bool get isLoggedIn => _username != null;

  Future<void> login(String username) async {
    _username = username;
    notifyListeners();
    return;
  }

  void logout() {
    _username = null;
    notifyListeners();
  }
}
