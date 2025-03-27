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
        Text(
          'Label: ${alarm.label}',
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        Text(
          'Ringtone: ${alarm.ringtoneName}',
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        if (alarm.note.isNotEmpty)
          Text(
            'Note: ${alarm.note}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        if (alarm.isGuardian)
          Text(
            'Guardian Mode: Enabled',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        if (alarm.isMathsEnabled)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Math Challenge: Enabled',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Difficulty: ${Utils.getDifficultyLabel(Utils.getDifficulty(alarm.mathsDifficulty.toDouble()))}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              Text(
                'Questions: ${alarm.numMathsQuestions}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        if (alarm.isShakeEnabled)
          Text(
            'Shake Challenge: Enabled (${alarm.shakeTimes} shakes)',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        if (alarm.isQrEnabled)
          Text(
            'QR Challenge: Enabled',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        if (alarm.isPedometerEnabled)
          Text(
            'Step Challenge: Enabled (${alarm.numberOfSteps} steps)',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        if (alarm.isLocationEnabled)
          Text(
            'Location Challenge: Enabled',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        if (alarm.isWeatherEnabled)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Weather Condition: Enabled',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Selected Conditions: ${Utils.getFormattedWeatherTypes(Utils.getWeatherTypesFromInt(alarm.weatherTypes))}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
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