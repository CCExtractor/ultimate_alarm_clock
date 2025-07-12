import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final double height;
  final double width;

  String _getLocationConditionText(LocationConditionType type) {
    switch (type) {
      case LocationConditionType.off:
        return 'Off';
      case LocationConditionType.ringWhenAt:
        return 'Ring when AT location';
      case LocationConditionType.cancelWhenAt:
        return 'Cancel when AT location';
      case LocationConditionType.ringWhenAway:
        return 'Ring when AWAY from location';
      case LocationConditionType.cancelWhenAway:
        return 'Cancel when AWAY from location';
    }
  }

  String _getLocationConditionDescription(LocationConditionType type) {
    switch (type) {
      case LocationConditionType.off:
        return 'Location-based alarm control is disabled.';
      case LocationConditionType.ringWhenAt:
        return 'Perfect for travel alarms - rings when you reach your destination';
      case LocationConditionType.cancelWhenAt:
        return 'Avoid redundant alarms - cancels if you\'re already where you need to be';
      case LocationConditionType.ringWhenAway:
        return 'Departure reminders - rings when you\'re away from important places';
      case LocationConditionType.cancelWhenAway:
        return 'Location-specific activities - cancels if you\'re too far away';
    }
  }

  IconData _getLocationConditionIcon(LocationConditionType type) {
    switch (type) {
      case LocationConditionType.off:
        return Icons.location_off;
      case LocationConditionType.ringWhenAt:
        return Icons.location_on;
      case LocationConditionType.cancelWhenAt:
        return Icons.location_disabled;
      case LocationConditionType.ringWhenAway:
        return Icons.location_searching;
      case LocationConditionType.cancelWhenAway:
        return Icons.wrong_location;
    }
  }

  void _showLocationPicker(BuildContext context, LocationConditionType selectedType) {
    Get.bottomSheet(
      Container(
        height: height * 0.9,
        decoration: BoxDecoration(
          color: themeController.secondaryBackgroundColor.value,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: themeController.primaryDisabledTextColor.value,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Choose Location',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: themeController.primaryTextColor.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kprimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getLocationConditionDescription(selectedType),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeController.primaryTextColor.value,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      onTap: (tapPosition, point) {
                        controller.selectedPoint.value = point;
                      },
                      center: controller.selectedPoint.value,
                      zoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      Obx(() => MarkerLayer(
                        markers: List<Marker>.from(controller.markersList),
                      )),
                    ],
                  ),
                ),
              ),
            ),
            
            
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Utils.hapticFeedback();
                        Get.back();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Utils.hapticFeedback();
                        Get.back();
                      },
                      child: Text(
                        'Save Location',
                        style: TextStyle(
                          color: themeController.secondaryTextColor.value,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );

    
    if (controller.selectedPoint.value.latitude == 0 && 
        controller.selectedPoint.value.longitude == 0) {
      controller.getLocation().then((_) {
        controller.mapController.move(controller.selectedPoint.value, 15);
      });
    }
  }

  Widget _buildConditionOption(LocationConditionType type, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected 
          ? kprimaryColor.withOpacity(0.1)
          : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
            ? kprimaryColor
            : themeController.primaryDisabledTextColor.value.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Utils.hapticFeedback();
          controller.locationConditionType.value = type;
          
    
          if (type != LocationConditionType.off) {
            _showLocationPicker(Get.context!, type);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? kprimaryColor
                    : themeController.primaryDisabledTextColor.value.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getLocationConditionIcon(type),
                  color: isSelected 
                    ? Colors.white
                    : themeController.primaryTextColor.value,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLocationConditionText(type),
                      style: TextStyle(
                        color: themeController.primaryTextColor.value,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getLocationConditionDescription(type),
                      style: TextStyle(
                        color: themeController.primaryTextColor.value.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: kprimaryColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
    
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Row(
                children: [
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Location Conditions'.tr,
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
                      Utils.showModal(
                        context: context,
                        title: 'Enhanced Location Controls',
                        description: 'Choose how location affects your alarm:\n\n'
                            '• Ring when AT: Alarm rings when you reach the location\n'
                            '• Cancel when AT: Alarm cancels if you\'re already there\n'
                            '• Ring when AWAY: Alarm rings when you\'re far from location\n'
                            '• Cancel when AWAY: Alarm cancels if you\'re too far\n\n'
                            'All conditions use a 500m radius.',
                        iconData: Icons.location_on,
                        isLightMode: themeController.currentTheme.value == ThemeMode.light,
                      );
                    },
                  ),
                ],
              ),
              trailing: Switch(
                value: controller.locationConditionType.value != LocationConditionType.off,
                onChanged: (bool value) {
                  Utils.hapticFeedback();
                  if (!value) {
                    controller.locationConditionType.value = LocationConditionType.off;
                  } else {
                    controller.locationConditionType.value = LocationConditionType.cancelWhenAt;
                  }
                },
                activeColor: kprimaryColor,
              ),
            ),
            
    
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: controller.locationConditionType.value != LocationConditionType.off 
                ? null 
                : 0,
              child: controller.locationConditionType.value != LocationConditionType.off
                ? Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: themeController.secondaryBackgroundColor.value.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: kprimaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Location Condition',
                          style: TextStyle(
                            color: themeController.primaryTextColor.value,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...LocationConditionType.values.where((type) => type != LocationConditionType.off).map(
                          (type) => _buildConditionOption(
                            type, 
                            controller.locationConditionType.value == type,
                          ),
                        ).toList(),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}