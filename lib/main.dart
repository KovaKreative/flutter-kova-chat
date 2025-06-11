import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Test',
      home: Scaffold(
        appBar: AppBar(title: const Text('Firestore Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                await firestore.collection('test_collection').add({
                  'timestamp': FieldValue.serverTimestamp(),
                  'message': 'Hello Firestore!',
                });
                debugPrint('✅ Document successfully written!');
              } catch (e) {
                debugPrint('❌ Firestore write failed: $e');
              }
            },
            child: const Text('Write to Firestore'),
          ),
        ),
      ),
    );
  }
}
