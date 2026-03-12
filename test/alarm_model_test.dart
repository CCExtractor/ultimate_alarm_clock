import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

Map<String, dynamic> _baseMap() => {
      'firestoreId': null,
      'alarmID': 'test-alarm-001',
      'alarmTime': '07:30',
      'minutesSinceMidnight': 450,
      'isEnabled': true,
      'isLocationEnabled': false,
      'isSharedAlarmEnabled': false,
      'isWeatherEnabled': false,
      'isMathsEnabled': false,
      'isShakeEnabled': false,
      'isQrEnabled': false,
      'isPedometerEnabled': false,
      'isActivityEnabled': false,
      'isOneTime': false,
      'isGuardian': false,
      'isCall': false,
      'mutexLock': false,
      'deleteAfterGoesOff': false,
      'showMotivationalQuote': false,
      'ringOn': false,
      'intervalToAlarm': 5,
      'activityInterval': 30,
      'snoozeDuration': 5,
      'maxSnoozeCount': 3,
      'gradient': 0,
      'shakeTimes': 3,
      'numberOfSteps': 10,
      'numMathsQuestions': 3,
      'mathsDifficulty': 0,
      'activityMonitor': 0,
      'guardianTimer': 0,
      'volMax': 1.0,
      'volMin': 0.5,
      'location': '',
      'qrValue': '',
      'label': 'Morning',
      'note': '',
      'ringtoneName': 'Default',
      'alarmDate': '2026-03-12',
      'profile': 'default',
      'guardian': '',
      'ownerId': 'user-123',
      'ownerName': 'Test User',
      'lastEditedUserId': 'user-123',
      'sharedUserIds': <String>[],
      'days': List<bool>.filled(7, true),
      'weatherTypes': <int>[0],
      'mainAlarmTime': null,
    };

AlarmModel _baseModel() => AlarmModel.fromMap(_baseMap());

void main() {
  group('AlarmModel.fromMap', () {
    test('populates string fields', () {
      final m = _baseModel();
      expect(m.alarmID, 'test-alarm-001');
      expect(m.alarmTime, '07:30');
      expect(m.label, 'Morning');
      expect(m.profile, 'default');
      expect(m.ownerId, 'user-123');
      expect(m.ownerName, 'Test User');
      expect(m.ringtoneName, 'Default');
      expect(m.alarmDate, '2026-03-12');
    });

    test('populates boolean fields', () {
      final m = _baseModel();
      expect(m.isEnabled, true);
      expect(m.isLocationEnabled, false);
      expect(m.isSharedAlarmEnabled, false);
      expect(m.isWeatherEnabled, false);
      expect(m.isMathsEnabled, false);
      expect(m.isShakeEnabled, false);
      expect(m.isQrEnabled, false);
      expect(m.isPedometerEnabled, false);
      expect(m.isActivityEnabled, false);
      expect(m.isOneTime, false);
      expect(m.mutexLock, false);
      expect(m.deleteAfterGoesOff, false);
      expect(m.showMotivationalQuote, false);
      expect(m.ringOn, false);
      expect(m.isGuardian, false);
      expect(m.isCall, false);
    });

    test('populates numeric fields', () {
      final m = _baseModel();
      expect(m.minutesSinceMidnight, 450);
      expect(m.snoozeDuration, 5);
      expect(m.maxSnoozeCount, 3);
      expect(m.gradient, 0);
      expect(m.intervalToAlarm, 5);
      expect(m.activityInterval, 30);
      expect(m.shakeTimes, 3);
      expect(m.numberOfSteps, 10);
      expect(m.numMathsQuestions, 3);
      expect(m.mathsDifficulty, 0);
      expect(m.volMax, 1.0);
      expect(m.volMin, 0.5);
    });

    test('populates list fields', () {
      final m = _baseModel();
      expect(m.days, List.filled(7, true));
      expect(m.weatherTypes, [0]);
      expect(m.sharedUserIds, isEmpty);
    });

    test('maxSnoozeCount defaults to 3 when absent from map', () {
      final map = _baseMap()..remove('maxSnoozeCount');
      expect(AlarmModel.fromMap(map).maxSnoozeCount, 3);
    });
  });

  group('AlarmModel toMap / fromMap roundtrip', () {
    test('preserves scalar fields', () {
      final original = _baseModel();
      final restored = AlarmModel.fromMap(AlarmModel.toMap(original));

      expect(restored.alarmID, original.alarmID);
      expect(restored.alarmTime, original.alarmTime);
      expect(restored.minutesSinceMidnight, original.minutesSinceMidnight);
      expect(restored.label, original.label);
      expect(restored.snoozeDuration, original.snoozeDuration);
      expect(restored.maxSnoozeCount, original.maxSnoozeCount);
      expect(restored.isEnabled, original.isEnabled);
      expect(restored.ringOn, original.ringOn);
      expect(restored.volMax, original.volMax);
      expect(restored.volMin, original.volMin);
    });

    test('preserves days list', () {
      final original = _baseModel();
      final restored = AlarmModel.fromMap(AlarmModel.toMap(original));
      expect(restored.days, original.days);
    });

    test('preserves weatherTypes list', () {
      final map = _baseMap();
      map['weatherTypes'] = [0, 1, 2];
      final original = AlarmModel.fromMap(map);
      final restored = AlarmModel.fromMap(AlarmModel.toMap(original));
      expect(restored.weatherTypes, [0, 1, 2]);
    });

    test('includes mainAlarmTime and offsetDetails when shared', () {
      final map = _baseMap();
      map['isSharedAlarmEnabled'] = true;
      map['mainAlarmTime'] = '07:30';
      final result = AlarmModel.toMap(AlarmModel.fromMap(map));
      expect(result.containsKey('mainAlarmTime'), true);
      expect(result.containsKey('offsetDetails'), true);
    });

    test('excludes mainAlarmTime and offsetDetails when not shared', () {
      final result = AlarmModel.toMap(_baseModel());
      expect(result.containsKey('mainAlarmTime'), false);
      expect(result.containsKey('offsetDetails'), false);
    });
  });

  group('toJson', () {
    test('produces valid JSON', () {
      expect(() => jsonDecode(AlarmModel.toJson(_baseModel())), returnsNormally);
    });

    test('JSON contains expected fields', () {
      final decoded =
          jsonDecode(AlarmModel.toJson(_baseModel())) as Map<String, dynamic>;
      expect(decoded['alarmID'], 'test-alarm-001');
      expect(decoded['label'], 'Morning');
      expect(decoded['minutesSinceMidnight'], 450);
    });
  });

  group('boolListToString / stringToBoolList', () {
    late AlarmModel model;
    setUp(() => model = _baseModel());

    // days list is Mon-first internally, but stored as Sun-first.
    // These single-day tests verify that contract explicitly.
    test('Sunday (index 6 in list) maps to position 0 in encoded string', () {
      final sundayOnly = [false, false, false, false, false, false, true];
      expect(model.boolListToString(sundayOnly)[0], '1');
    });

    test('Monday (index 0 in list) maps to position 1 in encoded string', () {
      final mondayOnly = [true, false, false, false, false, false, false];
      expect(model.boolListToString(mondayOnly)[1], '1');
    });

    test('Saturday (index 5 in list) maps to position 6 in encoded string', () {
      final saturdayOnly = [false, false, false, false, false, true, false];
      expect(model.boolListToString(saturdayOnly)[6], '1');
    });

    test('roundtrip is lossless', () {
      final days = [true, false, true, false, true, false, true];
      expect(model.stringToBoolList(model.boolListToString(days)), days);
    });

    test('all-days roundtrip', () {
      final all = List.filled(7, true);
      expect(model.stringToBoolList(model.boolListToString(all)), all);
    });

    test('no-days roundtrip', () {
      final none = List.filled(7, false);
      expect(model.stringToBoolList(model.boolListToString(none)), none);
    });

    test('weekend-only roundtrip', () {
      final weekends = [false, false, false, false, false, true, true];
      expect(model.stringToBoolList(model.boolListToString(weekends)), weekends);
    });

    test('output length is always 7', () {
      expect(model.boolListToString(List.filled(7, true)).length, 7);
    });

    test('output contains only 0s and 1s', () {
      final result =
          model.boolListToString([true, false, true, false, true, false, true]);
      expect(result.split('').every((c) => c == '0' || c == '1'), true);
    });
  });

  group('AlarmModel default constructor', () {
    test('creates model with correct values and defaults', () {
      final model = AlarmModel(
        alarmTime: '08:00',
        alarmID: 'alarm-99',
        ownerId: 'owner-1',
        ownerName: 'Alice',
        lastEditedUserId: 'owner-1',
        mutexLock: false,
        days: List.filled(7, true),
        intervalToAlarm: 5,
        isActivityEnabled: false,
        minutesSinceMidnight: 480,
        isLocationEnabled: false,
        isSharedAlarmEnabled: false,
        isWeatherEnabled: false,
        location: '',
        weatherTypes: [],
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
        label: 'Work',
        isOneTime: false,
        snoozeDuration: 5,
        gradient: 0,
        ringtoneName: 'Default',
        note: '',
        deleteAfterGoesOff: false,
        showMotivationalQuote: false,
        volMax: 1.0,
        volMin: 0.0,
        activityMonitor: 0,
        ringOn: false,
        alarmDate: '',
        profile: 'default',
        isGuardian: false,
        guardianTimer: 0,
        guardian: '',
        isCall: false,
      );

      expect(model.alarmID, 'alarm-99');
      expect(model.minutesSinceMidnight, 480);
      expect(model.label, 'Work');
      expect(model.maxSnoozeCount, 3); // default
      expect(model.isEnabled, true); // default
    });
  });
}
