import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SharedUsers extends StatelessWidget {
  const SharedUsers({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
          child: (controller.isSharedAlarmEnabled.value &&
                  controller.alarmRecord != null)
              ? (controller.alarmRecord!.ownerId != controller.userModel!.id)
                  ? ListTile(
                      title: const Text(
                        'Alarm Owner',
                        style: TextStyle(color: kprimaryTextColor),
                      ),
                      trailing: Text(
                        controller.alarmRecord!.ownerName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: kprimaryDisabledTextColor),
                      ))
                  : ListTile(
                      title: const Text(
                        'Shared Users',
                        style: TextStyle(color: kprimaryTextColor),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Utils.hapticFeedback();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: kprimaryBackgroundColor,
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
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          backgroundColor: kprimaryColor,
                                          valueColor: AlwaysStoppedAnimation(
                                            kprimaryColor,
                                          ),
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
                                                    style: const TextStyle(
                                                        color:
                                                            kprimaryTextColor),
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
                                                            color:
                                                                kprimaryTextColor
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
                                                const Divider(
                                                  color:
                                                      kprimaryDisabledTextColor,
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
                            color: kprimaryTextColor.withOpacity(0.7)),
                      ),
                    )
              : const SizedBox()),
    );
  }
}
