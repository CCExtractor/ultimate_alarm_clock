import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/language_controller.dart';

import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../settings/controllers/theme_controller.dart';
import '../controllers/settings_controller.dart';
//
// class LanguageMenu extends GetView<LanguageController>{
//   @override
//   ThemeController themeController = Get.find<ThemeController>();
//
//   LanguageMenu({super.key});
//   Widget build(BuildContext context){
//     return PopupMenuButton(
//       child: ListTile(
//         leading: Icon(
//             Icons.language_outlined,
//             size: 26,
//             color: themeController.isLightMode.value
//                 ? kLightPrimaryTextColor.withOpacity(0.8)
//                 : kprimaryTextColor.withOpacity(0.8),
//           ),
//          title: Text('Change Language',
//             style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                 color: themeController.isLightMode.value
//                     ? kLightPrimaryTextColor.withOpacity(0.8)
//                     : kprimaryTextColor.withOpacity(0.8)),
//           ),
//       ),
//       itemBuilder: (context) =>
//           controller.optionslocales.entries.map((e){
//             return PopupMenuItem(
//               value: e.key,
//               child: Text("${e.value['description']}",
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                     color: ksecondaryTextColor.withOpacity(0.8),
//               ),),);
//           }).toList(),
//       onSelected: (newValue){
//         controller.updateLocale(newValue);
//       },
//     );
//   }
//
// }

class LanguageMenu extends StatefulWidget {
  const LanguageMenu({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  });

  final SettingsController controller;
  final ThemeController themeController;

  final double height;
  final double width;

  @override
  State<LanguageMenu> createState() => _LanguageMenuState();
}

class _LanguageMenuState extends State<LanguageMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownMenu(
          trailingIcon: Icon(
            Icons.arrow_drop_down_outlined,
            size: 40.0,
            color: widget.themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(0.8)
                    : kprimaryTextColor.withOpacity(0.8)
          ),
          width: widget.width * 0.91,
          initialSelection: 'English',
          label: Padding(padding: EdgeInsets.all(15.0),
              child: const Text('Change Language')),
          dropdownMenuEntries: widget.controller.optionslocales.entries.map((e) {
            return DropdownMenuEntry(
              value: e.key,
              label: "${e.value['description']}",
            );
          }).toList(),
          onSelected: (newValue) {
            widget.controller.updateLocale(newValue!);
          }
      ),
    );
  }
}