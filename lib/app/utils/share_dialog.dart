import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/saved_emails.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/push_notifications.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    super.key,
    required this.homeController,
    required this.controller,
    required this.themeController,
  });
  final HomeController homeController;
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: ksecondaryBackgroundColor,
      child: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: kprimaryBackgroundColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  toShare(),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: controller.selectedEmails.isNotEmpty
                              ? WidgetStateProperty.all(
                                  ksecondaryColor,
                                )
                              : WidgetStateProperty.all(
                                  kprimaryDisabledTextColor,
                                ),
                        ),
                        onPressed: () async {
                          if (controller.selectedEmails.isNotEmpty) {
                            if (homeController.isProfile.value) {
                              await FirestoreDb.shareProfile(
                                controller.selectedEmails,
                              );
                            } else {
                              await FirestoreDb.shareAlarm(
                                controller.selectedEmails,
                                controller.alarmRecord.value,
                              );
                              
                            List<String> sharedUserIds = await FirestoreDb.getUserIdsByEmails(
                                controller.selectedEmails,
                              );

                              await PushNotifications().triggerSharedItemNotification(sharedUserIds);
                            }
                          } else {
                            Get.snackbar('Error', 'Select an User');
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share,
                              color: controller.selectedEmails.isNotEmpty
                                  ? kprimaryBackgroundColor
                                  : kprimaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Share',
                                style: TextStyle(
                                  color: controller.selectedEmails.isNotEmpty
                                      ? kprimaryBackgroundColor
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: ksecondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Select Users',
                      style: TextStyle(
                        fontSize: homeController.scalingFactor * 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    splashRadius: homeController.scalingFactor * 16,
                    color: kprimaryColor,
                    onPressed: () {
                      controller.isAddUser.value = !controller.isAddUser.value;
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.isAddUser.value
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: controller.emailTextEditingController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () async {
                              if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(
                                controller.emailTextEditingController.text,
                              )) {
                                IsarDb.addEmail(
                                  controller.emailTextEditingController.text,
                                );
                              } else {
                                Get.snackbar('Error', 'Invalid email');
                              }
                            },
                            icon: const Icon(
                              Icons.add_circle_outlined,
                              color: kprimaryColor,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.alternate_email),
                          prefixIconColor: kprimaryDisabledTextColor,
                          hintText: 'Enter e-mail',
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            StreamBuilder(
              stream: IsarDb.getEmails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userList = snapshot.data;
                  return SizedBox(

                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userList!.length,
                      itemBuilder: (context, index) {
                        return emailTile(userList[index]);
                      },
                    ),
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget emailTile(Saved_Emails email) {
    return ListTile(
      onTap: () {
        if (controller.selectedEmails.contains(email.email)) {
          controller.selectedEmails.remove(email.email);
        } else {
          controller.selectedEmails.add(email.email);
        }
      },
      tileColor: kprimaryBackgroundColor,
      title: Padding(
        padding:
            EdgeInsets.symmetric(vertical: homeController.scalingFactor * 16),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: controller.selectedEmails.contains(email.email)
                        ? kprimaryColor
                        : ksecondaryBackgroundColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(homeController.scalingFactor * 16),
                    child: controller.selectedEmails.contains(email.email)
                        ? const Icon(Icons.check)
                        : Text(
                            Utils.getInitials(email.username),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: homeController.scalingFactor * 15,
                              color: ksecondaryColor,
                            ),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width * 0.5,
                        child: Text(
                          email.username,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: homeController.scalingFactor * 20,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width * 0.5,
                        child: Text(
                          email.email,
                          style: TextStyle(
                            fontSize: homeController.scalingFactor * 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toShare() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ksecondaryBackgroundColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: EdgeInsets.all(homeController.scalingFactor * 25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: homeController.isProfile.value
                    ? Text(
                        homeController.selectedProfile.value
                            .substring(0, 2)
                            .toUpperCase(),
                        style: TextStyle(
                          color: ksecondaryColor,
                          fontSize: homeController.scalingFactor * 30,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Icon(
                        Icons.alarm,
                        size: homeController.scalingFactor * 45,
                      ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ homeController.isProfile.value
                ? const Text('Sharing Profile')
                : const Text('Sharing Alarm'),
             SizedBox(width: Get.width*0.35,child:
                 homeController.isProfile.value
                     ? Text(

                   homeController.selectedProfile.value,
                   style: TextStyle(
                     color: kprimaryColor,
                     fontSize: homeController.scalingFactor * 30,
                     fontWeight: FontWeight.w700,
                   ),                          overflow: TextOverflow.ellipsis,
                 )
                     : Text(
                   Utils.timeOfDayToString(
                     TimeOfDay.fromDateTime(
                       controller.selectedTime.value,

                     ),
                   ), overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                     color: kprimaryColor,
                     fontSize: homeController.scalingFactor * 30,
                     fontWeight: FontWeight.w700,
                   ),
                 ),)
            ],
          ),
        ),
      ],
    );
  }
}
