import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_kova_chat/app/app_messenger.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:flutter_kova_chat/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  Future<Map<String, String>> fetchStripeIds(List<String> usernames) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user', whereIn: usernames)
        .get();

    return {for (var doc in snapshot.docs) doc['user']: doc['stripe_id']};
  }

  Future<bool> _handleCheckout(
    String currentUser,
    List<CartItem> cartItems,
  ) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where('user', isEqualTo: currentUser)
        .limit(1)
        .get();

    final ourStripeId = doc.docs.first.data()['stripe_id'] as String;

    // final cartProvider = context.read<CartProvider>();
    // final cartItems = cartProvider.items;

    final usernames = cartItems.map((item) => item.user).toSet().toList();
    final stripeIdsMap = await fetchStripeIds(usernames);

    final payload = {
      "items": cartItems
          .map(
            (item) => {
              "stripe_id": stripeIdsMap[item.user],
              "amount_cents": item.priceInCents,
              "quantity": item.quantity,
            },
          )
          .toList(),
      "payer_stripe_id": ourStripeId, // fetch this too, as you said
    };

    // Now build your payment payload using stripeIdsMap and cart items

    try {
      final url = Uri.parse('${dotenv.env['API_URL']}/api/checkout');
      // final url = Uri.parse(
      //   '/api/checkout',
      // );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Checkout failed: ${response.body}');
      }
      final responseData = jsonDecode(response.body);
      await FirebaseFirestore.instance.collection('transactions').add({
        'user': currentUser,
        'items': cartItems
            .map(
              (item) => {
                'user': item.user,
                'priceInCents': item.priceInCents,
                'quantity': item.quantity,
              },
            )
            .toList(),
        'paymentIntentId': responseData['paymentIntentId'],
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending', // or 'completed' if confirmed
      });

      AppMessenger.show("Payment processed successfully!");
      return true;
    } catch (e) {
      AppMessenger.show(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.items;
    final currentUser = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.user),
                  subtitle: Text(
                    '\$${(item.priceInCents / 100).toStringAsFixed(2)} x ${item.quantity}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => cartProvider.updateQuantity(
                          item.user,
                          item.quantity - 1,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => cartProvider.updateQuantity(
                          item.user,
                          item.quantity + 1,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => cartProvider.removeItem(item.user),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: cartItems.isEmpty
                ? null
                : () => _handleCheckout(currentUser!, cartItems).then(
                    (r) => {
                      if (r) {cartProvider.clearCart()},
                    },
                  ),
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
