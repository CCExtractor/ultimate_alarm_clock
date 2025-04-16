import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class StopwatchOverlayPop extends StatelessWidget {
  const StopwatchOverlayPop({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: width * 0.95,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeController.secondaryBackgroundColor.value,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      await FlutterOverlayWindow.closeOverlay();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                    color: themeController.primaryTextColor.value
                        .withOpacity(0.75),
                    iconSize: 27,
                  ),
                  const Text(
                    'UAC Stopwatch',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Added this below icon just to shift text in center
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                    color: Colors.transparent,
                    iconSize: 27,
                  ),
                ],
              ),
              StreamBuilder(
                stream: FlutterOverlayWindow.overlayListener,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasData) {
                    String timer = '00:00:00';
                    if (snapshot.hasData) timer = snapshot.data;
                    return Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  timer.split(':')[0],
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const Center(
                              child: Text(
                                ':',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  timer.split(':')[1],
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const Center(
                              child: Text(
                                ':',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  timer.split(':')[2],
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Some error occurred. Please try again.',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> requestPermission() async {
  bool isPermissionGranted = await FlutterOverlayWindow.isPermissionGranted();
  if (!isPermissionGranted) {
    isPermissionGranted =
        await FlutterOverlayWindow.requestPermission() ?? false;
  }
  return isPermissionGranted;
}
