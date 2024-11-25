import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 4)); // Show splash for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const Home()), // Replace with your main screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Roulette(child: Image.asset("assets/logo.png")),
            const Text(
              "Be A Chill Guy",
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
