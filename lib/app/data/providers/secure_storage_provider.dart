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

  Future<CustomRingtoneStatus> readCustomRingtoneStatus() async {
    String customRingtoneStatus =
        await _secureStorage.read(key: 'custom_ringtone_status') ??
            'CustomRingtoneStatus.disabled';

    return customRingtoneStatus == 'CustomRingtoneStatus.disabled'
        ? CustomRingtoneStatus.disabled
        : CustomRingtoneStatus.enabled;
  }

  Future<void> writeCustomRingtoneStatus({
    required CustomRingtoneStatus status,
  }) async {
    await _secureStorage.write(
      key: 'custom_ringtone_status',
      value: status.toString(),
    );
  }

  //check 24 hrs enabled
  Future<bool> read24HoursEnabled({required String key}) async {
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
}
