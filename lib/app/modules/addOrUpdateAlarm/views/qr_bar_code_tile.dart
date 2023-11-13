import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
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
    var height = Get.height;
    var width = Get.width;
    return ListTile(
      title: Row(
        children: [
          Text(
            'QR/Bar Code',
            style: TextStyle(
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor
                  : kprimaryTextColor,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.info_sharp,
              size: 21,
              color: themeController.isLightMode.value
                  ? kLightPrimaryTextColor.withOpacity(0.45)
                  : kprimaryTextColor.withOpacity(0.3),
            ),
            onPressed: () {
              Utils.hapticFeedback();
              showModalBottomSheet(
                context: context,
                backgroundColor: themeController.isLightMode.value
                    ? kLightSecondaryBackgroundColor
                    : ksecondaryBackgroundColor,
                builder: (context) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor,
                            size: height * 0.1,
                          ),
                          Text(
                            'QR / Bar code',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              'Scan the QR/Bar code on any object, like a book, and relocate it to a different room. To deactivate the alarm, simply rescan the same QR/Bar code.',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kprimaryColor),
                              ),
                              onPressed: () {
                                Utils.hapticFeedback();
                                Get.back();
                              },
                              child: Text(
                                'Understood',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryTextColor
                                          : ksecondaryTextColor,
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
      onTap: () async {
        Utils.hapticFeedback();
        await controller.requestQrPermission();
      },
      trailing: InkWell(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.isQrEnabled.value == true ? 'Enabled' : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isQrEnabled.value == false)
                          ? themeController.isLightMode.value
                              ? kLightPrimaryDisabledTextColor
                              : kprimaryDisabledTextColor
                          : themeController.isLightMode.value
                              ? kLightPrimaryTextColor
                              : kprimaryTextColor,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: themeController.isLightMode.value
                  ? kLightPrimaryDisabledTextColor
                  : kprimaryDisabledTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
