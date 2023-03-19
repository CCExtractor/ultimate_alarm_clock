import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/add_alarm_controller.dart';

class AddAlarmView extends GetView<AddAlarmController> {
  final bool _enabled = true;
  AddAlarmView({Key? key}) : super(key: key);
  Future<TimeOfDay?> selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Get.defaultDialog(
                title: "Add Alarm",
                content: Column(
                  children: [
                    TextButton.icon(
                        onPressed: () async {
                          final TimeOfDay? selectedTime =
                              await selectTime(context);
                          if (selectedTime != null) {
                            controller.selectedTime.value = selectedTime;
                          }
                        },
                        icon: Icon(Icons.alarm),
                        label: Text('Select time!')),
                    TextButton(
                        onPressed: () {
                          controller.addTime(Utils.timeOfDayToString(
                              controller.selectedTime.value));
                          controller.createForegroundTask(
                              Utils.getMillisecondsToAlarm(DateTime.now(),
                                  DateTime.now().add(Duration(minutes: 1))));
                          controller.startForegroundTask(1.toString());
                        },
                        child: Text('Add alarm!'))
                  ],
                ));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('AddAlarmView'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'AddAlarmView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
