import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HapticFeebackService extends GetxService {
  final _prefKey = 'haptic_feedback';
  bool _isHapticFeedbackEnabled = true;

  bool get isHapticFeedbackEnabled => _isHapticFeedbackEnabled;

  HapticFeebackService() {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isHapticFeedbackEnabled = prefs.getBool(_prefKey) ?? true;
  }

  void _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isHapticFeedbackEnabled);
  }

  void toggleHapticFeedback(bool enabled) {
    _isHapticFeedbackEnabled = enabled;
    _savePreference();
  }

  Future<void> hapticFeedback() async {
    if (_isHapticFeedbackEnabled) {
      await SystemChannels.platform.invokeMethod<void>(
        'HapticFeedback.vibrate',
        'HapticFeedbackType.selectionClick',
      );
    }
  }
}
