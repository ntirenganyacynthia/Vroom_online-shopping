import 'package:flutter/material.dart';
import 'package:vroom/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignupScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}
 