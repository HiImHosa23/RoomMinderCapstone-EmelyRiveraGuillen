import 'package:flutter/material.dart';
import 'package:roommindercapstone/login.dart';
import 'package:roommindercapstone/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context){
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = false;

  void toggleDarkMode(bool value){
    setState(() {
      darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF4FAF9F),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4FAF9F),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4FAF9F),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4FAF9F),
          brightness: Brightness.dark
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4FAF9F),
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => SignInPage(),
      },
    );
  }
}
