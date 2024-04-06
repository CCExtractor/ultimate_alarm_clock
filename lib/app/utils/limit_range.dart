import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LimitRange extends TextInputFormatter {
  LimitRange(
    this.minRange,
    this.maxRange,
  ) : assert(
          minRange < maxRange,
        );

  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      var value = int.parse(newValue.text);
      if (value < minRange) {
        return TextEditingValue(text: minRange.toString());
      } else if (value > maxRange) {
        return TextEditingValue(text: maxRange.toString());
      }
      return newValue;
    } catch (e) {
      debugPrint(e.toString());
      return newValue;
    }
  }
}
