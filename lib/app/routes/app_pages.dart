import 'package:get/get.dart';

import '../modules/addAlarm/bindings/add_alarm_binding.dart';
import '../modules/addAlarm/views/add_alarm_view.dart';
import '../modules/alarmRing/bindings/alarm_ring_binding.dart';
import '../modules/alarmRing/views/alarm_ring_view.dart';
import '../modules/alarmRingIgnore/bindings/alarm_ring_ignore_binding.dart';
import '../modules/alarmRingIgnore/views/alarm_ring_ignore_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/updateAlarm/bindings/update_alarm_binding.dart';
import '../modules/updateAlarm/views/update_alarm_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ALARM,
      page: () => AddAlarmView(),
      binding: AddAlarmBinding(),
    ),
    GetPage(
      name: _Paths.ALARM_RING,
      page: () => const AlarmControlView(),
      binding: AlarmControlBinding(),
    ),
    GetPage(
      name: _Paths.ALARM_RING_IGNORE,
      page: () => const AlarmControlIgnoreView(),
      binding: AlarmControlIgnoreBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_ALARM,
      page: () => const UpdateAlarmView(),
      binding: UpdateAlarmBinding(),
    ),
  ];
}
