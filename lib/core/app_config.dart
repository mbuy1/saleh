import 'package:flutter/material.dart';

/// وضع التطبيق: عميل أو تاجر
enum AppMode {
  customer, // وضع العميل (التسوق)
  merchant, // وضع التاجر (لوحة التحكم)
}

/// Provider بسيط لإدارة AppMode
/// 
/// يمكن استخدامه في أي مكان في التطبيق لتغيير أو قراءة AppMode
class AppModeProvider extends ChangeNotifier {
  AppMode _mode = AppMode.customer;

  AppMode get mode => _mode;

  /// تغيير وضع التطبيق
  void setMode(AppMode mode) {
    if (_mode != mode) {
      _mode = mode;
      notifyListeners();
    }
  }

  /// تغيير إلى وضع العميل
  void setCustomerMode() {
    setMode(AppMode.customer);
  }

  /// تغيير إلى وضع التاجر
  void setMerchantMode() {
    setMode(AppMode.merchant);
  }

  /// التحقق من وجود صلاحيات تاجر
  /// TODO: يجب التحقق من قاعدة البيانات أو Supabase
  bool hasMerchantAccess() {
    // في الوقت الحالي، نرجع true للجميع
    // يمكن لاحقاً التحقق من user role في Supabase
    return true;
  }
}

