import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ultimate_alarm_clock/app/data/models/profile_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

import '../../../utils/constants.dart';
import 'package:android_intent_plus/android_intent.dart';

import '../../../utils/utils.dart';

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
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: child,
          );
        },
        child: !controller.expandProfile.value
            ? InkWell(
                onTap: () async {
                  controller.isProfile.value = true;
                  controller.isProfileUpdate.value = true;
                  Get.toNamed(
                    '/add-update-alarm',
                    arguments: controller.genFakeAlarmModel(),
                  );
                },
                child: Container(
                  key: const ValueKey(1),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 18 * controller.scalingFactor.value,
                        ),
                        child: Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24 * controller.scalingFactor.value,
                              vertical: 4 * controller.scalingFactor.value,
                            ),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 2 / 3),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topCenter,
                                stops: const [0.2, 0.2],
                                colors: [
                                  kprimaryColor,
                                  themeController
                                      .secondaryBackgroundColor.value,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              '${controller.selectedProfile}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: themeController
                                        .primaryTextColor.value
                                        .withOpacity(
                                      0.75,
                                    ),
                                    fontSize:
                                        22 * controller.scalingFactor.value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () {
                            controller.expandProfile.value =
                                !controller.expandProfile.value;
                          },
                          child: Container(
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () async {
                          controller.isProfile.value = true;
                          controller.profileModel.value =
                              (await IsarDb.getProfile(
                            controller.selectedProfile.value,
                          ))!;
                          controller.isProfileUpdate.value = false;
                          Get.toNamed(
                            '/add-update-alarm',
                          );
                        },
                        child: Container(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      child: Container(child: const Icon(Icons.arrow_back_ios)),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.8,
                    key: const ValueKey(2),
                    child: StreamBuilder(
                      stream: IsarDb.getProfiles(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
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
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget profileCapsule(ProfileModel profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          controller.writeProfileName(profile.profileName);
          controller.expandProfile.value = !controller.expandProfile.value;
        },
        child: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24 * controller.scalingFactor.value,
              vertical: 4 * controller.scalingFactor.value,
            ),
            decoration: BoxDecoration(
              color: profile.profileName == controller.selectedProfile.value
                  ? kprimaryColor.withOpacity(0.5)
                  : ksecondaryBackgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              profile.profileName,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: themeController.primaryTextColor.value.withOpacity(
                      0.75,
                    ),
                    fontSize: 22 * controller.scalingFactor.value,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
