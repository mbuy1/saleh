import 'package:flutter/material.dart';

/// مزود الثيم - يدير حالة الثيم في التطبيق
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// تغيير الثيم
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    _saveThemeMode(mode);
  }

  /// التبديل بين Light و Dark
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  /// حفظ تفضيل الثيم
  /// TODO: دمج مع SharedPreferences عند إضافته للمشروع
  void _saveThemeMode(ThemeMode mode) {
    // سيتم حفظه في SharedPreferences
    debugPrint('💾 Theme saved: $mode');
  }

  /// تحميل تفضيل الثيم المحفوظ
  /// TODO: جلب من SharedPreferences عند إضافته للمشروع
  Future<void> loadThemeMode() async {
    // سيتم جلبه من SharedPreferences
    // _themeMode = savedMode;
    // notifyListeners();
  }
}
