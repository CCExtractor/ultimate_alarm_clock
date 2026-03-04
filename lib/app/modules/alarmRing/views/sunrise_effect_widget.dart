import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

enum SunriseColorScheme {
  natural, // Orange to yellow to white
  warm, // Deep red to orange to yellow
  cool, // Purple to blue to light blue to white
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
    final duration = Duration(minutes: widget.durationMinutes);
    _brightController = AnimationController(duration: duration, vsync: this);
    _colorController = AnimationController(duration: duration, vsync: this);

    _brightnessAnimation = Tween<double>(
      begin: 0.0,
      end: widget.maxIntensity,
    ).animate(
      CurvedAnimation(parent: _brightController, curve: Curves.easeInOut),
    );

    _colorAnimation = _createColorAnimation();

    _brightController.addListener(_updateBrightness);
    _colorController.addListener(_updateUI);

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
          const Color(0xFF1a1a1a),
          const Color(0xFF4a2c2a),
          const Color(0xFFCD853F),
          const Color(0xFFffa500),
          const Color(0xFFffff99),
          const Color(0xFFffffff),
        ];
        break;
      case SunriseColorScheme.warm:
        colors = [
          const Color(0xFF1a1a1a),
          const Color(0xFF8B0000),
          const Color(0xFFFF4500),
          const Color(0xFFFF8C00),
          const Color(0xFFFFD700),
          const Color(0xFFfffaf0),
        ];
        break;
      case SunriseColorScheme.cool:
        colors = [
          const Color(0xFF1a1a1a),
          const Color(0xFF191970),
          const Color(0xFF4169E1),
          const Color(0xFF87CEEB),
          const Color(0xFFE0F6FF),
          const Color(0xFFffffff),
        ];
        break;
    }

    return TweenSequence<Color?>(
      List.generate(colors.length, (index) {
        final begin = index == 0 ? colors[0] : colors[index - 1];
        final end = colors[index];
        return TweenSequenceItem<Color?>(
          tween: ColorTween(begin: begin, end: end),
          weight: 1.0,
        );
      }),
    ).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startSunriseEffect() async {
    if (_isActive) return;
    _isActive = true;
    try {
      _originalBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(0.0);
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
    } catch (_) {}
  }

  void _updateUI() {
    if (mounted) setState(() {});
  }

  Future<void> _stopSunriseEffect() async {
    if (!_isActive) return;
    _isActive = false;
    try {
      _brightController.stop();
      _colorController.stop();
      await ScreenBrightness().setScreenBrightness(_originalBrightness);
    } catch (_) {}
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
    if (!widget.isEnabled) return const SizedBox.shrink();

    final sunProgress =
        (_colorController.value * 2 - 0.5).clamp(0.0, 1.0);
    final currentColor = _colorAnimation.value ?? Colors.black;

    return AnimatedBuilder(
      animation: Listenable.merge([_brightController, _colorController]),
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.3),
                  radius: 1.5,
                  colors: [
                    currentColor,
                    currentColor.withOpacity(0.8),
                    currentColor.withOpacity(0.4),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
            if (sunProgress > 0)
              Positioned(
                top: MediaQuery.of(context).size.height *
                    (0.18 - sunProgress * 0.05),
                left:
                    MediaQuery.of(context).size.width * 0.5 - 55,
                child: Opacity(
                  opacity: sunProgress.clamp(0.0, 1.0),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.9),
                          Colors.orange.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
