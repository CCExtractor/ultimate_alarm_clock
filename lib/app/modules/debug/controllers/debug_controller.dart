import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'dart:async';
import '../../../data/providers/isar_provider.dart';
import '../../../modules/settings/controllers/theme_controller.dart';
import '../../../modules/settings/controllers/settings_controller.dart';
import '../../../utils/utils.dart';
import '../../../utils/constants.dart';
import '../../../data/models/debug_model.dart';
import '../../../data/models/alarm_model.dart';

class DebugController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  final TextEditingController searchController = TextEditingController();
  
  var logs = <Map<String, dynamic>>[].obs;
  var filteredLogs = <Map<String, dynamic>>[].obs;
  var selectedLogLevel = Rxn<LogLevel>();
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  RxBool isDevMode = false.obs;
  
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchLogs();
    });
    
    isDevMode.value = settingsController.isDevMode.value;
  }

  @override
  void onClose() {
    _timer?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void toggleDevMode() {
    settingsController.toggleDevMode(!settingsController.isDevMode.value);
    isDevMode.value = settingsController.isDevMode.value;
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      final fetchedLogs = await IsarDb().getLogs();
      logs.value = fetchedLogs.reversed.toList();
      applyFilters();
      debugPrint('Debug screen: Successfully loaded ${fetchedLogs.length} logs');
    } catch (e) {
      debugPrint('Debug screen: Error loading logs: $e');
      Get.snackbar(
        'Error',
        'Error loading logs: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void applyFilters() {
    filteredLogs.value = logs.where((log) {
      bool matchesSearch = searchController.text.isEmpty ||
          log['Status'].toString().toLowerCase().contains(searchController.text.toLowerCase()) ||
          log['LogID'].toString().contains(searchController.text) ||
          Utils.getFormattedDate(DateTime.fromMillisecondsSinceEpoch(log['LogTime']))
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
      
      bool matchesLevel = selectedLogLevel.value == null;
      if (selectedLogLevel.value != null) {
        final status = log['Status'].toString().toLowerCase();
        debugPrint('Checking log: "$status" for level: ${selectedLogLevel.value}');
        
        switch (selectedLogLevel.value!) {
          case LogLevel.error:
            matchesLevel = status.contains('error');
            break;
          case LogLevel.warning:
            matchesLevel = status.contains('warning');
            break;
          case LogLevel.info:
            matchesLevel = !status.contains('error') && !status.contains('warning');
            break;
        }
        debugPrint('Matches level: $matchesLevel');
      }
      
      bool matchesDateRange = true;
      if (startDate.value != null && endDate.value != null) {
        final logTime = DateTime.fromMillisecondsSinceEpoch(log['LogTime']);
        final startOfDay = DateTime(startDate.value!.year, startDate.value!.month, startDate.value!.day);
        final endOfDay = DateTime(endDate.value!.year, endDate.value!.month, endDate.value!.day, 23, 59, 59);
        matchesDateRange = logTime.isAfter(startOfDay) && logTime.isBefore(endOfDay);
      }
      
      return matchesSearch && matchesLevel && matchesDateRange;
    }).toList();
    
    debugPrint('Total logs: ${logs.length}');
    debugPrint('Filtered logs: ${filteredLogs.length}');
    if (filteredLogs.isEmpty) {
      debugPrint('First few log statuses:');
      for (var i = 0; i < logs.length && i < 5; i++) {
        debugPrint('Log ${i + 1}: "${logs[i]['Status']}"');
      }
    }
  }

  Future<void> clearLogs() async {
    try {
      await IsarDb().clearLogs();
      logs.value = [];
      filteredLogs.value = [];
      Get.snackbar(
        'Success',
        'Logs cleared successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error clearing logs: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: startDate.value ?? DateTime.now().subtract(const Duration(days: 7)),
        end: endDate.value ?? DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kprimaryColor,
              onPrimary: Colors.white,
              surface: themeController.secondaryBackgroundColor.value,
              onSurface: themeController.primaryTextColor.value,
              background: themeController.primaryBackgroundColor.value,
              onBackground: themeController.primaryTextColor.value,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kprimaryColor,
              ),
            ),
            dialogBackgroundColor: themeController.secondaryBackgroundColor.value,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
      applyFilters();
    }
  }

  Color getLogLevelColor(String status) {
    status = status.toLowerCase();
    if (status.contains('error')) return Colors.red;
    if (status.contains('warning')) return Colors.orange;
    return Colors.green;
  }

  Future<Widget> getAlarmDetailsWidget(String? alarmID, String logMsg, String status, bool hasRung) async {
    
    String? effectiveAlarmID = alarmID;
    if (effectiveAlarmID == null || effectiveAlarmID.isEmpty) {
    
      final idMatch = RegExp(r'ID: (\d+)|alarmID: (\d+)').firstMatch(logMsg);
      if (idMatch != null) {
        effectiveAlarmID = idMatch.group(1) ?? idMatch.group(2);
      }
    }

    if (effectiveAlarmID == null || effectiveAlarmID.isEmpty) {
      debugPrint('No alarm ID found in log message: $logMsg');
      return const SizedBox.shrink();
    }

    try {
      debugPrint('Fetching alarm details for ID: $effectiveAlarmID');
      final alarm = await IsarDb.getAlarmByID(effectiveAlarmID);
      if (alarm == null) {
        debugPrint('No alarm found for ID: $effectiveAlarmID');
        return const SizedBox.shrink();
      }

      debugPrint('Found alarm: ${alarm.alarmID} with time: ${alarm.alarmTime}');

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            if (!logMsg.toLowerCase().contains('alarm deleted')) ...[
              const SizedBox(height: 10),
              Text(
                'Alarm Details:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Time: ${alarm.alarmTime}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              if (alarm.label.isNotEmpty)
                Text(
                  'Label: ${alarm.label}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              if (alarm.ringtoneName.isNotEmpty)
                Text(
                  'Ringtone: ${alarm.ringtoneName}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              if (alarm.note.isNotEmpty)
                Text(
                  'Notes: ${alarm.note}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              if (alarm.isMathsEnabled || alarm.isShakeEnabled || alarm.isQrEnabled || 
                  alarm.isPedometerEnabled || alarm.isLocationEnabled || alarm.isWeatherEnabled) ...[
                const SizedBox(height: 10),
                Text(
                  'Challenge Settings:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                if (alarm.isMathsEnabled)
                  Text(
                    'Math Challenge: Enabled',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                if (alarm.isShakeEnabled)
                  Text(
                    'Shake Challenge: Enabled',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                if (alarm.isQrEnabled)
                  Text(
                    'QR Challenge: Enabled',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                if (alarm.isPedometerEnabled)
                  Text(
                    'Pedometer Challenge: Enabled',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                if (alarm.isLocationEnabled)
                  Text(
                    'Location Challenge: Enabled',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                if (alarm.isWeatherEnabled) ...[
                  Text(
                    'Weather Condition: ${alarm.weatherTypes.map((type) {
                      switch (type) {
                        case 0: return 'Sunny';
                        case 1: return 'Cloudy';
                        case 2: return 'Rainy';
                        case 3: return 'Windy';
                        case 4: return 'Stormy';
                        default: return 'Unknown';
                      }
                    }).join(", ")}',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ],
            ],

            if (logMsg.toLowerCase().contains('alarm deleted')) ...[
              const SizedBox(height: 10),
              Text(
                'Deleted Alarm Details:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Time: ${logMsg.split(' ').last}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
            if (logMsg.toLowerCase().contains('alarm scheduled')) ...[
              const SizedBox(height: 10),
              Text(
                'Schedule Details:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Scheduled Time: ${logMsg.split(' ').last}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Status: ${status == 'SUCCESS' ? 'Successfully Scheduled' : 'Failed to Schedule'}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
            if (logMsg.toLowerCase().contains('alarm ringing')) ...[
              const SizedBox(height: 10),
              Text(
                'Ringing Details:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Ringing Time: ${logMsg.split(' ').last}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Status: ${status == 'SUCCESS' ? 'Successfully Ringing' : 'Failed to Ring'}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Has Rung: ${hasRung ? 'Yes' : 'No'}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
            
            if (settingsController.isDevMode.value) ...[
              const SizedBox(height: 10),
              Text(
                'DEV:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Alarm ID: ${alarm.alarmID}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Created At: ${Utils.getFormattedDate(DateTime.fromMillisecondsSinceEpoch(alarm.activityMonitor))}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Updated At: ${Utils.getFormattedDate(DateTime.fromMillisecondsSinceEpoch(alarm.activityMonitor))}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Is Active: ${alarm.isEnabled}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              if (alarm.isLocationEnabled)
                Text(
                  'Location: ${alarm.location}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              Text(
                'Is Recurring: ${!alarm.isOneTime}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              if (!alarm.isOneTime) ...[
                Text(
                  'Recurring Days: ${alarm.days.map((day) => day ? 'Enabled' : 'Disabled').join(", ")}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            
              if (logMsg.toLowerCase().contains('kotlin error') || logMsg.toLowerCase().contains('android error'))
                Text(
                  'Kotlin Error: ${logMsg.split('Error:').last.trim()}',
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
            ],
          ],
        ),
      );
    } catch (e) {
      debugPrint('Error loading alarm details: $e');
      return Text(
        'Error loading alarm details: $e',
        style: const TextStyle(color: Colors.red),
      );
    }
  }
} 