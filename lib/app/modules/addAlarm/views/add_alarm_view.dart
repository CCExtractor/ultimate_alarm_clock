import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_alarm_controller.dart';

class AddAlarmView extends GetView<AddAlarmController> {
  const AddAlarmView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final alarmSettings = AlarmSettings(
            dateTime: DateTime.now().add(Duration(seconds: 10)),
            assetAudioPath: 'assets/music/alarm.mp3',
            loopAudio: true,
            notificationTitle: 'This is the title',
            notificationBody: 'This is the body',
            enableNotificationOnKill: false,
          );
          await Alarm.set(settings: alarmSettings);
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
    );
  }
}
