import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:flutter_kova_chat/screens/chat_session_screen.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthProvider>().user!;
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('chats')
            .where('users', arrayContains: currentUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final users = List<String>.from(chat['users']);
              final otherUser = users.firstWhere((u) => u != currentUser);

              return ListTile(
                title: Text(otherUser),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatSessionScreen(
                        currentUser: currentUser,
                        otherUser: otherUser,
                        chatId: chat.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
