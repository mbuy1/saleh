import 'package:flutter/material.dart';

/// App Dimensions - Global E-commerce Standards
/// Based on Material Design 3, iOS HIG, and major apps
/// (Amazon, Noon, AliExpress, Shopify)
class AppDimensions {
  AppDimensions._();

  // ============================================================================
  // Spacing - 8pt Grid System (Material Design Standard)
  // ============================================================================
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing10 = 10.0;
  static const double spacing12 = 12.0;
  static const double spacing14 = 14.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;

  // ============================================================================
  // Screen Padding - Consistent Edge Margins
  // ============================================================================
  static const double screenPaddingHorizontal = 16.0;
  static const double screenPaddingVertical = 16.0;
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets screenPaddingHorizontalOnly = EdgeInsets.symmetric(
    horizontal: 16.0,
  );

  // ============================================================================
  // Standardized Padding EdgeInsets - Use these instead of hardcoded values
  // ============================================================================
  /// Padding 8px all sides - for small compact items
  static const EdgeInsets paddingXS = EdgeInsets.all(spacing8);

  /// Padding 12px all sides - for cards and list items
  static const EdgeInsets paddingS = EdgeInsets.all(spacing12);

  /// Padding 16px all sides - standard screen/section padding
  static const EdgeInsets paddingM = EdgeInsets.all(spacing16);

  /// Padding 20px all sides - for emphasized sections
  static const EdgeInsets paddingL = EdgeInsets.all(spacing20);

  /// Padding 24px all sides - for large sections and dialogs
  static const EdgeInsets paddingXL = EdgeInsets.all(spacing24);

  /// Padding 32px all sides - for hero/empty state sections
  static const EdgeInsets paddingXXL = EdgeInsets.all(spacing32);

  // Horizontal only padding
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(
    horizontal: spacing8,
  );
  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(
    horizontal: spacing12,
  );
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(
    horizontal: spacing16,
  );
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(
    horizontal: spacing20,
  );
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: spacing24,
  );

  // Vertical only padding
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(
    vertical: spacing8,
  );
  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(
    vertical: spacing12,
  );
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(
    vertical: spacing16,
  );
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(
    vertical: spacing20,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: spacing24,
  );

  // ============================================================================
  // Border Radius - Rounded Corners (Modern Standard)
  // ============================================================================
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircle = 100.0;

  // BorderRadius objects
  static final BorderRadius borderRadiusXS = BorderRadius.circular(radiusXS);
  static final BorderRadius borderRadiusS = BorderRadius.circular(radiusS);
  static final BorderRadius borderRadiusM = BorderRadius.circular(radiusM);
  static final BorderRadius borderRadiusL = BorderRadius.circular(radiusL);
  static final BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);
  static final BorderRadius borderRadiusXXL = BorderRadius.circular(radiusXXL);

  // ============================================================================
  // Icon Sizes - Consistent across app
  // ============================================================================
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0; // Default Material icon size
  static const double iconL = 28.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 40.0;
  static const double iconHero = 48.0;
  static const double iconDisplay = 64.0;

  // ============================================================================
  // Button Heights - Touch Targets (min 48dp for accessibility)
  // ============================================================================
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 44.0;
  static const double buttonHeightL = 48.0; // Recommended minimum
  static const double buttonHeightXL = 56.0;
  static const Size buttonMinSize = Size(88, 48);

  // ============================================================================
  // Input Field Heights
  // ============================================================================
  static const double inputHeightS = 40.0;
  static const double inputHeightM = 48.0;
  static const double inputHeightL = 56.0;

  // ============================================================================
  // Card Dimensions
  // ============================================================================
  static const double cardElevationLow = 1.0;
  static const double cardElevationMedium = 2.0;
  static const double cardElevationHigh = 4.0;
  static const double cardPadding = 16.0;

  // ============================================================================
  // AppBar & Navigation
  // ============================================================================
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;
  static const double bottomNavHeight = 80.0;
  static const double tabBarHeight = 48.0;

  // ============================================================================
  // Avatar Sizes
  // ============================================================================
  static const double avatarXS = 24.0;
  static const double avatarS = 32.0;
  static const double avatarM = 40.0;
  static const double avatarL = 48.0;
  static const double avatarXL = 56.0;
  static const double avatarXXL = 72.0;
  static const double avatarProfile = 96.0;

  // ============================================================================
  // Thumbnail Sizes
  // ============================================================================
  static const double thumbnailS = 48.0;
  static const double thumbnailM = 64.0;
  static const double thumbnailL = 80.0;
  static const double thumbnailXL = 100.0;

  // ============================================================================
  // Grid - Product Cards
  // ============================================================================
  static const int gridCrossAxisCount2 = 2;
  static const int gridCrossAxisCount3 = 3;
  static const double gridSpacing = 12.0;
  static const double gridChildAspectRatioProduct = 0.65; // Tall product cards
  static const double gridChildAspectRatioSquare = 1.0;
  static const double gridChildAspectRatioWide = 1.5;

  // ============================================================================
  // List Item Heights
  // ============================================================================
  static const double listItemHeightS = 48.0;
  static const double listItemHeightM = 56.0;
  static const double listItemHeightL = 72.0;
  static const double listItemHeightXL = 88.0;

  // ============================================================================
  // Divider
  // ============================================================================
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // ============================================================================
  // Badge Sizes
  // ============================================================================
  static const double badgeSize = 18.0;
  static const double badgeSizeS = 16.0;
  static const double badgeSizeL = 24.0;

  // ============================================================================
  // Modal & Dialog
  // ============================================================================
  static const double dialogWidth = 320.0;
  static const double dialogMaxWidth = 560.0;
  static const double bottomSheetRadius = 24.0;

  // ============================================================================
  // Animation Durations
  // ============================================================================
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============================================================================
  // Font Sizes - Typographic Scale
  // ============================================================================
  static const double fontCaption = 11.0;
  static const double fontLabel = 12.0;
  static const double fontBody2 = 13.0;
  static const double fontBody = 14.0;
  static const double fontSubtitle = 15.0;
  static const double fontTitle = 16.0;
  static const double fontHeadline = 18.0;
  static const double fontDisplay3 = 20.0;
  static const double fontDisplay2 = 24.0;
  static const double fontDisplay1 = 28.0;
  static const double fontHero = 32.0;
  // Additional font sizes for headings
  static const double fontH1 = 32.0;
  static const double fontH2 = 24.0;
  static const double fontH3 = 20.0;
  static const double fontH4 = 18.0;

  // ============================================================================
  // Line Heights
  // ============================================================================
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;

  // ============================================================================
  // Max Widths for Web/Tablet
  // ============================================================================
  static const double maxContentWidth = 600.0;
  static const double maxWidthMobile = 480.0;
  static const double maxWidthTablet = 768.0;
  static const double maxWidthDesktop = 1200.0;

  // ============================================================================
  // Breakpoints
  // ============================================================================
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Get responsive padding based on screen width
  static EdgeInsets responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointMobile) {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    } else if (width < breakpointTablet) {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    }
  }

  /// Get responsive grid count based on screen width
  static int responsiveGridCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointMobile) {
      return 2;
    } else if (width < breakpointTablet) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMobile;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMobile && width < breakpointDesktop;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointDesktop;
  }
}
