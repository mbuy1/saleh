import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مزود خدمة تفضيلات المستخدم
final userPreferencesProvider = Provider<UserPreferencesService>((ref) {
  return UserPreferencesService();
});

/// مزود حالة التفضيلات
final preferencesStateProvider =
    StateNotifierProvider<PreferencesNotifier, UserPreferences>((ref) {
  return PreferencesNotifier(ref.read(userPreferencesProvider));
});

/// خدمة تفضيلات المستخدم الشاملة
/// تدير جميع إعدادات وتفضيلات المستخدم
class UserPreferencesService {
  static const String _keyPrefix = 'user_pref_';

  // ============================================================================
  // Keys
  // ============================================================================
  static const String keyOnboardingComplete = '${_keyPrefix}onboarding_complete';
  static const String keyOnboardingStep = '${_keyPrefix}onboarding_step';
  static const String keyShortcuts = '${_keyPrefix}shortcuts';
  static const String keyQuickActions = '${_keyPrefix}quick_actions';
  static const String keyNotificationSettings = '${_keyPrefix}notification_settings';
  static const String keyHomeLayout = '${_keyPrefix}home_layout';
  static const String keyThemeMode = '${_keyPrefix}theme_mode';
  static const String keyLanguage = '${_keyPrefix}language';
  static const String keyLastSyncTime = '${_keyPrefix}last_sync';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ============================================================================
  // Onboarding
  // ============================================================================

  /// هل أكمل المستخدم الـ Onboarding
  Future<bool> isOnboardingComplete() async {
    final p = await prefs;
    return p.getBool(keyOnboardingComplete) ?? false;
  }

  /// تعيين حالة إكمال الـ Onboarding
  Future<void> setOnboardingComplete(bool complete) async {
    final p = await prefs;
    await p.setBool(keyOnboardingComplete, complete);
  }

  /// الحصول على خطوة الـ Onboarding الحالية
  Future<int> getOnboardingStep() async {
    final p = await prefs;
    return p.getInt(keyOnboardingStep) ?? 0;
  }

  /// حفظ خطوة الـ Onboarding
  Future<void> setOnboardingStep(int step) async {
    final p = await prefs;
    await p.setInt(keyOnboardingStep, step);
  }

  // ============================================================================
  // Shortcuts
  // ============================================================================

  /// الحصول على الاختصارات المحفوظة
  Future<List<String>> getShortcuts() async {
    final p = await prefs;
    return p.getStringList(keyShortcuts) ?? [];
  }

  /// حفظ الاختصارات
  Future<void> setShortcuts(List<String> shortcuts) async {
    final p = await prefs;
    await p.setStringList(keyShortcuts, shortcuts);
  }

  /// الحصول على الإجراءات السريعة (Home Quick Actions)
  Future<List<String>> getQuickActions() async {
    final p = await prefs;
    return p.getStringList(keyQuickActions) ?? _defaultQuickActions;
  }

  /// حفظ الإجراءات السريعة
  Future<void> setQuickActions(List<String> actions) async {
    final p = await prefs;
    await p.setStringList(keyQuickActions, actions);
  }

  static const List<String> _defaultQuickActions = [
    'add_product',
    'view_orders',
    'coupons',
    'reports',
    'customers',
    'settings',
  ];

  // ============================================================================
  // Notification Settings
  // ============================================================================

  /// الحصول على إعدادات الإشعارات
  Future<NotificationSettings> getNotificationSettings() async {
    final p = await prefs;
    final jsonStr = p.getString(keyNotificationSettings);
    if (jsonStr != null) {
      try {
        return NotificationSettings.fromJson(json.decode(jsonStr));
      } catch (e) {
        debugPrint('Error parsing notification settings: $e');
      }
    }
    return NotificationSettings.defaults();
  }

  /// حفظ إعدادات الإشعارات
  Future<void> setNotificationSettings(NotificationSettings settings) async {
    final p = await prefs;
    await p.setString(keyNotificationSettings, json.encode(settings.toJson()));
  }

  // ============================================================================
  // Home Layout
  // ============================================================================

  /// الحصول على ترتيب عناصر الصفحة الرئيسية
  Future<List<String>> getHomeLayout() async {
    final p = await prefs;
    return p.getStringList(keyHomeLayout) ?? _defaultHomeLayout;
  }

  /// حفظ ترتيب عناصر الصفحة الرئيسية
  Future<void> setHomeLayout(List<String> layout) async {
    final p = await prefs;
    await p.setStringList(keyHomeLayout, layout);
  }

  static const List<String> _defaultHomeLayout = [
    'stats_cards',
    'quick_actions',
    'recent_orders',
    'top_products',
    'marketing_banner',
  ];

  // ============================================================================
  // Theme & Language
  // ============================================================================

  /// الحصول على وضع السمة
  Future<ThemeMode> getThemeMode() async {
    final p = await prefs;
    final mode = p.getString(keyThemeMode) ?? 'system';
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// حفظ وضع السمة
  Future<void> setThemeMode(ThemeMode mode) async {
    final p = await prefs;
    String modeStr;
    switch (mode) {
      case ThemeMode.light:
        modeStr = 'light';
        break;
      case ThemeMode.dark:
        modeStr = 'dark';
        break;
      default:
        modeStr = 'system';
    }
    await p.setString(keyThemeMode, modeStr);
  }

  /// الحصول على اللغة
  Future<String> getLanguage() async {
    final p = await prefs;
    return p.getString(keyLanguage) ?? 'ar';
  }

  /// حفظ اللغة
  Future<void> setLanguage(String lang) async {
    final p = await prefs;
    await p.setString(keyLanguage, lang);
  }

  // ============================================================================
  // Clear & Reset
  // ============================================================================

  /// مسح جميع التفضيلات
  Future<void> clearAll() async {
    final p = await prefs;
    final keys = p.getKeys().where((k) => k.startsWith(_keyPrefix));
    for (final key in keys) {
      await p.remove(key);
    }
  }

  /// إعادة تعيين التفضيلات للقيم الافتراضية
  Future<void> resetToDefaults() async {
    await clearAll();
    await setShortcuts([]);
    await setQuickActions(_defaultQuickActions);
    await setHomeLayout(_defaultHomeLayout);
    await setNotificationSettings(NotificationSettings.defaults());
  }
}

// ============================================================================
// Notification Settings Model
// ============================================================================

/// إعدادات الإشعارات
class NotificationSettings {
  /// تفعيل الإشعارات
  final bool enabled;

  /// إشعارات الطلبات الجديدة
  final bool newOrders;

  /// إشعارات حالة الطلبات
  final bool orderStatus;

  /// إشعارات المخزون المنخفض
  final bool lowStock;

  /// إشعارات رسائل العملاء
  final bool customerMessages;

  /// إشعارات التقييمات
  final bool reviews;

  /// إشعارات العروض والترويج
  final bool promotions;

  /// إشعارات النظام والتحديثات
  final bool systemUpdates;

  /// إشعارات التقارير
  final bool reports;

  /// الصوت
  final bool sound;

  /// الاهتزاز
  final bool vibration;

  /// الإشعارات الصامتة (وقت الهدوء)
  final bool quietMode;

  /// بداية وقت الهدوء (ساعة)
  final int quietStartHour;

  /// نهاية وقت الهدوء (ساعة)
  final int quietEndHour;

  const NotificationSettings({
    this.enabled = true,
    this.newOrders = true,
    this.orderStatus = true,
    this.lowStock = true,
    this.customerMessages = true,
    this.reviews = true,
    this.promotions = true,
    this.systemUpdates = true,
    this.reports = false,
    this.sound = true,
    this.vibration = true,
    this.quietMode = false,
    this.quietStartHour = 22,
    this.quietEndHour = 7,
  });

  factory NotificationSettings.defaults() => const NotificationSettings();

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabled: json['enabled'] ?? true,
      newOrders: json['new_orders'] ?? true,
      orderStatus: json['order_status'] ?? true,
      lowStock: json['low_stock'] ?? true,
      customerMessages: json['customer_messages'] ?? true,
      reviews: json['reviews'] ?? true,
      promotions: json['promotions'] ?? true,
      systemUpdates: json['system_updates'] ?? true,
      reports: json['reports'] ?? false,
      sound: json['sound'] ?? true,
      vibration: json['vibration'] ?? true,
      quietMode: json['quiet_mode'] ?? false,
      quietStartHour: json['quiet_start_hour'] ?? 22,
      quietEndHour: json['quiet_end_hour'] ?? 7,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'new_orders': newOrders,
        'order_status': orderStatus,
        'low_stock': lowStock,
        'customer_messages': customerMessages,
        'reviews': reviews,
        'promotions': promotions,
        'system_updates': systemUpdates,
        'reports': reports,
        'sound': sound,
        'vibration': vibration,
        'quiet_mode': quietMode,
        'quiet_start_hour': quietStartHour,
        'quiet_end_hour': quietEndHour,
      };

  NotificationSettings copyWith({
    bool? enabled,
    bool? newOrders,
    bool? orderStatus,
    bool? lowStock,
    bool? customerMessages,
    bool? reviews,
    bool? promotions,
    bool? systemUpdates,
    bool? reports,
    bool? sound,
    bool? vibration,
    bool? quietMode,
    int? quietStartHour,
    int? quietEndHour,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      newOrders: newOrders ?? this.newOrders,
      orderStatus: orderStatus ?? this.orderStatus,
      lowStock: lowStock ?? this.lowStock,
      customerMessages: customerMessages ?? this.customerMessages,
      reviews: reviews ?? this.reviews,
      promotions: promotions ?? this.promotions,
      systemUpdates: systemUpdates ?? this.systemUpdates,
      reports: reports ?? this.reports,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      quietMode: quietMode ?? this.quietMode,
      quietStartHour: quietStartHour ?? this.quietStartHour,
      quietEndHour: quietEndHour ?? this.quietEndHour,
    );
  }
}

// ============================================================================
// User Preferences State
// ============================================================================

/// نموذج حالة التفضيلات الكاملة
class UserPreferences {
  final bool isLoading;
  final List<String> shortcuts;
  final List<String> quickActions;
  final NotificationSettings notificationSettings;
  final List<String> homeLayout;
  final ThemeMode themeMode;
  final String language;
  final bool onboardingComplete;

  const UserPreferences({
    this.isLoading = true,
    this.shortcuts = const [],
    this.quickActions = const [],
    this.notificationSettings = const NotificationSettings(),
    this.homeLayout = const [],
    this.themeMode = ThemeMode.system,
    this.language = 'ar',
    this.onboardingComplete = false,
  });

  UserPreferences copyWith({
    bool? isLoading,
    List<String>? shortcuts,
    List<String>? quickActions,
    NotificationSettings? notificationSettings,
    List<String>? homeLayout,
    ThemeMode? themeMode,
    String? language,
    bool? onboardingComplete,
  }) {
    return UserPreferences(
      isLoading: isLoading ?? this.isLoading,
      shortcuts: shortcuts ?? this.shortcuts,
      quickActions: quickActions ?? this.quickActions,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      homeLayout: homeLayout ?? this.homeLayout,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}

/// مدير حالة التفضيلات
class PreferencesNotifier extends StateNotifier<UserPreferences> {
  final UserPreferencesService _service;

  PreferencesNotifier(this._service) : super(const UserPreferences()) {
    loadAll();
  }

  /// تحميل جميع التفضيلات
  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);

    final shortcuts = await _service.getShortcuts();
    final quickActions = await _service.getQuickActions();
    final notificationSettings = await _service.getNotificationSettings();
    final homeLayout = await _service.getHomeLayout();
    final themeMode = await _service.getThemeMode();
    final language = await _service.getLanguage();
    final onboardingComplete = await _service.isOnboardingComplete();

    state = UserPreferences(
      isLoading: false,
      shortcuts: shortcuts,
      quickActions: quickActions,
      notificationSettings: notificationSettings,
      homeLayout: homeLayout,
      themeMode: themeMode,
      language: language,
      onboardingComplete: onboardingComplete,
    );
  }

  /// تحديث الاختصارات
  Future<void> updateShortcuts(List<String> shortcuts) async {
    await _service.setShortcuts(shortcuts);
    state = state.copyWith(shortcuts: shortcuts);
  }

  /// تحديث الإجراءات السريعة
  Future<void> updateQuickActions(List<String> actions) async {
    await _service.setQuickActions(actions);
    state = state.copyWith(quickActions: actions);
  }

  /// تحديث إعدادات الإشعارات
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    await _service.setNotificationSettings(settings);
    state = state.copyWith(notificationSettings: settings);
  }

  /// تحديث ترتيب الصفحة الرئيسية
  Future<void> updateHomeLayout(List<String> layout) async {
    await _service.setHomeLayout(layout);
    state = state.copyWith(homeLayout: layout);
  }

  /// تحديث وضع السمة
  Future<void> updateThemeMode(ThemeMode mode) async {
    await _service.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  /// تحديث اللغة
  Future<void> updateLanguage(String lang) async {
    await _service.setLanguage(lang);
    state = state.copyWith(language: lang);
  }

  /// إكمال الـ Onboarding
  Future<void> completeOnboarding() async {
    await _service.setOnboardingComplete(true);
    state = state.copyWith(onboardingComplete: true);
  }

  /// إعادة تعيين للقيم الافتراضية
  Future<void> resetToDefaults() async {
    await _service.resetToDefaults();
    await loadAll();
  }
}
