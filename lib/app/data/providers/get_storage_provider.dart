import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetStorageProvider {
  late final GetStorage _getStorage;

  Future<GetStorageProvider> init() async {
    await GetStorage.init();
    _getStorage = GetStorage();
    return this;
  }

  Future<String> readCurrentLanguage() async {
    print(_getStorage.read('currentLanguageKey'));
    String? language = await _getStorage.read(('currentLanguageKey'));
    if (language == null) {
      language = Get.locale.toString();
      writeCurrentLanguage(language);
    }
    return language;
  }

  Future<void> writeCurrentLanguage(String value) async {
    await _getStorage.write('currentLanguageKey', value);
  }

  Future<Locale> readLocale() async {
    final languageCode = _getStorage.read('languageCode');

    return languageCode != null
        ? Locale(
            languageCode,
            _getStorage.read('countryCode') ?? '',
          )
        : const Locale('en', 'EN');
  }

  Future<void> writeLocale(String lanCode, String countryCode) async {
    await _getStorage.write('languageCode', lanCode);
    await _getStorage.write('countryCode', countryCode);
  }

  Future<void> writeTimerStartTimeInSeconds({
    required int timerStartTimeInSeconds,
  }) async {
    await _getStorage.write(
      'timer_start_time_in_seconds',
      timerStartTimeInSeconds.toString(),
    );
  }

  Future<int> readTimerStartTimeInSeconds() async {
    String timerStartTime =
        await _getStorage.read('timer_start_time_in_seconds') ?? '-1';
    return int.parse(timerStartTime);
  }

  Future<bool> readIsTimerRunning() async {
    return await _getStorage.read('is_timer_running') == 'true';
  }

  Future<void> writeIsTimerRunning({
    required bool isTimerRunning,
  }) async {
    await _getStorage.write(
      'is_timer_running',
      isTimerRunning.toString(),
    );
  }

  Future<bool> readIsTimerPaused() async {
    return await _getStorage.read('is_timer_paused') == 'true';
  }

  Future<void> writeIsTimerPaused({
    required bool isTimerPaused,
  }) async {
    await _getStorage.write(
      'is_timer_paused',
      isTimerPaused.toString(),
    );
  }

  Future<int> readRemainingTimeInSeconds() async {
    String remainingTime =
        await _getStorage.read('remaining_time_in_seconds') ?? '-1';
    return int.parse(remainingTime);
  }

  Future<void> writeRemainingTimeInSeconds({
    required int remainingTimeInSeconds,
  }) async {
    await _getStorage.write(
      'remaining_time_in_seconds',
      remainingTimeInSeconds.toString(),
    );
  }

  Future<void> removeRemainingTimeInSeconds() async {
    await _getStorage.remove('remaining_time_in_seconds');
  }

  Future<int> readStartTime() async {
    String startTime = await _getStorage.read('start_time') ?? '-1';
    return int.parse(startTime);
  }

  Future<void> writeStartTime({
    required int startTime,
  }) async {
    await _getStorage.write(
      'start_time',
      startTime.toString(),
    );
  }

  Future<void> removeStartTime() async {
    await _getStorage.remove('start_time');
  }
}
