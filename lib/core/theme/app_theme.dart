import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   هذا الملف يحتوي على التصميم المعتمد والنهائي للتطبيق                     ║
// ║   تاريخ التثبيت: 14 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل الألوان أو التصميم إلا بطلب صريح وواضح من المالك          ║
// ║   ⛔ DO NOT MODIFY colors or design without EXPLICIT owner request        ║
// ║                                                                           ║
// ║   الألوان المعتمدة:                                                       ║
// ║   • Primary: Navy Blue #1E3A5F (الثقة والاحترافية)                        ║
// ║   • Secondary: Teal #00B4B4 (الحداثة والانتعاش)                           ║
// ║   • Accent: Orange #FF6B35 (الإجراءات والتحفيز)                           ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// App Theme Configuration - Modern E-commerce Palette
/// Professional shopping app design with trust-inspiring colors
///
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-14
/// Do not change without explicit request
class AppTheme {
  // ============================================================================
  // E-commerce Color Palette (Amazon/Noon/Shopify Inspired)
  // ============================================================================

  // === Primary Colors (Deep Blue - Trust & Authority) ===
  static const Color primaryColor = Color(0xFF1E3A5F); // Deep Navy Blue
  static const Color primaryLight = Color(0xFF4A6FA5);
  static const Color primaryDark = Color(0xFF0D2137);

  // === Secondary Colors (Teal - Fresh & Modern) ===
  static const Color secondaryColor = Color(0xFF00B4B4); // Shopping Teal
  static const Color secondaryLight = Color(0xFF4DD4D4);
  static const Color secondaryDark = Color(0xFF008585);

  // === Accent Colors (Orange - CTA & Urgency) ===
  static const Color accentColor = Color(0xFFFF6B35); // Shopping Orange
  static const Color accentLight = Color(0xFFFF9A6C);
  static const Color accentDark = Color(0xFFE54D1B);

  // === Background & Surface (Light Mode) ===
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // === Background & Surface (Dark Mode) ===
  static const Color backgroundColorDark = Color(0xFF121212);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);
  static const Color cardColorDark = Color(0xFF2D2D2D);

  // === Text Colors (Light Mode) ===
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color textHintColor = Color(0xFF999999);

  // === Text Colors (Dark Mode) ===
  static const Color textPrimaryColorDark = Color(0xFFEEEEEE);
  static const Color textSecondaryColorDark = Color(0xFFB3B3B3);
  static const Color textHintColorDark = Color(0xFF808080);

  // === Status Colors (Semantic - Do Not Change) ===
  static const Color successColor = Color(0xFF28A745);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFDC3545);
  static const Color infoColor = Color(0xFF17A2B8);

  // === Price Colors ===
  static const Color priceColor = Color(0xFF1A1A1A);
  static const Color salePriceColor = Color(0xFFE31837); // Sale Red
  static const Color discountBadgeColor = Color(0xFFE31837);

  // === Rating Colors (Semantic - Do Not Change) ===
  static const Color ratingStarColor = Color(0xFFFFB800);
  static const Color ratingTextColor = Color(0xFF666666);

  // === Badge Colors ===
  static const Color freeShippingColor = Color(0xFF28A745);
  static const Color fastDeliveryColor = Color(0xFF17A2B8);
  static const Color verifiedSellerColor = Color(0xFF6F42C1);

  // === Divider & Border ===
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color borderColor = Color(0xFFD0D0D0);
  static const Color dividerColorDark = Color(0xFF404040);
  static const Color borderColorDark = Color(0xFF505050);

  // ============================================================================
  // Gradients - E-commerce Identity
  // ============================================================================

  // Brand Identity Gradient (Navy → Teal)
  static const LinearGradient brandGradient = LinearGradient(
    colors: [
      Color(0xFF1E3A5F), // Deep Navy
      Color(0xFF00B4B4), // Teal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Metallic Modern Gradient for FAB (Orange CTA)
  static const LinearGradient metallicGradient = LinearGradient(
    colors: [
      Color(0xFFFF6B35), // Orange
      Color(0xFFFF8C5A), // Light Orange
      Color(0xFFFFAB7A), // Soft Orange
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Accent Gradient (Orange variations)
  static const LinearGradient accentGradient = LinearGradient(
    colors: [
      Color(0xFFFF6B35), // Orange
      Color(0xFFE54D1B), // Deep Orange
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Primary Gradient (Navy to Teal)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF1E3A5F), // Navy
      Color(0xFF00B4B4), // Teal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subtle Overlay Gradient (for cards/headers)
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [
      Color(0x0A1E3A5F), // Navy 4%
      Color(0x0A00B4B4), // Teal 4%
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sale/Promo Gradient
  static const LinearGradient saleGradient = LinearGradient(
    colors: [
      Color(0xFFE31837), // Sale Red
      Color(0xFFFF4757), // Bright Red
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // Dimensions - Global Standards
  // ============================================================================

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  static const double cardElevation = 2.0;
  static const double buttonElevation = 4.0;

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

      // Color Scheme - Meta AI Inspired
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFE3F7FD),
        onPrimaryContainer: primaryDark,
        secondary: secondaryColor,
        onSecondary: Color(0xFF1A1D21),
        secondaryContainer: Color(0xFFE8FEF8),
        onSecondaryContainer: secondaryDark,
        tertiary: accentColor,
        onTertiary: Color(0xFF1A1D21),
        tertiaryContainer: Color(0xFFFEF0FA),
        onTertiaryContainer: accentDark,
        surface: surfaceColor,
        onSurface: textPrimaryColor,
        surfaceContainerHighest: Color(0xFFF5F5F5),
        error: errorColor,
        onError: Colors.white,
        outline: borderColor,
        outlineVariant: dividerColor,
      ),

      // Scaffold
      scaffoldBackgroundColor: backgroundColor,

      // AppBar - Clean & Modern with Meta Blue
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimaryColor,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        iconTheme: const IconThemeData(color: primaryColor, size: 24),
      ),

      // Text Theme - Cairo for Arabic
      textTheme: TextTheme(
        // Display - Headlines
        displayLarge: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          height: 1.2,
        ),
        // Headlines
        headlineLarge: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        headlineSmall: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        // Titles
        titleLarge: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleMedium: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        titleSmall: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        // Body
        bodyLarge: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimaryColor,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimaryColor,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondaryColor,
          height: 1.4,
        ),
        // Labels
        labelLarge: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        labelMedium: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryColor,
        ),
        labelSmall: GoogleFonts.cairo(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textSecondaryColor,
        ),
      ),

      // Elevated Button - Primary CTA with Meta Blue
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: buttonElevation,
          shadowColor: primaryColor.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button - Secondary CTA
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          side: const BorderSide(color: primaryColor, width: 1.5),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration - Search & Forms
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: GoogleFonts.cairo(color: textHintColor, fontSize: 14),
        labelStyle: GoogleFonts.cairo(color: textSecondaryColor, fontSize: 14),
        prefixIconColor: textSecondaryColor,
        suffixIconColor: textSecondaryColor,
      ),

      // Card Theme - Product Cards
      cardTheme: CardThemeData(
        elevation: cardElevation,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),

      // Chip Theme - Filters & Tags
      chipTheme: ChipThemeData(
        backgroundColor: backgroundColor,
        selectedColor: primaryColor.withValues(alpha: 0.1),
        disabledColor: backgroundColor,
        labelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        secondaryLabelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),

      // Bottom Navigation - Main Nav with Meta Colors
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        indicatorColor: primaryColor.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            );
          }
          return GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: textSecondaryColor,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor, size: 24);
          }
          return const IconThemeData(color: textSecondaryColor, size: 24);
        }),
      ),

      // Tab Bar
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 3),
        ),
      ),

      // Floating Action Button with Meta Gradient
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimaryColor,
        contentTextStyle: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        contentTextStyle: GoogleFonts.cairo(
          fontSize: 14,
          color: textSecondaryColor,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadiusXLarge),
          ),
        ),
        dragHandleColor: const Color(0xFFE5E7EB),
        dragHandleSize: const Size(40, 4),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        subtitleTextStyle: GoogleFonts.cairo(
          fontSize: 12,
          color: textSecondaryColor,
        ),
        iconColor: textSecondaryColor,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textSecondaryColor, size: 24),

      // Progress Indicator with Meta Blue
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: Color(0xFFE4E6EB),
        circularTrackColor: Color(0xFFE4E6EB),
      ),

      // Badge Theme
      badgeTheme: BadgeThemeData(
        backgroundColor: accentColor,
        textColor: textPrimaryColor,
        textStyle: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w600),
      ),

      // Splash & Highlight
      splashColor: primaryColor.withValues(alpha: 0.1),
      highlightColor: primaryColor.withValues(alpha: 0.05),
    );
  }

  // ============================================================================
  // Custom Widget Styles
  // ============================================================================

  /// Product Price Style
  static TextStyle get priceStyle => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: priceColor,
  );

  /// Sale Price Style
  static TextStyle get salePriceStyle => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: salePriceColor,
  );

  /// Original Price (Strikethrough)
  static TextStyle get originalPriceStyle => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    decoration: TextDecoration.lineThrough,
  );

  /// Discount Badge Style
  static BoxDecoration get discountBadgeDecoration => BoxDecoration(
    color: discountBadgeColor,
    borderRadius: BorderRadius.circular(borderRadiusSmall),
  );

  /// Rating Stars Style
  static const Color starActiveColor = ratingStarColor;
  static const Color starInactiveColor = Color(0xFFE5E7EB);

  /// Free Shipping Badge
  static BoxDecoration get freeShippingBadge => BoxDecoration(
    color: freeShippingColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadiusSmall),
    border: Border.all(color: freeShippingColor),
  );

  /// Fast Delivery Badge
  static BoxDecoration get fastDeliveryBadge => BoxDecoration(
    color: fastDeliveryColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadiusSmall),
    border: Border.all(color: fastDeliveryColor),
  );

  /// Product Card Shadow
  static List<BoxShadow> get productCardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  /// Search Bar Decoration
  static BoxDecoration get searchBarDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(borderRadiusMedium),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
