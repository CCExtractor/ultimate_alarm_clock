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
    // var width = Get.width;
    // var height = Get.height;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Obx(
      () => Container(
        child:  ListTile(
                onTap: () async {
                  Utils.hapticFeedback();
                  await controller.checkAndRequestPermission();
                  Get.defaultDialog(
                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: themeController.secondaryBackgroundColor.value,
                    title: 'Select weather types'.tr,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox.adaptive(
                                    side: BorderSide(
                                      width: width*0.0015,
                                      color: themeController.primaryTextColor.value.withOpacity(0.5),
                                    ),
                                    value: controller.selectedWeather
                                        .contains(WeatherTypes.sunny),
                                    activeColor: kprimaryColor.withOpacity(0.8),
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
                                    },
                                  ),
                                  Text(
                                    'Sunny'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox.adaptive(
                                    side: BorderSide(
                                      width: width*0.0015,
                                      color: themeController.primaryTextColor.value.withOpacity(0.5),
                                    ),
                                    value: controller.selectedWeather
                                        .contains(WeatherTypes.cloudy),
                                    activeColor: kprimaryColor.withOpacity(0.8),
                                    onChanged: (value) {
                                      Utils.hapticFeedback();
                                      if (controller.selectedWeather.contains(
                                        WeatherTypes.cloudy,
                                      )) {
                                        controller.selectedWeather
                                            .remove(WeatherTypes.cloudy);
                                      } else {
                                        controller.selectedWeather
                                            .add(WeatherTypes.cloudy);
                                      }
                                    },
                                  ),
                                  Text(
                                    'Cloudy'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox.adaptive(
                                    side: BorderSide(
                                      width: width*0.0015,
                                      color: themeController.primaryTextColor.value.withOpacity(0.5),
                                    ),
                                    value: controller.selectedWeather
                                        .contains(WeatherTypes.rainy),
                                    activeColor: kprimaryColor.withOpacity(0.8),
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
                                    },
                                  ),
                                  Text(
                                    'Rainy'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox.adaptive(
                                    side: BorderSide(
                                      width: width*0.0015,
                                      color: themeController.primaryTextColor.value.withOpacity(0.5),
                                    ),
                                    value: controller.selectedWeather
                                        .contains(WeatherTypes.windy),
                                    activeColor: kprimaryColor.withOpacity(0.8),
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
                                    },
                                  ),
                                  Text(
                                    'Windy'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox.adaptive(
                                    side: BorderSide(
                                      width: width*0.0015,
                                      color: themeController.primaryTextColor.value.withOpacity(0.5),
                                    ),
                                    value: controller.selectedWeather
                                        .contains(WeatherTypes.stormy),
                                    activeColor: kprimaryColor.withOpacity(0.8),
                                    onChanged: (value) {
                                      Utils.hapticFeedback();
                                      if (controller.selectedWeather.contains(
                                        WeatherTypes.stormy,
                                      )) {
                                        controller.selectedWeather
                                            .remove(WeatherTypes.stormy);
                                      } else {
                                        controller.selectedWeather
                                            .add(WeatherTypes.stormy);
                                      }
                                    },
                                  ),
                                  Text(
                                    'Stormy'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },

                title: Row(
                  children: [
                    FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Weather Condition'.tr,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info_sharp,
                        size: 21,
                        color: themeController.primaryTextColor.value.withOpacity(0.3),
                      ),
                      onPressed: () {
                        Utils.hapticFeedback();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: themeController.secondaryBackgroundColor.value,
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
                                      color: themeController.primaryTextColor.value,
                                      size: height * 0.1,
                                    ),
                                    Text(
                                      'Weather based cancellation'.tr,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Text(
                                        // 'This feature will automatically'
                                        // ' cancel the alarm if the current'
                                        // ' weather matches your chosen'
                                        // ' weather conditions, allowing you'
                                        // ' to sleep better!',
                                        'weatherDescription'.tr,
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
                                                color: themeController
                                                        .secondaryTextColor.value,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
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
                                color:
                                    (controller.isWeatherEnabled.value == false)
                                        ? kprimaryDisabledTextColor
                                        : themeController.primaryTextColor.value,
                              ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: kprimaryDisabledTextColor,
                      ),
                    ],
                  ),
                ),
              )
      ),
    );
  }
}
