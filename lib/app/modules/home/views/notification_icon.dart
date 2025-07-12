import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import '../../../routes/app_pages.dart';

Widget notificationIcon(HomeController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Obx(
      () => controller.isUserSignedIn.value
          ? StreamBuilder(
              stream: FirestoreDb.getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final document = snapshot.data!;
                  final data = document.data();
                  final List notif = data != null ? (data['receivedItems'] ?? []) : [];
                  controller.notifications = notif;
                  
                  debugPrint('🔔 NotificationIcon: Document exists: ${document.exists}, Data: $data, Notifications: ${notif.length}');
                  return notif.isEmpty
                      ? InkWell(
                          onTap: () {
                            Get.snackbar('Notifications', 'No Notifications');
                          },
                          child: const Icon(Icons.notifications),
                        )
                      : InkWell(
                          onTap: () {
                            Get.toNamed(
                              Routes.NOTIFICATIONS,
                            );
                          },
                          child: Stack(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.notifications,
                                ),
                              ),
                              Positioned(
                                left: 28,
                                top: -3,
                                child: Text(
                                  '${notif.length}',
                                  style: const TextStyle(
                                    color: kprimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                }
                return const Icon(
                  Icons.notifications_none,
                  color: kprimaryDisabledTextColor,
                );
              },
            )
          : const Icon(
              Icons.notifications_none,
              color: kprimaryDisabledTextColor,
            ),
    ),
  );
}
