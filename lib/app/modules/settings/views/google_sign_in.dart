import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class GoogleSignIn extends StatelessWidget {
  const GoogleSignIn({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
  });

  final SettingsController controller;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (controller.isUserLoggedIn.value == false) {
          bool isSuccessfulLogin = await controller.loginWithGoogle();
          Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 20),
              backgroundColor: ksecondaryBackgroundColor,
              title: isSuccessfulLogin ? 'Sucess!' : 'Error!',
              titleStyle: Theme.of(context).textTheme.displaySmall,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    isSuccessfulLogin ? Icons.done : Icons.close,
                    size: 50,
                    color: isSuccessfulLogin ? Colors.green : Colors.red,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      isSuccessfulLogin
                          ? 'Your account is now linked!'
                          : "Your account couldn't be linked!",
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
                        Get.back();
                      }),
                ],
              ));
        } else {
          Get.defaultDialog(
              contentPadding: EdgeInsets.all(10.0),
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
              () => Text(
                (controller.isUserLoggedIn.value)
                    ? 'Unlink Google Account'
                    : 'Sign-In with Google',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: kprimaryTextColor,
                    ),
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
