import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<void> exportLogs({required String format}) async {
    try {
      final logsToExport = await IsarDb().getLogs();
      if (logsToExport.isEmpty) {
        Get.snackbar(
          'Export',
          'No logs to export',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final hasPermission = await _ensureStoragePermission();
      if (!hasPermission && Platform.isAndroid) {
        Get.snackbar(
          'Export',
          'Storage permission is required to save in Downloads',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final directory = await _resolveDownloadDirectory();
      if (directory == null) {
        Get.snackbar(
          'Export',
          'Unable to access Downloads folder',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final extension = format.toLowerCase() == 'json' ? 'json' : 'csv';
      final filePath =
          '${directory.path}/alarm_history_$timestamp.$extension';

      final file = File(filePath);
      if (extension == 'json') {
        final payload = _buildJsonPayload(logsToExport);
        await file.writeAsString(payload);
      } else {
        final payload = _buildCsvPayload(logsToExport);
        await file.writeAsString(payload);
      }

      Get.snackbar(
        'Export',
        'Saved to ${file.path}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Export',
        'Failed to export logs: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> _ensureStoragePermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final manageStatus = await Permission.manageExternalStorage.request();
    if (manageStatus.isGranted) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<Directory?> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      final publicDownloads = Directory('/storage/emulated/0/Download');
      if (await publicDownloads.exists()) {
        return publicDownloads;
      }

      final appDownloads = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      if (appDownloads != null && appDownloads.isNotEmpty) {
        return appDownloads.first;
      }
    }

    return getApplicationDocumentsDirectory();
  }

  String _buildJsonPayload(List<Map<String, dynamic>> logsToExport) {
    final normalized = logsToExport.map((log) {
      final logTime = log['LogTime'];
      DateTime? logTimeValue;
      if (logTime is int) {
        logTimeValue = DateTime.fromMillisecondsSinceEpoch(logTime);
      }
      return {
        ...log,
        'LogTimeIso': logTimeValue?.toIso8601String(),
      };
    }).toList();

    return const JsonEncoder.withIndent('  ').convert(normalized);
  }

  String _buildCsvPayload(List<Map<String, dynamic>> logsToExport) {
    const headers = [
      'LogID',
      'LogTimeEpoch',
      'LogTimeIso',
      'Status',
      'LogType',
      'Message',
      'HasRung',
      'AlarmID',
    ];

    final buffer = StringBuffer();
    buffer.writeln(headers.join(','));

    for (final log in logsToExport) {
      final logTime = log['LogTime'];
      DateTime? logTimeValue;
      if (logTime is int) {
        logTimeValue = DateTime.fromMillisecondsSinceEpoch(logTime);
      }

      final row = [
        log['LogID'],
        logTime,
        logTimeValue?.toIso8601String() ?? '',
        log['Status'] ?? '',
        log['LogType'] ?? '',
        log['Message'] ?? '',
        log['HasRung'] ?? 0,
        log['AlarmID'] ?? '',
      ].map(_csvEscape).join(',');

      buffer.writeln(row);
    }

    return buffer.toString();
  }

  String _csvEscape(dynamic value) {
    final text = (value ?? '').toString();
    final escaped = text.replaceAll('"', '""');
    return '"$escaped"';
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