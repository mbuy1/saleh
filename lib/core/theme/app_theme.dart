import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ألوان هوية mBuy - Meta AI Style × mBuy Purple Identity
class MbuyColors {
  // الألوان الأساسية - mBuy Purple Palette
  static const Color primaryPurple = Color(0xFF7B2CF5); // mBuy Purple
  static const Color primaryLight = Color(0xFFA46CFF); // Soft Purple
  static const Color primaryDark = Color(0xFF5320A0); // Deep Purple
  static const Color primarySubtle = Color(0xFFF5F0FF); // Background Tint

  // الخلفيات - White & Clean
  static const Color background = Color(0xFFFFFFFF); // Pure White
  static const Color surface = Color(0xFFF7F7F9); // Soft Gray
  static const Color surfaceDark = Color(0xFFF0F0F2); // Card Hover
  static const Color cardBackground = Color(0xFFFFFFFF);

  // النصوص - Clean & Clear
  static const Color textPrimary = Color(0xFF1A1A1A); // Main Content
  static const Color textSecondary = Color(0xFF6A6A6A); // Descriptions
  static const Color textTertiary = Color(0xFF9A9A9A); // Placeholders

  // الحدود - Soft Borders
  static const Color borderLight = Color(0xFFE6E6E8); // Dividers
  static const Color border = Color(0xFFD0D0D2); // Input Borders

  // Backward compatibility aliases (للألوان القديمة)
  static const Color primaryBlue = primaryPurple; // مرادف للون الأساسي الجديد
  static const Color accentPink = primaryLight; // مرادف للون الفاتح
  static const Color surfaceLight = surface; // مرادف للسطح
  static const LinearGradient cardGradient = subtleGradient; // مرادف للتدرج

  // ألوان الحالات - Status Colors
  static const Color success = Color(0xFF22CC88); // Green
  static const Color successLight = Color(0xFFE6F9F0); // Background
  static const Color error = Color(0xFFFF4D4F); // Red
  static const Color errorLight = Color(0xFFFFF0F0); // Background
  static const Color warning = Color(0xFFFFA940); // Orange
  static const Color warningLight = Color(0xFFFFF7E6); // Background
  static const Color info = Color(0xFF40A9FF); // Blue
  static const Color infoLight = Color(0xFFE6F7FF); // Background

  // التدرجات - Purple Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryLight],
  );

  // تدرج غامق للأزرار
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryPurple],
  );

  // تدرج ناعم للبطاقات والخلفيات
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primarySubtle, Color(0xFFFFFFFF)],
  );

  // تدرج دائري للأيقونات
  static const SweepGradient circularGradient = SweepGradient(
    colors: [primaryPurple, primaryLight, primaryPurple],
    stops: [0.0, 0.5, 1.0],
  );

  // تدرجات الحالات
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF059669)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, Color(0xFFDC2626)],
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

      // ColorScheme - mBuy Purple Identity
      colorScheme: const ColorScheme.light(
        primary: MbuyColors.primaryPurple,
        secondary: MbuyColors.primaryLight,
        surface: MbuyColors.surface,
        error: MbuyColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: MbuyColors.textPrimary,
        onError: Colors.white,
      ),

      // AppBar Theme - Clean & Modern
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: MbuyColors.textPrimary),
        titleTextStyle: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // Card Theme - Soft Shadows & 16px Radius
      cardTheme: CardThemeData(
        color: MbuyColors.cardBackground,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Text Theme - Cairo Font System
      textTheme: TextTheme(
        // Hero Title - 28px SemiBold
        displayLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.29,
        ),
        // Page Title - 20px SemiBold
        displayMedium: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        // Section Title - 17px Medium
        displaySmall: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.41,
        ),
        // Stats/Numbers - 18px Bold
        headlineLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.33,
          letterSpacing: -0.2,
        ),
        // Subtitle - 17px Medium
        headlineMedium: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.41,
        ),
        // Body Large - 16px Regular
        headlineSmall: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        // Title Medium - 15px SemiBold
        titleLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        // Title Small - 14px Medium
        titleMedium: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        // Body - 14px Regular
        bodyLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.57,
        ),
        // Body Secondary - 14px Regular
        bodyMedium: GoogleFonts.cairo(
          color: MbuyColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.57,
        ),
        // Small - 12px Regular
        bodySmall: GoogleFonts.cairo(
          color: MbuyColors.textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        // Caption - 11px Regular
        labelSmall: GoogleFonts.cairo(
          color: MbuyColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        // Label - 14px Medium
        labelLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Elevated Button Theme - Purple with Glow
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MbuyColors.primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: MbuyColors.primaryPurple.withValues(alpha: 0.2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MbuyColors.primaryPurple,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme - 12px Radius
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: MbuyColors.borderLight,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: MbuyColors.borderLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: MbuyColors.primaryPurple,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MbuyColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.cairo(
          color: MbuyColors.textSecondary,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.cairo(
          color: MbuyColors.textTertiary,
          fontSize: 14,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: MbuyColors.primaryPurple,
        unselectedItemColor: MbuyColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.cairo(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12),
      ),

      // Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  /// Dark Theme - الثيم الداكن
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // الخلفية الأساسية
      scaffoldBackgroundColor: const Color(0xFF121212),

      // ColorScheme - Dark Mode
      colorScheme: const ColorScheme.dark(
        primary: MbuyColors.primaryPurple,
        secondary: MbuyColors.primaryLight,
        surface: Color(0xFF1E1E1E),
        error: MbuyColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Text Theme - Cairo Font System
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.29,
        ),
        displayMedium: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        displaySmall: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.41,
        ),
        headlineLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.33,
          letterSpacing: -0.2,
        ),
        headlineMedium: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.41,
        ),
        headlineSmall: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        titleLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.57,
        ),
        bodyMedium: GoogleFonts.cairo(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.57,
        ),
        bodySmall: GoogleFonts.cairo(
          color: Colors.white60,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        labelSmall: GoogleFonts.cairo(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        labelLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MbuyColors.primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: MbuyColors.primaryPurple.withValues(alpha: 0.2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MbuyColors.primaryPurple,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF404040), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF404040), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: MbuyColors.primaryPurple,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MbuyColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
        hintStyle: GoogleFonts.cairo(color: Colors.white60, fontSize: 14),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: MbuyColors.primaryPurple,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.cairo(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12),
      ),

      // Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
      ),
    );
  }
}
