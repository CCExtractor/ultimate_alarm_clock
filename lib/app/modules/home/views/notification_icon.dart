// You will need to add this import for the explicit snapshot types
import 'package:cloud_firestore/cloud_firestore.dart';
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
          ? StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirestoreDb.getNotifications(),
              // Be explicit with the snapshot type for better safety
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                // 1. Handle errors (like the SecurityException)
                if (snapshot.hasError) {
                  print("Error in notification stream: ${snapshot.error}");
                  // Return the disabled icon as per your original 'else' block
                  return const Icon(
                    Icons.notifications_none,
                    color: kprimaryDisabledTextColor,
                  );
                }

                // 2. Handle loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Return the disabled icon as per your original 'else' block
                  return const Icon(
                    Icons.notifications_none,
                    color: kprimaryDisabledTextColor,
                  );
                }

                // 3. Handle document not existing
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  // Use your "no notifications" UI from the original `notif.isEmpty` block
                  return InkWell(
                    onTap: () {
                      Get.snackbar('Notifications', 'No Notifications');
                    },
                    // We use the non-disabled icon, as this is a valid (empty) state
                    child: const Icon(Icons.notifications),
                  );
                }

                // 4. Handle field not existing (extra safe)
                var data = snapshot.data!.data();
                if (data == null || !data.containsKey('receivedItems')) {
                  // Use your "no notifications" UI
                  return InkWell(
                    onTap: () {
                      Get.snackbar('Notifications', 'No Notifications');
                    },
                    child: const Icon(Icons.notifications),
                  );
                }

                // 5. SUCCESS! Data is valid and the field exists.
                // We can now safely access the data.
                final List notif = data['receivedItems'] as List;
                controller.notifications = notif;

                // Return your original logic, which is now 100% safe to run
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
              },
            )
          : const Icon(
              Icons.notifications_none,
              color: kprimaryDisabledTextColor,
            ),
    ),
  );
}