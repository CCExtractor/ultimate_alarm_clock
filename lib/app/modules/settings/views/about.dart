import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/modules/about/controller/about_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    Key? key,
    required this.aboutController,
    required this.width,
    required this.height,
    required this.themeController,
  }) : super(key: key);

  final AboutController aboutController;
  final ThemeController themeController;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        aboutController.navigateToAboutView();
      },
      child: Container(
        width: width * 0.91,
        height: height * 0.1,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(18),
          ),
          color: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(0.4)
                    : kprimaryTextColor.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
