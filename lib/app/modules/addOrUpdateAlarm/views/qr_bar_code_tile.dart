import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class QrBarCode extends StatelessWidget {
  const QrBarCode({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Obx(
              () => Text(
                'QR/Bar Code'.tr,
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Obx(
              () => Icon(
                Icons.info_sharp,
                size: 21,
                color: themeController.primaryTextColor.value.withOpacity(0.3),
              ),
            ),
            onPressed: () {
              Utils.showModal(
                context: context,
                title: 'QR/Bar Code'.tr,
                // description:
                //     'Scan the QR/Bar code on any object, like a book, and relocate it to a different room. To deactivate the alarm, simply rescan the same QR/Bar code.',
                description: 'qrDescription'.tr,
                iconData: Icons.qr_code_scanner,
                isLightMode: themeController.currentTheme.value == ThemeMode.light,
              );
            },
          ),
        ],
      ),
      onTap: () async {
        Utils.hapticFeedback();
        await controller.requestQrPermission(context);
      },
      trailing: InkWell(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.isQrEnabled.value == true ? 'Enabled'.tr : 'Off'.tr,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isQrEnabled.value == false)
                          ? themeController.primaryDisabledTextColor.value
                          : themeController.primaryTextColor.value,
                    ),
              ),
            ),
            Obx(
              () => Icon(
                Icons.chevron_right,
                color: themeController.primaryDisabledTextColor.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
