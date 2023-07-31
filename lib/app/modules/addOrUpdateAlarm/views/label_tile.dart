import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class LabelTile extends StatelessWidget {
  const LabelTile({
    super.key,
    required this.controller,
  });

  final AddOrUpdateAlarmController controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: ksecondaryBackgroundColor,
      title: const Text(
        'Label',
        style: TextStyle(color: kprimaryTextColor),
      ),
      onTap: () {
        Get.defaultDialog(
          title: "Enter a name",
          titlePadding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
          backgroundColor: ksecondaryBackgroundColor,
          titleStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: kprimaryTextColor),
          contentPadding: const EdgeInsets.all(21),
          content: TextField(
            autofocus: true,
            controller: controller.labelController,
            style: Theme.of(context).textTheme.bodyLarge,
            cursorColor: kprimaryTextColor.withOpacity(0.75),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kprimaryTextColor.withOpacity(0.75), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kprimaryTextColor.withOpacity(0.75), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kprimaryTextColor.withOpacity(0.75), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                hintText: 'Enter a name',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: kprimaryDisabledTextColor)),
          ),
          buttonColor: ksecondaryBackgroundColor,
          confirm: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kprimaryColor)),
            child: Text(
              'Save',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: ksecondaryTextColor),
            ),
            onPressed: () {
              controller.label.value = controller.labelController.text;
              Get.back();
            },
          ),
        );
      },
      trailing: InkWell(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Obx(
              () => Text(
                controller.label.value.isNotEmpty
                    ? controller.label.value
                    : 'Off',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (controller.label.value.isEmpty)
                          ? kprimaryDisabledTextColor
                          : kprimaryTextColor,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: (controller.label.value.isEmpty)
                  ? kprimaryDisabledTextColor
                  : kprimaryTextColor,
            )
          ],
        ),
      ),
    );
  }
}
