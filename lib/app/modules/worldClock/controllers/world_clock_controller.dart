import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:ultimate_alarm_clock/app/data/models/world_clock_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';

class WorldClockController extends GetxController {
  final RxList<WorldClockModel> clocks = <WorldClockModel>[].obs;
  final RxInt tick = 0.obs;
  late final Timer _timer;

  final GetStorageProvider _storage = Get.find<GetStorageProvider>();

  @override
  void onInit() {
    super.onInit();
    clocks.assignAll(_storage.readWorldClocks());
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => tick.value++,
    );
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void addClock(WorldClockModel clock) {
    clocks.add(clock);
    _storage.writeWorldClocks(clocks.toList());
  }

  void removeClock(int index) {
    clocks.removeAt(index);
    _storage.writeWorldClocks(clocks.toList());
  }

  String getCityTime(WorldClockModel clock, bool is24Hour) {
    final location = tz.getLocation(clock.ianaTimezone);
    final now = tz.TZDateTime.now(location);
    return is24Hour
        ? DateFormat('HH:mm').format(now)
        : DateFormat('h:mm').format(now);
  }

  String getCityTimePeriod(WorldClockModel clock) {
    final location = tz.getLocation(clock.ianaTimezone);
    final now = tz.TZDateTime.now(location);
    return DateFormat('a').format(now);
  }

  String getCityDate(WorldClockModel clock) {
    final location = tz.getLocation(clock.ianaTimezone);
    final now = tz.TZDateTime.now(location);
    return DateFormat('EEE, MMM d').format(now);
  }

  String getUtcOffset(WorldClockModel clock) {
    final location = tz.getLocation(clock.ianaTimezone);
    final now = tz.TZDateTime.now(location);
    final offset = now.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs();
    final minutes = offset.inMinutes.abs() % 60;
    return minutes == 0
        ? 'UTC$sign$hours'
        : 'UTC$sign$hours:${minutes.toString().padLeft(2, '0')}';
  }

  String getTimeDiff(WorldClockModel clock) {
    final location = tz.getLocation(clock.ianaTimezone);
    final now = tz.TZDateTime.now(location);
    final localOffset = DateTime.now().timeZoneOffset;
    final diff = now.timeZoneOffset - localOffset;
    if (diff == Duration.zero) return 'Local time';
    final sign = diff.isNegative ? '-' : '+';
    final h = diff.inHours.abs();
    final m = diff.inMinutes.abs() % 60;
    return m == 0
        ? '${sign}${h}h from you'
        : '${sign}${h}h ${m}m from you';
  }
}
