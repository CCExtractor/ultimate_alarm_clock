import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/hapticFeedback/controllers/haptic_feedback_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.put<HapticFeedbackController>(
      HapticFeedbackController(),
    );
  });

  tearDown(() {
    Get.reset();
  });

  test('Toggling Haptic Feedback', () {
    final HapticFeedbackController hapticFeedbackController = HapticFeedbackController();

    expect(hapticFeedbackController.isHapticFeedbackEnabled.value, true);

    hapticFeedbackController.toggleHapticFeedback(false);
    expect(hapticFeedbackController.isHapticFeedbackEnabled.value, false);

    hapticFeedbackController.toggleHapticFeedback(true);
    expect(hapticFeedbackController.isHapticFeedbackEnabled.value, true);
  });
}
