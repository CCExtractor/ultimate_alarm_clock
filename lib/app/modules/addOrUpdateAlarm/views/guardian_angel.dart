import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class GaurdianAngel extends StatelessWidget {
  const GaurdianAngel({
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

    return Column(
      children: [
        ListTile(
          onTap: () {
          },
          title: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gaurdian Angel'.tr,
                  style: TextStyle(
                    color: themeController.isLightMode.value
                        ? kLightPrimaryTextColor
                        : kprimaryTextColor,
                  ),
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
                  Utils.showModal(
                    context: context,
                    title: 'Guardian Angel',
                    description:
                        'This feature will automatically call or text a person'
                        ' you trust the most if you dont wake up to an alarm!'
                        '\n \n CALLING AND SMS PERMISSION REQUIRED.'
                        '\n \n RATES MAY APPLY AS PER YOUR SERVICE PROVIDER',
                    iconData: Icons.info_sharp,
                    isLightMode: themeController.isLightMode.value,
                  );
                },
              ),
            ],
          ),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () {
                  return Switch.adaptive(
                    value: controller.isGuardian.value,
                    activeColor: ksecondaryColor,
                    onChanged: (value) {
                      Utils.hapticFeedback();
                      Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          backgroundColor: kprimaryBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InternationalPhoneNumberInput(
                                    textFieldController:
                                        controller.contactTextEditingController,
                                    onInputChanged: (value) {},
                                    onInputValidated: (value) {},
                                    spaceBetweenSelectorAndTextField: 0,
                                    selectorConfig: const SelectorConfig(
                                      showFlags: false,
                                      setSelectorButtonAsPrefixIcon: true,
                                      leadingPadding: 0,
                                      trailingSpace: false,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: controller
                                            .homeController.scalingFactor *
                                        8,
                                    horizontal: controller
                                            .homeController.scalingFactor *
                                        4,
                                  ),
                                  child: Row(
                                    children: [
                                      Option(0, Icons.sms, 'Text'),
                                      Option(1, Icons.call, 'Call'),
                                      const Spacer(),
                                      Submit(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget Option(int val, IconData icon, String name) {
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () {
                val == 0
                    ? controller.isCall.value = false
                    : controller.isCall.value = true;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (val == 0 && !controller.isCall.value) ||
                          (val == 1 && controller.isCall.value)
                      ? kprimaryColor
                      : ksecondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: (val == 0 && !controller.isCall.value) ||
                            (val == 1 && controller.isCall.value)
                        ? ksecondaryBackgroundColor
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: controller.homeController.scalingFactor.value * 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget Submit() {
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () {
                controller.isGuardian.value = true;
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ksecondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check,
                    color: kprimaryColor,
                  ),
                ),
              ),
            ),
          ),
          Text(
            'Confirm',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: controller.homeController.scalingFactor.value * 12,
            ),
          ),
        ],
      ),
    );
  }
}
