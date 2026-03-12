import 'package:flutter_test/flutter_test.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

void main() {
  AlarmModel buildAlarm() {
    return AlarmModel(
      alarmTime: '07:30',
      alarmID: 'alarm-123',
      ownerId: 'owner-1',
      ownerName: 'Rahul',
      lastEditedUserId: 'owner-1',
      mutexLock: false,
      days: const [true, false, true, false, true, false, false],
      intervalToAlarm: 15,
      isActivityEnabled: false,
      minutesSinceMidnight: 450,
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
      mainAlarmTime: null,
      label: 'Morning',
      isOneTime: false,
      snoozeDuration: 10,
      gradient: 1,
      ringtoneName: 'Default',
      note: 'Wake up',
      deleteAfterGoesOff: false,
      showMotivationalQuote: false,
      volMax: 1.0,
      volMin: 0.4,
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

  test('fromJson initializes fields from serialized alarm data', () {
    final original = buildAlarm();

    final restored = AlarmModel.fromJson(AlarmModel.toJson(original), null);

    expect(restored.alarmID, original.alarmID);
    expect(restored.alarmTime, original.alarmTime);
    expect(restored.label, original.label);
    expect(restored.minutesSinceMidnight, original.minutesSinceMidnight);
  });
}
