import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SharedAlarm extends StatelessWidget {
  const SharedAlarm({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;

    return Obx(() => Container(
          child: (controller.userModel.value != null)
              ? ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Shared Alarm'.tr,
                          style: TextStyle(
                            color: themeController.primaryTextColor.value,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.info_sharp,
                          size: 21,
                          color: themeController.currentTheme.value == ThemeMode.light
                              ? kLightPrimaryTextColor.withOpacity(0.45)
                              : kprimaryTextColor.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: themeController.secondaryBackgroundColor.value,
                            builder: (context) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.share_arrival_time,
                                        color: themeController.primaryTextColor.value,
                                        size: height * 0.1,
                                      ),
                                      Text(
                                        'Shared alarms'.tr,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          // 'Share alarms with others using the'
                                          // ' Alarm ID. Each shared user can choose'
                                          // ' to have their alarm ring before or'
                                          // ' after the set time.',
                                          'sharedDescription'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              kprimaryColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            Utils.hapticFeedback();
                                            Get.back();
                                          },
                                          child: Text(
                                            'Understood'.tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                  color: themeController
                                                          .currentTheme.value == ThemeMode.light
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
                  onTap: () {
                    Utils.hapticFeedback();
                    // Toggle the value of isSharedAlarmEnabled
                    controller.isSharedAlarmEnabled.value =
                        !controller.isSharedAlarmEnabled.value;
                  },
                  trailing: Obx(
                    () => Switch.adaptive(
                      onChanged: (value) {
                        Utils.hapticFeedback();
                        // You can optionally add the onChanged callback here
                        // as well
                        controller.isSharedAlarmEnabled.value = value;
                      },
                      value: controller.isSharedAlarmEnabled.value,
                      activeColor: ksecondaryColor,
                    ),
                  ),
                )
              : ListTile(
                  onTap: () {
                    Utils.hapticFeedback();
                    Get.defaultDialog(
                      contentPadding: const EdgeInsets.all(10.0),
                      titlePadding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: themeController.secondaryBackgroundColor.value,
                      title: 'Disabled!'.tr,
                      titleStyle: Theme.of(context).textTheme.displaySmall,
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              'To use this feature, you have to link your Google account!'
                                  .tr,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        kprimaryColor,
                                      ),
                                    ),
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Go to settings'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                              color: themeController
                                                      .currentTheme.value == ThemeMode.light
                                                  ? kLightPrimaryTextColor
                                                  : ksecondaryTextColor,
                                            ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Utils.hapticFeedback();
                                      Get.back();
                                      Get.toNamed('/settings');
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Expanded(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                            themeController.primaryTextColor.value
                                                .withOpacity(0.5),
                                      ),
                                    ),
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Cancel'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                              color: themeController.primaryTextColor.value,
                                            ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Utils.hapticFeedback();
                                      Get.back();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enable Shared Alarm'.tr,
                      style: TextStyle(
                        color: themeController.primaryTextColor.value,
                      ),
                    ),
                  ),
                  trailing: InkWell(
                    child: Icon(
                      Icons.lock,
                      color: themeController.primaryTextColor.value.withOpacity(0.7),
                    ),
                  ),
                ),
        ));
  }
}
