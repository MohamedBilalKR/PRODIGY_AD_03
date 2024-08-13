import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int ms = 0, s = 0, m = 0;
  String digMs = "00", digSec = "00", digMin = "00";
  Timer? timer;
  bool started = false;
  DateTime? startTime;
  Duration? elapsedTime;

  List<String> laps = [];

  // stop Function
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  // reset Function
  void reset() {
    timer!.cancel();
    setState(() {
      ms = 0;
      s = 0;
      m = 0;
      digMs = "00";
      digSec = "00";
      digMin = "00";
      laps.clear();
      started = false;
      startTime = null;
      elapsedTime = null;
    });
  }

  // adding Laps Function
  void addLap() {
    String lap = "$digMin:$digSec:$digMs";
    setState(() {
      laps.add(lap);
    });
  }

  //Start and Pause function
  void startPause() {
    if (!started) {
      started = true;
      if (elapsedTime != null) {
        startTime = DateTime.now().subtract(elapsedTime!);
      } else {
        startTime = DateTime.now();
      }
      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        DateTime currentTime = DateTime.now();
        elapsedTime = currentTime.difference(startTime!);
        ms = elapsedTime!.inMilliseconds % 1000;
        s = elapsedTime!.inSeconds % 60;
        m = elapsedTime!.inMinutes;

        setState(() {
          digMs = (ms >= 100)
              ? "${ms ~/ 10}"
              : (ms >= 10)
                  ? "0${ms ~/ 10}"
                  : "00";
          digSec = (s >= 10) ? "$s" : "0$s";
          digMin = (m >= 10) ? "$m" : "0$m";
        });
      });
    } else {
      timer!.cancel();
      setState(() {
        started = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                    // child: Text(
                    //   'Stop Watch',
                    //   style: TextStyle(
                    //       fontSize: 28.0,
                    //       fontWeight: FontWeight.bold,
                    //       color: Color.fromARGB(255, 0, 0, 0)),
                    // ),
                    ),
                Expanded(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (Rect rect) {
                          return LinearGradient(
                            colors: [
                              Color.fromARGB(255, 29, 150, 255), // start color
                              Color.fromARGB(255, 209, 58, 255), // end color
                            ],
                          ).createShader(rect);
                        },
                        child: Text(
                          '$digMin:$digSec:$digMs',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 400.0,
                    decoration: BoxDecoration(
                        // color: Color(0xFF313E66),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: ListView.builder(
                        itemCount: laps.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Lap ${index + 1}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${laps[index]}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(
                                          255, 29, 150, 255), // start color
                                      Color.fromARGB(
                                          255, 209, 58, 255), // end color
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: ElevatedButton(
                                onPressed: () {
                                  startPause();
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.all(10),
                                ),
                                child: Text(
                                  (started) ? "Pause" : "Start",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          IconButton(
                            onPressed: () {
                              addLap();
                            },
                            icon: const Icon(
                              Icons.flag,
                              color: Color.fromARGB(255, 0, 0, 0),
                              size: 35,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(
                                          255, 29, 150, 255), // start color
                                      Color.fromARGB(
                                          255, 209, 58, 255), // end color
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: ElevatedButton(
                                onPressed: () {
                                  reset();
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    padding: EdgeInsets.all(10),
                                    shape: StadiumBorder()),
                                child: Text(
                                  'Restart',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
