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
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'API Key',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Container(
              // If the user hasn't clicked on the 'Save' or 'Update' button of
              // the dialog, or there is no error in the weather key, then
              // show the dialog
              child: (controller.weatherKeyState.value !=
                          WeatherKeyState.saveAdded &&
                      controller.weatherKeyState.value !=
                          WeatherKeyState.saveUpdated)
                  ? (controller.didWeatherKeyError.value == false)
                      ? Column(
                          children: [
                            TextField(
                              autofocus: true,
                              obscureText: false,
                              controller: controller.apiKey,
                              decoration: const InputDecoration(
                                hintText: 'Enter API Key...',
                              ),
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
                                        kprimaryColor,
                                      ),
                                    ),
                                    child: Text(
                                      // If the weather state is add, then
                                      // show 'Save' else show 'Update' text
                                      // on the button
                                      controller.weatherKeyState.value ==
                                              WeatherKeyState.add
                                          ? 'Save'
                                          : 'Update',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                            color: themeController
                                                    .isLightMode.value
                                                ? kLightPrimaryTextColor
                                                : ksecondaryTextColor,
                                          ),
                                    ),
                                    onPressed: () async {
                                      Utils.hapticFeedback();

                                      // Get the user's location
                                      await controller.getLocation();

                                      // If the API key is valid
                                      if (await controller.isApiKeyValid(
                                        controller.apiKey.text,
                                      )) {
                                        // Add the key to the storage
                                        await controller.addKey(
                                          ApiKeys.openWeatherMap,
                                          controller.apiKey.text,
                                        );

                                        // If it is added for the first time
                                        if (controller.weatherKeyState.value ==
                                            WeatherKeyState.add) {
                                          controller.weatherKeyState.value =
                                              WeatherKeyState.saveAdded;
                                          controller
                                              .addWeatherState('saveAdded');
                                        } else {
                                          // If it is updated
                                          controller.weatherKeyState.value =
                                              WeatherKeyState.saveUpdated;
                                          controller
                                              .addWeatherState('saveUpdated');
                                        }
                                      } else {
                                        // If the API key is not valid
                                        controller.didWeatherKeyError.value =
                                            true;
                                      }
                                    },
                                  ),
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
                                    },
                                  ),
                                ],
                              ),
                            ),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                'Error adding key!',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  kprimaryColor,
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: themeController.isLightMode.value
                                          ? kLightSecondaryTextColor
                                          : ksecondaryTextColor,
                                    ),
                              ),
                              onPressed: () {
                                Utils.hapticFeedback();
                                controller.didWeatherKeyError.value = false;
                              },
                            ),
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
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            // If the user clicked on the 'Save' button, then
                            controller.weatherKeyState.value ==
                                    WeatherKeyState.saveAdded
                                ? 'Your API Key is added!' // show this message
                                : 'Your API Key is updated!',
                            // else this message
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kprimaryColor),
                          ),
                          child: Text(
                            'Okay',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: themeController.isLightMode.value
                                      ? kLightSecondaryTextColor
                                      : ksecondaryTextColor,
                                ),
                          ),
                          onPressed: () {
                            Utils.hapticFeedback();

                            // Assign the weather state to update, and save
                            // it in the local storage
                            controller.weatherKeyState.value =
                                WeatherKeyState.update;
                            controller.addWeatherState('update');
                            Get.back();
                          },
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
      child: Container(
        width: width * 0.91,
        height: height * 0.1,
        decoration: Utils.getCustomTileBoxDecoration(
          isLightMode: themeController.isLightMode.value,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Open Weather Map API',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
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
