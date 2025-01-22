import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

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
          onTap: () {},
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    'Gaurdian Angel'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: themeController.primaryTextColor.value,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Obx(
                () => IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.info_sharp,
                    size: 21.r,
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.3),
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
                      isLightMode:
                          themeController.currentTheme.value == ThemeMode.light,
                    );
                  },
                ),
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
                    onChanged: (value) async {
                      Utils.hapticFeedback();
                      var phonePerm =
                          await Permission.phone.request().isGranted;
                      var smsPerm = await Permission.sms.request().isGranted;

                      if (phonePerm && smsPerm) {
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
                                      textFieldController: controller
                                          .contactTextEditingController,
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
                      }
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
