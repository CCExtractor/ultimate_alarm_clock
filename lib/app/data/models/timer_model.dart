import 'package:isar/isar.dart';

@collection
class TimerModel {
  Id isarId = Isar.autoIncrement;

  late String timerTime;
  late String mainTimerTime;
  late int intervalToAlarm;
  late String ringtoneName;

  TimerModel({
    required this.intervalToAlarm,
    required this.mainTimerTime,
    required this.ringtoneName,
    required this.timerTime,
  });
}
