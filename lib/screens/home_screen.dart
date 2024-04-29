import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const fullSeconds = 25 * 60;
  int totalSeconds = fullSeconds;
  bool isRunning = false;
  int pomodoros = 0;
  late Timer timer;

  void onStartPressed() {
    setState(() {
      totalSeconds--;
    });
    timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) {
        setState(() {
          if (totalSeconds == 0) {
            timer.cancel();
            isRunning = false;
            totalSeconds = fullSeconds;
            pomodoros++;
            return;
          }
          totalSeconds--;
        });
      },
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onStopPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = fullSeconds;
    });
  }

  String formatTime(int time) {
    Duration duration = Duration(seconds: time);
    String hms = duration.toString().split('.').first;
    return '${hms.split(':')[1]} : ${hms.split(':')[2]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                formatTime(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 80.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    icon: Icon(
                      isRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                      size: 120.0,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                  isRunning
                      ? IconButton(
                          onPressed: onStopPressed,
                          icon: Icon(
                            Icons.stop_circle_outlined,
                            size: 120.0,
                            color: Theme.of(context).cardColor,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'pomodoros',
                        style: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$pomodoros',
                        style: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                          fontSize: 60.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
