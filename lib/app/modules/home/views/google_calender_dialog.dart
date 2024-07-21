import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../../utils/constants.dart';

Future<Widget> googleCalenderDialog(
  HomeController controller,
  ThemeController themeController,
  BuildContext context,
) async {
  controller.fetchGoogleCalendars();
  return Obx(() => Dialog(
        backgroundColor: kprimaryBackgroundColor,
        child: SizedBox(
          height: controller.scalingFactor.value * 350,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: controller.calendarFetchStatus == 'Loading'
                ? const SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation(
                          kprimaryColor,
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/GC.svg',
                            colorFilter: const ColorFilter.mode(
                                kprimaryColor, BlendMode.srcIn,),
                            height: 30 * controller.scalingFactor.value,
                            width: 30 * controller.scalingFactor.value,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            child: Text(
                              'Google Calender',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: themeController.isLightMode.value
                                        ? kLightPrimaryDisabledTextColor
                                        : kprimaryDisabledTextColor,
                                    fontSize:
                                        20 * controller.scalingFactor.value,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      controller.isCalender.value
                          ? Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.Calendars.value.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          controller.calendarFetchStatus.value =
                                              'Loading';
                                          controller.fetchEvents(controller
                                              .Calendars.value[index].id,);
                                        },
                                        child: Card(
                                          color: themeController
                                                  .isLightMode.value
                                              ? kLightSecondaryBackgroundColor
                                              : ksecondaryBackgroundColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(16.0),
                                            child: SingleChildScrollView(
                                              scrollDirection:
                                                  Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                    child: Icon(
                                                      Icons.calendar_month,
                                                      color: kprimaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${controller.Calendars.value[index].summary}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall!
                                                        .copyWith(
                                                          color: themeController
                                                                  .isLightMode
                                                                  .value
                                                              ? kLightPrimaryTextColor
                                                              : kprimaryTextColor,
                                                          fontSize: 15 *
                                                              controller
                                                                  .scalingFactor
                                                                  .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.Events.value.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: themeController.isLightMode.value
                                            ? kLightSecondaryBackgroundColor
                                            : ksecondaryBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(width: controller.scalingFactor.value*180,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.all(8.0),
                                                            child: Icon(
                                                              Icons.calendar_month,
                                                              color: kprimaryColor,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${controller.Events.value[index].summary}',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .displaySmall!
                                                                .copyWith(
                                                                  color: themeController
                                                                          .isLightMode
                                                                          .value
                                                                      ? kLightPrimaryTextColor
                                                                      : kprimaryTextColor,
                                                                  fontSize: 15 *
                                                                      controller
                                                                          .scalingFactor
                                                                          .value,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SingleChildScrollView(scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    8.0,),
                                                            child: Icon(
                                                              Icons
                                                                  .watch_later_outlined,
                                                              color: kprimaryColor,
                                                            ),
                                                          ),
                                                          Text(
                                                              '${Utils.formatDateTimeToStandard(controller.Events.value[index].start.dateTime ?? controller.Events.value[index].start.date)}',),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: InkWell(onTap: (){
                                                controller.setAlarmFromEvent(controller.Events.value[index]);
                                              },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                        16,
                                                      ),
                                                      color: kprimaryColor,),

                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Icon(Icons
                                                          .arrow_forward_ios_rounded,),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    );
                                  },),
                            ),
                    ],
                  ),
          ),
        ),
      ),);
}
