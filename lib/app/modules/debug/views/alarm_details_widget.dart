import 'package:flutter/material.dart';
import '../../../data/models/alarm_model.dart';
import '../../../utils/utils.dart';
import '../../../modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

class AlarmDetailsWidget extends StatelessWidget {
  final AlarmModel alarm;
  final String logMsg;
  final String status;
  final bool hasRung;

  const AlarmDetailsWidget({
    Key? key,
    required this.alarm,
    required this.logMsg,
    required this.status,
    required this.hasRung,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
        if (!logMsg.toLowerCase().contains('alarm deleted')) ...[
          const SizedBox(height: 10),
          Text(
            logMsg.toLowerCase().contains('alarm scheduled') ? 'Schedule Details:' : 'Ringing Details:',
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
          Text(
            'Status: ${status == 'SUCCESS' ? (logMsg.toLowerCase().contains('alarm scheduled') ? 'Successfully Scheduled' : 'Successfully Ringing') : (logMsg.toLowerCase().contains('alarm scheduled') ? 'Failed to Schedule' : 'Failed to Ring')}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (!logMsg.toLowerCase().contains('alarm scheduled')) Text(
            'Has Rung: ${hasRung ? 'Yes' : 'No'}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (alarm.label.isNotEmpty) Text(
            'Label: ${alarm.label}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (alarm.ringtoneName.isNotEmpty) Text(
            'Ringtone: ${alarm.ringtoneName}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (alarm.note.isNotEmpty) Text(
            'Note: ${alarm.note}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (alarm.isGuardian) Text(
            'Guardian Mode: ${logMsg.toLowerCase().contains('alarm scheduled') ? 'Enabled' : 'Active'}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (alarm.isOneTime) Text(
            'Type: One-time Alarm',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (!alarm.isOneTime) Text(
            'Type: Recurring (${alarm.days.asMap().entries.where((e) => e.value).map((e) => ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][e.key]).join(', ')})',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (Utils.isChallengeEnabled(alarm)) ...[
            const SizedBox(height: 5),
            Text(
              'Challenges Required:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (alarm.isMathsEnabled) Text(
              '• Math (${alarm.numMathsQuestions} questions, ${Utils.getDifficultyLabel(Utils.getDifficulty(alarm.mathsDifficulty.toDouble()))} difficulty)',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            if (alarm.isShakeEnabled) Text(
              '• Shake (${alarm.shakeTimes} shakes)',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            if (alarm.isQrEnabled) Text(
              '• QR Code Scan',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            if (alarm.isPedometerEnabled) Text(
              '• Steps (${alarm.numberOfSteps} steps)',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            if (alarm.isLocationEnabled) Text(
              '• Location Check',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            if (alarm.isWeatherEnabled) Text(
              '• Weather (${Utils.getFormattedWeatherTypes(Utils.getWeatherTypesFromInt(alarm.weatherTypes))})',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ],
        if (settingsController.isDevMode.value && !logMsg.toLowerCase().contains('alarm deleted')) ...[
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
            'AlarmID: ${alarm.alarmID}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'FirestoreID: ${alarm.firestoreId ?? "N/A"}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'OwnerID: ${alarm.ownerId}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'OwnerName: ${alarm.ownerName}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'LastEditedBy: ${alarm.lastEditedUserId}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'IsOneTime: ${alarm.isOneTime}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'DeleteAfterGoesOff: ${alarm.deleteAfterGoesOff}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'ShowMotivationalQuote: ${alarm.showMotivationalQuote}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'Volume Range: ${alarm.volMin} - ${alarm.volMax}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'Activity Monitor: ${alarm.activityMonitor}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'Activity Interval: ${alarm.activityInterval}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'IsShared: ${alarm.isSharedAlarmEnabled}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          if (alarm.sharedUserIds != null && alarm.sharedUserIds!.isNotEmpty)
            Text(
              'Shared Users: ${alarm.sharedUserIds!.join(", ")}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
        ],
      ],
    );
  }
} 