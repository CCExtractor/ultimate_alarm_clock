import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/splashScreen/controllers/splash_screen_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/splashScreen/views/splash_screen_view.dart';

void main() {
  setUpAll(() {
    Get.put(SplashScreenController());
  });

  tearDownAll(() {
    Get.reset();
  });

  testWidgets('SplashScreenView Test', (widgetTester) async {
    await widgetTester.pumpWidget(
      const GetMaterialApp(
        home: SplashScreenView(),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });
}
