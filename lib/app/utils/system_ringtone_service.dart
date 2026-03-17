import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ultimate_alarm_clock/app/data/models/system_ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/utils/app_logger.dart';

class SystemRingtoneService {
  static const MethodChannel _channel = MethodChannel('system_ringtones');

  static Future<List<SystemRingtoneModel>> getSystemRingtones(String category) async {
    if (!Platform.isAndroid) {
      return [];
    }

    try {
      final List<dynamic> result = await _channel.invokeMethod('getSystemRingtones', {
        'category': category,
      });

      return result.map((dynamic item) {
        return SystemRingtoneModel.fromMap(Map<String, dynamic>.from(item));
      }).toList();
    } catch (e) {
      AppLogger.e(
        'Error getting system ringtones',
        tag: 'SystemRingtoneService',
        error: e,
      );
      return [];
    }
  }

  static Future<List<SystemRingtoneModel>> getAllSystemRingtones() async {
    if (!Platform.isAndroid) {
      return [];
    }

    try {
      final List<SystemRingtoneModel> allRingtones = [];
      final List<String> categories = ['alarm', 'notification', 'ringtone'];
      
      for (String category in categories) {
        final List<SystemRingtoneModel> categoryRingtones = await getSystemRingtones(category);
        allRingtones.addAll(categoryRingtones);
      }
      
      return allRingtones;
    } catch (e) {
      AppLogger.e(
        'Error getting all system ringtones',
        tag: 'SystemRingtoneService',
        error: e,
      );
      return [];
    }
  }

  static Future<Map<String, List<SystemRingtoneModel>>> getSystemRingtonesByCategory() async {
    if (!Platform.isAndroid) {
      return {};
    }

    try {
      final Map<String, List<SystemRingtoneModel>> categorizedRingtones = {};
      final List<String> categories = ['alarm', 'notification', 'ringtone'];
      
      for (String category in categories) {
        final List<SystemRingtoneModel> categoryRingtones = await getSystemRingtones(category);
        categorizedRingtones[category] = categoryRingtones;
      }
      
      return categorizedRingtones;
    } catch (e) {
      AppLogger.e(
        'Error getting categorized system ringtones',
        tag: 'SystemRingtoneService',
        error: e,
      );
      return {};
    }
  }

  static Future<void> playSystemRingtone(String ringtoneUri) async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      AppLogger.i(
        'Attempting to play ringtone',
        tag: 'SystemRingtoneService',
      );
      await _channel.invokeMethod('playSystemRingtone', {
        'ringtoneUri': ringtoneUri,
      });
      AppLogger.i(
        'Successfully called platform play method',
        tag: 'SystemRingtoneService',
      );
    } catch (e) {
      AppLogger.e(
        'Error playing system ringtone',
        tag: 'SystemRingtoneService',
        error: e,
      );
    }
  }

  static Future<void> stopSystemRingtone() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      AppLogger.i('Stopping system ringtone', tag: 'SystemRingtoneService');
      await _channel.invokeMethod('stopSystemRingtone');
      AppLogger.i('Successfully stopped ringtone', tag: 'SystemRingtoneService');
    } catch (e) {
      AppLogger.e(
        'Error stopping system ringtone',
        tag: 'SystemRingtoneService',
        error: e,
      );
    }
  }

  static Future<void> testAudio() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      AppLogger.i('Running audio diagnostics', tag: 'SystemRingtoneService');
      await _channel.invokeMethod('testAudio');
      AppLogger.i('Audio test completed', tag: 'SystemRingtoneService');
    } catch (e) {
      AppLogger.e(
        'Audio test failed',
        tag: 'SystemRingtoneService',
        error: e,
      );
    }
  }
} 