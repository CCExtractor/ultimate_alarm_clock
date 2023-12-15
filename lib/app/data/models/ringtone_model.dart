import 'package:isar/isar.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

part 'ringtone_model.g.dart';

@collection
class RingtoneModel {
  late String ringtoneName;
  late String ringtonePath;
  late int currentCounterOfUsage;

  Id get isarId => Utils.fastHash(ringtoneName);

  RingtoneModel({
    required this.ringtoneName,
    required this.ringtonePath,
    required this.currentCounterOfUsage,
  });
}
