import 'package:chill_guy/lib/splash.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Youtube extends StatefulWidget {
  const Youtube({super.key});

  @override
  State<Youtube> createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  final TextEditingController _controller = TextEditingController();
  int selectedMinutes = 5;
  late Duration remainingTime;
  late String link = "https://youtu.be/Hl2DVLxB7R0?si=p1WWVJbr9HQVWGYn";
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

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
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
        _launchUrl(Uri.parse(link));
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

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade800,
          title: const Text(
            "Enter Youtube Link",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            controller: _controller,
            decoration: const InputDecoration(
                hintText: "Paste here...",
                hintStyle: TextStyle(color: Colors.white)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  link = _controller.text;
                });
                _controller.clear();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade800,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            show
                ? Dance(infinite: true, child: Image.asset("assets/logo.png"))
                : SlideInDown(
                    delay: const Duration(milliseconds: 400),
                    child: Image.asset("assets/logo.png"),
                  ),
            const SizedBox(height: 20),
            show
                ? Container()
                : Column(
                    children: [
                      const SizedBox(
                        width: 250,
                        child: Center(
                          child: Text(
                            "Chill on Youtube:",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showInputDialog();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: const Text(
                              "Set your Youtube Link",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropdownButton<int>(
                            focusColor: Colors.transparent,
                            dropdownColor: Colors.red,
                            value: selectedMinutes,
                            items: [1, 2, 3, 4, 5, 10, 30, 60].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  "$value minutes",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedMinutes = newValue!;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                show = true;
                              });
                              _startCountdown(); // Start the countdown timer
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Text(
                                'Start Chilling',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            show
                ? Column(
                    children: [
                      const Text(
                        "You're gonna Chill on Youtube in",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        _formatDuration(remainingTime),
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      "Eww! You're not a Chill guy",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
