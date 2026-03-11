import 'package:flutter/material.dart';
import 'package:roommindercapstone/login.dart';
import 'package:roommindercapstone/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoomMinder',
      theme: ThemeData(
        primaryColor: Color(0xFF4FAF9F),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4FAF9F),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4FAF9F)
        )
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => SignInPage(),
      },
    );
  }
}
