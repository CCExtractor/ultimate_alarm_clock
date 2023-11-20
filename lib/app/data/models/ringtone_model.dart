import 'package:isar/isar.dart';

part 'ringtone_model.g.dart';

@collection
class RingtoneModel {
  Id isarId = Isar.autoIncrement;
  late String ringtoneName;
  late List<int> ringtoneData;

  RingtoneModel({
    required this.ringtoneName,
    required this.ringtoneData,
  });
}
