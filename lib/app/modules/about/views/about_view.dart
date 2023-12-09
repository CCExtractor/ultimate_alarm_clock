import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/about/controller/about_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AboutView extends GetView<AboutController> {
  final AboutController aboutController = Get.find<AboutController>();
  ThemeController themeController = Get.find<ThemeController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About',style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: themeController.isLightMode.value
              ? kLightPrimaryTextColor
              : kprimaryTextColor,
          fontWeight: FontWeight.w500,
        ),),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: themeController.isLightMode.value
                ? kLightPrimaryTextColor
                : kprimaryTextColor,
          ),
          onPressed: () {
            Utils.hapticFeedback();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.fromSize(
                size: Size.fromRadius(48),
                child: Image.asset('assets/images/ic_launcher-playstore.png'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ultimate Alarm Clock',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'This project aims to build a non-conventional alarm clock with smart features such as auto-dismissal based on phone activity, weather, and more!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (!await aboutController
                          .launchUrl(Uri.parse(AboutController.githubUrl))) {
                        throw Exception(
                            'Could not launch ${AboutController.githubUrl}');
                      }
                    },
                    icon: SvgPicture.asset(
                      "assets/images/github.svg",
                      width: 30,
                      height: 30,
                    ),
                    label: Text(
                      "GitHub",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (!await aboutController.launchUrl(
                          Uri.parse(AboutController.ccExtractorUrl))) {
                        throw Exception(
                            'Could not launch ${AboutController.ccExtractorUrl}');
                      }
                    },
                    icon: SvgPicture.asset(
                      "assets/images/link.svg",
                      width: 30,
                      height: 30,
                    ),
                    label: Text(
                      "CCExtractor",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
