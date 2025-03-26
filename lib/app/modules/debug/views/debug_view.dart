import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../../../data/providers/isar_provider.dart';
import '../../../modules/settings/controllers/theme_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../controllers/debug_controller.dart';
import '../../../data/models/debug_model.dart';

class DebugView extends GetView<DebugController> {
  const DebugView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: controller.themeController.secondaryBackgroundColor.value,
        title: Text(
          'Debug Logs'.tr,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: controller.themeController.primaryTextColor.value,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchLogs,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: controller.clearLogs,
          ),
        ],
      ),
      backgroundColor: controller.themeController.primaryBackgroundColor.value,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: controller.searchController,
                  onChanged: (value) {
                    controller.applyFilters();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by ID (e.g., 1, 2, 3) or message...'.tr,
                    prefixIcon: Icon(
                      Icons.search,
                      color: controller.themeController.primaryTextColor.value.withOpacity(0.75),
                    ),
                    suffixIcon: controller.searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: controller.themeController.primaryTextColor.value.withOpacity(0.75),
                            ),
                            onPressed: () {
                              controller.searchController.clear();
                              controller.applyFilters();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: controller.themeController.secondaryBackgroundColor.value,
                    hintStyle: TextStyle(
                      color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
                    ),
                    helperText: 'Search by ID, message, or date (e.g., "1" for LogID 1)'.tr,
                    helperStyle: TextStyle(
                      color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: controller.themeController.primaryTextColor.value,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => DropdownButtonFormField<LogLevel>(
                            value: controller.selectedLogLevel.value,
                            decoration: InputDecoration(
                              hintText: 'Filter by log level'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: controller.themeController.secondaryBackgroundColor.value,
                              hintStyle: TextStyle(
                                color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
                              ),
                            ),
                            dropdownColor: controller.themeController.secondaryBackgroundColor.value,
                            style: TextStyle(
                              color: controller.themeController.primaryTextColor.value,
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
                              controller.selectedLogLevel.value = value;
                              controller.applyFilters();
                            },
                          )),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: controller.themeController.secondaryBackgroundColor.value,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: controller.themeController.primaryTextColor.value.withOpacity(0.75),
                        ),
                        onPressed: controller.selectDateRange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => controller.filteredLogs.isEmpty
                ? Center(
                    child: Text(
                      'No logs available'.tr,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: controller.themeController.primaryTextColor.value,
                          ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (context, _) {
                      return SizedBox(height: height * 0.02);
                    },
                    itemCount: controller.filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = controller.filteredLogs[index];
                      final logTime = DateTime.fromMillisecondsSinceEpoch(log['LogTime']);
                      final formattedTime = Utils.getFormattedDate(logTime);
                      final formattedHour = logTime.hour.toString().padLeft(2, '0');
                      final formattedMinute = logTime.minute.toString().padLeft(2, '0');
                      final logLevelColor = controller.getLogLevelColor(log['Status']);

                      return Container(
                        width: width * 0.91,
                        decoration: Utils.getCustomTileBoxDecoration(
                          isLightMode: controller.themeController.currentTheme.value == ThemeMode.light,
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
                                              color: controller.themeController.primaryTextColor.value,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$formattedHour:$formattedMinute',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: controller.themeController.primaryTextColor.value.withOpacity(0.75),
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formattedTime,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                log['Status'],
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: controller.themeController.primaryTextColor.value,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }
}