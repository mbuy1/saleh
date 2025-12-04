import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../shared/widgets/skeleton/skeleton_loader.dart';
import 'change_password_screen.dart';
import 'privacy_security_screen.dart';
import 'terms_screen.dart';
import 'help_support_screen.dart';

/// شاشة الإعدادات
class SettingsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const SettingsScreen({super.key, required this.themeProvider});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'ar';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// تحميل الإعدادات المحفوظة
  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final savedLanguage = PreferencesService.getLanguage();
      if (savedLanguage != null) {
        _selectedLanguage = savedLanguage;
      }

      _notificationsEnabled = PreferencesService.getNotificationsEnabled();
    } catch (e) {
      debugPrint('⚠️ خطأ في تحميل الإعدادات: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : ListView(
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
        child: RadioGroup<ThemeMode>(
          groupValue: widget.themeProvider.themeMode,
          onChanged: (value) {
            if (value != null) {
              widget.themeProvider.setThemeMode(value);
            }
          },
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
                toggleable: false,
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
                toggleable: false,
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
                toggleable: false,
              ),
            ],
          ),
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
        child: RadioGroup<String>(
          groupValue: _selectedLanguage,
          onChanged: (value) async {
            if (value != null) {
              setState(() {
                _selectedLanguage = value;
              });
              
              // حفظ اللغة
              try {
                await PreferencesService.saveLanguage(value);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value == 'ar'
                            ? 'تم حفظ اللغة. سيتم تطبيقها بعد إعادة تشغيل التطبيق'
                            : 'Language saved. Will be applied after app restart',
                      ),
                      duration: const Duration(seconds: 3),
                      backgroundColor: MbuyColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ في حفظ اللغة: $e'),
                      backgroundColor: MbuyColors.error,
                    ),
                  );
                }
              }
            }
          },
          child: Column(
            children: [
              RadioListTile<String>(
                title: const Text('العربية'),
                subtitle: const Text('Arabic'),
                value: 'ar',
                toggleable: false,
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text('الإنجليزية'),
                subtitle: const Text('English'),
                value: 'en',
                toggleable: false,
              ),
            ],
          ),
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
            onChanged: (value) async {
              setState(() {
                _notificationsEnabled = value;
              });
              
              // حفظ الإعداد
              try {
                await PreferencesService.saveNotificationsEnabled(value);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? 'تم تفعيل الإشعارات'
                            : 'تم إيقاف الإشعارات',
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: MbuyColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ في حفظ الإعداد: $e'),
                      backgroundColor: MbuyColors.error,
                    ),
                  );
                }
              }
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('الخصوصية والأمان'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacySecurityScreen(),
                ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('المساعدة والدعم'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SkeletonLoader(width: 120, height: 20),
        const SizedBox(height: 16),
        ...List.generate(4, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SkeletonListItem(),
        )),
      ],
    );
  }
}
