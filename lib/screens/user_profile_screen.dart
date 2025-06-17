import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/app/app_messenger.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:flutter_kova_chat/providers/cart_provider.dart';
import 'package:flutter_kova_chat/screens/chat_session_screen.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  final String user;

  const UserProfileScreen({super.key, required this.user});

  Future<DocumentSnapshot?> _fetchUser() async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('user', isEqualTo: user)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }
    return query.docs.first;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    var currentUser = context.watch<AuthProvider>().user!;

    return Scaffold(
      appBar: AppBar(title: Text(user)),
      body: FutureBuilder<DocumentSnapshot?>(
        future: _fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final price = userData['price'] ?? 0.0;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: $user', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Price: \$${price.toStringAsFixed(2)}'),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    cart.addItem(user: user, priceInCents: price);
                    AppMessenger.show('Added $user to cart');
                  },
                  icon: Icon(Icons.add_shopping_cart),
                  label: Text('Add to Cart'),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatSessionScreen(
                          currentUser: currentUser,
                          otherUser: user,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.chat),
                  label: Text('Message'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
