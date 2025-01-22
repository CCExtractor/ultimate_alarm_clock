import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          child: ListTile(
        onTap: () async {
          Utils.hapticFeedback();
          await controller.getLocation();
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
                        controller.selectedWeather.remove(WeatherTypes.sunny);
                      } else {
                        controller.selectedWeather.add(WeatherTypes.sunny);
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
                              width: 1.5.w,
                              color: themeController.primaryTextColor.value
                                  .withOpacity(0.5),
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
                        controller.selectedWeather.remove(WeatherTypes.cloudy);
                      } else {
                        controller.selectedWeather.add(WeatherTypes.cloudy);
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
                              width: width * 0.0015,
                              color: themeController.primaryTextColor.value
                                  .withOpacity(0.5),
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
                        controller.selectedWeather.remove(WeatherTypes.rainy);
                      } else {
                        controller.selectedWeather.add(WeatherTypes.rainy);
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
                              width: width * 0.0015,
                              color: themeController.primaryTextColor.value
                                  .withOpacity(0.5),
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
                        controller.selectedWeather.remove(WeatherTypes.windy);
                      } else {
                        controller.selectedWeather.add(WeatherTypes.windy);
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
                              width: width * 0.0015,
                              color: themeController.primaryTextColor.value
                                  .withOpacity(0.5),
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
                        controller.selectedWeather.remove(WeatherTypes.stormy);
                      } else {
                        controller.selectedWeather.add(WeatherTypes.stormy);
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
                              width: width * 0.0015,
                              color: themeController.primaryTextColor.value
                                  .withOpacity(0.5),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                'Weather Condition '.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            SizedBox(
              width: 28.r,
              height: 28.r,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  maxWidth: 28.w,
                  maxHeight: 32.h,
                ),
                icon: Icon(
                  Icons.info_sharp,
                  size: 21.r,
                  color:
                      themeController.primaryTextColor.value.withOpacity(0.3),
                ),
                onPressed: () {
                  Utils.showModal(
                    context: context,
                    title: 'Weather based cancellation'.tr,
                    description: 'weatherDescription'.tr,
                    iconData: Icons.cloudy_snowing,
                    isLightMode:
                        themeController.currentTheme.value == ThemeMode.light,
                  );
                },
              ),
            ),
          ],
        ),
        trailing: InkWell(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Obx(
                    () => Container(
                      width: 100.w,
                      child: Text(
                        controller.weatherTypes.value,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14.sp,
                              color:
                                  (controller.isWeatherEnabled.value == false)
                                      ? kprimaryDisabledTextColor
                                      : themeController.primaryTextColor.value,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              Icon(
                size: 24.r,
                Icons.chevron_right,
                color: kprimaryDisabledTextColor,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
