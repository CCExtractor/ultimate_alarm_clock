import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class HapticFeebackService extends GetxService {
  final _hapticFeedbackKey = 'haptic_feedback';
  bool _isHapticFeedbackEnabled = true;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool get isHapticFeedbackEnabled => _isHapticFeedbackEnabled;

  HapticFeebackService() {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    _isHapticFeedbackEnabled =
        await _secureStorage.read(key: _hapticFeedbackKey) == 'true';
  }

  void _savePreference() async {
    await _secureStorage.write(
      key: _hapticFeedbackKey,
      value: _isHapticFeedbackEnabled.toString(),
    );
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
