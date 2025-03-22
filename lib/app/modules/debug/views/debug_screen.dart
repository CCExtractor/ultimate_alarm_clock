import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../../../data/providers/isar_provider.dart';
import '../../../modules/settings/controllers/theme_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<DebugScreen> {
  List<Map<String, dynamic>> logs = [];
  Timer? _timer;
  ThemeController themeController = Get.find<ThemeController>();

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
    super.dispose();
  }

  Future<void> fetchLogs() async {
    try {
      final logs = await IsarDb().getLogs();
      setState(() {
        this.logs = logs.reversed.toList();
      });
      debugPrint('Debug screen: Successfully loaded ${logs.length} logs');
    } catch (e) {
      debugPrint('Debug screen: Error loading logs: $e');
      // Show error in UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading logs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      ),
      backgroundColor: themeController.primaryBackgroundColor.value,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: logs.isEmpty
            ? Center(
                child: Text(
                  'No logs available'.tr,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: themeController.primaryTextColor.value,
                      ),
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, _) {
                  return SizedBox(height: height * 0.02);
                },
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final logTime = DateTime.fromMillisecondsSinceEpoch(log['LogTime']);
                  final formattedTime = Utils.getFormattedDate(logTime);
                  final formattedHour = logTime.hour.toString().padLeft(2, '0');
                  final formattedMinute = logTime.minute.toString().padLeft(2, '0');

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
                              Text(
                                'LogID: ${log['LogID']}',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: themeController.primaryTextColor.value,
                                      fontWeight: FontWeight.bold,
                                    ),
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
    );
  }
}