import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// خدمة التخزين المحلي باستخدام SharedPreferences
class PreferencesService {
  static SharedPreferences? _prefs;

  /// تهيئة الخدمة
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('✅ تم تهيئة PreferencesService');
  }

  /// الحصول على SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('PreferencesService غير مهيأ. استدعِ initialize() أولاً');
    }
    return _prefs!;
  }

  // ==================== Theme ====================

  /// حفظ تفضيل الثيم
  static Future<bool> saveThemeMode(String mode) async {
    return await prefs.setString('theme_mode', mode);
  }

  /// جلب تفضيل الثيم
  static String? getThemeMode() {
    return prefs.getString('theme_mode');
  }

  // ==================== Language ====================

  /// حفظ اللغة المفضلة
  static Future<bool> saveLanguage(String languageCode) async {
    return await prefs.setString('language', languageCode);
  }

  /// جلب اللغة المفضلة
  static String? getLanguage() {
    return prefs.getString('language');
  }

  // ==================== Notifications ====================

  /// حفظ حالة الإشعارات
  static Future<bool> saveNotificationsEnabled(bool enabled) async {
    return await prefs.setBool('notifications_enabled', enabled);
  }

  /// جلب حالة الإشعارات
  static bool getNotificationsEnabled() {
    return prefs.getBool('notifications_enabled') ?? true;
  }

  // ==================== FCM Token ====================

  /// حفظ FCM Token
  static Future<bool> saveFCMToken(String token) async {
    return await prefs.setString('fcm_token', token);
  }

  /// جلب FCM Token
  static String? getFCMToken() {
    return prefs.getString('fcm_token');
  }

  // ==================== Search History ====================

  /// حفظ سجل البحث
  static Future<bool> saveSearchHistory(List<String> searches) async {
    return await prefs.setStringList('search_history', searches);
  }

  /// جلب سجل البحث
  static List<String> getSearchHistory() {
    return prefs.getStringList('search_history') ?? [];
  }

  /// مسح سجل البحث
  static Future<bool> clearSearchHistory() async {
    return await prefs.remove('search_history');
  }

  // ==================== General ====================

  /// حذف جميع البيانات المحفوظة
  static Future<bool> clearAll() async {
    return await prefs.clear();
  }

  /// حذف مفتاح محدد
  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }
}

