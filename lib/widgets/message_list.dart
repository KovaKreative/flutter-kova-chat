import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final String currentUser;
  final String otherUser;
  final String chatId;

  const MessageList({
    super.key,
    required this.currentUser,
    required this.otherUser,
    required this.chatId
  });

  @override
  Widget build(BuildContext context) {
    // final sortedUsers = [currentUser, otherUser]..sort();
    // final chatId = sortedUsers.join('_');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          reverse: false,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final data = messages[index].data() as Map<String, dynamic>;
            final isMe = data['sender'] == currentUser;

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['text'] ?? '',
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
