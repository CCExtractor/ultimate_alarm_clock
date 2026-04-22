import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class SecureStorageProvider {
  final FlutterSecureStorage _secureStorage;

  SecureStorageProvider() : _secureStorage = const FlutterSecureStorage();

  Future<void> storeUserModel(UserModel userModel) async {
    const String key = 'userModel';
    final String userString = jsonEncode(userModel.toJson());

    await _secureStorage.write(key: key, value: userString);
  }

  Future<UserModel?> retrieveUserModel() async {
    const String key = 'userModel';
    final String? userString = await _secureStorage.read(key: key);

    if (userString != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        return UserModel.fromJson(userMap);
      } catch (e) {
        debugPrint('Error parsing user model: $e');
        return null;
      }
    }

    return null;
  }

  Future<void> deleteUserModel() async {
    const String key = 'userModel';
    await _secureStorage.delete(key: key);
  }

  Future<void> storeApiKey(ApiKeys key, String val) async {
    final String apiKey = key.toString();
    await _secureStorage.write(key: apiKey, value: val);
  }

  Future<String?> retrieveApiKey(ApiKeys key) async {
    final String apiKey = key.toString();
    return await _secureStorage.read(key: apiKey);
  }

  // Store the weather state in the flutter secure storage
  Future<void> storeWeatherState(String weatherState) async {
    const String key = 'weather_state';
    await _secureStorage.write(
      key: key,
      value: weatherState,
    );
  }

  // Get the weather state from the flutter secure storage
  Future<String?> retrieveWeatherState() async {
    const String key = 'weather_state';
    return await _secureStorage.read(key: key);
  }

  Future<bool> readHapticFeedbackValue({required String key}) async {
    return await _secureStorage.read(key: key) == 'true';
  }

  Future<void> writeHapticFeedbackValue({
    required String key,
    required bool isHapticFeedbackEnabled,
  }) async {
    await _secureStorage.write(
      key: key,
      value: isHapticFeedbackEnabled.toString(),
    );
  }

  Future<bool> readSortedAlarmListValue({required String key}) async {
    return await _secureStorage.read(key: key) == 'true';
  }

  Future<void> writeSortedAlarmListValue({
    required String key,
    required bool isSortedAlarmListEnabled,
  }) async {
    await _secureStorage.write(
      key: key,
      value: isSortedAlarmListEnabled.toString(),
    );
  }

  Future<AppTheme> readThemeValue() async {
    String themeValue =
        await _secureStorage.read(key: 'theme_value') ?? 'AppTheme.dark';
    return themeValue == 'AppTheme.dark' ? AppTheme.dark : AppTheme.light;
  }

  Future<void> writeThemeValue({
    required AppTheme theme,
  }) async {
    await _secureStorage.write(
      key: 'theme_value',
      value: theme.toString(),
    );
  }

  //check 24 hrs enabled
  Future<bool> read24HoursEnabled({required String key}) async {
    return await _secureStorage.read(key: key) == 'true';
  }
  Future<bool> readFlipToSnooze({required String key}) async {
    return await _secureStorage.read(key: key) == 'true';
  }

  Future<void> write24HoursEnabled({
    required String key,
    required bool is24HoursEnabled,
  }) async {
    await _secureStorage.write(
      key: key,
      value: is24HoursEnabled.toString(),
    );
  }

  Future<int> readTabIndex() async {
    String tabIndex = await _secureStorage.read(key: 'tab_index') ?? '0';
    return int.parse(tabIndex);
  }

  Future<void> writeTabIndex({
    required int tabIndex,
  }) async {
    await _secureStorage.write(
      key: 'tab_index',
      value: tabIndex.toString(),
    );
  }

  Future<bool> readIsTimerRunning() async {
    return await _secureStorage.read(key: 'is_timer_running') == 'true';
  }

  Future<void> writeIsTimerRunning({
    required bool isTimerRunning,
  }) async {
    await _secureStorage.write(
      key: 'is_timer_running',
      value: isTimerRunning.toString(),
    );
  }

  Future<bool> readIsTimerPaused() async {
    return await _secureStorage.read(key: 'is_timer_paused') == 'true';
  }

  Future<void> writeIsTimerPaused({
    required bool isTimerPaused,
  }) async {
    await _secureStorage.write(
      key: 'is_timer_paused',
      value: isTimerPaused.toString(),
    );
  }

  Future<int> readRemainingTimeInSeconds() async {
    String remainingTime =
        await _secureStorage.read(key: 'remaining_time_in_seconds') ?? '-1';
    return int.parse(remainingTime);
  }

  Future<void> writeRemainingTimeInSeconds({
    required int remainingTimeInSeconds,
  }) async {
    await _secureStorage.write(
      key: 'remaining_time_in_seconds',
      value: remainingTimeInSeconds.toString(),
    );
  }

  Future<void> removeRemainingTimeInSeconds() async {
    await _secureStorage.delete(key: 'remaining_time_in_seconds');
  }

  Future<int> readStartTime() async {
    String startTime = await _secureStorage.read(key: 'start_time') ?? '-1';
    return int.parse(startTime);
  }

  Future<void> writeStartTime({
    required int startTime,
  }) async {
    await _secureStorage.write(
      key: 'start_time',
      value: startTime.toString(),
    );
  }

  Future<void> removeStartTime() async {
    await _secureStorage.delete(key: 'start_time');
  }

  Future<int> readTimerId() async {
    String timerId = await _secureStorage.read(key: 'timer_id') ?? '-1';
    return int.parse(timerId);
  }

  Future<void> writeTimerId({
    required int timerId,
  }) async {
    await _secureStorage.write(
      key: 'timer_id',
      value: timerId.toString(),
    );
  }

  // Timezone preference methods
  Future<bool> readTimezoneEnabledByDefault({required String key}) async {
    return await _secureStorage.read(key: key) == 'true';
  }

  Future<void> writeTimezoneEnabledByDefault({
    required String key,
    required bool isTimezoneEnabledByDefault,
  }) async {
    await _secureStorage.write(
      key: key,
      value: isTimezoneEnabledByDefault.toString(),
    );
  }

  Future<String> readDefaultTimezoneId({required String key}) async {
    return await _secureStorage.read(key: key) ?? '';
  }

  Future<void> writeDefaultTimezoneId({
    required String key,
    required String defaultTimezoneId,
  }) async {
    await _secureStorage.write(
      key: key,
      value: defaultTimezoneId,
    );
  }

  Future<bool> readShowTimezoneInAlarmList({required String key}) async {
    return await _secureStorage.read(key: key) != 'false'; // Default to true
  }

  Future<void> writeShowTimezoneInAlarmList({
    required String key,
    required bool showTimezoneInAlarmList,
  }) async {
    await _secureStorage.write(
      key: key,
      value: showTimezoneInAlarmList.toString(),
    );
  }
}
