import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: Text('Your Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $user', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().logout();
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
