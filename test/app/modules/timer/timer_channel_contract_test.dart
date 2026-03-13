import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timerRing/controllers/timer_ring_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const timerChannel = MethodChannel('timer');
  const alarmChannel = MethodChannel('ulticlock');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timerChannel, (_) async => null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(alarmChannel, (_) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timerChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(alarmChannel, null);
  });

  test(
      'TimerController cancelTimer uses the implemented timer notification clear method',
      () async {
    MethodCall? capturedCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timerChannel, (call) async {
      capturedCall = call;
      return null;
    });

    final controller = TimerController();
    await controller.cancelTimer();

    expect(capturedCall?.method, 'clearTimerNotif');
  });

  test('TimerRingController foreground recovery uses the alarm channel',
      () async {
    MethodCall? timerCall;
    MethodCall? alarmCall;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timerChannel, (call) async {
      timerCall = call;
      return null;
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(alarmChannel, (call) async {
      alarmCall = call;
      return null;
    });

    final controller = TimerRingController();
    await controller.bringAppToForegroundForTest();

    expect(timerCall, isNull);
    expect(alarmCall?.method, 'bringAppToForeground');
  });

  test(
      'TimerRingController clears timer notifications through the timer channel',
      () async {
    MethodCall? timerCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timerChannel, (call) async {
      timerCall = call;
      return null;
    });

    final controller = TimerRingController();
    await controller.clearTimerNotificationForTest();

    expect(timerCall?.method, 'clearTimerNotif');
  });
}
