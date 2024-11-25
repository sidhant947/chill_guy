import 'package:chill_guy/lib/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Chill Guy", debugShowCheckedModeBanner: false, home: Splash());
  }
}
