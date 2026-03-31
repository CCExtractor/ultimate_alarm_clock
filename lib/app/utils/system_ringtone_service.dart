import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ultimate_alarm_clock/app/data/models/system_ringtone_model.dart';

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
      debugPrint('Error getting system ringtones: $e');
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
      debugPrint('Error getting all system ringtones: $e');
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
      debugPrint('Error getting categorized system ringtones: $e');
      return {};
    }
  }

  static Future<void> playSystemRingtone(String ringtoneUri) async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      debugPrint('🔊 SystemRingtoneService: Attempting to play ringtone: $ringtoneUri');
      await _channel.invokeMethod('playSystemRingtone', {
        'ringtoneUri': ringtoneUri,
      });
      debugPrint('✅ SystemRingtoneService: Successfully called platform method');
    } catch (e) {
      debugPrint('❌ SystemRingtoneService: Error playing system ringtone: $e');
    }
  }

  static Future<void> stopSystemRingtone() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      debugPrint('🛑 SystemRingtoneService: Stopping system ringtone');
      await _channel.invokeMethod('stopSystemRingtone');
      debugPrint('✅ SystemRingtoneService: Successfully stopped ringtone');
    } catch (e) {
      debugPrint('❌ SystemRingtoneService: Error stopping system ringtone: $e');
    }
  }

  static Future<void> testAudio() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      debugPrint('🔍 SystemRingtoneService: Running audio diagnostics...');
      await _channel.invokeMethod('testAudio');
      debugPrint('✅ SystemRingtoneService: Audio test completed');
    } catch (e) {
      debugPrint('❌ SystemRingtoneService: Audio test failed: $e');
    }
  }
} 