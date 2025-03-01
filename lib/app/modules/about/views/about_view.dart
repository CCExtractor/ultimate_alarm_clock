import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/about/controller/about_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AboutView extends GetView<AboutController> {
  final AboutController aboutController = Get.find<AboutController>();
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'About'.tr,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Obx(
            () => Icon(
              Icons.adaptive.arrow_back,
              color: themeController.primaryTextColor.value,
            ),
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
                size: const Size.fromRadius(48),
                child: Image.asset('assets/images/ic_launcher-playstore.png'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ultimate Alarm Clock'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Version: 0.2.1'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'This project was originally developed as part of Google Summer of code under the CCExtractor organization. It\'s free, the source code is available, and we encourage programmers to contribute'
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                          'Could not launch ${AboutController.githubUrl}'.tr,
                        );
                      }
                    },
                    icon: SvgPicture.asset(
                      'assets/images/github.svg',
                      width: 30,
                      height: 30,
                    ),
                    label: const Text(
                      'GitHub',
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
                        Uri.parse(AboutController.ccExtractorUrl),
                      )) {
                        throw Exception(
                          'Could not launch ${AboutController.ccExtractorUrl}'
                              .tr,
                        );
                      }
                    },
                    icon: SvgPicture.asset(
                      'assets/images/link.svg',
                      width: 30,
                      height: 30,
                    ),
                    label: const Text(
                      'CCExtractor',
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
