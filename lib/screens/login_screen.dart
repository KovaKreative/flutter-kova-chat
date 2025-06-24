import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/app/app_messenger.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final user = _controller.text.trim();
    if (user.isEmpty) return;

    final auth = context.read<AuthProvider>();
    try {
      bool success = await auth.login(user);
      if (!success) {
        AppMessenger.show("Unable to log in.");
      }
    } catch (e) {
      // In case of any unexpected error
      AppMessenger.show('An error occurred: ${e.toString()}');
    }
  }

  void _handleRegister() async {
    final user = _controller.text.trim();
    if (user.isEmpty) {
      AppMessenger.show("Please enter a username.");
    }

    final auth = context.read<AuthProvider>();
    try {
      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('user', isEqualTo: user)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        // Username is already taken
        throw Exception('Username already exists');
      }

      await FirebaseFirestore.instance.collection('users').add({
        'user': user,
        'price': 0,
        'stripe_id': "12345",
        'createdAt': DateTime.now(),
      });

      bool success = await auth.login(user);
      if (!success) {
        AppMessenger.show(
          "User created, but unable to log in. Try logging in again.",
        );
      }
    } catch (e) {
      if (e is FirebaseException) {
        AppMessenger.show('Firebase error: ${e.message}');
        return;
      }

      AppMessenger.show('An error occurred: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Username'),
              onSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text('Create New Account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
