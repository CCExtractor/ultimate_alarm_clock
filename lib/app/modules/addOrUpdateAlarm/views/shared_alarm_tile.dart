import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class SharedAlarm extends StatelessWidget {
  const SharedAlarm({
    super.key,
    required this.controller, required this.hapticFeedbackController,
  });

  final AddOrUpdateAlarmController controller;

  final HapticFeedbackController hapticFeedbackController;

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;

    return Container(
      child: (controller.userModel != null)
          ? ListTile(
              title: Row(
                children: [
                  const Text(
                    'Shared Alarm',
                    style: TextStyle(color: kprimaryTextColor),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_sharp,
                      size: 21,
                      color: kprimaryTextColor.withOpacity(0.3),
                    ),
                    onPressed: () {
                      hapticFeedbackController.hapticFeedback();
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: ksecondaryBackgroundColor,
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
                                      color: kprimaryTextColor,
                                      size: height * 0.1,
                                    ),
                                    Text("Shared alarms",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Text(
                                        "Share alarms with others using the Alarm ID. Each shared user can choose to have their alarm ring before or after the set time.",
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
                                                  kprimaryColor),
                                        ),
                                        onPressed: () {
                                          hapticFeedbackController.hapticFeedback();
                                          Get.back();
                                        },
                                        child: Text(
                                          'Understood',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  color: ksecondaryTextColor),
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
              onTap: () {
                hapticFeedbackController.hapticFeedback();
                // Toggle the value of isSharedAlarmEnabled
                controller.isSharedAlarmEnabled.value =
                    !controller.isSharedAlarmEnabled.value;
              },
              trailing: Obx(
                () => Switch(
                  onChanged: (value) {
                    hapticFeedbackController.hapticFeedback();
                    // You can optionally add the onChanged callback here as well
                    controller.isSharedAlarmEnabled.value = value;
                  },
                  value: controller.isSharedAlarmEnabled.value,
                ),
              ),
            )
          : ListTile(
              onTap: () {
                hapticFeedbackController.hapticFeedback();
                Get.defaultDialog(
                    contentPadding: const EdgeInsets.all(10.0),
                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: ksecondaryBackgroundColor,
                    title: 'Disabled!',
                    titleStyle: Theme.of(context).textTheme.displaySmall,
                    content: Column(
                      children: [
                        const Text(
                            "To use this feature, you have link your Google account!"),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        kprimaryColor)),
                                child: Text(
                                  'Go to settings',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: ksecondaryTextColor),
                                ),
                                onPressed: () {
                                  hapticFeedbackController.hapticFeedback();
                                  Get.back();
                                  Get.toNamed('/settings');
                                },
                              ),
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        kprimaryTextColor.withOpacity(0.5))),
                                child: Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: kprimaryTextColor),
                                ),
                                onPressed: () {
                                  hapticFeedbackController.hapticFeedback();
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ));
              },
              title: const Text(
                'Enable Shared Alarm',
                style: TextStyle(color: kprimaryTextColor),
              ),
              trailing: InkWell(
                child: Icon(
                  Icons.lock,
                  color: kprimaryTextColor.withOpacity(0.7),
                ),
              )),
    );
  }
}
