/// نموذج إعدادات المتجر (Store Settings)
/// TODO: إكمال التنفيذ عند الحاجة
class StoreSettingsModel {
  final String storeId;
  final Map<String, dynamic> settings; // جميع الإعدادات

  // إعدادات عامة
  final bool? isAcceptingOrders;
  final bool? isAcceptingNewCustomers;
  final String? defaultCurrency;
  final String? defaultLanguage;
  final String? timezone;

  // إعدادات الطلبات
  final int? minOrderAmount;
  final int? maxOrderAmount;
  final int? estimatedDeliveryDays;
  final bool? allowCashOnDelivery;
  final bool? allowWalletPayment;

  // إعدادات الإشعارات
  final bool? emailNotificationsEnabled;
  final bool? smsNotificationsEnabled;
  final bool? pushNotificationsEnabled;

  // إعدادات أخرى
  final Map<String, dynamic>? customSettings;

  StoreSettingsModel({
    required this.storeId,
    required this.settings,
    this.isAcceptingOrders,
    this.isAcceptingNewCustomers,
    this.defaultCurrency,
    this.defaultLanguage,
    this.timezone,
    this.minOrderAmount,
    this.maxOrderAmount,
    this.estimatedDeliveryDays,
    this.allowCashOnDelivery,
    this.allowWalletPayment,
    this.emailNotificationsEnabled,
    this.smsNotificationsEnabled,
    this.pushNotificationsEnabled,
    this.customSettings,
  });

  factory StoreSettingsModel.fromJson(Map<String, dynamic> json) {
    return StoreSettingsModel(
      storeId: json['store_id'] as String,
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      isAcceptingOrders: json['is_accepting_orders'] as bool?,
      isAcceptingNewCustomers: json['is_accepting_new_customers'] as bool?,
      defaultCurrency: json['default_currency'] as String?,
      defaultLanguage: json['default_language'] as String?,
      timezone: json['timezone'] as String?,
      minOrderAmount: json['min_order_amount'] as int?,
      maxOrderAmount: json['max_order_amount'] as int?,
      estimatedDeliveryDays: json['estimated_delivery_days'] as int?,
      allowCashOnDelivery: json['allow_cash_on_delivery'] as bool?,
      allowWalletPayment: json['allow_wallet_payment'] as bool?,
      emailNotificationsEnabled: json['email_notifications_enabled'] as bool?,
      smsNotificationsEnabled: json['sms_notifications_enabled'] as bool?,
      pushNotificationsEnabled: json['push_notifications_enabled'] as bool?,
      customSettings: json['custom_settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'settings': settings,
      'is_accepting_orders': isAcceptingOrders,
      'is_accepting_new_customers': isAcceptingNewCustomers,
      'default_currency': defaultCurrency,
      'default_language': defaultLanguage,
      'timezone': timezone,
      'min_order_amount': minOrderAmount,
      'max_order_amount': maxOrderAmount,
      'estimated_delivery_days': estimatedDeliveryDays,
      'allow_cash_on_delivery': allowCashOnDelivery,
      'allow_wallet_payment': allowWalletPayment,
      'email_notifications_enabled': emailNotificationsEnabled,
      'sms_notifications_enabled': smsNotificationsEnabled,
      'push_notifications_enabled': pushNotificationsEnabled,
      'custom_settings': customSettings,
    };
  }
}

