import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ألوان الهوية الجديدة لتطبيق mBuy (Shein Style)
/// عودي / بني / رصاصي / أبيض / أسود
class MbuyColors {
  // المحور البصري الأساسي - العودي
  static const Color primaryMaroon = Color(0xFF800020); // Burgundy/Maroon
  static const Color primaryMaroonLight = Color(0xFFA52A2A); // Lighter Maroon
  static const Color primaryMaroonDark = Color(0xFF500010); // Darker Maroon

  // الخلفيات الثانوية والبطاقات - بني
  static const Color secondaryBeige = Color(0xFFF5F5DC); // Beige
  static const Color secondaryBrown = Color(0xFFD2B48C); // Tan
  static const Color secondaryBrownDark = Color(0xFF8D6E63); // Brown

  // المحايد
  static const Color background = Color(0xFFFFFFFF); // أبيض نقي
  static const Color surface = Color(0xFFFAFAFA); // أبيض مائل للرمادي قليلاً
  static const Color cardBackground = Color(0xFFFFFFFF); // أبيض نقي

  // النصوص والعناصر
  static const Color textPrimary = Color(0xFF000000); // أسود نقي
  static const Color textSecondary = Color(0xFF616161); // رمادي داكن
  static const Color textTertiary = Color(0xFF9E9E9E); // رمادي متوسط

  // الفواصل والحدود
  static const Color border = Color(0xFFE0E0E0); // رمادي فاتح
  static const Color borderLight = Color(0xFFEEEEEE); // رمادي فاتح جداً

  // التنبيهات
  static const Color alertRed = Color(0xFFFF0000); // أحمر فاقع
  static const Color badgeRed = Color(0xFFFF3B30); // أحمر للإشعارات

  // التدرجات - بسيطة جداً أو معدومة في هذا التصميم
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryMaroon, primaryMaroonLight],
  );

  // --- Compatibility Aliases (Mapping old colors to new palette) ---
  static const Color primaryPurple = primaryMaroon;
  static const Color primaryIndigo = primaryMaroon;
  static const Color primaryBlue = primaryMaroon;
  static const Color secondary = secondaryBrown;
  static const Color success =
      primaryMaroon; // Using primary for success to stick to palette
  static const Color error = alertRed;
  static const Color warning = secondaryBrown;
  static const Color info = textSecondary;

  static const Color successLight = secondaryBeige;
  static const Color errorLight = secondaryBeige;
  static const Color infoLight = secondaryBeige;
  static const Color warningLight = secondaryBeige;

  static const Color surfaceLight = surface;
  static const Color primaryLight = primaryMaroonLight;

  static const Color glassBackground = Color(
    0x0D000000,
  ); // Very light black tint
  static const Color glassBorder = Color(0x1A000000); // Light border

  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, cardBackground],
  );

  static const SweepGradient circularGradient = SweepGradient(
    colors: [primaryMaroon, primaryMaroonLight, primaryMaroon],
    stops: [0.0, 0.5, 1.0],
  );
}

/// الأحجام المعيارية للأيقونات
class MbuyIconSizes {
  static const double bottomNavigation = 24;
  static const double bottomNavigationCenter = 32; // Compatibility alias
  static const double header = 24;
  static const double small = 16;
  static const double medium = 24;
  static const double large = 32;
}

/// نظام المسافات
class MbuySpacing {
  static const double screen = 16;
  static const double section = 24;
  static const double cardPadding = 12;
  static const double itemGap = 8;
  static const double radius = 12; // زوايا ناعمة
  static const double radiusSmall = 8;
  static const double radiusLarge = 20;
}

/// ThemeData الرئيسي للتطبيق
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // الخلفية الأساسية - أبيض
      scaffoldBackgroundColor: MbuyColors.background,

      // ColorScheme
      colorScheme: const ColorScheme.light(
        primary: MbuyColors.primaryMaroon,
        secondary: MbuyColors.secondaryBrown,
        surface: MbuyColors.surface,
        error: MbuyColors.alertRed,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
      ),

      // AppBar Theme - بسيط ونظيف
      appBarTheme: AppBarTheme(
        backgroundColor: MbuyColors.background,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: MbuyColors.textPrimary,
          size: MbuyIconSizes.header,
        ),
        titleTextStyle: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card Theme - بدون ظلال
      cardTheme: CardThemeData(
        color: MbuyColors.cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MbuySpacing.radius),
          side: const BorderSide(color: MbuyColors.borderLight, width: 1),
        ),
      ),

      // Text Theme - أسود فقط
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: GoogleFonts.cairo(
          color: MbuyColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: GoogleFonts.cairo(
          color: MbuyColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MbuyColors.primaryMaroon,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MbuySpacing.radius),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MbuyColors.textPrimary,
          side: const BorderSide(color: MbuyColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MbuySpacing.radius),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MbuyColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MbuySpacing.radiusLarge),
          borderSide: const BorderSide(color: MbuyColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MbuySpacing.radiusLarge),
          borderSide: const BorderSide(color: MbuyColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MbuySpacing.radiusLarge),
          borderSide: const BorderSide(color: MbuyColors.primaryMaroon),
        ),
        hintStyle: GoogleFonts.cairo(
          color: MbuyColors.textTertiary,
          fontSize: 14,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: MbuyColors.primaryMaroon,
        unselectedItemColor: MbuyColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0, // No shadow
        selectedLabelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: MbuyColors.borderLight,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Dark Theme - يمكن إضافته لاحقاً، حالياً التركيز على الفاتح كما في الطلب
  static ThemeData get darkTheme => lightTheme;
}
