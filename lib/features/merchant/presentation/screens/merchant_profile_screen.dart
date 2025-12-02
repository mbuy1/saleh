import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/supabase_client.dart';

/// شاشة الملف الشخصي للتاجر
class MerchantProfileScreen extends StatefulWidget {
  const MerchantProfileScreen({super.key});

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = supabaseClient.auth.currentUser;
      if (user != null) {
        final response = await supabaseClient
            .from('user_profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        setState(() {
          _userProfile = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: MbuyColors.primaryIndigo,
                          child: Text(
                            _userProfile?['display_name']?[0] ?? 'T',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _userProfile?['display_name'] ?? 'تاجر',
                          style: GoogleFonts.cairo(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: MbuyColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _userProfile?['email'] ?? '',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: MbuyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Menu Items
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('تعديل الملف الشخصي'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: فتح صفحة التعديل
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.store),
                        title: const Text('معلومات المتجر'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: فتح صفحة معلومات المتجر
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

