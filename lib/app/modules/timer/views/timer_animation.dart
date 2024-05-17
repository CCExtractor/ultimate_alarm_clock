import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import '../../../utils/utils.dart';
import '../../settings/controllers/theme_controller.dart';

class TimerAnimatedCard extends StatefulWidget {
  TimerModel timer;
  int index;

  TimerAnimatedCard(this.timer, this.index);
  @override
  _TimerAnimatedCardState createState() => _TimerAnimatedCardState();
}

class _TimerAnimatedCardState extends State<TimerAnimatedCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  TimerController controller = Get.find<TimerController>();
  ThemeController themeController = Get.find<ThemeController>();

  bool isPlaying = false;
  Timer? timerCounter;
  late int milliseconds;
  late int progressCounter;
  void startTimer() {
    milliseconds = widget.timer.intervalToAlarm;
    timerCounter = Timer.periodic(Duration(seconds: 1), (timer) {
      if (milliseconds > 0) {
        setState(() {
          milliseconds -= 1000;
          progressCounter += 1000;
        });
      }
    });
  }

  void stopTimer() {
    timerCounter!.cancel();
  }

  @override
  void initState() {
    super.initState();
    progressCounter = 0;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: widget.timer
              .intervalToAlarm), // Replace x with your duration in milliseconds
    );
    if (controller.pausedTimers.value[widget.index] == 0) {
      startTimer();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _controller.forward() : _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Container(
        height: context.height / 3.3,
        width: context.width,
        child: Card(
          margin: const EdgeInsets.all(5),
          color: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              18,
            ),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                decoration: BoxDecoration(
                    color: kprimaryDisabledTextColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18)),
                duration: Duration(milliseconds: 1000),
                height: context.height / 3.3,
                width: context.width *
                    (progressCounter / (widget.timer.intervalToAlarm)),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 20.0,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.timer.timerName,
                                  overflow: TextOverflow.ellipsis,
                                  // Set overflow property here
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: kprimaryColor,
                                      fontSize: 18),
                                ),
                                InkWell(
                                  onTap: () {
                                    controller
                                        .deleteTimer(widget.timer.timerId);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: kprimaryBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const  Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Utils.formatMilliseconds(milliseconds),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayLarge!.copyWith(
                                          color:
                                              themeController.isLightMode.value
                                                  ? kLightPrimaryTextColor
                                                  : kprimaryTextColor,
                                          fontSize: 50,
                                        ),
                                  ),
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    onTap: () {
                                      controller.toggleAnimation(widget.index);
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(25.0),
                                        child: GestureDetector(
                                          onTap: _toggleAnimation,
                                          child: AnimatedBuilder(
                                            animation: _controller,
                                            builder: (context, child) {
                                              return CustomPaint(
                                                painter: CirclePainter(
                                                    _controller.value),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Icon(
                                                    controller.pausedTimers[
                                                                widget.index] ==
                                                            0
                                                        ? Icons.pause
                                                        : Icons.play_arrow,
                                                    size: 30,
                                                    color:
                                                        kLightPrimaryDisabledTextColor,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = kprimaryColor
      ..strokeWidth = 50
      ..style = PaintingStyle.stroke;

    double angle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width / 2,
          height: size.height / 2),
      -math.pi / 2,
      angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
