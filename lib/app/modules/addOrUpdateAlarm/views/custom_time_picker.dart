import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';


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
    final systemScale = MediaQuery.textScalerOf(context).scale(1.0);
    final effectiveScale = scalingFactor * systemScale;


    final timeUnitWidth = (width * 0.18).clamp(80.0, 120.0);
    final meridiemWidth = (width * 0.2).clamp(80.0, 100.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.02),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Expanded(
              flex: 3,
              child: _buildTimeUnitPicker(
                context: context,
                value: hours,
                minValue: is24Hour ? 0 : 1,
                maxValue: is24Hour ? 23 : 12,
                onChanged: onHoursChanged,
                width: timeUnitWidth,
                effectiveScale: effectiveScale,
              ),
            ),
            

            Container(
              width: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: (32 * effectiveScale).clamp(24.0, 48.0),
                    fontWeight: FontWeight.bold,
                    color: primaryColor.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            
            
            Expanded(
              flex: 3,
              child: _buildTimeUnitPicker(
                context: context,
                value: minutes,
                minValue: 0,
                maxValue: 59,
                onChanged: onMinutesChanged,
                width: timeUnitWidth,
                effectiveScale: effectiveScale,
              ),
            ),
            
            
            if (!is24Hour) ...[
              Container(
                width: 16,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: Container(
                    width: 2,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryColor.withOpacity(0.2),
                          primaryColor.withOpacity(0.6),
                          primaryColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildMeridiemPicker(
                  context: context,
                  width: meridiemWidth,
                  effectiveScale: effectiveScale,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  
  BoxDecoration _getPickerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          textColor.withOpacity(0.02),
          textColor.withOpacity(0.05),
          textColor.withOpacity(0.02),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: primaryColor.withOpacity(0.15),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.1),
          blurRadius: 1,
          offset: const Offset(0, -1),
        ),
      ],
    );
  }

  
  BoxDecoration _getSelectionDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withOpacity(0.15),
          primaryColor.withOpacity(0.25),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: primaryColor.withOpacity(0.4),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.2),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  
  TextStyle _getPickerTextStyle({
    required double effectiveScale,
    required bool isSelected,
    double? letterSpacing,
    bool isAmPm = false,
  }) {
    
    final selectedSize = isAmPm ? 24.0 : 28.0;
    final unselectedSize = isAmPm ? 18.0 : 20.0;
    final selectedClampMax = isAmPm ? 42.0 : 48.0;
    final unselectedClampMax = isAmPm ? 32.0 : 36.0;
    final unselectedClampMin = isAmPm ? 14.0 : 16.0;
    
    return TextStyle(
      fontSize: isSelected 
          ? (selectedSize * effectiveScale).clamp(20.0, selectedClampMax)
          : (unselectedSize * effectiveScale).clamp(unselectedClampMin, unselectedClampMax),
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      color: isSelected 
          ? primaryColor 
          : textColor.withOpacity(0.6),
      letterSpacing: letterSpacing,
      shadows: isSelected ? [
        Shadow(
          color: primaryColor.withOpacity(0.3),
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ] : null,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = (50 * effectiveScale).clamp(40.0, 80.0);
    final totalHeight = (screenHeight * 0.22).clamp(140.0, 280.0);
    
    
    List<int> values = [];
    for (int i = minValue; i <= maxValue; i++) {
      values.add(i);
    }
    
    
    final valuesCount = values.length;
    final virtualListSize = valuesCount * 1000; // Large enough for smooth infinite scrolling
    final centerOffset = virtualListSize ~/ 2;
    
    
    final initialVirtualIndex = centerOffset + (value - minValue);
    final scrollController = FixedExtentScrollController(
      initialItem: initialVirtualIndex,
    );
    
    return Container(
      height: totalHeight,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: _getPickerDecoration(),
      child: Stack(
        children: [
          
          Positioned(
            top: (totalHeight - itemHeight) / 2,
            left: 4,
            right: 4,
            height: itemHeight,
            child: Container(
              decoration: _getSelectionDecoration(),
            ),
          ),
          
          
          ListWheelScrollView.useDelegate(
            controller: scrollController,
            itemExtent: itemHeight,
            perspective: 0.003,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (virtualIndex) {

              final actualIndex = virtualIndex % valuesCount;
              final actualValue = values[actualIndex];
              Utils.hapticFeedback();
              onChanged(actualValue);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, virtualIndex) {
                
                final actualIndex = virtualIndex % valuesCount;
                final itemValue = values[actualIndex];
                final isSelected = itemValue == value;
                
                return Container(
                  height: itemHeight,
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      itemValue.toString().padLeft(2, '0'),
                      style: _getPickerTextStyle(
                        effectiveScale: effectiveScale,
                        isSelected: isSelected,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              childCount: virtualListSize,
            ),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = (50 * effectiveScale).clamp(40.0, 80.0);
    final totalHeight = (screenHeight * 0.22).clamp(140.0, 280.0);
    
    final meridiemOptions = ['AM', 'PM'];
    
    
    final virtualListSize = 1000; 
    final centerOffset = virtualListSize ~/ 2;
    
    
    final initialVirtualIndex = centerOffset + meridiemIndex;
    final scrollController = FixedExtentScrollController(
      initialItem: initialVirtualIndex,
    );
    
    return Container(
      height: totalHeight,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: _getPickerDecoration(),
      child: Stack(
        children: [
          
          Positioned(
            top: (totalHeight - itemHeight) / 2,
            left: 4,
            right: 4,
            height: itemHeight,
            child: Container(
              decoration: _getSelectionDecoration(),
            ),
          ),
          
          
          ListWheelScrollView.useDelegate(
            controller: scrollController,
            itemExtent: itemHeight,
            perspective: 0.003,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (virtualIndex) {
              
              final actualIndex = virtualIndex % meridiemOptions.length;
              Utils.hapticFeedback();
              onMeridiemChanged(actualIndex);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, virtualIndex) {
                
                final actualIndex = virtualIndex % meridiemOptions.length;
                final isSelected = actualIndex == meridiemIndex;
                
                return Container(
                  height: itemHeight,
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      meridiemOptions[actualIndex],
                      style: _getPickerTextStyle(
                        effectiveScale: effectiveScale,
                        isSelected: isSelected,
                        letterSpacing: 1.2,
                        isAmPm: true,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              childCount: virtualListSize,
            ),
          ),
        ],
      ),
    );
  }


}