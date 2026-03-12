import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/alarm_schedule_payload.dart';

AlarmModel buildAlarm() {
  return AlarmModel(
    alarmTime: '09:00',
    alarmID: 'alarm-1',
    ownerId: '',
    ownerName: '',
    lastEditedUserId: '',
    mutexLock: false,
    days: [false, false, false, false, false, false, false],
    intervalToAlarm: 0,
    isActivityEnabled: false,
    minutesSinceMidnight: 0,
    isLocationEnabled: false,
    isSharedAlarmEnabled: false,
    isWeatherEnabled: false,
    location: '',
    weatherTypes: const [],
    isMathsEnabled: false,
    mathsDifficulty: 0,
    numMathsQuestions: 0,
    isShakeEnabled: false,
    shakeTimes: 0,
    isQrEnabled: false,
    qrValue: '',
    isPedometerEnabled: false,
    numberOfSteps: 0,
    activityInterval: 0,
    mainAlarmTime: '09:00',
    label: '',
    isOneTime: true,
    snoozeDuration: 5,
    gradient: 0,
    ringtoneName: 'Default',
    note: '',
    deleteAfterGoesOff: false,
    showMotivationalQuote: false,
    volMax: 1,
    volMin: 0,
    activityMonitor: 0,
    ringOn: false,
    alarmDate: '2026-03-12',
    profile: 'Default',
    isGuardian: false,
    guardianTimer: 0,
    guardian: '',
    isCall: false,
  );
}

void main() {
  test('finds the next enabled weekday for repeating alarms', () {
    final alarm = buildAlarm()
      ..alarmTime = '08:45'
      ..days = [false, false, true, false, true, false, false];

    final triggerAt = AlarmSchedulePayload.nextTriggerAt(
      alarm,
      referenceTime: DateTime(2026, 3, 11, 9, 0),
    );

    expect(triggerAt, DateTime(2026, 3, 13, 8, 45));
  });

  test('respects ringOn date based alarms instead of wrapping to tomorrow', () {
    final alarm = buildAlarm()
      ..alarmTime = '07:30'
      ..ringOn = true
      ..alarmDate = '2026-03-15 ';

    final triggerAt = AlarmSchedulePayload.nextTriggerAt(
      alarm,
      referenceTime: DateTime(2026, 3, 12, 9, 0),
    );

    final payload = AlarmSchedulePayload.fromAlarm(
      alarm,
      now: DateTime(2026, 3, 12, 9, 0),
    );

    expect(triggerAt, DateTime(2026, 3, 15, 7, 30));
    expect(
      payload['triggerAtMs'],
      DateTime(2026, 3, 15, 7, 30).millisecondsSinceEpoch,
    );
    expect(
      payload['milliSeconds'],
      const Duration(days: 2, hours: 22, minutes: 30).inMilliseconds,
    );
  });

  test('builds the native scheduling payload from alarm state', () {
    final alarm = buildAlarm()
      ..alarmTime = '09:30'
      ..activityMonitor = 1
      ..isLocationEnabled = true
      ..location = '12.9716,77.5946'
      ..isWeatherEnabled = true
      ..weatherTypes = [1, 3];

    final payload = AlarmSchedulePayload.fromAlarm(
      alarm,
      now: DateTime(2026, 3, 12, 9, 0),
    );

    expect(
      payload['triggerAtMs'],
      DateTime(2026, 3, 12, 9, 30).millisecondsSinceEpoch,
    );
    expect(payload['milliSeconds'], 30 * 60 * 1000);
    expect(payload['activityMonitor'], 1);
    expect(payload['locationMonitor'], 1);
    expect(payload['location'], '12.9716,77.5946');
    expect(payload['isWeather'], 1);
    expect(payload['weatherTypes'], jsonEncode([1, 3]));
  });

  test('wraps scheduling to the next day when the alarm time already passed',
      () {
    final alarm = buildAlarm()..alarmTime = '08:45';

    final payload = AlarmSchedulePayload.fromAlarm(
      alarm,
      now: DateTime(2026, 3, 12, 9, 0),
    );

    expect(
      payload['triggerAtMs'],
      DateTime(2026, 3, 13, 8, 45).millisecondsSinceEpoch,
    );
    expect(payload['milliSeconds'], ((23 * 60) + 45) * 60 * 1000);
    expect(payload['locationMonitor'], 0);
    expect(payload['isWeather'], 0);
    expect(payload['weatherTypes'], jsonEncode([]));
  });
}
