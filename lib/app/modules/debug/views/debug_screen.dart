import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../../../data/providers/isar_provider.dart';
import '../../../modules/settings/controllers/theme_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';

enum LogLevel { error, warning, info }

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<DebugScreen> {
  List<Map<String, dynamic>> logs = [];
  List<Map<String, dynamic>> filteredLogs = [];
  Timer? _timer;
  ThemeController themeController = Get.find<ThemeController>();
  final TextEditingController _searchController = TextEditingController();
  LogLevel? _selectedLogLevel;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    fetchLogs();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchLogs();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchLogs() async {
    try {
      final logs = await IsarDb().getLogs();
      setState(() {
        this.logs = logs.reversed.toList();
        applyFilters();
      });
      debugPrint('Debug screen: Successfully loaded ${logs.length} logs');
    } catch (e) {
      debugPrint('Debug screen: Error loading logs: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading logs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void applyFilters() {
    filteredLogs = logs.where((log) {
      bool matchesSearch = _searchController.text.isEmpty ||
          log['Status'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
          log['LogID'].toString().contains(_searchController.text) ||
          Utils.getFormattedDate(DateTime.fromMillisecondsSinceEpoch(log['LogTime']))
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      
      bool matchesLevel = _selectedLogLevel == null;
      if (_selectedLogLevel != null) {
        final status = log['Status'].toString().toLowerCase();
        debugPrint('Checking log: "$status" for level: ${_selectedLogLevel}');
        
        switch (_selectedLogLevel!) {
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
      if (_startDate != null && _endDate != null) {
        final logTime = DateTime.fromMillisecondsSinceEpoch(log['LogTime']);
        final startOfDay = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
        final endOfDay = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
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

  Future<void> _clearLogs() async {
    try {
      await IsarDb().clearLogs();
      setState(() {
        logs = [];
        filteredLogs = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logs cleared successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error clearing logs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _startDate ?? DateTime.now().subtract(const Duration(days: 7)),
        end: _endDate ?? DateTime.now(),
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
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        applyFilters();
      });
    }
  }

  Color _getLogLevelColor(String status) {
    status = status.toLowerCase();
    if (status.contains('error')) return Colors.red;
    if (status.contains('warning')) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.secondaryBackgroundColor.value,
        title: Text(
          'Debug Logs'.tr,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: themeController.primaryTextColor.value,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchLogs,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearLogs,
          ),
        ],
      ),
      backgroundColor: themeController.primaryBackgroundColor.value,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      applyFilters();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by ID (e.g., 1, 2, 3) or message...'.tr,
                    prefixIcon: Icon(
                      Icons.search,
                      color: themeController.primaryTextColor.value.withOpacity(0.75),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: themeController.primaryTextColor.value.withOpacity(0.75),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                applyFilters();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: themeController.secondaryBackgroundColor.value,
                    hintStyle: TextStyle(
                      color: themeController.primaryTextColor.value.withOpacity(0.5),
                    ),
                    helperText: 'Search by ID, message, or date (e.g., "1" for LogID 1)'.tr,
                    helperStyle: TextStyle(
                      color: themeController.primaryTextColor.value.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: themeController.primaryTextColor.value,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<LogLevel>(
                        value: _selectedLogLevel,
                        decoration: InputDecoration(
                          hintText: 'Filter by log level'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: themeController.secondaryBackgroundColor.value,
                          hintStyle: TextStyle(
                            color: themeController.primaryTextColor.value.withOpacity(0.5),
                          ),
                        ),
                        dropdownColor: themeController.secondaryBackgroundColor.value,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                        ),
                        items: LogLevel.values.map((level) {
                          Color levelColor;
                          String levelText;
                          switch (level) {
                            case LogLevel.error:
                              levelColor = Colors.red;
                              levelText = 'Error';
                              break;
                            case LogLevel.warning:
                              levelColor = Colors.orange;
                              levelText = 'Warning';
                              break;
                            case LogLevel.info:
                              levelColor = Colors.green;
                              levelText = 'Info';
                              break;
                          }
                          return DropdownMenuItem(
                            value: level,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: levelColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(levelText),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLogLevel = value;
                            applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: themeController.secondaryBackgroundColor.value,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: themeController.primaryTextColor.value.withOpacity(0.75),
                        ),
                        onPressed: _selectDateRange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredLogs.isEmpty
                ? Center(
                    child: Text(
                      'No logs available'.tr,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: themeController.primaryTextColor.value,
                          ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (context, _) {
                      return SizedBox(height: height * 0.02);
                    },
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      final logTime = DateTime.fromMillisecondsSinceEpoch(log['LogTime']);
                      final formattedTime = Utils.getFormattedDate(logTime);
                      final formattedHour = logTime.hour.toString().padLeft(2, '0');
                      final formattedMinute = logTime.minute.toString().padLeft(2, '0');
                      final logLevelColor = _getLogLevelColor(log['Status']);

                      return Container(
                        width: width * 0.91,
                        decoration: Utils.getCustomTileBoxDecoration(
                          isLightMode: themeController.currentTheme.value == ThemeMode.light,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: logLevelColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'LogID: ${log['LogID']}',
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                              color: themeController.primaryTextColor.value,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$formattedHour:$formattedMinute',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: themeController.primaryTextColor.value.withOpacity(0.75),
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formattedTime,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: themeController.primaryTextColor.value.withOpacity(0.5),
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                log['Status'],
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: themeController.primaryTextColor.value,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}