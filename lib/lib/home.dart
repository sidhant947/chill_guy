import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedMinutes = 5;
  late Duration remainingTime;
  late Timer timer;
  late bool show;

  @override
  void initState() {
    super.initState();
    remainingTime = Duration.zero; // Initially no time has passed
    timer = Timer(
        Duration.zero, () {}); // Initialize the timer with a no-op function
    show = false;
  }

  // Function that gets triggered when time is up
  void _onTimeUp() {
    SystemNavigator.pop();
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    } else if (Platform.isWindows) {
      Process.run('shutdown', ["-s"]);
    } else {
      SystemNavigator.pop();
    }
  }

  // Function to show time picker and handle time
  void _startCountdown() {
    remainingTime = Duration(minutes: selectedMinutes);

    if (timer.isActive) {
      timer.cancel();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      } else {
        _onTimeUp();
        timer.cancel();
      }
    });
  }

  // Function to format the remaining time to a string like "HH:mm:ss"
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            show
                ? Bounce(infinite: true, child: Image.asset("assets/logo.png"))
                : SlideInRight(
                    delay: const Duration(milliseconds: 400),
                    child: Image.asset("assets/logo.png"),
                  ),
            const SizedBox(height: 20),
            show
                ? Container()
                : Column(
                    children: [
                      const Text(
                        "Pick the duration you want to chill for:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropdownButton<int>(
                            focusColor: Colors.white,
                            value: selectedMinutes,
                            items: [1, 2, 3, 4, 5, 10, 30, 60].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text("$value minutes"),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedMinutes = newValue!;
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                show = true;
                              });
                              _startCountdown(); // Start the countdown timer
                            },
                            child: const Text('Start Chilling'),
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 50),
            show
                ? Column(
                    children: [
                      const Text(
                        "You're Chill Guy for",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatDuration(remainingTime),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : const Text("Eww! You're not a Chill guy")
          ],
        ),
      ),
    );
  }
}
