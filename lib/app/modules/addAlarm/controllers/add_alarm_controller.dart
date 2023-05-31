import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:latlong2/latlong.dart';

import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AddAlarmController extends GetxController with AlarmHandlerSetupModel {
  var homeController = Get.find<HomeController>();
  final selectedTime = DateTime.now().add(Duration(minutes: 1)).obs;
  final isActivityenabled = false.obs;
  final isLocationEnabled = false.obs;
  final isSharedAlarmEnabled = false.obs;
  final timeToAlarm = ''.obs;

  AlarmModel? _alarmRecord;

  final MapController mapController = MapController();
  final selectedPoint = LatLng(0, 0).obs;
  final List<Marker> markersList = [];
  final daysRepeating = "Never".obs;
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
    if (isSharedAlarmEnabled.value == true) {
      _alarmRecord = await FirestoreDb.addAlarm(alarmData);
    } else {
      _alarmRecord = await IsarDb.addAlarm(alarmData);
    }

    AlarmModel isarLatestAlarm = await IsarDb.getLatestAlarm(_alarmRecord!);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_alarmRecord!);
    AlarmModel latestAlarm =
        Utils.getFirstScheduledAlarm(isarLatestAlarm, firestoreLatestAlarm);

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

  T? _ambiguate<T>(T? value) => value;

  @override
  void onInit() async {
    super.onInit();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _alarmRecord = Utils.genFakeAlarmModel();
        registerReceivePort(newReceivePort, _alarmRecord!);
      }
    });

    // Adding to markers list, to display on map (MarkersLayer takes only List<Marker>)
    selectedPoint.listen((point) {
      selectedPoint.value = point;
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
      timeToAlarm.value =
          Utils.timeUntilAlarm(TimeOfDay.fromDateTime(time), repeatDays);
    });

    //Updating UI to show repeated days
    repeatDays.listen((days) {
      daysRepeating.value = Utils.getRepeatDays(days);
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
    homeController.refreshUpcomingAlarms();
  }
}
