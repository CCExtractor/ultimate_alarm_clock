import 'package:isar/isar.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';

part 'ringtone_model.g.dart';

class RingtoneModel {
  late String ringtoneName;
  late String ringtonePath;
  late int currentCounterOfUsage;

  Id get isarId => AudioUtils.fastHash(ringtoneName);

  RingtoneModel({
    required this.ringtoneName,
    required this.ringtonePath,
    required this.currentCounterOfUsage,
  });
}

extension SystemRingtoneExtension on RingtoneModel {
  static RingtoneModel fromSystemRingtone(String title, String uri) {
    return RingtoneModel(
      ringtoneName: title,
      ringtonePath: uri,
      currentCounterOfUsage: 0,
    );
  }

  bool get isSystemRingtone => ringtonePath.startsWith('content://');
}
