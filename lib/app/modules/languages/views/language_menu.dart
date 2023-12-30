import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/languages/controllers/language_controller.dart';

import '../../../utils/constants.dart';
import '../../settings/controllers/theme_controller.dart';

class LanguageMenu extends GetView<LanguageController>{
  @override
  ThemeController themeController = Get.find<ThemeController>();

  LanguageMenu({super.key});
  Widget build(BuildContext context){
    return PopupMenuButton(
      child: ListTile(
        leading: Icon(
            Icons.language_outlined,
            size: 26,
            color: themeController.isLightMode.value
                ? kLightPrimaryTextColor.withOpacity(0.8)
                : kprimaryTextColor.withOpacity(0.8),
          ),
         title: Text('Change Language',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(0.8)
                    : kprimaryTextColor.withOpacity(0.8)),
          ),
      ),
      itemBuilder: (context) =>
          controller.optionslocales.entries.map((e){
            return PopupMenuItem(
              value: e.key,
              child: Text("${e.value['description']}",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: ksecondaryTextColor.withOpacity(0.8),
              ),),);
          }).toList(),
      onSelected: (newValue){
        controller.updateLocale(newValue);
      },
    );
  }
}