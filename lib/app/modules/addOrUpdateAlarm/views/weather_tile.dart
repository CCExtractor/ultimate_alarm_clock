import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class WeatherTile extends StatelessWidget {
  const WeatherTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Obx(
      () => Container(
        child: (controller.weatherApiKeyExists.value == true)
            ? ListTile(
                onTap: () async {
                  Utils.hapticFeedback();
                  await controller.getLocation();
                  Get.defaultDialog(
                      titlePadding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      title: 'Select weather types',
                      titleStyle: Theme.of(context).textTheme.displaySmall,
                      content: Obx(
                        () => Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.selectedWeather
                                    .contains(WeatherTypes.sunny)) {
                                  controller.selectedWeather
                                      .remove(WeatherTypes.sunny);
                                } else {
                                  controller.selectedWeather
                                      .add(WeatherTypes.sunny);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: themeController
                                                      .isLightMode.value
                                                  ? kLightPrimaryTextColor
                                                      .withOpacity(0.5)
                                                  : kprimaryTextColor
                                                      .withOpacity(0.5)),
                                          value: controller.selectedWeather
                                              .contains(WeatherTypes.sunny),
                                          onChanged: (value) {
                                            Utils.hapticFeedback();
                                            if (controller.selectedWeather
                                                .contains(WeatherTypes.sunny)) {
                                              controller.selectedWeather
                                                  .remove(WeatherTypes.sunny);
                                            } else {
                                              controller.selectedWeather
                                                  .add(WeatherTypes.sunny);
                                            }
                                          }),
                                      Text(
                                        'Sunny',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 15),
                                      ),
                                    ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.selectedWeather
                                    .contains(WeatherTypes.cloudy)) {
                                  controller.selectedWeather
                                      .remove(WeatherTypes.cloudy);
                                } else {
                                  controller.selectedWeather
                                      .add(WeatherTypes.cloudy);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: themeController
                                                      .isLightMode.value
                                                  ? kLightPrimaryTextColor
                                                      .withOpacity(0.5)
                                                  : kprimaryTextColor
                                                      .withOpacity(0.5)),
                                          value: controller.selectedWeather
                                              .contains(WeatherTypes.cloudy),
                                          onChanged: (value) {
                                            Utils.hapticFeedback();
                                            if (controller.selectedWeather
                                                .contains(
                                                    WeatherTypes.cloudy)) {
                                              controller.selectedWeather
                                                  .remove(WeatherTypes.cloudy);
                                            } else {
                                              controller.selectedWeather
                                                  .add(WeatherTypes.cloudy);
                                            }
                                          }),
                                      Text(
                                        'Cloudy',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 15),
                                      ),
                                    ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.selectedWeather
                                    .contains(WeatherTypes.rainy)) {
                                  controller.selectedWeather
                                      .remove(WeatherTypes.rainy);
                                } else {
                                  controller.selectedWeather
                                      .add(WeatherTypes.rainy);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: themeController
                                                      .isLightMode.value
                                                  ? kLightPrimaryTextColor
                                                      .withOpacity(0.5)
                                                  : kprimaryTextColor
                                                      .withOpacity(0.5)),
                                          value: controller.selectedWeather
                                              .contains(WeatherTypes.rainy),
                                          onChanged: (value) {
                                            Utils.hapticFeedback();
                                            if (controller.selectedWeather
                                                .contains(WeatherTypes.rainy)) {
                                              controller.selectedWeather
                                                  .remove(WeatherTypes.rainy);
                                            } else {
                                              controller.selectedWeather
                                                  .add(WeatherTypes.rainy);
                                            }
                                          }),
                                      Text(
                                        'Rainy',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 15),
                                      ),
                                    ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.selectedWeather
                                    .contains(WeatherTypes.windy)) {
                                  controller.selectedWeather
                                      .remove(WeatherTypes.windy);
                                } else {
                                  controller.selectedWeather
                                      .add(WeatherTypes.windy);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: themeController
                                                      .isLightMode.value
                                                  ? kLightPrimaryTextColor
                                                      .withOpacity(0.5)
                                                  : kprimaryTextColor
                                                      .withOpacity(0.5)),
                                          value: controller.selectedWeather
                                              .contains(WeatherTypes.windy),
                                          onChanged: (value) {
                                            Utils.hapticFeedback();
                                            if (controller.selectedWeather
                                                .contains(WeatherTypes.windy)) {
                                              controller.selectedWeather
                                                  .remove(WeatherTypes.windy);
                                            } else {
                                              controller.selectedWeather
                                                  .add(WeatherTypes.windy);
                                            }
                                          }),
                                      Text(
                                        'Windy',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 15),
                                      ),
                                    ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Utils.hapticFeedback();
                                if (controller.selectedWeather
                                    .contains(WeatherTypes.stormy)) {
                                  controller.selectedWeather
                                      .remove(WeatherTypes.stormy);
                                } else {
                                  controller.selectedWeather
                                      .add(WeatherTypes.stormy);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          side: BorderSide(
                                              width: 1.5,
                                              color: themeController
                                                      .isLightMode.value
                                                  ? kLightPrimaryTextColor
                                                      .withOpacity(0.5)
                                                  : kprimaryTextColor
                                                      .withOpacity(0.5)),
                                          value: controller.selectedWeather
                                              .contains(WeatherTypes.stormy),
                                          onChanged: (value) {
                                            Utils.hapticFeedback();
                                            if (controller.selectedWeather
                                                .contains(
                                                    WeatherTypes.stormy)) {
                                              controller.selectedWeather
                                                  .remove(WeatherTypes.stormy);
                                            } else {
                                              controller.selectedWeather
                                                  .add(WeatherTypes.stormy);
                                            }
                                          }),
                                      Text(
                                        'Stormy',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 15),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
                tileColor: themeController.isLightMode.value
                    ? kLightSecondaryBackgroundColor
                    : ksecondaryBackgroundColor,
                title: Row(
                  children: [
                    Text('Weather Condition',
                        style: TextStyle(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor,
                            fontWeight: FontWeight.w500)),
                    IconButton(
                      icon: Icon(
                        Icons.info_sharp,
                        size: 21,
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor.withOpacity(0.3)
                            : kprimaryTextColor.withOpacity(0.3),
                      ),
                      onPressed: () {
                        Utils.hapticFeedback();
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: themeController.isLightMode.value
                                ? kLightSecondaryBackgroundColor
                                : ksecondaryBackgroundColor,
                            builder: (context) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.cloudy_snowing,
                                        color: themeController.isLightMode.value
                                            ? kLightPrimaryTextColor
                                            : kprimaryTextColor,
                                        size: height * 0.1,
                                      ),
                                      Text("Weather based cancellation",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          "This feature will automatically cancel the alarm if the current weather matches your chosen weather conditions, allowing you to sleep better!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kprimaryColor),
                                          ),
                                          onPressed: () {
                                            Utils.hapticFeedback();
                                            Get.back();
                                          },
                                          child: Text(
                                            'Understood',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: themeController
                                                            .isLightMode.value
                                                        ? kLightPrimaryTextColor
                                                        : ksecondaryTextColor),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ],
                ),
                trailing: InkWell(
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.weatherTypes.value,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: (controller.isWeatherEnabled.value ==
                                            false)
                                        ? kprimaryDisabledTextColor
                                        : themeController.isLightMode.value
                                            ? kLightPrimaryTextColor
                                            : kprimaryTextColor),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: kprimaryDisabledTextColor,
                        )
                      ]),
                ),
              )
            : ListTile(
                onTap: () {
                  Utils.hapticFeedback();
                  Get.defaultDialog(
                      contentPadding: EdgeInsets.all(10.0),
                      titlePadding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: themeController.isLightMode.value
                          ? kLightSecondaryBackgroundColor
                          : ksecondaryBackgroundColor,
                      title: 'Disabled!',
                      titleStyle: Theme.of(context).textTheme.displaySmall,
                      content: Column(
                        children: [
                          const Text(
                              "To use this feature, you have to add an OpenWeatherMap API key!"),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kprimaryColor)),
                                  child: Text(
                                    'Go to settings',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            color: themeController
                                                    .isLightMode.value
                                                ? kLightPrimaryTextColor
                                                : ksecondaryTextColor),
                                  ),
                                  onPressed: () {
                                    Utils.hapticFeedback();
                                    Get.back();
                                    Get.toNamed('/settings');
                                  },
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              themeController
                                                      .isLightMode.value
                                                  ? kLightPrimaryTextColor
                                                      .withOpacity(0.5)
                                                  : kprimaryTextColor
                                                      .withOpacity(0.5))),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            color: themeController
                                                    .isLightMode.value
                                                ? kLightPrimaryTextColor
                                                : kprimaryTextColor),
                                  ),
                                  onPressed: () {
                                    Utils.hapticFeedback();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
                },
                tileColor: themeController.isLightMode.value
                    ? kLightSecondaryBackgroundColor
                    : ksecondaryBackgroundColor,
                title: Row(
                  children: [
                    Text('Weather Condition',
                        style: TextStyle(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor,
                            fontWeight: FontWeight.w500)),
                    IconButton(
                      icon: Icon(
                        Icons.info_sharp,
                        size: 21,
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor.withOpacity(0.45)
                            : kprimaryTextColor.withOpacity(0.3),
                      ),
                      onPressed: () {
                        Utils.hapticFeedback();
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: themeController.isLightMode.value
                                ? kLightSecondaryBackgroundColor
                                : ksecondaryBackgroundColor,
                            builder: (context) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.cloudy_snowing,
                                        color: themeController.isLightMode.value
                                            ? kLightPrimaryTextColor
                                            : kprimaryTextColor,
                                        size: height * 0.1,
                                      ),
                                      Text("Weather based cancellation",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          "This feature will automatically cancel the alarm if the current weather matches your chosen weather conditions, allowing you to sleep better!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kprimaryColor),
                                          ),
                                          onPressed: () {
                                            Utils.hapticFeedback();
                                            Get.back();
                                          },
                                          child: Text(
                                            'Understood',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: themeController
                                                            .isLightMode.value
                                                        ? kLightSecondaryTextColor
                                                        : ksecondaryTextColor),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ],
                ),
                trailing: InkWell(
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Icon(
                          Icons.lock,
                          color: themeController.isLightMode.value
                              ? kLightPrimaryTextColor.withOpacity(0.7)
                              : kprimaryTextColor.withOpacity(0.7),
                        )
                      ]),
                )),
      ),
    );
  }
}
