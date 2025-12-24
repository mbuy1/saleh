# 📋 Design Inventory - Saleh App
## Single Source of Truth for UI/UX Design System

> **تاريخ التحديث:** 2025-12-24
> **الغرض:** توثيق شامل لكل عناصر التصميم المستخدمة في التطبيق
> **⚠️ التصميم الموحد: Brand Primary #215950 (Teal Green)**

---

## 📁 ملفات التصميم الأساسية

| الملف | المسار | الوصف |
|-------|--------|-------|
| `app_theme.dart` | `lib/core/theme/app_theme.dart` | الألوان الرئيسية، الثيمات، التدرجات (المصدر الوحيد) |
| `app_dimensions.dart` | `lib/core/constants/app_dimensions.dart` | المقاسات، التباعد، الأحجام |
| `app_icons.dart` | `lib/core/constants/app_icons.dart` | مسارات الأيقونات SVG |
| `design_system_widgets.dart` | `lib/shared/widgets/design_system_widgets.dart` | المكونات المشتركة الموحدة |

---

## 🎨 الألوان (Colors)

### ⚠️ نظام الألوان الموحد - Brand Primary #215950
```
🔒 DESIGN FROZEN - لا يُعدل إلا بطلب صريح من المالك

Primary Color = #215950 ← Teal Green (اللون الأساسي الثابت للتطبيق)
Primary Light = #2D7A6E ← نسخة فاتحة
Primary Dark = #153B35 ← نسخة داكنة

Background Light = #F1F5F9 ← Slate-100
Surface Light = #FFFFFF ← White
Card Light = #FFFFFF ← White

Background Dark = #121212
Surface Dark = #1E1E1E
Card Dark = #2D2D2D

Text Primary Light = #0F172A ← Slate-900
Text Secondary Light = #64748B ← Slate-500
Text Hint Light = #94A3B8 ← Slate-400

Border Light = #CBD5E1 ← Slate-300
Border Dark = #505050

Rating Star = #FFB800 ← Yellow
Warning = #FFC107 ← Badge PRO
```

### ⛔ ممنوع: الألوان المحلية داخل الشاشات
```dart
// ❌ ممنوع - لا تنشئ ألوان محلية
class _ScreenColors {
  static const Color primary = Color(0xFF13EC80); // ❌ WRONG
}

// ✅ صحيح - استخدم AppTheme دائماً
import '../../../../core/theme/app_theme.dart';

color: AppTheme.primaryColor  // ✅ CORRECT
color: AppTheme.backgroundColor  // ✅ CORRECT
```

### ألوان الخلفية والسطح - Background & Surface

```dart
// LIGHT THEME - من AppTheme فقط
AppTheme.backgroundColor     // #F1F5F9 - خلفية فاتحة
AppTheme.surfaceColor        // #FFFFFF - السطح
AppTheme.cardColor           // #FFFFFF - البطاقات

// DARK THEME - من AppTheme فقط
AppTheme.backgroundColorDark // #121212
AppTheme.surfaceColorDark    // #1E1E1E
AppTheme.cardColorDark       // #2D2D2D
```

### ألوان النصوص - Text Colors

```dart
// LIGHT THEME
AppTheme.textPrimaryColor    // #0F172A - نص رئيسي
AppTheme.textSecondaryColor  // #64748B - نص ثانوي
AppTheme.textHintColor       // #94A3B8 - تلميح

// DARK THEME
static const Color textPrimaryColorDark = Color(0xFFEEEEEE);
static const Color textSecondaryColorDark = Color(0xFFB3B3B3);
static const Color textHintColorDark = Color(0xFF808080);
```

### ألوان الحالة - Status Colors

```dart
static const Color successColor = Color(0xFF28A745);      // أخضر - نجاح
static const Color warningColor = Color(0xFFFFC107);      // أصفر - تحذير
static const Color errorColor = Color(0xFFDC3545);        // أحمر - خطأ
static const Color infoColor = Color(0xFF17A2B8);         // أزرق - معلومات
```

### ألوان التجارة - E-Commerce Colors

```dart
// PRICING
static const Color priceColor = Color(0xFF1A1A1A);
static const Color salePriceColor = Color(0xFFE31837);    // Sale Red
static const Color discountBadgeColor = Color(0xFFE31837);

// RATINGS
static const Color ratingStarColor = Color(0xFFFFB800);
static const Color ratingTextColor = Color(0xFF666666);
static const Color starInactiveColor = Color(0xFFE5E7EB);

// BADGES
static const Color freeShippingColor = Color(0xFF28A745);
static const Color fastDeliveryColor = Color(0xFF17A2B8);
static const Color verifiedSellerColor = Color(0xFF6F42C1);

// BORDERS
static const Color dividerColor = Color(0xFFE5E7EB);
static const Color borderColor = Color(0xFFD1D5DB);
static const Color dividerColorDark = Color(0xFF404040);
static const Color borderColorDark = Color(0xFF505050);
```

### � لون Accent (للاستخدام المحدود فقط)

```dart
// ⚠️ يُستخدم فقط لـ: CTAs مهمة، حالات خاصة، تمييز عناصر محددة
// ❌ ممنوع استخدامه كلون أساسي لأي شاشة

static const Color accentGreen = Color(0xFF13EC80);       // Accent فقط - ليس Primary!
```

### 🎬 ألوان Studio (Dark Theme)

```dart
// lib/features/studio/constants/studio_colors.dart

// PRIMARY
static const Color primaryColor = Color(0xFF2B6CEE);      // Blue Primary
static const Color secondaryColor = Color(0xFF9333EA);    // Purple
static const Color accentPink = Color(0xFFEC4899);
static const Color accentGreen = Color(0xFF10B981);
static const Color accentOrange = Color(0xFFF97316);

// BACKGROUNDS (Dark)
static const Color bgDark = Color(0xFF101622);
static const Color surfaceDark = Color(0xFF1C2333);
static const Color surfaceDarkAlt = Color(0xFF1C212E);
static const Color surfaceLighter = Color(0xFF282E39);
static const Color surfaceLight = Color(0xFF1C1F27);

// BACKGROUNDS (Light)
static const Color bgLight = Color(0xFFF6F6F8);

// BORDERS
static const Color borderDark = Color(0xFF3B4354);
static const Color borderLight = Color(0xFFE2E8F0);
static const Color borderSubtle = Color(0xFF334155);

// TEXT
static const Color textPrimary = Colors.white;
static const Color textSecondary = Color(0xFF9CA3AF);
static const Color textMuted = Color(0xFF6B7280);
```

---

## 🌈 التدرجات (Gradients)

```dart
// lib/core/theme/app_theme.dart

// BRAND GRADIENT - التدرج الرئيسي للعلامة التجارية
static const LinearGradient brandGradient = LinearGradient(
  colors: [Color(0xFF1E3A5F), Color(0xFF00B4B4)],  // Deep Navy → Teal
);

// METALLIC GRADIENT - تدرج معدني
static const LinearGradient metallicGradient = LinearGradient(
  colors: [Color(0xFF2563EB), Color(0xFF3B82F6), Color(0xFF60A5FA)],
);

// ACCENT GRADIENT - تدرج مميز
static const LinearGradient accentGradient = LinearGradient(
  colors: [Color(0xFFFF6B35), Color(0xFFE54D1B)],  // Orange → Deep Orange
);

// PRIMARY GRADIENT
static const LinearGradient primaryGradient = LinearGradient(
  colors: [Color(0xFF2563EB), Color(0xFF3B82F6), Color(0xFF60A5FA)],
);

// SECONDARY GRADIENT
static const LinearGradient secondaryGradient = LinearGradient(
  colors: [Color(0xFF2563EB), Color(0xFF3B82F6), Color(0xFF60A5FA)],
);

// LIGHT SURFACE GRADIENT
static const LinearGradient lightSurfaceGradient = LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
);

// CARD GRADIENT
static const LinearGradient cardGradient = LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFE2E8F0)],
);

// METALLIC SHINE
static const LinearGradient metallicShineGradient = LinearGradient(
  colors: [Color(0xFFE2E8F0), Color(0xFFF1F5F9)],
);

// SUBTLE OVERLAY
static const LinearGradient subtleOverlayGradient = LinearGradient(
  colors: [Color(0x0A2563EB), Color(0x0A3B82F6)],  // Blue 4% opacity
);

// SALE GRADIENT
static const LinearGradient saleGradient = LinearGradient(
  colors: [Color(0xFFE31837), Color(0xFFFF4757)],
);

// STUDIO GRADIENTS
static const LinearGradient studioGradient = LinearGradient(
  colors: [Color(0xFF2B6CEE), Color(0xFF9333EA)],   // Blue → Purple
);

static const LinearGradient studioAccentGradient = LinearGradient(
  colors: [Color(0xFFEC4899), Color(0xFFF97316)],   // Pink → Orange
);

static const LinearGradient studioCyanGradient = LinearGradient(
  colors: [Color(0xFF0EA5E9), Color(0xFF8B5CF6)],   // Cyan → Purple
);

static const LinearGradient studioProGradient = LinearGradient(
  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
);

static const LinearGradient studioIndigoGradient = LinearGradient(
  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
);
```

---

## 📐 الأبعاد والمقاسات (Dimensions)

### نظام التباعد - Spacing System (8pt Grid)

```dart
// lib/core/constants/app_dimensions.dart

class AppDimensions {
  // SPACING (based on 8pt grid system)
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing10 = 10;
  static const double spacing12 = 12;
  static const double spacing14 = 14;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;
  
  // SEMANTIC SPACING
  static const double spacingXXS = 2;
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;
  static const double spacingHuge = 64;
```

### نصف القطر للحواف - Border Radius

```dart
  // BORDER RADIUS
  static const double radiusXS = 4;
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 20;
  static const double radiusXXL = 24;
  static const double radiusFull = 999;   // للدوائر الكاملة
  
  // SEMANTIC RADIUS
  static const double buttonRadius = 12;
  static const double cardRadius = 16;
  static const double inputRadius = 12;
  static const double chipRadius = 20;
  static const double modalRadius = 24;
  static const double bottomSheetRadius = 24;
```

### أحجام الأيقونات - Icon Sizes

```dart
  // ICON SIZES
  static const double iconXS = 16;
  static const double iconS = 20;
  static const double iconM = 24;
  static const double iconL = 28;
  static const double iconXL = 32;
  static const double iconXXL = 40;
  static const double iconHero = 48;
  static const double iconDisplay = 64;
```

### ارتفاعات الأزرار - Button Heights

```dart
  // BUTTON HEIGHTS
  static const double buttonHeightS = 36;
  static const double buttonHeightM = 44;
  static const double buttonHeightL = 48;
  static const double buttonHeightXL = 56;
```

### ارتفاعات حقول الإدخال - Input Heights

```dart
  // INPUT HEIGHTS
  static const double inputHeightS = 40;
  static const double inputHeightM = 48;
  static const double inputHeightL = 56;
```

### أحجام الصور المصغرة - Thumbnail Sizes

```dart
  // THUMBNAIL SIZES
  static const double thumbnailXS = 32;
  static const double thumbnailS = 48;
  static const double thumbnailM = 64;
  static const double thumbnailL = 80;
  static const double thumbnailXL = 96;
  static const double thumbnailXXL = 120;
```

### أحجام الـ Avatar

```dart
  // AVATAR SIZES
  static const double avatarXS = 24;
  static const double avatarS = 32;
  static const double avatarM = 40;
  static const double avatarL = 48;
  static const double avatarXL = 64;
  static const double avatarXXL = 80;
  static const double avatarProfile = 120;
```

---

## ✏️ الخطوط والطباعة (Typography)

### الخط الرئيسي - Primary Font

```dart
// الخط: Cairo (Google Fonts)
// يدعم: العربية والإنجليزية
fontFamily: GoogleFonts.cairo().fontFamily
```

### أوزان الخط - Font Weights

```dart
static const FontWeight weightRegular = FontWeight.w400;
static const FontWeight weightMedium = FontWeight.w500;
static const FontWeight weightSemiBold = FontWeight.w600;
static const FontWeight weightBold = FontWeight.w700;
```

### أحجام الخطوط - Font Sizes

```dart
// lib/core/constants/app_dimensions.dart

// FONT SIZES
static const double fontCaption = 11;
static const double fontLabel = 12;
static const double fontBody2 = 13;
static const double fontBody = 14;
static const double fontSubtitle = 15;
static const double fontTitle = 16;
static const double fontHeadline = 18;
static const double fontH3 = 20;
static const double fontH2 = 24;
static const double fontH1 = 32;
static const double fontDisplay = 40;
```

### ارتفاع السطر - Line Heights

```dart
static const double lineHeightTight = 1.2;
static const double lineHeightNormal = 1.4;
static const double lineHeightRelaxed = 1.6;
static const double lineHeightLoose = 1.8;
```

### أنماط النصوص المُعرّفة - Text Styles

```dart
// lib/core/theme/app_theme.dart → textTheme

// displayLarge:  32px, Bold
// displayMedium: 24px, Bold  
// displaySmall:  20px, Bold
// headlineMedium: 18px, SemiBold
// headlineSmall:  16px, SemiBold
// titleLarge:    16px, SemiBold
// titleMedium:   14px, Medium
// titleSmall:    12px, Medium
// bodyLarge:     16px, Regular
// bodyMedium:    14px, Regular
// bodySmall:     12px, Regular
// labelLarge:    14px, Medium
// labelMedium:   12px, Medium
// labelSmall:    10px, Regular
```

---

## 🖼️ الأيقونات (Icons)

### مصدر الأيقونات

```dart
// Base Path: assets/icons/
// Format: SVG
// Reference File: lib/core/constants/app_icons.dart
```

### فئات الأيقونات

#### Navigation Icons
```dart
home, homeOutline, search, searchOutline
cart, cartOutline, profile, profileOutline
categories, categoriesOutline, menu, close
```

#### Arrow Icons
```dart
arrowLeft, arrowRight, arrowUp, arrowDown
chevronLeft, chevronRight, chevronUp, chevronDown
expand, collapse
```

#### Action Icons
```dart
edit, delete, add, remove, share
copy, paste, download, upload, refresh
filter, sort, settings, more, options
```

#### User Icons
```dart
user, userCircle, users, userAdd
login, logout, key, lock, unlock
```

#### Commerce Icons
```dart
store, product, order, invoice
payment, wallet, card, cash
shipping, delivery, tracking, package
```

#### Money Icons
```dart
dollar, currency, coins, moneyBag
discount, percent, priceTag, receipt
```

#### Alert Icons
```dart
info, warning, error, success
notification, bell, alert, check
```

#### Marketing Icons
```dart
campaign, promotion, coupon, gift
star, heart, favorite, bookmark
```

#### Media Icons
```dart
image, gallery, camera, video
play, pause, stop, record
music, microphone, volume
```

#### Social Icons
```dart
facebook, twitter, instagram, whatsapp
linkedin, youtube, tiktok, telegram
```

#### Document Icons
```dart
file, folder, document, pdf
excel, word, text, archive
```

#### Chart Icons
```dart
chart, barChart, lineChart, pieChart
analytics, statistics, growth, trend
```

---

## 🃏 البطاقات والحاويات (Cards & Containers)

### بطاقة قياسية - Standard Card

```dart
Container(
  decoration: BoxDecoration(
    color: surfaceColor,                    // أبيض في الفاتح
    borderRadius: BorderRadius.circular(16), // radiusL
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
  padding: EdgeInsets.all(16),              // spacingM
)
```

### بطاقة زجاجية - Glass Card (للثيم الأخضر)

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: isDark 
        ? [Color(0xFF1C3228), Color(0xFF162920)]
        : [Colors.white, Color(0xFFFAFAFA)],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: isDark ? Color(0xFF32674D) : Colors.grey.shade200,
    ),
  ),
)
```

### بطاقة مرتفعة - Elevated Card

```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: ...
)
```

---

## 🔘 المكونات (UI Components)

### الأزرار - Buttons

#### Primary Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,          // #215950 - Brand Primary
    foregroundColor: Colors.white,
    minimumSize: Size(double.infinity, 48), // buttonHeightL
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  ),
)
```

#### Secondary Button (Outlined)
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: BorderSide(color: primaryColor),
    minimumSize: Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

#### Text Button
```dart
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: primaryColor,
    minimumSize: Size(0, 44),
  ),
)
```

### حقول الإدخال - Input Fields

```dart
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: isDark ? Color(0xFF193326) : Colors.grey.shade50,
    hintText: 'النص التوضيحي',
    hintStyle: TextStyle(color: textHintColor),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isDark ? Color(0xFF32674D) : Colors.grey.shade200,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
  ),
)
```

### الشارات - Badges

```dart
// Status Badge
Container(
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: statusColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    'الحالة',
    style: TextStyle(
      color: statusColor,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  ),
)
```

### التبويبات - Tabs

```dart
// Segmented Tabs (Green Theme)
Container(
  decoration: BoxDecoration(
    color: isDark ? Color(0xFF1C3228) : Colors.grey.shade100,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      // Active Tab
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: primaryColor,            // #215950 - Brand Primary
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'تبويب نشط',
            style: TextStyle(
              color: isDark ? Color(0xFF102219) : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      // Inactive Tab
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'تبويب غير نشط',
            style: TextStyle(
              color: isDark ? Color(0xFF92C9AD) : Colors.grey,
            ),
          ),
        ),
      ),
    ],
  ),
)
```

### شريط البحث - Search Bar

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'البحث...',
    prefixIcon: Icon(Icons.search),
    filled: true,
    fillColor: isDark ? Color(0xFF193326) : Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
  ),
)
```

### شريط التنقل السفلي - Bottom Navigation

```dart
BottomNavigationBar(
  backgroundColor: surfaceColor,
  selectedItemColor: primaryColor,
  unselectedItemColor: Colors.grey,
  type: BottomNavigationBarType.fixed,
  selectedLabelStyle: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
)
```

---

## 📱 Widget Gallery - قائمة الـ Widgets المشتركة

```dart
// lib/shared/widgets/exports.dart

// Buttons
├── MbuyButton
├── MbuyIconButton
├── MbuyTextButton

// Cards
├── MbuyCard
├── GlassCard
├── ProductCard
├── OrderCard

// Inputs
├── MbuyTextField
├── MbuySearchField
├── MbuyDropdown

// Dialogs & Sheets
├── MbuyDialog
├── MbuyBottomSheet
├── MbuySnackbar

// Loading & Empty
├── MbuyLoader
├── MbuyShimmer
├── MbuyEmptyState

// Navigation
├── MbuyAppBar
├── MbuyBottomNav
├── MbuyDrawer

// Lists
├── MbuyListTile
├── MbuySwipeable

// Media
├── MbuyImage
├── MbuyAvatar
├── MbuyGallery

// Status
├── MbuyBadge
├── MbuyChip
├── MbuyTag
├── MbuyRating

// Layout
├── MbuySection
├── MbuyDivider
├── MbuySpacer
```

---

## 🎯 أنماط التصميم المتكررة (Design Patterns)

### نمط الشاشة القياسي

```dart
Scaffold(
  backgroundColor: isDark ? backgroundDark : bgLight,
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Text(
      'عنوان الشاشة',
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  body: SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...],
      ),
    ),
  ),
)
```

### نمط قائمة العناصر

```dart
ListView.separated(
  padding: EdgeInsets.all(16),
  itemCount: items.length,
  separatorBuilder: (_, __) => SizedBox(height: 12),
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withOpacity(0.1)),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon/Image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.item, color: primaryColor),
          ),
          SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ...),
                Text(subtitle, style: ...),
              ],
            ),
          ),
          // Action
          Icon(Icons.chevron_right),
        ],
      ),
    );
  },
)
```

### نمط Header مع Gradient

```dart
Container(
  width: double.infinity,
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF215950), Color(0xFF2D7A6E)], // Brand Primary gradient
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    children: [
      Text(
        'عنوان رئيسي',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'عنوان فرعي',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
        ),
      ),
    ],
  ),
)
```

---

## 📊 جدول المراجع السريع

### الألوان الأكثر استخداماً

| الاسم | Hex | الاستخدام |
|------|-----|---------|
| **Brand Primary** | `#215950` | اللون الأساسي الوحيد (ثابت) |
| Primary Light | `#2D7A6E` | نسخة فاتحة |
| Primary Dark | `#153B35` | نسخة داكنة |
| Accent Green | `#13EC80` | CTA مهمة فقط (محدود) |
| Background Light | `#F1F5F9` | خلفية فاتحة |
| Background Dark | `#121212` | خلفية داكنة |
| Surface Light | `#FFFFFF` | سطح فاتح |
| Surface Dark | `#1E1E1E` | سطح داكن |
| Text Primary | `#0F172A` | نص رئيسي |
| Text Secondary | `#64748B` | نص ثانوي |

### المقاسات الأكثر استخداماً

| العنصر | القيمة |
|--------|-------|
| Padding الشاشة | 16px |
| Gap بين العناصر | 12px |
| Border Radius للبطاقات | 16px |
| Border Radius للأزرار | 12px |
| ارتفاع الزر | 48px |
| حجم الأيقونة | 24px |
| حجم الخط العنوان | 18px |
| حجم الخط الجسم | 14px |
| حجم الخط التسمية | 12px |

---

## ✅ قواعد التصميم (Design Rules)

1. **اتجاه النص**: RTL (من اليمين لليسار) للعربية
2. **الخط**: Cairo فقط لضمان دعم العربية
3. **الـ Spacing**: يتبع نظام 8pt grid
4. **الـ Border Radius**: 
   - صغير: 8px
   - متوسط: 12px  
   - كبير: 16px
   - دائري: 20-24px
5. **الظلال**: خفيفة جداً (opacity 0.04-0.08)
6. **التباين**: يجب أن يكون 4.5:1 على الأقل للنصوص

---

> **ملاحظة**: هذا المستند يُعتبر المرجع الرسمي للتصميم. 
> أي تغييرات في التصميم يجب أن تُوثق هنا أولاً.
