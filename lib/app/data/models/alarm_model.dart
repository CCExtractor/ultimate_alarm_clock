import 'package:objectbox/objectbox.dart';

@Entity()
class AlarmModel {
  @Id()
  int id;
  String alarmTime;
  bool isEnabled;
  int intervalToAlarm;

  AlarmModel(
      {this.id = 0,
      required this.alarmTime,
      this.isEnabled = true,
      required this.intervalToAlarm});
}
