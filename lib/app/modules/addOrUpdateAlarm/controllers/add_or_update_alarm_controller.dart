import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
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
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:uuid/uuid.dart';

class AddOrUpdateAlarmController extends GetxController
    with AlarmHandlerSetupModel {
  final labelController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();

  late UserModel? userModel;
  var alarmID = const Uuid().v4();
  var homeController = Get.find<HomeController>();
  final selectedTime = DateTime.now().add(const Duration(minutes: 1)).obs;
  final mainAlarmTime = DateTime.now().add(const Duration(minutes: 1)).obs;
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
  final qrValue = ''.obs;
  final isQrEnabled = false.obs;

  final mathsSliderValue = 0.0.obs;
  final mathsDifficulty = Difficulty.Easy.obs;
  final isMathsEnabled = false.obs;
  final numMathsQuestions = 1.obs;
  final MapController mapController = MapController();
  final selectedPoint = LatLng(0, 0).obs;
  final RxList markersList = [].obs;
  final daysRepeating = 'Never'.obs;
  final weatherTypes = 'Off'.obs;
  final selectedWeather = <WeatherTypes>[].obs;
  final repeatDays =
      <bool>[false, false, false, false, false, false, false].obs;
  final RxBool isOneTime = false.obs;
  final RxString label = ''.obs;
  final RxInt snoozeDuration = 1.obs;
  Future<List<UserModel?>> fetchUserDetailsForSharedUsers() async {
    List<UserModel?> userDetails = [];

    for (String userId in alarmRecord?.sharedUserIds ?? []) {
      userDetails.add(await FirestoreDb.fetchUserDetails(userId));
    }

    return userDetails;
  }

  checkOverlayPermissionAndNavigate() async {
    if (!(await FlutterForegroundTask.canDrawOverlays) ||
        !(await FlutterForegroundTask.isIgnoringBatteryOptimizations) ||
        !(await FlutterForegroundTask.canDrawOverlays)) {
      Get.defaultDialog(
        backgroundColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: 'Permission Required',
        titleStyle: TextStyle(
          color: themeController.isLightMode.value
              ? kLightPrimaryTextColor
              : Colors.white,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        titlePadding: const EdgeInsets.only(top: 30, right: 40),
        content: const Text(
          'This app requires permission to draw overlays,send notifications'
          ' and Ignore batter optimization.',
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kprimaryColor,
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Get.back();
            },
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kprimaryColor,
            ),
            child: const Text(
              'Grant Permission',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              Get.back();

              // Request overlay permission
              if (!(await FlutterForegroundTask.canDrawOverlays)) {
                final isOverlayPermissionGranted =
                    await FlutterForegroundTask.openSystemAlertWindowSettings();
                if (!isOverlayPermissionGranted) {
                  debugPrint('SYSTEM_ALERT_WINDOW permission denied!');
                  return;
                }
              }
              if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
                // This function requires `android.permission.
                // REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
                await FlutterForegroundTask.requestIgnoreBatteryOptimization();
                if (!await (FlutterForegroundTask
                    .isIgnoringBatteryOptimizations)) {
                  debugPrint('IGNORE_BATTERY_OPTIMIZATION permission denied!');
                  return;
                }
              }
              // Request notification permission
              if (!await Permission.notification.isGranted) {
                final status = await Permission.notification.request();
                if (status != PermissionStatus.granted) {
                  debugPrint('Notification permission denied!');
                  return;
                }
              }

              Get.back();
            },
          ),
        ],
      );
    } else {
      Get.back();
    }
  }

  Future<void> getLocation() async {
    if (await _checkAndRequestPermission()) {
      const timeLimit = Duration(seconds: 10);
      await FlLocation.getLocation(
        timeLimit: timeLimit,
        accuracy: LocationAccuracy.best,
      ).then((location) {
        selectedPoint.value = LatLng(location.latitude, location.longitude);
      }).onError((error, stackTrace) {
        debugPrint('error: ${error.toString()}');
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
      // Cannot request runtime permission because location permission
      // is denied forever.
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      bool? shouldAskPermission = await Get.defaultDialog<bool>(
        backgroundColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        barrierDismissible: false,
        title: 'Location Permission',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        titlePadding: const EdgeInsets.only(top: 30, right: 40),
        titleStyle: TextStyle(
          color: themeController.isLightMode.value
              ? kLightPrimaryTextColor
              : Colors.white,
        ),
        content: const Text('This app needs access to your location.'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kprimaryColor,
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Get.back(result: false);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kprimaryColor,
            ),
            child: const Text('Allow', style: TextStyle(color: Colors.black)),
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

  showQRDialog() {
    restartQRCodeController();
    Get.defaultDialog(
      titlePadding: const EdgeInsets.symmetric(vertical: 20),
      backgroundColor: themeController.isLightMode.value
          ? kLightSecondaryBackgroundColor
          : ksecondaryBackgroundColor,
      title: 'Scan a QR/Bar Code',
      titleStyle: Theme.of(Get.context!).textTheme.displaySmall,
      content: Obx(
        () => Column(
          children: [
            isQrEnabled.value == false
                ? SizedBox(
                    height: 300,
                    width: 300,
                    child: MobileScanner(
                      controller: qrController,
                      fit: BoxFit.cover,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          qrValue.value = barcode.rawValue.toString();
                          debugPrint(barcode.rawValue.toString());
                          isQrEnabled.value = true;
                        }
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(qrValue.value),
                  ),
            isQrEnabled.value == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        child: Text(
                          'Save',
                          style: Theme.of(Get.context!)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryTextColor
                                    : ksecondaryTextColor,
                              ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        child: Text(
                          'Retake',
                          style: Theme.of(Get.context!)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.isLightMode.value
                                    ? kLightPrimaryTextColor
                                    : ksecondaryTextColor,
                              ),
                        ),
                        onPressed: () async {
                          qrController.dispose();
                          restartQRCodeController();
                          isQrEnabled.value = false;
                        },
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  requestQrPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      Get.defaultDialog(
        backgroundColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: 'Camera Permission',
        titleStyle: TextStyle(
          color: themeController.isLightMode.value
              ? kLightPrimaryTextColor
              : Colors.white,
        ),
        titlePadding: const EdgeInsets.only(
          top: 25,
          left: 10,
        ),
        contentPadding: const EdgeInsets.only(top: 20, left: 20, bottom: 23),
        content: const Text('Please allow camera access to scan QR codes.'),
        onCancel: () {
          Get.back(); // Close the alert box
        },
        onConfirm: () async {
          Get.back(); // Close the alert box
          PermissionStatus permissionStatus = await Permission.camera.request();
          if (permissionStatus.isGranted) {
            // Permission granted, proceed with QR code scanning
            showQRDialog();
          }
        },
        cancel: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kprimaryColor,
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Get.back(); // Close the alert box
          },
        ),
        confirm: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kprimaryColor,
          ),
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            Get.back(); // Close the alert box
            PermissionStatus permissionStatus =
                await Permission.camera.request();
            if (permissionStatus.isGranted) {
              // Permission granted, proceed with QR code scanning
              showQRDialog();
            }
          },
        ),
      );
    } else {
      showQRDialog();
    }
  }

  restartQRCodeController() async {
    // Camera permission already granted, proceed with QR code scanning
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
      // Making sure the alarm wasn't suddenly updated to be an
      // online (shared) alarm
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
        Utils.stringToTimeOfDay(alarmRecord!.alarmTime),
      );
      // Shows the "Rings in" time
      timeToAlarm.value = Utils.timeUntilAlarm(
        TimeOfDay.fromDateTime(selectedTime.value),
        repeatDays,
      );

      repeatDays.value = alarmRecord!.days;
      // Shows the selected days in UI
      daysRepeating.value = Utils.getRepeatDays(repeatDays);

      // Setting the old values for all the auto dismissal
      isActivityenabled.value = alarmRecord!.isActivityEnabled;
      activityInterval.value = alarmRecord!.activityInterval ~/ 60000;

      isLocationEnabled.value = alarmRecord!.isLocationEnabled;
      selectedPoint.value = Utils.stringToLatLng(alarmRecord!.location);
      // Shows the marker in UI
      markersList.add(
        Marker(
          point: selectedPoint.value,
          builder: (ctx) => const Icon(
            Icons.location_on,
            size: 35,
            color: Colors.black,
          ),
        ),
      );

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
          Utils.stringToTimeOfDay(alarmRecord!.mainAlarmTime!),
        );

        mainAlarmTime.value = Utils.timeOfDayToDateTime(
          Utils.stringToTimeOfDay(alarmRecord!.mainAlarmTime!),
        );
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
      TimeOfDay.fromDateTime(selectedTime.value),
      repeatDays,
    );

    // Adding to markers list, to display on map
    // (MarkersLayer takes only List<Marker>)
    selectedPoint.listen((point) {
      selectedPoint.value = point;
      markersList.clear();
      markersList.add(
        Marker(
          point: point,
          builder: (ctx) => const Icon(
            Icons.location_on,
            size: 35,
            color: Colors.black,
          ),
        ),
      );
    });

    // Updating UI to show time to alarm

    selectedTime.listen((time) {
      debugPrint('CHANGED CHANGED CHANGED CHANGED');
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
  void onClose() async {
    super.onClose();

    if (Get.arguments == null) {
      // Shared alarm was not suddenly enabled, so we can update doc
      // on firestore
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
      shakeTimes: shakeTimes.value,
    );
  }
}
