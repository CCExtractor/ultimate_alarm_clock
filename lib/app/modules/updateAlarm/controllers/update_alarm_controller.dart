import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:latlong2/latlong.dart';

import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class UpdateAlarmController extends GetxController with AlarmHandlerSetupModel {
  var homeController = Get.find<HomeController>();

  final MapController mapController = MapController();
  final daysRepeating = "Never".obs;

// AlarmModel is being passed as parameter
  AlarmModel _alarmRecord = Get.arguments;

  // Reinitialize these in onInit()
  final selectedTime = DateTime.now().obs;
  final isActivityenabled = false.obs;
  final isLocationEnabled = false.obs;
  final isSharedAlarmEnabled = false.obs;
  final timeToAlarm = ''.obs;

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

  updateAlarm(AlarmModel alarmData) async {
    // Adding the ID's so it can update depending on the db
    if (isSharedAlarmEnabled.value == true) {
      alarmData.firestoreId = _alarmRecord.firestoreId;
      await FirestoreDb.updateAlarm(alarmData);
    } else {
      alarmData.isarId = _alarmRecord.isarId;
      await IsarDb.updateAlarm(alarmData);
    }

    AlarmModel isarLatestAlarm = await IsarDb.getLatestAlarm(_alarmRecord);
    AlarmModel firestoreLatestAlarm =
        await FirestoreDb.getLatestAlarm(_alarmRecord);
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

// Reinitializing all values here
    selectedTime.value = Utils.timeOfDayToDateTime(
        Utils.stringToTimeOfDay(_alarmRecord.alarmTime));
    // Shows the "Rings in" time
    timeToAlarm.value = Utils.timeUntilAlarm(
        TimeOfDay.fromDateTime(selectedTime.value), repeatDays);

    repeatDays.value = _alarmRecord.days;
    // Shows the selected days in UI
    daysRepeating.value = Utils.getRepeatDays(repeatDays);

    isActivityenabled.value = _alarmRecord.isActivityEnabled;
    isLocationEnabled.value = _alarmRecord.isLocationEnabled;
    isSharedAlarmEnabled.value = _alarmRecord.isSharedAlarmEnabled;
    selectedPoint.value = Utils.stringToLatLng(_alarmRecord.location);
    // Shows the marker in UI
    markersList.add(Marker(
      point: selectedPoint.value,
      builder: (ctx) => const Icon(
        Icons.location_on,
        size: 35,
      ),
    ));

    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        registerReceivePort(newReceivePort, _alarmRecord);
      }
    });

// This section contains all the UI updates for various options
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
