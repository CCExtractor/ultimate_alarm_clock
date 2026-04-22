import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'dart:async';
import '../../../data/providers/isar_provider.dart';
import '../../../modules/settings/controllers/theme_controller.dart';
import '../../../utils/utils.dart';
import '../../../utils/constants.dart';
import '../../../data/models/debug_model.dart';

class DebugController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();
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
  }

  @override
  void onClose() {
    _timer?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void toggleDevMode() {
    isDevMode.value = !isDevMode.value;
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      final fetchedLogs = await IsarDb().getLogs();
      logs.value = fetchedLogs.reversed.toList();
      applyFilters();
      debugPrint('Alarm History: Successfully loaded ${fetchedLogs.length} history entries');
    } catch (e) {
      debugPrint('Alarm History: Error loading history: $e');
      Get.snackbar(
        'Error',
        'Error loading alarm history: $e',
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
        'Alarm history cleared successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error clearing alarm history: $e',
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
} 