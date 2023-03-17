import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:get/get.dart';

import '../controllers/add_alarm_controller.dart';

class AddAlarmView extends GetView<AddAlarmController> {
  final bool _enabled = true;
  AddAlarmView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            controller.createForegroundTask(controller.getMillisecondsToAlarm(
                DateTime.now(), DateTime.now().add(Duration(minutes: 1))));
            controller.startForegroundTask(1.toString());
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
