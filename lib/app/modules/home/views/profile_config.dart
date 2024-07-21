import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

import '../../../utils/constants.dart';

class ProfileSelect extends StatefulWidget {
  const ProfileSelect({super.key});

  @override
  State<ProfileSelect> createState() => _ProfileSelectState();
}

class _ProfileSelectState extends State<ProfileSelect> {
  HomeController controller = Get.find<HomeController>();
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return SizeTransition(
              sizeFactor: animation, axis: Axis.horizontal, child: child);
        },
        child: !controller.expandProfile.value
            ? Container(
                key: ValueKey(1),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24 * controller.scalingFactor.value,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24 * controller.scalingFactor.value,
                          vertical: 4 * controller.scalingFactor.value,
                        ),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topCenter,
                              stops: [0.2, 0.2],
                              colors: [
                                kprimaryColor,
                                ksecondaryBackgroundColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18)),
                        child: Text(
                          "Profile",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryTextColor.withOpacity(
                                        0.75,
                                      )
                                    : kprimaryTextColor.withOpacity(
                                        0.75,
                                      ),
                                fontSize: 22 * controller.scalingFactor.value,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () {
                          controller.expandProfile.value =
                              !controller.expandProfile.value;
                        },
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_ios),
                        )),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () {
                        controller.isProfile.value = true;
                        Get.toNamed('/add-update-alarm',
                            );
                      },
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add),
                      )),
                    ),
                  ],
                ),
              )
            : Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 24 * controller.scalingFactor.value,
                    ),
                    child: InkWell(
                      onTap: () {
                        controller.expandProfile.value =
                            !controller.expandProfile.value;
                      },
                      child: Container(child: Icon(Icons.arrow_back_ios)),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.8,
                    key: ValueKey(2),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          profileCapsule("Profile 1"),
                          profileCapsule("Profile 2"),
                          profileCapsule("Profile 3")
                        ],
                      ),
                    ),
                  ),
                ],
              )));
  }

  Widget profileCapsule(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24 * controller.scalingFactor.value,
          vertical: 4 * controller.scalingFactor.value,
        ),
        decoration: BoxDecoration(
            color: ksecondaryBackgroundColor,
            borderRadius: BorderRadius.circular(18)),
        child: Text(
          "$name",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(
                        0.75,
                      )
                    : kprimaryTextColor.withOpacity(
                        0.75,
                      ),
                fontSize: 22 * controller.scalingFactor.value,
              ),
        ),
      ),
    );
  }
}
