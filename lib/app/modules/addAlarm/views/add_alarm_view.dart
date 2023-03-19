import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
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
                onPressed: () {},
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
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(
                          'Enable Activity',
                          style: const TextStyle(color: kprimaryTextColor),
                        ),
                        trailing: Switch(
                          onChanged: (value) {},
                          value: true,
                        ),
                      )
                    ],
                  )
                ]),
              )
            ],
          )),
    );
  }
}
