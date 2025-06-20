import 'package:flutter/material.dart';
import 'package:flutter_kova_chat/providers/cart_provider.dart';
import 'package:flutter_kova_chat/screens/chat_list_screen.dart';
import 'package:flutter_kova_chat/screens/checkout_screen.dart';
import 'package:flutter_kova_chat/screens/home_screen.dart';
import 'package:flutter_kova_chat/screens/settings_screen.dart';

import 'package:provider/provider.dart';

class TabItem {
  final String title;
  final Widget page;

  TabItem({required this.title, required this.page});
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<TabItem> _tabs = [
    TabItem(title: 'Home', page: const HomeScreen()),
    TabItem(title: 'Chat', page: ChatListScreen()),
    TabItem(title: 'Cart', page: CheckoutScreen()),
    TabItem(title: 'Profile', page: const SettingsScreen()),
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartProvider>().totalQuantity;
    return Scaffold(
      appBar: AppBar(title: Text(_tabs[_currentIndex].title)),
      body: _tabs[_currentIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (count > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
