import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/main.dart';

import '../controllers/add_alarm_controller.dart';

class AddAlarmView extends GetView<AddAlarmController> {
  AddAlarmView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return WithForegroundTask(
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
                  'Save',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: ksecondaryTextColor),
                ),
                onPressed: () {
                  AlarmModel alarmRecord = AlarmModel(
                    alarmTime: Utils.timeOfDayToString(
                        TimeOfDay.fromDateTime(controller.selectedTime.value)),
                    intervalToAlarm: Utils.getMillisecondsToAlarm(
                        DateTime.now(), controller.selectedTime.value),
                    isActivityEnabled: controller.isActivityenabled.value,
                  );
                  objectbox.insertAlarm(alarmRecord);
                  // Starting service mandatorily!
                  controller.createForegroundTask(Utils.getMillisecondsToAlarm(
                      DateTime.now(), controller.selectedTime.value));
                  controller.startForegroundTask(alarmRecord.alarmTime);
                },
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: ksecondaryBackgroundColor,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              'Add your alarm',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          body: Column(
            children: [
              Container(
                color: ksecondaryBackgroundColor,
                height: height * 0.28,
                width: width,
                child: TimePickerSpinner(
                  isForce2Digits: true,
                  alignment: Alignment.center,
                  is24HourMode: false,
                  normalTextStyle: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(
                          fontWeight: FontWeight.normal,
                          color: kprimaryDisabledTextColor),
                  highlightedTextStyle:
                      Theme.of(context).textTheme.displayMedium,
                  onTimeChange: (dateTime) {
                    controller.selectedTime.value = dateTime;
                  },
                ),
              ),
              Container(
                color: ksecondaryTextColor,
                height: 10,
                width: width,
              ),
              Container(
                color: ksecondaryBackgroundColor,
                child: Column(children: [
                  Obx(
                    () => ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Text(
                            'Enable Activity',
                            style: const TextStyle(color: kprimaryTextColor),
                          ),
                          trailing: Switch(
                            onChanged: (value) {
                              controller.isActivityenabled.value = value;
                            },
                            value: controller.isActivityenabled.value,
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              )
            ],
          )),
    );
  }
}
