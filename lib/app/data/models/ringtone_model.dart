import 'package:isar/isar.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';

part 'ringtone_model.g.dart';

@collection
class RingtoneModel {
  late String ringtoneName;
  late String ringtonePath;
  late int currentCounterOfUsage;
  late bool isSystemRingtone;
  late String ringtoneUri;
  late String category;

  Id get isarId => AudioUtils.fastHash(ringtoneName);

  RingtoneModel({
    required this.ringtoneName,
    required this.ringtonePath,
    required this.currentCounterOfUsage,
    this.isSystemRingtone = false,
    this.ringtoneUri = '',
    this.category = '',
  });
}
