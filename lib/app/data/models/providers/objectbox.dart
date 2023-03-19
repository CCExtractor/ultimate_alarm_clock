import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';

import '../../../../objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  static late final Store _store;
  static late final Box<AlarmModel> _alarmBox;

  ObjectBox._init(Store store) {
    _alarmBox = Box<AlarmModel>(_store);
  }

  static Future init() async {
    var docsDir = await getApplicationDocumentsDirectory();
    var dbPath = p.join(docsDir.path, "objectbox");
    if (Store.isOpen(dbPath)) {
      _store = Store.attach(getObjectBoxModel(), dbPath);
    } else {
      _store = await openStore(directory: dbPath);
    }
    return ObjectBox._init(_store);
  }

  AlarmModel? getAlarm(int id) => _alarmBox.get(id);

  Stream<List<AlarmModel>> getAlarms() => _alarmBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  int insertAlarm(AlarmModel alarmRecord) => _alarmBox.put(alarmRecord);

  bool deleteAlarm(int id) => _alarmBox.remove(id);

  List<AlarmModel> getAllAlarms() => _alarmBox.getAll();

  deleteAllAlarms() => _alarmBox.removeAll();
}
