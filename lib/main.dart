import 'package:flutter/material.dart';
import 'Screens/LoadingScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
    ),
    home: const LoadingScreen(),
    );
  }
}

