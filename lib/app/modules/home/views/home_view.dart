// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/views/google_calender_dialog.dart';
import 'package:ultimate_alarm_clock/app/modules/home/views/profile_config.dart';
import 'package:ultimate_alarm_clock/app/modules/home/views/toggle_button.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/end_drawer.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/home_controller.dart';
import 'notification_icon.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  ThemeController themeController = Get.find<ThemeController>();
  SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => Visibility(
            visible: controller.inMultipleSelectMode.value ? false : true,
            child: Container(
              height: width * 0.13,
              width: width * 0.13,
              child: FloatingActionButton(
                onPressed: () {
                  Utils.hapticFeedback();
                  controller.isProfile.value = false;
                  Get.toNamed(
                    '/add-update-alarm',
                    arguments: controller.genFakeAlarmModel(),
                  );
                },
                child: Container(
                    child: Icon(
                  Icons.add,
                  size: controller.scalingFactor.value * 30,
                )),
              ),
            )),
      ),
      endDrawer: buildEndDrawer(context),
      appBar: null,
      body: SafeArea(
        child: Obx(
          () => NestedScrollView(
            controller: controller.scrollController,
            // If the user is not in the multiple select mode
            headerSliverBuilder: controller.inMultipleSelectMode.value == false
                ? (context, innerBoxIsScrolled) => [
                      // Show the normal app bar
                      SliverAppBar(
                        actions: [Container()],
                        automaticallyImplyLeading: false,
                        expandedHeight: height / 7.9,
                        floating: true,
                        pinned: true,
                        snap: false,
                        centerTitle: true,
                        flexibleSpace: LayoutBuilder(
                          builder: (context, constraints) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center everything vertically
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 25 *
                                              controller.scalingFactor.value,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Next alarm'.tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                    color: themeController.primaryDisabledTextColor.value,
                                                    fontSize: 16 *
                                                        controller.scalingFactor
                                                            .value,
                                                  ),
                                            ),
                                            Obx(
                                              () => Text(
                                                controller.alarmTime.value.tr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                      color: themeController.primaryTextColor.value
                                                              .withOpacity(
                                                              0.75,
                                                            ),
                                                      fontSize: 14 *
                                                          controller
                                                              .scalingFactor
                                                              .value,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          notificationIcon(controller),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () async {
                                                controller.isCalender.value =
                                                    true;
                                                Get.dialog(
                                                  await googleCalenderDialog(
                                                    controller,
                                                    themeController,
                                                    context,
                                                  ),
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/GC.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  kprimaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                                height: 30 *
                                                    controller
                                                        .scalingFactor.value,
                                                width: 30 *
                                                    controller
                                                        .scalingFactor.value,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => Visibility(
                                              visible:
                                                  controller.scalingFactor < 0.9
                                                      ? false
                                                      : true,
                                              child: IconButton(
                                                onPressed: () {
                                                  Utils.hapticFeedback();
                                                  Scaffold.of(context)
                                                      .openEndDrawer();
                                                },
                                                icon: const Icon(
                                                  Icons.menu,
                                                ),
                                                color: themeController.primaryTextColor.value
                                                        .withOpacity(0.75),
                                                iconSize: 27 *
                                                    controller.scalingFactor.value,
                                              ),

                                              //   PopupMenuButton(
                                              //     // onPressed: () {
                                              //     //   Utils.hapticFeedback();
                                              //     //   Get.toNamed('/settings');
                                              //     // },

                                              //     icon: const Icon(Icons.more_vert),
                                              //     color: themeController
                                              //             .isLightMode.value
                                              //         ? kLightSecondaryBackgroundColor
                                              //         : ksecondaryBackgroundColor,
                                              //     iconSize: 27 *
                                              //         controller.scalingFactor.value,
                                              //     itemBuilder: (context) {
                                              //       return [
                                              //         PopupMenuItem<String>(
                                              //           onTap: () {
                                              //             Utils.hapticFeedback();
                                              //             Get.toNamed('/settings');
                                              //           },
                                              //           child: Text(
                                              //             'Settings',
                                              //             style: Theme.of(context)
                                              //                 .textTheme
                                              //                 .bodyMedium!
                                              //                 .copyWith(
                                              //                     color: themeController
                                              //                             .isLightMode
                                              //                             .value
                                              //                         ? kLightPrimaryTextColor
                                              //                         : kprimaryTextColor),
                                              //           ),
                                              //         ),
                                              //         PopupMenuItem<String>(
                                              //           value: 'option1',
                                              //           child: Text(
                                              //             'About',
                                              //             style: Theme.of(context)
                                              //                 .textTheme
                                              //                 .bodyMedium!
                                              //                 .copyWith(
                                              //                     color: themeController
                                              //                             .isLightMode
                                              //                             .value
                                              //                         ? kLightPrimaryTextColor
                                              //                         : kprimaryTextColor),
                                              //           ),
                                              //         ),
                                              //       ];
                                              //     },
                                              //   ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                : (context, innerBoxIsScrolled) => [
                      // Else show the multiple select mode app bar
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        actions: [Container()],
                        expandedHeight: height / 7.9,
                        floating: true,
                        pinned: true,
                        snap: false,
                        centerTitle: true,
                        flexibleSpace: LayoutBuilder(
                          builder: (context, constraints) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center everything vertically
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // On pressing the close button, we're closing the multiple select mode, and clearing the select alarm set
                                              controller.inMultipleSelectMode
                                                  .value = false;
                                              controller.isAnyAlarmHolded
                                                  .value = false;
                                              controller.isAllAlarmsSelected
                                                  .value = false;
                                              controller.numberOfAlarmsSelected
                                                  .value = 0;
                                              controller.selectedAlarmSet
                                                  .clear();
                                            },
                                            icon: const Icon(Icons.close),
                                            color: themeController.primaryTextColor.value
                                                    .withOpacity(0.75),
                                            iconSize: 27 *
                                                controller.scalingFactor.value,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2 *
                                                  controller
                                                      .scalingFactor.value,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Select alarms to delete'.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                        color: themeController.primaryDisabledTextColor.value,
                                                        fontSize: 16 *
                                                            controller
                                                                .scalingFactor
                                                                .value,
                                                      ),
                                                ),
                                                Container(
                                                  height: 35,
                                                  width: MediaQuery.of(context).size.width / 1.2,
                                                  child: Row(
                                                    children: [
                                                      Obx(() {
                                                        // Storing the number of selected alarms
                                                        int numberOfAlarmsSelected =
                                                            controller
                                                                .numberOfAlarmsSelected
                                                                .value;
                                                        return Text(
                                                          numberOfAlarmsSelected ==
                                                                  0
                                                              ? 'No alarm selected'
                                                                  .tr
                                                              : '@noofAlarm alarms selected'
                                                                  .trParams({
                                                                  'noofAlarm':
                                                                      numberOfAlarmsSelected
                                                                          .toString(),
                                                                }),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                    color: themeController.primaryTextColor.value
                                                                            .withOpacity(
                                                                            0.75,
                                                                          ),
                                                                    fontSize: 14 *
                                                                        controller
                                                                            .scalingFactor
                                                                            .value,
                                                                  ),
                                                        );
                                                      }),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          // All alarm select button
                                                          ToggleButton(
                                                            controller:
                                                                controller,
                                                            isSelected: controller
                                                                .isAllAlarmsSelected,
                                                          ),

                                                          // Delete button
                                                          SizedBox(
                                                            width: 30 * controller.scalingFactor.value,
                                                          ),
                                                          Obx(
                                                            () => InkWell(
                                                              onTap: () async {
                                                                if (controller.numberOfAlarmsSelected.value > 0) {
                                                                  
                                                                  bool confirm = await Get.defaultDialog(
                                                                    title: 'Confirmation'.tr,
                                                                    titleStyle: Theme.of(context).textTheme.displaySmall,
                                                                    backgroundColor: themeController.secondaryBackgroundColor.value,
                                                                    content: Column(
                                                                      children: [
                                                                        Text(
                                                                          'Delete ${controller.numberOfAlarmsSelected.value} selected alarms?'.tr,
                                                                          style: Theme.of(context).textTheme.bodyMedium,
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top: 20),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              TextButton(
                                                                                onPressed: () => Get.back(result: false),
                                                                                style: ButtonStyle(
                                                                                  backgroundColor: MaterialStateProperty.all(
                                                                                    kprimaryTextColor.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                child: Text(
                                                                                  'Cancel'.tr,
                                                                                  style: Theme.of(context).textTheme.displaySmall!,
                                                                                ),
                                                                              ),
                                                                              TextButton(
                                                                                onPressed: () => Get.back(result: true),
                                                                                style: ButtonStyle(
                                                                                  backgroundColor: MaterialStateProperty.all(kprimaryColor),
                                                                                ),
                                                                                child: Text(
                                                                                  'Delete'.tr,
                                                                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                                                                    color: kprimaryBackgroundColor,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );

                                                                  if (confirm == true) {
                                                                    
                                                                    await controller.deleteAlarms();

                                                                    // Closing the multiple select mode
                                                                    controller.inMultipleSelectMode.value = false;
                                                                    controller.isAnyAlarmHolded.value = false;
                                                                    controller.isAllAlarmsSelected.value = false;
                                                                    controller.numberOfAlarmsSelected.value = 0;
                                                                    controller.selectedAlarmSet.clear();
                                                                    
                                                                    
                                                                    controller.refreshTimer = true;
                                                                    controller.refreshUpcomingAlarms();
                                                                  }
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                color: controller.numberOfAlarmsSelected.value > 0
                                                                    ? Colors.red
                                                                    : themeController.primaryTextColor.value.withOpacity(0.75),
                                                                size: 27 * controller.scalingFactor.value,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],

            body: RefreshIndicator(
              onRefresh: () async {
                refresh(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: controller.scalingFactor * 20),
                    child: const ProfileSelect(),
                  ),
                  Expanded(
                    child: GlowingOverscrollIndicator(
                      color: themeController.primaryDisabledTextColor.value,
                      axisDirection: AxisDirection.down,
                      child: Obx(() {
                        return FutureBuilder(
                          future: (() {
                            print('🏠 HomeView: User signed in: ${controller.isUserSignedIn.value}');
                            print('🏠 HomeView: User model: ${controller.userModel.value?.email ?? 'null'}');
                            return controller.initStream(controller.userModel.value);
                          })(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              final Stream streamAlarms = snapshot.data;

                              return StreamBuilder(
                                stream: streamAlarms,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator.adaptive(
                                        backgroundColor: Colors.transparent,
                                        valueColor: AlwaysStoppedAnimation(
                                          kprimaryColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    List<AlarmModel> alarms = snapshot.data;
                                    print('🏠 HomeView: Received ${alarms.length} alarms');
                                    for (int i = 0; i < alarms.length && i < 3; i++) {
                                      print('   - Alarm ${i + 1}: ${alarms[i].alarmTime} (${alarms[i].isSharedAlarmEnabled ? 'Shared' : 'Local'})');
                                    }

                                    alarms = alarms.toList();
                                    controller.refreshTimer = true;
                                    controller.refreshUpcomingAlarms();
                                    if (alarms.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/empty.svg',
                                              height: height * 0.3,
                                              width: width * 0.8,
                                            ),
                                            Text(
                                              'Add an alarm to get started!'.tr,
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                    color: themeController.primaryDisabledTextColor.value,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return ListView.separated(
                                      separatorBuilder: (context, _) {
                                        return SizedBox(
                                          height: height * 0.02,
                                        );
                                      },
                                      itemCount: alarms.length + 1,
                                      itemBuilder: (context, index) {
                                        // Spacing after last card
                                        if (index == alarms.length) {
                                          return SizedBox(
                                            height: height * 0.1,
                                          );
                                        }
                                        final AlarmModel alarm = alarms[index];
                                        final repeatDays =
                                            Utils.getRepeatDays(alarm.days);
                                        // Main card
                                        return alarm.profile ==
                                                controller.selectedProfile.value
                                            ? Dismissible(
                                                onDismissed: (direction) async {
                                                  // pop up confirmation to delete on swipe
                                                  bool userConfirmed =
                                                      await showDeleteAlarmConfirmationPopupOnSwipe(
                                                    context,
                                                  );
                                                  if (userConfirmed) {
                                                    await controller.swipeToDeleteAlarm(
                                                      controller.userModel.value,
                                                      alarm,
                                                    );
                                                  }
                                                  
                                                  Get.offNamedUntil(
                                                    '/bottom-navigation-bar',
                                                    (route) =>
                                                        route.settings.name ==
                                                        '/splash-screen',
                                                  );
                                                },
                                                key: ValueKey(alarms[index]),
                                                background: Container(
                                                  color: Colors.red,
                                                  // Set the background color to red
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: Obx(
                                                  () => GestureDetector(
                                                    onTap: () {
                                                      Utils.hapticFeedback();

                                                      // If multiple select mode is not on, then only you can update the alarm
                                                      if (!controller
                                                          .inMultipleSelectMode
                                                          .value) {
                                                        controller.isProfile
                                                            .value = false;
                                                        Get.toNamed(
                                                          '/add-update-alarm',
                                                          arguments: alarm,
                                                        );
                                                      }
                                                    },
                                                    onLongPress: () {
                                                      // Entering the multiple select mode
                                                      controller
                                                          .inMultipleSelectMode
                                                          .value = true;
                                                      controller
                                                          .isAnyAlarmHolded
                                                          .value = true;

                                                      // Assigning the alarm list pairs to list of alarms and list of isSelected all equal to false initially
                                                      controller
                                                              .alarmListPairs =
                                                          Pair(
                                                        alarms,
                                                        List.generate(
                                                          alarms.length,
                                                          (index) => false.obs,
                                                        ),
                                                      );

                                                Utils.hapticFeedback();
                                              },
                                              onLongPressEnd: (details) {
                                                controller
                                                    .isAnyAlarmHolded
                                                    .value = false;
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 600,
                                                ),
                                                curve: Curves.easeInOut,
                                                margin: EdgeInsets.all(
                                                  controller
                                                      .isAnyAlarmHolded
                                                          .value
                                                      ? 10
                                                      : 0,
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10.0,
                                                    ),
                                                    child: Card(
                                                      color: themeController.secondaryBackgroundColor.value,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          18,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets
                                                                  .only(
                                                            left: 25.0,
                                                            right: controller
                                                                    .inMultipleSelectMode
                                                                    .value
                                                                ? 10.0
                                                                : 0.0,
                                                            top: controller
                                                                    .inMultipleSelectMode
                                                                    .value
                                                                ? Utils.isChallengeEnabled(
                                                                          alarm,
                                                                        ) ||
                                                                        Utils.isAutoDismissalEnabled(
                                                                          alarm,
                                                                        )
                                                                    ? 15.0
                                                                    : 18.0
                                                                : Utils.isChallengeEnabled(
                                                                          alarm,
                                                                        ) ||
                                                                        Utils.isAutoDismissalEnabled(
                                                                          alarm,
                                                                        )
                                                                    ? 8.0
                                                                    : 0.0,
                                                            bottom: controller
                                                                    .inMultipleSelectMode
                                                                    .value
                                                                ? Utils.isChallengeEnabled(
                                                                          alarm,
                                                                        ) ||
                                                                        Utils.isAutoDismissalEnabled(
                                                                          alarm,
                                                                        )
                                                                    ? 15.0
                                                                    : 18.0
                                                                : Utils.isChallengeEnabled(
                                                                          alarm,
                                                                        ) ||
                                                                        Utils.isAutoDismissalEnabled(
                                                                          alarm,
                                                                        )
                                                                    ? 8.0
                                                                    : 0.0,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                flex: 3,
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    IntrinsicHeight(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            repeatDays.replaceAll(
                                                                              'Never'.tr,
                                                                              'One Time'.tr,
                                                                            ),
                                                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: alarm.isEnabled == true
                                                                                      ? kprimaryColor
                                                                                      : themeController.primaryDisabledTextColor.value,
                                                                                ),
                                                                          ),
                                                                          if (alarm.label.isNotEmpty)
                                                                            VerticalDivider(
                                                                              color: alarm.isEnabled == true
                                                                                  ? kprimaryColor
                                                                                  : themeController.primaryDisabledTextColor.value,
                                                                              thickness: 1.4,
                                                                              width: 6,
                                                                              indent: 3.1,
                                                                              endIndent: 3.1,
                                                                            ),
                                                                          Expanded(
                                                                            child: Container(
                                                                              child: Text(
                                                                                alarm.label,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                // Set overflow property here
                                                                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: alarm.isEnabled == true
                                                                                          ? kprimaryColor
                                                                                          : themeController.primaryDisabledTextColor.value,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          (settingsController.is24HrsEnabled.value
                                                                              ? Utils.split24HourFormat(alarm.alarmTime)
                                                                              : Utils.convertTo12HourFormat(
                                                                                  alarm.alarmTime,
                                                                                ))[0],
                                                                          style: Theme.of(
                                                                            context,
                                                                          ).textTheme.displayLarge!.copyWith(
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal: 3.0,
                                                                          ),
                                                                          child: Text(
                                                                            (settingsController.is24HrsEnabled.value
                                                                                ? Utils.split24HourFormat(alarm.alarmTime)
                                                                                : Utils.convertTo12HourFormat(
                                                                                    alarm.alarmTime,
                                                                                  ))[1],
                                                                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                                                                  color: alarm.isEnabled == true
                                                                                      ? themeController.primaryTextColor.value
                                                                                      : themeController.primaryDisabledTextColor.value,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    if (Utils.isChallengeEnabled(
                                                                          alarm,
                                                                        ) ||
                                                                        Utils.isAutoDismissalEnabled(
                                                                          alarm,
                                                                        ) ||
                                                                        alarm.isSharedAlarmEnabled)
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          if (alarm.isSharedAlarmEnabled)
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 3.0,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.share_arrival_time,
                                                                                size: 24,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value.withOpacity(0.5)
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                            ),
                                                                          if (alarm.isLocationEnabled)
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 3.0,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.location_pin,
                                                                                size: 24,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value.withOpacity(0.5)
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                            ),
                                                                          if (alarm.isActivityEnabled)
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 3.0,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.screen_lock_portrait,
                                                                                size: 24,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value.withOpacity(0.5)
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                            ),
                                                                          if (alarm.isWeatherEnabled)
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 3.0,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.cloudy_snowing,
                                                                                size: 24,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value.withOpacity(0.5)
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                            ),
                                                                          if (alarm.isQrEnabled)
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 3.0,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.qr_code_scanner,
                                                                                size: 24,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value.withOpacity(0.5)
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                            ),
                                                                          if (alarm.isShakeEnabled)
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 3.0,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.vibration,
                                                                                size: 24,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value.withOpacity(0.5)
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                            ),
                                                                          if (alarm.isMathsEnabled)
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 3.0,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.calculate,
                                                                                size: 24,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value.withOpacity(0.5)
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                            ),
                                                                          if (alarm.isPedometerEnabled)
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 3.0,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.directions_walk,
                                                                                size: 24,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value.withOpacity(0.5)
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                ),
                                                                child: controller
                                                                        .inMultipleSelectMode
                                                                        .value
                                                                    ? Column(
                                                                        // Showing the toggle button
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            flex: 0,
                                                                            child: ToggleButton(
                                                                              controller: controller,
                                                                              alarmIndex: index,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Column(
                                                                        // Showing the switch and pop up menu button
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            flex: 0,
                                                                            child: Switch.adaptive(
                                                                              activeColor: ksecondaryColor,
                                                                              value: alarm.isEnabled,
                                                                              onChanged: (bool value) async {
                                                                                Utils.hapticFeedback();
                                                                                alarm.isEnabled = value;
                                                                                if (alarm.isSharedAlarmEnabled == true) {
                                                                                  await FirestoreDb.updateAlarm(alarm.ownerId, alarm);
                                                                                } else {
                                                                                  await IsarDb.updateAlarm(alarm);
                                                                                }
                                                                                controller.refreshTimer = true;
                                                                                controller.refreshUpcomingAlarms();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex: 0,
                                                                            child: PopupMenuButton(
                                                                              onSelected: (value) async {
                                                                                Utils.hapticFeedback();
                                                                                if (value == 0) {
                                                                                  Get.toNamed('/alarm-ring', arguments: {
                                                                                    'alarm': alarm,
                                                                                    'preview': true
                                                                                  });
                                                                                } else if (value == 1) {
                                                                                  debugPrint(alarm.isSharedAlarmEnabled.toString());

                                                                                        if (alarm.isSharedAlarmEnabled == true) {
                                                                                          // Cancel the native Android alarm BEFORE deleting from database
                                                                                          try {
                                                                                            await controller.alarmChannel.invokeMethod('cancelAlarmById', {
                                                                                              'alarmID': alarm.firestoreId!,
                                                                                              'isSharedAlarm': true,
                                                                                            });
                                                                                            debugPrint('🗑️ Canceled native shared alarm before deletion: ${alarm.firestoreId}');
                                                                                          } catch (e) {
                                                                                            debugPrint('⚠️ Error canceling native shared alarm: $e');
                                                                                          }
                                                                                          
                                                                                          await FirestoreDb.deleteAlarm(controller.userModel.value, alarm.firestoreId!);
                                                                                        } else {
                                                                                          // Cancel the native Android alarm BEFORE deleting from database
                                                                                          try {
                                                                                            await controller.alarmChannel.invokeMethod('cancelAlarmById', {
                                                                                              'alarmID': alarm.alarmID,
                                                                                              'isSharedAlarm': false,
                                                                                            });
                                                                                            debugPrint('🗑️ Canceled native local alarm before deletion: ${alarm.alarmID}');
                                                                                          } catch (e) {
                                                                                            debugPrint('⚠️ Error canceling native local alarm: $e');
                                                                                          }
                                                                                          
                                                                                          await IsarDb.deleteAlarm(alarm.isarId);
                                                                                        }

                                                                                        if (Get.isSnackbarOpen) {
                                                                                          Get.closeAllSnackbars();
                                                                                        }

                                                                                        Get.snackbar(
                                                                                          'Alarm deleted',
                                                                                          'The alarm has been deleted.',
                                                                                          duration: Duration(seconds: controller.duration.toInt()),
                                                                                          snackPosition: SnackPosition.BOTTOM,
                                                                                          margin: const EdgeInsets.symmetric(
                                                                                            horizontal: 10,
                                                                                            vertical: 15,
                                                                                          ),
                                                                                          mainButton: TextButton(
                                                                                            onPressed: () async {
                                                                                              if (alarm.isSharedAlarmEnabled == true) {
                                                                                                await FirestoreDb.addAlarm(controller.userModel.value, alarm);
                                                                                              } else {
                                                                                                await IsarDb.addAlarm(alarm);
                                                                                              }
                                                                                            },
                                                                                            child: const Text('Undo'),
                                                                                          ),
                                                                                        );

                                                                                        String ringtoneName = alarm.ringtoneName;

                                                                                        await AudioUtils.updateRingtoneCounterOfUsage(
                                                                                          customRingtoneName: ringtoneName,
                                                                                          counterUpdate: CounterUpdate.decrement,
                                                                                        );

                                                                                  controller.refreshTimer = true;
                                                                                  controller.refreshUpcomingAlarms();
                                                                                }
                                                                              },
                                                                              color: themeController.primaryBackgroundColor.value,
                                                                              icon: Icon(
                                                                                Icons.more_vert,
                                                                                color: alarm.isEnabled == true
                                                                                    ? themeController.primaryTextColor.value
                                                                                    : themeController.primaryDisabledTextColor.value,
                                                                              ),
                                                                              itemBuilder: (context) {
                                                                                return [
                                                                                  PopupMenuItem<int>(
                                                                                    value: 0,
                                                                                    child: Text(
                                                                                      'Preview Alarm'.tr,
                                                                                      style: Theme.of(context).textTheme.bodyMedium,
                                                                                    ),
                                                                                  ),
                                                                                  if (alarm.isSharedAlarmEnabled == false || (alarm.isSharedAlarmEnabled == true && alarm.ownerId == controller.userModel.value!.id))
                                                                                    PopupMenuItem<int>(
                                                                                      value: 1,
                                                                                      child: Text(
                                                                                        'Delete Alarm'.tr,
                                                                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                              color: Colors.red,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                ];
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox();
                                      },
                                    );
                                  }
                                },
                              );
                            } else {
                              return const CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation(
                                  kprimaryColor,
                                ),
                              );
                            }
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showDeleteAlarmConfirmationPopupOnSwipe(
    BuildContext context,
  ) async {
    // Return true if user confirms deletion, false if canceled

    var result = await Get.defaultDialog(
      titlePadding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      backgroundColor: themeController.secondaryBackgroundColor.value,
      title: 'Confirmation'.tr,
      titleStyle: Theme.of(context).textTheme.displaySmall,
      content: Column(
        children: [
          Text(
            'want to delete?'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      kprimaryTextColor.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    'Cancel'.tr,
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back(result: true); // User confirmed
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kprimaryColor),
                  ),
                  child: Text(
                    'delete'.tr,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: kprimaryBackgroundColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return result ??
        false; // Default to false if the user dismisses the dialog without tapping any button
  }

  void refresh(BuildContext context) async {
    controller.refresh();
    await Future.delayed(const Duration(seconds: 3));
  }
}
