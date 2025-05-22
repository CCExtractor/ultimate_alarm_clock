import 'package:flutter/material.dart';
import '../../settings/controllers/theme_controller.dart';
import '../controllers/add_or_update_alarm_controller.dart';

// This is just a simple wrapper to maintain compatibility
// The actual implementation is in qr_bar_code_tile.dart
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
    // Just forward the parameters to the existing implementation
    return ListTile(
      title: Row(
        children: [
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              'QR/Bar Code',
              style: TextStyle(
                color: themeController.primaryTextColor.value,
              ),
            ),
          ),
        ],
      ),
      onTap: () async {
        await controller.requestQrPermission(context);
      },
      trailing: Text(
        controller.isQrEnabled.value ? 'Enabled' : 'Off',
        style: TextStyle(
          color: controller.isQrEnabled.value
              ? themeController.primaryTextColor.value
              : themeController.primaryDisabledTextColor.value,
        ),
      ),
    );
  }
} 