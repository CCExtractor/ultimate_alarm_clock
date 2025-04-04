import 'package:flutter/material.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with SingleTickerProviderStateMixin<SplashScreenView> {
  AnimationController? controller;
  Animation<double>? colorAnimation;

  @override
  void initState() {
    super.initState();

    // ignore: avoid_print
    print('this is callling in initstate');
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    colorAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.bounceOut));
    WidgetsBinding.instance.scheduleFrameCallback((_) async {
      controller!.addListener(() {
        setState(() {});
      });

      controller!.addStatusListener((status) async {
        if (status == AnimationStatus.completed) {}
      });

      controller!.forward();
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SizedBox(
          height: 250 * colorAnimation!.value,
          child: Image.asset('assets/images/splashscreen.png'),
        ),
      ),
    );
  }
}
