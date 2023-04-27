import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:latlong2/latlong.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_model.dart';

import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AlarmHandlerModel());
}

class AddAlarmController extends GetxController {
  var homeController = Get.find<HomeController>();
  final selectedTime = DateTime.now().obs;
  final isActivityenabled = false.obs;
  final isLocationEnabled = false.obs;
  final timeToAlarm = ''.obs;
  late SendPort _sendPort;
  late AlarmModel _alarmRecord;
  ReceivePort? _receivePort;
  final MapController mapController = MapController();
  final selectedPoint = LatLng(0, 0).obs;
  final List<Marker> markersList = [];
  final repeatDays =
      <bool>[false, false, false, false, false, false, false].obs;
  Future<void> getLocation() async {
    if (await _checkAndRequestPermission()) {
      final timeLimit = const Duration(seconds: 10);
      await FlLocation.getLocation(
              timeLimit: timeLimit, accuracy: LocationAccuracy.best)
          .then((location) {
        selectedPoint.value = LatLng(location.latitude, location.longitude);
      }).onError((error, stackTrace) {
        print('error: ${error.toString()}');
      });
    }
  }

  Future<bool> _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      // Location services are disabled.
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      // Cannot request runtime permission because location permission is denied forever.
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      // Ask the user for location permission.
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) return false;
    }

    // Location permission must always be allowed (LocationPermission.always)
    // to collect location data in the background.
    if (background == true &&
        locationPermission == LocationPermission.whileInUse) return false;

    // Location services has been enabled and permission have been granted.
    return true;
  }

  createAlarm(AlarmModel alarmData) async {
    _alarmRecord = await FirestoreDb.addAlarm(alarmData);
    AlarmModel latestAlarm = await FirestoreDb.getLatestAlarm(_alarmRecord);
    TimeOfDay latestAlarmTimeOfDay =
        Utils.stringToTimeOfDay(latestAlarm.alarmTime);
    int intervaltoAlarm = Utils.getMillisecondsToAlarm(
        DateTime.now(), Utils.timeOfDayToDateTime(latestAlarmTimeOfDay));

    if (await FlutterForegroundTask.isRunningService == false) {
      // Starting service mandatorily!
      createForegroundTask(intervaltoAlarm);
      await startForegroundTask(latestAlarm);
    } else {
      await restartForegroundTask(latestAlarm, intervaltoAlarm);
    }
  }

  restartForegroundTask(AlarmModel alarmRecord, int intervalToAlarm) async {
    await _stopForegroundTask();
    createForegroundTask(intervalToAlarm);
    await startForegroundTask(alarmRecord);
  }

  void createForegroundTask(int intervalForAlarm) {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'ulti_clock',
        channelName: 'Ultimate Alarm Clock',
        channelDescription: 'Ultimate Alarm Clock Channel',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        interval: intervalForAlarm,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> startForegroundTask(AlarmModel alarmRecord) async {
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
          await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        print('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }
    // print('Setting alarm for time: ${alarmRecord.alarmTime}');
    // await FlutterForegroundTask.saveData(
    //     key: 'alarmData', value: AlarmModel.toJson(alarmRecord));

    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'UltiClock is running!',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        // Send port has been initialized, let's send it the alarm details
        _sendPort.send(AlarmModel.toMap(_alarmRecord));
      }
      // print('MAIN RECIEVED $message');

      if (message is String) {
        if (message == 'onNotificationPressed') {
          Get.toNamed('/alarm-control');
        }
      }
    });

    return _receivePort != null;
  }

  T? _ambiguate<T>(T? value) => value;

  @override
  void onInit() async {
    super.onInit();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });

    // Adding to markers list, to display on map (MarkersLayer takes only List<Marker>)
    selectedPoint.listen((point) {
      markersList.clear();
      markersList.add(Marker(
        point: point,
        builder: (ctx) => const Icon(
          Icons.location_on,
          size: 35,
        ),
      ));
    });

    // Updating UI to show time to alarm
    selectedTime.listen((time) {
      timeToAlarm.value = Utils.timeUntilAlarm(TimeOfDay.fromDateTime(time));
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    homeController.refreshTimer = true;
    homeController.onReady();
  }
}
