import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mylocation/mytimescreenview.dart';

class MytimeScreen extends StatefulWidget {
  MytimeScreen({super.key});

  @override
  State<MytimeScreen> createState() => _MytimeScreenState();
}

class _MytimeScreenState extends State<MytimeScreen> {
  String timeIn = "2024-04-22 10:55:58";

  StreamController<Duration>? _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<Duration>();
    _startTimer();
  }

  @override
  void dispose() {
    _controller!.close();
    _timer!.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      final now = DateTime.now();
      final timeIn = DateTime(2024, 04, 25, 11, 50, 04);
      final difference = now.difference(timeIn);
      _controller!.add(difference);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(timeIn.toString());
    String formattedDateTime =
        DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(formattedDateTime.toString()),
            MytimeScreenView(timeIn: "2024-04-22 10:55:58"),

            // Container(
            //   child: StreamBuilder(
            //     stream: _controller!.stream,
            //     builder: (context, snapshot) {
            //       final duration = snapshot.data;
            //       if (snapshot.hasData) {
            //         return Text(
            //           'Duration: ${formatDuration(duration!)}',
            //           style: TextStyle(fontSize: 20),
            //         );
            //       } else {
            //         return Text(
            //           'Loading...',
            //           style: TextStyle(fontSize: 20),
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${twoDigits(duration.inHours)}:${twoDigitMinutes}:${twoDigitSeconds}";
  }
}
