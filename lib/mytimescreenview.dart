import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mylocation/helper.dart';

class MytimeScreenView extends StatefulWidget {
  String timeIn;

  MytimeScreenView({Key? key, required this.timeIn}) : super(key: key);

  @override
  State<MytimeScreenView> createState() => _MytimeScreenState();
}

class _MytimeScreenState extends State<MytimeScreenView> {
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
      final timeIn = DateTime.parse(widget.timeIn);
      final difference = now.difference(timeIn);
      _controller!.add(difference);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller!.stream,
      builder: (context, snapshot) {
        final duration = snapshot.data;
        if (snapshot.hasData) {
          return Center(
            child: Text(
              'Duration: ${formatDuration(duration!)}',
              style: TextStyle(fontSize: 20),
            ),
          );
        } else {
          return Center(
            child: Text(
              'Loading...',
              style: TextStyle(fontSize: 20),
            ),
          );
        }
      },
    );
  }
}
