import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:flutter_kova_chat/screens/login_screen.dart';
import 'package:flutter_kova_chat/widgets/main_scaffold.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isLoggedIn) {
          return const LoginScreen();
        } else {
          return const MainScaffold();
        }
      },
    );
  }
}
