import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
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

  @override
  void initState() {
    super.initState();
    controller.initializeTimer(widget.timer);
  }

  @override
  void dispose() {
    controller.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 4.0, // Adjusted height for better fit
        width: MediaQuery.of(context).size.width,
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
                      borderRadius: BorderRadius.circular(18),
                    ),
                    duration: Duration(milliseconds: 1000),
                    height: MediaQuery.of(context).size.height / 4.0,
                    width: MediaQuery.of(context).size.width *
                        ((widget.timer.timeElapsed) /
                            (widget.timer.timerValue)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.timer.timerName,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: kprimaryColor,
                                      fontSize: 16,
                                    ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.resetTimer(widget.timer);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: themeController.primaryBackgroundColor.value,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.refresh,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    controller.stopRinger(widget.timer.timerId);
                                    controller.deleteTimer(widget.timer.timerId);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: themeController.primaryBackgroundColor.value,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => AnimatedContainer(
                                duration: Duration(seconds: 1),
                                child: Text(
                                  '${Utils.formatMilliseconds(widget.timer.timerValue - widget.timer.timeElapsed)}',
                                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                        color: themeController.primaryTextColor.value,
                                        fontSize: 30, // Reduced font size for better fit
                                      ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.toggleTimer(widget.timer);
                                controller.completeTimer(widget.timer);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kprimaryColor,
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                width: 60,
                                height: 60,
                                child: Icon(
                                  widget.timer.isPaused == 0
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 24,
                                  color: ksecondaryBackgroundColor,
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
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
