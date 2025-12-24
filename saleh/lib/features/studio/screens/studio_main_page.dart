import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_dimensions.dart';
import '../constants/studio_colors.dart';

/// صفحة الاستوديو الرئيسية - استديو AI
class StudioMainPage extends ConsumerStatefulWidget {
  const StudioMainPage({super.key});

  @override
  ConsumerState<StudioMainPage> createState() => _StudioMainPageState();
}

class _StudioMainPageState extends ConsumerState<StudioMainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: StudioColors.getBackgroundColor(isDark),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Headline
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'ابدأ رحلة\n'),
                        TextSpan(
                          text: 'الإبداع الرقمي',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: AppDimensions.fontDisplay1,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),

                // Quick Actions Grid
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _buildQuickActionCard(
                        context,
                        icon: Icons.auto_awesome,
                        title: 'استديو التوليد',
                        subtitle: 'حول النص إلى صورة',
                        color: colorScheme.primary,
                        onTap: () => _navigateToGenerationStudio(context),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.movie_edit,
                        title: 'تحرير فيديو',
                        subtitle: 'أدوات احترافية',
                        color: const Color(0xFF9333EA),
                        onTap: () => _showVideoEditorDialog(context),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.auto_fix_high,
                        title: 'إزالة الخلفية',
                        subtitle: 'بضغطة واحدة',
                        color: const Color(0xFFEC4899),
                        onTap: () => _showBackgroundRemoverDialog(context),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.edit,
                        title: 'استديو التحرير',
                        subtitle: 'تحرير الصور والفيديو',
                        color: const Color(0xFF10B981),
                        onTap: () => _navigateToEditStudio(context),
                      ),
                    ],
                  ),
                ),

                // Recent Projects Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المشاريع الأخيرة',
                        style: TextStyle(
                          fontSize: AppDimensions.fontHeadline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'عرض الكل',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Recent Projects Carousel
                SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildProjectCard(
                        context,
                        title: 'تصميم شعار نيون',
                        time: 'منذ ساعتين',
                        type: 'IMG',
                        color: Colors.black54,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildProjectCard(
                        context,
                        title: 'إعلان انستقرام',
                        time: 'أمس',
                        type: 'VID',
                        color: colorScheme.primary,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildProjectCard(
                        context,
                        title: 'تعديل بورتريه',
                        time: 'منذ يومين',
                        type: 'IMG',
                        color: Colors.black54,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC4899), Color(0xFFF97316)],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Trending Templates Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'قوالب مقترحة',
                        style: TextStyle(
                          fontSize: AppDimensions.fontHeadline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'المزيد',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Trending Templates Grid
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.6,
                    children: [
                      _buildTemplateCard(
                        context,
                        title: 'سايبر بانك',
                        badge: 'شائع 🔥',
                        badgeColor: colorScheme.primary,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0EA5E9), Color(0xFF8B5CF6)],
                        ),
                      ),
                      _buildTemplateCard(
                        context,
                        title: 'مينيمال ستوري',
                        subtitle: '12K استخدام',
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFF472B6), Color(0xFFFBBF24)],
                        ),
                      ),
                      _buildTemplateCard(
                        context,
                        title: 'فلاتر قديمة',
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF78716C), Color(0xFFA8A29E)],
                        ),
                      ),
                      _buildTemplateCard(
                        context,
                        title: 'عرض أعمال',
                        badge: 'جديد',
                        badgeColor: Colors.white24,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E3A5F), Color(0xFF3B82F6)],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: StudioColors.getSurfaceColor(isDark),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Stack(
            children: [
              // Background blur effect
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: AppDimensions.iconS),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.fontBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppDimensions.fontCaption,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
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

  Widget _buildProjectCard(
    BuildContext context, {
    required String title,
    required String time,
    required String type,
    required Color color,
    required Gradient gradient,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: gradient,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontCaption,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: AppDimensions.fontBody,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: AppDimensions.fontLabel,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? badge,
    Color? badgeColor,
    required Gradient gradient,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Stack(
          children: [
            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 12,
              right: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badge != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor ?? Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontCaption,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimensions.fontBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: AppDimensions.fontLabel,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToGenerationStudio(BuildContext context) {
    context.push('/dashboard/content-studio/script-generator');
  }

  void _showVideoEditorDialog(BuildContext context) {
    _showToolDialog(
      context,
      title: 'تحرير فيديو',
      icon: Icons.movie_edit,
      color: const Color(0xFF9333EA),
      hint: 'اختر فيديو للتحرير أو أنشئ مشروعاً جديداً...',
    );
  }

  void _showBackgroundRemoverDialog(BuildContext context) {
    _showToolDialog(
      context,
      title: 'إزالة الخلفية',
      icon: Icons.auto_fix_high,
      color: const Color(0xFFEC4899),
      hint: 'اختر صورة لإزالة خلفيتها...',
    );
  }

  void _navigateToEditStudio(BuildContext context) {
    context.push('/dashboard/content-studio/editor');
  }

  void _showToolDialog(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String hint,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C2333) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: AppDimensions.iconM,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: AppDimensions.fontDisplay3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: hint,
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF101622)
                                : const Color(0xFFF6F6F8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('جاري المعالجة...'),
                                  backgroundColor: color,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'ابدأ',
                              style: TextStyle(
                                fontSize: AppDimensions.fontTitle,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
