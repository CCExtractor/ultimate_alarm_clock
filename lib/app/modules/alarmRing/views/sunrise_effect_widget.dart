import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';

enum SunriseColorScheme {
  natural,  // Orange to yellow to white
  warm,     // Deep red to orange to yellow
  cool,     // Purple to blue to light blue to white
}

class SunriseEffectWidget extends StatefulWidget {
  final bool isEnabled;
  final int durationMinutes;
  final double maxIntensity;
  final SunriseColorScheme colorScheme;
  final VoidCallback? onComplete;

  const SunriseEffectWidget({
    Key? key,
    required this.isEnabled,
    required this.durationMinutes,
    required this.maxIntensity,
    required this.colorScheme,
    this.onComplete,
  }) : super(key: key);

  @override
  State<SunriseEffectWidget> createState() => _SunriseEffectWidgetState();
}

class _SunriseEffectWidgetState extends State<SunriseEffectWidget>
    with TickerProviderStateMixin {
  late AnimationController _brightController;
  late AnimationController _colorController;
  late Animation<double> _brightnessAnimation;
  late Animation<Color?> _colorAnimation;
  
  double _originalBrightness = 0.5;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.isEnabled) {
      _startSunriseEffect();
    }
  }

  void _initializeAnimations() {
    // Brightness animation controller
    _brightController = AnimationController(
      duration: Duration(minutes: widget.durationMinutes),
      vsync: this,
    );

    // Color animation controller
    _colorController = AnimationController(
      duration: Duration(minutes: widget.durationMinutes),
      vsync: this,
    );

    // Brightness animation (0.0 to maxIntensity)
    _brightnessAnimation = Tween<double>(
      begin: 0.0,
      end: widget.maxIntensity,
    ).animate(CurvedAnimation(
      parent: _brightController,
      curve: Curves.easeInOut,
    ));

    // Color animation based on selected scheme
    _colorAnimation = _createColorAnimation();

    // Listen for animation updates
    _brightController.addListener(_updateBrightness);
    _colorController.addListener(_updateUI);
    
    // Complete callback
    _brightController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  Animation<Color?> _createColorAnimation() {
    List<Color> colors;
    
    switch (widget.colorScheme) {
      case SunriseColorScheme.natural:
        colors = [
          const Color(0xFF1a1a1a), // Dark
          const Color(0xFF4a2c2a), // Deep brown
          const Color(0xFFCD853F), // Peru/tan
          const Color(0xFFffa500), // Orange
          const Color(0xFFffff99), // Light yellow
          const Color(0xFFffffff), // White
        ];
        break;
      case SunriseColorScheme.warm:
        colors = [
          const Color(0xFF1a1a1a), // Dark
          const Color(0xFF8B0000), // Dark red
          const Color(0xFFFF4500), // Orange red
          const Color(0xFFFF8C00), // Dark orange
          const Color(0xFFFFD700), // Gold
          const Color(0xFFfffaf0), // Warm white
        ];
        break;
      case SunriseColorScheme.cool:
        colors = [
          const Color(0xFF1a1a1a), // Dark
          const Color(0xFF191970), // Midnight blue
          const Color(0xFF4169E1), // Royal blue
          const Color(0xFF87CEEB), // Sky blue
          const Color(0xFFE0F6FF), // Light cyan
          const Color(0xFFffffff), // White
        ];
        break;
    }

    return TweenSequence<Color?>(
      colors.asMap().entries.map((entry) {
        int index = entry.key;
        Color color = entry.value;
        
        return TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: index == 0 ? color : colors[index - 1],
            end: color,
          ),
          weight: 1.0,
        );
      }).toList(),
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startSunriseEffect() async {
    if (_isActive) return;
    
    _isActive = true;
    
    try {
      // Store original brightness
      _originalBrightness = await ScreenBrightness().current;
      
      // Set initial low brightness
      await ScreenBrightness().setScreenBrightness(0.0);
      
      // Start both animations
      _brightController.forward();
      _colorController.forward();
      
    } catch (e) {
      debugPrint('Error starting sunrise effect: $e');
    }
  }

  void _updateBrightness() {
    if (!_isActive) return;
    
    try {
      ScreenBrightness().setScreenBrightness(_brightnessAnimation.value);
    } catch (e) {
      debugPrint('Error updating brightness: $e');
    }
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _stopSunriseEffect() async {
    if (!_isActive) return;
    
    _isActive = false;
    
    try {
      // Stop animations
      _brightController.stop();
      _colorController.stop();
      
      // Restore original brightness
      await ScreenBrightness().setScreenBrightness(_originalBrightness);
    } catch (e) {
      debugPrint('Error stopping sunrise effect: $e');
    }
  }

  @override
  void dispose() {
    _stopSunriseEffect();
    _brightController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_brightController, _colorController]),
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, -0.3), // Sun position
              radius: 1.5,
              colors: [
                _colorAnimation.value ?? Colors.black,
                _colorAnimation.value?.withOpacity(0.8) ?? Colors.black,
                _colorAnimation.value?.withOpacity(0.4) ?? Colors.black,
                Colors.black.withOpacity(0.9),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: _buildSunAnimation(),
        );
      },
    );
  }

  Widget _buildSunAnimation() {
    // Sun disc that appears during later stages
    final sunProgress = (_colorController.value * 2 - 0.5).clamp(0.0, 1.0);
    
    if (sunProgress <= 0) return const SizedBox.shrink();
    
    return Positioned(
      top: MediaQuery.of(context).size.height * (0.2 - sunProgress * 0.1),
      left: MediaQuery.of(context).size.width * 0.5 - 50,
      child: AnimatedOpacity(
        opacity: sunProgress,
        duration: const Duration(milliseconds: 500),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.yellow.withOpacity(0.8),
                Colors.orange.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: (_colorAnimation.value ?? Colors.orange).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to add sunrise effect to existing alarm ring
extension SunriseEffectExtension on Widget {
  Widget withSunriseEffect({
    required bool isEnabled,
    required int durationMinutes,
    required double intensity,
    required int colorSchemeIndex,
  }) {
    if (!isEnabled) return this;
    
    final colorScheme = SunriseColorScheme.values[colorSchemeIndex.clamp(0, 2)];
    
    return Stack(
      children: [
        SunriseEffectWidget(
          isEnabled: isEnabled,
          durationMinutes: durationMinutes,
          maxIntensity: intensity,
          colorScheme: colorScheme,
        ),
        this,
      ],
    );
  }
} 