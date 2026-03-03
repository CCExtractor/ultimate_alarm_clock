import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:fl_location/fl_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/profile_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart' as isar;
import 'package:ultimate_alarm_clock/app/data/providers/push_notifications.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/system_ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/timezone_utils.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import '../../settings/controllers/settings_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ultimate_alarm_clock/app/utils/system_ringtone_service.dart';

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
  final isActivityMonitorenabled = 0.obs;
  final activityInterval = 0.obs;
  final activityConditionType = ActivityConditionType.off.obs;
  final isLocationEnabled = false.obs;
  final isSharedAlarmEnabled = false.obs;
  late final isWeatherEnabled = false.obs;
  final weatherApiKeyExists = false.obs;
  final isShakeEnabled = false.obs;
  final timeToAlarm = ''.obs;
  final shakeTimes = 0.obs;
  final isPedometerEnabled = false.obs;
  final numberOfSteps = 0.obs;
  final locationConditionType = LocationConditionType.off.obs;
  final weatherConditionType = WeatherConditionType.off.obs;
  var ownerId = ''.obs; // id -> owner of the alarm
  var ownerName = ''.obs; // name -> owner of the alarm
  var userId = ''.obs; // id -> loggedin user
  var userName = ''.obs; // name -> loggedin user
  final mutexLock = false.obs;
  var lastEditedUserId = ''.obs;
  final sharedUserIds = <String>[].obs;
  var alarmRecord = Utils.alarmModelInit.obs;
  final RxMap userOffsetDetails = {}.obs;
  final RxList<Map> offsetDetails = [{}].obs;
  final offsetDuration = 0.obs;
  final isOffsetBefore = true.obs;
  
  // NEW: Selected location radius for customizable detection radius
  final selectedLocationRadius = 500.obs; // Default 500m radius
  
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
  final numMathsQuestions = 0.obs;
  final MapController mapController = MapController();
  final selectedPoint = LatLng(0, 0).obs;
  final RxList markersList = [].obs;
  final daysRepeating = 'Never'.tr.obs;
  final weatherTypes = 'Off'.tr.obs;
  final selectedWeather = <WeatherTypes>[].obs;
  final repeatDays =
      <bool>[false, false, false, false, false, false, false].obs;
  final RxBool isOneTime = true.obs;
  final RxString label = ''.obs;
  final RxInt snoozeDuration = 1.obs;
  final RxInt maxSnoozeCount = 3.obs;
  var customRingtoneName = 'Digital Alarm 1'.obs;
  var customRingtoneNames = [].obs;
  var previousRingtone = '';
  final noteController = TextEditingController();
  final RxString note = ''.obs;
  final deleteAfterGoesOff = false.obs;

  final RxBool showMotivationalQuote = false.obs;
  final RxBool useScreenActivity = false.obs;
  final RxInt gradient = 0.obs;
  final RxDouble selectedGradientDouble = 0.0.obs;
  final RxDouble volMin = 0.0.obs;
  final RxDouble volMax = 10.0.obs;
  var selectedDate = DateTime.now().obs;
  final RxBool isFutureDate = false.obs;

  final RxBool isAddUser = false.obs;

  final RxList selectedEmails = [].obs;

  TextEditingController profileTextEditingController = TextEditingController();

  TextEditingController contactTextEditingController = TextEditingController();

  TextEditingController emailTextEditingController = TextEditingController();

  final RxInt hours = 0.obs, minutes = 0.obs, meridiemIndex = 0.obs;
  final List<RxString> meridiem = ['AM'.obs, 'PM'.obs];

  
  TextEditingController inputHrsController = TextEditingController();
  TextEditingController inputMinutesController = TextEditingController();
  
  
  final isTimePicker = false.obs;
  final isAM = true.obs;
  int? _previousDisplayHour;

  Future<List<UserModel?>> fetchUserDetailsForSharedUsers() async {
    List<UserModel?> userDetails = [];

    for (String userId in alarmRecord.value.sharedUserIds ?? []) {
      userDetails.add(await FirestoreDb.fetchUserDetails(userId));
    }

    return userDetails;
  }

  RxBool isDailySelected = false.obs;
  RxBool isWeekdaysSelected = false.obs;
  RxBool isCustomSelected = false.obs;
  final RxBool isPlaying = false.obs;

  // to check whether alarm data is updated or not
  Map<String, dynamic> initialValues = {};
  Map<String, dynamic> changedFields = {};

  RxInt alarmSettingType = 0.obs;

  final RxBool isSystemRingtonesLoading = false.obs;
  final RxMap<String, List<SystemRingtoneModel>> categorizedSystemRingtones = <String, List<SystemRingtoneModel>>{}.obs;
  final RxString playingSystemRingtoneUri = ''.obs;

  late ProfileModel profileModel;
  final storage = Get.find<GetStorageProvider>();

  final RxBool isGuardian = false.obs;
  final RxInt guardianTimer = 120.obs; // Default to 2 minutes (120 seconds)
  final RxString guardian = ''.obs;
  final RxBool isCall = false.obs;
  
  // Sunrise Alarm Variables
  final RxBool isSunriseEnabled = false.obs;
  final RxInt sunriseDuration = 30.obs;
  final RxDouble sunriseIntensity = 1.0.obs;
  final RxInt sunriseColorScheme = 0.obs;
  
  // Timezone Variables
  final RxString selectedTimezoneId = ''.obs;
  final RxBool isTimezoneEnabled = false.obs;
  final RxInt targetTimezoneOffset = 0.obs;
  final RxList<TimezoneData> timezoneList = <TimezoneData>[].obs;
  final RxList<TimezoneData> filteredTimezoneList = <TimezoneData>[].obs;
  final RxString timezoneSearchQuery = ''.obs;
  final RxString deviceTimezoneId = ''.obs;
  
  // Smart Control Combination Variables
  final RxInt smartControlCombinationType = SmartControlCombinationType.and.index.obs;

  void setSmartControlCombinationType(SmartControlCombinationType type) {
    smartControlCombinationType.value = type.index;
  }

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
    gradient.value = value;
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

  // Timezone methods
  Future<void> initializeTimezone() async {
    await TimezoneUtils.init();
    deviceTimezoneId.value = TimezoneUtils.getDeviceTimezoneId();
    // For testing - if device timezone is not India, set it manually
    if (deviceTimezoneId.value != 'Asia/Kolkata') {
      deviceTimezoneId.value = 'Asia/Kolkata'; // India Standard Time
    }
    print('🌍 Device timezone set to: ${deviceTimezoneId.value}');
    loadTimezones();
    
    // Check if this is a new alarm (no arguments) and apply default settings
    if (Get.arguments == null) {
      // Apply default timezone settings for new alarms
      isTimezoneEnabled.value = settingsController.isTimezoneEnabledByDefault.value;
      if (settingsController.defaultTimezoneId.value.isNotEmpty) {
        selectedTimezoneId.value = settingsController.defaultTimezoneId.value;
      } else {
        selectedTimezoneId.value = deviceTimezoneId.value;
      }
    } else {
      // For existing alarms, set device timezone as default if no timezone is selected
      if (selectedTimezoneId.value.isEmpty && !isTimezoneEnabled.value) {
        selectedTimezoneId.value = deviceTimezoneId.value;
      }
    }
    
    updateTimezoneOffset();
  }

  void loadTimezones() {
    timezoneList.value = TimezoneUtils.getCommonTimezones();
    filteredTimezoneList.value = timezoneList.value;
  }

  void searchTimezones(String query) {
    timezoneSearchQuery.value = query;
    if (query.isEmpty) {
      filteredTimezoneList.value = timezoneList.value;
    } else {
      filteredTimezoneList.value = TimezoneUtils.searchTimezones(query);
    }
  }

  void toggleTimezone(bool enabled) {
    isTimezoneEnabled.value = enabled;
    if (!enabled) {
      selectedTimezoneId.value = deviceTimezoneId.value;
      targetTimezoneOffset.value = 0;
    } else {
      updateTimezoneOffset();
      if (selectedTimezoneId.value.isNotEmpty) {
        convertLocalTimeToTargetTimezone();
      }
    }
    updateAlarmTimeForTimezone();
  }

  void selectTimezone(String timezoneId) {
    selectedTimezoneId.value = timezoneId;
    updateTimezoneOffset();
    convertLocalTimeToTargetTimezone();
    updateAlarmTimeForTimezone();
  }

  void updateTimezoneOffset() {
    if (selectedTimezoneId.value.isNotEmpty) {
      targetTimezoneOffset.value = TimezoneUtils.calculateTimezoneOffset(selectedTimezoneId.value);
    }
  }

  void convertLocalTimeToTargetTimezone() {
    if (!isTimezoneEnabled.value || selectedTimezoneId.value.isEmpty) return;
    
    try {
      // Get current selected time as local time
      final localTime = TimeOfDay.fromDateTime(selectedTime.value);
      final currentDate = selectedDate.value;
      
      // Get timezone locations
      final localLocation = tz.getLocation(deviceTimezoneId.value);
      final targetLocation = tz.getLocation(selectedTimezoneId.value);
      
      // Calculate the offset difference
      final now = DateTime.now();
      final localNow = tz.TZDateTime.now(localLocation);
      final targetNow = tz.TZDateTime.now(targetLocation);
      final offsetDifference = targetNow.timeZoneOffset.inMinutes - localNow.timeZoneOffset.inMinutes;
      
      // Convert the local time to target timezone by adding the offset
      final localMinutes = localTime.hour * 60 + localTime.minute;
      final targetMinutes = localMinutes + offsetDifference;
      
      // Handle day overflow/underflow
      var targetHour = (targetMinutes ~/ 60) % 24;
      var targetMinute = targetMinutes % 60;
      
      // Handle negative minutes
      if (targetMinute < 0) {
        targetMinute += 60;
        targetHour -= 1;
      }
      
      // Handle negative hours
      if (targetHour < 0) {
        targetHour += 24;
      }
      
      // Debug output
      print('🔧 TIMEZONE CONVERSION DEBUG:');
      print('   Local Time Input: ${localTime.hour}:${localTime.minute}');
      print('   Local TZ: ${deviceTimezoneId.value} (${localNow.timeZoneOffset})');
      print('   Target TZ: ${selectedTimezoneId.value} (${targetNow.timeZoneOffset})');
      print('   Offset Difference: $offsetDifference minutes');
      print('   Target Time: $targetHour:$targetMinute');
      
      // Update selectedTime to show the converted time 
      selectedTime.value = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        targetHour,
        targetMinute,
      );
      
      // Update the time picker display
      hours.value = targetHour;
      minutes.value = targetMinute;
      
      // Update meridiem for 12-hour format
      if (settingsController.is24HrsEnabled.value == false) {
        if (targetHour == 0) {
          hours.value = 12;
          meridiemIndex.value = 0;
        } else if (targetHour == 12) {
          meridiemIndex.value = 1;
        } else if (targetHour > 12) {
          hours.value = targetHour - 12;
          meridiemIndex.value = 1;
        } else {
          meridiemIndex.value = 0;
        }
      }
      
    } catch (e) {
      // If conversion fails, keep the original time
      print('Error converting timezone: $e');
    }
  }

  void updateAlarmTimeForTimezone() {
    if (isTimezoneEnabled.value && selectedTimezoneId.value.isNotEmpty) {
      // Update the alarm time display using timezone-aware time
      final timezoneAwareTime = getTimezoneAwareAlarmTime();
      timeToAlarm.value = Utils.timeUntilAlarm(
        TimeOfDay.fromDateTime(timezoneAwareTime), 
        repeatDays,
      );
    } else {
      // Use regular time calculation
      timeToAlarm.value = Utils.timeUntilAlarm(
        TimeOfDay.fromDateTime(selectedTime.value), 
        repeatDays,
      );
    }
  }

  String getFormattedTimezoneTime() {
    if (!isTimezoneEnabled.value || selectedTimezoneId.value.isEmpty) {
      return '';
    }

    try {
      final selectedData = getSelectedTimezoneData();
      if (selectedData == null) return '';
      
      final currentTime = TimeOfDay.fromDateTime(selectedTime.value);
      final timeString = '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';
      
      return 'Alarm will ring at $timeString in ${selectedData.displayName}';
    } catch (e) {
      return 'Timezone conversion error';
    }
  }

  TimezoneData? getSelectedTimezoneData() {
    if (selectedTimezoneId.value.isEmpty) return null;
    
    return timezoneList.firstWhereOrNull(
      (timezone) => timezone.id == selectedTimezoneId.value,
    );
  }

  DateTime getTimezoneAwareAlarmTime() {
    if (!isTimezoneEnabled.value || selectedTimezoneId.value.isEmpty) {
      return selectedTime.value;
    }

    try {
      // selectedTime now contains the TARGET timezone time (after conversion)
      // We need to convert it back to LOCAL time for scheduling
      final targetTime = TimeOfDay.fromDateTime(selectedTime.value);
      final currentDate = selectedDate.value;
      
      // Create target timezone DateTime
      final targetDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        targetTime.hour,
        targetTime.minute,
      );
      
      // Convert from target timezone to local timezone for scheduling
      final targetLocation = tz.getLocation(selectedTimezoneId.value);
      final localLocation = tz.getLocation(deviceTimezoneId.value);
      
      // Create proper TZDateTime in target timezone
      final targetTZDateTime = tz.TZDateTime(
        targetLocation,
        currentDate.year,
        currentDate.month,
        currentDate.day,
        targetTime.hour,
        targetTime.minute,
      );
      
      // Convert to local timezone for scheduling  
      final localTZDateTime = tz.TZDateTime.from(targetTZDateTime, localLocation);
      
      return DateTime(
        localTZDateTime.year,
        localTZDateTime.month,
        localTZDateTime.day,
        localTZDateTime.hour,
        localTZDateTime.minute,
      );
    } catch (e) {
      // Fallback to selected time if timezone conversion fails
      print('Error in timezone conversion for scheduling: $e');
      return selectedTime.value;
    }
  }

  int getTimezoneAwareIntervalToAlarm() {
    final alarmTime = getTimezoneAwareAlarmTime();
    return Utils.getMillisecondsToAlarm(DateTime.now(), alarmTime);
  }

  checkOverlayPermissionAndNavigate() async {
    if (!(await Permission.systemAlertWindow.isGranted) &&
        !(await Permission.ignoreBatteryOptimizations.isGranted)) {
      Get.defaultDialog(
        backgroundColor: themeController.secondaryBackgroundColor.value,
        title: 'Permission Required',
        titleStyle: TextStyle(
          color: themeController.primaryTextColor.value,
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
                      'IGNORE_BATTERY_OPTIMIZATION permission denied!',
                    );
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
        backgroundColor: themeController.secondaryBackgroundColor.value,
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
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Leave'.tr,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.red,
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
    if (await checkAndRequestPermission()) {
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

  Future<bool> checkAndRequestPermission({bool? background}) async {
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
        backgroundColor: themeController.secondaryBackgroundColor.value,
        barrierDismissible: false,
        title: 'Location Permission',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        titlePadding: const EdgeInsets.only(top: 30, right: 40),
        titleStyle: TextStyle(
          color: themeController.primaryTextColor.value,
        ),
        content: const Text(
          'To ensure timely alarm dismissal, this app requires access to your location. Your location will be accessed in the background at the scheduled alarm time.',
        ),
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
      alarmRecord.value =
          await FirestoreDb.addAlarm(userModel.value, alarmData);
    } else {
      alarmRecord.value = await isar.IsarDb.addAlarm(alarmData);
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
      backgroundColor: themeController.secondaryBackgroundColor.value,
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
                                color: themeController.secondaryTextColor.value,
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
                                color: themeController.secondaryTextColor.value,
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
                                  color:
                                      themeController.secondaryTextColor.value,
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
        backgroundColor: themeController.secondaryBackgroundColor.value,
        title: 'Camera Permission'.tr,
        titleStyle: TextStyle(
          color: themeController.primaryTextColor.value,
        ),
        titlePadding: const EdgeInsets.only(
          top: 25,
          left: 10,
        ),
        contentPadding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 23),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Please allow camera access to scan QR codes.'.tr,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
          child: Obx(
            () => Text(
              'OK',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: themeController.secondaryTextColor.value,
                  ),
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
        cancel: Obx(
          () => TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                themeController.primaryTextColor.value.withOpacity(0.5),
              ),
            ),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: themeController.primaryTextColor.value,
                  ),
            ),
            onPressed: () {
              Get.back(); // Close the alert box
            },
          ),
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
      
      bool isConversion = await isar.IsarDb.doesAlarmExist(alarmRecord.value.alarmID) && 
                         (alarmRecord.value.firestoreId == null || alarmRecord.value.firestoreId!.isEmpty);
      
      if (isConversion) {
        debugPrint('🔄 Converting normal alarm to shared alarm');
        
      
        try {
          await homeController.alarmChannel.invokeMethod('cancelAlarmById', {
            'alarmID': alarmRecord.value.alarmID,
            'isSharedAlarm': false,
          });
          debugPrint('🗑️ Canceled existing local alarm: ${alarmRecord.value.alarmID}');
        } catch (e) {
          debugPrint('⚠️ Error canceling local alarm: $e');
        }
        
      
        await isar.IsarDb.deleteAlarm(alarmRecord.value.isarId);
        debugPrint('🗑️ Deleted alarm from local database using isarId: ${alarmRecord.value.isarId}');
        
      
        alarmRecord.value = await FirestoreDb.addAlarm(userModel.value, alarmData);
        debugPrint('✅ Created new shared alarm in Firestore: ${alarmRecord.value.firestoreId}');
        
      } else if (alarmRecord.value.firestoreId != null && alarmRecord.value.firestoreId!.isNotEmpty) {
      
        debugPrint('📝 Updating existing shared alarm: ${alarmRecord.value.firestoreId}');
        
        alarmData.firestoreId = alarmRecord.value.firestoreId;
        
      
        try {
          await homeController.alarmChannel.invokeMethod('cancelAlarmById', {
            'alarmID': alarmData.firestoreId,
            'isSharedAlarm': true,
          });
          debugPrint('🗑️ Canceled existing shared alarm before update: ${alarmData.firestoreId}');
        } catch (e) {
          debugPrint('⚠️ Error canceling existing alarm (continuing anyway): $e');
        }
        
      
        await FirestoreDb.updateAlarm(alarmRecord.value.ownerId, alarmData);
        
      
        try {
          PushNotifications().triggerRescheduleAlarmNotification(alarmData.firestoreId!);
        } catch (e) {
          debugPrint('Push notification failed (this is ok): $e');
        }
        
      
        await FirestoreDb.triggerRescheduleUpdate(alarmData);
        
      
        try {
          await sendDirectNotificationToSharedUsers(alarmData);
        } catch (e) {
          debugPrint('Direct notification failed (this is ok): $e');
        }
        
      
        homeController.forceRefreshAfterAlarmUpdate(alarmData.firestoreId, true);
      } else {
      
        debugPrint('⚠️ Unexpected state: shared alarm enabled but no valid ID found');
        alarmRecord.value = await FirestoreDb.addAlarm(userModel.value, alarmData);
      }
    } else {
      
      bool isConversion = (alarmRecord.value.firestoreId != null && alarmRecord.value.firestoreId!.isNotEmpty) &&
                         !await isar.IsarDb.doesAlarmExist(alarmRecord.value.alarmID);
      
      if (isConversion) {
        debugPrint('🔄 Converting shared alarm to normal alarm');
        
      
        try {
          await homeController.alarmChannel.invokeMethod('cancelAlarmById', {
            'alarmID': alarmRecord.value.firestoreId,
            'isSharedAlarm': true,
          });
          debugPrint('🗑️ Canceled existing shared alarm: ${alarmRecord.value.firestoreId}');
        } catch (e) {
          debugPrint('⚠️ Error canceling shared alarm: $e');
        }
        
      
        await FirestoreDb.deleteAlarm(userModel.value, alarmRecord.value.firestoreId!);
        debugPrint('🗑️ Deleted alarm from Firestore');
        
      
        alarmRecord.value = await isar.IsarDb.addAlarm(alarmData);
        debugPrint('✅ Created new normal alarm in local database: ${alarmRecord.value.alarmID}');
        
      } else if (await isar.IsarDb.doesAlarmExist(alarmRecord.value.alarmID) == true) {
      
        debugPrint('📝 Updating existing normal alarm: ${alarmRecord.value.alarmID}');
        
        alarmData.isarId = alarmRecord.value.isarId;
        
      
        try {
          await homeController.alarmChannel.invokeMethod('cancelAlarmById', {
            'alarmID': alarmRecord.value.alarmID,
            'isSharedAlarm': false,
          });
          debugPrint('🗑️ Canceled existing local alarm before update: ${alarmRecord.value.alarmID}');
        } catch (e) {
          debugPrint('⚠️ Error canceling existing alarm (continuing anyway): $e');
        }
        
      
        await isar.IsarDb.updateAlarm(alarmData);
        
      
        homeController.forceRefreshAfterAlarmUpdate(alarmData.alarmID, false);
      } else {
      
        debugPrint('⚠️ Unexpected state: normal alarm but no valid local ID found');
        alarmRecord.value = await isar.IsarDb.addAlarm(alarmData);
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

    profileTextEditingController.text = homeController.isProfileUpdate.value
        ? homeController.selectedProfile.value
        : "";
    emailTextEditingController.text = '';

    if (Get.arguments != null) {
      alarmRecord.value = Get.arguments;
    }

    userModel.value = homeController.userModel.value;

    if (userModel.value != null) {
      userId.value = userModel.value!.id;
      userName.value = userModel.value!.fullName;
      lastEditedUserId.value = userModel.value!.id;
    }
    isar.IsarDb.loadDefaultRingtones();

    // listens to the userModel declared in homeController and updates on signup event
    homeController.userModel.stream.listen((UserModel? user) {
      userModel.value = user;
      if (user != null) {
        userId.value = user.id;
        userName.value = user.fullName;
        lastEditedUserId.value = user.id;
      }
    });

    if (Get.arguments != null || homeController.isProfile.value) {
      selectedDate.value = Utils.stringToDate(alarmRecord.value.alarmDate);
      isFutureDate.value =
          selectedDate.value.difference(DateTime.now()).inHours > 0;
      isGuardian.value = alarmRecord.value.isGuardian;
      guardian.value = alarmRecord.value.guardian;
      guardianTimer.value = alarmRecord.value.guardianTimer;
      isSunriseEnabled.value = alarmRecord.value.isSunriseEnabled;
      sunriseDuration.value = alarmRecord.value.sunriseDuration;
      sunriseIntensity.value = alarmRecord.value.sunriseIntensity;
      sunriseColorScheme.value = alarmRecord.value.sunriseColorScheme;
      
      // Initialize timezone values
      selectedTimezoneId.value = alarmRecord.value.timezoneId;
      isTimezoneEnabled.value = alarmRecord.value.isTimezoneEnabled;
      targetTimezoneOffset.value = alarmRecord.value.targetTimezoneOffset;
      
      // Initialize smart control combination type
      smartControlCombinationType.value = alarmRecord.value.smartControlCombinationType;
      isActivityMonitorenabled.value =
          alarmRecord.value.isActivityEnabled ? 1 : 0;
      snoozeDuration.value = alarmRecord.value.snoozeDuration;
      maxSnoozeCount.value = alarmRecord.value.maxSnoozeCount;
      gradient.value = alarmRecord.value.gradient;
      volMin.value = alarmRecord.value.volMin;
      volMax.value = alarmRecord.value.volMax;
      isOneTime.value = alarmRecord.value.isOneTime;
      deleteAfterGoesOff.value = alarmRecord.value.deleteAfterGoesOff;
      label.value = alarmRecord.value.label;
      customRingtoneName.value = alarmRecord.value.ringtoneName;
      note.value = alarmRecord.value.note;
      showMotivationalQuote.value = alarmRecord.value.showMotivationalQuote;

      sharedUserIds.value = alarmRecord.value.sharedUserIds!;
      // Reinitializing all values here
      selectedTime.value = Utils.timeOfDayToDateTime(
        Utils.stringToTimeOfDay(alarmRecord.value.alarmTime),
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

      repeatDays.value = alarmRecord.value.days;
      // Shows the selected days in UI
      daysRepeating.value = Utils.getRepeatDays(repeatDays);

      // Setting the old values for all the auto dismissal
      isActivityenabled.value = alarmRecord.value.isActivityEnabled;
      useScreenActivity.value = alarmRecord.value.isActivityEnabled;
      activityInterval.value = alarmRecord.value.activityInterval ~/ 60000;
      
      // Set activity condition type based on existing data
      if (alarmRecord.value.isActivityEnabled) {
        activityConditionType.value = ActivityConditionType.values[alarmRecord.value.activityConditionType];
      } else {
        activityConditionType.value = ActivityConditionType.off;
      }

      isLocationEnabled.value = alarmRecord.value.isLocationEnabled;
      // Set location condition type based on existing data
      if (alarmRecord.value.isLocationEnabled) {
        locationConditionType.value = LocationConditionType.values[alarmRecord.value.locationConditionType];
      } else {
        locationConditionType.value = LocationConditionType.off;
      }
      selectedPoint.value = Utils.stringToLatLng(alarmRecord.value.location);
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

      isWeatherEnabled.value = alarmRecord.value.isWeatherEnabled;
      
      if (alarmRecord.value.isWeatherEnabled) {
        weatherConditionType.value = WeatherConditionType.values[alarmRecord.value.weatherConditionType];
      } else {
        weatherConditionType.value = WeatherConditionType.off;
      }
      weatherTypes.value = Utils.getFormattedWeatherTypes(selectedWeather);

      isMathsEnabled.value = alarmRecord.value.isMathsEnabled;
      numMathsQuestions.value = alarmRecord.value.numMathsQuestions;
      mathsDifficulty.value =
          Difficulty.values[alarmRecord.value.mathsDifficulty];
      mathsSliderValue.value = alarmRecord.value.mathsDifficulty.toDouble();

      isShakeEnabled.value = alarmRecord.value.isShakeEnabled;
      shakeTimes.value = alarmRecord.value.shakeTimes;

      isPedometerEnabled.value = alarmRecord.value.isPedometerEnabled;
      numberOfSteps.value = alarmRecord.value.numberOfSteps;

      isQrEnabled.value = alarmRecord.value.isQrEnabled;
      qrValue.value = alarmRecord.value.qrValue;
      detectedQrValue.value = alarmRecord.value.qrValue;

      alarmID = alarmRecord.value.alarmID == ''
          ? const Uuid().v4()
          : alarmRecord.value.alarmID;

      // if alarmRecord is null or alarmRecord.ownerId is null,
      // then assign the current logged-in user as the owner.
      if (alarmRecord.value.ownerId.isEmpty) {
        ownerId.value = userId.value;
        ownerName.value = userName.value;
      } else {
        ownerId.value = alarmRecord.value.ownerId;
        ownerName.value = alarmRecord.value.ownerName;
      }

      mutexLock.value = alarmRecord.value.mutexLock;
      isSharedAlarmEnabled.value = alarmRecord.value.isSharedAlarmEnabled;

      if (isSharedAlarmEnabled.value) {
        selectedTime.value = Utils.timeOfDayToDateTime(
          Utils.stringToTimeOfDay(alarmRecord.value.mainAlarmTime!),
        );

        mainAlarmTime.value = Utils.timeOfDayToDateTime(
          Utils.stringToTimeOfDay(alarmRecord.value.mainAlarmTime!),
          );

        offsetDetails.value = alarmRecord.value.offsetDetails!;
      
          final userOffset = alarmRecord.value.offsetDetails!
      .firstWhereOrNull((entry) => entry['userId'] == userId);

      if (userOffset != null) {
        userOffsetDetails.value = userOffset;
        offsetDuration.value = userOffset['offsetDuration'];
        isOffsetBefore.value = userOffset['isOffsetBefore'];
      }
      }

      // Set lock only if its not locked
      if (isSharedAlarmEnabled.value == true &&
          alarmRecord.value.mutexLock == false) {
        alarmRecord.value.mutexLock = true;
        alarmRecord.value.lastEditedUserId = userModel.value!.id;
        await FirestoreDb.updateAlarm(
          userModel.value!.id,
          alarmRecord.value,
        );
        alarmRecord.value.mutexLock = false;
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
      'maxSnoozeCount': maxSnoozeCount.value,
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
      'isOffsetBefore': isOffsetBefore.value,
      'smartControlCombinationType': smartControlCombinationType.value,
    });

    addListeners();

    if (await SecureStorageProvider().retrieveApiKey(ApiKeys.openWeatherMap) !=
        null) {
      weatherApiKeyExists.value = true;
    }

    // If there's an argument sent, we are in update mode


    isTimePicker.value = true;
    initTimeTextField();
    
    // Initialize timezone functionality
    initializeTimezone();
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
          'location',
          '${point.latitude} ${point.longitude}',
        );
      },
    );

    
    locationConditionType.listen((value) {
      if (value == LocationConditionType.off) {
        isLocationEnabled.value = false;
        if (weatherTypes.value == 'Off') {
          selectedPoint.value = LatLng(0, 0);
        }
      } else {
        isLocationEnabled.value = true;
      }
    });

    setupListener<int>(shakeTimes, 'shakeTimes');
    setupListener<String>(qrValue, 'qrValue');
    setupListener<double>(mathsSliderValue, 'mathsSliderValue');
    setupListener<Difficulty>(mathsDifficulty, 'mathsDifficulty');
    setupListener<int>(numMathsQuestions, 'numMathsQuestions');
    setupListener<int>(numberOfSteps, 'numberOfSteps');

    setupListener<bool>(isSharedAlarmEnabled, 'isSharedAlarmEnabled');
    setupListener<LocationConditionType>(locationConditionType, 'locationConditionType');
    setupListener<WeatherConditionType>(weatherConditionType, 'weatherConditionType');
    setupListener<int>(offsetDuration, 'offsetDuration');
    setupListener<bool>(isOffsetBefore, 'isOffsetBefore');
    setupListener<int>(smartControlCombinationType, 'smartControlCombinationType');
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

    await SystemRingtoneService.stopSystemRingtone();
    playingSystemRingtoneUri.value = '';

    if (Get.arguments == null) {
      // Shared alarm was not suddenly enabled, so we can update doc
      // on firestore
      // We also make sure the doc was not already locked
      // If it was suddenly enabled, it will be created newly anyway
      if (isSharedAlarmEnabled.value == true &&
          alarmRecord.value.isSharedAlarmEnabled == true &&
          alarmRecord.value.mutexLock == false) {
        AlarmModel updatedModel = updatedAlarmModel();
        updatedModel.firestoreId = alarmRecord.value.firestoreId;
        await FirestoreDb.updateAlarm(updatedModel.ownerId, updatedModel);
      }
    }
    inputHrsController.dispose();
    inputMinutesController.dispose();
  }

  AlarmModel updatedAlarmModel() {
    String ownerId = '';
    String ownerName = '';

    // if alarmRecord is null or alarmRecord.ownerId is null,
    // then assign the current logged-in user as the owner.

    if (alarmRecord.value.ownerId.isEmpty) {
      ownerId = userId.value;
      ownerName = userName.value;
    } else {
      ownerId = alarmRecord.value.ownerId;
      ownerName = alarmRecord.value.ownerName;
    }

    
    debugPrint('🔔 Creating alarm with maxSnoozeCount: ${maxSnoozeCount.value}');
    return AlarmModel(
      snoozeDuration: snoozeDuration.value,
      maxSnoozeCount: maxSnoozeCount.value,
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
      lastEditedUserId: lastEditedUserId.value,
      mutexLock: mutexLock.value,
      alarmID: alarmID,
      ownerId: ownerId,
      ownerName: ownerName,
      activityInterval: activityInterval.value * 60000,
      days: repeatDays.toList(),
      alarmTime:
          Utils.timeOfDayToString(TimeOfDay.fromDateTime(getTimezoneAwareAlarmTime())),
      intervalToAlarm: getTimezoneAwareIntervalToAlarm(),
      isActivityEnabled: isActivityenabled.value,
      minutesSinceMidnight:
          Utils.timeOfDayToInt(TimeOfDay.fromDateTime(getTimezoneAwareAlarmTime())),
      isLocationEnabled: isLocationEnabled.value,
      locationConditionType: locationConditionType.value.index,
      weatherTypes: Utils.getIntFromWeatherTypes(selectedWeather.toList()),
      isWeatherEnabled: isWeatherEnabled.value,
      weatherConditionType: weatherConditionType.value.index,
      activityConditionType: activityConditionType.value.index,
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
      activityMonitor: isActivityMonitorenabled.value,
      alarmDate: selectedDate.value.toString().substring(0, 11),
      profile: homeController.selectedProfile.value,
      isGuardian: isGuardian.value,
      guardianTimer: guardianTimer.value,
      guardian: guardian.value,
      isCall: isCall.value,
      ringOn: isFutureDate.value,
      isSunriseEnabled: isSunriseEnabled.value,
      sunriseDuration: sunriseDuration.value,
      sunriseIntensity: sunriseIntensity.value,
      sunriseColorScheme: sunriseColorScheme.value,
      timezoneId: selectedTimezoneId.value,
      isTimezoneEnabled: isTimezoneEnabled.value,
      targetTimezoneOffset: targetTimezoneOffset.value,
      smartControlCombinationType: smartControlCombinationType.value,
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
            counterUpdate: CounterUpdate.decrement,
          );
          await isar.IsarDb.addCustomRingtone(customRingtone);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<String>> getAllCustomRingtoneNames() async {
    try {
      List<RingtoneModel> customRingtones =
          await isar.IsarDb.getAllCustomRingtones();

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
          await isar.IsarDb.getCustomRingtone(customRingtoneId: customRingtoneId);

      if (customRingtone != null) {
        int currentCounterOfUsage = customRingtone.currentCounterOfUsage;
        bool isSystemRingtone = customRingtone.isSystemRingtone;

        if (currentCounterOfUsage == 0 || isSystemRingtone) {
          customRingtoneNames.removeAt(ringtoneIndex);
          await isar.IsarDb.deleteCustomRingtone(ringtoneId: customRingtoneId);

          if (isSystemRingtone) {
            Get.snackbar(
              'System Ringtone Removed',
              'The system ringtone has been removed from your list.',
              margin: const EdgeInsets.all(15),
              animationDuration: const Duration(seconds: 1),
              snackPosition: SnackPosition.BOTTOM,
              barBlur: 15,
              colorText: kprimaryTextColor,
            );
          } else {
            final documentsDirectory = await getApplicationDocumentsDirectory();
            final ringtoneFilePath =
                '${documentsDirectory.path}/ringtones/$ringtoneName';

            if (await File(ringtoneFilePath).exists()) {
              await File(ringtoneFilePath).delete();
              Get.snackbar(
                'Ringtone Deleted',
                'The selected ringtone has been successfully deleted.',
                margin: const EdgeInsets.all(15),
                animationDuration: const Duration(seconds: 1),
                snackPosition: SnackPosition.BOTTOM,
                barBlur: 15,
                colorText: kprimaryTextColor,
              );
            } else {
              Get.snackbar(
                'Ringtone Not Found',
                'The selected ringtone does not exist and cannot be deleted.',
                margin: const EdgeInsets.all(15),
                animationDuration: const Duration(seconds: 1),
                snackPosition: SnackPosition.BOTTOM,
                barBlur: 15,
                colorText: kprimaryTextColor,
              );
            }
          }
        } else {
          Get.snackbar(
            'Ringtone in Use',
            'This ringtone cannot be deleted as it is currently assigned'
                ' to one or more alarms.',
            margin: const EdgeInsets.all(15),
            animationDuration: const Duration(seconds: 1),
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

  datePicker(BuildContext context) async {
    selectedDate.value = (await showDatePicker(
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: themeController.currentTheme.value == ThemeMode.light
                  ? ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: kprimaryColor,
                ),
              )
                  : ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: kprimaryColor,
                ),
              ),
              child: child!,
            );
          },
          context: context,
          currentDate: selectedDate.value,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 355)),
        )) ??
        DateTime.now();
    isFutureDate.value =
        selectedDate.value.difference(DateTime.now()).inHours > 0;
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
        backgroundColor: themeController.secondaryBackgroundColor.value,
        textColor: themeController.primaryTextColor.value,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createProfile() async {
    try {
      if (profileTextEditingController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Profile name cannot be empty',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
        );
        return;
      }

      bool exists = await isar.IsarDb.profileExists(profileTextEditingController.text.trim());
      if (exists) {
        Get.snackbar(
          'Error',
          'A profile with this name already exists',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
        );
        return;
      }

      profileModel = ProfileModel(
      profileName: profileTextEditingController.text,
      deleteAfterGoesOff: deleteAfterGoesOff.value,
      snoozeDuration: snoozeDuration.value,
      volMax: volMax.value,
      volMin: volMin.value,
      gradient: gradient.value,
      offsetDetails: offsetDetails,
      label: label.value,
      note: note.value,
      showMotivationalQuote: showMotivationalQuote.value,
      isOneTime: isOneTime.value,
      lastEditedUserId: lastEditedUserId.value,
      mutexLock: mutexLock.value,
      ownerId: ownerId.value,
      ownerName: ownerName.value,
      activityInterval: activityInterval.value * 60000,
      days: repeatDays.toList(),
      intervalToAlarm: Utils.getMillisecondsToAlarm(
        DateTime.now(),
        selectedTime.value,
      ),
      isActivityEnabled: isActivityenabled.value,
      minutesSinceMidnight: Utils.timeOfDayToInt(
        TimeOfDay.fromDateTime(
          selectedTime.value,
        ),
      ),
      isLocationEnabled: isLocationEnabled.value,
      weatherTypes: Utils.getIntFromWeatherTypes(
        selectedWeather.toList(),
      ),
      isWeatherEnabled: isWeatherEnabled.value,
      location: Utils.geoPointToString(
        Utils.latLngToGeoPoint(
          selectedPoint.value,
        ),
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
      activityMonitor: isActivityMonitorenabled.value,
      alarmDate: selectedDate.value.toString().substring(0, 11),
      isGuardian: isGuardian.value,
      guardianTimer: guardianTimer.value,
      guardian: guardian.value,
      isCall: isCall.value,
      ringOn: isFutureDate.value,
      isSunriseEnabled: isSunriseEnabled.value,
      sunriseDuration: sunriseDuration.value,
      sunriseIntensity: sunriseIntensity.value,
      sunriseColorScheme: sunriseColorScheme.value,
      );

      if (homeController.isProfileUpdate.value) {
        var profileId =
            await isar.IsarDb.profileId(homeController.selectedProfile.value);
        print(profileId);
        if (profileId != 'null') profileModel.isarId = profileId;
        print(profileModel.isarId);
        await isar.IsarDb.updateAlarmProfiles(profileTextEditingController.text);
      }

      await isar.IsarDb.addProfile(profileModel);
      homeController.selectedProfile.value = profileModel.profileName;
      storage.writeProfile(profileModel.profileName);
      homeController.writeProfileName(profileModel.profileName);

      Get.snackbar(
        'Success',
        'Profile created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
      );
    } catch (e) {
      debugPrint('Error creating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to create profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
      );
    }
  }

  Future<void> initializeSharedAlarmSettings() async {
    try {
      debugPrint('Initializing shared alarm settings...');
      
  
      if (userModel.value == null) {
        debugPrint('Cannot initialize shared alarm: User not logged in');
        throw Exception('User must be logged in to enable shared alarms');
      }
      
  
      if (ownerId.value.isEmpty) {
        ownerId.value = userModel.value!.id;
        ownerName.value = userModel.value!.fullName;
        debugPrint('Set owner: ${ownerName.value} (${ownerId.value})');
      }
      
  
      if (sharedUserIds.isEmpty) {
        sharedUserIds.value = [];
        debugPrint('Initialized empty shared users list');
      }
      
  
      if (offsetDetails.isEmpty || offsetDetails.first.isEmpty) {
        offsetDetails.value = [{
          'userId': userModel.value!.id,
          'offsetDuration': 0,
          'isOffsetBefore': true,
        }];
        debugPrint('Initialized offset details for user');
      }
      
  
      if (mainAlarmTime.value.difference(DateTime.now()).inMinutes <= 0) {
        mainAlarmTime.value = selectedTime.value;
        debugPrint('Set main alarm time: ${mainAlarmTime.value}');
      }
      
  
      final userOffset = offsetDetails.value
          .firstWhereOrNull((entry) => entry['userId'] == userModel.value!.id);
      
      if (userOffset != null) {
        userOffsetDetails.value = userOffset;
        offsetDuration.value = userOffset['offsetDuration'] ?? 0;
        isOffsetBefore.value = userOffset['isOffsetBefore'] ?? true;
      } else {
  
        Map<String, dynamic> newUserOffset = {
          'userId': userModel.value!.id,
          'offsetDuration': 0,
          'isOffsetBefore': true,
        };
        offsetDetails.value = [...offsetDetails.value, newUserOffset];
        userOffsetDetails.value = newUserOffset;
        offsetDuration.value = 0;
        isOffsetBefore.value = true;
      }
      
      debugPrint('✅ Shared alarm settings initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing shared alarm settings: $e');
  
      isSharedAlarmEnabled.value = false;
      rethrow;
    }
  }

  
  Future<void> sendDirectNotificationToSharedUsers(AlarmModel alarmData) async {
    if (alarmData.sharedUserIds == null || alarmData.sharedUserIds!.isEmpty) {
      debugPrint('No shared users to notify');
      return;
    }
    
    try {
      debugPrint('🔔 Sending direct notifications to ${alarmData.sharedUserIds!.length} shared users');
      debugPrint('   - Alarm time: ${alarmData.alarmTime}');
      debugPrint('   - Owner: ${alarmData.ownerName}');
      
  
      try {
        // Create shared item data for the notification
        final sharedItem = {
          'type': 'alarm',
          'AlarmName': alarmData.firestoreId,
          'owner': alarmData.ownerName ?? 'Someone',
          'alarmTime': alarmData.alarmTime
        };
        
        await PushNotifications().triggerSharedItemNotification(alarmData.sharedUserIds!, sharedItem: sharedItem);
        debugPrint('✅ Cloud function notification sent');
      } catch (e) {
        debugPrint('⚠️ Cloud function notification failed: $e');
      }
      
  
      for (String userId in alarmData.sharedUserIds!) {
        try {
          await FirebaseFirestore.instance
            .collection('userNotifications')
            .doc(userId)
            .collection('notifications')
            .add({
            'type': 'alarm_update',
            'title': 'Shared Alarm Updated! 🔔',
            'message': '${alarmData.ownerName ?? 'Someone'} updated the alarm time to ${alarmData.alarmTime}',
            'alarmId': alarmData.firestoreId,
            'newAlarmTime': alarmData.alarmTime,
            'ownerName': alarmData.ownerName,
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });
          debugPrint('✅ Firestore notification created for user: $userId');
        } catch (e) {
          debugPrint('⚠️ Failed to create Firestore notification for $userId: $e');
        }
      }
      
  

      try {
        await FirebaseFirestore.instance
          .collection('sharedAlarms')
          .doc(alarmData.firestoreId)
          .update({
          'lastNotificationSent': FieldValue.serverTimestamp(),
          'notificationMessage': '${alarmData.ownerName ?? 'Someone'} updated the alarm time to ${alarmData.alarmTime}',
        });
        debugPrint('✅ Updated shared alarm document with notification trigger');
      } catch (e) {
        debugPrint('⚠️ Failed to update alarm document: $e');
      }
      
      debugPrint('🎯 Direct notification process completed');
    } catch (e) {
      debugPrint('❌ Error in sendDirectNotificationToSharedUsers: $e');

    }
  }

  void changeDatePicker() {
    isTimePicker.value = !isTimePicker.value;
    if (isTimePicker.value) {
      initTimeTextField();
    }
  }
  
  void changePeriod(String period) {
    isAM.value = period == 'AM';
  }
  
  void confirmTimeInput() {
    setTime();
    changeDatePicker();
  }
  
  void toggleIfAtBoundary() {
    if (!settingsController.is24HrsEnabled.value) {
      final rawHourText = inputHrsController.text.trim();
      int newHour;
      try {
        newHour = int.parse(rawHourText);
      } catch (e) {
        debugPrint("toggleIfAtBoundary error parsing hour: $e");
        return;
      }

      if (newHour == 0) {
        newHour = 12;
      }
      if (_previousDisplayHour != null) {
        if ((_previousDisplayHour == 11 && newHour == 12) ||
            (_previousDisplayHour == 12 && newHour == 11)) {
          isAM.value = !isAM.value;
        }
      }
      _previousDisplayHour = newHour;
    }
  }
  
  void setTime() {
    selectedTime.value = selectedTime.value;
    toggleIfAtBoundary();

    try {
      int hour = int.parse(inputHrsController.text);
      if (!settingsController.is24HrsEnabled.value) {
        if (isAM.value) {
          if (hour == 12) hour = 0; 
        } else {
          if (hour != 12) hour = hour + 12;
        }
      }

      int minute = int.parse(inputMinutesController.text);
      final time = TimeOfDay(hour: hour, minute: minute);
      DateTime today = DateTime.now();
      DateTime tomorrow = today.add(const Duration(days: 1));

      bool isNextDay = (time.hour == today.hour && time.minute < today.minute) || (time.hour < today.hour);
      bool isNextMonth = isNextDay && (today.day > tomorrow.day);
      bool isNextYear = isNextMonth && (today.month > tomorrow.month);
      int day = isNextDay ? tomorrow.day : today.day;
      int month = isNextMonth ? tomorrow.month : today.month;
      int year = isNextYear ? tomorrow.year : today.year;
      selectedTime.value = DateTime(year, month, day, time.hour, time.minute);

      if (!settingsController.is24HrsEnabled.value) {
        if (selectedTime.value.hour == 0) {
          hours.value = 12;
        } else if (selectedTime.value.hour > 12) {
          hours.value = selectedTime.value.hour - 12;
        } else {
          hours.value = selectedTime.value.hour;
        }
      } else {
        hours.value = convert24(selectedTime.value.hour, meridiemIndex.value);
      }
      minutes.value = selectedTime.value.minute;
      if (selectedTime.value.hour >= 12) {
        meridiemIndex.value = 1;
      } else {
        meridiemIndex.value = 0;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  int convert24(int value, int meridiemIndex) {
    if (!settingsController.is24HrsEnabled.value) {
      if (meridiemIndex == 0) {
        if (value == 12) {
          value = value - 12;
        }
      } else {
        if (value != 12) {
          value = value + 12;
        }
      }
    }
    return value;
  }
  
  void initTimeTextField() {
    isAM.value = selectedTime.value.hour < 12;
    
    inputHrsController.text = settingsController.is24HrsEnabled.value
        ? selectedTime.value.hour.toString()
        : (selectedTime.value.hour == 0
            ? '12'
            : (selectedTime.value.hour > 12
                ? (selectedTime.value.hour - 12).toString()
                : selectedTime.value.hour.toString()));
    inputMinutesController.text = selectedTime.value.minute.toString().padLeft(2, '0');
  }

  int orderedCountryCode(Country countryA, Country countryB) {
    // `??` for null safety of 'dialCode'
    String dialCodeA = countryA.dialCode ?? '0';
    String dialCodeB = countryB.dialCode ?? '0';

    return int.parse(dialCodeA).compareTo(int.parse(dialCodeB));
  }
}

class LimitRange extends TextInputFormatter {
  LimitRange(this.minRange, this.maxRange) : assert(minRange < maxRange);
  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      if (newValue.text.isEmpty) {
        return newValue;
      }
      int value = int.parse(newValue.text);
      if (value < minRange) return TextEditingValue(text: minRange.toString());
      else if (value > maxRange) return TextEditingValue(text: maxRange.toString());
      return newValue;
    } catch (e) {
      debugPrint(e.toString());
      return newValue;
    }
  }
}