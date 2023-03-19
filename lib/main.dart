import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: kThemeData,
      title: "UltiClock",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
