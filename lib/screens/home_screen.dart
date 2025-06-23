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
        .toList();
    // .map((doc) => doc['user'])

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
        Timestamp createdAt = user["createdAt"];
        DateTime d = createdAt.toDate();
        String memberSince = '${d.day}/${d.month}/${d.year}';

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(user["user"]),
            subtitle: Text("Member since $memberSince"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(user: user["user"]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
