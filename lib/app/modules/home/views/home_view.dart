// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/views/toggle_button.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();
  SettingsController settingsController = Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.inMultipleSelectMode.value ? false : true,
          child: Container(
            child: (controller.isUserSignedIn.value)
                ? ExpandableFab(
                    key: controller.floatingButtonKey,
                    initialOpen: false,
                    type: ExpandableFabType.up,
                    childrenOffset: Offset.zero,
                    distance: 70,
                    child: const Icon(Icons.add),
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          controller.floatingButtonKey.currentState!.toggle();
                          Get.defaultDialog(
                            title: 'Join an alarm',
                            titlePadding:
                                const EdgeInsets.fromLTRB(0, 21, 0, 0),
                            backgroundColor: themeController.isLightMode.value
                                ? kLightSecondaryBackgroundColor
                                : ksecondaryBackgroundColor,
                            titleStyle: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: themeController.isLightMode.value
                                      ? kLightPrimaryTextColor
                                      : kprimaryTextColor,
                                ),
                            contentPadding: const EdgeInsets.all(21),
                            content: TextField(
                              controller: controller.alarmIdController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              cursorColor: themeController.isLightMode.value
                                  ? kLightPrimaryTextColor.withOpacity(0.75)
                                  : kprimaryTextColor.withOpacity(0.75),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryTextColor
                                            .withOpacity(0.75)
                                        : kprimaryTextColor.withOpacity(0.75),
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryTextColor
                                            .withOpacity(0.75)
                                        : kprimaryTextColor.withOpacity(0.75),
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryTextColor
                                            .withOpacity(0.75)
                                        : kprimaryTextColor.withOpacity(0.75),
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                hintText: 'Enter Alarm ID',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: themeController.isLightMode.value
                                          ? kLightPrimaryDisabledTextColor
                                          : kprimaryDisabledTextColor,
                                    ),
                              ),
                            ),
                            buttonColor: themeController.isLightMode.value
                                ? kLightSecondaryBackgroundColor
                                : ksecondaryBackgroundColor,
                            confirm: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  kprimaryColor,
                                ),
                              ),
                              child: Text(
                                'Join',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: themeController.isLightMode.value
                                          ? kLightSecondaryTextColor
                                          : ksecondaryTextColor,
                                    ),
                              ),
                              onPressed: () async {
                                Utils.hapticFeedback();
                                var result =
                                    await FirestoreDb.addUserToAlarmSharedUsers(
                                  controller.userModel.value,
                                  controller.alarmIdController.text,
                                );

                                if (result != true) {
                                  Get.defaultDialog(
                                    titlePadding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    backgroundColor:
                                        themeController.isLightMode.value
                                            ? kLightSecondaryBackgroundColor
                                            : ksecondaryBackgroundColor,
                                    title: 'Error!',
                                    titleStyle: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.close,
                                          size: 50,
                                          color: Colors.red,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          child: Text(
                                            result == null
                                                ? 'You cannot join your'
                                                    ' own alarm!'
                                                : 'An alarm with this ID'
                                                    " doesn't exist!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              kprimaryColor,
                                            ),
                                          ),
                                          child: Text(
                                            'Okay',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                  color: themeController
                                                          .isLightMode.value
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
                                } else {
                                  Get.back();
                                }
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.alarm,
                              color: themeController.isLightMode.value
                                  ? kLightSecondaryTextColor
                                  : ksecondaryTextColor,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Join alarm',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: themeController.isLightMode.value
                                        ? kLightSecondaryTextColor
                                        : ksecondaryTextColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          controller.floatingButtonKey.currentState!.toggle();
                          Get.toNamed('/add-update-alarm');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              color: themeController.isLightMode.value
                                  ? kLightSecondaryTextColor
                                  : ksecondaryTextColor,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Create alarm',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: themeController.isLightMode.value
                                        ? kLightSecondaryTextColor
                                        : ksecondaryTextColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ExpandableFab(
                    initialOpen: false,
                    child: const Icon(Icons.add),
                    key: controller.floatingButtonKeyLoggedOut,
                    children: const [],
                    onOpen: () {
                      controller.floatingButtonKeyLoggedOut.currentState!
                          .toggle();
                      Utils.hapticFeedback();
                      Get.toNamed('/add-update-alarm');
                    },
                  ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => NestedScrollView(
            controller: controller.scrollController,
            // If the user is not in the multiple select mode
            headerSliverBuilder: controller.inMultipleSelectMode.value == false
                ? (context, innerBoxIsScrolled) => [
                      // Show the normal app bar
                      SliverAppBar(
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 25 *
                                              controller.scalingFactor.value,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Next alarm',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                    color: themeController
                                                            .isLightMode.value
                                                        ? kLightPrimaryDisabledTextColor
                                                        : kprimaryDisabledTextColor,
                                                    fontSize: 16 *
                                                        controller.scalingFactor
                                                            .value,
                                                  ),
                                            ),
                                            Obx(
                                              () => Text(
                                                controller.alarmTime.value,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                      color: themeController
                                                              .isLightMode.value
                                                          ? kLightPrimaryTextColor
                                                              .withOpacity(
                                                              0.75,
                                                            )
                                                          : kprimaryTextColor
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
                                      Obx(
                                        () => Visibility(
                                          visible:
                                              controller.scalingFactor < 0.95
                                                  ? false
                                                  : true,
                                          child: IconButton(
                                            onPressed: () {
                                              Utils.hapticFeedback();
                                              Get.toNamed('/settings');
                                            },
                                            icon: const Icon(Icons.settings),
                                            color: themeController
                                                    .isLightMode.value
                                                ? kLightPrimaryTextColor
                                                    .withOpacity(0.75)
                                                : kprimaryTextColor
                                                    .withOpacity(0.75),
                                            iconSize: 27 *
                                                controller.scalingFactor.value,
                                          ),
                                        ),
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
                                            color: themeController
                                                    .isLightMode.value
                                                ? kLightPrimaryTextColor
                                                    .withOpacity(0.75)
                                                : kprimaryTextColor
                                                    .withOpacity(0.75),
                                            iconSize: 27 *
                                                controller.scalingFactor.value,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15 *
                                                  controller
                                                      .scalingFactor.value,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Select alarms to delete',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                        color: themeController
                                                                .isLightMode
                                                                .value
                                                            ? kLightPrimaryDisabledTextColor
                                                            : kprimaryDisabledTextColor,
                                                        fontSize: 16 *
                                                            controller
                                                                .scalingFactor
                                                                .value,
                                                      ),
                                                ),
                                                Obx(() {
                                                  // Storing the number of selected alarms
                                                  int numberOfAlarmsSelected =
                                                      controller
                                                          .numberOfAlarmsSelected
                                                          .value;
                                                  return Text(
                                                    numberOfAlarmsSelected == 0
                                                        ? 'No alarm selected'
                                                        : numberOfAlarmsSelected ==
                                                                1
                                                            ? '1 alarm selected'
                                                            : '$numberOfAlarmsSelected alarms selected',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                          color: themeController
                                                                  .isLightMode
                                                                  .value
                                                              ? kLightPrimaryTextColor
                                                                  .withOpacity(
                                                                  0.75,
                                                                )
                                                              : kprimaryTextColor
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
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // All alarm select button
                                          ToggleButton(
                                            controller: controller,
                                            isSelected:
                                                controller.isAllAlarmsSelected,
                                          ),

                                          // Delete button
                                          Obx(
                                            () => IconButton(
                                              onPressed: () async {
                                                // Deleting the alarms
                                                await controller.deleteAlarms();

                                                // Closing the multiple select mode
                                                controller.inMultipleSelectMode
                                                    .value = false;
                                                controller.isAnyAlarmHolded
                                                    .value = false;
                                                controller.isAllAlarmsSelected
                                                    .value = false;
                                                controller
                                                    .numberOfAlarmsSelected
                                                    .value = 0;
                                                controller.selectedAlarmSet
                                                    .clear();
                                                // After deleting alarms, refreshing to schedule latest one
                                                controller.refreshTimer = true;
                                                controller
                                                    .refreshUpcomingAlarms();
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                              ),
                                              color: controller
                                                          .numberOfAlarmsSelected
                                                          .value >
                                                      0
                                                  ? Colors.red
                                                  : themeController
                                                          .isLightMode.value
                                                      ? kLightPrimaryTextColor
                                                          .withOpacity(0.75)
                                                      : kprimaryTextColor
                                                          .withOpacity(0.75),
                                              iconSize: 27 *
                                                  controller
                                                      .scalingFactor.value,
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
            body: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: GlowingOverscrollIndicator(
                    color: themeController.isLightMode.value
                        ? kLightPrimaryDisabledTextColor
                        : kprimaryDisabledTextColor,
                    axisDirection: AxisDirection.down,
                    child: Obx(() {
                      return FutureBuilder(
                        future: controller.isSortedAlarmListEnabled.value
                            ? controller.initStream(controller.userModel.value)
                            : controller.initStream(controller.userModel.value),
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
                                  final List<AlarmModel> alarms = snapshot.data;

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
                                            'Add an alarm to get started!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                  color: themeController
                                                          .isLightMode.value
                                                      ? kLightPrimaryDisabledTextColor
                                                      : kprimaryDisabledTextColor,
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
                                      return Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            Utils.hapticFeedback();

                                            // If multiple select mode is not on, then only you can update the alarm
                                            if (!controller
                                                .inMultipleSelectMode.value) {
                                              Get.toNamed(
                                                '/add-update-alarm',
                                                arguments: alarm,
                                              );
                                            }
                                          },
                                          onLongPress: () {
                                            // Entering the multiple select mode
                                            controller.inMultipleSelectMode
                                                .value = true;
                                            controller.isAnyAlarmHolded.value =
                                                true;

                                            // Assigning the alarm list pairs to list of alarms and list of isSelected all equal to false initially
                                            controller.alarmListPairs = Pair(
                                              alarms,
                                              List.generate(
                                                alarms.length,
                                                (index) => false.obs,
                                              ),
                                            );

                                            Utils.hapticFeedback();
                                          },
                                          onLongPressEnd: (details) {
                                            controller.isAnyAlarmHolded.value =
                                                false;
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 600,
                                            ),
                                            curve: Curves.easeInOut,
                                            margin: EdgeInsets.all(
                                              controller.isAnyAlarmHolded.value
                                                  ? 10
                                                  : 0,
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                ),
                                                child: Card(
                                                  color: themeController
                                                          .isLightMode.value
                                                      ? kLightSecondaryBackgroundColor
                                                      : ksecondaryBackgroundColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      18,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
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
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                IntrinsicHeight(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        repeatDays
                                                                            .replaceAll(
                                                                          'Never',
                                                                          'One Time',
                                                                        ),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: alarm.isEnabled == true
                                                                                  ? kprimaryColor
                                                                                  : themeController.isLightMode.value
                                                                                      ? kLightPrimaryDisabledTextColor
                                                                                      : kprimaryDisabledTextColor,
                                                                            ),
                                                                      ),
                                                                      if (alarm
                                                                          .label
                                                                          .isNotEmpty)
                                                                        VerticalDivider(
                                                                          color: alarm.isEnabled == true
                                                                              ? kprimaryColor
                                                                              : themeController.isLightMode.value
                                                                                  ? kLightPrimaryDisabledTextColor
                                                                                  : kprimaryDisabledTextColor,
                                                                          thickness:
                                                                              1.4,
                                                                          width:
                                                                              6,
                                                                          indent:
                                                                              3.1,
                                                                          endIndent:
                                                                              3.1,
                                                                        ),
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              alarm.label,
                                                                              overflow: TextOverflow.ellipsis, // Set overflow property here
                                                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: alarm.isEnabled == true
                                                                                        ? kprimaryColor
                                                                                        : themeController.isLightMode.value
                                                                                            ? kLightPrimaryDisabledTextColor
                                                                                            : kprimaryDisabledTextColor,
                                                                                  ),
                                                                            ),
                                                                            Text(
                                                                              alarm.quickNote,
                                                                              overflow: TextOverflow.ellipsis, // Set overflow property here
                                                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: alarm.isEnabled == true
                                                                                        ? kprimaryColor
                                                                                        : themeController.isLightMode.value
                                                                                            ? kLightPrimaryDisabledTextColor
                                                                                            : kprimaryDisabledTextColor,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      (settingsController
                                                                              .is24HrsEnabled
                                                                              .value
                                                                          ? Utils.split24HourFormat(alarm
                                                                              .alarmTime)
                                                                          : Utils
                                                                              .convertTo12HourFormat(
                                                                              alarm.alarmTime,
                                                                            ))[0],
                                                                      style: Theme
                                                                              .of(
                                                                        context,
                                                                      )
                                                                          .textTheme
                                                                          .displayLarge!
                                                                          .copyWith(
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor
                                                                                    : kprimaryTextColor
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
                                                                          ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            3.0,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        (settingsController.is24HrsEnabled.value
                                                                            ? Utils.split24HourFormat(alarm.alarmTime)
                                                                            : Utils.convertTo12HourFormat(
                                                                                alarm.alarmTime,
                                                                              ))[1],
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .displayMedium!
                                                                            .copyWith(
                                                                              color: alarm.isEnabled == true
                                                                                  ? themeController.isLightMode.value
                                                                                      ? kLightPrimaryTextColor
                                                                                      : kprimaryTextColor
                                                                                  : themeController.isLightMode.value
                                                                                      ? kLightPrimaryDisabledTextColor
                                                                                      : kprimaryDisabledTextColor,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                if (Utils
                                                                        .isChallengeEnabled(
                                                                      alarm,
                                                                    ) ||
                                                                    Utils
                                                                        .isAutoDismissalEnabled(
                                                                      alarm,
                                                                    ) ||
                                                                    alarm
                                                                        .isSharedAlarmEnabled)
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (alarm
                                                                          .isSharedAlarmEnabled)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                3.0,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.share_arrival_time,
                                                                            size:
                                                                                24,
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor.withOpacity(0.5)
                                                                                    : kprimaryTextColor.withOpacity(0.5)
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
                                                                          ),
                                                                        ),
                                                                      if (alarm
                                                                          .isLocationEnabled)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                3.0,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.location_pin,
                                                                            size:
                                                                                24,
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor.withOpacity(0.5)
                                                                                    : kprimaryTextColor.withOpacity(0.5)
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
                                                                          ),
                                                                        ),
                                                                      if (alarm
                                                                          .isActivityEnabled)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                3.0,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.screen_lock_portrait,
                                                                            size:
                                                                                24,
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor.withOpacity(0.5)
                                                                                    : kprimaryTextColor.withOpacity(0.5)
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
                                                                          ),
                                                                        ),
                                                                      if (alarm
                                                                          .isWeatherEnabled)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                3.0,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.cloudy_snowing,
                                                                            size:
                                                                                24,
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor.withOpacity(0.5)
                                                                                    : kprimaryTextColor.withOpacity(0.5)
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
                                                                          ),
                                                                        ),
                                                                      if (alarm
                                                                          .isQrEnabled)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                3.0,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.qr_code_scanner,
                                                                            size:
                                                                                24,
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor.withOpacity(0.5)
                                                                                    : kprimaryTextColor.withOpacity(0.5)
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
                                                                          ),
                                                                        ),
                                                                      if (alarm
                                                                          .isShakeEnabled)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                3.0,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.vibration,
                                                                            size:
                                                                                24,
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor.withOpacity(0.5)
                                                                                    : kprimaryTextColor.withOpacity(0.5)
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
                                                                          ),
                                                                        ),
                                                                      if (alarm
                                                                          .isMathsEnabled)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                3.0,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.calculate,
                                                                            size:
                                                                                24,
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor.withOpacity(0.5)
                                                                                    : kprimaryTextColor.withOpacity(0.5)
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
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
                                                              horizontal: 10.0,
                                                            ),
                                                            child: controller
                                                                    .inMultipleSelectMode
                                                                    .value
                                                                ? Column(
                                                                    // Showing the toggle button
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 0,
                                                                        child:
                                                                            ToggleButton(
                                                                          controller:
                                                                              controller,
                                                                          alarmIndex:
                                                                              index,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Column(
                                                                    // Showing the switch and pop up menu button
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 0,
                                                                        child: Switch
                                                                            .adaptive(
                                                                          activeColor:
                                                                              ksecondaryColor,
                                                                          value:
                                                                              alarm.isEnabled,
                                                                          onChanged:
                                                                              (bool value) async {
                                                                            Utils.hapticFeedback();
                                                                            alarm.isEnabled =
                                                                                value;

                                                                            if (alarm.isSharedAlarmEnabled ==
                                                                                true) {
                                                                              await FirestoreDb.updateAlarm(alarm.ownerId, alarm);
                                                                            } else {
                                                                              await IsarDb.updateAlarm(alarm);
                                                                            }
                                                                            controller.refreshTimer =
                                                                                true;
                                                                            controller.refreshUpcomingAlarms();
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 0,
                                                                        child:
                                                                            PopupMenuButton(
                                                                          onSelected:
                                                                              (value) async {
                                                                            Utils.hapticFeedback();
                                                                            if (value ==
                                                                                0) {
                                                                              Get.back();
                                                                              Get.offNamed('/alarm-ring', arguments: alarm);
                                                                            } else if (value ==
                                                                                1) {
                                                                              debugPrint(alarm.isSharedAlarmEnabled.toString());

                                                                              if (alarm.isSharedAlarmEnabled == true) {
                                                                                await FirestoreDb.deleteAlarm(controller.userModel.value, alarm.firestoreId!);
                                                                              } else {
                                                                                await IsarDb.deleteAlarm(alarm.isarId);
                                                                              }

                                                                              controller.refreshTimer = true;
                                                                              controller.refreshUpcomingAlarms();
                                                                            }
                                                                          },
                                                                          color: themeController.isLightMode.value
                                                                              ? kLightPrimaryBackgroundColor
                                                                              : kprimaryBackgroundColor,
                                                                          icon:
                                                                              Icon(
                                                                            Icons.more_vert,
                                                                            color: alarm.isEnabled == true
                                                                                ? themeController.isLightMode.value
                                                                                    ? kLightPrimaryTextColor
                                                                                    : kprimaryTextColor
                                                                                : themeController.isLightMode.value
                                                                                    ? kLightPrimaryDisabledTextColor
                                                                                    : kprimaryDisabledTextColor,
                                                                          ),
                                                                          itemBuilder:
                                                                              (context) {
                                                                            return [
                                                                              PopupMenuItem<int>(
                                                                                value: 0,
                                                                                child: Text(
                                                                                  'Preview Alarm',
                                                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                                                ),
                                                                              ),
                                                                              if (alarm.isSharedAlarmEnabled == false || (alarm.isSharedAlarmEnabled == true && alarm.ownerId == controller.userModel.value!.id))
                                                                                PopupMenuItem<int>(
                                                                                  value: 1,
                                                                                  child: Text(
                                                                                    'Delete Alarm',
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
                                      );
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
    );
  }
}
