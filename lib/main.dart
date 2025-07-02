import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_kova_chat/providers/auth_provider.dart';
import 'package:flutter_kova_chat/widgets/auth_gate.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';

import 'app/app_messenger.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 30, 113, 90),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 71, 36, 152),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: kReleaseMode ? ".env.production" : ".env");

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: AppMessenger.messengerKey,
        title: 'Kova Chat',
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: kDarkColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kDarkColorScheme.onPrimary,
            foregroundColor: kDarkColorScheme.primary,
            centerTitle: true,
          ),
          cardTheme: CardThemeData().copyWith(
            color: kDarkColorScheme.secondaryContainer,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
            ),
          ),
        ),
        theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.onPrimary,
            centerTitle: true,
          ),
          cardTheme: CardThemeData().copyWith(
            color: kColorScheme.primaryFixed,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer,
            ),
          ),
          textTheme: ThemeData().textTheme.copyWith(
            bodyMedium: TextStyle(color: kColorScheme.onPrimaryFixed),
          ),
          iconTheme: ThemeData().iconTheme.copyWith(
            color: kColorScheme.onPrimaryFixed,
          ),
        ),
        themeMode: ThemeMode.dark,
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
