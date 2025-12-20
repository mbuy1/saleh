/// ============================================================================
/// Shared Exports - المكونات المشتركة الموحدة
/// ============================================================================
///
/// استيراد هذا الملف للحصول على جميع المكونات المشتركة:
/// ```dart
/// import 'package:saleh/shared/widgets/exports.dart';
/// ```
///
/// المكونات المتاحة:
/// - Theme & Dimensions: ألوان وأبعاد التطبيق
/// - Buttons: MbuyButton (primary, secondary, outline, text, gradient)
/// - Cards: MbuyCard, GlassCard
/// - Form Inputs: MbuyTextField, MbuyDropdown, MbuySwitch, MbuyCheckbox
/// - Dialogs: MbuyDialog, MbuyBottomSheet, MbuyActionSheet
/// - Chips & Tags: MbuyChip, MbuyTag, MbuyChipGroup
/// - Avatar: MbuyAvatar
/// - States: MbuyEmptyState, MbuyLoadingIndicator, SkeletonLoading
/// - Layout: SubPageScaffold, MbuyScaffold
///
library;

// ============================================================================
// Theme & Constants - الثيم والثوابت
// ============================================================================
export '../../core/theme/app_theme.dart';
export '../../core/constants/app_dimensions.dart';
export '../../core/constants/app_icons.dart';

// ============================================================================
// Shared Widgets - المكونات الأساسية
// ============================================================================
// نخفي المكونات المكررة من shared_widgets
export 'shared_widgets.dart' hide MbuyButton, MbuyButtonType;

// ============================================================================
// Buttons - الأزرار
// ============================================================================
export 'mbuy_button.dart';

// ============================================================================
// Cards - البطاقات
// ============================================================================
export 'mbuy_card.dart';
export 'glass_card.dart';

// ============================================================================
// Form Inputs - حقول الإدخال
// ============================================================================
export 'mbuy_dropdown.dart';
export 'mbuy_switch.dart';

// ============================================================================
// Dialogs & Sheets - الحوارات والنوافذ
// ============================================================================
export 'mbuy_dialog.dart';
export 'mbuy_bottom_sheet.dart';

// ============================================================================
// Chips & Tags - الشرائح والوسوم
// ============================================================================
export 'mbuy_chips.dart';

// ============================================================================
// Avatar - الأفاتار
// ============================================================================
export 'mbuy_avatar.dart';

// ============================================================================
// Loading States - حالات التحميل
// ============================================================================
export 'skeleton_loading.dart';
export 'loading_states.dart';

// ============================================================================
// Icons & Visual - الأيقونات
// ============================================================================
export 'app_icon.dart';

// ============================================================================
// UX Enhancement - تحسينات تجربة المستخدم
// ============================================================================
export 'app_search_delegate.dart';
export 'app_breadcrumb.dart';
export 'accessible_button.dart';

// ============================================================================
// Layout & Scaffolds - التخطيط والهياكل
// ============================================================================
export 'base_screen.dart';
export 'error_boundary.dart';
export 'sub_page_scaffold.dart';

// Utils
export '../utils/dialog_helper.dart';
export '../utils/haptic_helper.dart';
