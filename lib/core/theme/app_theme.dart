import 'package:flutter/material.dart';

/// ألوان هوية Mbuy - يمكن تغييرها من هنا فقط
class MbuyColors {
  // الألوان الأساسية من الشعار
  static const Color primaryBlue = Color(0xFF00D2FF);
  static const Color primaryPurple = Color(0xFFFF00FF);
  
  // الخلفيات الفاتحة (وضع فاتح)
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFF0F2F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // النصوص (وضع فاتح)
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  // الألوان الثانوية
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  
  // ألوان ناعمة للخلفيات
  static const Color blueLight = Color(0xFFE0F7FF);
  static const Color purpleLight = Color(0xFFFFE0FF);
  
  // الجراديانت الأساسي (من الأزرق إلى الموف) - ناعم
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryPurple],
  );
  
  // جراديانت ناعم للخلفيات
  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blueLight, purpleLight],
  );
  
  // جراديانت دائري للحدود
  static const SweepGradient circularGradient = SweepGradient(
    colors: [primaryBlue, primaryPurple, primaryBlue],
    stops: [0.0, 0.5, 1.0],
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
      
      // Card Theme - ناعم وحديث
      cardTheme: CardThemeData(
        color: MbuyColors.cardBackground,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
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
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Arabic',
        ),
      ),
      
      // Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}

