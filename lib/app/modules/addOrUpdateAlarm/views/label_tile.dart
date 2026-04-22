import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class LabelTile extends StatelessWidget {
  const LabelTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(

        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            'Label'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
        ),
        onTap: () {
          Utils.hapticFeedback();
          _showLabelBottomSheet(context);
        },
        trailing: InkWell(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () => Container(
                  width: 100,
                  alignment: Alignment.centerRight,
                  child: Text(
                    (controller.label.value.trim().isNotEmpty)
                        ? controller.label.value
                        : 'Off'.tr,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: (controller.label.value.trim().isEmpty)
                              ? themeController.primaryDisabledTextColor.value
                              : themeController.primaryTextColor.value,
                        ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: (controller.label.value.trim().isEmpty)
                    ? themeController.primaryDisabledTextColor.value
                    : themeController.primaryTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLabelBottomSheet(BuildContext context) {
    // Store original value for cancellation
    String originalLabel = controller.labelController.text;
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: themeController.secondaryBackgroundColor.value,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: themeController.primaryDisabledTextColor.value
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add a label'.tr,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: themeController.primaryTextColor.value,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Reset to original value if cancelled
                          controller.labelController.text = originalLabel;
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: themeController.primaryDisabledTextColor.value,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Input Field
                      TextField(
                        autofocus: true,
                        controller: controller.labelController,
                        maxLength: 50, // Reasonable limit for labels
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: themeController.primaryTextColor.value,
                        ),
                        cursorColor: kprimaryColor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: themeController.primaryBackgroundColor.value,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: themeController.primaryDisabledTextColor.value
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: kprimaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Enter a label'.tr,
                          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: themeController.primaryDisabledTextColor.value,
                          ),
                          counterStyle: TextStyle(
                            color: themeController.primaryDisabledTextColor.value,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _saveLabelAndClose(context),
                        onChanged: (text) {
                          // Remove leading whitespace
                          if (text.isNotEmpty && text[0] == ' ') {
                            controller.labelController.text = text.trimLeft();
                            controller.labelController.selection = TextSelection.fromPosition(
                              TextPosition(offset: controller.labelController.text.length),
                            );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Helper text
                      Text(
                        'Give your alarm a memorable name'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: themeController.primaryDisabledTextColor.value,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          // Cancel Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Utils.hapticFeedback();
                                // Reset to original value
                                controller.labelController.text = originalLabel;
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(
                                  color: themeController.primaryDisabledTextColor.value
                                      .withOpacity(0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel'.tr,
                                style: TextStyle(
                                  color: themeController.primaryTextColor.value,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Save Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Utils.hapticFeedback();
                                _saveLabelAndClose(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kprimaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Save'.tr,
                                style: TextStyle(
                                  color: themeController.secondaryTextColor.value,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Extra padding for keyboard
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveLabelAndClose(BuildContext context) {
    controller.label.value = controller.labelController.text.trim();
    Navigator.pop(context);
  }
}
