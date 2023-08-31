import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/splashScreen/controllers/splash_screen_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: Image.asset(
                  'assets/images/ic_launcher-playstore-nobg.png',
                  fit: BoxFit.cover,
                  width: width / 2,
                  height: width / 2,
                ),
              ),
              Text(
                'Ultimate Alarm Clock',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: kprimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
