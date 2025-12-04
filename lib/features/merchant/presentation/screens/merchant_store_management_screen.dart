import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'merchant_store_setup_screen.dart';
import 'merchant_products_screen.dart';
import 'merchant_orders_screen.dart';

/// صفحة إدارة المتجر الكاملة
class MerchantStoreManagementScreen extends StatelessWidget {
  const MerchantStoreManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MbuyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'إدارة المتجر',
          style: GoogleFonts.cairo(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MbuyColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Link Section
            _buildStoreLinkSection(context),
            
            // Quick Actions Grid
            _buildQuickActionsGrid(context),
            
            // Store Management Options
            _buildStoreManagementOptions(context),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreLinkSection(BuildContext context) {
    const storeLink = 'tabayu.com/Muath-Buy';
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MbuyColors.borderLight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MbuyColors.primaryIndigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.store,
                  color: MbuyColors.primaryIndigo,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رابط المتجر',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      storeLink,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLinkActionButton(
                  icon: Icons.qr_code,
                  label: 'QR Code',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم إضافة QR Code قريباً')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLinkActionButton(
                  icon: Icons.copy,
                  label: 'نسخ',
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: storeLink));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الرابط')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLinkActionButton(
                  icon: Icons.share,
                  label: 'مشاركة',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم إضافة المشاركة قريباً')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: MbuyColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MbuyColors.borderLight, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: MbuyColors.textPrimary, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MbuyColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إجراءات سريعة',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
            children: [
              _buildSquareMenuOption(
                icon: Icons.store,
                title: 'عرض المتجر',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MerchantStoreSetupScreen(),
                    ),
                  );
                },
              ),
              _buildSquareMenuOption(
                icon: Icons.settings,
                title: 'إدارة المتجر',
                color: Colors.grey,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MerchantStoreSetupScreen(),
                    ),
                  );
                },
              ),
              _buildSquareMenuOption(
                icon: Icons.palette,
                title: 'مظهر المتجر',
                color: Colors.purple,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('سيتم إضافة مظهر المتجر قريباً')),
                  );
                },
              ),
              _buildSquareMenuOption(
                icon: Icons.edit,
                title: 'تحرير المتجر',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MerchantStoreSetupScreen(),
                    ),
                  );
                },
              ),
              _buildSquareMenuOption(
                icon: Icons.person,
                title: 'تعديل معلومات الحساب',
                color: Colors.teal,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('سيتم إضافة تعديل معلومات الحساب قريباً')),
                  );
                },
              ),
              _buildSquareMenuOption(
                icon: Icons.lock,
                title: 'تغيير كلمة المرور',
                color: Colors.indigo,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('سيتم إضافة تغيير كلمة المرور قريباً')),
                  );
                },
              ),
              _buildSquareMenuOption(
                icon: Icons.delete_outline,
                title: 'حذف المتجر',
                color: Colors.red,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('سيتم إضافة حذف المتجر قريباً')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSquareMenuOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: MbuyColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreManagementOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إدارة المتجر',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildOptionTile(
            icon: Icons.inventory_2_outlined,
            title: 'المنتجات',
            subtitle: 'إدارة منتجات المتجر',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantProductsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildOptionTile(
            icon: Icons.receipt_long_outlined,
            title: 'الطلبات',
            subtitle: 'عرض ومتابعة الطلبات',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantOrdersScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildOptionTile(
            icon: Icons.settings_outlined,
            title: 'إعدادات المتجر',
            subtitle: 'تعديل معلومات المتجر',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantStoreSetupScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MbuyColors.borderLight, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: MbuyColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

