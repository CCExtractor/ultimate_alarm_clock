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
  DebugView({super.key});

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: controller.themeController.primaryBackgroundColor.value,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alarm History'.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.themeController.primaryTextColor.value,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Obx(() => Text(
              '${controller.filteredLogs.length} logs',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: controller.themeController.primaryTextColor.value.withOpacity(0.7),
                  ),
            )),
          ],
        ),
        actions: [
          Obx(() => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: controller.isDevMode.value ? kprimaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.developer_mode,
                color: controller.isDevMode.value ? Colors.white : controller.themeController.primaryTextColor.value,
                size: 20,
              ),
            ),
            onPressed: controller.toggleDevMode,
            tooltip: controller.isDevMode.value ? 'Disable Developer Mode' : 'Enable Developer Mode',
          )),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: controller.themeController.primaryTextColor.value,
            ),
            onPressed: controller.fetchLogs,
            tooltip: 'Refresh Logs',
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: controller.themeController.primaryTextColor.value,
            ),
            color: controller.themeController.secondaryBackgroundColor.value,
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmation(context);
              } else if (value == 'export') {
                _showExportOptions(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, color: controller.themeController.primaryTextColor.value),
                    const SizedBox(width: 8),
                    Text('Export Logs', style: TextStyle(color: controller.themeController.primaryTextColor.value)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('Clear All Logs', style: TextStyle(color: controller.themeController.primaryTextColor.value)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: controller.themeController.primaryBackgroundColor.value,
      body: Column(
        children: [
          // Enhanced Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: controller.themeController.secondaryBackgroundColor.value,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: controller.themeController.primaryBackgroundColor.value,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: controller.themeController.primaryTextColor.value.withOpacity(0.1),
                    ),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (value) {
                      controller.applyFilters();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by alarm time, ID, message, or type...'.tr,
                      prefixIcon: Icon(
                        Icons.search,
                        color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
                      ),
                      suffixIcon: controller.searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
                              ),
                              onPressed: () {
                                controller.searchController.clear();
                                controller.applyFilters();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      hintStyle: TextStyle(
                        color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
                      ),
                    ),
                    style: TextStyle(
                      color: controller.themeController.primaryTextColor.value,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                                 // Filter Row
                 Row(
                   children: [
                     // Status Filter
                     Expanded(
                       flex: 3,
                       child: Obx(() => Container(
                        decoration: BoxDecoration(
                          color: controller.themeController.primaryBackgroundColor.value,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller.themeController.primaryTextColor.value.withOpacity(0.1),
                          ),
                        ),
                        child: DropdownButtonFormField<LogLevel>(
                          value: controller.selectedLogLevel.value,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: InputBorder.none,
                          ),
                          hint: Text(
                            'All Status',
                            style: TextStyle(
                              color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
                              fontSize: 14,
                            ),
                          ),
                          dropdownColor: controller.themeController.secondaryBackgroundColor.value,
                          style: TextStyle(
                            color: controller.themeController.primaryTextColor.value,
                            fontSize: 14,
                          ),
                          items: [
                            DropdownMenuItem<LogLevel>(
                              value: null,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('All Status'),
                                ],
                              ),
                            ),
                            ...LogLevel.values.map((level) {
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
                                  levelText = 'Success';
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
                          ],
                          onChanged: (value) {
                            controller.selectedLogLevel.value = value;
                            controller.applyFilters();
                          },
                        ),
                      )),
                    ),
                    const SizedBox(width: 8),
                    // Date Filter Button
                    Container(
                      decoration: BoxDecoration(
                        color: controller.themeController.primaryBackgroundColor.value,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.themeController.primaryTextColor.value.withOpacity(0.1),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: controller.themeController.primaryTextColor.value.withOpacity(0.7),
                          size: 20,
                        ),
                        onPressed: controller.selectDateRange,
                        tooltip: 'Filter by date range',
                      ),
                    ),
                  ],
                ),
                                 // Developer Mode Toggle Info
                 Obx(() => controller.isDevMode.value 
                   ? Container(
                       margin: const EdgeInsets.only(top: 12),
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: kprimaryColor.withOpacity(0.1),
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: kprimaryColor.withOpacity(0.3)),
                       ),
                       child: IntrinsicHeight(
                         child: Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Icon(Icons.developer_mode, color: kprimaryColor, size: 16),
                             const SizedBox(width: 8),
                             Expanded(
                               child: Text(
                                 'Developer mode is ON - showing technical logs',
                                 style: TextStyle(
                                   color: kprimaryColor,
                                   fontSize: 12,
                                   fontWeight: FontWeight.w500,
                                 ),
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                               ),
                             ),
                           ],
                         ),
                       ),
                     )
                   : const SizedBox.shrink()),
              ],
            ),
          ),
          // Enhanced Logs List
          Expanded(
            child: Obx(() {
              if (controller.filteredLogs.isEmpty) {
                return _buildEmptyState();
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.filteredLogs.length,
                itemBuilder: (context, index) {
                  final log = controller.filteredLogs[index];
                  return _buildLogCard(log, context);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: controller.themeController.primaryTextColor.value.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No alarm history found',
            style: TextStyle(
              color: controller.themeController.primaryTextColor.value.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create some alarms to see their history here',
            style: TextStyle(
              color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log, BuildContext context) {
    final logTime = DateTime.fromMillisecondsSinceEpoch(log['LogTime']);
    final formattedTime = Utils.getFormattedDate(logTime);
    final formattedHour = logTime.hour.toString().padLeft(2, '0');
    final formattedMinute = logTime.minute.toString().padLeft(2, '0');
    final status = log['Status'];
    final logType = log['LogType'];
    final message = log['Message'];
    final hasRung = log['HasRung'] ?? 0;
    final alarmID = log['AlarmID'];

    // Skip DEV logs if not in developer mode
    if (!controller.isDevMode.value && logType == 'DEV') {
      return const SizedBox.shrink();
    }

    // Parse message for better display
    final parsedMessage = _parseLogMessage(message);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: controller.themeController.secondaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(status).withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          backgroundColor: controller.themeController.secondaryBackgroundColor.value,
          collapsedBackgroundColor: controller.themeController.secondaryBackgroundColor.value,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: _buildStatusIcon(status, hasRung),
          title: _buildLogTitle(parsedMessage, logType),
          subtitle: _buildLogSubtitle(formattedTime, formattedHour, formattedMinute, alarmID),
          trailing: _buildLogTrailing(logType, status),
          children: [
            _buildLogDetails(parsedMessage, log, context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status, int hasRung) {
    IconData iconData;
    Color iconColor;
    
    if (hasRung == 1) {
      iconData = Icons.notifications_active;
      iconColor = Colors.blue;
    } else {
      switch (status) {
        case 'SUCCESS':
          iconData = Icons.check_circle;
          iconColor = Colors.green;
          break;
        case 'WARNING':
          iconData = Icons.warning;
          iconColor = Colors.orange;
          break;
        case 'ERROR':
          iconData = Icons.error;
          iconColor = Colors.red;
          break;
        default:
          iconData = Icons.info;
          iconColor = Colors.blue;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildLogTitle(Map<String, String> parsedMessage, String logType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                parsedMessage['title'] ?? parsedMessage['message'] ?? 'Unknown',
                style: TextStyle(
                  color: controller.themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (logType == 'DEV') ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kprimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'DEV',
                  style: TextStyle(
                    color: kprimaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (parsedMessage['subtitle'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              parsedMessage['subtitle']!,
              style: TextStyle(
                color: controller.themeController.primaryTextColor.value.withOpacity(0.7),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildLogSubtitle(String formattedTime, String formattedHour, String formattedMinute, String? alarmID) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 12,
            color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '$formattedHour:$formattedMinute • $formattedTime',
              style: TextStyle(
                color: controller.themeController.primaryTextColor.value.withOpacity(0.6),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (alarmID != null && alarmID.isNotEmpty) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.tag,
              size: 12,
              color: controller.themeController.primaryTextColor.value.withOpacity(0.5),
            ),
            const SizedBox(width: 4),
            Text(
              alarmID.length > 6 ? '${alarmID.substring(0, 6)}...' : alarmID,
              style: TextStyle(
                color: controller.themeController.primaryTextColor.value.withOpacity(0.6),
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogTrailing(String logType, String status) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: _getStatusColor(status),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogDetails(Map<String, String> parsedMessage, Map<String, dynamic> log, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: controller.themeController.primaryBackgroundColor.value.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full message
          Text(
            'Details',
            style: TextStyle(
              color: controller.themeController.primaryTextColor.value,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: controller.themeController.secondaryBackgroundColor.value,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: controller.themeController.primaryTextColor.value.withOpacity(0.1),
              ),
            ),
            child: Text(
              log['Message'],
              style: TextStyle(
                color: controller.themeController.primaryTextColor.value,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
                     // Technical details
           SingleChildScrollView(
             scrollDirection: Axis.horizontal,
             child: Row(
               children: [
                 _buildDetailChip('Log ID', log['LogID'].toString()),
                 const SizedBox(width: 8),
                 _buildDetailChip('Type', log['LogType']),
                 if (log['AlarmID'] != null && log['AlarmID'].toString().isNotEmpty) ...[
                   const SizedBox(width: 8),
                   _buildDetailChip('Alarm ID', log['AlarmID'].toString().length > 8 
                     ? '${log['AlarmID'].toString().substring(0, 8)}...' 
                     : log['AlarmID'].toString()),
                 ],
                 if (log['HasRung'] == 1) ...[
                   const SizedBox(width: 8),
                   _buildDetailChip('Status', 'Actually Rang', color: Colors.blue),
                 ],
               ],
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(String label, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? controller.themeController.primaryTextColor.value).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color ?? controller.themeController.primaryTextColor.value,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Map<String, String> _parseLogMessage(String message) {
    final result = <String, String>{};
    
    // Parse different message types
    if (message.contains('🔔 RINGING')) {
      final parts = message.split(' - ');
      result['title'] = parts[0]; // "🔔 RINGING SHARED ALARM"
      if (parts.length > 1) {
        final details = parts[1];
        final timeMatch = RegExp(r'⏰ Time: ([^,]+)').firstMatch(details);
        final labelMatch = RegExp(r'📝 Label: "([^"]+)"').firstMatch(details);
        final noteMatch = RegExp(r'💬 Note: "([^"]+)"').firstMatch(details);
        
        if (labelMatch != null) {
          result['subtitle'] = 'Label: ${labelMatch.group(1)}';
        } else if (noteMatch != null) {
          result['subtitle'] = 'Note: ${noteMatch.group(1)}';
        } else if (timeMatch != null) {
          result['subtitle'] = 'Time: ${timeMatch.group(1)}';
        }
      }
    } else if (message.contains('CREATED') || message.contains('UPDATED') || message.contains('DELETED') || message.contains('SCHEDULED')) {
      final parts = message.split(' - ');
      result['title'] = parts[0];
      if (parts.length > 1) {
        final timeMatch = RegExp(r'Time: ([^,]+)').firstMatch(parts[1]);
        final labelMatch = RegExp(r'Label: "([^"]+)"').firstMatch(parts[1]);
        
        if (labelMatch != null) {
          result['subtitle'] = 'Label: ${labelMatch.group(1)}';
        } else if (timeMatch != null) {
          result['subtitle'] = 'Time: ${timeMatch.group(1)}';
        }
      }
    } else {
      // Simple message
      result['message'] = message;
      if (message.length > 50) {
        result['title'] = '${message.substring(0, 50)}...';
      } else {
        result['title'] = message;
      }
    }
    
    return result;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SUCCESS':
        return Colors.green;
      case 'WARNING':
        return Colors.orange;
      case 'ERROR':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _showClearConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: controller.themeController.secondaryBackgroundColor.value,
        title: Text(
          'Clear All Logs',
          style: TextStyle(color: controller.themeController.primaryTextColor.value),
        ),
        content: Text(
          'Are you sure you want to clear all alarm history? This action cannot be undone.',
          style: TextStyle(color: controller.themeController.primaryTextColor.value),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearLogs();
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: controller.themeController.secondaryBackgroundColor.value,
        title: Text(
          'Export Logs',
          style: TextStyle(color: controller.themeController.primaryTextColor.value),
        ),
        content: Text(
          'Export functionality coming soon! You will be able to export logs as CSV or JSON.',
          style: TextStyle(color: controller.themeController.primaryTextColor.value),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}