import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class DeleteAfterGoesOff extends StatelessWidget {
  const DeleteAfterGoesOff({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    // Check if using Firestore and the current user is the owner
    // and if not using, just show the tile
    bool isVisible = (controller.isSharedAlarmEnabled.value == true &&
            controller.userModel.value?.id == controller.ownerId) ||
        (controller.isSharedAlarmEnabled.value == false);

    return Column(
      children: [
        Visibility(
          visible: isVisible,
          child: Obx(
            () => ListTile(

              title: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  'Delete After Goes Off'.tr,
                  style: TextStyle(
                    color: themeController.primaryTextColor.value,
                  ),
                ),
              ),
              onTap: () {
                Utils.hapticFeedback();
                controller.deleteAfterGoesOff.value =
                    !controller.deleteAfterGoesOff.value;
              },
              trailing: InkWell(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Obx(
                      () {
                        return Switch.adaptive(
                          value: controller.deleteAfterGoesOff.value,
                          activeColor: ksecondaryColor,
                          onChanged: (value) {
                            Utils.hapticFeedback();
                            controller.deleteAfterGoesOff.value = value;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Obx(
          () => Container(
            child: Divider(
              color: themeController.primaryDisabledTextColor.value,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
