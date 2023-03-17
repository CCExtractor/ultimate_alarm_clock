import 'package:get/get.dart';

import '../modules/addAlarm/bindings/add_alarm_binding.dart';
import '../modules/addAlarm/views/add_alarm_view.dart';
import '../modules/alarm-control/bindings/alarm_control_binding.dart';
import '../modules/alarm-control/views/alarm_control_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

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
      name: _Paths.ALARM_CONTROL,
      page: () => const AlarmControlView(),
      binding: AlarmControlBinding(),
    ),
  ];
}
