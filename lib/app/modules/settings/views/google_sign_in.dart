import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

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
      onTap: () async {
        Utils.hapticFeedback();
        if (controller.isUserLoggedIn.value == false) {
          bool? isSuccessfulLogin = await controller.loginWithGoogle();

          if (isSuccessfulLogin != null) {
            Get.defaultDialog(
              titlePadding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: themeController.isLightMode.value
                  ? kLightSecondaryBackgroundColor
                  : ksecondaryBackgroundColor,
              title: 'Success!',
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
                      'Your account is now linked!',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kprimaryColor),
                    ),
                    child: Text(
                      'Okay',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: themeController.isLightMode.value
                                ? kLightPrimaryTextColor
                                : ksecondaryTextColor,
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
          }
        } else {
          Get.defaultDialog(
            contentPadding: const EdgeInsets.all(10.0),
            titlePadding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: themeController.isLightMode.value
                ? kLightSecondaryBackgroundColor
                : ksecondaryBackgroundColor,
            title: 'Are you sure?',
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Column(
              children: [
                const Text('Do you want to unlink your Google account?'),
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
                        child: Text(
                          'Unlink',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryTextColor
                                    : ksecondaryTextColor,
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
                          'Cancel',
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
          isLightMode: themeController.isLightMode.value,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (controller.isUserLoggedIn.value)
                        ? 'Unlink ${controller.userModel!.email}'
                        : 'Sign-In with Google',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Icon(
                (controller.isUserLoggedIn.value)
                    ? Icons.close
                    : Icons.arrow_forward_ios_sharp,
                color: themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(0.4)
                    : kprimaryTextColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
