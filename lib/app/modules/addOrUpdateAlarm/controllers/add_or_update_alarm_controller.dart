import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:fl_location/fl_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final labelController = TextEditingController();

  late UserModel? userModel;
  var alarmID = Uuid().v4();
  var homeController = Get.find<HomeController>();
  final selectedTime = DateTime.now().add(Duration(minutes: 1)).obs;
  final mainAlarmTime = DateTime.now().add(Duration(minutes: 1)).obs;
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
  final mutexLock = false.obs;
  var lastEditedUserId = '';
  var ownerName = '';
  final sharedUserIds = <String>[].obs;
  AlarmModel? alarmRecord = Get.arguments;
  final RxMap offsetDetails = {}.obs;
  final offsetDuration = 0.obs;
  final isOffsetBefore = true.obs;
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
  final RxBool isOneTime = false.obs;
  final RxString label = "".obs;
  final RxInt snoozeDuration = 1.obs;
  Future<List<UserModel?>> fetchUserDetailsForSharedUsers() async {
    List<UserModel?> userDetails = [];

    for (String userId in alarmRecord?.sharedUserIds ?? []) {
      userDetails.add(await FirestoreDb.fetchUserDetails(userId));
    }

    return userDetails;
  }

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
      bool? shouldAskPermission = await Get.defaultDialog<bool>(
        backgroundColor: ksecondaryBackgroundColor,
        barrierDismissible: false,
        title: 'Location Permission',
        contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        titlePadding: EdgeInsets.only(top:30,right: 40),
        titleStyle: TextStyle(color: Colors.white),
        content: Text('This app needs access to your location.'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kprimaryColor,
            ),
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Get.back(result: false);
            },
          ),
          SizedBox(
            width: 10,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kprimaryColor,
            ),
            child: Text('Allow', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Get.back(result: true);
            },
          ),
        ],
        cancelTextColor: Colors.black,
        confirmTextColor: Colors.black,

      );


      if (shouldAskPermission == false) {
        // User declined the permission request.
        return false;
      }
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
      alarmRecord = await FirestoreDb.addAlarm(userModel, alarmData);
    } else {
      alarmRecord = await IsarDb.addAlarm(alarmData);
    }
  }

  restartQRCodeController() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      Get.defaultDialog(
        backgroundColor: ksecondaryBackgroundColor,
        title: 'Camera Permission',
        titleStyle: TextStyle(color: Colors.white),
        titlePadding: EdgeInsets.only(top: 25,left: 10,),
        contentPadding: EdgeInsets.only(top: 20,left: 20,bottom:23 ),

        content: Text('Please allow camera access to scan QR codes.'),

        onCancel: () {
          Get.back(); // Close the alert box
        },
        onConfirm: () async {
          Get.back(); // Close the alert box
          PermissionStatus permissionStatus = await Permission.camera.request();
          if (permissionStatus.isGranted) {
            // Permission granted, proceed with QR code scanning
            qrController = MobileScannerController(
              autoStart: true,
              detectionSpeed: DetectionSpeed.noDuplicates,
              facing: CameraFacing.back,
              torchEnabled: false,
            );
          }
        },
        cancel: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kprimaryColor,
          ),
          child: Text('Cancel',style: TextStyle(color: Colors.black),),
          onPressed: () {
            Get.back(); // Close the alert box
          },
        ),
        confirm: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kprimaryColor,
          ),
          child: Text('OK',style: TextStyle(color: Colors.black),),
          onPressed: () async {
            Get.back(); // Close the alert box
            PermissionStatus permissionStatus = await Permission.camera.request();
            if (permissionStatus.isGranted) {
              // Permission granted, proceed with QR code scanning
              qrController = MobileScannerController(
                autoStart: true,
                detectionSpeed: DetectionSpeed.noDuplicates,
                facing: CameraFacing.back,
                torchEnabled: false,
              );
            }
          },
        ),
      );

    } else {
      // Camera permission already granted, proceed with QR code scanning
      qrController = MobileScannerController(
        autoStart: true,
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
      );
    }
  }

  updateAlarm(AlarmModel alarmData) async {
    // Adding the ID's so it can update depending on the db
    if (isSharedAlarmEnabled.value == true) {
      // Making sure the alarm wasn't suddenly updated to be an online (shared) alarm
      if (await IsarDb.doesAlarmExist(alarmRecord!.alarmID) == false) {
        alarmData.firestoreId = alarmRecord!.firestoreId;
        await FirestoreDb.updateAlarm(alarmRecord!.ownerId, alarmData);
      } else {
        // Deleting alarm on IsarDB to ensure no duplicate entry
        await IsarDb.deleteAlarm(alarmRecord!.isarId);
        createAlarm(alarmData);
      }
    } else {
      // Making sure the alarm wasn't suddenly updated to be an offline alarm
      if (await IsarDb.doesAlarmExist(alarmRecord!.alarmID) == true) {
        alarmData.isarId = alarmRecord!.isarId;
        await IsarDb.updateAlarm(alarmData);
      } else {
        // Deleting alarm on firestore to ensure no duplicate entry
        await FirestoreDb.deleteAlarm(userModel, alarmRecord!.firestoreId!);
        createAlarm(alarmData);
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();

    userModel = homeController.userModel.value;
    if (userModel != null) {
      ownerId = userModel!.id;
      ownerName = userModel!.fullName;
      lastEditedUserId = userModel!.id;
    }

    if (Get.arguments != null) {
      snoozeDuration.value = alarmRecord!.snoozeDuration;
      isOneTime.value = alarmRecord!.isOneTime;
      label.value = alarmRecord!.label;

      sharedUserIds.value = alarmRecord!.sharedUserIds!;
      // Reinitializing all values here
      selectedTime.value = Utils.timeOfDayToDateTime(
          Utils.stringToTimeOfDay(alarmRecord!.alarmTime));
      // Shows the "Rings in" time
      timeToAlarm.value = Utils.timeUntilAlarm(
          TimeOfDay.fromDateTime(selectedTime.value), repeatDays);

      repeatDays.value = alarmRecord!.days;
      // Shows the selected days in UI
      daysRepeating.value = Utils.getRepeatDays(repeatDays);

      // Setting the old values for all the auto dismissal
      isActivityenabled.value = alarmRecord!.isActivityEnabled;
      activityInterval.value = alarmRecord!.activityInterval ~/ 60000;

      isLocationEnabled.value = alarmRecord!.isLocationEnabled;
      selectedPoint.value = Utils.stringToLatLng(alarmRecord!.location);
      // Shows the marker in UI
      markersList.add(Marker(
        point: selectedPoint.value,
        builder: (ctx) => const Icon(
          Icons.location_on,
          size: 35,
        ),
      ));

      isWeatherEnabled.value = alarmRecord!.isWeatherEnabled;
      weatherTypes.value = Utils.getFormattedWeatherTypes(selectedWeather);

      isMathsEnabled.value = alarmRecord!.isMathsEnabled;
      numMathsQuestions.value = alarmRecord!.numMathsQuestions;
      mathsDifficulty.value = Difficulty.values[alarmRecord!.mathsDifficulty];
      mathsSliderValue.value = alarmRecord!.mathsDifficulty.toDouble();

      isShakeEnabled.value = alarmRecord!.isShakeEnabled;
      shakeTimes.value = alarmRecord!.shakeTimes;

      isQrEnabled.value = alarmRecord!.isQrEnabled;
      qrValue.value = alarmRecord!.qrValue;

      alarmID = alarmRecord!.alarmID;
      ownerId = alarmRecord!.ownerId;
      ownerName = alarmRecord!.ownerName;
      mutexLock.value = alarmRecord!.mutexLock;

      isSharedAlarmEnabled.value = alarmRecord!.isSharedAlarmEnabled;

      if (isSharedAlarmEnabled.value) {
        selectedTime.value = Utils.timeOfDayToDateTime(
            Utils.stringToTimeOfDay(alarmRecord!.mainAlarmTime!));

        mainAlarmTime.value = Utils.timeOfDayToDateTime(
            Utils.stringToTimeOfDay(alarmRecord!.mainAlarmTime!));
        offsetDetails.value = alarmRecord!.offsetDetails!;
        offsetDuration.value =
            alarmRecord!.offsetDetails![userModel!.id]['offsetDuration'];
        isOffsetBefore.value =
            alarmRecord!.offsetDetails![userModel!.id]['isOffsetBefore'];
      }

      // Set lock only if its not locked
      if (isSharedAlarmEnabled.value == true &&
          alarmRecord!.mutexLock == false) {
        alarmRecord!.mutexLock = true;
        alarmRecord!.lastEditedUserId = userModel!.id;
        await FirestoreDb.updateAlarm(alarmRecord!.ownerId, alarmRecord!);
        alarmRecord!.mutexLock = false;
        mutexLock.value = false;
      }
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
  void onClose() async {
    super.onClose();

    if (Get.arguments == null) {
      // Shared alarm was not suddenly enabled, so we can update doc on firestore
      // We also make sure the doc was not already locked
      // If it was suddenly enabled, it will be created newly anyway
      if (isSharedAlarmEnabled.value == true &&
          alarmRecord!.isSharedAlarmEnabled == true &&
          alarmRecord!.mutexLock == false) {
        AlarmModel updatedModel = updatedAlarmModel();
        updatedModel.firestoreId = alarmRecord!.firestoreId;
        await FirestoreDb.updateAlarm(updatedModel.ownerId, updatedModel);
      }
    }
  }

  AlarmModel updatedAlarmModel() {
    return AlarmModel(
        snoozeDuration: snoozeDuration.value,
        label: label.value,
        isOneTime: isOneTime.value,
        mainAlarmTime:
            Utils.timeOfDayToString(TimeOfDay.fromDateTime(selectedTime.value)),
        offsetDetails: offsetDetails,
        sharedUserIds: sharedUserIds,
        lastEditedUserId: lastEditedUserId,
        mutexLock: mutexLock.value,
        alarmID: alarmID,
        ownerId: alarmRecord!.ownerId,
        ownerName: ownerName,
        activityInterval: activityInterval.value * 60000,
        days: repeatDays.toList(),
        alarmTime:
            Utils.timeOfDayToString(TimeOfDay.fromDateTime(selectedTime.value)),
        intervalToAlarm:
            Utils.getMillisecondsToAlarm(DateTime.now(), selectedTime.value),
        isActivityEnabled: isActivityenabled.value,
        minutesSinceMidnight:
            Utils.timeOfDayToInt(TimeOfDay.fromDateTime(selectedTime.value)),
        isLocationEnabled: isLocationEnabled.value,
        weatherTypes: Utils.getIntFromWeatherTypes(selectedWeather.toList()),
        isWeatherEnabled: isWeatherEnabled.value,
        location: Utils.geoPointToString(
          Utils.latLngToGeoPoint(selectedPoint.value),
        ),
        isSharedAlarmEnabled: isSharedAlarmEnabled.value,
        isQrEnabled: isQrEnabled.value,
        qrValue: qrValue.value,
        isMathsEnabled: isMathsEnabled.value,
        numMathsQuestions: numMathsQuestions.value,
        mathsDifficulty: mathsDifficulty.value.index,
        isShakeEnabled: isShakeEnabled.value,
        shakeTimes: shakeTimes.value);
  }
}
