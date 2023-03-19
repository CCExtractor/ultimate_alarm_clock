import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/objectbox.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import 'app/routes/app_pages.dart';

late ObjectBox objectbox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.init();
  runApp(
    GetMaterialApp(
      theme: kThemeData,
      title: "UltiClock",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
