import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        tileColor: themeController.secondaryBackgroundColor.value,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Note'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
        ),
        onTap: () {
          Utils.hapticFeedback();
          Get.defaultDialog(
            title: 'Add a note'.tr,
            titlePadding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            titleStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: themeController.primaryTextColor.value,
                ),
            contentPadding: const EdgeInsets.all(21),
            content: TextField(
              autofocus: true,
              controller: controller.noteController,
              style: Theme.of(context).textTheme.bodyLarge,
              cursorColor: themeController.primaryTextColor.value.withOpacity(0.75),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: themeController.primaryTextColor.value.withOpacity(0.75),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: themeController.primaryTextColor.value.withOpacity(0.75),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: themeController.primaryTextColor.value.withOpacity(0.75),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Enter a note'.tr,
                hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: themeController.primaryDisabledTextColor.value,
                    ),
              ),
              onChanged: (text) {
                if (text.trim().isEmpty) {
                  controller.noteController.text = '';
                  if (text.isNotEmpty) {
                    Get.snackbar(
                      'Note'.tr,
                      // "Please don't enter whitespace as first character!",
                      'noWhitespace'.tr,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              },
            ),
            buttonColor: themeController.secondaryBackgroundColor.value,
            confirm: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kprimaryColor),
              ),
              child: Text(
                'Save'.tr,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: themeController.currentTheme.value == ThemeMode.light
                          ? kLightPrimaryTextColor
                          : ksecondaryTextColor,
                    ),
              ),
              onPressed: () {
                Utils.hapticFeedback();
                controller.note.value = controller.noteController.text;
                Get.back();
              },
            ),
          );
        },
        trailing: InkWell(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () => Container(
                  width: 100,
                  alignment: Alignment.centerRight,
                  child: Text(
                    (controller.note.value.trim().isNotEmpty)
                        ? controller.note.value
                        : 'Off'.tr,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: (controller.note.value.trim().isEmpty)
                              ? themeController.primaryDisabledTextColor.value
                              : themeController.primaryTextColor.value,
                        ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: (controller.note.value.trim().isEmpty)
                    ? themeController.primaryDisabledTextColor.value
                    : themeController.primaryTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
