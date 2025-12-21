import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/studio_package.dart';
import '../providers/studio_provider.dart';
import '../services/studio_api_service.dart';

/// صفحة حزم التوفير - تصميم حديث
class PackagesPage extends ConsumerStatefulWidget {
  const PackagesPage({super.key});

  @override
  ConsumerState<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends ConsumerState<PackagesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final PageController _featuredController = PageController(
    viewportFraction: 0.88,
  );
  int _currentFeaturedIndex = 0;
  late List<PackageDefinition> _packages;
  int? _pressedCardIndex;

  @override
  void initState() {
    super.initState();
    _packages = getDefaultPackages();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // الهيدر الزجاجي
            SliverAppBar(
              pinned: true,
              expandedHeight: 0,
              backgroundColor: bgColor.withOpacity(0.85),
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.menu, size: 28),
                onPressed: () => HapticFeedback.lightImpact(),
              ),
              title: const Text(
                'الخدمات والمميزات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, size: 28),
                      onPressed: () => HapticFeedback.lightImpact(),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: bgColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // قسم جديد ومميز
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'جديد ومميز',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => HapticFeedback.lightImpact(),
                      child: const Text(
                        'عرض الكل',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // البطاقات المميزة (كاروسيل)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _featuredController,
                  onPageChanged: (index) {
                    setState(() => _currentFeaturedIndex = index);
                  },
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return _buildFeaturedCard(index: index, isDark: isDark);
                  },
                ),
              ),
            ),

            // نقاط المؤشر
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentFeaturedIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentFeaturedIndex == index
                            ? const Color(0xFF3B82F6)
                            : (isDark ? Colors.white24 : Colors.grey[300]),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // قسم اكتشف الخدمات
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  'اكتشف الخدمات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ),

            // شبكة الخدمات
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // الصف الأول - بطاقتين
                    Row(
                      children: [
                        Expanded(
                          child: _buildServiceCard(
                            icon: Icons.animation,
                            iconColor: const Color(0xFF3B82F6),
                            bgColor: isDark
                                ? const Color(0xFF3B82F6).withOpacity(0.1)
                                : const Color(0xFFEFF6FF),
                            title: 'موشن جرافيك',
                            description: 'تحريك شعارات ورسوم توضيحية احترافية.',
                            cardColor: cardColor,
                            isDark: isDark,
                            cardIndex: 0,
                            onTap: () => _openPackage(_packages[0]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildServiceCard(
                            icon: Icons.ads_click,
                            iconColor: const Color(0xFFF97316),
                            bgColor: isDark
                                ? const Color(0xFFF97316).withOpacity(0.1)
                                : const Color(0xFFFFF7ED),
                            title: 'إعلانات سوشال',
                            description:
                                'تصاميم جذابة لزيادة التفاعل والمبيعات.',
                            cardColor: cardColor,
                            isDark: isDark,
                            cardIndex: 1,
                            onTap: () => _openPackage(_packages[1]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // البطاقة المميزة الكبيرة
                    _buildFeaturedServiceCard(isDark: isDark),
                    const SizedBox(height: 16),

                    // الصف الثالث - بطاقتين
                    Row(
                      children: [
                        Expanded(
                          child: _buildServiceCard(
                            icon: Icons.video_camera_front,
                            iconColor: const Color(0xFFF43F5E),
                            bgColor: isDark
                                ? const Color(0xFFF43F5E).withOpacity(0.1)
                                : const Color(0xFFFFF1F2),
                            title: 'فلوقات',
                            description: 'مونتاج يومياتك بأسلوب سينمائي مميز.',
                            cardColor: cardColor,
                            isDark: isDark,
                            cardIndex: 2,
                            onTap: () => _openPackage(_packages[2]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildServiceCard(
                            icon: Icons.smartphone,
                            iconColor: const Color(0xFF10B981),
                            bgColor: isDark
                                ? const Color(0xFF10B981).withOpacity(0.1)
                                : const Color(0xFFECFDF5),
                            title: 'فيديو UGC',
                            description: 'محتوى عفوي من صناع محتوى حقيقيين.',
                            cardColor: cardColor,
                            isDark: isDark,
                            cardIndex: 3,
                            onTap: () => _openPackage(_packages[3]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // الصف الرابع - بطاقتين
                    Row(
                      children: [
                        Expanded(
                          child: _buildServiceCard(
                            icon: Icons.palette,
                            iconColor: const Color(0xFFEC4899),
                            bgColor: isDark
                                ? const Color(0xFFEC4899).withOpacity(0.1)
                                : const Color(0xFFFDF2F8),
                            title: 'هوية بصرية',
                            description:
                                'بناء هوية كاملة ومتميزة لعلامتك التجارية.',
                            cardColor: cardColor,
                            isDark: isDark,
                            cardIndex: 4,
                            onTap: () => _openPackage(_packages[4]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMoreServicesCard(
                            isDark: isDark,
                            cardColor: cardColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // مسافة سفلية
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard({required int index, required bool isDark}) {
    final isFirst = index == 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Semantics(
        label: isFirst ? 'حملات إعلانية متكاملة' : 'محرر الذكاء الاصطناعي',
        button: true,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            if (_packages.isNotEmpty) {
              _openPackage(_packages[index % _packages.length]);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: isFirst
                      ? const Color(0xFF3B82F6).withOpacity(0.15)
                      : const Color(0xFF8B5CF6).withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // الصورة الخلفية مع التخزين المؤقت
                  CachedNetworkImage(
                    imageUrl: isFirst
                        ? 'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=800'
                        : 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _buildShimmerPlaceholder(isDark),
                    errorWidget: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isFirst
                              ? [
                                  const Color(0xFF3B82F6),
                                  const Color(0xFF8B5CF6),
                                ]
                              : [
                                  const Color(0xFF8B5CF6),
                                  const Color(0xFFEC4899),
                                ],
                        ),
                      ),
                    ),
                  ),
                  // التدرج الداكن
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // المحتوى
                  Positioned(
                    bottom: 20,
                    right: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الشارة
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isFirst
                                ? const Color(0xFF3B82F6).withOpacity(0.9)
                                : const Color(0xFF8B5CF6).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isFirst
                                    ? Icons.trending_up
                                    : Icons.auto_awesome,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isFirst ? 'الأكثر طلباً' : 'جديد',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // العنوان
                        Text(
                          isFirst
                              ? 'حملات إعلانية متكاملة'
                              : 'محرر الذكاء الاصطناعي',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // الوصف
                        Text(
                          isFirst
                              ? 'حلول تسويقية شاملة لعلامتك التجارية من التخطيط إلى التنفيذ.'
                              : 'حول أفكارك ونصوصك إلى فيديو احترافي في ثوانٍ معدودة.',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
    required Color cardColor,
    required bool isDark,
    required VoidCallback onTap,
    int? cardIndex,
  }) {
    final isPressed = _pressedCardIndex == cardIndex;
    return Semantics(
      label: '$title: $description',
      button: true,
      child: GestureDetector(
        onTapDown: cardIndex != null
            ? (_) => setState(() => _pressedCardIndex = cardIndex)
            : null,
        onTapUp: cardIndex != null
            ? (_) => setState(() => _pressedCardIndex = null)
            : null,
        onTapCancel: cardIndex != null
            ? () => setState(() => _pressedCardIndex = null)
            : null,
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedScale(
          scale: isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.transparent,
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الأيقونة
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, size: 32, color: iconColor),
                ),
                const SizedBox(height: 16),
                // العنوان
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                // الوصف
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedServiceCard({required bool isDark}) {
    return Semantics(
      label: 'الخدمة المميزة: حملة إعلانية كاملة',
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (_packages.length > 2) {
            _openPackage(_packages[2]);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              // الدوائر الزخرفية
              Positioned(
                top: -60,
                right: -40,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -40,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              // المحتوى
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الشارة
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.rocket_launch,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'الخدمة المميزة',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[200],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // العنوان
                        const Text(
                          'حملة إعلانية كاملة',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // الوصف
                        Text(
                          'إدارة شاملة لحملتك من التخطيط إلى التنفيذ مع تقارير أداء دورية.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.indigo[100],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // زر السهم
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Transform.scale(
                      scaleX: -1,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreServicesCard({
    required bool isDark,
    required Color cardColor,
  }) {
    return Semantics(
      label: 'المزيد من الخدمات',
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          // TODO: الانتقال إلى صفحة جميع الخدمات
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                ),
                child: Icon(
                  Icons.add,
                  size: 28,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'المزيد من الخدمات',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shimmer placeholder للصور أثناء التحميل
  Widget _buildShimmerPlaceholder(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(color: isDark ? Colors.grey[800] : Colors.grey[300]),
    );
  }

  void _openPackage(PackageDefinition package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PackageDetailSheet(package: package),
    );
  }
}

/// صفحة تفاصيل الحزمة - تصميم محدث
class _PackageDetailSheet extends ConsumerStatefulWidget {
  final PackageDefinition package;

  const _PackageDetailSheet({required this.package});

  @override
  ConsumerState<_PackageDetailSheet> createState() =>
      _PackageDetailSheetState();
}

class _PackageDetailSheetState extends ConsumerState<_PackageDetailSheet> {
  bool _isOrdering = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final package = widget.package;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFF8FAFC);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF3B82F6).withOpacity(0.1),
                                const Color(0xFF8B5CF6).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            _getIconData(package.icon),
                            color: const Color(0xFF3B82F6),
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package.nameAr,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF3B82F6,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          size: 16,
                                          color: Color(0xFF3B82F6),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${package.creditsCost} رصيد',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3B82F6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${package.estimatedTimeMinutes} دقيقة',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Description
                    Text(
                      package.descriptionAr,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Deliverables
                    Text(
                      'ماذا ستحصل؟',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...package.deliverables.map(
                      (d) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getDeliverableIcon(d.type),
                                size: 24,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    d.descriptionAr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${d.quantity}x ${d.format.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Features
                    Text(
                      'المميزات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: package.featuresAr
                          .map(
                            (f) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.grey[200]!,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    f,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Action Button
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey[200]!,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: _isOrdering ? null : _orderPackage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: _isOrdering
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            ),
                      color: _isOrdering ? Colors.grey : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _isOrdering
                          ? null
                          : [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isOrdering)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        else ...[
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'طلب الحزمة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'movie_filter':
        return Icons.movie_filter;
      case 'person_play':
        return Icons.person;
      case 'campaign':
        return Icons.campaign;
      case 'video_camera_front':
        return Icons.video_camera_front;
      case 'share':
        return Icons.share;
      case 'palette':
        return Icons.palette;
      default:
        return Icons.auto_awesome;
    }
  }

  IconData _getDeliverableIcon(String type) {
    switch (type) {
      case 'video':
        return Icons.videocam;
      case 'image':
        return Icons.image;
      case 'logo':
        return Icons.star;
      case 'document':
        return Icons.description;
      case 'text':
        return Icons.text_fields;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _orderPackage() async {
    setState(() => _isOrdering = true);

    try {
      final api = ref.read(studioApiServiceProvider);
      final package = widget.package;

      // عرض نافذة إدخال بيانات المنتج
      final productData = await _showProductInputDialog();
      if (productData == null) {
        setState(() => _isOrdering = false);
        return;
      }

      // طلب الباقة
      final result = await api.orderPackage(
        packageType: package.id.name,
        productData: productData,
      );

      // تحديث الرصيد
      ref.read(userCreditsProvider.notifier).deductCredits(result.creditsUsed);

      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة النجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم طلب الحزمة بنجاح! رقم الطلب: ${result.orderId}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // الانتقال لمتابعة الطلب (يمكن إضافتها لاحقاً)
      }
    } on InsufficientCreditsException catch (e) {
      _showErrorDialog(
        'رصيد غير كافي',
        'تحتاج ${e.required} رصيد، المتوفر لديك ${e.balance}',
      );
    } on ApiException catch (e) {
      _showErrorDialog('خطأ', e.message);
    } catch (e) {
      _showErrorDialog('خطأ', 'حدث خطأ غير متوقع');
    } finally {
      if (mounted) {
        setState(() => _isOrdering = false);
      }
    }
  }

  Future<Map<String, dynamic>?> _showProductInputDialog() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFF8FAFC);

    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // العنوان
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Color(0xFF3B82F6),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'بيانات المنتج',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'أدخل معلومات منتجك لإنشاء المحتوى',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // حقل اسم المنتج
                  Text(
                    'اسم المنتج',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'مثال: ساعة ذكية رياضية',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey[200]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // حقل وصف المنتج
                  Text(
                    'وصف المنتج',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    maxLength: 500,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText:
                          'اكتب وصفاً تفصيلياً للمنتج، مميزاته، والجمهور المستهدف...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey[200]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      counterStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // الأزرار
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            if (nameController.text.trim().isEmpty ||
                                descriptionController.text.trim().isEmpty) {
                              HapticFeedback.heavyImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.warning_amber,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 12),
                                      Text('يرجى ملء جميع الحقول المطلوبة'),
                                    ],
                                  ),
                                  backgroundColor: Colors.orange[700],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                              return;
                            }
                            HapticFeedback.lightImpact();
                            Navigator.pop(context, {
                              'name': nameController.text.trim(),
                              'description': descriptionController.text.trim(),
                            });
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3B82F6,
                                  ).withOpacity(0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'متابعة',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // أيقونة الخطأ
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),

            // العنوان
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // الرسالة
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // زر الإغلاق
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
