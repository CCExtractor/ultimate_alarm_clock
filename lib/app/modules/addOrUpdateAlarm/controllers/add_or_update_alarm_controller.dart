import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:isar/isar.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_handler_setup_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:uuid/uuid.dart';

class AddOrUpdateAlarmController extends GetxController
    with AlarmHandlerSetupModel {
  late UserModel? _userModel;
  var alarmID = Uuid().v4();
  var homeController = Get.find<HomeController>();
  final selectedTime = DateTime.now().add(Duration(minutes: 1)).obs;
  final isActivityenabled = false.obs;
  final activityInterval = 0.obs;
  final isLocationEnabled = false.obs;
  final isSharedAlarmEnabled = false.obs;
  late final isWeatherEnabled = false.obs;
  final weatherApiKeyExists = false.obs;
  final isShakeEnabled = false.obs;
  final timeToAlarm = ''.obs;
  final shakeTimes = 0.obs;
  var ownerId = '';
  var ownerName = '';

  AlarmModel? _alarmRecord;

  var qrController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  final qrValue = "".obs;
  final isQrEnabled = false.obs;

  final mathsSliderValue = 0.0.obs;
  final mathsDifficulty = Difficulty.Easy.obs;
  final isMathsEnabled = false.obs;
  final numMathsQuestions = 1.obs;
  final MapController mapController = MapController();
  final selectedPoint = LatLng(0, 0).obs;
  final List<Marker> markersList = [];
  final daysRepeating = "Never".obs;
  final weatherTypes = "Off".obs;
  final selectedWeather = <WeatherTypes>[].obs;
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
      _alarmRecord = await FirestoreDb.addAlarm(_userModel, alarmData);
    } else {
      _alarmRecord = await IsarDb.addAlarm(alarmData);
    }
  }

  restartQRCodeController() {
    qrController = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  updateAlarm(AlarmModel alarmData) async {
    // Adding the ID's so it can update depending on the db
    if (isSharedAlarmEnabled.value == true) {
      // Making sure the alarm wasn't suddenly updated to be an online (shared) alarm
      if (await IsarDb.doesAlarmExist(_alarmRecord!.alarmID) == false) {
        alarmData.firestoreId = _alarmRecord!.firestoreId;
        await FirestoreDb.updateAlarm(_userModel, alarmData);
      } else {
        // Deleting alarm on IsarDB to ensure no duplicate entry
        await IsarDb.deleteAlarm(_alarmRecord!.isarId);
        createAlarm(alarmData);
      }
    } else {
      // Making sure the alarm wasn't suddenly updated to be an offline alarm
      if (await IsarDb.doesAlarmExist(_alarmRecord!.alarmID) == true) {
        alarmData.isarId = _alarmRecord!.isarId;
        await IsarDb.updateAlarm(alarmData);
      } else {
        // Deleting alarm on firestore to ensure no duplicate entry
        await FirestoreDb.deleteAlarm(_userModel, _alarmRecord!.firestoreId!);
        createAlarm(alarmData);
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();

    _alarmRecord = Get.arguments;

    if (Get.arguments != null) {
      // Reinitializing all values here
      selectedTime.value = Utils.timeOfDayToDateTime(
          Utils.stringToTimeOfDay(_alarmRecord!.alarmTime));
      // Shows the "Rings in" time
      timeToAlarm.value = Utils.timeUntilAlarm(
          TimeOfDay.fromDateTime(selectedTime.value), repeatDays);

      repeatDays.value = _alarmRecord!.days;
      // Shows the selected days in UI
      daysRepeating.value = Utils.getRepeatDays(repeatDays);

      // Setting the old values for all the auto dismissal
      isActivityenabled.value = _alarmRecord!.isActivityEnabled;
      activityInterval.value = _alarmRecord!.activityInterval ~/ 60000;

      isLocationEnabled.value = _alarmRecord!.isLocationEnabled;
      selectedPoint.value = Utils.stringToLatLng(_alarmRecord!.location);
      // Shows the marker in UI
      markersList.add(Marker(
        point: selectedPoint.value,
        builder: (ctx) => const Icon(
          Icons.location_on,
          size: 35,
        ),
      ));

      isWeatherEnabled.value = _alarmRecord!.isWeatherEnabled;
      weatherTypes.value = Utils.getFormattedWeatherTypes(selectedWeather);

      isMathsEnabled.value = _alarmRecord!.isMathsEnabled;
      numMathsQuestions.value = _alarmRecord!.numMathsQuestions;
      mathsDifficulty.value = Difficulty.values[_alarmRecord!.mathsDifficulty];
      mathsSliderValue.value = _alarmRecord!.mathsDifficulty.toDouble();

      isShakeEnabled.value = _alarmRecord!.isShakeEnabled;
      shakeTimes.value = _alarmRecord!.shakeTimes;

      isQrEnabled.value = _alarmRecord!.isQrEnabled;
      qrValue.value = _alarmRecord!.qrValue;

      alarmID = _alarmRecord!.alarmID;
      ownerId = _alarmRecord!.ownerId;
      ownerName = _alarmRecord!.ownerName;

      isSharedAlarmEnabled.value = _alarmRecord!.isSharedAlarmEnabled;
    }

    _userModel = await SecureStorageProvider().retrieveUserModel();

    if (_userModel != null) {
      ownerId = _userModel!.id;
      ownerName = _userModel!.fullName;
    }

    timeToAlarm.value = Utils.timeUntilAlarm(
        TimeOfDay.fromDateTime(selectedTime.value), repeatDays);

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
      print("CHANGED CHANGED CHANGED CHANGED");
      timeToAlarm.value =
          Utils.timeUntilAlarm(TimeOfDay.fromDateTime(time), repeatDays);
    });

    //Updating UI to show repeated days
    repeatDays.listen((days) {
      daysRepeating.value = Utils.getRepeatDays(days);
    });

    // Updating UI to show weather types
    selectedWeather.listen((weather) {
      if (weather.toList().isEmpty) {
        isWeatherEnabled.value = false;
      } else {
        isWeatherEnabled.value = true;
      }
      weatherTypes.value = Utils.getFormattedWeatherTypes(weather);
    });

    if (await SecureStorageProvider().retrieveApiKey(ApiKeys.openWeatherMap) !=
        null) {
      weatherApiKeyExists.value = true;
    }

    // If there's an argument sent, we are in update mode
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
