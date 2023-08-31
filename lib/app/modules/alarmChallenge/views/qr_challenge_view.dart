import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ultimate_alarm_clock/app/services/haptic_feedback_service.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

import '../controllers/alarm_challenge_controller.dart';

class QRChallengeView extends GetView<AlarmChallengeController> {
  QRChallengeView({Key? key}) : super(key: key);

  final HapticFeebackService _hapticFeebackService = Get.find();

  void _hapticFeedback() {
    _hapticFeebackService.hapticFeedback();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var width = Get.width;
    var height = Get.height;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            _hapticFeedback();
            controller.restartTimer();
          },
          child: Column(
            children: [
              Obx(
                () => LinearProgressIndicator(
                  minHeight: 2,
                  value: controller.progress.value,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Scan your QR/Bar Code!',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color:
                                          kprimaryTextColor.withOpacity(0.7)),
                            ),
                            SizedBox(
                              height: height * 0.08,
                            ),
                            Obx(
                              () => Column(
                                children: [
                                  (controller.isQrOngoing.value ==
                                          Status.initialized)
                                      ? SizedBox(
                                          height: 300,
                                          width: 300,
                                          child: MobileScanner(
                                            controller: controller.qrController,
                                            fit: BoxFit.cover,
                                            onDetect: (capture) {
                                              final List<Barcode> barcodes =
                                                  capture.barcodes;
                                              for (final barcode in barcodes) {
                                                controller.qrValue.value =
                                                    barcode.rawValue.toString();

                                                if (controller.qrValue.value !=
                                                    controller
                                                        .alarmRecord.qrValue) {
                                                  controller.isQrOngoing.value =
                                                      Status.ongoing;
                                                } else {
                                                  controller.isQrOngoing.value =
                                                      Status.completed;
                                                }
                                              }
                                            },
                                          ),
                                        )
                                      : SizedBox(
                                          height: 300,
                                          width: 300,
                                          child: Center(
                                              child: (controller
                                                          .qrValue.value ==
                                                      controller
                                                          .alarmRecord.qrValue)
                                                  ? Icon(
                                                      Icons.done,
                                                      size: height * 0.2,
                                                      color: kprimaryTextColor
                                                          .withOpacity(0.7),
                                                    )
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Icon(
                                                          Icons.close,
                                                          size: height * 0.2,
                                                          color:
                                                              kprimaryTextColor
                                                                  .withOpacity(
                                                                      0.7),
                                                        ),
                                                        Text(
                                                          'Wrong Code Scanned!',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: kprimaryTextColor
                                                                      .withOpacity(
                                                                          0.7)),
                                                        ),
                                                        TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                          kprimaryColor)),
                                                          child: Text(
                                                            'Retake',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displaySmall!
                                                                .copyWith(
                                                                    color:
                                                                        ksecondaryTextColor),
                                                          ),
                                                          onPressed: () async {
                                                            _hapticFeedback();
                                                            controller
                                                                .qrController!
                                                                .dispose();
                                                            controller
                                                                .restartQRCodeController();
                                                            controller
                                                                    .isQrOngoing
                                                                    .value =
                                                                Status
                                                                    .initialized;
                                                          },
                                                        ),
                                                      ],
                                                    )),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
