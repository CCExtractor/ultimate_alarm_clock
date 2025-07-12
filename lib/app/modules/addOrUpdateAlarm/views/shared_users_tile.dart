// ignore_for_file: lines_longer_than_80_chars, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SharedUsers extends StatelessWidget {
  const SharedUsers({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: (controller.isSharedAlarmEnabled.value &&
                controller.alarmRecord.value != null)
            ? (controller.alarmRecord.value.ownerId !=
                    controller.userModel.value!.id)
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: themeController.secondaryBackgroundColor.value.withOpacity(0.3),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: kprimaryColor.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          color: kprimaryColor,
                        ),
                      ),
                      title: Text(
                        'Alarm Owner'.tr,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        controller.alarmRecord.value.ownerName,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: themeController.secondaryBackgroundColor.value.withOpacity(0.3),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kprimaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.people_alt_rounded,
                          color: kprimaryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Shared Users'.tr,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Obx(() => Text(
                        controller.sharedUserIds.isEmpty
                            ? 'No users yet'.tr
                            : '${controller.sharedUserIds.length} ${controller.sharedUserIds.length == 1 ? 'user'.tr : 'users'.tr}',
                        style: TextStyle(
                          color: themeController.primaryTextColor.value.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      )),
                      trailing: InkWell(
                        onTap: () {
                          Utils.hapticFeedback();
                          _showSharedUsersBottomSheet(context);
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: themeController.primaryTextColor.value.withOpacity(0.7),
                          size: 16,
                        ),
                      ),
                    ),
                  )
            : const SizedBox(),
      ),
    );
  }

  void _showSharedUsersBottomSheet(BuildContext context) {
    final userDetails = RxList<UserModel?>([]);

    showModalBottomSheet(
      context: context,
      backgroundColor: themeController.primaryBackgroundColor.value,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Obx(() {
          if (controller.sharedUserIds.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 48,
                      color: themeController.primaryDisabledTextColor.value,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No shared users!'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeController.primaryTextColor.value,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share this alarm with others to see them here'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeController.primaryTextColor.value.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Utils.hapticFeedback();
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: Text('Go back'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                        foregroundColor: themeController.secondaryTextColor.value,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return FutureBuilder<List<UserModel?>>(
            future: controller.fetchUserDetailsForSharedUsers(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<UserModel?>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: kprimaryColor,
                    valueColor: AlwaysStoppedAnimation(
                      kprimaryColor,
                    ),
                  ),
                );
              }

              userDetails.value = snapshot.data ?? [];

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: themeController.secondaryBackgroundColor.value,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.people_alt_rounded,
                          color: kprimaryColor,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Shared Users'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: themeController.primaryTextColor.value,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${userDetails.length} ${userDetails.length == 1 ? 'user'.tr : 'users'.tr}',
                          style: TextStyle(
                            color: themeController.primaryTextColor.value.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: userDetails.length,
                      itemBuilder: (context, index) {
                        final user = userDetails[index]!;
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: kprimaryColor.withOpacity(0.2),
                                child: Text(
                                  Utils.getInitials(user.fullName),
                                  style: TextStyle(
                                    color: kprimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.fullName,
                                style: TextStyle(
                                  color: themeController.primaryTextColor.value,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                user.email,
                                style: TextStyle(
                                  color: themeController.primaryTextColor.value.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                              trailing: TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.person_remove,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                label: Text(
                                  'Remove'.tr,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () async {
                                  Utils.hapticFeedback();
                                  
                                  // Show confirmation dialog
                                  final confirmed = await Get.dialog<bool>(
                                    AlertDialog(
                                      backgroundColor: themeController.secondaryBackgroundColor.value,
                                      title: Text('Remove user?'.tr),
                                      content: Text(
                                        'Are you sure you want to remove ${user.fullName} from this alarm?'.tr,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(result: false),
                                          child: Text(
                                            'Cancel'.tr,
                                            style: TextStyle(
                                              color: themeController.primaryTextColor.value,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => Get.back(result: true),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.red.withOpacity(0.1),
                                          ),
                                          child: Text(
                                            'Remove'.tr,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ?? false;
                                  
                                  if (confirmed) {
                                    await FirestoreDb.removeUserFromAlarmSharedUsers(
                                      user,
                                      controller.alarmID,
                                    );
                                    
                                    
                                    controller.sharedUserIds.remove(user.id);

                                    
                                    userDetails.remove(user);

                                    
                                    userDetails.refresh();
                                    
                                    
                                    Get.snackbar(
                                      'Success'.tr,
                                      'User removed successfully'.tr,
                                      backgroundColor: kprimaryColor,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: const EdgeInsets.all(16),
                                    );
                                  }
                                },
                              ),
                            ),
                            Divider(
                              color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                              height: 1,
                              indent: 70,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }
}