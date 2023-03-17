import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/alarm_control_controller.dart';

class AlarmControlView extends GetView<AlarmControlController> {
  const AlarmControlView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlarmControlView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AlarmControlView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
