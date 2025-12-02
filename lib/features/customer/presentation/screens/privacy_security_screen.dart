import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة الخصوصية والأمان
class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = false;
  bool _locationTracking = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('الخصوصية والأمان'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('الأمان'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('المصادقة الثنائية'),
                  subtitle: const Text('حماية إضافية لحسابك'),
                  value: _twoFactorEnabled,
                  onChanged: (value) {
                    setState(() {
                      _twoFactorEnabled = value;
                    });
                    // TODO: حفظ الإعداد
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('المصادقة البيومترية'),
                  subtitle: const Text('استخدم البصمة أو Face ID'),
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                    // TODO: حفظ الإعداد
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('الخصوصية'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('تتبع الموقع'),
                  subtitle: const Text('لتحسين تجربة التسوق'),
                  value: _locationTracking,
                  onChanged: (value) {
                    setState(() {
                      _locationTracking = value;
                    });
                    // TODO: حفظ الإعداد
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('إدارة البيانات الشخصية'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: فتح صفحة إدارة البيانات
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('الحساب'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('حذف الحساب'),
                  trailing: const Icon(Icons.chevron_right, color: MbuyColors.error),
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: MbuyColors.textPrimary,
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text('هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // TODO: حذف الحساب
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة حذف الحساب قريباً')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: MbuyColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

