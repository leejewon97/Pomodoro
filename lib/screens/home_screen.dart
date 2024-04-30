import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int fullSeconds = 25 * 60;
  int totalSeconds = 0;
  bool isRunning = false;
  bool isEditing = false;
  int pomodoros = 0;
  late Timer timer;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    totalSeconds = fullSeconds;
  }

  void onStartPressed() {
    setState(() {
      isRunning = true;
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
  }

  void onPausePressed() {
    setState(() {
      timer.cancel();
      isRunning = false;
    });
  }

  void onStopPressed() {
    setState(() {
      timer.cancel();
      isRunning = false;
      totalSeconds = fullSeconds;
    });
  }

  void onDonePressed() {
    setState(() {
      int? parsed = int.tryParse(controller.text);
      parsed = parsed != null && parsed > 0 && parsed < 60 * 60 ? parsed : null;
      fullSeconds = parsed ?? fullSeconds;
      totalSeconds = parsed ?? totalSeconds;
      isEditing = false;
      controller.clear();
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: isRunning ? 0.0 : 40.0,
                ),
                Container(
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
                isRunning
                    ? const SizedBox.shrink()
                    : Container(
                        alignment: Alignment.bottomCenter,
                        width: 40.0,
                        child: IconButton(
                          onPressed: () => setState(() {
                            isEditing = true;
                          }),
                          icon: Icon(
                            Icons.mode_edit_outline,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: isEditing
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                              hintText: 'Enter seconds in hour',
                              hintStyle: TextStyle(
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onDonePressed,
                          icon: Icon(
                            Icons.done_outlined,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed:
                              isRunning ? onPausePressed : onStartPressed,
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
