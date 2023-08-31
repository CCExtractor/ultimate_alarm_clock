import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class GoogleSignIn extends StatelessWidget {
  GoogleSignIn({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
  });

  final SettingsController controller;

  final double width;
  final double height;

  final HapticFeebackService _hapticFeebackService = Get.find();

  void _hapticFeedback() {
    _hapticFeebackService.hapticFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        _hapticFeedback();
        if (controller.isUserLoggedIn.value == false) {
          bool? isSuccessfulLogin = await controller.loginWithGoogle();

          if (isSuccessfulLogin != null) {
            Get.defaultDialog(
                titlePadding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: ksecondaryBackgroundColor,
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
                            backgroundColor:
                                MaterialStateProperty.all(kprimaryColor)),
                        child: Text(
                          'Okay',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: ksecondaryTextColor),
                        ),
                        onPressed: () {
                          _hapticFeedback();
                          Get.back();
                        }),
                  ],
                ));
          }
        } else {
          Get.defaultDialog(
              contentPadding: const EdgeInsets.all(10.0),
              titlePadding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: ksecondaryBackgroundColor,
              title: 'Are you sure?',
              titleStyle: Theme.of(context).textTheme.displaySmall,
              content: Column(
                children: [
                  const Text("Do you want to unlink your Google account?"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(kprimaryColor)),
                          child: Text(
                            'Unlink',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: ksecondaryTextColor),
                          ),
                          onPressed: () async {
                            _hapticFeedback();
                            await controller.logoutGoogle();
                            Get.back();
                          },
                        ),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  kprimaryTextColor.withOpacity(0.5))),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: kprimaryTextColor),
                          ),
                          onPressed: () {
                            _hapticFeedback();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ));
        }
      },
      child: Container(
        width: width * 0.91,
        height: height * 0.1,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: ksecondaryBackgroundColor),
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
                        color: kprimaryTextColor,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            Obx(
              () => Icon(
                (controller.isUserLoggedIn.value)
                    ? Icons.close
                    : Icons.arrow_forward_ios_sharp,
                color: kprimaryTextColor.withOpacity(0.2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
