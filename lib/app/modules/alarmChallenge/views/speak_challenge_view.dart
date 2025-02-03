import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmChallenge/controllers/alarm_challenge_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';


class SpeakChallengeView extends GetView<AlarmChallengeController> {
  SpeakChallengeView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    // var height = Get.height;
    // ignore: unused_local_variable
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: const Color(0xff16171C),
        title: const Text('Speak Challenge'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: controller.speechToText.isListening ?
          controller.stopListening : controller.startListening,
          tooltip: 'Listen',
          heroTag: null,
          child: Obx(()=>Icon(controller.isListening.value ? Icons.mic_off : Icons.mic),
          ),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Repeat The Phrase:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Flexible(
              child: Container(
                //color: Colors.amber,
                padding: const EdgeInsets.all(16),
                child:Obx(()=> Text(controller.randomSentence.value.toString(),
                    style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Spoken Phrase:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Flexible(
              child: Container(
                //color: Colors.amber,
                padding: const EdgeInsets.all(16),
                child:Obx(()=>Text('${controller.spokenText.value}',
                  style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}