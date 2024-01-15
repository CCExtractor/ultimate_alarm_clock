import 'package:flutter/material.dart';
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
  String lang = 'en_US';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.91,
      height: widget.height * 0.1,
      decoration: Utils.getCustomTileBoxDecoration(
        isLightMode: widget.themeController.isLightMode.value,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 20),
        child: Row(
          children: [
            Container(
              width: widget.width * 0.78,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: lang,
                  items: widget.controller.optionslocales.entries.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.key,
                      child: Text(
                        "${e.value['description']}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    widget.controller.updateLocale(newValue!);
                    setState(() {
                      lang = newValue;
                    });
                  },
                  style: TextStyle(
                    color: widget.themeController.isLightMode.value
                        ? kLightPrimaryTextColor.withOpacity(0.8)
                        : kprimaryTextColor.withOpacity(0.8),
                  ),
                  dropdownColor: widget.themeController.isLightMode.value
                      ? Colors.white // Light theme background color
                      : Colors.black, // Dark theme background color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
