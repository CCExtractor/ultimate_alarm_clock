import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';

import '../../../utils/constants.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.notifications),
            Text(' Notifications'),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirestoreDb.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List notif = snapshot.data!['receivedItems'];
            controller.notifications = notif;
            return controller.notifications.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Get.dialog(
                            Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: ksecondaryBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          controller.notifications[index]
                                                      ['type'] ==
                                                  'profile'
                                              ? 'Add profile '
                                              : 'Add Alarm ',
                                          style: TextStyle(
                                            fontSize: controller.homeController
                                                    .scalingFactor *
                                                20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          controller.notifications[index]
                                                      ['type'] ==
                                                  'profile'
                                              ? "${controller.notifications[index]['profileName']} ?"
                                              : "${controller.notifications[index]['alarmTime']} ?",
                                          style: TextStyle(
                                            color: kprimaryColor,
                                            fontSize: controller.homeController
                                                    .scalingFactor *
                                                20,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    controller.notifications[index]['type'] ==
                                            'profile'
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: controller
                                                      .homeController
                                                      .scalingFactor *
                                                  20,
                                            ),
                                            child: Text(
                                                "Select profile to add to"),
                                          ),
                                    controller.notifications[index]['type'] ==
                                            'profile'
                                        ? const SizedBox()
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                controller.allProfiles.length,
                                            itemBuilder: (context, index) {
                                              return Obx(() => ListTile(
                                                  onTap: () {
                                                    controller.selectedProfile
                                                            .value =
                                                        controller
                                                            .allProfiles[index];
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18)),
                                                  tileColor: controller
                                                              .selectedProfile
                                                              .value ==
                                                          controller
                                                                  .allProfiles[
                                                              index]
                                                      ? kprimaryColor
                                                      : ksecondaryBackgroundColor,
                                                  title: Text(
                                                    controller
                                                        .allProfiles[index],
                                                    style: TextStyle(
                                                      color: controller
                                                                  .selectedProfile
                                                                  .value ==
                                                              controller
                                                                      .allProfiles[
                                                                  index]
                                                          ? kprimaryBackgroundColor
                                                          : Colors.white,
                                                      fontSize: controller
                                                              .homeController
                                                              .scalingFactor *
                                                          18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )));
                                            }),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            await FirestoreDb.removeItem(
                                              controller.notifications[index],
                                            );
                                            Get.snackbar('Notification',
                                                'Shared Item Removed',);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Reject',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            controller.notifications[index]
                                                        ['type'] ==
                                                    'profile'
                                                ? await controller
                                                    .importProfile(
                                                    controller.notifications[
                                                        index]['owner'],
                                                    controller.notifications[
                                                        index]['profileName'],
                                                  )
                                                : await controller.importAlarm(
                                                    controller.notifications[
                                                        index]['owner'],
                                                    controller.notifications[
                                                        index]['AlarmName'],
                                                  );
                                            await FirestoreDb.removeItem(
                                                controller
                                                    .notifications[index]);


                                            Get.snackbar("Notification",
                                                "Shared Item Added");
                                          },
                                          child: const Text('Add'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        title: toAccept(controller.notifications[index]),
                      );
                    },
                  )
                : const Text(
                    "No Notifications to see",
                    style: TextStyle(color: kprimaryDisabledTextColor),
                  );
            ;
          }
          return const Text(
            "No Notifications to see",
            style: TextStyle(color: kprimaryDisabledTextColor),
          );
        },
      ),
    );
  }

  Widget toAccept(Map notification) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ksecondaryBackgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: EdgeInsets.all(
                    controller.homeController.scalingFactor * 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: notification['type'] == 'profile'
                      ? Text(
                          '${notification['profileName']}'
                              .substring(0, 2)
                              .toUpperCase(),
                          style: TextStyle(
                            color: ksecondaryColor,
                            fontSize:
                                controller.homeController.scalingFactor * 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : Icon(
                          Icons.alarm,
                          size: controller.homeController.scalingFactor * 20,
                          color: ksecondaryColor,
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
              children: [
                notification['type'] == 'profile'
                    ? Text(
                        '${notification['owner']} sent a profile.',
                        style: TextStyle(
                          fontSize:
                              controller.homeController.scalingFactor * 14,
                        ),
                      )
                    : Text(
                        '${notification['owner']} sent an alarm.',
                        style: TextStyle(
                          fontSize:
                              controller.homeController.scalingFactor * 14,
                        ),
                      ),
                notification['type'] == 'profile'
                    ? Text(
                        notification['profileName'],
                        style: TextStyle(
                          color: kprimaryColor,
                          fontSize:
                              controller.homeController.scalingFactor * 20,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Text(
                        notification['alarmTime'],
                        style: TextStyle(
                          color: kprimaryColor,
                          fontSize:
                              controller.homeController.scalingFactor * 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
