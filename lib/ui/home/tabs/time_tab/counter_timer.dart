import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class CountDownTimer extends StatefulWidget {
  Duration timeRemaining;

  final void Function() getPrayingData;
  final void Function() playAdhan;
  final void Function() stopAdhan;

  CountDownTimer(
      {super.key,
      required this.timeRemaining,
      required this.playAdhan,
      required this.getPrayingData,
      required this.stopAdhan});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  bool isMuted = false;
  late Timer timer;

  @override
  void initState() { timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (widget.timeRemaining.inSeconds > 0) {
            widget.timeRemaining -= Duration(seconds: 1);
          } else {
            timer.cancel();
            widget.getPrayingData();
            widget.playAdhan();
          }
        });
      },
    );

    super.initState();
  }

  String _formatDuration(Duration timeRemaining) {
    String hours = timeRemaining.inHours.toString().padLeft(2, "0");
    String minutes =
        timeRemaining.inMinutes.remainder(60).toString().padLeft(2, "0");
    String seconds =
        timeRemaining.inSeconds.remainder(60).toString().padLeft(2, "0");
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Spacer(
          flex: 2,
        ),
        const Text(
          "Next Pray - ",
          style: TextStyle(color: AppColors.blackColor),
        ),
        AutoSizeText(
          _formatDuration(widget.timeRemaining),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              setState(() {
                isMuted = !isMuted;
                //todo: mute/unmute adhan
                if (isMuted) {
                  widget.stopAdhan();
                }
              });
            },
            icon: Icon(
              isMuted ? CupertinoIcons.volume_off : Icons.volume_up,
              size: 25,
            )),
        const Spacer(),
      ],
    );
  }
}
