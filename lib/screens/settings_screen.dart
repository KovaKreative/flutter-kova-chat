import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/app/app_messenger.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? _priceInCents;
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrice();
  }

  Future<void> _loadPrice() async {
    final username = context.read<AuthProvider>().user;
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('user', isEqualTo: username)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final userData = query.docs.first.data();
      final price = userData['price'] ?? 0;
      setState(() {
        _priceInCents = price;
        _priceController.text = (price / 100).toStringAsFixed(2);
      });
    }
  }

  Future<void> _savePrice() async {
    final username = context.read<AuthProvider>().user;
    final newPriceDouble = double.tryParse(_priceController.text);

    if (newPriceDouble == null) {
      AppMessenger.show('Invalid price');
      return;
    }

    final newPriceInCents = (newPriceDouble * 100).round();

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('user', isEqualTo: username)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final docId = query.docs.first.id;
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'price': newPriceInCents,
      });

      setState(() {
        _priceInCents = newPriceInCents;
      });

      AppMessenger.show('Price updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $username', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              'Current Price: \$${((_priceInCents ?? 0) / 100).toStringAsFixed(2)}',
            ),
            SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Set New Price (\$)'),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: _savePrice, child: Text('Save')),
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
