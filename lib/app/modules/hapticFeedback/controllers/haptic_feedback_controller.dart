import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class HapticFeedbackController extends GetxController {

  var isHapticFeedbackEnabled = true.obs;

  final _hapticFeedbackKey = 'haptic_feedback';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _loadPreference() async {
    isHapticFeedbackEnabled.value =
        await _secureStorage.read(key: _hapticFeedbackKey) == 'true';
  }

  @override
  void onInit() {
    super.onInit();
    _loadPreference();
  }

  void _savePreference() async {
    await _secureStorage.write(
      key: _hapticFeedbackKey,
      value: isHapticFeedbackEnabled.toString(),
    );
  }

  void toggleHapticFeedback(bool enabled) {
    isHapticFeedbackEnabled.value = enabled;
    _savePreference();
  }

  Future<void> hapticFeedback() async {
    if (isHapticFeedbackEnabled.value) {
      await SystemChannels.platform.invokeMethod<void>(
        'HapticFeedback.vibrate',
        'HapticFeedbackType.selectionClick',
      );
    }
  }
}