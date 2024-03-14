import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:fl_location/fl_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:uuid/uuid.dart';
import '../../settings/controllers/settings_controller.dart';

class AddOrUpdateAlarmController extends GetxController {
  final labelController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  SettingsController settingsController = Get.find<SettingsController>();

  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
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
  final isPedometerEnabled = false.obs;
  final numberOfSteps = 0.obs;
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
  final qrValue = ''.obs; // qrvalue stored in alarm
  final detectedQrValue = ''.obs; // QR value detected by camera
  final isQrEnabled = false.obs;

  final mathsSliderValue = 0.0.obs;
  final mathsDifficulty = Difficulty.Easy.obs;
  final isMathsEnabled = false.obs;
  final numMathsQuestions = 1.obs;
  final MapController mapController = MapController();
  final selectedPoint = LatLng(0, 0).obs;
  final RxList markersList = [].obs;
  final daysRepeating = 'Never'.tr.obs;
  final weatherTypes = 'Off'.tr.obs;
  final selectedWeather = <WeatherTypes>[].obs;
  final repeatDays =
      <bool>[false, false, false, false, false, false, false].obs;
  final RxBool isOneTime = false.obs;
  final RxString label = ''.obs;
  final RxInt snoozeDuration = 1.obs;
  var customRingtoneName = 'Default'.obs;
  var customRingtoneNames = [].obs;
  var previousRingtone = '';
  final noteController = TextEditingController();
  final RxString note = ''.obs;
  final deleteAfterGoesOff = false.obs;

  final RxBool showMotivationalQuote = false.obs;
  final RxInt gradient = 0.obs;
  final RxDouble selectedGradientDouble = 0.0.obs;
  final RxDouble volMin = 0.0.obs;
  final RxDouble volMax = 10.0.obs;

  final RxInt hours = 0.obs, minutes = 0.obs, meridiemIndex = 0.obs;
  final List<RxString> meridiem = ['AM'.obs, 'PM'.obs];

  Future<List<UserModel?>> fetchUserDetailsForSharedUsers() async {
    List<UserModel?> userDetails = [];

    for (String userId in alarmRecord?.sharedUserIds ?? []) {
      userDetails.add(await FirestoreDb.fetchUserDetails(userId));
    }

    return userDetails;
  }

  RxBool isDailySelected = false.obs;
  RxBool isWeekdaysSelected = false.obs;
  RxBool isCustomSelected = false.obs;
  RxBool isPlaying = false.obs; // Observable boolean to track playing state

  // to check whether alarm data is updated or not
  Map<String, dynamic> initialValues = {};
  Map<String, dynamic> changedFields = {};

  void toggleIsPlaying() {
    isPlaying.toggle();
  }

  void resetIsPlaying() {
    isPlaying.value = false;
  }

  void setIsDailySelected(bool value) {
    isDailySelected.value = value;
    if (value == true) {
      isCustomSelected.value = false;
      isWeekdaysSelected.value = false;
    }
  }

  void setGradient(int value) {
    this.gradient.value = value;
  }

  void setIsWeekdaysSelected(bool value) {
    isWeekdaysSelected.value = value;
    if (value == true) {
      isCustomSelected.value = false;
      isDailySelected.value = false;
    }
  }

  void setIsCustomSelected(bool value) {
    isCustomSelected.value = value;
    if (value == true) {
      isWeekdaysSelected.value = false;
      isDailySelected.value = false;
    }
  }

  checkOverlayPermissionAndNavigate() async {
    if (!(await Permission.systemAlertWindow.isGranted) ||
        !(await Permission.ignoreBatteryOptimizations.isGranted) ||
        !(await Permission.systemAlertWindow.isGranted)) {
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

              if (Platform.isAndroid) {
                // Request overlay permission
                if (!(await Permission.systemAlertWindow.isGranted)) {
                  final status = await Permission.systemAlertWindow.request();
                  if (!status.isGranted) {
                    debugPrint('SYSTEM_ALERT_WINDOW permission denied!');
                    return;
                  }
                }

                if (!(await Permission.ignoreBatteryOptimizations.isGranted)) {
                  bool requested = await Permission.ignoreBatteryOptimizations
                      .request()
                      .isGranted;
                  if (!requested) {
                    debugPrint(
                        'IGNORE_BATTERY_OPTIMIZATION permission denied!');
                    return;
                  }
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

  void checkUnsavedChangesAndNavigate(BuildContext context) {
    int numberOfChangesMade =
        changedFields.entries.where((element) => element.value == true).length;
    if (numberOfChangesMade >= 1) {
      Get.defaultDialog(
        titlePadding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        backgroundColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: 'Discard Changes?'.tr,
        titleStyle: Theme.of(context).textTheme.displaySmall,
        content: Column(
          children: [
            Text(
              'unsavedChanges'.tr,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kprimaryColor),
                    ),
                    child: Text(
                      'Cancel'.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: kprimaryBackgroundColor,
                          ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Get.back(closeOverlays: true);
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: themeController.isLightMode.value
                            ? Colors.red.withOpacity(0.9)
                            : Colors.red,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Leave'.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: themeController.isLightMode.value
                                ? Colors.red.withOpacity(0.9)
                                : Colors.red,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      alarmRecord = await FirestoreDb.addAlarm(userModel.value, alarmData);
    } else {
      alarmRecord = await IsarDb.addAlarm(alarmData);
    }

    Future.delayed(const Duration(seconds: 1), () {
      showToast(
        alarmRecord: alarmData,
      );
    });
  }

  showQRDialog() {
    restartQRCodeController(false);
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
            detectedQrValue.value.isEmpty
                ? SizedBox(
                    height: 300,
                    width: 300,
                    child: MobileScanner(
                      controller: qrController,
                      fit: BoxFit.cover,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          detectedQrValue.value = barcode.rawValue.toString();
                          debugPrint(barcode.rawValue.toString());
                        }
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(detectedQrValue.value),
                  ),
            (detectedQrValue.value.isNotEmpty)
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
                          qrValue.value = detectedQrValue.value;
                          isQrEnabled.value = true;
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
                          restartQRCodeController(true);
                        },
                      ),
                      if (isQrEnabled.value)
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kprimaryColor),
                          ),
                          child: Text(
                            'Disable',
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
                            isQrEnabled.value = false;
                            qrValue.value = '';
                            Get.back();
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

  requestQrPermission(context) async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      Get.defaultDialog(
        backgroundColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        title: 'Camera Permission'.tr,
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
        content: Text('Please allow camera access to scan QR codes.'.tr),
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
        confirm: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kprimaryColor),
          ),
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor
                      : ksecondaryTextColor,
                ),
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
        cancel: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              themeController.isLightMode.value
                  ? kLightPrimaryTextColor.withOpacity(0.5)
                  : kprimaryTextColor.withOpacity(0.5),
            ),
          ),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor
                      : kprimaryTextColor,
                ),
          ),
          onPressed: () {
            Get.back(); // Close the alert box
          },
        ),
      );
    } else {
      showQRDialog();
    }
  }

  restartQRCodeController(bool retake) async {
    // Camera permission already granted, proceed with QR code scanning
    qrController = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    detectedQrValue.value = retake ? '' : qrValue.value;
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
        await FirestoreDb.deleteAlarm(
          userModel.value,
          alarmRecord!.firestoreId!,
        );
        createAlarm(alarmData);
      }
    }

    Future.delayed(const Duration(seconds: 1), () {
      showToast(
        alarmRecord: alarmData,
      );
    });
  }

  @override
  void onInit() async {
    super.onInit();

    userModel.value = homeController.userModel.value;
    if (userModel.value != null) {
      ownerId = userModel.value!.id;
      ownerName = userModel.value!.fullName;
      lastEditedUserId = userModel.value!.id;
    }

    // listens to the userModel declared in homeController and updates on signup event
    homeController.userModel.stream.listen((UserModel? user) {
      userModel.value = user;
      if (user != null) {
        ownerId = user.id;
        ownerName = user.fullName;
        lastEditedUserId = user.id;
      }
    });

    if (Get.arguments != null) {
      snoozeDuration.value = alarmRecord!.snoozeDuration;
      gradient.value = alarmRecord!.gradient;
      volMin.value = alarmRecord!.volMin;
      volMax.value = alarmRecord!.volMax;
      isOneTime.value = alarmRecord!.isOneTime;
      deleteAfterGoesOff.value = alarmRecord!.deleteAfterGoesOff;
      label.value = alarmRecord!.label;
      customRingtoneName.value = alarmRecord!.ringtoneName;
      note.value = alarmRecord!.note;
      showMotivationalQuote.value = alarmRecord!.showMotivationalQuote;

      sharedUserIds.value = alarmRecord!.sharedUserIds!;
      // Reinitializing all values here
      selectedTime.value = Utils.timeOfDayToDateTime(
        Utils.stringToTimeOfDay(alarmRecord!.alarmTime),
      );
      hours.value = selectedTime.value.hour;
      minutes.value = selectedTime.value.minute;

      if (settingsController.is24HrsEnabled.value == false) {
        if (selectedTime.value.hour == 0) {
          hours.value = 12;
          meridiemIndex.value = 0;
        } else if (selectedTime.value.hour == 12) {
          meridiemIndex.value = 1;
        } else if (selectedTime.value.hour > 12) {
          hours.value = selectedTime.value.hour - 12;
          meridiemIndex.value = 1;
        } else {
          meridiemIndex.value = 0;
        }
      }
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

      isPedometerEnabled.value = alarmRecord!.isPedometerEnabled;
      numberOfSteps.value = alarmRecord!.numberOfSteps;

      isQrEnabled.value = alarmRecord!.isQrEnabled;
      qrValue.value = alarmRecord!.qrValue;
      detectedQrValue.value = alarmRecord!.qrValue;

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
            alarmRecord!.offsetDetails![userModel.value!.id]['offsetDuration'];
        isOffsetBefore.value =
            alarmRecord!.offsetDetails![userModel.value!.id]['isOffsetBefore'];
      }

      // Set lock only if its not locked
      if (isSharedAlarmEnabled.value == true &&
          alarmRecord!.mutexLock == false) {
        alarmRecord!.mutexLock = true;
        alarmRecord!.lastEditedUserId = userModel.value!.id;
        await FirestoreDb.updateAlarm(alarmRecord!.ownerId, alarmRecord!);
        alarmRecord!.mutexLock = false;
        mutexLock.value = false;
      }
    } else {
      hours.value = selectedTime.value.hour;
      minutes.value = selectedTime.value.minute;

      if (settingsController.is24HrsEnabled.value == false) {
        if (selectedTime.value.hour == 0) {
          hours.value = 12;
          meridiemIndex.value = 0;
        } else if (selectedTime.value.hour == 12) {
          meridiemIndex.value = 1;
        } else if (selectedTime.value.hour > 12) {
          hours.value = selectedTime.value.hour - 12;
          meridiemIndex.value = 1;
        } else {
          meridiemIndex.value = 0;
        }
      }
    }

    timeToAlarm.value = Utils.timeUntilAlarm(
      TimeOfDay.fromDateTime(selectedTime.value),
      repeatDays,
    );

    // store initial values of the variables
    initialValues.addAll({
      'selectedTime': selectedTime.value,
      'daysRepeating': daysRepeating.value,
      'snoozeDuration': snoozeDuration.value,
      'deleteAfterGoesOff': deleteAfterGoesOff.value,
      'label': label.value,
      'note': note.value,
      'customRingtoneName': customRingtoneName.value,
      'volMin': volMin.value,
      'volMax': volMax.value,
      'gradient': gradient.value,
      'showMotivationalQuote': showMotivationalQuote.value,
      'activityInterval': activityInterval.value,
      'weatherTypes': weatherTypes.value,
      'location':
          '${selectedPoint.value.latitude} ${selectedPoint.value.longitude}',
      'shakeTimes': shakeTimes.value,
      'qrValue': qrValue.value,
      'mathsDifficulty': mathsDifficulty.value,
      'mathsSliderValue': mathsSliderValue.value,
      'numMathsQuestions': numMathsQuestions.value,
      'numberOfSteps': numberOfSteps.value,
      'isSharedAlarmEnabled': isSharedAlarmEnabled.value,
      'offsetDuration': offsetDuration.value,
      'isOffsetBefore': isOffsetBefore.value
    });

    addListeners();

    if (await SecureStorageProvider().retrieveApiKey(ApiKeys.openWeatherMap) !=
        null) {
      weatherApiKeyExists.value = true;
    }

    // If there's an argument sent, we are in update mode
  }

  void addListeners() {
    // Updating UI to show time to alarm
    selectedTime.listen((time) {
      debugPrint('CHANGED CHANGED CHANGED CHANGED');
      timeToAlarm.value =
          Utils.timeUntilAlarm(TimeOfDay.fromDateTime(time), repeatDays);
      _compareAndSetChange('selectedTime', time);
    });

    //Updating UI to show repeated days
    repeatDays.listen((days) {
      daysRepeating.value = Utils.getRepeatDays(days);
      _compareAndSetChange('daysRepeating', daysRepeating.value);
    });

    setupListener<int>(snoozeDuration, 'snoozeDuration');
    setupListener<bool>(deleteAfterGoesOff, 'deleteAfterGoesOff');
    setupListener<String>(label, 'label');
    setupListener<String>(note, 'note');
    setupListener<String>(customRingtoneName, 'customRingtoneName');
    setupListener<double>(volMin, 'volMin');
    setupListener<double>(volMax, 'volMax');
    setupListener<int>(gradient, 'gradient');
    setupListener<bool>(showMotivationalQuote, 'showMotivationalQuote');
    setupListener<int>(activityInterval, 'activityInterval');

    // Updating UI to show weather types
    selectedWeather.listen((weather) {
      if (weather.toList().isEmpty) {
        isWeatherEnabled.value = false;
      } else {
        isWeatherEnabled.value = true;
      }
      weatherTypes.value = Utils.getFormattedWeatherTypes(weather);
      _compareAndSetChange('weatherTypes', weatherTypes.value);
      // if location based is disabled and weather based is disabled, reset location
      if (weatherTypes.value == 'Off' && !isLocationEnabled.value) {
        selectedPoint.value = LatLng(0, 0);
      }
    });

    // Adding to markers list, to display on map
    // (MarkersLayer takes only List<Marker>)
    selectedPoint.listen(
      (point) {
        selectedPoint.value = point;
        markersList.clear();
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
        _compareAndSetChange(
            'location', '${point.latitude} ${point.longitude}');
      },
    );

    // reset selectedPoint to default value if isLocationEnabled is false and weather based is off
    isLocationEnabled.listen((value) {
      if (!value && weatherTypes.value == 'Off') {
        selectedPoint.value = LatLng(0, 0);
      }
    });

    setupListener<int>(shakeTimes, 'shakeTimes');
    setupListener<String>(qrValue, 'qrValue');
    setupListener<double>(mathsSliderValue, 'mathsSliderValue');
    setupListener<Difficulty>(mathsDifficulty, 'mathsDifficulty');
    setupListener<int>(numMathsQuestions, 'numMathsQuestions');
    setupListener<int>(numberOfSteps, 'numberOfSteps');

    setupListener<bool>(isSharedAlarmEnabled, 'isSharedAlarmEnabled');
    setupListener<int>(offsetDuration, 'offsetDuration');
    setupListener<bool>(isOffsetBefore, 'isOffsetBefore');
  }

  // adds listener to rxVar variable
  void setupListener<T>(Rx<T> rxVar, String fieldName) {
    rxVar.listen((value) {
      _compareAndSetChange(fieldName, value);
    });
  }

  // if initialValues map contains fieldName and newValue is equal to currentValue
  // then set changeFields map field to true
  void _compareAndSetChange(String fieldName, dynamic currentValue) {
    if (initialValues.containsKey(fieldName)) {
      bool hasChanged = initialValues[fieldName] != currentValue;
      changedFields[fieldName] = hasChanged;
    }
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
      volMax: volMax.value,
      volMin: volMin.value,
      gradient: gradient.value,
      label: label.value,
      isOneTime: isOneTime.value,
      deleteAfterGoesOff: deleteAfterGoesOff.value,
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
      isPedometerEnabled: isPedometerEnabled.value,
      numberOfSteps: numberOfSteps.value,
      ringtoneName: customRingtoneName.value,
      note: note.value,
      showMotivationalQuote: showMotivationalQuote.value,
    );
  }

  Future<FilePickerResult?> openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        withData: true,
      );

      if (result != null) {
        customRingtoneName.value = result.files.single.name;
        if (customRingtoneNames.contains(customRingtoneName.value)) {
          Get.snackbar(
            'Duplicate Ringtone'.tr,
            'Choosen ringtone is already present'.tr,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            barBlur: 15,
            colorText: kprimaryTextColor,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
          );
        } else {
          customRingtoneNames.add(customRingtoneName.value);
          return result;
        }
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> saveToDocumentsDirectory({
    required String filePath,
  }) async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String ringtonesDirectoryPath = '${documentsDirectory.path}/ringtones';

      // Create the ringtones directory if it doesn't exist
      Directory(ringtonesDirectoryPath).createSync(recursive: true);

      // Copy the picked audio files to the ringtones directory
      File pickedFile = File(filePath);
      String newFilePath =
          '$ringtonesDirectoryPath/${pickedFile.uri.pathSegments.last}';
      pickedFile.copySync(newFilePath);

      return newFilePath;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> saveCustomRingtone() async {
    try {
      FilePickerResult? customRingtoneResult = await openFilePicker();

      if (customRingtoneResult != null) {
        String? filePath = customRingtoneResult.files.single.path;

        String? savedFilePath =
            await saveToDocumentsDirectory(filePath: filePath!);

        if (savedFilePath != null) {
          RingtoneModel customRingtone = RingtoneModel(
            ringtoneName: customRingtoneName.value,
            ringtonePath: savedFilePath,
            currentCounterOfUsage: 1,
          );
          AudioUtils.updateRingtoneCounterOfUsage(
              customRingtoneName: previousRingtone,
              counterUpdate: CounterUpdate.decrement);
          await IsarDb.addCustomRingtone(customRingtone);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<String>> getAllCustomRingtoneNames() async {
    try {
      List<RingtoneModel> customRingtones =
          await IsarDb.getAllCustomRingtones();

      return customRingtones
          .map((customRingtone) => customRingtone.ringtoneName)
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> deleteCustomRingtone({
    required String ringtoneName,
    required int ringtoneIndex,
  }) async {
    try {
      int customRingtoneId = AudioUtils.fastHash(ringtoneName);
      RingtoneModel? customRingtone =
          await IsarDb.getCustomRingtone(customRingtoneId: customRingtoneId);

      if (customRingtone != null) {
        int currentCounterOfUsage = customRingtone.currentCounterOfUsage;

        if (currentCounterOfUsage == 0) {
          customRingtoneNames.removeAt(ringtoneIndex);
          await IsarDb.deleteCustomRingtone(ringtoneId: customRingtoneId);

          final documentsDirectory = await getApplicationDocumentsDirectory();
          final ringtoneFilePath =
              '${documentsDirectory.path}/ringtones/$ringtoneName';

          if (await File(ringtoneFilePath).exists()) {
            await File(ringtoneFilePath).delete();
            Get.snackbar(
              'Ringtone Deleted',
              'The selected ringtone has been successfully deleted.',
              margin: EdgeInsets.all(15),
              animationDuration: Duration(seconds: 1),
              snackPosition: SnackPosition.BOTTOM,
              barBlur: 15,
              colorText: kprimaryTextColor,
            );
          } else {
            Get.snackbar(
              'Ringtone Not Found',
              'The selected ringtone does not exist and cannot be deleted.',
              margin: EdgeInsets.all(15),
              animationDuration: Duration(seconds: 1),
              snackPosition: SnackPosition.BOTTOM,
              barBlur: 15,
              colorText: kprimaryTextColor,
            );
          }
        } else {
          Get.snackbar(
            'Ringtone in Use',
            'This ringtone cannot be deleted as it is currently assigned'
                ' to one or more alarms.',
            margin: EdgeInsets.all(15),
            animationDuration: Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM,
            barBlur: 15,
            colorText: kprimaryTextColor,
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showToast({
    required AlarmModel alarmRecord,
  }) {
    try {
      String timeToAlarm = Utils.timeUntilAlarm(
        Utils.stringToTimeOfDay(alarmRecord.alarmTime),
        alarmRecord.days,
      );

      Fluttertoast.showToast(
        msg: 'Rings in $timeToAlarm',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: themeController.isLightMode.value
            ? kLightSecondaryBackgroundColor
            : ksecondaryBackgroundColor,
        textColor: themeController.isLightMode.value
            ? kLightPrimaryTextColor
            : kprimaryTextColor,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
