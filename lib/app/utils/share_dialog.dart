import 'dart:async';
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
  
  Future<void> _deleteEmail(Saved_Emails email) async {
    try {
      final isarProvider = IsarDb();
      final db = await isarProvider.db;
      
      await db.writeTxn(() async {
        await db.saved_Emails.delete(email.isarId);
      });
    } catch (e) {
      debugPrint('Error deleting email: $e');
      Get.snackbar(
        'Error'.tr,
        'Failed to delete contact'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Function to dismiss loading dialog safely
    void dismissLoadingDialog() {
      // Only dismiss if there's a dialog open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
    
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: themeController.primaryBackgroundColor.value,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.share_rounded,
                      color: kprimaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Share Alarm'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeController.primaryTextColor.value,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.close,
                        color: themeController.primaryTextColor.value.withOpacity(0.7),
                      ),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 8),
                    _buildRecipientSection(),
                    const SizedBox(height: 16),
                    Obx(
                      () => ElevatedButton.icon(
                        icon: Icon(
                          Icons.send_rounded,
                          color: controller.selectedEmails.isNotEmpty
                              ? Colors.white
                              : kprimaryColor,
                          size: 20,
                        ),
                        label: Text(
                          'Share'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: controller.selectedEmails.isNotEmpty
                                ? Colors.white
                                : kprimaryColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedEmails.isNotEmpty
                              ? kprimaryColor
                              : themeController.primaryDisabledTextColor.value.withOpacity(0.2),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (controller.selectedEmails.isEmpty) {
                            Get.snackbar(
                              'Error'.tr,
                              'Please select at least one recipient'.tr,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                            );
                            return;
                          }
                          
                          Utils.hapticFeedback();
                          
                          // Simple approach - show loading indicator in this screen
                          bool isLoading = true;
                          
                          // Create an overlay for the loading indicator that we can easily remove
                          OverlayEntry? overlayEntry;
                          overlayEntry = OverlayEntry(
                            builder: (context) => Material(
                              color: Colors.black54,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: themeController.secondaryBackgroundColor.value,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: CircularProgressIndicator(
                                          color: kprimaryColor,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Sharing alarm...'.tr,
                                        style: TextStyle(
                                          color: themeController.primaryTextColor.value,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                          
                          // Add overlay to screen
                          if (context.mounted) {
                            Overlay.of(context).insert(overlayEntry);
                          }
                          
                          // Force remove overlay after 10 seconds no matter what
                          Future.delayed(const Duration(seconds: 10), () {
                            overlayEntry?.remove();
                            overlayEntry = null;
                          });
                          
                          bool success = false;
                          String errorMessage = '';
                          
                          try {
                            if (homeController.isProfile.value) {
                              await FirestoreDb.shareProfile(
                                controller.selectedEmails,
                              );
                            } else {
                              debugPrint('🚀 Starting alarm sharing process...');
                              debugPrint('   - Recipients: ${controller.selectedEmails}');
                              debugPrint('   - Alarm ID: ${controller.alarmRecord.value.firestoreId}');
                              
                              // First share the alarm - with 10 second timeout
                              debugPrint('📤 Step 1: Sharing alarm to Firestore...');
                              try {
                                await Future.any([
                                  FirestoreDb.shareAlarm(
                                    controller.selectedEmails,
                                    controller.alarmRecord.value,
                                  ),
                                  Future.delayed(const Duration(seconds: 10))
                                ]);
                                debugPrint('✅ Step 1 completed: Firestore sharing');
                              } catch (e) {
                                debugPrint('❌ Step 1 failed: Firestore sharing error: $e');
                              }
                              
                              // Get user IDs (with 3 second timeout)
                              debugPrint('📤 Step 2: Getting user IDs...');
                              List<String> sharedUserIds = [];
                              try {
                                sharedUserIds = await Future.any([
                                  FirestoreDb.getUserIdsByEmails(controller.selectedEmails),
                                  Future.delayed(const Duration(seconds: 3), () => <String>[])
                                ]);
                                debugPrint('✅ Step 2 completed: Found ${sharedUserIds.length} user IDs');
                                
                                // Send notifications with timeout
                                debugPrint('📤 Step 3: Sending push notifications...');
                                if (sharedUserIds.isNotEmpty) {
                                  try {
                                    // Create shared item data for the notification
                                    final sharedItem = {
                                      'type': 'alarm',
                                      'AlarmName': controller.alarmRecord.value.firestoreId,
                                      'owner': controller.alarmRecord.value.ownerName ?? 'Someone',
                                      'alarmTime': controller.alarmRecord.value.alarmTime
                                    };
                                    
                                    await Future.any([
                                      PushNotifications().triggerSharedItemNotification(sharedUserIds, sharedItem: sharedItem),
                                      Future.delayed(const Duration(seconds: 3))
                                    ]);
                                    debugPrint('✅ Step 3 completed: Push notifications sent');
                                  } catch (e) {
                                    debugPrint('❌ Step 3 failed: Push notification error: $e');
                                  }
                                } else {
                                  debugPrint('⚠️ Step 3 skipped: No user IDs found');
                                }
                              } catch (e) {
                                debugPrint('❌ Step 2 failed: User ID lookup error: $e');
                              }
                              
                              debugPrint('🏁 Alarm sharing process completed');
                            }
                            success = true;
                          } catch (e) {
                            success = false;
                            errorMessage = e.toString();
                            debugPrint('Error sharing alarm: $e');
                          } finally {
                            // Remove loading overlay
                            overlayEntry?.remove();
                            overlayEntry = null;
                            
                            // Close share dialog
                            if (Get.isDialogOpen ?? false) {
                              Get.back();
                            }
                            
                            // Show appropriate snackbar
                            if (success) {
                              Get.snackbar(
                                'Success'.tr,
                                'Alarm shared successfully'.tr,
                                backgroundColor: kprimaryColor,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                              );
                            } else {
                              Get.snackbar(
                                'Error'.tr,
                                'Failed to share alarm: $errorMessage'.tr,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildContactsHeader(),
                    _buildAddContactSection(),
                    _buildContactsList(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipientSection() {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeController.secondaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kprimaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipients'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: themeController.primaryTextColor.value,
            ),
          ),
          const SizedBox(height: 8),
          controller.selectedEmails.isEmpty
              ? Text(
                  'No recipients selected'.tr,
                  style: TextStyle(
                    color: themeController.primaryDisabledTextColor.value,
                    fontSize: 14,
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.selectedEmails.map((email) {
                    return Chip(
                      backgroundColor: kprimaryColor.withOpacity(0.2),
                      label: Text(
                        email,
                        style: TextStyle(
                          color: kprimaryColor,
                          fontSize: 12,
                        ),
                      ),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16,
                        color: kprimaryColor,
                      ),
                      onDeleted: () {
                        controller.selectedEmails.remove(email);
                      },
                    );
                  }).toList(),
                ),
        ],
      ),
    ));
  }

  Widget _buildContactsHeader() {
    return Row(
      children: [
        Icon(
          Icons.people,
          color: kprimaryColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Select Contacts'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: themeController.primaryTextColor.value,
          ),
        ),
        const Spacer(),
        Obx(
          () => IconButton(
            icon: Icon(
              controller.isAddUser.value ? Icons.remove : Icons.add,
              color: kprimaryColor,
              size: 20,
            ),
            onPressed: () {
              Utils.hapticFeedback();
              controller.isAddUser.value = !controller.isAddUser.value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddContactSection() {
    return Obx(
      () => controller.isAddUser.value
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.emailTextEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter email address'.tr,
                        prefixIcon: const Icon(
                          Icons.alternate_email,
                          color: kprimaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: themeController.primaryDisabledTextColor.value,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: kprimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final email = controller.emailTextEditingController.text.trim();
                      if (email.isEmpty) return;
                      
                      if (RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(email)) {
                        Utils.hapticFeedback();
                        await IsarDb.addEmail(email);
                        controller.emailTextEditingController.clear();
                        
                        Get.snackbar(
                          'Success'.tr,
                          'Contact added'.tr,
                          backgroundColor: kprimaryColor,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 1),
                        );
                      } else {
                        Get.snackbar(
                          'Error'.tr,
                          'Invalid email format'.tr,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildContactsList(BuildContext context) {
    return StreamBuilder(
      stream: IsarDb.getEmails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                color: kprimaryColor,
              ),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading contacts'.tr,
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          final userList = snapshot.data;
          
          if (userList == null || userList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 48,
                      color: themeController.primaryDisabledTextColor.value,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No contacts found'.tr,
                      style: TextStyle(
                        color: themeController.primaryTextColor.value,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add contacts to share your alarm'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userList.length,
            itemBuilder: (context, index) {
              return _buildContactTile(userList[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildContactTile(Saved_Emails email) {
    return Obx(() {
      final isSelected = controller.selectedEmails.contains(email.email);
      
      return ListTile(
        onTap: () {
          Utils.hapticFeedback();
          if (isSelected) {
            controller.selectedEmails.remove(email.email);
          } else {
            controller.selectedEmails.add(email.email);
          }
        },
        leading: CircleAvatar(
          backgroundColor: isSelected
              ? kprimaryColor
              : themeController.secondaryBackgroundColor.value,
          child: isSelected
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Text(
                  Utils.getInitials(email.username),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kprimaryColor,
                  ),
                ),
        ),
        title: Text(
          email.username,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: themeController.primaryTextColor.value,
          ),
        ),
        subtitle: Text(
          email.email,
          style: TextStyle(
            fontSize: 12,
            color: themeController.primaryDisabledTextColor.value,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red.withOpacity(0.7),
            size: 20,
          ),
          onPressed: () async {
            Utils.hapticFeedback();
            
            final confirmed = await Get.dialog<bool>(
              AlertDialog(
                backgroundColor: themeController.secondaryBackgroundColor.value,
                title: Text('Remove contact?'.tr),
                content: Text(
                  'Are you sure you want to remove ${email.username} from your contacts?'.tr,
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
              if (controller.selectedEmails.contains(email.email)) {
                controller.selectedEmails.remove(email.email);
              }
              
              await _deleteEmail(email);
            }
          },
        ),
      );
    });
  }
}