import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:flutter_kova_chat/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final currentUsername = context.read<AuthProvider>().user;
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final fetched = snapshot.docs
        .where((doc) => doc['user'] != currentUsername)
        .map((doc) => doc['user'])
        .toList();

    setState(() {
      users = fetched;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserProfileScreen(user: user)),
            );
          },
        );
      },
    );
  }
}
