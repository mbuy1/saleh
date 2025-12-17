import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_dimensions.dart';
import 'app_icon.dart';

/// مندوب البحث العام للتطبيق
/// يوفر بحثاً سريعاً في جميع ميزات التطبيق
class AppSearchDelegate extends SearchDelegate<String?> {
  AppSearchDelegate()
    : super(
        searchFieldLabel: 'ابحث في التطبيق...',
        searchFieldStyle: const TextStyle(
          fontSize: 16,
          color: AppTheme.textPrimaryColor,
        ),
      );

  // قائمة جميع الميزات القابلة للبحث
  static final List<SearchItem> _allItems = [
    // التنقل الأساسي
    SearchItem(
      title: 'الرئيسية',
      subtitle: 'الصفحة الرئيسية للوحة التحكم',
      icon: AppIcons.home,
      route: '/dashboard',
      category: 'التنقل',
      keywords: ['home', 'رئيسية', 'لوحة', 'dashboard'],
    ),
    SearchItem(
      title: 'الطلبات',
      subtitle: 'إدارة طلبات المتجر',
      icon: AppIcons.orders,
      route: '/dashboard/orders',
      category: 'التنقل',
      keywords: ['orders', 'طلبات', 'مبيعات'],
    ),
    SearchItem(
      title: 'المنتجات',
      subtitle: 'إدارة منتجات المتجر',
      icon: AppIcons.product,
      route: '/dashboard/products',
      category: 'التنقل',
      keywords: ['products', 'منتجات', 'سلع'],
    ),
    SearchItem(
      title: 'المحادثات',
      subtitle: 'محادثات العملاء',
      icon: AppIcons.chat,
      route: '/dashboard/conversations',
      category: 'التنقل',
      keywords: ['chat', 'محادثات', 'رسائل', 'عملاء'],
    ),

    // التسويق
    SearchItem(
      title: 'التسويق',
      subtitle: 'أدوات التسويق والترويج',
      icon: AppIcons.megaphone,
      route: '/dashboard/marketing',
      category: 'التسويق',
      keywords: ['marketing', 'تسويق', 'ترويج'],
    ),
    SearchItem(
      title: 'الكوبونات',
      subtitle: 'إنشاء وإدارة كوبونات الخصم',
      icon: AppIcons.discount,
      route: '/dashboard/coupons',
      category: 'التسويق',
      keywords: ['coupons', 'كوبونات', 'خصم', 'عروض'],
    ),
    SearchItem(
      title: 'العروض الخاطفة',
      subtitle: 'عروض محدودة الوقت',
      icon: AppIcons.flash,
      route: '/dashboard/flash-sales',
      category: 'التسويق',
      keywords: ['flash', 'عروض', 'خاطفة', 'تخفيضات'],
    ),
    SearchItem(
      title: 'السلات المتروكة',
      subtitle: 'استرداد العملاء المترددين',
      icon: AppIcons.cart,
      route: '/dashboard/abandoned-cart',
      category: 'التسويق',
      keywords: ['cart', 'سلة', 'متروكة', 'abandoned'],
    ),
    SearchItem(
      title: 'برنامج الإحالة',
      subtitle: 'مكافآت إحالة الأصدقاء',
      icon: AppIcons.share,
      route: '/dashboard/referral',
      category: 'التسويق',
      keywords: ['referral', 'إحالة', 'أصدقاء', 'مكافآت'],
    ),
    SearchItem(
      title: 'برنامج الولاء',
      subtitle: 'نقاط ومكافآت العملاء',
      icon: AppIcons.loyalty,
      route: '/dashboard/loyalty-program',
      category: 'التسويق',
      keywords: ['loyalty', 'ولاء', 'نقاط', 'مكافآت'],
    ),
    SearchItem(
      title: 'شرائح العملاء',
      subtitle: 'تقسيم العملاء لمجموعات',
      icon: AppIcons.users,
      route: '/dashboard/customer-segments',
      category: 'التسويق',
      keywords: ['segments', 'شرائح', 'عملاء', 'تقسيم'],
    ),
    SearchItem(
      title: 'رسائل مخصصة',
      subtitle: 'إرسال رسائل للعملاء',
      icon: AppIcons.chat,
      route: '/dashboard/custom-messages',
      category: 'التسويق',
      keywords: ['messages', 'رسائل', 'مخصصة', 'إشعارات'],
    ),
    SearchItem(
      title: 'التسعير الذكي',
      subtitle: 'تسعير ديناميكي للمنتجات',
      icon: AppIcons.dollar,
      route: '/dashboard/smart-pricing',
      category: 'التسويق',
      keywords: ['pricing', 'تسعير', 'ذكي', 'أسعار'],
    ),

    // الإحصائيات
    SearchItem(
      title: 'المحفظة',
      subtitle: 'رصيد وتحويلات المحفظة',
      icon: AppIcons.wallet,
      route: '/dashboard/wallet',
      category: 'الإحصائيات',
      keywords: ['wallet', 'محفظة', 'رصيد', 'تحويل'],
    ),
    SearchItem(
      title: 'النقاط',
      subtitle: 'نقاط المكافآت',
      icon: AppIcons.points,
      route: '/dashboard/points',
      category: 'الإحصائيات',
      keywords: ['points', 'نقاط', 'مكافآت'],
    ),
    SearchItem(
      title: 'المبيعات',
      subtitle: 'تقارير المبيعات',
      icon: AppIcons.chart,
      route: '/dashboard/sales',
      category: 'الإحصائيات',
      keywords: ['sales', 'مبيعات', 'إيرادات', 'أرباح'],
    ),
    SearchItem(
      title: 'العملاء',
      subtitle: 'قائمة العملاء',
      icon: AppIcons.people,
      route: '/dashboard/customers',
      category: 'الإحصائيات',
      keywords: ['customers', 'عملاء', 'مشترين'],
    ),
    SearchItem(
      title: 'التقارير',
      subtitle: 'تقارير شاملة',
      icon: AppIcons.assessment,
      route: '/dashboard/reports',
      category: 'الإحصائيات',
      keywords: ['reports', 'تقارير', 'إحصائيات'],
    ),

    // الأدوات
    SearchItem(
      title: 'اختصاراتي',
      subtitle: 'الاختصارات المفضلة',
      icon: AppIcons.shortcuts,
      route: '/dashboard/shortcuts',
      category: 'الأدوات',
      keywords: ['shortcuts', 'اختصارات', 'مفضلة', 'سريع'],
    ),
    SearchItem(
      title: 'أدوات AI',
      subtitle: 'استوديو الذكاء الاصطناعي',
      icon: AppIcons.bot,
      route: '/dashboard/studio',
      category: 'الأدوات',
      keywords: ['ai', 'studio', 'ذكاء', 'اصطناعي'],
    ),
    SearchItem(
      title: 'أدوات Mbuy',
      subtitle: 'أدوات متقدمة',
      icon: AppIcons.tools,
      route: '/dashboard/tools',
      category: 'الأدوات',
      keywords: ['tools', 'أدوات', 'متقدمة'],
    ),
    SearchItem(
      title: 'المخزون',
      subtitle: 'إدارة المخزون',
      icon: AppIcons.inventory,
      route: '/dashboard/inventory',
      category: 'الأدوات',
      keywords: ['inventory', 'مخزون', 'كميات'],
    ),
    SearchItem(
      title: 'الإشعارات',
      subtitle: 'إشعارات التطبيق',
      icon: AppIcons.notifications,
      route: '/dashboard/notifications',
      category: 'الأدوات',
      keywords: ['notifications', 'إشعارات', 'تنبيهات'],
    ),

    // الدروب شيبنج
    SearchItem(
      title: 'دروب شيبنج',
      subtitle: 'إدارة الدروب شيبنج',
      icon: AppIcons.shipping,
      route: '/dashboard/dropshipping',
      category: 'الدروب شيبنج',
      keywords: ['dropshipping', 'دروب', 'شيبنج', 'موردين'],
    ),
    SearchItem(
      title: 'طلبات الموردين',
      subtitle: 'طلبات من الموردين',
      icon: AppIcons.orders,
      route: '/dashboard/supplier-orders',
      category: 'الدروب شيبنج',
      keywords: ['supplier', 'موردين', 'طلبات'],
    ),

    // المتجر
    SearchItem(
      title: 'عرض متجري',
      subtitle: 'معاينة المتجر',
      icon: AppIcons.eye,
      route: '/dashboard/view-store',
      category: 'المتجر',
      keywords: ['store', 'متجر', 'معاينة', 'عرض'],
    ),
    SearchItem(
      title: 'حزم التوفير',
      subtitle: 'باقات وحزم الاشتراك',
      icon: AppIcons.package,
      route: '/dashboard/packages',
      category: 'المتجر',
      keywords: ['packages', 'حزم', 'باقات', 'اشتراك'],
    ),
    SearchItem(
      title: 'متجرك الإلكتروني',
      subtitle: 'تصميم وتخصيص المتجر',
      icon: AppIcons.storeLocation,
      route: '/dashboard/webstore',
      category: 'المتجر',
      keywords: ['webstore', 'متجر', 'تصميم', 'ثيم'],
    ),

    // الإجراءات
    SearchItem(
      title: 'إضافة منتج',
      subtitle: 'إضافة منتج جديد',
      icon: AppIcons.add,
      route: '/dashboard/products/add',
      category: 'الإجراءات',
      keywords: ['add', 'إضافة', 'منتج', 'جديد'],
    ),
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.primaryColor),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: AppIcon(AppIcons.close, color: Colors.grey),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AppIcon(AppIcons.arrowBack, color: AppTheme.primaryColor),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildRecentAndPopular(context);
    }
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = _searchItems(query);

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(AppIcons.search, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا توجد نتائج لـ "$query"',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'جرب كلمات بحث مختلفة',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    // تجميع النتائج حسب الفئة
    final groupedResults = <String, List<SearchItem>>{};
    for (final item in results) {
      groupedResults.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: groupedResults.length,
      itemBuilder: (context, index) {
        final category = groupedResults.keys.elementAt(index);
        final items = groupedResults[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ...items.map((item) => _buildSearchResultItem(context, item)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildRecentAndPopular(BuildContext context) {
    final popularItems = _allItems.take(8).toList();

    return ListView(
      padding: AppDimensions.paddingM,
      children: [
        // العناصر الشائعة
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              AppIcon(
                AppIcons.trendingUp,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                'الأكثر استخداماً',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularItems
              .map((item) => _buildQuickChip(context, item))
              .toList(),
        ),
        const SizedBox(height: 24),

        // جميع الفئات
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              AppIcon(AppIcons.grid, size: 18, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'تصفح حسب الفئة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        ..._buildCategoryList(context),
      ],
    );
  }

  List<Widget> _buildCategoryList(BuildContext context) {
    final categories = <String>{};
    for (final item in _allItems) {
      categories.add(item.category);
    }

    return categories.map((category) {
      final categoryItems = _allItems
          .where((i) => i.category == category)
          .toList();
      return ExpansionTile(
        title: Text(
          category,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        children: categoryItems
            .map((item) => _buildSearchResultItem(context, item))
            .toList(),
      );
    }).toList();
  }

  Widget _buildQuickChip(BuildContext context, SearchItem item) {
    return ActionChip(
      avatar: AppIcon(item.icon, size: 16, color: AppTheme.primaryColor),
      label: Text(item.title, style: const TextStyle(fontSize: 12)),
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
      onPressed: () {
        HapticFeedback.lightImpact();
        close(context, item.route);
        context.push(item.route);
      },
    );
  }

  Widget _buildSearchResultItem(BuildContext context, SearchItem item) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AppIcon(item.icon, size: 20, color: AppTheme.primaryColor),
        ),
      ),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        item.subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: AppIcon(AppIcons.chevronLeft, size: 16, color: Colors.grey),
      onTap: () {
        HapticFeedback.lightImpact();
        close(context, item.route);
        context.push(item.route);
      },
    );
  }

  List<SearchItem> _searchItems(String searchQuery) {
    final normalizedQuery = searchQuery.toLowerCase().trim();
    if (normalizedQuery.isEmpty) return [];

    return _allItems.where((item) {
      // البحث في العنوان
      if (item.title.toLowerCase().contains(normalizedQuery)) return true;
      // البحث في الوصف
      if (item.subtitle.toLowerCase().contains(normalizedQuery)) return true;
      // البحث في الكلمات المفتاحية
      for (final keyword in item.keywords) {
        if (keyword.toLowerCase().contains(normalizedQuery)) return true;
      }
      return false;
    }).toList();
  }
}

/// عنصر البحث
class SearchItem {
  final String title;
  final String subtitle;
  final String icon;
  final String route;
  final String category;
  final List<String> keywords;

  const SearchItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.category,
    this.keywords = const [],
  });
}
