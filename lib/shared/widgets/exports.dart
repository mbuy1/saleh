/// Shared Exports
/// استيراد هذا الملف للحصول على جميع المكونات المشتركة
library;

// Theme & Dimensions
export '../../core/theme/app_theme.dart';
export '../../core/constants/app_dimensions.dart';
export '../../core/constants/app_icons.dart';

// Shared Widgets
export 'shared_widgets.dart' hide MbuyButton, MbuyButtonType, MbuyCard;
export 'skeleton_loading.dart';
export 'loading_states.dart';

// New Unified Components
export 'mbuy_button.dart';
export 'mbuy_card.dart';
export 'glass_card.dart';
export 'app_icon.dart';

// UX Enhancement Components
export 'app_search_delegate.dart';
export 'app_breadcrumb.dart';
export 'accessible_button.dart';

// Base Screen & Error Handling
export 'base_screen.dart';
export 'error_boundary.dart';

// Utils
export '../utils/dialog_helper.dart';
export '../utils/haptic_helper.dart';
