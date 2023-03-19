import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      backgroundColor: kprimaryBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('add-alarm'),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            child: Expanded(
              child: GlowingOverscrollIndicator(
                color: kprimaryColor,
                axisDirection: AxisDirection.down,
                child: ListView.separated(
                    separatorBuilder: (context, _) {
                      return SizedBox(height: height * 0.02);
                    },
                    itemCount: 3,
                    itemBuilder: (context, _) {
                      return Center(
                        child: Container(
                          width: width * 0.91,
                          height: height * 0.10,
                          decoration: BoxDecoration(
                              color: ksecondaryBackgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18))),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('One Time',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                          Row(
                                            children: [
                                              Text(
                                                "8:03",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3.0),
                                                child: Text(
                                                  "AM",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                  // Flexible(
                                  //   flex: 3,
                                  //   child: Transform.rotate(
                                  //     angle: 30 * math.pi / 180,
                                  //     child: VerticalDivider(
                                  //       color: kprimaryColor,
                                  //       thickness: 3.5,
                                  //     ),
                                  //   ),
                                  // ),
                                  Column(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Switch(
                                            value: true,
                                            onChanged: (bool value) {}),
                                      ),
                                      PopupMenuButton(
                                          color: kprimaryTextColor,
                                          itemBuilder: (context) {
                                            return [
                                              const PopupMenuItem<int>(
                                                value: 0,
                                                child: Text("Preview Alarm"),
                                              ),
                                              const PopupMenuItem<int>(
                                                value: 1,
                                                child: Text("Delete Alarm"),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) {
                                            if (value == 0) {
                                              print(
                                                  "Preview menu is selected.");
                                            } else if (value == 1) {
                                              print("Delete menu is selected.");
                                            }
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
