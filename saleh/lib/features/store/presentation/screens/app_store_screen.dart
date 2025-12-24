import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// نموذج بيانات التطبيق
class AppModel {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isInstalled;
  final bool isPro;
  final bool isNew;
  final bool isFeatured;

  AppModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isInstalled = false,
    this.isPro = false,
    this.isNew = false,
    this.isFeatured = false,
  });
}

/// صفحة متجر التطبيقات - App Store Screen
class AppStoreScreen extends ConsumerStatefulWidget {
  const AppStoreScreen({super.key});

  @override
  ConsumerState<AppStoreScreen> createState() => _AppStoreScreenState();
}

class _AppStoreScreenState extends ConsumerState<AppStoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  int _currentFeaturedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.9);

  final List<String> _categories = [
    'الكل',
    'الدفع',
    'الشحن',
    'التسويق',
    'التحليلات',
    'التواصل',
    'المخزون',
  ];

  // بيانات تجريبية للتطبيقات المميزة
  final List<AppModel> _featuredApps = [
    AppModel(
      id: '1',
      name: 'بوابة الدفع المتقدمة',
      description: 'نظام دفع متكامل يدعم جميع طرق الدفع المحلية والعالمية',
      iconUrl: '',
      category: 'الدفع',
      rating: 4.9,
      reviewCount: 2340,
      isFeatured: true,
      isPro: true,
    ),
    AppModel(
      id: '2',
      name: 'تتبع الشحنات الذكي',
      description: 'تتبع شحناتك في الوقت الحقيقي مع إشعارات فورية',
      iconUrl: '',
      category: 'الشحن',
      rating: 4.7,
      reviewCount: 1850,
      isFeatured: true,
    ),
    AppModel(
      id: '3',
      name: 'مساعد التسويق بالذكاء الاصطناعي',
      description: 'أتمتة حملاتك التسويقية باستخدام الذكاء الاصطناعي',
      iconUrl: '',
      category: 'التسويق',
      rating: 4.8,
      reviewCount: 980,
      isFeatured: true,
      isNew: true,
    ),
  ];

  // بيانات تجريبية للتطبيقات الشائعة
  final List<AppModel> _popularApps = [
    AppModel(
      id: '4',
      name: 'محلل المبيعات',
      description: 'تحليلات متقدمة لأداء مبيعاتك',
      iconUrl: '',
      category: 'التحليلات',
      rating: 4.6,
      reviewCount: 3200,
      isInstalled: true,
    ),
    AppModel(
      id: '5',
      name: 'مدير المخزون الذكي',
      description: 'إدارة مخزونك بكفاءة عالية',
      iconUrl: '',
      category: 'المخزون',
      rating: 4.5,
      reviewCount: 2100,
    ),
    AppModel(
      id: '6',
      name: 'روبوت المحادثة',
      description: 'رد آلي على استفسارات العملاء',
      iconUrl: '',
      category: 'التواصل',
      rating: 4.4,
      reviewCount: 1560,
      isPro: true,
    ),
  ];

  // بيانات تجريبية للتطبيقات الجديدة
  final List<AppModel> _newApps = [
    AppModel(
      id: '7',
      name: 'كوبونات الخصم',
      description: 'إنشاء وإدارة كوبونات الخصم',
      iconUrl: '',
      category: 'التسويق',
      rating: 4.3,
      reviewCount: 450,
      isNew: true,
    ),
    AppModel(
      id: '8',
      name: 'تقييمات العملاء',
      description: 'جمع وعرض تقييمات العملاء',
      iconUrl: '',
      category: 'التواصل',
      rating: 4.2,
      reviewCount: 320,
      isNew: true,
    ),
    AppModel(
      id: '9',
      name: 'الفواتير الإلكترونية',
      description: 'إنشاء فواتير احترافية',
      iconUrl: '',
      category: 'الدفع',
      rating: 4.1,
      reviewCount: 280,
      isNew: true,
    ),
    AppModel(
      id: '10',
      name: 'تحليل المنافسين',
      description: 'راقب أداء منافسيك في السوق',
      iconUrl: '',
      category: 'التحليلات',
      rating: 4.0,
      reviewCount: 150,
      isNew: true,
      isPro: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColorDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // الهيدر
            SliverToBoxAdapter(child: _buildHeader()),
            // شريط البحث
            SliverToBoxAdapter(child: _buildSearchBar()),
            // التطبيقات المميزة (كاروسيل)
            SliverToBoxAdapter(child: _buildFeaturedSection()),
            // التصنيفات
            SliverToBoxAdapter(child: _buildCategoriesSection()),
            // التطبيقات الشائعة
            SliverToBoxAdapter(child: _buildPopularAppsSection()),
            // وصلنا حديثاً
            SliverToBoxAdapter(child: _buildNewArrivalsSection()),
            // التطبيقات الموصى بها
            SliverToBoxAdapter(child: _buildRecommendedSection()),
            // مسافة سفلية
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // زر الرجوع
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColorDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColorDark, width: 1),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textPrimaryColorDark,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // العنوان
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'متجر التطبيقات',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColorDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'اكتشف التطبيقات التي تعزز متجرك',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColorDark,
                  ),
                ),
              ],
            ),
          ),
          // زر التطبيقات المثبتة
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: الانتقال لصفحة التطبيقات المثبتة
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.apps, color: AppTheme.primaryColor, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'المثبتة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColorDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColorDark, width: 1),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(
            color: AppTheme.textPrimaryColorDark,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: 'ابحث عن تطبيقات...',
            hintStyle: TextStyle(
              color: AppTheme.textHintColorDark,
              fontSize: 15,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppTheme.textHintColorDark,
              size: 22,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppTheme.textHintColorDark,
                      size: 20,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (value) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: AppTheme.ratingStarColor,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'تطبيقات مميزة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColorDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: عرض الكل
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        // كاروسيل التطبيقات المميزة
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _featuredApps.length,
            onPageChanged: (index) {
              setState(() {
                _currentFeaturedIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildFeaturedCard(_featuredApps[index]);
            },
          ),
        ),
        // مؤشرات الصفحات
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _featuredApps.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentFeaturedIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentFeaturedIndex == index
                    ? AppTheme.primaryColor
                    : AppTheme.borderColorDark,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(AppModel app) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.2),
            AppTheme.cardColorDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: الانتقال لتفاصيل التطبيق
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // أيقونة التطبيق
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.apps,
                        color: AppTheme.primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  app.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimaryColorDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (app.isPro) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.ratingStarColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'PRO',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.backgroundColorDark,
                                    ),
                                  ),
                                ),
                              ],
                              if (app.isNew) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'جديد',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.backgroundColorDark,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            app.category,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondaryColorDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  app.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColorDark,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // التقييم
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppTheme.ratingStarColor,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          app.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColorDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${app.reviewCount})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textHintColorDark,
                          ),
                        ),
                      ],
                    ),
                    // زر التثبيت
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'تثبيت',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.backgroundColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text(
            'التصنيفات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColorDark,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.surfaceColorDark,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.borderColorDark,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppTheme.backgroundColorDark
                            : AppTheme.textSecondaryColorDark,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularAppsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: AppTheme.accentColor,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'الأكثر شعبية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColorDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _popularApps.length,
          itemBuilder: (context, index) {
            return _buildAppListItem(_popularApps[index], index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildAppListItem(AppModel app, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColorDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColorDark, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: الانتقال لتفاصيل التطبيق
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // رقم الترتيب
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // أيقونة التطبيق
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColorDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(app.category),
                    color: AppTheme.primaryColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                // معلومات التطبيق
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              app.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColorDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (app.isPro) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.ratingStarColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRO',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.backgroundColorDark,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        app.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textHintColorDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppTheme.ratingStarColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            app.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColorDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${app.reviewCount})',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textHintColorDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColorDark,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              app.category,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.textSecondaryColorDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // زر التثبيت
                _buildInstallButton(app),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstallButton(AppModel app) {
    if (app.isInstalled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColorDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.borderColorDark, width: 1),
        ),
        child: const Text(
          'مثبت',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textHintColorDark,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'تثبيت',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppTheme.backgroundColorDark,
        ),
      ),
    );
  }

  Widget _buildNewArrivalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.new_releases_rounded,
                    color: AppTheme.primaryColor,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'وصلنا حديثاً',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColorDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        // شبكة التطبيقات الجديدة
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _newApps.length,
          itemBuilder: (context, index) {
            return _buildNewAppCard(_newApps[index]);
          },
        ),
      ],
    );
  }

  Widget _buildNewAppCard(AppModel app) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColorDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColorDark, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: الانتقال لتفاصيل التطبيق
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // أيقونة التطبيق
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(app.category),
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    // شارات
                    Row(
                      children: [
                        if (app.isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'جديد',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.backgroundColorDark,
                              ),
                            ),
                          ),
                        if (app.isPro) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.ratingStarColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.backgroundColorDark,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  app.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColorDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  app.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textHintColorDark,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // التقييم
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppTheme.ratingStarColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          app.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColorDark,
                          ),
                        ),
                      ],
                    ),
                    // زر التثبيت
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'تثبيت',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.backgroundColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    final recommendedApps = [..._popularApps, ..._newApps].take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.thumb_up_rounded,
                    color: Color(0xFF64B5F6),
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'موصى بها لك',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColorDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendedApps.length,
            itemBuilder: (context, index) {
              return _buildRecommendedCard(recommendedApps[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard(AppModel app) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardColorDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColorDark, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(app.category),
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColorDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            app.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textHintColorDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (app.isPro)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.ratingStarColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.backgroundColorDark,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  app.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColorDark,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppTheme.ratingStarColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          app.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColorDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(${app.reviewCount})',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textHintColorDark,
                          ),
                        ),
                      ],
                    ),
                    _buildInstallButton(app),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'الدفع':
        return Icons.payment_rounded;
      case 'الشحن':
        return Icons.local_shipping_rounded;
      case 'التسويق':
        return Icons.campaign_rounded;
      case 'التحليلات':
        return Icons.analytics_rounded;
      case 'التواصل':
        return Icons.chat_bubble_rounded;
      case 'المخزون':
        return Icons.inventory_2_rounded;
      default:
        return Icons.apps_rounded;
    }
  }
}
