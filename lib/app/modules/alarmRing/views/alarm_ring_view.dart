import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import '../controllers/alarm_ring_controller.dart';

class AlarmControlView extends GetView<AlarmControlController> {
  const AlarmControlView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.all(18.0),
            child: SizedBox(
              height: height * 0.06,
              width: width * 0.8,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kprimaryColor)),
                child: Text(
                  'Dismiss',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: ksecondaryTextColor),
                ),
                onPressed: () {
                  Get.offNamed('/home');
                },
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(
                  () => Column(
                    children: [
                      Text(
                        controller.formattedDate.value,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 10,
                        width: 0,
                      ),
                      Text(
                        "${controller.timeNow[0]} ${controller.timeNow[1]}",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontSize: 50),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.055,
                  width: width * 0.25,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            ksecondaryBackgroundColor)),
                    child: Text(
                      'Snooze',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: kprimaryTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )),
    );
  }
}
