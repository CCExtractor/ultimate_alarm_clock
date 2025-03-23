import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/citySelection/views/city_selection_view.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/worldClockPage/views/my_clocks_view.dart';
import 'package:ultimate_alarm_clock/app/modules/worldClockPage/controllers/world_clock_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class WorldClockView extends StatelessWidget  {
  final WorldClockController controller = Get.put(WorldClockController());

 @override
  Widget build(BuildContext context) {
   ThemeController themeController = Get.find<ThemeController>();
   return Scaffold(
      backgroundColor: const Color(0xFF16171C),

      body: Container(
        color: const Color(0xFF16171C),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Clock',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Utils.hapticFeedback();
                        Scaffold.of(context).openEndDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                      ),
                      color: themeController.primaryTextColor.value
                          .withOpacity(0.75),
                      iconSize: 27,
                      // splashRadius: 0.000001,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30,),

              Obx(() =>
                Column(
                  children: [
                    Text(controller.formattedTime.value, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    Text(controller.formattedDateNDay.value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 30,),

              const Text('Long Press the custom clock to Delete it!',
                style: TextStyle(
                  color: Color(0xffAFFC41),
                ),
              ),

              const SizedBox(height: 1,),

              Expanded(
                child: Obx(() => controller.selectedTimeZones.isEmpty
                  ? const Expanded(
                    child: Column(
                      children: [
                        const Icon(Icons.search_rounded, size: 400, color: Color(0xff71A7D9FF),),
                        Text('No Clocks',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  )

                  : Expanded(
                    child: ListView.builder(
                      itemCount: controller.selectedTimeZones.length,
                      itemBuilder: (context, index) {
                        // return MyClocksView(selectedTimeZones: controller.selectedTimeZones[index]);
                        return MyClocksView(clockDetails: controller.selectedTimeZones[index],);
                      },
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CitySelectionView()), );

          if(result != null) {
            controller.addCity(result);
            // print("City added: $result");
          }
        },
        backgroundColor: Color(0xff6FBC00),
        child: const Icon(Icons.add, color: Colors.black, size: 35,),
      ),
    );
  }
}







// CODE TO DISPLAY AN ANALOG WATCH
// class ClockPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;
//
//     final circlePaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;
//
//     final handPaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 4
//       ..strokeCap = StrokeCap.round;
//
//     final secondHandPaint = Paint()
//       ..color = Colors.red
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round;
//
//     canvas.drawCircle(center, radius, circlePaint); // Clock face
//
//     final now = DateTime.now();
//     final hourAngle = (now.hour % 12) * 30 + (now.minute / 60) * 30;
//     final minuteAngle = now.minute * 6;
//     final secondAngle = now.second * 6;
//
//     _drawHand(canvas, center, radius * 0.5, hourAngle, handPaint);
//     _drawHand(canvas, center, radius * 0.7, minuteAngle.toDouble(), handPaint);
//     _drawHand(canvas, center, radius * 0.9, secondAngle.toDouble(), secondHandPaint);
//   }
//
//   void _drawHand(Canvas canvas, Offset center, double length, double angle, Paint paint) {
//     final angleRad = (angle - 90) * pi / 180;
//     final handEnd = Offset(
//       center.dx + length * cos(angleRad),
//       center.dy + length * sin(angleRad),
//     );
//     canvas.drawLine(center, handEnd, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }