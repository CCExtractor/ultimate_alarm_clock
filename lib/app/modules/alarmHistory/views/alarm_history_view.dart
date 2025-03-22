import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmHistory/controllers/alarm_history_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmHistoryView extends GetView<AlarmHistoryController> {

  final AlarmHistoryController controller = Get.find<AlarmHistoryController>();
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Alarm history'.tr,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Obx(
            () => Icon(
              Icons.adaptive.arrow_back,
              color: themeController.primaryTextColor.value,
            ),
          ),
          onPressed: () {
            Utils.hapticFeedback();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Obx(()  => Center(
          child: controller.history.value.isEmpty
          ? Text('History is empty.')
          : Align(
            alignment: Alignment.topCenter,
            child:
             ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.history.value.length,
              itemBuilder: (context, index) {
                final data = controller.history.value[index];

                bool didAlarmRing = data['didAlarmRing'] == 1;
                String? reason = data['reason'];
                String alarmTime = data['alarmTime'];

                if(reason == null){
                  return 
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ExpansionTile(
                          collapsedBackgroundColor: themeController.secondaryBackgroundColor.value,
                          backgroundColor: themeController.secondaryBackgroundColor.value,
                          textColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Alarm Time', style: TextStyle(color: themeController.primaryDisabledTextColor.value, fontWeight: FontWeight.bold),),
                                    Text(alarmTime, style: TextStyle(fontSize: 18),)
                                  ]
                                ),
                                Icon(
                                  didAlarmRing? Icons.check_circle_rounded: Icons.close,
                                  color: didAlarmRing? Colors.green: Colors.red,),
                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25, right: 10, top: 0, bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Alarm Type: ',
                                    style: TextStyle(
                                      color: themeController.primaryDisabledTextColor.value,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Text('Normal Alarm')
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                }
                else if(reason == 'activity'){
                  int activityInterval = data['activityInterval'];
                  return 
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ExpansionTile(
                          collapsedBackgroundColor: themeController.secondaryBackgroundColor.value,
                          backgroundColor: themeController.secondaryBackgroundColor.value,
                          textColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Alarm Time', style: TextStyle(color: themeController.primaryDisabledTextColor.value, fontWeight: FontWeight.bold),),
                                    Text(alarmTime, style: TextStyle(fontSize: 18),)
                                  ]
                                ),
                                Icon(
                                  didAlarmRing? Icons.check_circle_rounded: Icons.close,
                                  color: didAlarmRing? Colors.green: Colors.red,),
                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25, right: 10, top: 0, bottom: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Alarm Type: ',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text('Screen Activity Based Alarm')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Screen Activity Time:',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(activityInterval.toString())
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                }
                else if(reason == 'location'){
                  String location = data['location'];
                  String locationAtAlarmTime = data['locationAtAlarmTime'];
                  int distance = data['distance'];

                  return 
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ExpansionTile(
                          collapsedBackgroundColor: themeController.secondaryBackgroundColor.value,
                          backgroundColor: themeController.secondaryBackgroundColor.value,
                          textColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Alarm Time', style: TextStyle(color: themeController.primaryDisabledTextColor.value, fontWeight: FontWeight.bold),),
                                    Text(alarmTime, style: TextStyle(fontSize: 18),)
                                  ]
                                ),
                                Icon(
                                  didAlarmRing? Icons.check_circle_rounded: Icons.close,
                                  color: didAlarmRing? Colors.green: Colors.red,),
                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25, right: 10, top: 0, bottom: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Alarm Type: ',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text('Location Based Alarm')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Location Set:',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(location)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Location At Alarm Time:',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(locationAtAlarmTime)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Distance:',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(distance.toString())
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                }
                else if (reason == 'weather'){
                  String weatherTypes = data['weatherTypes'];
                  String weatherAtAlarmTime = data['locationAtAlarmTime'];

                  return 
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ExpansionTile(
                          collapsedBackgroundColor: themeController.secondaryBackgroundColor.value,
                          backgroundColor: themeController.secondaryBackgroundColor.value,
                          textColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Alarm Time', style: TextStyle(color: themeController.primaryDisabledTextColor.value, fontWeight: FontWeight.bold),),
                                    Text(alarmTime, style: TextStyle(fontSize: 18),)
                                  ]
                                ),
                                Icon(
                                  didAlarmRing? Icons.check_circle_rounded: Icons.close,
                                  color: didAlarmRing? Colors.green: Colors.red,),
                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25, right: 10, top: 0, bottom: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Alarm Type: ',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text('Weather Based Alarm')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Weather Types:',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(weatherTypes)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Weather At Alarm Time:',
                                        style: TextStyle(
                                          color: themeController.primaryDisabledTextColor.value,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(weatherAtAlarmTime)
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                }
                return Text('Some error occured loading data');
              },
          )
          )
        )
      ),
    );
  }
  
}