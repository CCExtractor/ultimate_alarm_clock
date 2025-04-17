import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class WifiBasedTile extends StatelessWidget {
  const WifiBasedTile({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () async {
          Utils.hapticFeedback();
          if (await controller.checkAndRequestPermission()) {
            final info = NetworkInfo();
            final wifiName = await info.getWifiName();
            final wifiBSSID = await info.getWifiBSSID();

            Get.defaultDialog(
                titlePadding: const EdgeInsets.symmetric(vertical: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                backgroundColor: themeController.secondaryBackgroundColor.value,
                title: 'Use this wifi network for alarm cancellation.',
                titleStyle: Theme.of(context).textTheme.displaySmall,
                content: WifiOption(
                    name: wifiName,
                    bssid: wifiBSSID,
                    controller: controller,
                    themeController: themeController,),
                
                
                );
                
          } else {}
        },
        title: Row(
          children: [
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                'Wifi SSID Based'.tr,
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.info_sharp,
                size: 21,
                color: themeController.primaryTextColor.value.withOpacity(0.3),
              ),
              onPressed: () {
                Utils.hapticFeedback();
                Utils.showModal(
                  context: context,
                  title: 'Wifi SSID based cancellation',
                  description:
                      'This feature will automatically cancel the alarm if you are connected to the specified wifi network',
                  iconData: Icons.wifi,
                  isLightMode:
                      themeController.currentTheme.value == ThemeMode.light,
                );
              },
            ),
          ],
        ),
        trailing: InkWell(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width *
                      0.3, // Adjust width dynamically
                  alignment: Alignment.centerRight,
                  child: Text(
                    controller.isWifiEnabled.value
                        ? controller.wifiName.value
                        : 'Off',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: (controller.isWeatherEnabled.value == false)
                              ? kprimaryDisabledTextColor
                              : themeController.primaryTextColor.value,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: kprimaryDisabledTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WifiOption extends StatelessWidget {
  const WifiOption({
    super.key,
    required this.name,
    required this.bssid,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final String? name;
  final String? bssid;

  @override
  Widget build(BuildContext context) {
    if (bssid != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Name: ', style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),),
            const SizedBox(width: 5,),
            Text(name!.substring(1, name!.length-1)),],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('BSSID: ', style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),),
            const SizedBox(width: 5,),
            Text(bssid!)],
          ),
          SizedBox(height: 20,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(themeController.primaryColor.value),
                    foregroundColor: WidgetStatePropertyAll(themeController.secondaryTextColor.value)
                  ),
                  onPressed: () {
                    controller.isWifiEnabled.value = false;
                    controller.wifiName.value = '';
                    controller.wifiBSSID.value = '';
                    Get.back();
                  },
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600),)),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(themeController.primaryColor.value),
                    foregroundColor: WidgetStatePropertyAll(themeController.secondaryTextColor.value)
                  ),
                  onPressed: () {
                    controller.isWifiEnabled.value = true;
                    controller.wifiName.value = name!.substring(1, name!.length-1);
                    controller.wifiBSSID.value = bssid!;
                    Get.back();
                  },
                  child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.w600),)),
            ],
          )
        ],
      );
    }
    else {
      return Column(
        children: [
          const Text('No Wifi Connected!'),
          Text(
            'Connect to a wifi network to use this feature.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
              fontSize: 14
            ),
          ),
          const SizedBox(height: 20,),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(themeController.primaryColor.value),
              foregroundColor: WidgetStatePropertyAll(themeController.secondaryTextColor.value)
            ),
            onPressed: () {
              controller.isWifiEnabled.value = false;
              controller.wifiName.value = '';
              controller.wifiBSSID.value = '';
              Get.back();
            },
            child: const Text('Turn this feature Off', style: TextStyle(fontWeight: FontWeight.w600),)),
        ],
      );
    }
  }
}
