import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================================
/// Theme Provider - إدارة الوضع الداكن/الفاتح
/// ============================================================================
///
/// يوفر:
/// - تبديل بين الوضع الفاتح والداكن
/// - حفظ التفضيل في التخزين المحلي
/// - استرجاع التفضيل عند فتح التطبيق
/// - دعم وضع النظام التلقائي

const String _themePreferenceKey = 'theme_mode';

/// حالة الثيم
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Provider للثيم
final themeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(() {
  return ThemeNotifier();
});

/// Provider لـ ThemeMode المستخدم فعلياً
final effectiveThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeMode = ref.watch(themeProvider);
  switch (themeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});

/// Provider للتحقق من الوضع الداكن
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == AppThemeMode.dark;
});

/// Notifier للثيم
class ThemeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    _loadTheme();
    return AppThemeMode.light;
  }

  /// تحميل الثيم من التخزين
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themePreferenceKey);
      if (themeIndex != null && themeIndex < AppThemeMode.values.length) {
        state = AppThemeMode.values[themeIndex];
      }
    } catch (e) {
      // في حالة الخطأ، نستخدم الوضع الفاتح
      state = AppThemeMode.light;
    }
  }

  /// تعيين الثيم وحفظه
  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, mode.index);
    } catch (e) {
      // تجاهل أخطاء الحفظ
    }
  }

  /// تبديل بين الفاتح والداكن
  Future<void> toggleTheme() async {
    final newMode =
        state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    await setTheme(newMode);
  }

  /// تعيين الوضع الفاتح
  Future<void> setLightMode() async {
    await setTheme(AppThemeMode.light);
  }

  /// تعيين الوضع الداكن
  Future<void> setDarkMode() async {
    await setTheme(AppThemeMode.dark);
  }

  /// تعيين وضع النظام
  Future<void> setSystemMode() async {
    await setTheme(AppThemeMode.system);
  }
}

/// Widget لتبديل الثيم (Dark Mode Toggle)
class ThemeToggleWidget extends ConsumerWidget {
  final bool showLabel;
  final bool compact;

  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == AppThemeMode.dark;

    if (compact) {
      return Semantics(
        label: isDark ? 'تفعيل الوضع الفاتح' : 'تفعيل الوضع الداكن',
        button: true,
        child: IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              key: ValueKey(isDark),
            ),
          ),
          onPressed: () {
            ref.read(themeProvider.notifier).toggleTheme();
          },
          tooltip: isDark ? 'الوضع الفاتح' : 'الوضع الداكن',
        ),
      );
    }

    return Semantics(
      label: 'تبديل الوضع الداكن',
      toggled: isDark,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: showLabel ? const Text('الوضع الداكن') : null,
        subtitle: showLabel
            ? Text(
                isDark ? 'مفعّل' : 'معطّل',
                style: TextStyle(
                  color: isDark ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: Switch.adaptive(
          value: isDark,
          onChanged: (value) {
            ref.read(themeProvider.notifier).setTheme(
                  value ? AppThemeMode.dark : AppThemeMode.light,
                );
          },
          activeTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          activeThumbColor: Theme.of(context).primaryColor,
        ),
        onTap: () {
          ref.read(themeProvider.notifier).toggleTheme();
        },
      ),
    );
  }
}

/// Selector للثيم (3 خيارات)
class ThemeSelectorWidget extends ConsumerWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Semantics(
      label: 'اختيار مظهر التطبيق',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'مظهر التطبيق',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _ThemeOption(
            icon: Icons.light_mode,
            title: 'فاتح',
            subtitle: 'استخدام المظهر الفاتح دائماً',
            isSelected: themeMode == AppThemeMode.light,
            onTap: () {
              ref.read(themeProvider.notifier).setLightMode();
            },
          ),
          _ThemeOption(
            icon: Icons.dark_mode,
            title: 'داكن',
            subtitle: 'استخدام المظهر الداكن دائماً',
            isSelected: themeMode == AppThemeMode.dark,
            onTap: () {
              ref.read(themeProvider.notifier).setDarkMode();
            },
          ),
          _ThemeOption(
            icon: Icons.settings_suggest,
            title: 'تلقائي',
            subtitle: 'اتباع إعدادات النظام',
            isSelected: themeMode == AppThemeMode.system,
            onTap: () {
              ref.read(themeProvider.notifier).setSystemMode();
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Semantics(
      label: title,
      hint: subtitle,
      selected: isSelected,
      button: true,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.15)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isSelected ? primaryColor : Colors.grey,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? primaryColor : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: primaryColor)
            : const Icon(Icons.circle_outlined, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
