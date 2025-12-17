import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../merchant/data/merchant_store_provider.dart';

class BoostSalesScreen extends ConsumerWidget {
  const BoostSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeState = ref.watch(merchantStoreControllerProvider);
    final store = storeState.store;
    final storeName = store?.name ?? 'متجري';
    final storeSlug = storeName.replaceAll(' ', '-');
    final storeUrl = 'https://tabayu.com/$storeSlug';

    // التحقق من وجود متجر
    if (store == null && !storeState.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'ارفع مبيعاتك 🚀',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              AppIcons.arrowBack,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.black87,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.store,
                width: 64,
                height: 64,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'لا يوجد متجر',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'يرجى إنشاء متجر أولاً',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.push('/dashboard/store/create-store'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('إنشاء متجر'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ارفع مبيعاتك 🚀',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Colors.black87,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // 1. اسم المتجر
                    Text(
                      storeName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 2. زر عرض المتجر
                    OutlinedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(storeUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: SvgPicture.asset(
                        AppIcons.visibility,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          AppTheme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: const Text('عرض متجري'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // 3. المحتوى
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('تحويل المتجر من خاص إلى عام'),
                          const SizedBox(height: 8),
                          _buildSectionText(
                            'يعني أن متجرك سيصبح متاحاً للجميع، ويمكن لأي شخص زيارته والشراء منه مباشرة دون قيود.',
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle('لماذا ترفع مبيعاتك؟'),
                          const SizedBox(height: 8),
                          _buildSectionText(
                            'عند تفعيل هذه الميزة، ستتمكن من الوصول إلى شريحة أكبر من العملاء وزيادة فرص البيع بشكل ملحوظ.',
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle('كيف يساعدك Mbuy؟'),
                          const SizedBox(height: 12),
                          _buildFeaturePoint(
                            'زيادة الظهور في محركات البحث وداخل التطبيق',
                          ),
                          _buildFeaturePoint('جذب عملاء جدد مهتمين بمنتجاتك'),
                          _buildFeaturePoint(
                            'تحسين عرض المنتجات لتكون أكثر جاذبية',
                          ),
                          _buildFeaturePoint(
                            'استخدام أدوات التسويق المتقدمة بسهولة',
                          ),
                          _buildFeaturePoint(
                            'الاستفادة الكاملة من Mbuy Studio و Mbuy Tools',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 5. زر الإجراء الرئيسي
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _showBoostOptionsDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ابدأ برفع مبيعاتك',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
    );
  }

  Widget _buildFeaturePoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppIcons.checkCircle,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBoostOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'اختر طريقة رفع المبيعات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildBoostOption(
              context,
              icon: Icons.campaign,
              title: 'حملة إعلانية',
              subtitle: 'أنشئ حملة إعلانية لمنتجاتك',
              onTap: () {
                Navigator.pop(context);
                _showCampaignDialog(context);
              },
            ),
            const SizedBox(height: 12),
            _buildBoostOption(
              context,
              icon: Icons.local_offer,
              title: 'كوبون خصم',
              subtitle: 'أنشئ كوبون خصم لجذب العملاء',
              onTap: () {
                Navigator.pop(context);
                _showCouponDialog(context);
              },
            ),
            const SizedBox(height: 12),
            _buildBoostOption(
              context,
              icon: Icons.flash_on,
              title: 'عرض سريع',
              subtitle: 'خصم لفترة محدودة',
              onTap: () {
                Navigator.pop(context);
                _showFlashSaleDialog(context);
              },
            ),
            const SizedBox(height: 12),
            _buildBoostOption(
              context,
              icon: Icons.share,
              title: 'مشاركة على السوشيال',
              subtitle: 'شارك منتجاتك على وسائل التواصل',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري فتح خيارات المشاركة...')),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBoostOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showCampaignDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء حملة إعلانية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'اسم الحملة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'الميزانية (ر.س)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'مدة الحملة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [
                DropdownMenuItem(value: '7', child: Text('أسبوع')),
                DropdownMenuItem(value: '14', child: Text('أسبوعين')),
                DropdownMenuItem(value: '30', child: Text('شهر')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✨ تم إنشاء الحملة بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showCouponDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء كوبون خصم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'كود الكوبون',
                hintText: 'مثال: SALE20',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'نسبة الخصم %',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✨ تم إنشاء الكوبون بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showFlashSaleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء عرض سريع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'نسبة الخصم %',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'مدة العرض',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [
                DropdownMenuItem(value: '1', child: Text('ساعة واحدة')),
                DropdownMenuItem(value: '6', child: Text('6 ساعات')),
                DropdownMenuItem(value: '12', child: Text('12 ساعة')),
                DropdownMenuItem(value: '24', child: Text('24 ساعة')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('⚡ تم إنشاء العرض السريع'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }
}
