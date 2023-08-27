import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/information_button.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class WeatherTile extends StatelessWidget {
  const WeatherTile({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Obx(
      () => Container(
        child: (controller.weatherApiKeyExists.value == true)
            ? ListTile(
                onTap: () async {
                  await controller.getLocation();
                  Get.defaultDialog(
                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: ksecondaryBackgroundColor,
                    title: 'Select weather types',
                    titleStyle: Theme.of(context).textTheme.displaySmall,
                    content: Obx(
                      () => Column(
                        children: [
                          weatherCheckbox(
                            context: context,
                            weather: WeatherTypes.sunny,
                            weatherTitle: 'Sunny',
                          ),
                          weatherCheckbox(
                            context: context,
                            weather: WeatherTypes.cloudy,
                            weatherTitle: 'Cloudy',
                          ),
                          weatherCheckbox(
                            context: context,
                            weather: WeatherTypes.rainy,
                            weatherTitle: 'Rainy',
                          ),
                          weatherCheckbox(
                            context: context,
                            weather: WeatherTypes.windy,
                            weatherTitle: 'Windy',
                          ),
                          weatherCheckbox(
                            context: context,
                            weather: WeatherTypes.stormy,
                            weatherTitle: 'Stormy',
                          ),
                        ],
                      ),
                    ),
                  );
                },
                tileColor: ksecondaryBackgroundColor,
                title: Row(
                  children: [
                    const Text(
                      'Weather Condition',
                      style: TextStyle(
                        color: kprimaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InformationButton(
                      infoIconData: Icons.cloudy_snowing,
                      height: height,
                      width: width,
                      infoTitle: "Weather based cancellation",
                      infoDescription:
                          "This feature will automatically cancel the alarm if the current weather matches your chosen weather conditions, allowing you to sleep better!",
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
                                        : kprimaryTextColor,
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
            : ListTile(
                onTap: () {
                  Get.defaultDialog(
                    contentPadding: const EdgeInsets.all(10.0),
                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: ksecondaryBackgroundColor,
                    title: 'Disabled!',
                    titleStyle: Theme.of(context).textTheme.displaySmall,
                    content: Column(
                      children: [
                        const Text(
                          "To use this feature, you have to add an OpenWeatherMap API key!",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kprimaryColor),
                                ),
                                child: Text(
                                  'Go to settings',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: ksecondaryTextColor),
                                ),
                                onPressed: () {
                                  Get.back();
                                  Get.toNamed('/settings');
                                },
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    kprimaryTextColor.withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: kprimaryTextColor),
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                tileColor: ksecondaryBackgroundColor,
                title: Row(
                  children: [
                    const Text(
                      'Weather Condition',
                      style: TextStyle(
                          color: kprimaryTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                    InformationButton(
                      infoIconData: Icons.cloudy_snowing,
                      height: height,
                      width: width,
                      infoTitle: "Weather based cancellation",
                      infoDescription:
                          "This feature will automatically cancel the alarm if the current weather matches your chosen weather conditions, allowing you to sleep better!",
                    ),
                  ],
                ),
                trailing: InkWell(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Icon(
                        Icons.lock,
                        color: kprimaryTextColor.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget weatherCheckbox({
    required BuildContext context,
    required WeatherTypes weather,
    required String weatherTitle,
  }) {
    return InkWell(
      onTap: () {
        if (controller.selectedWeather.contains(weather)) {
          controller.selectedWeather.remove(weather);
        } else {
          controller.selectedWeather.add(weather);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              side: BorderSide(
                width: 1.5,
                color: kprimaryTextColor.withOpacity(0.5),
              ),
              value: controller.selectedWeather.contains(weather),
              onChanged: (value) {
                if (controller.selectedWeather.contains(weather)) {
                  controller.selectedWeather.remove(weather);
                } else {
                  controller.selectedWeather.add(weather);
                }
              },
            ),
            Text(
              weatherTitle,
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
