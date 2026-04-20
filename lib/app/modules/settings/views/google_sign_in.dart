import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../../data/providers/google_cloud_api_provider.dart';

class GoogleSignIn extends StatelessWidget {
  const GoogleSignIn({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
    required this.themeController,
  });

  final SettingsController controller;
  final ThemeController themeController;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      onTap: () async {
        Utils.hapticFeedback();
        if (controller.isUserLoggedIn.value == false) {
          try {
            var isSuccessfulLogin = await GoogleCloudProvider.getInstance();

            if (isSuccessfulLogin != null) {
              Get.defaultDialog(
                titlePadding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: themeController.secondaryBackgroundColor.value,
                title: 'Success!'.tr,
                titleStyle: Theme.of(context).textTheme.displaySmall,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.done,
                      size: 50,
                      color: Colors.green,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Your account is now linked!'.tr,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(kprimaryColor),
                      ),
                      child: Obx(
                        () => Text(
                          'Okay'.tr,
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: themeController.secondaryTextColor.value,
                              ),
                        ),
                      ),
                      onPressed: () {
                        Utils.hapticFeedback();
                        Get.back();
                      },
                    ),
                  ],
                ),
              );
            } else {
              Get.snackbar(
                'Error'.tr, 
                'Sign-In attempt failed! Please try again.'.tr,
                backgroundColor: Colors.red.withOpacity(0.8),
                colorText: Colors.white,
              );
            }
          } catch (e) {
            Get.snackbar(
              'Error'.tr, 
              'Sign-In failed: @error'.trParams({'error': e.toString()}),
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );
          }
        } else {
          Get.defaultDialog(
            contentPadding: const EdgeInsets.all(10.0),
            titlePadding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Are you sure?'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Column(
              children: [
                Text(
                    // 'Do you want to unlink your Google account?',
                    'unlinkAccount'.tr),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        child: Obx(
                          () => Text(
                            'Unlink'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: themeController.secondaryTextColor.value,
                                ),
                          ),
                        ),
                        onPressed: () async {
                          Utils.hapticFeedback();
                          await controller.logoutGoogle();
                          Get.back();
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            kprimaryTextColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: Theme.of(context).textTheme.displaySmall!,
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        width: width * 0.91,
        height: height * 0.1,
        decoration: Utils.getCustomTileBoxDecoration(
          isLightMode: themeController.currentTheme.value == ThemeMode.light,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Expanded(
                    child: Text(
                      (controller.isUserLoggedIn.value)
                          ?
                          // 'Unlink ${controller.userModel!.email}'
                          'Unlink @usermail'.trParams(
                              {'usermail': controller.userModel.value!.email})
                          : 'Sign-In with Google'.tr,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                ),Obx(
                () => IconButton(
                  onPressed: () => {
                    Utils.hapticFeedback(),
                    showBottomSheet(
                      context: context,
                      backgroundColor: themeController.secondaryBackgroundColor.value,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Why do I have to sign in with Google?'.tr,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              Column(
                                children: [
                                  Text(
                                    // 'Signing in is optional. It'
                                    // ' is only required for the'
                                    // ' functionalities that use'
                                    // ' cloud services to work such as:',
                                    'Sign-inDescription'.tr,
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Shared Alarm'.tr,
                                    style:
                                    Theme.of(context).textTheme.displaySmall,
                                  ),
                                  Text(
                                    // 'Collaborate with friends, family members,'
                                    // ' or colleagues to ensure that they'
                                    // ' wake up on time using shared alarms.',
                                    'CollabDescription'.tr,
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Syncing Across Devices'.tr,
                                    style:
                                    Theme.of(context).textTheme.displaySmall,
                                  ),
                                  Text(
                                    // 'Access your alarms across multiple devices'
                                    // ' where the alarms are updated in'
                                    // ' real-time.',
                                    'AccessMultiple'.tr,
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Your privacy'.tr,
                                    style:
                                    Theme.of(context).textTheme.displaySmall,
                                  ),
                                  Text(
                                    // 'We do not access,  use or sell any'
                                    // ' information, which you can verify by'
                                    // ' inspecting the source code.',
                                    'NoAccessInfo'.tr,
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    // 'All access is limited exclusively to'
                                    // ' provide the functionalities described'
                                    // ' above.',
                                    'LimitedAccess'.tr,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: width,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      kprimaryColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Utils.hapticFeedback();
                                    Get.back();
                                  },
                                  child: Text(
                                    'Understood'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          color: themeController
                                                      .secondaryTextColor.value,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  },
                  icon: Icon(
                    Icons.info_sharp,
                    size: 21,
                    color: themeController.primaryTextColor.value.withOpacity(0.3),
                  ),
                ),
              ),
              Obx(
                () => Icon(
                  (controller.isUserLoggedIn.value)
                      ? Icons.close
                      : Icons.arrow_forward_ios_sharp,
                  color:
                      themeController.primaryTextColor.value.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
