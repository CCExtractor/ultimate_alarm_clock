import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/routes/app_pages.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

Widget buildEndDrawer(BuildContext context) {
  ThemeController themeController = Get.find<ThemeController>();
  return Obx(
    () => Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          bottomLeft: Radius.circular(10.r),
        ),
      ),
      backgroundColor: themeController.secondaryBackgroundColor.value,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: kLightSecondaryColor),
            child: Center(
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundImage: const AssetImage(
                        'assets/images/ic_launcher-playstore.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 0.5.sw,
                          child: Text(
                            'Ultimate Alarm Clock'.tr,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: themeController
                                        .primaryBackgroundColor.value,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp),
                          ),
                        ),
                        SizedBox(
                          width: 0.5.sw,
                          child: Text(
                            'v0.2.1'.tr,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: themeController.primaryTextColor.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Utils.hapticFeedback();
              Get.back();
              Get.toNamed('/settings');
            },
            contentPadding: EdgeInsets.only(left: 20.w, right: 44.w),
            title: Text(
              'Settings'.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.8),
                    fontSize: 16.sp,
                  ),
            ),
            leading: Icon(
              Icons.settings,
              size: 24.r,
              color: themeController.primaryTextColor.value.withOpacity(0.8),
            ),
          ),
          ListTile(
            onTap: () {
              Utils.hapticFeedback();
              Get.back();
              Get.toNamed(Routes.ABOUT);
            },
            contentPadding: EdgeInsets.only(left: 20.w, right: 44.w),
            title: Text(
              'About'.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.8),
                    fontSize: 16.sp,
                  ),
            ),
            leading: Icon(
              Icons.info_outline,
              size: 24.r,
              color: themeController.primaryTextColor.value.withOpacity(0.8),
            ),
          ),
        ],
      ),
    ),
  );
}
