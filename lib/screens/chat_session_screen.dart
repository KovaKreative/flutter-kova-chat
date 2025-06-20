import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/widgets/message_input.dart';
import 'package:flutter_kova_chat/widgets/message_list.dart';

class ChatSessionScreen extends StatefulWidget {
  final String currentUser;
  final String otherUser;
  final String? chatId;

  const ChatSessionScreen({
    super.key,
    required this.currentUser,
    required this.otherUser,
    this.chatId,
  });

  @override
  State<ChatSessionScreen> createState() {
    return _ChatSessionScreenState();
  }
}

class _ChatSessionScreenState extends State<ChatSessionScreen> {
  String? chatId;
  @override
  void initState() {
    super.initState();
    _initializeChat(chatId);
  }

  Future<void> _initializeChat(String? id) async {
    if (id != null) return;

    final users = [widget.currentUser, widget.otherUser]..sort();
    final query = await FirebaseFirestore.instance
        .collection('chats')
        .where('users', isEqualTo: users)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      id = query.docs.first.id;
      chatId = id;
    } else {
      final newChat = await FirebaseFirestore.instance.collection('chats').add({
        'users': users,
      });
      id = newChat.id;
      chatId = id;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // String? chatId = widget.chatId;

    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.otherUser}")),
      body: chatId == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: MessageList(
                    currentUser: widget.currentUser,
                    otherUser: widget.otherUser,
                    chatId: chatId!,
                  ),
                ),
                MessageInput(
                  currentUser: widget.currentUser,
                  otherUser: widget.otherUser,
                  chatId: chatId!,
                ),
              ],
            ),
    );
  }
}
