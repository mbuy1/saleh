import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ألوان الهوية النظيفة لتطبيق mBuy
/// أبيض / أسود / رمادي / أصفر للعروض / أحمر للتنبيهات / أخضر للنجاح
class MbuyColors {
  // الهوية الأساسية - بنفسجي Material Design Purple 500
  static const Color primaryIndigo = Color(0xFF6200EE); // #6200EE - Material Purple 500
  static const Color primaryDeep = Color(0xFF3700B3); // Purple 700 - أغمق للدرجات
  static const Color primaryHighlight = Color(0xFF9D46FF); // Purple 300 - أفتح للتمييز

  // المحايد
  static const Color background = Color(0xFFFFFFFF); // أبيض نقي
  static const Color surface = Color(0xFFF8F9FA); // رمادي فاتح جداً
  static const Color cardBackground = Color(0xFFFFFFFF); // أبيض نقي
  static const Color textPrimary = Color(0xFF333333); // رمادي داكن للنصوص
  static const Color textSecondary = Color(0xFF6C757D); // رمادي متوسط
  static const Color textTertiary = Color(0xFF9E9E9E); // رمادي فاتح
  static const Color borderLight = Color(0xFFDEE2E6); // رمادي فاتح
  static const Color border = Color(0xFFDEE2E6); // رمادي فاتح
  static const Color luxuryBlack = Color(0xFF333333); // رمادي داكن

  // Glass Layer
  static const Color glassBackground = Color(0x1AFFFFFF); // شفافية خفيفة
  static const Color glassBorder = Color(0x33FFFFFF); // حدود شفافة

  // توافق خلفي
  static const Color primaryPurple = Color(0xFF6200EE); // Purple 500
  static const Color primaryLight = Color(0xFF9D46FF); // Purple 300 - فاتح
  static const Color primaryDark = Color(0xFF3700B3); // Purple 700 - داكن
  static const Color primarySubtle = Color(0xFFE1BEE7); // Purple 100 - خفيف جداً
  static const Color surfaceDark = surface;
  static const Color primaryBlue = Color(0xFF6200EE); // نفس الأساسي
  static const Color accentPink = Color(0xFF6200EE); // نفس الأساسي
  static const Color surfaceLight = surface;

  static const Color successLight = successMuted;
  static const Color infoLight = infoMuted;
  static const Color errorLight = errorMuted;

  // اللون الثانوي - أصفر/ذهبي جذاب
  static const Color secondary = Color(0xFFFFC107); // أصفر ذهبي #FFC107
  static const Color secondaryDark = Color(0xFFFFB300); // ذهبي داكن
  static const Color secondaryLight = Color(0xFFFFD54F); // ذهبي فاتح

  // حالات - Super Ultra Premium Accents
  static const Color success = Color(0xFF29CC6A); // Success Green
  static const Color successMuted = Color(0xFFE9F9F0);
  static const Color warning = Color(0xFFFFC107); // Rating Gold (نفس الثانوي)
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningMuted = Color(0xFFFFF9E6);
  static const Color info = Color(0xFF2D9CDB); // Info Blue
  static const Color infoMuted = Color(0xFFE3F3FB);
  static const Color error = Color(0xFFFF4D4F);
  static const Color errorMuted = Color(0xFFFFEBEC);

  // التدرجات - بنفسجي Material Design
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment(-0.07, -1.0), // ~94° angle
    end: Alignment(0.07, 1.0),
    colors: [
      primaryIndigo, // #6200EE - Purple 500
      primaryDeep, // #3700B3 - Purple 700
    ],
    stops: [0.0, 0.86],
  );

  static const LinearGradient darkGradient = primaryGradient;
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, cardBackground],
  );
  static const SweepGradient circularGradient = SweepGradient(
    colors: [primaryIndigo, textPrimary, primaryIndigo],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF1F9B4F)],
  );
  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, Color(0xFFB3261E)],
  );
}

/// الأحجام المعيارية للأيقونات
class MbuyIconSizes {
  static const double bottomNavigation = 26; // أيقونات التبويبات
  static const double bottomNavigationCenter = 38; // الزر المركزي
  static const double primaryAction = 28; // أيقونات الإجراءات
  static const double gridItem = 45; // أيقونات داخل الكروت 42-48px
  static const double header = 24; // أيقونات الهيدر
  static const double secondary = 22; // أيقونات ثانوية
  static const double merchant = 60; // صورة المتجر
  static const double iconStroke = 1.5; // سماكة الحدود
}

/// نظام المسافات العالمي - Super Ultra Premium Spacing Grid
class MbuySpacing {
  static const double screen = 16; // Screen padding
  static const double section = 28; // Between sections (spacious)
  static const double row = 18; // Between rows
  static const double cardPadding = 20; // Card internal padding (Soft Premium)
  static const double cardGap = 16; // Gap between cards
  static const double headerPadding = 14; // Header internal padding
  static const double headerHeight = 70; // Header height
  static const double iconTextGap = 10; // Icon to text spacing
  static const double cardRadius = 12; // Card corner radius 10-14px
  static const double glassBlur = 22; // Glassmorphism blur
}

/// نظام الحركة والتفاعلات - Premium Motion (Apple-like)
class MbuyMotion {
  static const Duration quick = Duration(
    milliseconds: 180,
  ); // Elegant transitions
  static const Duration smooth = Duration(milliseconds: 200); // Smooth fades
  static const double pressedScale = 1.025; // 2.5% scale on press
  static const double glassOpacity = 0.18; // 18% glass transparency
  static const double glassInnerGlow = 0.08; // Inner glow opacity
}

/// ThemeData الرئيسي للتطبيق
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // الخلفية الأساسية
      scaffoldBackgroundColor: MbuyColors.background,

      // ColorScheme - بنفسجي Material Design
      colorScheme: const ColorScheme.light(
        primary: MbuyColors.primaryIndigo, // #6200EE
        secondary: MbuyColors.textSecondary,
        surface: MbuyColors.surface,
        error: MbuyColors.error,
        onPrimary: Colors.white,
        onSecondary: MbuyColors.textPrimary,
        onSurface: MbuyColors.textPrimary,
        onError: Colors.white,
      ),

      // AppBar Theme - Ultra Premium Clean & Modern
      appBarTheme: AppBarTheme(
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: MbuySpacing.headerHeight, // 70px
        iconTheme: const IconThemeData(
          color: MbuyColors.textPrimary,
          size: MbuyIconSizes.header, // 24px
        ),
        titleTextStyle: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 18, // Section header size
          fontWeight: FontWeight.w600,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // Card Theme - كروت بيضاء بدون ظل
      cardTheme: CardThemeData(
        color: MbuyColors.cardBackground,
        elevation: 0, // بدون ظل
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MbuySpacing.cardRadius), // 12px
        ),
        margin: EdgeInsets.symmetric(
          horizontal: MbuySpacing.screen,
          vertical: MbuySpacing.cardGap / 2,
        ),
      ),

      // Text Theme - Super Ultra Premium Typography Hierarchy
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 26, // Title XL - Bold (main header)
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        displayMedium: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 22, // Title L - SemiBold (page titles)
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 18, // Section Headline - SemiBold
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 18, // Section titles - SemiBold
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        bodyLarge: GoogleFonts.cairo(
          color: MbuyColors.textPrimary,
          fontSize: 16, // Body Main - Regular
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.cairo(
          color: MbuyColors.textSecondary,
          fontSize: 14, // Subtext - Medium
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.cairo(
          color: MbuyColors.textTertiary,
          fontSize: 12, // Caption - Regular
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        labelLarge: GoogleFonts.cairo(
          color: MbuyColors.textSecondary,
          fontSize: 14, // Labels - Medium
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.cairo(
          color: MbuyColors.textTertiary,
          fontSize: 12, // Small labels - Regular
          fontWeight: FontWeight.w400,
        ),
      ),

      // Elevated Button Theme - solid fallback, gradients handled via custom widgets
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MbuyColors.primaryIndigo, // #6200EE - Purple 500
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MbuyColors.primaryIndigo,
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
            color: MbuyColors.textSecondary,
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
        backgroundColor: MbuyColors.cardBackground,
        selectedItemColor: MbuyColors.primaryIndigo, // #6200EE - Purple 500
        unselectedItemColor: MbuyColors.textSecondary,
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
        primary: MbuyColors.primaryIndigo, // #6200EE - Purple 500
        secondary: Color(0xFF1E1E1E),
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

      // Card Theme - Dark Mode (20px radius)
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MbuySpacing.cardRadius), // 20px
        ),
        margin: EdgeInsets.symmetric(
          horizontal: MbuySpacing.screen,
          vertical: MbuySpacing.cardGap / 2,
        ),
      ),

      // Text Theme - Super Premium Typography (Dark)
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 26, // Title XL - Bold
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        displayMedium: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 22, // Title L - SemiBold
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 18, // Section Headline - SemiBold
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 18, // Section titles - SemiBold
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        bodyLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 16, // Body Main - Regular
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.cairo(
          color: Colors.white70,
          fontSize: 14, // Subtext - Medium
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.cairo(
          color: Colors.white60,
          fontSize: 12, // Caption - Regular
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        labelLarge: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 14, // Labels - Medium
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.cairo(
          color: Colors.white60,
          fontSize: 12, // Small labels - Regular
          fontWeight: FontWeight.w400,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MbuyColors.primaryIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.2),
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
          foregroundColor: MbuyColors.primaryIndigo,
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
            color: MbuyColors.primaryIndigo,
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
        selectedItemColor: MbuyColors.primaryIndigo,
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
