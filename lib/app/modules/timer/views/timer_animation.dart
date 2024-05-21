import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import '../../../utils/utils.dart';
import '../../settings/controllers/theme_controller.dart';

class TimerAnimatedCard extends StatefulWidget {
  final TimerModel timer;

  const TimerAnimatedCard(this.timer, {super.key});
  @override
  _TimerAnimatedCardState createState() => _TimerAnimatedCardState();
}

class _TimerAnimatedCardState extends State<TimerAnimatedCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TimerController controller = Get.find<TimerController>();
  ThemeController themeController = Get.find<ThemeController>();

  bool isPlaying = false;
  Timer? _timerCounter;
  late int _progressCounter;
  void startTimer() {
    _timerCounter = Timer.periodic(Duration(seconds: 1), (timer) {
      print("${widget.timer.timerName}");
      if (widget.timer.timeElapsed < widget.timer.timerValue) {
        setState(() {
          widget.timer.timeElapsed += 1000;
          _progressCounter += 1000;
          IsarDb.updateTimerTick(widget.timer.timerId, widget.timer);
        });
      }
    });
  }

  void stopTimer() {
    _timerCounter!.cancel();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _progressCounter = 0;
    });

    if (widget.timer.isPaused == 0) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _timerCounter!.cancel();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      isPlaying = !isPlaying;
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
                    (_progressCounter / (widget.timer.timerValue)),
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
                                    child: const Padding(
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
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    child: Text(
                                      "${Utils.formatMilliseconds(widget.timer.timerValue - widget.timer.timeElapsed)}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.displayLarge!.copyWith(
                                            color: themeController
                                                    .isLightMode.value
                                                ? kLightPrimaryTextColor
                                                : kprimaryTextColor,
                                            fontSize: 50,
                                          ),
                                    ),
                                  ),
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        widget.timer.isPaused == 0
                                            ? stopTimer()
                                            : startTimer();
                                        widget.timer.isPaused =
                                            widget.timer.isPaused == 0 ? 1 : 0;
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: GestureDetector(
                                          onTap: _toggleAnimation,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: kprimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(80)),
                                            width: 80,
                                            height: 80,
                                            child: Icon(
                                              widget.timer.isPaused == 0
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              size: 30,
                                              color: ksecondaryBackgroundColor,
                                            ),
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
