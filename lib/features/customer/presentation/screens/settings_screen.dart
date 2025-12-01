import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';

/// شاشة الإعدادات
class SettingsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const SettingsScreen({super.key, required this.themeProvider});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // TODO: جلب القيمة من التخزين
  String _selectedLanguage = 'ar'; // TODO: جلب القيمة من التخزين

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // قسم المظهر
          _buildSectionTitle('المظهر'),
          _buildThemeCard(isDark),
          const SizedBox(height: 24),

          // قسم اللغة
          _buildSectionTitle('اللغة'),
          _buildLanguageCard(),
          const SizedBox(height: 24),

          // قسم الإشعارات
          _buildSectionTitle('الإشعارات'),
          _buildNotificationsCard(),
          const SizedBox(height: 24),

          // قسم الحساب
          _buildSectionTitle('الحساب'),
          _buildAccountCard(context),
          const SizedBox(height: 24),

          // قسم حول التطبيق
          _buildSectionTitle('حول التطبيق'),
          _buildAboutCard(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: MbuyColors.primaryPurple,
        ),
      ),
    );
  }

  Widget _buildThemeCard(bool isDark) {
    return Card(
      child: RadioTheme(
        data: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return MbuyColors.primaryPurple;
            }
            return null;
          }),
        ),
        child: Column(
          children: [
            RadioListTile<ThemeMode>(
              title: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: widget.themeProvider.isLightMode
                        ? MbuyColors.primaryPurple
                        : null,
                  ),
                  const SizedBox(width: 12),
                  const Text('فاتح'),
                ],
              ),
              value: ThemeMode.light,
              groupValue: widget.themeProvider.themeMode,
              toggleable: false,
              onChanged: (value) {
                if (value != null) {
                  widget.themeProvider.setThemeMode(value);
                }
              },
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              title: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: widget.themeProvider.isDarkMode
                        ? MbuyColors.primaryPurple
                        : null,
                  ),
                  const SizedBox(width: 12),
                  const Text('داكن'),
                ],
              ),
              value: ThemeMode.dark,
              groupValue: widget.themeProvider.themeMode,
              toggleable: false,
              onChanged: (value) {
                if (value != null) {
                  widget.themeProvider.setThemeMode(value);
                }
              },
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              title: Row(
                children: [
                  Icon(
                    Icons.brightness_auto,
                    color: widget.themeProvider.isSystemMode
                        ? MbuyColors.primaryPurple
                        : null,
                  ),
                  const SizedBox(width: 12),
                  const Text('تلقائي (حسب النظام)'),
                ],
              ),
              value: ThemeMode.system,
              groupValue: widget.themeProvider.themeMode,
              toggleable: false,
              onChanged: (value) {
                if (value != null) {
                  widget.themeProvider.setThemeMode(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard() {
    return Card(
      child: RadioTheme(
        data: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return MbuyColors.primaryPurple;
            }
            return null;
          }),
        ),
        child: Column(
          children: [
            RadioListTile<String>(
              title: const Text('الإنجليزية'),
              subtitle: const Text('English'),
              value: 'en',
              groupValue: _selectedLanguage,
              toggleable: false,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                // TODO: تطبيق تغيير اللغة
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('سيتم تطبيق اللغة قريباً'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            RadioListTile<String>(
              title: const Text('الإنجليزية'),
              subtitle: const Text('English'),
              value: 'en',
              groupValue: _selectedLanguage,
              toggleable: false,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                // TODO: تطبيق تغيير اللغة
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language will be applied soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('الإشعارات'),
            subtitle: const Text('تلقي إشعارات حول الطلبات والعروض'),
            secondary: const Icon(Icons.notifications),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: حفظ الإعداد وتطبيقه
            },
            activeTrackColor: MbuyColors.primaryPurple.withValues(alpha: 0.5),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return MbuyColors.primaryPurple;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              // سيتم فتح صفحة Profile الموجودة
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('تغيير كلمة المرور'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: فتح صفحة تغيير كلمة المرور
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('الخصوصية والأمان'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: فتح صفحة الخصوصية
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('عن التطبيق'),
            subtitle: const Text('mBuy v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'mBuy',
                applicationVersion: '1.0.0',
                applicationIcon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: MbuyColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                children: [
                  const Text(
                    'منصة تسوق وإدارة متاجر شاملة',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('الشروط والأحكام'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: فتح صفحة الشروط
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('المساعدة والدعم'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: فتح صفحة المساعدة
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
              );
            },
          ),
        ],
      ),
    );
  }
}
