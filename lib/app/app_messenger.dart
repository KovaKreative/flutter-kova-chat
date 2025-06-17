import 'package:flutter/material.dart';

class AppMessenger {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    final messenger = messengerKey.currentState;
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          showCloseIcon: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } else {
      debugPrint("⚠️ Tried to show SnackBar, but messenger was null");
    }
  }
}
