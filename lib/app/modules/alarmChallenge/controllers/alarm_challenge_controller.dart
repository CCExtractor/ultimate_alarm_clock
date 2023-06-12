import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shake/shake.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmChallengeController extends GetxController {
  AlarmModel alarmRecord = Get.arguments;

  final RxDouble progress = 1.0.obs;

  final RxInt shakedCount = 0.obs;
  final isShakeOngoing = Status.initialized.obs;
  ShakeDetector? _shakeDetector;
  MobileScannerController? qrController;

  final qrValue = "".obs;
  final isQrOngoing = Status.initialized.obs;

  final isMathsOngoing = Status.initialized.obs;

  final RxInt numMathsQuestions = 0.obs;
  final RxString displayValue = ''.obs;
  final RxString questionText = '0'.obs;
  final RxBool correctAnswer = false.obs;
  int mathsAnswer = 0;
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
    numMathsQuestions.value = alarmRecord.numMathsQuestions;
    List mathsProblemDetails = Utils.generateMathProblem(
        Difficulty.values[alarmRecord.mathsDifficulty]);
    questionText.value = mathsProblemDetails[0];
    displayValue.value = '';
    mathsAnswer = mathsProblemDetails[1];
  }

  @override
  void onInit() async {
    super.onInit();
    _startTimer();

    await FlutterRingtonePlayer.stop();
    if (alarmRecord.isShakeEnabled) {
      isShakeOngoing.listen((value) {
        if (value == Status.ongoing) {
          _shakeDetector = ShakeDetector.autoStart(onPhoneShake: () {
            shakedCount.value -= 1;
            restartTimer();
          });
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
  }

  void _startTimer() async {
    final duration = const Duration(seconds: 15);
    final totalIterations = 1500000;
    final decrement = 0.000001;

    for (var i = totalIterations; i > 0; i--) {
      if (progress.value <= 0.0) {
        Get.until((route) => route.settings.name == '/alarm-ring');
        break;
      }
      await Future.delayed(duration ~/ i);
      progress.value -= decrement;
    }
  }

  restartTimer() {
    progress.value = 1.0; // Reset the progress to its initial value
    _startTimer(); // Start the timer again
  }

  isChallengesComplete() {
    if (!Utils.isChallengeEnabled(alarmRecord)) {
      Get.offAllNamed('/home');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();

    if (!Utils.isChallengeEnabled(alarmRecord)) {
      await FlutterRingtonePlayer.stop();
    } else {
      await FlutterRingtonePlayer.playAlarm();
    }
  }
}
