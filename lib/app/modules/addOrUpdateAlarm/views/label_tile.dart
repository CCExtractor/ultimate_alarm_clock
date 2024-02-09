import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class LabelTile extends StatelessWidget {
  const LabelTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: themeController.isLightMode.value
          ? kLightSecondaryBackgroundColor
          : ksecondaryBackgroundColor,
      title: Flexible(
        child: Text(
          'Label'.tr,
          style: TextStyle(
            color: themeController.isLightMode.value
                ? kLightPrimaryTextColor
                : kprimaryTextColor,
          ),
        ),
      ),
      onTap: () {
        Utils.hapticFeedback();
        Get.defaultDialog(
          title: 'Add a label'.tr,
          titlePadding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          titleStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor
                    : kprimaryTextColor,
              ),
          contentPadding: const EdgeInsets.all(21),
          content: TextField(
            autofocus: true,
            controller: controller.labelController,
            style: Theme.of(context).textTheme.bodyLarge,
            cursorColor: themeController.isLightMode.value
                ? kLightPrimaryTextColor.withOpacity(0.75)
                : kprimaryTextColor.withOpacity(0.75),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.75)
                      : kprimaryTextColor.withOpacity(0.75),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.75)
                      : kprimaryTextColor.withOpacity(0.75),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.75)
                      : kprimaryTextColor.withOpacity(0.75),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              hintText: 'Enter a label'.tr,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: themeController.isLightMode.value
                        ? kLightPrimaryDisabledTextColor
                        : kprimaryDisabledTextColor,
                  ),
            ),
            onChanged: (text) {
              if (text.trim().isEmpty) {
                controller.labelController.text = '';
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
          buttonColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          confirm: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kprimaryColor),
            ),
            child: Text(
              'Save'.tr,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor
                        : ksecondaryTextColor,
                  ),
            ),
            onPressed: () {
              Utils.hapticFeedback();
              controller.label.value = controller.labelController.text;
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
                  (controller.label.value.trim().isNotEmpty)
                      ? controller.label.value
                      : 'Off'.tr,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: (controller.label.value.trim().isEmpty)
                            ? themeController.isLightMode.value
                                ? kLightPrimaryDisabledTextColor
                                : kprimaryDisabledTextColor
                            : themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor,
                      ),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: (controller.label.value.trim().isEmpty)
                  ? themeController.isLightMode.value
                      ? kLightPrimaryDisabledTextColor
                      : kprimaryDisabledTextColor
                  : themeController.isLightMode.value
                      ? kLightPrimaryTextColor
                      : kprimaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
