import 'package:flutter/material.dart';
import 'mbuy_logo.dart';
import '../../core/theme/app_theme.dart';

/// شاشة الترحيب / البداية
///
/// تعرض:
/// - الخلفية الكحلية
/// - الشعار الدائري في المنتصف (نسخة كبيرة)
/// - نص ترحيبي
class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onComplete;

  const WelcomeScreen({super.key, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الشعار الدائري الكبير
              const MbuyLogo(size: 120),
              const SizedBox(height: 32),
              // النص الترحيبي
              const Text(
                'مرحباً بك في Mbuy',
                style: TextStyle(
                  color: MbuyColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arabic',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'متجرك ومنصّتك في مكان واحد',
                  style: TextStyle(
                    color: MbuyColors.textSecondary,
                    fontSize: 16,
                    fontFamily: 'Arabic',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
