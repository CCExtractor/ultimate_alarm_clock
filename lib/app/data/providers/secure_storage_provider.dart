import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ultimate_alarm_clock/app/data/models/user_model.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class SecureStorageProvider {
  final FlutterSecureStorage _secureStorage;

  SecureStorageProvider() : _secureStorage = FlutterSecureStorage();

  Future<void> storeUserModel(UserModel userModel) async {
    final String key = 'userModel';
    final String userString = jsonEncode(userModel.toJson());

    await _secureStorage.write(key: key, value: userString);
  }

  Future<UserModel?> retrieveUserModel() async {
    final String key = 'userModel';
    final String? userString = await _secureStorage.read(key: key);

    if (userString != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        return UserModel.fromJson(userMap);
      } catch (e) {
        print('Error parsing user model: $e');
        return null;
      }
    }

    return null;
  }

  Future<void> deleteUserModel() async {
    final String key = 'userModel';
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
}
