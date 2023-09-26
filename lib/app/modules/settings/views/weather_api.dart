import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WeatherApi extends StatelessWidget {
  const WeatherApi({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  });

  final SettingsController controller;
  final ThemeController themeController;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Utils.hapticFeedback();
        Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 20),
            backgroundColor: themeController.isLightMode.value
                ? kLightSecondaryBackgroundColor
                : ksecondaryBackgroundColor,
            title: 'API Key',
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
              () => Container(
                  child: (controller.isWeatherKeyAdded.value == false)
                      ? (controller.didWeatherKeyError.value == false)
                          ? Column(
                              children: [
                                TextField(
                                  obscureText: false,
                                  controller: controller.apiKey,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kprimaryColor),
                                          ),
                                          child: Text(
                                            'Save',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: themeController
                                                            .isLightMode.value
                                                        ? kLightPrimaryTextColor
                                                        : ksecondaryTextColor),
                                          ),
                                          onPressed: () async {
                                            Utils.hapticFeedback();
                                            await controller.getLocation();
                                            if (await controller.isApiKeyValid(
                                                controller.apiKey.text)) {
                                              await controller.addKey(
                                                  ApiKeys.openWeatherMap,
                                                  controller.apiKey.text);
                                              controller.isWeatherKeyAdded
                                                  .value = true;
                                            } else {
                                              controller.didWeatherKeyError
                                                  .value = true;
                                            }
                                          }),
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              color: kprimaryColor,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            'Get Key',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                  color: kprimaryColor,
                                                ),
                                          ),
                                          onPressed: () async {
                                            Utils.hapticFeedback();
                                            const url =
                                                'https://home.openweathermap.org/api_keys';
                                            if (await canLaunchUrlString(url)) {
                                              await launchUrlString(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          }),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                const Icon(
                                  Icons.close,
                                  size: 50,
                                  color: Colors.red,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Text(
                                    "Error adding key!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ),
                                TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kprimaryColor)),
                                    child: Text(
                                      'Retry',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              color: themeController
                                                      .isLightMode.value
                                                  ? kLightSecondaryTextColor
                                                  : ksecondaryTextColor),
                                    ),
                                    onPressed: () {
                                      Utils.hapticFeedback();
                                      controller.didWeatherKeyError.value =
                                          false;
                                    }),
                              ],
                            )
                      : Column(
                          children: [
                            const Icon(
                              Icons.done,
                              size: 50,
                              color: Colors.green,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                "Your API key is added!",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        kprimaryColor)),
                                child: Text(
                                  'Okay',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color:
                                              themeController.isLightMode.value
                                                  ? kLightSecondaryTextColor
                                                  : ksecondaryTextColor),
                                ),
                                onPressed: () {
                                  Utils.hapticFeedback();
                                  Get.back();
                                }),
                          ],
                        )),
            ));
      },
      child: Container(
        width: width * 0.91,
        height: height * 0.1,
        decoration: Utils.getCustomTileBoxDecoration(
            isLightMode: themeController.isLightMode.value),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Open Weather Map API',
                style: Theme.of(context).textTheme.bodyLarge),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor.withOpacity(0.4)
                  : kprimaryTextColor.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
