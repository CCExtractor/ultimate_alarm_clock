import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/worldClockPage/controllers/my_clocks_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/selected_cities.dart';

class MyClocksView extends StatelessWidget {
  final Map<String, String> clockDetails;
  MyClocksView({Key? key, required this.clockDetails}) : super(key: key);

  final MyClocksController controller = Get.put(MyClocksController());

  @override
  Widget build(BuildContext context) {
    controller.updateTime(clockDetails['timezone']!);

    return Obx(() => Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2, left: 10, right: 10),
      child:  Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.transparent),
          color: const Color(0xffAFFC41),
          borderRadius: BorderRadius.circular(30),
        ),
        child: GestureDetector(
          onDoubleTap: () {
            selectedCities.removeWhere((city) => city['city'] == clockDetails['city']);
            // selectedCities.refresh();
          },
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text('${controller.formattedTime.value} | '),
                  Text(clockDetails['city']!),
                ],
              ),
            ),
            titleTextStyle: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
            subtitleTextStyle: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 10.0),
              child: Text(
                '${controller.formattedDate.value} ${controller.formattedDay.value} | ${clockDetails['timezone']!}',
              ),
            ),
          ),
        ),
      ),
    ),);
  }
}
