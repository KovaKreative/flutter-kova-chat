import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _NewLoginScreenState();
  }
}

class _NewLoginScreenState extends State<LoginScreen> {
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
    final messenger = ScaffoldMessenger.of(context);
    try {
      bool success = await auth.login(
        user,
      ); // Let's say your login returns bool for success/fail
      if (!success) {
        // Show error SnackBar
        messenger.showSnackBar(
          SnackBar(
            content: Text('Login failed: user not found.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // In case of any unexpected error
      messenger.showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
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
            ElevatedButton(onPressed: _handleLogin, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
