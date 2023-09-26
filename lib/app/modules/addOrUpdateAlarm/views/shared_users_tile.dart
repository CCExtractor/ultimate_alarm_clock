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
                  controller.alarmRecord != null)
              ? (controller.alarmRecord!.ownerId != controller.userModel!.id)
                  ? ListTile(
                      title: Text(
                        'Alarm Owner',
                        style: TextStyle(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor),
                      ),
                      trailing: Text(
                        controller.alarmRecord!.ownerName,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryDisabledTextColor
                                : kprimaryDisabledTextColor),
                      ))
                  : ListTile(
                      title: Text(
                        'Shared Users',
                        style: TextStyle(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : kprimaryTextColor),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Utils.hapticFeedback();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: themeController.isLightMode.value
                                ? kLightPrimaryBackgroundColor
                                : kprimaryBackgroundColor,
                            builder: (BuildContext context) {
                              final userDetails = RxList<UserModel?>([]);

                              return Obx(() {
                                if (controller.sharedUserIds.isEmpty) {
                                  return const Center(
                                      child: Text("No shared users!"));
                                }

                                return FutureBuilder<List<UserModel?>>(
                                  future: controller
                                      .fetchUserDetailsForSharedUsers(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<UserModel?>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: kprimaryColor,
                                        ),
                                      );
                                    }

                                    userDetails.value = snapshot.data ?? [];

                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Shared Users',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                          for (UserModel? user in userDetails)
                                            Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    user!.fullName,
                                                    style: TextStyle(
                                                        color: themeController
                                                                .isLightMode
                                                                .value
                                                            ? kLightPrimaryTextColor
                                                            : kprimaryTextColor),
                                                  ),
                                                  trailing: TextButton(
                                                    style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .zero),
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(const Size(
                                                                  80, 30)),
                                                      maximumSize:
                                                          MaterialStateProperty
                                                              .all(const Size(
                                                                  80, 30)),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    ),
                                                    child: Text(
                                                      'Remove',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: themeController
                                                                    .isLightMode
                                                                    .value
                                                                ? kLightPrimaryTextColor
                                                                    .withOpacity(
                                                                        0.9)
                                                                : kprimaryTextColor
                                                                    .withOpacity(
                                                                        0.9),
                                                          ),
                                                    ),
                                                    onPressed: () async {
                                                      Utils.hapticFeedback();
                                                      await FirestoreDb
                                                          .removeUserFromAlarmSharedUsers(
                                                              user,
                                                              controller
                                                                  .alarmID);
                                                      // Update sharedUserIds value after removing the user
                                                      controller.sharedUserIds
                                                          .remove(user.id);

                                                      // Remove the user from userDetails list
                                                      userDetails.remove(user);

                                                      // Update the list
                                                      userDetails.refresh();
                                                    },
                                                  ),
                                                ),
                                                Divider(
                                                  color: themeController
                                                          .isLightMode.value
                                                      ? kLightPrimaryDisabledTextColor
                                                      : kprimaryDisabledTextColor,
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              });
                            },
                          );
                        },
                        child: Icon(Icons.chevron_right,
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor.withOpacity(0.7)
                                : kprimaryTextColor.withOpacity(0.7)),
                      ),
                    )
              : const SizedBox()),
    );
  }
}
