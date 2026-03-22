import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmChallengeController extends GetxController {
  AlarmModel alarmRecord = Get.arguments;

  final RxDouble progress = 1.0.obs;

  final RxInt shakedCount = 0.obs;
  final isShakeOngoing = Status.initialized.obs;
  ShakeDetector? _shakeDetector;
  MobileScannerController? qrController;
  Timer? _progressTimer;

  final qrValue = ''.obs;
  final isQrOngoing = Status.initialized.obs;

  final isMathsOngoing = Status.initialized.obs;

  final RxInt numMathsQuestions = 0.obs;
  final RxString displayValue = ''.obs;
  final RxString questionText = '0'.obs;
  final RxBool correctAnswer = false.obs;
  int mathsAnswer = 0;

  bool isTimerEnabled = true;
  bool isNumMathQuestionsSet = false;

  final RxInt stepsCount = 0.obs;
  final isPedometerOngoing = Status.initialized.obs;
  late int numberOfSteps;
  int initialSteps = 0;
  bool shouldProcessStepCount = false;

  late Stream<StepCount> _stepCountStream;

  void onButtonPressed(String buttonText) {
    displayValue.value += buttonText;
  }

  restartQRCodeController() {
    qrController = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  newMathsQuestion() {
    if (!isNumMathQuestionsSet) {
      numMathsQuestions.value = alarmRecord.numMathsQuestions;
      isNumMathQuestionsSet = true;
    }
    List mathsProblemDetails = Utils.generateMathProblem(
      Difficulty.values[alarmRecord.mathsDifficulty],
    );
    questionText.value = mathsProblemDetails[0];
    displayValue.value = '';
    mathsAnswer = mathsProblemDetails[1];
  }

  void onStepCount(StepCount event) {
    if (shouldProcessStepCount) {
      if (initialSteps == 0) {
        initialSteps = event.steps;
      } else {
        stepsCount.value = event.steps - initialSteps;
      }
    }
  }

  void onStepCountError(error) {
    if (shouldProcessStepCount) {
      debugPrint('onStepCountError: $error');
      stepsCount.value = -1;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    _startTimer();

    String ringtoneName = alarmRecord.ringtoneName;

    AudioUtils.stopAlarm(ringtoneName: ringtoneName);
    if (alarmRecord.isShakeEnabled) {
      isShakeOngoing.listen((value) {
        if (value == Status.ongoing) {
          _shakeDetector = ShakeDetector.autoStart(
            onPhoneShake: () {
              shakedCount.value -= 1;
              restartTimer();
            },
          );
        }
      });

      shakedCount.listen((value) {
        if (value == 0) {
          isShakeOngoing.value = Status.completed;
          alarmRecord.isShakeEnabled = false;
          Get.back();
          _shakeDetector!.stopListening();
          isChallengesComplete();
        }
      });
    }

    if (alarmRecord.isQrEnabled) {
      qrController = MobileScannerController(
        autoStart: true,
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
      );

      qrValue.listen((value) {
        restartTimer();
        if (value == alarmRecord.qrValue) {
          isQrOngoing.value = Status.completed;
          qrController!.dispose();
          alarmRecord.isQrEnabled = false;
          Get.back();
          isChallengesComplete();
        }
      });
    }

    if (alarmRecord.isMathsEnabled) {
      newMathsQuestion();

      numMathsQuestions.listen((value) {
        if (value <= 0) {
          isMathsOngoing.value = Status.completed;
          alarmRecord.isMathsEnabled = false;
          Get.back();
          isChallengesComplete();
        } else {
          newMathsQuestion();
        }
      });

      isMathsOngoing.listen((value) {
        if (value == Status.initialized) {
          Future.delayed(const Duration(seconds: 1), () {
            isMathsOngoing.value = Status.ongoing;
          });
        }
      });
    }

    if (alarmRecord.isPedometerEnabled) {
      final PermissionStatus status =
          await Permission.activityRecognition.request();

      if (status == PermissionStatus.granted) {
        numberOfSteps = alarmRecord.numberOfSteps;

        shouldProcessStepCount = true;

        _stepCountStream = Pedometer.stepCountStream;

        isPedometerOngoing.listen((value) {
          if (value == Status.ongoing) {
            _stepCountStream.listen(onStepCount).onError(onStepCountError);
          }
        });

        stepsCount.listen((value) {
          if (numberOfSteps - value <= 0) {
            isPedometerOngoing.value = Status.completed;
            alarmRecord.isPedometerEnabled = false;
            Get.back();
            isChallengesComplete();
          } else if (value == -1) {
            Get.snackbar(
              'Step Count Unavailable',
              'We\'re unable to retrieve your step count at the moment.'
                  ' Please try again later.',
            );
            isPedometerOngoing.value = Status.completed;
            alarmRecord.isPedometerEnabled = false;
            Get.back();
            isChallengesComplete();
          }
        });
      }
    }
  }

  void _startTimer() {
    const duration = Duration(seconds: 15);
    final stopwatch = Stopwatch()..start();

    // Use Timer.periodic with 16ms tick (60fps) for smooth UI updates
    // Calculate progress based on elapsed time instead of iteration count
    _progressTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (!isTimerEnabled) {
        timer.cancel();
        _progressTimer = null;
        return;
      }

      final elapsed = stopwatch.elapsed;
      if (elapsed >= duration) {
        // Timer complete
        progress.value = 0.0;
        shouldProcessStepCount = false;
        timer.cancel();
        _progressTimer = null;
        Get.until((route) => route.settings.name == '/alarm-ring');
        return;
      }

      // Calculate progress: 1.0 -> 0.0 over 15 seconds
      progress.value = 1.0 - (elapsed.inMilliseconds / duration.inMilliseconds);
    });
  }

  restartTimer() {
    // Cancel the existing timer before starting a new one
    _progressTimer?.cancel();
    _progressTimer = null;
    progress.value = 1.0; // Reset the progress to its initial value
    _startTimer(); // Start a new timer
  }

  isChallengesComplete() {
    if (!Utils.isChallengeEnabled(alarmRecord)) {
      isNumMathQuestionsSet = false;
      isTimerEnabled = false;
      Get.offAllNamed('/bottom-navigation-bar');
    }
  }

  @override
  void onClose() async {
    // Clean up timer to prevent memory leaks
    _progressTimer?.cancel();
    _progressTimer = null;

    super.onClose();

    shouldProcessStepCount = false;

    String ringtoneName = alarmRecord.ringtoneName;

    if (!Utils.isChallengeEnabled(alarmRecord)) {
      AudioUtils.stopAlarm(ringtoneName: ringtoneName);
    } else {
      AudioUtils.playAlarm(alarmRecord: alarmRecord);
    }
  }
  void removeDigit() {
  if (displayValue.value.isNotEmpty) {
    displayValue.value = displayValue.value.substring(
      0, 
      displayValue.value.length - 1
    );
  }
}
}

