import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class QrBarCode extends StatelessWidget {
  const QrBarCode({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('QR/Bar Code'),
      onTap: () {
        controller.restartQRCodeController();
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: ksecondaryBackgroundColor,
          title: 'Scan a QR/Bar Code',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Column(
              children: [
                controller.isQrEnabled.value == false
                    ? SizedBox(
                        height: 300,
                        width: 300,
                        child: MobileScanner(
                          controller: controller.qrController,
                          fit: BoxFit.cover,
                          onDetect: (capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                              controller.qrValue.value =
                                  barcode.rawValue.toString();
                              print(barcode.rawValue.toString());
                              controller.isQrEnabled.value = true;
                            }
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(controller.qrValue.value),
                      ),
                controller.isQrEnabled.value == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(kprimaryColor),
                            ),
                            child: Text(
                              'Save',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: ksecondaryTextColor),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(kprimaryColor),
                            ),
                            child: Text(
                              'Retake',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: ksecondaryTextColor),
                            ),
                            onPressed: () async {
                              controller.qrController.dispose();
                              controller.restartQRCodeController();
                              controller.isQrEnabled.value = false;
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
      trailing: InkWell(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.isQrEnabled.value == true ? 'Enabled' : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.isQrEnabled.value == false)
                          ? kprimaryDisabledTextColor
                          : kprimaryTextColor,
                    ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: kprimaryDisabledTextColor,
            )
          ],
        ),
      ),
    );
  }
}
