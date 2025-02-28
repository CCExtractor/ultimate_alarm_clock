
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';

import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../controllers/theme_controller.dart';

class CustomizeUndoDuration extends StatelessWidget{
  HomeController homeController = Get.find<HomeController>();
  CustomizeUndoDuration({
    super.key ,
    required this.themeController,
    required this.height,
    required this.width,
  });
  final ThemeController themeController;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    int duration;
    return Obx(
        () => InkWell(
        onTap: () {
          Utils.hapticFeedback();
          duration = homeController.duration.value;
          Get.defaultDialog(
            onWillPop: () async {
              Get.back();
              // Resetting the value to its initial state
              homeController.duration.value = duration;
              return true;
            },
            titlePadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Customize Undo Duration'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
                  () => Column(
                children: [
                  Text(
                    '${homeController.duration.value} seconds'.tr,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Slider(
                    value: homeController.selecteddurationDouble.value,
                    onChanged: (double value) {
                      homeController.selecteddurationDouble.value = value;
                      homeController.duration.value = value.toInt();
      
                    },
                    min: 0.0,
                    max: 20.0,
                    divisions: 20,
                    label: homeController.duration.value.toString(),
                  ),
                  // Replace the volMin Slider with RangeSlider
      
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                    ),
                    child: Text(
                      'Apply Duration'.tr,
                      style: TextStyle(
                        color: themeController.secondaryTextColor.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          width: width * 0.91,
          height: height * 0.09,
          decoration: Utils.getCustomTileBoxDecoration(
            isLightMode: themeController.currentTheme.value == ThemeMode.light,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
                tileColor: themeController.secondaryBackgroundColor.value,
                title: Text(
                  'Undo Duration'.tr,
                  style: TextStyle(
                    color: themeController.primaryTextColor.value,
                    fontSize: 15
                  ),
                ),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Obx(
                          () => Text(
                        '${homeController.duration.value.round().toInt()} seconds',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: themeController.primaryTextColor.value,
                            fontSize: 13
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: themeController.primaryDisabledTextColor.value,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}