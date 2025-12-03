import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

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
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      final modeString = mode.toString().split('.').last; // 'light', 'dark', 'system'
      await PreferencesService.saveThemeMode(modeString);
      debugPrint('💾 Theme saved: $modeString');
    } catch (e) {
      debugPrint('⚠️ خطأ في حفظ الثيم: $e');
    }
  }

  /// تحميل تفضيل الثيم المحفوظ
  Future<void> loadThemeMode() async {
    try {
      final savedMode = PreferencesService.getThemeMode();
      if (savedMode != null) {
        switch (savedMode) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          case 'system':
            _themeMode = ThemeMode.system;
            break;
        }
        notifyListeners();
        debugPrint('✅ تم تحميل الثيم: $savedMode');
      }
    } catch (e) {
      debugPrint('⚠️ خطأ في تحميل الثيم: $e');
    }
  }
}
