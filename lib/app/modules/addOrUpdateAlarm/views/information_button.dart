import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class InformationButton extends StatelessWidget {
  const InformationButton({
    super.key,
    required this.infoIconData,
    required this.height,
    required this.width,
    required this.infoTitle,
    required this.infoDescription,
  });

  final IconData infoIconData;
  final double height;
  final double width;
  final String infoTitle;
  final String infoDescription;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.info_sharp,
        size: 21,
        color: kprimaryTextColor.withOpacity(0.3),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: ksecondaryBackgroundColor,
          builder: (context) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      infoIconData,
                      color: kprimaryTextColor,
                      size: height * 0.1,
                    ),
                    Text(
                      infoTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        infoDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kprimaryColor),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'Understood',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: ksecondaryTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
