import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class QrBarCode extends StatelessWidget {
  const QrBarCode({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    bool isQrEnabled;
    return Obx(
      () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          // storing initial state
          isQrEnabled = controller.isQrEnabled.value;
          
          _showQrSettingsBottomSheet(context, isQrEnabled);
        },
        child: ListTile(
          leading: Icon(
            controller.isQrEnabled.value ? Icons.qr_code_scanner : Icons.qr_code_scanner_outlined,
            color: controller.isQrEnabled.value 
                ? kprimaryColor 
                : themeController.primaryDisabledTextColor.value,
          ),
          title: Text(
            'QR/Bar Code Challenge'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
          subtitle: Text(
            controller.isQrEnabled.value
                ? 'Scan QR code to dismiss alarm'.tr
                : 'Disabled'.tr,
            style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: themeController.primaryDisabledTextColor.value,
          ),
        ),
      ),
    );
  }

  void _showQrSettingsBottomSheet(BuildContext context, bool initialIsQrEnabled) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeController.secondaryBackgroundColor.value,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: kprimaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'QR/Bar Code Challenge'.tr,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: themeController.primaryTextColor.value,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Enable/Disable Switch
                          _buildSection(
                            title: 'Enable QR Challenge'.tr,
                            subtitle: 'Require QR code scan to dismiss alarm'.tr,
                            child: Obx(() => Switch.adaptive(
                              value: controller.isQrEnabled.value,
                              onChanged: (value) async {
                                Utils.hapticFeedback();
                                if (value) {
                                  await controller.requestQrPermission(context);
                                } else {
                                  controller.isQrEnabled.value = false;
                                }
                              },
                              activeColor: kprimaryColor,
                            )),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // QR Code Info (when enabled)
                          Obx(() => controller.isQrEnabled.value
                              ? _buildSection(
                                  title: 'How it works'.tr,
                                  subtitle: 'Scan instructions and tips'.tr,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blue.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                'Setup Instructions'.tr,
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  color: themeController.primaryTextColor.value,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          '1. Scan a QR code on any object (book, poster, etc.)\n2. Move that object to another room\n3. When alarm rings, find and scan the same QR code'.tr,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: themeController.primaryTextColor.value,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container()),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: themeController.secondaryBackgroundColor.value,
                      border: Border(
                        top: BorderSide(
                          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              // Reset to initial values
                              controller.isQrEnabled.value = initialIsQrEnabled;
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: themeController.primaryDisabledTextColor.value.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Cancel'.tr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: themeController.primaryTextColor.value,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.hapticFeedback();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Done'.tr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeController.primaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeController.primaryDisabledTextColor.value.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
