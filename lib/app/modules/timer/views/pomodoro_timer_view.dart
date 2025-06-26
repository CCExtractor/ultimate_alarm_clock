import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/pomodoro_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class PomodoroPage extends StatelessWidget {
  final PomodoroController controller = Get.put(PomodoroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // App Bar with settings button
              AppBar(
                centerTitle: true,
                title: Text(
                  "Pomodoro Timer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: () => _showSettingsSheet(context),
                  ),
                ],
              ),
              
              SizedBox(height: 30),
              // Main Timer Display
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.greenAccent, kprimaryColor.withOpacity(0.5)],
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    controller.isBreakTime.value
                                        ? 'Break Time'
                                        : controller.selectedLabel.value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                            SizedBox(width: 10),
                            // Add interval counter
                            Obx(() => controller.isRunning.value ||
                                    controller.currentInterval.value > 0
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      controller.progressText,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : SizedBox())
                          ],
                        ),
                        SizedBox(height: 20),
                        // Timer Display
                        Obx(() => Text(
                              controller.formattedTime,
                              style: TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(height: 30),
                        // Start/Give Up Button
                        Obx(() => GestureDetector(
                              onTap: () {
                                controller.isRunning.value
                                    ? controller.stopTimer()
                                    : controller.startTimer();
                              },
                              child: Container(
                                width: 180,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: controller.isRunning.value
                                      ? Colors.red.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    controller.isRunning.value
                                        ? "Give Up"
                                        : "Start",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              // Time Selection Panel
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeOption("30:00", 30),
                    _buildTimeOption("45:00", 45),
                    _buildTimeOption("60:00", 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeOption(String time, int minutes) {
    return Obx(() => GestureDetector(
          onTap: () {
            if (!controller.isRunning.value) {
              controller.setWorkTime(minutes);
            }
          },
          child: Container(
            width: 80,
            padding: EdgeInsets.symmetric(vertical: 12),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: controller.selectedWorkTime.value == minutes
                    ? [kprimaryColor, kprimaryColor.withOpacity(0.5)]
                    : [Colors.green.shade700, Colors.green.shade900],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: controller.selectedWorkTime.value == minutes
                  ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ));
  }

  void _showSettingsSheet(BuildContext context) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.settings, color: Colors.green, size: 24),
                  SizedBox(width: 10),
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(children: [
                Icon(Icons.label, color: Colors.amber),
                SizedBox(width: 10),
                Text("Labels",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ]),

              SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.labelOptions.length,
                  itemBuilder: (context, index) {
                    final label = controller.labelOptions[index];
                    return Obx(() => GestureDetector(
                      onTap: label == "Create"
                          ? () => _showAddLabelDialog(context)
                          : () => controller.setLabel(label),
                          
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: controller.selectedLabel.value == label
                                  ? kprimaryColor
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: controller.selectedLabel.value == label
                                  ? [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: controller.selectedLabel.value == label
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ),
              SizedBox(height: 30),

              // Number of Intervals Slider
              Row(
                children: [
                  Icon(Icons.repeat, color: Colors.purple),
                  SizedBox(width: 10),
                  Text("Number of Intervals",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                ],
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Intervals",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Obx(() => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${controller.selectedIntervals.value} intervals",
                                style: TextStyle(
                                  color: Colors.purple.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(() => SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            activeTrackColor: Colors.purple,
                            inactiveTrackColor: Colors.grey.shade300,
                            thumbColor: Colors.white,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                              elevation: 4,
                            ),
                            overlayColor: Colors.purple.withOpacity(0.2),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 16),
                          ),
                          child: Slider(
                            min: 1,
                            max: 10,
                            divisions: 9,
                            value:
                                controller.selectedIntervals.value.toDouble(),
                            onChanged: (value) {
                              if (!controller.isRunning.value) {
                                controller.setIntervals(value.toInt());
                              }
                            },
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                        Text("10",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Work Time Slider
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Work Time",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                ],
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Duration",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Obx(() => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${controller.selectedWorkTime.value} minutes",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(() => SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.grey.shade300,
                            thumbColor: Colors.white,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                              elevation: 4,
                            ),
                            overlayColor: Colors.green.withOpacity(0.2),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 16),
                          ),
                          child: Slider(
                            min: 1,
                            max: 120,
                            divisions: 119,
                            value: controller.selectedWorkTime.value.toDouble(),
                            onChanged: (value) {
                              if (!controller.isRunning.value) {
                                controller.setWorkTime(value.toInt());
                              }
                            },
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1 min",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                        Text("120 min",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Improved Break Time Slider
              Row(
                children: [
                  Icon(Icons.coffee, color: Colors.orange),
                  SizedBox(width: 10),
                  Text("Break Time",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16 , color: Colors.black)),
                ],
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Duration",
                            style: TextStyle(color: Colors.grey.shade600)),
                        Obx(() => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${controller.selectedBreakTime.value} minutes",
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(() => SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            activeTrackColor: Colors.orange,
                            inactiveTrackColor: Colors.grey.shade300,
                            thumbColor: Colors.white,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                              elevation: 4,
                            ),
                            overlayColor: Colors.orange.withOpacity(0.2),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 16),
                          ),
                          child: Slider(
                            min: 1,
                            max: 30,
                            divisions: 29,
                            value:
                                controller.selectedBreakTime.value.toDouble(),
                            onChanged: (value) {
                              controller.setBreakTime(value.toInt());
                            },
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1 min",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                        Text("30 min",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: kprimaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddLabelDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create Custom Label",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.newLabelController,
                decoration: InputDecoration(
                  hintText: "Enter label name",
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey.shade400,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      controller
                          .addCustomLabel(controller.newLabelController.text);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}