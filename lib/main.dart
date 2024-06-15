import 'package:flutter/material.dart';
import 'package:mimichat/views/pages/auth/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MimiChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purpleAccent,
          background: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
