import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get user => _username;
  bool get isLoggedIn => _username != null;

  Future<bool> login(String user) async {
    final userDoc = await _firestore
        .collection('users')
        .where('user', isEqualTo: user)
        .get();

    if (userDoc.docs.isEmpty) {
      return false;
    }

    _username = user;
    notifyListeners();
    return true; // success
  }

  void logout() {
    _username = null;
    notifyListeners();
  }
}
