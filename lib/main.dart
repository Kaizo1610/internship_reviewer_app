import 'package:flutter/material.dart';
import 'auth/loading_screen.dart';

void main() {
  runApp(const InternovaApp());
}

class InternovaApp extends StatelessWidget {
  const InternovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internova',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoadingScreen(),
    );
  }
}