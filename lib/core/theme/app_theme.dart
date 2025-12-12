import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Theme Configuration - Multi-Vendor Global Standards
/// Based on Amazon, Noon, AliExpress best practices
class AppTheme {
  // ============================================================================
  // Colors - Modern E-commerce Palette
  // ============================================================================

  // Primary Brand Colors
  static const Color primaryColor = Color(
    0xFF1A1A2E,
  ); // Deep Navy (Trust & Authority)
  static const Color secondaryColor = Color(0xFF16213E); // Dark Blue
  static const Color accentColor = Color(
    0xFFE94560,
  ); // Vibrant Coral (CTA Actions)

  // Background & Surface
  static const Color backgroundColor = Color(
    0xFFF8F9FA,
  ); // Light Gray (Easy on eyes)
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // Status Colors
  static const Color successColor = Color(
    0xFF00C853,
  ); // Green (Success/In Stock)
  static const Color warningColor = Color(0xFFFFB300); // Amber (Limited Stock)
  static const Color errorColor = Color(0xFFE53935); // Red (Error/Out of Stock)
  static const Color infoColor = Color(0xFF2196F3); // Blue (Info)

  // Text Colors
  static const Color textPrimaryColor = Color(
    0xFF1A1A2E,
  ); // Dark for readability
  static const Color textSecondaryColor = Color(
    0xFF6B7280,
  ); // Gray for secondary
  static const Color textHintColor = Color(0xFF9CA3AF); // Light gray for hints

  // Price Colors
  static const Color priceColor = Color(0xFF1A1A2E); // Original price
  static const Color salePriceColor = Color(0xFFE53935); // Sale price (Red)
  static const Color discountBadgeColor = Color(0xFFE53935); // Discount badge

  // Rating Colors
  static const Color ratingStarColor = Color(0xFFFFC107); // Yellow stars
  static const Color ratingTextColor = Color(0xFF6B7280); // Gray rating count

  // Shipping & Badge Colors
  static const Color freeShippingColor = Color(0xFF00C853); // Green badge
  static const Color fastDeliveryColor = Color(0xFF2196F3); // Blue badge
  static const Color verifiedSellerColor = Color(0xFF9C27B0); // Purple badge

  // Divider Color
  static const Color dividerColor = Color(0xFFE5E7EB); // Light gray divider

  // ============================================================================
  // Gradients
  // ============================================================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFFFF6B6B)],
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

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: textPrimaryColor,
        onError: Colors.white,
        outline: Color(0xFFE5E7EB),
      ),

      // Scaffold
      scaffoldBackgroundColor: backgroundColor,

      // AppBar - Clean & Modern
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
        iconTheme: const IconThemeData(color: textPrimaryColor, size: 24),
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

      // Elevated Button - Primary CTA
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: buttonElevation,
          shadowColor: accentColor.withValues(alpha: 0.4),
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
          foregroundColor: accentColor,
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

      // Bottom Navigation - Main Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        selectedItemColor: accentColor,
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
        indicatorColor: accentColor.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accentColor,
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
            return const IconThemeData(color: accentColor, size: 24);
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

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
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

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: Color(0xFFE5E7EB),
        circularTrackColor: Color(0xFFE5E7EB),
      ),

      // Badge Theme
      badgeTheme: BadgeThemeData(
        backgroundColor: accentColor,
        textColor: Colors.white,
        textStyle: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w600),
      ),

      // Splash & Highlight
      splashColor: accentColor.withValues(alpha: 0.1),
      highlightColor: accentColor.withValues(alpha: 0.05),
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
