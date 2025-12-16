import 'package:flutter/services.dart';

/// مساعد Haptic Feedback الموحد
/// يوفر تجربة لمسية متسقة عبر التطبيق
class HapticHelper {
  HapticHelper._();

  /// تأثير خفيف - للنقر على الأزرار العادية
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// تأثير متوسط - للإجراءات المهمة
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// تأثير قوي - للإجراءات الحاسمة
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// تأثير النقر - للضغط على العناصر
  static void selection() {
    HapticFeedback.selectionClick();
  }

  /// تأثير النجاح - عند إتمام عملية
  static void success() {
    HapticFeedback.mediumImpact();
  }

  /// تأثير الخطأ - عند حدوث خطأ
  static void error() {
    HapticFeedback.heavyImpact();
  }

  /// تأثير التحذير - للتنبيهات
  static void warning() {
    HapticFeedback.mediumImpact();
  }

  /// تأثير السحب والإفلات
  static void dragStart() {
    HapticFeedback.selectionClick();
  }

  /// تأثير الإفلات
  static void dragEnd() {
    HapticFeedback.lightImpact();
  }

  /// تأثير التمرير للتحديث
  static void refresh() {
    HapticFeedback.mediumImpact();
  }

  /// تأثير الحذف
  static void delete() {
    HapticFeedback.heavyImpact();
  }

  /// تأثير التبديل (Switch/Toggle)
  static void toggle() {
    HapticFeedback.selectionClick();
  }

  /// تأثير إضافة عنصر
  static void add() {
    HapticFeedback.lightImpact();
  }

  /// تأثير التنقل
  static void navigate() {
    HapticFeedback.selectionClick();
  }
}

/// Extension لإضافة Haptic بسهولة للـ GestureDetector و InkWell
extension HapticExtension on VoidCallback {
  /// تنفيذ الإجراء مع تأثير لمسي خفيف
  VoidCallback withLightHaptic() {
    return () {
      HapticHelper.light();
      this();
    };
  }

  /// تنفيذ الإجراء مع تأثير لمسي متوسط
  VoidCallback withMediumHaptic() {
    return () {
      HapticHelper.medium();
      this();
    };
  }

  /// تنفيذ الإجراء مع تأثير نقر
  VoidCallback withSelectionHaptic() {
    return () {
      HapticHelper.selection();
      this();
    };
  }
}
