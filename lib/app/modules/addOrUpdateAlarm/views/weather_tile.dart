import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class WeatherTile extends StatelessWidget {
  const WeatherTile({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListTile(
            onTap: () async {
              Utils.hapticFeedback();
              await controller.checkAndRequestPermission();
              Get.defaultDialog(
                titlePadding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: themeController.secondaryBackgroundColor.value,
                title: 'Select weather types'.tr,
                titleStyle: Theme.of(context).textTheme.displaySmall,
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WeatherOption(
                        type: WeatherTypes.sunny,
                        label: 'Sunny',
                        controller: controller,
                        themeController: themeController,
                      ),
                      WeatherOption(
                        type: WeatherTypes.cloudy,
                        label: 'Cloudy',
                        controller: controller,
                        themeController: themeController,
                      ),
                      WeatherOption(
                        type: WeatherTypes.rainy,
                        label: 'Rainy',
                        controller: controller,
                        themeController: themeController,
                      ),
                      WeatherOption(
                        type: WeatherTypes.windy,
                        label: 'Windy',
                        controller: controller,
                        themeController: themeController,
                      ),
                      WeatherOption(
                        type: WeatherTypes.stormy,
                        label: 'Stormy',
                        controller: controller,
                        themeController: themeController,
                      ),
                    ],
                  ),
                ),
              );
            },
            title: Container(
              width: width * 0.5, // 50% of screen width
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      'Weather Condition'.tr,
                      style: TextStyle(
                        color: themeController.primaryTextColor.value,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(maxWidth: width * 0.08),
                    icon: Icon(
                      Icons.info_sharp,
                      size: 21,
                      color: themeController.primaryTextColor.value
                          .withOpacity(0.3),
                    ),
                    onPressed: () {
                      Utils.hapticFeedback();
                      showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            themeController.secondaryBackgroundColor.value,
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
                                    color:
                                        themeController.primaryTextColor.value,
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
            ),
            trailing: Container(
              width: width * 0.35, // 35% of screen width
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.weatherTypes.value,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: kprimaryDisabledTextColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class WeatherOption extends StatelessWidget {
  final WeatherTypes type;
  final String label;
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  const WeatherOption({
    Key? key,
    required this.type,
    required this.label,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Utils.hapticFeedback();
        if (controller.selectedWeather.contains(type)) {
          controller.selectedWeather.remove(type);
        } else {
          controller.selectedWeather.add(type);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            Obx(
              () => Checkbox.adaptive(
                side: BorderSide(
                  width: width * 0.0015,
                  color:
                      themeController.primaryTextColor.value.withOpacity(0.5),
                ),
                value: controller.selectedWeather.contains(type),
                activeColor: kprimaryColor.withOpacity(0.8),
                onChanged: (value) {
                  Utils.hapticFeedback();
                  if (controller.selectedWeather.contains(type)) {
                    controller.selectedWeather.remove(type);
                  } else {
                    controller.selectedWeather.add(type);
                  }
                },
              ),
            ),
            Text(
              label.tr,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 15,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
