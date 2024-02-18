import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../../data/providers/secure_storage_provider.dart';

class ThemeValueTile extends StatefulWidget {
  const ThemeValueTile({
    Key? key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  }) : super(key: key);

  final SettingsController controller;
  final ThemeController themeController;
  final double height;
  final double width;

  @override
  State<ThemeValueTile> createState() => _ThemeValueTileState();
}

class _ThemeValueTileState extends State<ThemeValueTile> {
    final _secureStorageProvider = SecureStorageProvider();
    String appTheme = '';
@override
  void initState() {
    getAppTheme();
        super.initState();
  }

  void getAppTheme()async{
if(await _secureStorageProvider.readThemeValue() == AppTheme.system){
 setState(() {
    appTheme = 'System Mode';
 });
}
if(await _secureStorageProvider.readThemeValue() == AppTheme.light){
  setState(() {
    appTheme = 'Light Mode';
  });
}
if(await _secureStorageProvider.readThemeValue() == AppTheme.dark){
  setState(() {
    appTheme = 'Dark Mode';
  });
}


  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.91,
      height: widget.height * 0.1,
      decoration: Utils.getCustomTileBoxDecoration(
        isLightMode: widget.themeController.isLightMode.value,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30),
        child: Row(
          children: [
            DropdownMenu(
              menuStyle: MenuStyle(
                backgroundColor: MaterialStatePropertyAll(
                  widget.themeController.isLightMode.value
                      ? kLightSecondaryBackgroundColor
                      : ksecondaryBackgroundColor,
                ),
              ),
              inputDecorationTheme:
                  InputDecorationTheme(enabledBorder: InputBorder.none),
              trailingIcon: Icon(
                Icons.arrow_drop_down_outlined,
                size: 40.0,
                color: widget.themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(0.8)
                    : kprimaryTextColor.withOpacity(0.8),
              ),
              width: widget.width * 0.78,
              initialSelection: appTheme,
              label: Text('Select Theme'),
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  value: 'System Mode',
                  label: 'System Mode',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                      widget.themeController.isLightMode.value
                          ? kLightPrimaryTextColor
                          : kprimaryTextColor,
                    ),
                  ),
                ),
                DropdownMenuEntry(
                  value: 'Light Mode',
                  label: 'Light Mode',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                      widget.themeController.isLightMode.value
                          ? kLightPrimaryTextColor
                          : kprimaryTextColor,
                    ),
                  ),
                ),
                DropdownMenuEntry(
                  value: 'Dark Mode',
                  label: 'Dark Mode',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                      widget.themeController.isLightMode.value
                          ? kLightPrimaryTextColor
                          : kprimaryTextColor,
                    ),
                  ),
                ),
              ],
              onSelected: (newValue) {
                if (newValue == 'System Mode') {
                  widget.themeController.toggleSystemTheme();
                } else if (newValue == 'Light Mode') {
                  widget.themeController.toggleThemeValue(true);
                  Get.changeThemeMode(ThemeMode.light);
                } else {
                  widget.themeController.toggleThemeValue(false);
                  Get.changeThemeMode(ThemeMode.dark);
                }
                Utils.hapticFeedback();
                
              },
            ),
          ],
        ),
      ),
    );
  }
}
