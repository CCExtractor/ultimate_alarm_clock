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
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      onTap: () async {
        Utils.hapticFeedback();
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'API Key',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          onWillPop: () async {
            Future.delayed(
              const Duration(
                milliseconds: 300,
              ),
              () {
                controller.validate.value = false;
              },
            );
            return true;
          },
          content: Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                Container(
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
                                  obscureText: false,
                                  controller: controller.apiKey,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'API Key',
                                    errorText: controller.validate.value
                                        ? 'API Key cannot be empty'
                                        : null,
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
                                          controller
                                              .showingCircularProgressIndicator
                                              .value = true;

                                          // Validation If String is empty
                                          if (await controller
                                              .apiKey.text.isEmpty) {
                                            // setState(() {
                                            controller.validate.value = true;
                                            // });
                                            controller
                                                .showingCircularProgressIndicator
                                                .value = false;
                                            return;
                                          }

                                          // Reset state after getting error message
                                          if (await controller
                                              .apiKey.text.isNotEmpty) {
                                            // setState(() {
                                            controller.validate.value = false;
                                            // });
                                          }

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
                                            if (controller
                                                    .weatherKeyState.value ==
                                                WeatherKeyState.add) {
                                              controller.weatherKeyState.value =
                                                  WeatherKeyState.saveAdded;
                                              controller
                                                  .addWeatherState('saveAdded');
                                            } else {
                                              // If it is updated
                                              controller.weatherKeyState.value =
                                                  WeatherKeyState.saveUpdated;
                                              controller.addWeatherState(
                                                  'saveUpdated');
                                            }
                                          } else {
                                            // If the API key is not valid
                                            controller.didWeatherKeyError
                                                .value = true;
                                          }
                                          controller
                                              .showingCircularProgressIndicator
                                              .value = false;
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
                                          color:
                                              themeController.isLightMode.value
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
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
                if (controller.showingCircularProgressIndicator.value)
                  Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: kprimaryColor.withOpacity(0.5),
                      valueColor: const AlwaysStoppedAnimation(
                        kprimaryColor,
                      ),
                    ),
                  ),
              ],
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
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            children: [
              Text(
                'Open Weather Map API',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              IconButton(
                icon: Icon(
                  Icons.info_sharp,
                  size: 21,
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.3)
                      : kprimaryTextColor.withOpacity(0.3),
                ),
                onPressed: () => {
                  Utils.hapticFeedback(),
                  showBottomSheet(
                    context: context,
                    backgroundColor: themeController.isLightMode.value
                        ? kLightSecondaryBackgroundColor
                        : ksecondaryBackgroundColor,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'onenweathermap_title1.1'.tr,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'onenweathermap_title1.2'.tr,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.6,
                              child: ListView(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'step1.1'.tr,
                                        ),
                                        TextSpan(
                                          text: 'step1.2'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'step1.3'.tr,
                                        ),
                                        TextSpan(
                                          text: 'step1.4'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'step1.5'.tr,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'step2.1'.tr,
                                        ),
                                        TextSpan(
                                          text: 'step2.2'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'step2.3'.tr,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'step3'.tr,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'step4.1'.tr,
                                        ),
                                        TextSpan(
                                          text: 'step4.2'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'step4.3'.tr,
                                        ),
                                        TextSpan(
                                          text: 'step4.4'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'step4.5'.tr,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'step5'.tr,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    kprimaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  Utils.hapticFeedback();
                                  Get.back();
                                },
                                child: Text(
                                  'Understood'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: themeController.isLightMode.value
                                            ? kLightPrimaryTextColor
                                            : ksecondaryTextColor,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                },
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(0.4)
                    : kprimaryTextColor.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
