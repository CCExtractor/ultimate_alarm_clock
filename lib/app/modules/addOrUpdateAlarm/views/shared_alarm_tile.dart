// ignore_for_file: lines_longer_than_80_chars

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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Obx(() {
      try {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: controller.isSharedAlarmEnabled.value 
                ? themeController.secondaryBackgroundColor.value.withOpacity(0.3)
                : Colors.transparent,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: (controller.userModel.value != null)
              ? ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Row(
                    children: [
                      Icon(
                        Icons.share_arrival_time,
                        color: controller.isSharedAlarmEnabled.value 
                            ? kprimaryColor 
                            : themeController.primaryTextColor.value,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Shared Alarm'.tr,
                          style: TextStyle(
                            color: themeController.primaryTextColor.value,
                            fontWeight: controller.isSharedAlarmEnabled.value 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: themeController.primaryTextColor.value.withOpacity(0.5),
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: themeController.secondaryBackgroundColor.value,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
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
                                        color: kprimaryColor,
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
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Utils.hapticFeedback();
                                            Get.back();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text(
                                              'Understood'.tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                    color: themeController
                                                            .secondaryTextColor.value,
                                                  ),
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
                    try {
                    Utils.hapticFeedback();
                      // Add validation before toggling
                      if (controller.userModel.value == null) {
                        debugPrint('Cannot toggle shared alarm: User not logged in');
                        return;
                      }
                      
                      bool newValue = !controller.isSharedAlarmEnabled.value;
                      debugPrint('Toggling shared alarm to: $newValue');
                      
                      
                      controller.isSharedAlarmEnabled.value = newValue;
                      
                      
                      if (newValue) {
                        await controller.initializeSharedAlarmSettings();
                      }
                    } catch (e) {
                      debugPrint('Error toggling shared alarm: $e');
                      
                      controller.isSharedAlarmEnabled.value = !controller.isSharedAlarmEnabled.value;
                    }
                  },
                  trailing: Obx(
                    () => Switch.adaptive(
                      onChanged: (value) async {
                        try {
                        Utils.hapticFeedback();
                          debugPrint('Switch toggled to: $value');
                          
                          // Add validation before changing
                          if (controller.userModel.value == null && value) {
                            debugPrint('Cannot enable shared alarm: User not logged in');
                            return;
                          }
                          
                        controller.isSharedAlarmEnabled.value = value;
                          
                          
                          if (value) {
                            await controller.initializeSharedAlarmSettings();
                          }
                        } catch (e) {
                          debugPrint('Error in switch toggle: $e');
                         
                        }
                      },
                      value: controller.isSharedAlarmEnabled.value,
                      activeColor: ksecondaryColor,
                      activeTrackColor: kprimaryColor.withOpacity(0.4),
                    ),
                  ),
                )
              : ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: themeController.primaryTextColor.value.withOpacity(0.7),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Enable Shared Alarm'.tr,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.login_rounded,
                    color: themeController.primaryTextColor.value.withOpacity(0.7),
                  ),
                  onTap: () {
                    Utils.hapticFeedback();
                    Get.defaultDialog(
                      contentPadding: const EdgeInsets.all(16.0),
                      titlePadding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: themeController.secondaryBackgroundColor.value,
                      title: 'Account Required'.tr,
                      titleStyle: Theme.of(context).textTheme.displaySmall,
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.login_rounded,
                            size: 48,
                            color: kprimaryColor,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0,),
                            child: Text(
                              'To use this feature, you have to link your Google account!'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: themeController.primaryTextColor.value,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                    ),
                                    child: Text(
                                      'Go to settings'.tr,
                                      style: TextStyle(
                                        color: themeController.secondaryTextColor.value,
                                        fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    onPressed: () {
                                      Utils.hapticFeedback();
                                      Get.back();
                                      Get.toNamed('/settings');
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
                ),
        );
      } catch (e) {
        debugPrint('Error in SharedAlarm widget build: $e');
        // Return a safe fallback widget
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: ListTile(
            title: Text(
              'Shared Alarm'.tr,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                        ),
                  ),
                  trailing: Icon(
              Icons.error_outline,
              color: Colors.red,
                  ),
                ),
        );
      }
    });
  }
}