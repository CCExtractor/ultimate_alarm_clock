import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/saved_emails.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
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
                            ? MaterialStateProperty.all(
                                ksecondaryColor,
                              )
                            : MaterialStateProperty.all(
                                kprimaryDisabledTextColor,
                              ),
                      ),
                      onPressed: () async {
                        if (controller.selectedEmails.isNotEmpty) {
                          for (final email in controller.selectedEmails) {
                            await FirestoreDb.shareProfile(email);
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: userList!.map((e) => emailTile(e)).toList(),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
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
        child: Row(
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email.username,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: homeController.scalingFactor * 22,
                    ),
                  ),
                  Text(
                    email.email,
                    style: TextStyle(
                      fontSize: homeController.scalingFactor * 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget toShare() {
    if (homeController.isProfile.value) {
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
              child: Stack(
                children: [
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Icon(
                      Icons.settings,
                      size: homeController.scalingFactor * 45,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(homeController.scalingFactor * 25),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        homeController.selectedProfile.value
                            .substring(0, 2)
                            .toUpperCase(),
                        style: TextStyle(
                          color: ksecondaryColor,
                          fontSize: homeController.scalingFactor * 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sharing Profile'),
                Text(
                  homeController.selectedProfile.value,
                  style: TextStyle(
                    color: kprimaryColor,
                    fontSize: homeController.scalingFactor * 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const Row(
        children: [],
      );
    }
  }
}
