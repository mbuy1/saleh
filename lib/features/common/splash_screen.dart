import 'package:flutter/material.dart';
import '../../shared/widgets/smiley_cart_logo.dart';
import '../../core/constants/app_constants.dart';

/// شاشة البداية (Splash Screen) مع رسوم متحركة
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.bounceAnimationDuration,
    );

    // إعداد Bounce Animation (من 0.5 إلى 1.0)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppConstants.bounceCurve),
    );

    // بدء الرسوم المتحركة
    _controller.forward();

    // الانتقال للشاشة الرئيسية بعد 2.5 ثانية
    Future.delayed(AppConstants.splashScreenDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: const SmileyCartLogo(
            size: AppConstants.largeLogoSize,
            withShadow: true,
          ),
        ),
      ),
    );
  }
}
