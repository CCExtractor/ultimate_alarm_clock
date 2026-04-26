// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/profile_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
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

  final scrollKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollToSelected();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                          controller.isProfile.value = true;
                          controller.profileModel.value =
                              (await IsarDb.getProfile(
                                  controller.selectedProfile.value,))!;
                          controller.isProfileUpdate.value = false;
                          Get.toNamed(
                            '/add-update-alarm',arguments: controller.genFakeAlarmModel(),
                          );
                        },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(themeController.secondaryBackgroundColor.value),
                foregroundColor: WidgetStateProperty.all(themeController.primaryColor.value),
                shape: WidgetStateProperty.all(const CircleBorder()),
                ),
              child: Padding(padding: const EdgeInsets.all(2.0),
                child: Icon(
                  Icons.add,
                  color: themeController.primaryColor.value,
                  size: 30 * controller.scalingFactor.value,
                ),
              ),
            ),
            SizedBox(
              width: Get.width * 0.8,
              child: StreamBuilder(
                stream: IsarDb.getProfiles(),
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    final profiles = snapshot.data;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: profiles!
                                  .map((e) => profileCapsule(e))
                                  .toList(),
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            )
          ],
    ));
  }

  Widget profileCapsule(ProfileModel profile) {
    return Padding(
      key: profile.profileName == controller.selectedProfile.value
          ? scrollKey
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          controller.writeProfileName(profile.profileName);
          controller.expandProfile.value = !controller.expandProfile.value;
        },
        child: Obx(() => Container(
              padding: EdgeInsets.symmetric(
                horizontal: 18 * controller.scalingFactor.value,
                vertical: 7 * controller.scalingFactor.value,
              ),
              decoration: BoxDecoration(
                  color: profile.profileName == controller.selectedProfile.value
                      ? kprimaryColor
                      : themeController.secondaryBackgroundColor.value,
                  borderRadius: BorderRadius.circular(30),),
              child: Text(
                profile.profileName,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: profile.profileName == controller.selectedProfile.value
                          ? themeController.secondaryBackgroundColor.value
                          : themeController.primaryDisabledTextColor.value,
                      fontSize: 22 * controller.scalingFactor.value,
                    ),
              ),
            ),),
      ),
    );
  }

  void _scrollToSelected() {
    Future.delayed(1000.milliseconds, () {
      Scrollable.ensureVisible(scrollKey.currentContext!,
          duration: 500.milliseconds,);
    });
  }
}
