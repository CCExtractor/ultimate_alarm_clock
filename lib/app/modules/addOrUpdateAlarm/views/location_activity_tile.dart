import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
  });

  final AddOrUpdateAlarmController controller;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) async {
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
          color: ksecondaryBackgroundColor,
          context: context,
          position: position,
          items: [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Off",
                    style: TextStyle(
                      color: (controller.isLocationEnabled.value == true)
                          ? kprimaryDisabledTextColor
                          : kprimaryTextColor,
                    ),
                  ),
                  Radio(
                    fillColor: MaterialStateProperty.all(
                      (controller.isLocationEnabled.value == true)
                          ? kprimaryDisabledTextColor
                          : kprimaryColor,
                    ),
                    value: !controller.isLocationEnabled.value,
                    groupValue: true,
                    onChanged: (value) {},
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
                    "Choose location",
                    style: TextStyle(
                      color: (controller.isLocationEnabled.value == false)
                          ? kprimaryDisabledTextColor
                          : kprimaryTextColor,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: (controller.isLocationEnabled.value == false)
                        ? kprimaryDisabledTextColor
                        : kprimaryTextColor,
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
            if (controller.isLocationEnabled.value == false) {
              await controller.getLocation();
            }


            Get.defaultDialog(
              backgroundColor: ksecondaryBackgroundColor,
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
                        screenSize: Size(width * 0.3, height * 0.8),
                        center: controller.selectedPoint.value,
                        zoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        MarkerLayer(markers: controller.markersList),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kprimaryColor)),
                    child: Text(
                      'Save',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: ksecondaryTextColor),
                    ),
                    onPressed: () {
                      Get.back();
controller.isLocationEnabled.value = true;
                      },
                  ),
                ],
              ),
            );
          }
        });
      },
      child: ListTile(
        title: Row(
          children: [
            const Text(
              'Location Based',
              style: TextStyle(color: kprimaryTextColor),
            ),
            IconButton(
              icon: Icon(
                Icons.info_sharp,
                size: 21,
                color: kprimaryTextColor.withOpacity(0.3),
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: ksecondaryBackgroundColor,
                    builder: (context) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: kprimaryTextColor,
                                size: height * 0.1,
                              ),
                              Text("Location based cancellation",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  "This feature will automatically cancel the alarm if you are within 500m of the chosen location!",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: width,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        kprimaryColor),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'Understood',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(color: ksecondaryTextColor),
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
        trailing: Obx(
          () => Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                controller.isLocationEnabled.value == false ? 'Off' : 'Enabled',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isLocationEnabled.value == false)
                          ? kprimaryDisabledTextColor
                          : kprimaryTextColor,
                    ),
              ),
              Icon(
                Icons.chevron_right,
                color: (controller.isLocationEnabled.value == false)
                    ? kprimaryDisabledTextColor
                    : kprimaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
