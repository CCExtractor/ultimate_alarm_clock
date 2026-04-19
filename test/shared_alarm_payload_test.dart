import 'package:flutter_test/flutter_test.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/modules/notifications/controllers/notifications_controller.dart';

void main() {
  group('AlarmModel.fromMap backward compatibility', () {
    test('parses full payload without losing key fields', () {
      final payload = <String, dynamic>{
        'alarmID': 'alarm-123',
        'alarmTime': '07:45',
        'minutesSinceMidnight': 465,
        'isEnabled': true,
        'isLocationEnabled': true,
        'isSharedAlarmEnabled': true,
        'isWeatherEnabled': true,
        'isMathsEnabled': true,
        'isShakeEnabled': true,
        'isQrEnabled': false,
        'isPedometerEnabled': true,
        'intervalToAlarm': 1200,
        'isActivityEnabled': true,
        'location': '12.34,56.78',
        'activityInterval': 5,
        'days': [true, false, true, false, true, false, false],
        'weatherTypes': [0, 2],
        'shakeTimes': 3,
        'numberOfSteps': 100,
        'numMathsQuestions': 2,
        'mathsDifficulty': 1,
        'qrValue': 'abc',
        'sharedUserIds': ['user-1'],
        'ownerId': 'owner-1',
        'ownerName': 'Owner',
        'lastEditedUserId': 'editor-1',
        'mutexLock': false,
        'label': 'Wake up',
        'isOneTime': false,
        'snoozeDuration': 10,
        'maxSnoozeCount': 4,
        'gradient': 2,
        'ringtoneName': 'Digital Alarm 1',
        'note': 'Important',
        'deleteAfterGoesOff': false,
        'showMotivationalQuote': true,
        'volMin': 0.2,
        'volMax': 0.8,
        'activityMonitor': 1,
        'alarmDate': '2026-04-19',
        'profile': 'Default',
        'isGuardian': true,
        'guardianTimer': 30,
        'guardian': '+1234',
        'isCall': true,
        'ringOn': true,
        'offsetDetails': {
          'user-1': {
            'offsetDuration': 0,
            'offsettedTime': '07:45',
            'isOffsetBefore': true,
          }
        },
      };

      final alarm = AlarmModel.fromMap(payload);

      expect(alarm.alarmID, 'alarm-123');
      expect(alarm.alarmTime, '07:45');
      expect(alarm.label, 'Wake up');
      expect(alarm.ringtoneName, 'Digital Alarm 1');
      expect(alarm.snoozeDuration, 10);
      expect(alarm.maxSnoozeCount, 4);
      expect(alarm.days, [true, false, true, false, true, false, false]);
      expect(alarm.weatherTypes, [0, 2]);
      expect(alarm.isSharedAlarmEnabled, isTrue);
    });

    test('uses safe defaults for legacy partial payload', () {
      final legacyPayload = <String, dynamic>{
        'alarmID': 'legacy-id',
        'alarmTime': '06:00',
      };

      final alarm = AlarmModel.fromMap(legacyPayload);

      expect(alarm.alarmID, 'legacy-id');
      expect(alarm.alarmTime, '06:00');
      expect(alarm.label, '');
      expect(alarm.days.length, 7);
      expect(alarm.snoozeDuration, 0);
      expect(alarm.ringtoneName, 'Digital Alarm 1');
      expect(alarm.sharedUserIds, isEmpty);
    });
  });

  group('Notifications shared alarm payload helpers', () {
    test('reads embedded alarm payload and summary fields', () {
      final notification = <String, dynamic>{
        'type': 'alarm',
        'alarmTime': '08:10',
        'alarmLabel': 'Backup label',
        'alarmRepeat': 'Weekdays',
        'alarmData': {
          'alarmTime': '08:15',
          'label': 'Team standup',
          'days': [true, true, true, true, true, false, false],
        },
      };

      final payload = NotificationsController.parseAlarmPayload(notification);

      expect(payload, isNotNull);
      expect(NotificationsController.getAlarmTime(notification), '08:15');
      expect(NotificationsController.getAlarmLabel(notification), 'Team standup');
      expect(NotificationsController.getAlarmRepeat(notification), 'Weekdays');
    });

    test('falls back to top-level fields when embedded payload missing', () {
      final notification = <String, dynamic>{
        'type': 'alarm',
        'alarmTime': '09:00',
        'alarmLabel': 'Medicine',
        'alarmRepeat': 'Mon, Wed',
      };

      expect(NotificationsController.parseAlarmPayload(notification), isNull);
      expect(NotificationsController.getAlarmTime(notification), '09:00');
      expect(NotificationsController.getAlarmLabel(notification), 'Medicine');
      expect(NotificationsController.getAlarmRepeat(notification), 'Mon, Wed');
    });
  });
}
