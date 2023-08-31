import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUp(() {
    Get.put<HapticFeebackService>(
      HapticFeebackService(),
    );
  });

  tearDown(() {
    Get.reset();
  });

  test('Toggling Haptic Feedback', () {
    final HapticFeebackService _hapticFeedbackService = Get.find<HapticFeebackService>();

    expect(_hapticFeedbackService.isHapticFeedbackEnabled, true);

    _hapticFeedbackService.toggleHapticFeedback(false);
    expect(_hapticFeedbackService.isHapticFeedbackEnabled, false);

    _hapticFeedbackService.toggleHapticFeedback(true);
    expect(_hapticFeedbackService.isHapticFeedbackEnabled, true);
  });
}
