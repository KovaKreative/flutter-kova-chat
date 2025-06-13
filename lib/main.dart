import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PaymentTestScreen());
  }
}

class PaymentTestScreen extends StatefulWidget {
  const PaymentTestScreen({super.key});

  @override
  State<PaymentTestScreen> createState() => _PaymentTestScreenState();
}

class _PaymentTestScreenState extends State<PaymentTestScreen> {
  String? clientSecret;
  bool isLoading = false;
  String? error;

  Future<void> createPaymentIntent() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final url = Uri.parse(
      'https://kova-chat-backend.vercel.app/api/create-payment-intent',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': 5000, // amount in cents ($50.00)
          'currency': 'usd',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          clientSecret = data['clientSecret'];
        });
      } else {
        setState(() {
          error = 'Failed with status code: ${response.statusCode}';
        });
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Payment Intent Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) const CircularProgressIndicator(),
            if (error != null) ...[
              Text(error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: isLoading ? null : createPaymentIntent,
              child: const Text('Create Payment Intent'),
            ),
            const SizedBox(height: 20),
            if (clientSecret != null)
              SelectableText('Client Secret:\n$clientSecret'),
          ],
        ),
      ),
    );
  }
}
