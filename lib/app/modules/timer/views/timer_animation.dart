import 'dart:async';
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
  final int index;

  const TimerAnimatedCard({
    super.key,
    required this.index,
    required this.timer,
  });
  @override
  _TimerAnimatedCardState createState() => _TimerAnimatedCardState();
}

class _TimerAnimatedCardState extends State<TimerAnimatedCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TimerController controller = Get.find<TimerController>();
  ThemeController themeController = Get.find<ThemeController>();
  var width = Get.width;
  var height = Get.height;

  Timer? _timerCounter;
  void startTimer() {
    _timerCounter = Timer.periodic(Duration(seconds: 1), (timer) {
      print('${widget.timer.timerName}');
      if (widget.timer.timeElapsed < widget.timer.timerValue) {
        setState(() {
          widget.timer.timeElapsed += 1000;
          IsarDb.updateTimerTick(widget.timer);
        });
      } else {
        stopTimer();
        controller.startRinger(widget.timer.timerId);
      }
    });
  }

  void stopTimer() {
    _timerCounter!.cancel();
  }

  @override
  void initState() {
    super.initState();
    if (Utils.getDifferenceMillisFromNow(
                widget.timer.startedOn, widget.timer.timerValue) <=
            0 &&
        widget.timer.isPaused == 0) {
      widget.timer.isPaused = 1;
      widget.timer.timeElapsed = 0;
      IsarDb.updateTimerPauseStatus(widget.timer);
    } else if (Utils.getDifferenceMillisFromNow(
                widget.timer.startedOn, widget.timer.timerValue) <
            widget.timer.timerValue &&
        widget.timer.isPaused == 0) {
      widget.timer.timeElapsed = widget.timer.timerValue - Utils.getDifferenceMillisFromNow(
          widget.timer.startedOn, widget.timer.timerValue);
      IsarDb.updateTimerPauseStatus(widget.timer);
    }
    if (widget.timer.isPaused == 0) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _timerCounter?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Container(
        height: context.height / 3.0, 
        width: context.width,
        child: Obx(
          () => Card(
            margin: const EdgeInsets.all(5),
            color: widget.timer.timeElapsed < widget.timer.timerValue
                ? themeController.secondaryBackgroundColor.value
                : themeController.secondaryColor.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                18,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  AnimatedContainer(
                    decoration: BoxDecoration(
                        color: kprimaryDisabledTextColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18)),
                    duration: Duration(milliseconds: 1000),
                    height: context.height / 3.3,
                    width: context.width *
                        ((widget.timer.timeElapsed) /
                            (widget.timer.timerValue)),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.timer.timerName,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: kprimaryColor,
                                      fontSize: 18),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_timerCounter != null &&
                                            widget.timer.isPaused == 0) {
                                          stopTimer();
                                        }
                                        widget.timer.timeElapsed = 0;
                                        IsarDb.updateTimerTick(widget.timer);
                                        if (_timerCounter != null &&
                                            widget.timer.isPaused == 0) {
                                          widget.timer.startedOn =
                                              DateTime.now().toString();
                                          IsarDb.updateTimerTick(widget.timer)
                                              .then((value) => startTimer());
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.stopRinger(
                                          widget.timer.timerId);
                                      controller.deleteTimer(
                                          widget.timer.timerId);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    child: Text(
                                      '${Utils.formatMilliseconds(widget.timer.timerValue - widget.timer.timeElapsed)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                            color: themeController.primaryTextColor.value,
                                            fontSize: 44,
                                          ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (widget.timer.isPaused == 0) {
                                            stopTimer();
                                          } else {
                                            startTimer();
                                          }
                                          widget.timer.isPaused =
                                              widget.timer.isPaused == 0 ? 1 : 0;
                                          IsarDb.updateTimerPauseStatus(widget.timer);
                                        });
                                        if (widget.timer.timeElapsed >=
                                            widget.timer.timerValue) {
                                          controller.stopRinger(widget.timer.timerId);
                                          setState(() {
                                            widget.timer.timeElapsed = 0;
                                            IsarDb.updateTimerTick(widget.timer)
                                                .then((value) =>
                                                    IsarDb.updateTimerPauseStatus(
                                                        widget.timer));
                                            widget.timer.isPaused = 1;
                                          });
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: kprimaryColor,
                                            borderRadius: BorderRadius.circular(80)),
                                        width: 80,
                                        height: 80,
                                        child: Icon(
                                          widget.timer.isPaused == 0
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
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
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
