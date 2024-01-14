import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../settings/controllers/theme_controller.dart';
import '../controllers/settings_controller.dart';

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
                inputDecorationTheme:
                    InputDecorationTheme(enabledBorder: InputBorder.none),
                trailingIcon: Icon(Icons.arrow_drop_down_outlined,
                    size: 40.0,
                    color: widget.themeController.isLightMode.value
                        ? kLightPrimaryTextColor.withOpacity(0.8)
                        : kprimaryTextColor.withOpacity(0.8)),
                width: widget.width * 0.78,
                initialSelection: 'English',
                label: const Text('Change Language'),
                dropdownMenuEntries:
                    widget.controller.optionslocales.entries.map((e) {
                  return DropdownMenuEntry(
                    value: e.key,
                    label: "${e.value['description']}",
                  );
                }).toList(),
                onSelected: (newValue) {
                  widget.controller.updateLocale(newValue!);
                }
            ),
          ],
        ),
      ),
    );
  }
}
