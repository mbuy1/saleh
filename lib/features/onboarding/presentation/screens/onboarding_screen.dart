import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../data/onboarding_repository.dart';

/// شاشة الـ Onboarding المحسّنة
/// تجربة تفاعلية غنية للمستخدم الجديد
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'مرحباً بك في Mbuy',
      subtitle: 'منصتك المتكاملة لإدارة متجرك الإلكتروني',
      description: 'أدر منتجاتك، طلباتك، وعملائك من مكان واحد بسهولة تامة',
      icon: AppIcons.store,
      gradient: LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['إدارة المنتجات', 'تتبع الطلبات', 'تحليل العملاء'],
    ),
    const OnboardingPage(
      title: 'تسويق ذكي',
      subtitle: 'أدوات تسويق متقدمة لزيادة مبيعاتك',
      description:
          'كوبونات، عروض خاطفة، برامج ولاء، وإحالات - كل ما تحتاجه لجذب العملاء',
      icon: AppIcons.megaphone,
      gradient: LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF34D399)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['كوبونات خصم', 'عروض خاطفة', 'برنامج إحالة'],
    ),
    const OnboardingPage(
      title: 'ذكاء اصطناعي',
      subtitle: 'استخدم قوة AI لتطوير متجرك',
      description:
          'توليد وصف المنتجات، تحليلات ذكية، واقتراحات لتحسين أداء متجرك',
      icon: AppIcons.bot,
      gradient: LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['توليد المحتوى', 'تحليلات ذكية', 'مساعد AI'],
    ),
    const OnboardingPage(
      title: 'اختصارات مخصصة',
      subtitle: 'وصول سريع لما تحتاجه',
      description:
          'أنشئ اختصاراتك الخاصة للميزات التي تستخدمها كثيراً واستخدم البحث السريع',
      icon: AppIcons.shortcuts,
      gradient: LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['اختصارات مخصصة', 'بحث سريع', 'تفضيلات شخصية'],
    ),
    const OnboardingPage(
      title: 'إشعارات ذكية',
      subtitle: 'ابقَ على اطلاع دائم',
      description:
          'تحكم كامل في إشعاراتك - اختر ما تريد معرفته ومتى',
      icon: AppIcons.notifications,
      gradient: LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFF87171)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['إشعارات الطلبات', 'تنبيهات المخزون', 'وقت الهدوء'],
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }
  
  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _showSkipConfirmation();
  }
  
  void _showSkipConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'تخطي الجولة التعريفية؟',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'يمكنك دائماً إعادة عرض الجولة من الإعدادات',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeOnboarding();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('تخطي'),
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final repository = ref.read(onboardingRepositoryProvider);
    await repository.setOnboardingComplete();
    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    final gradientColors = (page.gradient as LinearGradient).colors;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // خلفية متحركة
          _buildAnimatedBackground(gradientColors),
          
          SafeArea(
            child: Column(
              children: [
                // Header مع progress
                _buildHeader(),
                
                // محتوى الصفحات
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      HapticFeedback.selectionClick();
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index], index);
                    },
                  ),
                ),

                // أزرار التنقل
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnimatedBackground(List<Color> colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.first.withValues(alpha: 0.05),
            colors.last.withValues(alpha: 0.02),
            AppTheme.backgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.3, 0.6],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // زر رجوع
          if (_currentPage > 0)
            GestureDetector(
              onTap: _previousPage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: AppTheme.primaryColor,
                ),
              ),
            )
          else
            const SizedBox(width: 44),
            
          // Progress indicator
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / _pages.length,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ((_pages[_currentPage].gradient as LinearGradient)
                            .colors
                            .first),
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_currentPage + 1} / ${_pages.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // زر تخطي
          GestureDetector(
            onTap: _skipOnboarding,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Text(
                'تخطي',
                style: TextStyle(
                  color: AppTheme.textHintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, int index) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الأيقونة المتحركة
              Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _currentPage == index ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: page.gradient,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: (page.gradient as LinearGradient)
                                  .colors
                                  .first
                                  .withValues(alpha: 0.4),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // تأثير دائري متحرك
                            ...List.generate(3, (i) {
                              return AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Container(
                                    width: 140 + (i * 20) * _pulseAnimation.value,
                                    height: 140 + (i * 20) * _pulseAnimation.value,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.1 - (i * 0.03),
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                            AppIcon(
                              page.icon,
                              size: AppDimensions.iconDisplay,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),

              // العنوان
              Text(
                page.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // العنوان الفرعي
              Text(
                page.subtitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: (page.gradient as LinearGradient).colors.first,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // الوصف
              Text(
                page.description,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.textHintColor,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // الميزات
              if (page.features != null)
                _buildFeaturesList(page.features!, page.gradient),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFeaturesList(List<String> features, Gradient gradient) {
    final color = (gradient as LinearGradient).colors.first;
    
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                feature,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == _pages.length - 1;
    final page = _pages[_currentPage];
    final buttonColor = (page.gradient as LinearGradient).colors.first;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        children: [
          // مؤشرات الصفحات
          Row(
            children: List.generate(
              _pages.length,
              (index) => _buildDot(index),
            ),
          ),
          const Spacer(),
          // زر التالي/ابدأ
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isLastPage ? 32 : 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: buttonColor.withValues(alpha: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLastPage ? 'ابدأ الآن' : 'التالي',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isLastPage ? Icons.rocket_launch : Icons.arrow_forward,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == _currentPage;
    final page = _pages[index];
    final color = (page.gradient as LinearGradient).colors.first;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: isActive ? 28 : 10,
        height: 10,
        decoration: BoxDecoration(
          color: isActive ? color : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

/// نموذج صفحة Onboarding محسّن
class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final String icon;
  final Gradient gradient;
  final List<String>? features;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    this.features,
  });
}
