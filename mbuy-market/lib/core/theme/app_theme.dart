import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    MBUY MARKET - Modern E-Commerce Design                 ║
// ║                                                                           ║
// ║   الألوان المعتمدة:                                                       ║
// ║   • Primary: Dark Brown #372018                                           ║
// ║   • Accent: Deep Brown #2A1810                                            ║
// ║   • Background: White #FFFFFF                                             ║
// ║   • Secondary: Light Grey #F5F5F5                                         ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

class AppTheme {
  // ============================================================================
  // Primary Colors - Dark Brown Theme
  // ============================================================================
  static const Color primaryColor = Color(0xFF372018); // Dark Brown
  static const Color accentColor = Color(0xFF2A1810); // Deeper Brown
  static const Color secondaryColor = Color(0xFF4A2E20); // Medium Brown

  // ============================================================================
  // Background & Surface
  // ============================================================================
  static const Color backgroundColor = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceColor = Color(0xFFF8F9FA); // Light Grey
  static const Color cardColor = Color(0xFFFFFFFF); // White

  // ============================================================================
  // Text Colors
  // ============================================================================
  static const Color textPrimary = Color(0xFF1A1A1A); // Dark Text
  static const Color textSecondary = Color(0xFF666666); // Grey Text
  static const Color textHint = Color(0xFF999999); // Light Grey
  static const Color textWhite = Color(0xFFFFFFFF); // White Text

  // ============================================================================
  // Border & Divider
  // ============================================================================
  static const Color borderColor = Color(0xFFE8E8E8);
  static const Color dividerColor = Color(0xFFEEEEEE);

  // ============================================================================
  // Status Colors
  // ============================================================================
  static const Color successColor = Color(0xFF372018);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color infoColor = Color(0xFF2196F3);

  // ============================================================================
  // Price Colors
  // ============================================================================
  static const Color priceColor = Color(0xFF372018); // Dark Brown for price
  static const Color salePriceColor = Color(0xFFFF5252); // Red for sale
  static const Color discountBadgeColor = Color(0xFF372018);

  // ============================================================================
  // Rating
  // ============================================================================
  static const Color ratingStarColor = Color(0xFFFFB800);

  // ============================================================================
  // Navigation Bar Colors
  // ============================================================================
  static const Color navBarBackground = Color(0xFFFFFFFF);
  static const Color navBarSelected = Color(
    0xFF372018,
  ); // Dark Brown when selected
  static const Color navBarUnselected = Color(0xFF999999);

  // ============================================================================
  // Badge Colors
  // ============================================================================
  static const Color badgeColor = Color(0xFFFF5252); // Red for notifications

  // ============================================================================
  // Dimensions
  // ============================================================================
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  static const double borderRadiusRound = 50.0;

  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // ============================================================================
  // Light Theme
  // ============================================================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: accentColor,
        onSecondary: Colors.white,
        tertiary: secondaryColor,
        surface: surfaceColor,
        onSurface: textPrimary,
        error: errorColor,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: backgroundColor,

      // AppBar - Clean White Header
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
      ),

      // Text Theme - Cairo for Arabic
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.cairo(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textHint,
        ),
      ),

      // Elevated Button - Turquoise CTA
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusLarge),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusLarge),
          ),
          side: const BorderSide(color: primaryColor, width: 1.5),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        hintStyle: GoogleFonts.cairo(color: textHint, fontSize: 14),
        labelStyle: GoogleFonts.cairo(color: textSecondary, fontSize: 14),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        margin: EdgeInsets.zero,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: navBarBackground,
        elevation: 8,
        selectedItemColor: navBarSelected,
        unselectedItemColor: navBarUnselected,
        selectedLabelStyle: GoogleFonts.cairo(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(
          fontSize: 10,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textPrimary, size: 24),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryColor,
        labelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusRound),
        ),
      ),

      // Badge Theme
      badgeTheme: BadgeThemeData(
        backgroundColor: badgeColor,
        textColor: Colors.white,
        textStyle: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ============================================================================
  // Custom Styles
  // ============================================================================

  /// Price Style
  static TextStyle get priceStyle => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: priceColor,
  );

  /// Sale Price Style
  static TextStyle get salePriceStyle => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: salePriceColor,
  );

  /// Original Price (Strikethrough)
  static TextStyle get originalPriceStyle => GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textHint,
    decoration: TextDecoration.lineThrough,
  );

  /// Discount Badge
  static BoxDecoration get discountBadge => BoxDecoration(
    color: discountBadgeColor,
    borderRadius: BorderRadius.circular(borderRadiusSmall),
  );

  /// Sale Badge
  static BoxDecoration get saleBadge => BoxDecoration(
    color: salePriceColor,
    borderRadius: BorderRadius.circular(borderRadiusSmall),
  );

  /// Search Bar Decoration
  static BoxDecoration get searchBarDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(borderRadiusMedium),
    border: Border.all(color: borderColor, width: 1),
  );

  /// Active Tab Decoration
  static BoxDecoration get activeTabDecoration => BoxDecoration(
    color: primaryColor,
    borderRadius: BorderRadius.circular(borderRadiusRound),
  );

  /// Inactive Tab Decoration
  static BoxDecoration get inactiveTabDecoration => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadiusRound),
    border: Border.all(color: borderColor, width: 1),
  );

  /// Card Shadow
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  /// Bottom Nav Shadow
  static List<BoxShadow> get bottomNavShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 10,
      offset: const Offset(0, -2),
    ),
  ];
}
