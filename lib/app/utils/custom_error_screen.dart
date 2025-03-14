import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class CustomErrorScreen extends StatefulWidget {
  const CustomErrorScreen({
    super.key,
    required this.errorDetails,
  });

  final FlutterErrorDetails? errorDetails;

  @override
  State<CustomErrorScreen> createState() => _CustomErrorScreenState();
}

class _CustomErrorScreenState extends State<CustomErrorScreen> {
  ThemeController themeController = Get.put<ThemeController>(ThemeController());

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Obx(
      () => Scaffold(
        backgroundColor: themeController.primaryBackgroundColor.value,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error Occurred',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: themeController.primaryTextColor.value,
                        ),
                  ),
                  SizedBox(
                    height: height * 0.18,
                  ),
                  SvgPicture.asset(
                    'assets/images/warning.svg',
                    height: height * 0.3,
                    width: width * 0.8,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    kDebugMode
                        ? widget.errorDetails!.summary.toString()
                        : 'Something went wrong! Don\'t worry we\'re'
                            'working on it!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: themeController.primaryTextColor.value,
                        ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Get.offNamedUntil(
                        '/bottom-navigation-bar',
                        (route) => route.settings.name == '/splash-screen',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side:  BorderSide(
                        color: getPrimaryColorTheme(),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Navigate to Home',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: getPrimaryColorTheme(),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
