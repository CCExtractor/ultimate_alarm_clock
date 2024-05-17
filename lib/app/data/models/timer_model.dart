import 'package:isar/isar.dart';
part 'timer_model.g.dart';

@collection
class TimerModel {
  Id timerId = Isar.autoIncrement;
  late String timerTime;
  late String mainTimerTime;
  late String timeElapsed ;
  late int intervalToAlarm;
  late String ringtoneName;
  late String timerName;
  late int isPaused ;

  TimerModel(
      {
      required this.intervalToAlarm,
      required this.mainTimerTime,
      required this.ringtoneName,
      required this.timerTime,
      required this.timerName,
      this.isPaused = 0,
      this.timeElapsed = '00:00:00'});

  Map<String, dynamic> toMap() {
    return {
      'id': timerId,
      'timerTime': timerTime,
      'mainTimerTime': mainTimerTime,
      'intervalToAlarm': intervalToAlarm,
      'ringtoneName': ringtoneName,
      'timerName': timerName,
      'isPaused': isPaused,
    };
  }

  // Extract a TimerModel object from a Map object.
  TimerModel.fromMap(Map<String, dynamic> map) {
    timerId = map['id'];
    timerTime = map['timerTime'];
    mainTimerTime = map['mainTimerTime'];
    intervalToAlarm = map['intervalToAlarm'];
    ringtoneName = map['ringtoneName'];
    timerName = map['timerName'];
    isPaused = map['isPaused'];
  }
}
