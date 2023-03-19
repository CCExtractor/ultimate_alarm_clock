import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

import '../../../../objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store _store;
  late final Box<AlarmModel> _alarmBox;

  ObjectBox._init(this._store) {
    _alarmBox = Box<AlarmModel>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();

    return ObjectBox._init(store);
  }

  AlarmModel? getAlarm(int id) => _alarmBox.get(id);

  Stream<List<AlarmModel>> getAlarms() => _alarmBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  int insertAlarm(AlarmModel alarmRecord) => _alarmBox.put(alarmRecord);

  bool deleteUser(int id) => _alarmBox.remove(id);
}
