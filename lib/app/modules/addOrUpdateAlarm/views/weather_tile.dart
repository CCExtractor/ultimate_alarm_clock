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
      child: Column(
        children: [
          ListTile(
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
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cloudy_snowing,
                                  color: themeController.primaryTextColor.value,
                                  size: height * 0.1,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Enhanced Weather Conditions'.tr,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Choose how your alarm responds to weather conditions:',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                _buildInfoItem(context, Icons.alarm, 'Ring When Match', 'Alarm rings when weather matches selected types'),
                                _buildInfoItem(context, Icons.alarm_off, 'Cancel When Match', 'Alarm is cancelled when weather matches selected types'),
                                _buildInfoItem(context, Icons.alarm_on, 'Ring When Different', 'Alarm rings when weather is different from selected types'),
                                _buildInfoItem(context, Icons.cancel, 'Cancel When Different', 'Alarm is cancelled when weather is different from selected types'),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: width,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(kprimaryColor),
                                    ),
                                    onPressed: () {
                                      Utils.hapticFeedback();
                                      Get.back();
                                    },
                                    child: Text(
                                      'Understood'.tr,
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                        color: themeController.secondaryTextColor.value,
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
            trailing: Obx(
              () => Switch(
                value: controller.weatherConditionType.value != WeatherConditionType.off,
                onChanged: (value) {
                  Utils.hapticFeedback();
                  if (value) {
                    controller.weatherConditionType.value = WeatherConditionType.cancelWhenMatch;
                  } else {
                    controller.weatherConditionType.value = WeatherConditionType.off;
                  }
                },
                activeColor: kprimaryColor,
              ),
            ),
          ),
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: controller.weatherConditionType.value != WeatherConditionType.off
                  ? null
                  : 0,
              child: controller.weatherConditionType.value != WeatherConditionType.off
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          ...WeatherConditionType.values.where((type) => type != WeatherConditionType.off).map(
                            (conditionType) => _buildWeatherConditionCard(
                              context,
                              conditionType,
                              controller,
                              themeController,
                            ),
                          ).toList(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: themeController.primaryTextColor.value),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: themeController.primaryTextColor.value,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeController.primaryTextColor.value.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherConditionCard(
    BuildContext context,
    WeatherConditionType conditionType,
    AddOrUpdateAlarmController controller,
    ThemeController themeController,
  ) {
    final isSelected = controller.weatherConditionType.value == conditionType;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Utils.hapticFeedback();
          controller.weatherConditionType.value = conditionType;
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected 
                ? kprimaryColor.withOpacity(0.1)
                : themeController.secondaryBackgroundColor.value,
            border: Border.all(
              color: isSelected 
                  ? kprimaryColor
                  : themeController.primaryTextColor.value.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                _getWeatherConditionIcon(conditionType),
                color: isSelected 
                    ? kprimaryColor
                    : themeController.primaryTextColor.value,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWeatherConditionTitle(conditionType),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? kprimaryColor
                            : themeController.primaryTextColor.value,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getWeatherConditionDescription(conditionType),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeController.primaryTextColor.value.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: kprimaryColor,
                  size: 20,
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  Utils.hapticFeedback();
                  controller.weatherConditionType.value = conditionType;
                  await controller.checkAndRequestPermission();
                  Get.defaultDialog(
                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: themeController.secondaryBackgroundColor.value,
                    title: 'Select weather types for ${_getWeatherConditionTitle(conditionType)}'.tr,
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: kprimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.selectedWeather.isEmpty ? 'Select Weather' : '${controller.selectedWeather.length} selected',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getWeatherConditionIcon(WeatherConditionType type) {
    switch (type) {
      case WeatherConditionType.ringWhenMatch:
        return Icons.alarm;
      case WeatherConditionType.cancelWhenMatch:
        return Icons.alarm_off;
      case WeatherConditionType.ringWhenDifferent:
        return Icons.alarm_on;
      case WeatherConditionType.cancelWhenDifferent:
        return Icons.cancel;
      default:
        return Icons.cloud;
    }
  }

  String _getWeatherConditionTitle(WeatherConditionType type) {
    switch (type) {
      case WeatherConditionType.ringWhenMatch:
        return 'Ring When Match';
      case WeatherConditionType.cancelWhenMatch:
        return 'Cancel When Match';
      case WeatherConditionType.ringWhenDifferent:
        return 'Ring When Different';
      case WeatherConditionType.cancelWhenDifferent:
        return 'Cancel When Different';
      default:
        return 'Unknown';
    }
  }

  String _getWeatherConditionDescription(WeatherConditionType type) {
    switch (type) {
      case WeatherConditionType.ringWhenMatch:
        return 'Ring alarm when weather matches selected types (e.g., wake me when it\'s sunny)';
      case WeatherConditionType.cancelWhenMatch:
        return 'Cancel alarm when weather matches selected types (e.g., don\'t wake me when it\'s raining)';
      case WeatherConditionType.ringWhenDifferent:
        return 'Ring alarm when weather is different from selected types (e.g., wake me when it\'s not sunny)';
      case WeatherConditionType.cancelWhenDifferent:
        return 'Cancel alarm when weather is different from selected types (e.g., don\'t wake me unless it\'s raining)';
      default:
        return 'Unknown condition';
    }
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
    return Obx(
      () => CheckboxListTile(
        activeColor: kprimaryColor,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: Text(
          label.tr,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: themeController.primaryTextColor.value,
              ),
        ),
        value: controller.selectedWeather.contains(type),
        onChanged: (value) {
          Utils.hapticFeedback();
          if (value!) {
            controller.selectedWeather.add(type);
          } else {
            controller.selectedWeather.remove(type);
          }
        },
      ),
    );
  }
}
