import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Alarm.init();
  runApp(
    GetMaterialApp(
      title: "UltiClock",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
