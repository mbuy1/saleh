import 'package:flutter/material.dart';

/// ألوان هوية Mbuy - تصميم عصري وجذاب
class MbuyColors {
  // الألوان الأساسية - تدرجات حديثة
  static const Color primaryBlue = Color(0xFF0EA5E9); // Sky Blue
  static const Color primaryPurple = Color(0xFF8B5CF6); // Violet
  static const Color accentPink = Color(0xFFEC4899); // Pink accent

  // الخلفيات الحديثة
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF3F4F6);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // النصوص
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // الألوان الثانوية
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // ألوان التدرجات الخفيفة
  static const Color blueLight = Color(0xFFE0F2FE);
  static const Color purpleLight = Color(0xFFF3E8FF);
  static const Color pinkLight = Color(0xFFFCE7F3);

  // التدرجات العصرية - من أزرق سماوي لبنفسجي لوردي
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryPurple, accentPink],
  );

  // تدرج ناعم للبطاقات
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEFF6FF), Color(0xFFF5F3FF)],
  );

  // تدرج للخلفيات
  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blueLight, purpleLight, pinkLight],
  );

  // تدرج دائري للأيقونات
  static const SweepGradient circularGradient = SweepGradient(
    colors: [primaryBlue, primaryPurple, accentPink, primaryBlue],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  // تدرجات إضافية
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );
}

/// ThemeData الرئيسي للتطبيق
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // الخلفية الأساسية
      scaffoldBackgroundColor: MbuyColors.background,

      // ColorScheme
      colorScheme: const ColorScheme.light(
        primary: MbuyColors.primaryBlue,
        secondary: MbuyColors.primaryPurple,
        surface: MbuyColors.surface,
        error: MbuyColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: MbuyColors.textPrimary,
        onError: Colors.white,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: MbuyColors.textPrimary),
        titleTextStyle: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Arabic',
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // Card Theme - عصري مع ظل ناعم
      cardTheme: CardThemeData(
        color: MbuyColors.cardBackground,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Text Theme - ناعم وواضح
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontFamily: 'Arabic',
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'Arabic',
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'Arabic',
        ),
        headlineLarge: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Arabic',
        ),
        headlineMedium: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Arabic',
        ),
        headlineSmall: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Arabic',
        ),
        titleLarge: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Arabic',
        ),
        titleMedium: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Arabic',
        ),
        bodyLarge: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: 'Arabic',
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: MbuyColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'Arabic',
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: MbuyColors.textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Arabic',
        ),
        labelLarge: TextStyle(
          color: MbuyColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Arabic',
        ),
      ),

      // Elevated Button Theme - عصري
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MbuyColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: MbuyColors.primaryBlue.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Arabic',
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MbuyColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Input Decoration Theme - ناعم
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MbuyColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MbuyColors.primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(
          color: MbuyColors.textSecondary,
          fontFamily: 'Arabic',
        ),
        hintStyle: const TextStyle(
          color: MbuyColors.textTertiary,
          fontFamily: 'Arabic',
        ),
      ),

      // Bottom Navigation Bar Theme - ناعم
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: MbuyColors.primaryBlue,
        unselectedItemColor: MbuyColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Arabic',
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Arabic'),
      ),

      // Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
