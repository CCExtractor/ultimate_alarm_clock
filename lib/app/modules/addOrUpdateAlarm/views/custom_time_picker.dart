import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

/// Custom time picker designed for better font scaling and accessibility
/// Alternative to NumberPicker when standard implementation has issues
class CustomTimePicker extends StatelessWidget {
  final int hours;
  final int minutes;
  final int meridiemIndex;
  final bool is24Hour;
  final Function(int) onHoursChanged;
  final Function(int) onMinutesChanged;
  final Function(int) onMeridiemChanged;
  final Color primaryColor;
  final Color textColor;
  final Color disabledTextColor;
  final double scalingFactor;

  const CustomTimePicker({
    Key? key,
    required this.hours,
    required this.minutes,
    required this.meridiemIndex,
    required this.is24Hour,
    required this.onHoursChanged,
    required this.onMinutesChanged,
    required this.onMeridiemChanged,
    required this.primaryColor,
    required this.textColor,
    required this.disabledTextColor,
    this.scalingFactor = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final systemScale = MediaQuery.textScaleFactorOf(context);
    final effectiveScale = scalingFactor * systemScale;

    // Calculate responsive widths
    final timeUnitWidth = (width * 0.18).clamp(80.0, 120.0);
    final meridiemWidth = (width * 0.2).clamp(80.0, 100.0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hours picker
          _buildTimeUnitPicker(
            context: context,
            value: hours,
            minValue: is24Hour ? 0 : 1,
            maxValue: is24Hour ? 23 : 12,
            onChanged: onHoursChanged,
            width: timeUnitWidth,
            effectiveScale: effectiveScale,
          ),
          
          // Colon separator
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Text(
              ':',
              style: TextStyle(
                fontSize: (32 * effectiveScale).clamp(24.0, 48.0),
                fontWeight: FontWeight.bold,
                color: disabledTextColor,
              ),
            ),
          ),
          
          // Minutes picker
          _buildTimeUnitPicker(
            context: context,
            value: minutes,
            minValue: 0,
            maxValue: 59,
            onChanged: onMinutesChanged,
            width: timeUnitWidth,
            effectiveScale: effectiveScale,
          ),
          
          // AM/PM picker (for 12-hour format)
          if (!is24Hour) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Text(
                '',
                style: TextStyle(
                  fontSize: (32 * effectiveScale).clamp(24.0, 48.0),
                  fontWeight: FontWeight.bold,
                  color: disabledTextColor,
                ),
              ),
            ),
            _buildMeridiemPicker(
              context: context,
              width: meridiemWidth,
              effectiveScale: effectiveScale,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeUnitPicker({
    required BuildContext context,
    required int value,
    required int minValue,
    required int maxValue,
    required Function(int) onChanged,
    required double width,
    required double effectiveScale,
  }) {
    return Container(
      width: width,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.25,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Plus button
          _buildControlButton(
            context: context,
            icon: Icons.keyboard_arrow_up,
            onPressed: () {
              Utils.hapticFeedback();
              int newValue = value + 1;
              if (newValue > maxValue) newValue = minValue;
              onChanged(newValue);
            },
            effectiveScale: effectiveScale,
          ),
          
          // Current value display
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: (4 * effectiveScale).clamp(2.0, 12.0),
                horizontal: 4,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: (24 * effectiveScale).clamp(20.0, 48.0),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          
          // Minus button
          _buildControlButton(
            context: context,
            icon: Icons.keyboard_arrow_down,
            onPressed: () {
              Utils.hapticFeedback();
              int newValue = value - 1;
              if (newValue < minValue) newValue = maxValue;
              onChanged(newValue);
            },
            effectiveScale: effectiveScale,
          ),
        ],
      ),
    );
  }

  Widget _buildMeridiemPicker({
    required BuildContext context,
    required double width,
    required double effectiveScale,
  }) {
    return Container(
      width: width,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.25,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toggle button
          _buildControlButton(
            context: context,
            icon: Icons.swap_vert,
            onPressed: () {
              Utils.hapticFeedback();
              onMeridiemChanged(meridiemIndex == 0 ? 1 : 0);
            },
            effectiveScale: effectiveScale,
          ),
          
          // Current AM/PM display
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: (4 * effectiveScale).clamp(2.0, 12.0),
                horizontal: 4,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  meridiemIndex == 0 ? 'AM' : 'PM',
                  style: TextStyle(
                    fontSize: (20 * effectiveScale).clamp(16.0, 36.0),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          
          // Spacer for symmetry
          Flexible(
            child: SizedBox(height: (20 * effectiveScale).clamp(16.0, 40.0)),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required double effectiveScale,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all((6 * effectiveScale).clamp(4.0, 12.0)),
        constraints: BoxConstraints(
          minHeight: 32,
          minWidth: 32,
        ),
        child: Icon(
          icon,
          color: primaryColor,
          size: (20 * effectiveScale).clamp(16.0, 32.0),
        ),
      ),
    );
  }
}