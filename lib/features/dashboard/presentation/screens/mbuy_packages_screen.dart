import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة حزم التوفير - حزم شاملة تجمع أدوات AI والخدمات بأسعار مخفضة
class MbuyPackagesScreen extends ConsumerStatefulWidget {
  const MbuyPackagesScreen({super.key});

  @override
  ConsumerState<MbuyPackagesScreen> createState() => _MbuyPackagesScreenState();
}

class _MbuyPackagesScreenState extends ConsumerState<MbuyPackagesScreen> {
  bool _isLoading = false;
  String? _selectedPackage;
  List<PackageModel> _packages = [];

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    setState(() => _isLoading = true);

    // في المستقبل، سيتم جلب هذه من API
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _packages = [
        PackageModel(
          id: 'starter',
          name: 'باقة البداية',
          nameEn: 'Starter',
          price: 0,
          originalPrice: 0,
          description: 'ابدأ متجرك مجاناً',
          features: [
            'إنشاء متجر مجاني',
            '3 صور AI شهرياً',
            'دعم بالبريد الإلكتروني',
            'قوالب أساسية',
          ],
          color: AppTheme.slate600,
          iconPath: AppIcons.rocketLaunch,
          isFree: true,
        ),
        PackageModel(
          id: 'pro',
          name: 'باقة برو',
          nameEn: 'Pro',
          price: 49,
          originalPrice: 99,
          description: 'للتجار المحترفين',
          features: [
            'جميع مميزات البداية',
            '50 صورة AI شهرياً',
            '10 فيديوهات شهرياً',
            'دعم أولوية 24/7',
            'تحليلات متقدمة',
            'إزالة العلامة المائية',
            'قوالب احترافية',
          ],
          color: AppTheme.primaryColor,
          iconPath: AppIcons.workspacePremium,
          isPopular: true,
          discount: 50,
        ),
        PackageModel(
          id: 'business',
          name: 'باقة الأعمال',
          nameEn: 'Business',
          price: 99,
          originalPrice: 199,
          description: 'للمتاجر الكبيرة',
          features: [
            'جميع مميزات برو',
            'صور AI غير محدودة',
            '50 فيديو شهرياً',
            'مدير حساب مخصص',
            'API مخصص',
            'تدريب الفريق',
            'تقارير مخصصة',
            'أولوية في الدعم',
          ],
          color: AppTheme.accentColor,
          iconPath: AppIcons.businessCenter,
          discount: 50,
        ),
        PackageModel(
          id: 'enterprise',
          name: 'باقة المؤسسات',
          nameEn: 'Enterprise',
          price: -1, // اتصل بنا
          originalPrice: -1,
          description: 'حلول مخصصة للشركات',
          features: [
            'كل شيء غير محدود',
            'حلول مخصصة',
            'تكامل مع أنظمتك',
            'SLA مضمون',
            'خوادم مخصصة',
            'تدريب شامل',
            'دعم على مدار الساعة',
            'عقود سنوية مرنة',
          ],
          color: AppTheme.successColor,
          iconPath: AppIcons.apartment,
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _subscribeToPackage(PackageModel package) async {
    if (package.isFree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أنت مشترك بالفعل في الباقة المجانية!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      return;
    }

    if (package.price == -1) {
      // اتصل بنا
      _showContactDialog();
      return;
    }

    // إظهار dialog للاشتراك
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الاشتراك في ${package.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('السعر: ${package.price} ر.س/شهر'),
            if (package.discount != null)
              Text(
                'وفر ${package.discount}%',
                style: const TextStyle(color: AppTheme.successColor),
              ),
            const SizedBox(height: 16),
            const Text('هل تريد المتابعة؟'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('اشترك الآن'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);

      try {
        // محاكاة عملية الدفع
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          setState(() {
            _selectedPackage = package.id;
            _isLoading = false;
          });

          // عرض رسالة نجاح
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              icon: SvgPicture.asset(
                AppIcons.checkCircle,
                width: 64,
                height: 64,
                colorFilter: const ColorFilter.mode(
                  AppTheme.successColor,
                  BlendMode.srcIn,
                ),
              ),
              title: const Text('تم الاشتراك بنجاح!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('مبروك! تم تفعيل ${package.name}'),
                  const SizedBox(height: 8),
                  const Text(
                    'يمكنك الآن الاستمتاع بجميع المميزات',
                    style: TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pop(); // العودة للشاشة السابقة
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('ابدأ الآن'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في الدفع: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تواصل معنا'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('للحصول على عرض مخصص لمؤسستك:'),
            const SizedBox(height: 16),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.email,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppTheme.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('enterprise@mbuy.app'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.phone,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppTheme.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('+966 50 123 4567'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'حزم التوفير',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 24),
                  // Packages Grid
                  _buildPackagesGrid(),
                  const SizedBox(height: 24),
                  // Features Comparison
                  _buildFeaturesComparison(),
                  const SizedBox(height: 24),
                  // FAQ
                  _buildFAQ(),
                  const SizedBox(height: 80), // Space for bottom nav
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.headerBannerGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppIcons.localOffer,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'خصم 50%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'اختر الباقة المناسبة لك',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'وفر أكثر مع حزم التوفير الشاملة',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: _packages.length,
      itemBuilder: (context, index) => _buildPackageCard(_packages[index]),
    );
  }

  Widget _buildPackageCard(PackageModel package) {
    final isSelected = _selectedPackage == package.id;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPackage = package.id);
        _subscribeToPackage(package);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? package.color.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? package.color : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: package.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      package.iconPath,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        package.color,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Name
                  Text(
                    package.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    package.description,
                    style: TextStyle(color: AppTheme.slate600, fontSize: 12),
                  ),
                  const Spacer(),
                  // Price
                  if (package.isFree)
                    const Text(
                      'مجاناً',
                      style: TextStyle(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  else if (package.price == -1)
                    const Text(
                      'اتصل بنا',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (package.originalPrice > package.price)
                          Text(
                            '${package.originalPrice} ر.س',
                            style: TextStyle(
                              color: AppTheme.slate600,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                        Row(
                          children: [
                            Text(
                              '${package.price}',
                              style: TextStyle(
                                color: package.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const Text(
                              ' ر.س/شهر',
                              style: TextStyle(
                                color: AppTheme.slate600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _subscribeToPackage(package),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: package.isFree
                            ? AppTheme.slate600
                            : package.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        package.isFree
                            ? 'الباقة الحالية'
                            : package.price == -1
                            ? 'تواصل معنا'
                            : 'اشترك',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Popular Badge
            if (package.isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'الأكثر طلباً',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Discount Badge
            if (package.discount != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-${package.discount}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesComparison() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ماذا تحتوي الحزم؟',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildFeatureRow('إنشاء متجر', ['✓', '✓', '✓', '✓']),
          _buildFeatureRow('صور AI شهرياً', ['3', '50', '∞', '∞']),
          _buildFeatureRow('فيديوهات شهرياً', ['-', '10', '50', '∞']),
          _buildFeatureRow('تحليلات', ['أساسية', 'متقدمة', 'شاملة', 'مخصصة']),
          _buildFeatureRow('دعم', ['بريد', '24/7', 'مدير خاص', 'فريق خاص']),
          _buildFeatureRow('API', ['-', '-', '✓', 'مخصص']),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          ...values.map(
            (value) => Expanded(
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: value == '-'
                        ? AppTheme.slate600
                        : value == '✓'
                        ? AppTheme.successColor
                        : AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أسئلة شائعة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'هل يمكنني تغيير الباقة لاحقاً؟',
            'نعم، يمكنك الترقية أو تغيير الباقة في أي وقت.',
          ),
          _buildFAQItem(
            'هل هناك التزام بمدة معينة؟',
            'لا، جميع الباقات شهرية ويمكنك إلغاء الاشتراك في أي وقت.',
          ),
          _buildFAQItem(
            'ماذا يحدث إذا استهلكت حصتي الشهرية؟',
            'يمكنك شراء رصيد إضافي أو الترقية لباقة أعلى.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(color: AppTheme.slate600, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

/// نموذج بيانات الحزمة
class PackageModel {
  final String id;
  final String name;
  final String nameEn;
  final int price;
  final int originalPrice;
  final String description;
  final List<String> features;
  final Color color;
  final String iconPath;
  final bool isFree;
  final bool isPopular;
  final int? discount;

  PackageModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.features,
    required this.color,
    required this.iconPath,
    this.isFree = false,
    this.isPopular = false,
    this.discount,
  });
}
