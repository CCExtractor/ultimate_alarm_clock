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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTapDown: (TapDownDetails details) async {
          Utils.hapticFeedback();
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;

          final RelativeRect position = RelativeRect.fromRect(
            Rect.fromPoints(
              details.globalPosition,
              details.globalPosition,
            ),
            Offset.zero & overlay.size,
          );

          await showMenu(
            color: themeController.secondaryBackgroundColor.value,
            context: context,
            position: position,
            items: [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Off',
                      style: TextStyle(
                        color: (controller.isLocationEnabled.value == true)
                            ? themeController.primaryDisabledTextColor.value
                            : themeController.primaryTextColor.value,
                      ),
                    ),
                    Radio(
                      fillColor: MaterialStateProperty.all(
                        (controller.isLocationEnabled.value == true)
                            ? themeController.primaryDisabledTextColor.value
                            : kprimaryColor,
                      ),
                      value: !controller.isLocationEnabled.value,
                      groupValue: true,
                      onChanged: (value) {
                        Utils.hapticFeedback();
                      },
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Choose location',
                      style: TextStyle(
                        color: (controller.isLocationEnabled.value == false)
                            ? themeController.primaryDisabledTextColor.value
                            : themeController.primaryTextColor.value,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: (controller.isLocationEnabled.value == false)
                          ? themeController.primaryDisabledTextColor.value
                          : themeController.primaryTextColor.value,
                    ),
                  ],
                ),
              ),
            ],
          ).then((value) async {
            // Handle menu item selection
            if (value == 0) {
              controller.isLocationEnabled.value = false;
            } else if (value == 1) {
              Get.defaultDialog(
                backgroundColor: themeController.secondaryBackgroundColor.value,
                title: 'Set location to automatically cancel alarm!',
                titleStyle: Theme.of(context).textTheme.bodyMedium,
                content: Column(
                  children: [
                    SizedBox(
                      height: height * 0.65,
                      width: width * 0.92,
                      child: FlutterMap(
                        mapController: controller.mapController,
                        options: MapOptions(
                          onTap: (tapPosition, point) {
                            controller.selectedPoint.value = point;
                          },
                          // screenSize: Size(width * 0.3, height * 0.8),
                          center: controller.selectedPoint.value,
                          zoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          Obx(() => MarkerLayer(
                              markers:
                                  List<Marker>.from(controller.markersList))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(kprimaryColor),
                      ),
                      child: Text(
                        'Save',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              color: themeController.secondaryTextColor.value,
                            ),
                      ),
                      onPressed: () {
                        Utils.hapticFeedback();
                        Get.back();
                        controller.isLocationEnabled.value = true;
                      },
                    ),
                  ],
                ),
              );

              if (controller.isLocationEnabled.value == false) {
                await controller.getLocation();
                controller.mapController.move(controller.selectedPoint.value, 15);
              }
            }
          });
        },
        child: ListTile(
          title: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Location Based'.tr,
                  style: TextStyle(
                    color: themeController.primaryTextColor.value,
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
                  Utils.showModal(
                    context: context,
                    title: 'Location based cancellation',
                    description: 'This feature will automatically cancel the'
                        ' alarm if you are within 500m of'
                        ' the chosen location!',
                    iconData: Icons.info_sharp,
                    isLightMode: themeController.currentTheme.value == ThemeMode.light,
                  );
                },
              ),
            ],
          ),
          trailing: Obx(
            () => Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  controller.isLocationEnabled.value == false ? 'Off' : 'Enabled',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: (controller.isLocationEnabled.value == false)
                            ? themeController.primaryDisabledTextColor.value
                            : themeController.primaryTextColor.value,
                      ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: (controller.isLocationEnabled.value == false)
                      ? themeController.primaryDisabledTextColor.value
                      : themeController.primaryTextColor.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
