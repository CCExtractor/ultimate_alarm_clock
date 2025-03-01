import 'package:isar/isar.dart';
part 'timer_model.g.dart';

@collection
class TimerModel {
  Id timerId = Isar.autoIncrement;
  late String timerName;
  late int timerValue;
  late String startedOn;
  late int timeElapsed;
  late String ringtoneName;
  late int isPaused;

  TimerModel({
    required this.timerValue,
    required this.startedOn,
    required this.ringtoneName,
    required this.timerName,
    this.isPaused = 0,
    this.timeElapsed = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': timerId,
      'startedOn': startedOn,
      'timerValue': timerValue,
      'timeElapsed': timeElapsed,
      'ringtoneName': ringtoneName,
      'timerName': timerName,
      'isPaused': isPaused,
    };
  }

  // Extract a TimerModel object from a Map object.
  TimerModel.fromMap(Map<String, dynamic> map) {
    timerId = map['id'];
    startedOn = map['startedOn'];
    timerValue = map['timerValue'];
    timeElapsed = map['timeElapsed'];
    ringtoneName = map['ringtoneName'];
    timerName = map['timerName'];
    isPaused = map['isPaused'];
  }
}
