import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   هذا الملف يحتوي على التصميم المعتمد والنهائي للتطبيق                     ║
// ║   تاريخ التثبيت: 19 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل الألوان أو التصميم إلا بطلب صريح وواضح من المالك          ║
// ║   ⛔ DO NOT MODIFY colors or design without EXPLICIT owner request        ║
// ║                                                                           ║
// ║   الألوان المعتمدة:                                                       ║
// ║   • Primary: Oxford Blue #00214A (الثقة والاحترافية)                      ║
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
  // E-commerce Color Palette - Oxford Blue Theme
  // ============================================================================

  // === Primary Colors (Oxford Blue - الأزرق الأكسفوردي) ===
  static const Color primaryColor = Color(
    0xFF00214A,
  ); // Oxford Blue - اللون الأساسي
  static const Color primaryLight = Color(0xFF003366); // Oxford Blue Light
  static const Color primaryDark = Color(0xFF001830); // Oxford Blue Dark

  // === Purple Colors (Reduced Usage) ===
  static const Color purpleColor = Color(
    0xFF9333EA,
  ); // Purple-600 (Limited use)
  static const Color purpleLight = Color(0xFFA855F7);
  static const Color purpleDark = Color(0xFF7C3AED);

  // === Secondary Colors (Teal - Fresh & Modern) ===
  static const Color secondaryColor = Color(0xFF00B4B4); // Shopping Teal
  static const Color secondaryLight = Color(0xFF4DD4D4);
  static const Color secondaryDark = Color(0xFF008585);

  // === Accent Colors (Orange - CTA & Urgency) ===
  static const Color accentColor = Color(0xFFFF6B35); // Shopping Orange
  static const Color accentLight = Color(0xFFFF9A6C);
  static const Color accentDark = Color(0xFFE54D1B);

  // === Background & Surface (Light Mode) - Metallic Slate Theme ===
  static const Color backgroundColor = Color(
    0xFFF1F5F9,
  ); // Slate-100 - Cool grey/lead tone
  static const Color surfaceColor = Color(0xFFFFFFFF); // White
  static const Color cardColor = Color(
    0xFFFFFFFF,
  ); // White (will use gradient in cards)

  // === Metallic Slate Colors (matching image exactly) ===
  static const Color slate100 = Color(
    0xFFF1F5F9,
  ); // Background with slight purple tint
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1); // Metallic edge border
  static const Color slate400 = Color(0xFF94A3B8); // Inactive icons
  static const Color slate500 = Color(0xFF64748B); // Medium slate
  static const Color slate600 = Color(
    0xFF475569,
  ); // Dark slate for better contrast
  static const Color darkSlate = Color(
    0xFF0F172A,
  ); // Headings & Icons (dark slate grey)
  static const Color mutedSlate = Color(
    0xFF64748B,
  ); // Body text & Inactive icons
  static const Color slate700 = Color(
    0xFF334155,
  ); // Dark charcoal for ad banners

  // === Background & Surface (Dark Mode) ===
  static const Color backgroundColorDark = Color(0xFF121212);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);
  static const Color cardColorDark = Color(0xFF2D2D2D);

  // === Text Colors (Light Mode) - Metallic Slate Theme ===
  static const Color textPrimaryColor = Color(
    0xFF0F172A,
  ); // Dark Slate - Headings
  static const Color textSecondaryColor = Color(
    0xFF64748B,
  ); // Muted Slate - Body text
  static const Color textHintColor = Color(0xFF94A3B8); // Slate-400

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

  // === Pro Badge Colors (from image) ===
  static const Color proBadgeColor = Color(
    0xFF2563EB,
  ); // Blue for "جرب خطة Pro"
  static const Color proLabelColor = Color(
    0xFF0EA5E9,
  ); // Sky Blue for "خطة Pro" label

  // === Divider & Border - Metallic Edge ===
  static const Color dividerColor = Color(
    0xFFCBD5E1,
  ); // Slate-300 - Metallic edge
  static const Color borderColor = Color(
    0xFFCBD5E1,
  ); // Slate-300 - Metallic edge
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

  // Metallic Modern Gradient for FAB (Blue Gradient) - Main color
  static const LinearGradient metallicGradient = LinearGradient(
    colors: [
      Color(0xFF2563EB), // Blue - Primary
      Color(0xFF3B82F6), // Blue-500
      Color(0xFF60A5FA), // Blue-400
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

  // Primary Gradient (Blue Gradient) - Reduced Purple Usage
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF2563EB), // Blue - Primary
      Color(0xFF3B82F6), // Blue-500
      Color(0xFF60A5FA), // Blue-400
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Header Banner Gradient (Blue with minimal purple)
  static const LinearGradient headerBannerGradient = LinearGradient(
    colors: [
      Color(0xFF2563EB), // Blue - Primary
      Color(0xFF3B82F6), // Blue-500
      Color(0xFF60A5FA), // Blue-400
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Card Gradient (White to Slate-100) - Metallic Surface
  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF), // White
      Color(0xFFF1F5F9), // Slate-100
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card Gradient Deep (White to Slate-200) - For elevated cards
  static const LinearGradient cardGradientDeep = LinearGradient(
    colors: [
      Color(0xFFFFFFFF), // White
      Color(0xFFE2E8F0), // Slate-200
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Recessed Metal Input Gradient
  static const LinearGradient recessedMetalGradient = LinearGradient(
    colors: [
      Color(0xFFE2E8F0), // Slate-200
      Color(0xFFF1F5F9), // Slate-100
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subtle Overlay Gradient (for cards/headers) - Blue only
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [
      Color(0x0A2563EB), // Blue 4%
      Color(0x0A3B82F6), // Blue-500 4%
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

      // Scaffold - Metallic Slate Background
      scaffoldBackgroundColor: backgroundColor, // Slate-100
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
          fontSize: 13,
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
          fontSize: 11,
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

      // Input Decoration - Recessed Metal Look
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: slate200, // Recessed metal background
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(
            color: slate300.withValues(alpha: 0.5),
          ), // Subtle metallic edge
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide(color: slate300.withValues(alpha: 0.5)),
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

      // Card Theme - Metallic Cards with Gradient
      cardTheme: CardThemeData(
        elevation: cardElevation,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
          side: const BorderSide(color: borderColor, width: 1), // Metallic edge
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

      // Divider - Metallic Edge
      dividerTheme: const DividerThemeData(
        color: slate300, // Metallic edge color
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
  // Dark Theme
  // ============================================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme for Dark Mode
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryDark,
        onPrimaryContainer: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        secondaryContainer: secondaryDark,
        onSecondaryContainer: Colors.white,
        tertiary: accentColor,
        onTertiary: Colors.white,
        tertiaryContainer: accentDark,
        onTertiaryContainer: Colors.white,
        surface: surfaceColorDark,
        onSurface: textPrimaryColorDark,
        surfaceContainerHighest: Color(0xFF3A3A3A),
        error: errorColor,
        onError: Colors.white,
        outline: borderColorDark,
        outlineVariant: dividerColorDark,
      ),

      // Scaffold
      scaffoldBackgroundColor: backgroundColorDark,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: surfaceColorDark,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimaryColorDark,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColorDark,
        ),
        iconTheme: const IconThemeData(color: primaryColor, size: 24),
      ),

      // Text Theme
      textTheme:
          TextTheme(
            displayLarge: GoogleFonts.cairo(color: textPrimaryColorDark),
            displayMedium: GoogleFonts.cairo(color: textPrimaryColorDark),
            displaySmall: GoogleFonts.cairo(color: textPrimaryColorDark),
            headlineLarge: GoogleFonts.cairo(color: textPrimaryColorDark),
            headlineMedium: GoogleFonts.cairo(color: textPrimaryColorDark),
            headlineSmall: GoogleFonts.cairo(color: textPrimaryColorDark),
            titleLarge: GoogleFonts.cairo(color: textPrimaryColorDark),
            titleMedium: GoogleFonts.cairo(color: textPrimaryColorDark),
            titleSmall: GoogleFonts.cairo(color: textPrimaryColorDark),
            bodyLarge: GoogleFonts.cairo(color: textPrimaryColorDark),
            bodyMedium: GoogleFonts.cairo(color: textPrimaryColorDark),
            bodySmall: GoogleFonts.cairo(color: textSecondaryColorDark),
            labelLarge: GoogleFonts.cairo(color: textPrimaryColorDark),
            labelMedium: GoogleFonts.cairo(color: textSecondaryColorDark),
            labelSmall: GoogleFonts.cairo(color: textSecondaryColorDark),
          ).apply(
            bodyColor: textPrimaryColorDark,
            displayColor: textPrimaryColorDark,
          ),

      // Elevated Button
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

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A), // Darker input background
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: borderColorDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: borderColorDark),
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
        hintStyle: GoogleFonts.cairo(color: textHintColorDark, fontSize: 14),
        labelStyle: GoogleFonts.cairo(
          color: textSecondaryColorDark,
          fontSize: 14,
        ),
        prefixIconColor: textSecondaryColorDark,
        suffixIconColor: textSecondaryColorDark,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
          side: const BorderSide(color: borderColorDark, width: 1),
        ),
        color: cardColorDark,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColorDark,
        elevation: 8,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColorDark,
      ),

      // Navigation Bar (M3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColorDark,
        elevation: 8,
        indicatorColor: primaryColor.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? primaryColor
              : textSecondaryColorDark;
          return GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? primaryColor
              : textSecondaryColorDark;
          return IconThemeData(color: color, size: 24);
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: dividerColorDark,
        thickness: 1,
        space: 1,
      ),

      // Other components
      dialogTheme: DialogThemeData(backgroundColor: surfaceColorDark),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: surfaceColorDark),
      popupMenuTheme: PopupMenuThemeData(color: surfaceColorDark),
      snackBarTheme: SnackBarThemeData(backgroundColor: surfaceColorDark),
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

  // ============================================================================
  // Metallic Card Decorations
  // ============================================================================

  /// Metallic Card Decoration with Gradient and Border
  static BoxDecoration get metallicCardDecoration => BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(borderRadiusLarge),
    border: Border.all(
      color: borderColor, // Metallic edge
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  /// Deep Metallic Card Decoration (for elevated cards)
  static BoxDecoration get metallicCardDecorationDeep => BoxDecoration(
    gradient: cardGradientDeep,
    borderRadius: BorderRadius.circular(borderRadiusLarge),
    border: Border.all(color: borderColor, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  /// Recessed Metal Input Decoration
  static BoxDecoration get recessedMetalDecoration => BoxDecoration(
    gradient: recessedMetalGradient,
    borderRadius: BorderRadius.circular(borderRadiusMedium),
    border: Border.all(color: slate300.withValues(alpha: 0.5), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
