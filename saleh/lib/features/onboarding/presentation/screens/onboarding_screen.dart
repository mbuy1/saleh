import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../data/onboarding_repository.dart';

/// Ø´Ø§Ø´Ø© Ø§Ù„Ù€ Onboarding Ø§Ù„Ù…Ø­Ø³Ù‘Ù†Ø©
/// ØªØ¬Ø±Ø¨Ø© ØªÙØ§Ø¹Ù„ÙŠØ© ØºÙ†ÙŠØ© Ù„Ù„Ù…Ø³ØªØ®Ø¯Ù… Ø§Ù„Ø¬Ø¯ÙŠØ¯
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
      title: 'Ù…Ø±Ø­Ø¨Ø§Ù‹ Ø¨Ùƒ ÙÙŠ Mbuy',
      subtitle: 'Ù…Ù†ØµØªÙƒ Ø§Ù„Ù…ØªÙƒØ§Ù…Ù„Ø© Ù„Ø¥Ø¯Ø§Ø±Ø© Ù…ØªØ¬Ø±Ùƒ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
      description: 'Ø£Ø¯Ø± Ù…Ù†ØªØ¬Ø§ØªÙƒØŒ Ø·Ù„Ø¨Ø§ØªÙƒØŒ ÙˆØ¹Ù…Ù„Ø§Ø¦Ùƒ Ù…Ù† Ù…ÙƒØ§Ù† ÙˆØ§Ø­Ø¯ Ø¨Ø³Ù‡ÙˆÙ„Ø© ØªØ§Ù…Ø©',
      icon: AppIcons.store,
      gradient: LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª', 'ØªØªØ¨Ø¹ Ø§Ù„Ø·Ù„Ø¨Ø§Øª', 'ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡'],
    ),
    const OnboardingPage(
      title: 'ØªØ³ÙˆÙŠÙ‚ Ø°ÙƒÙŠ',
      subtitle: 'Ø£Ø¯ÙˆØ§Øª ØªØ³ÙˆÙŠÙ‚ Ù…ØªÙ‚Ø¯Ù…Ø© Ù„Ø²ÙŠØ§Ø¯Ø© Ù…Ø¨ÙŠØ¹Ø§ØªÙƒ',
      description:
          'ÙƒÙˆØ¨ÙˆÙ†Ø§ØªØŒ Ø¹Ø±ÙˆØ¶ Ø®Ø§Ø·ÙØ©ØŒ Ø¨Ø±Ø§Ù…Ø¬ ÙˆÙ„Ø§Ø¡ØŒ ÙˆØ¥Ø­Ø§Ù„Ø§Øª - ÙƒÙ„ Ù…Ø§ ØªØ­ØªØ§Ø¬Ù‡ Ù„Ø¬Ø°Ø¨ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
      icon: AppIcons.megaphone,
      gradient: LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF34D399)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['ÙƒÙˆØ¨ÙˆÙ†Ø§Øª Ø®ØµÙ…', 'Ø¹Ø±ÙˆØ¶ Ø®Ø§Ø·ÙØ©', 'Ø¨Ø±Ù†Ø§Ù…Ø¬ Ø¥Ø­Ø§Ù„Ø©'],
    ),
    const OnboardingPage(
      title: 'Ø°ÙƒØ§Ø¡ Ø§ØµØ·Ù†Ø§Ø¹ÙŠ',
      subtitle: 'Ø§Ø³ØªØ®Ø¯Ù… Ù‚ÙˆØ© AI Ù„ØªØ·ÙˆÙŠØ± Ù…ØªØ¬Ø±Ùƒ',
      description:
          'ØªÙˆÙ„ÙŠØ¯ ÙˆØµÙ Ø§Ù„Ù…Ù†ØªØ¬Ø§ØªØŒ ØªØ­Ù„ÙŠÙ„Ø§Øª Ø°ÙƒÙŠØ©ØŒ ÙˆØ§Ù‚ØªØ±Ø§Ø­Ø§Øª Ù„ØªØ­Ø³ÙŠÙ† Ø£Ø¯Ø§Ø¡ Ù…ØªØ¬Ø±Ùƒ',
      icon: AppIcons.bot,
      gradient: LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['ØªÙˆÙ„ÙŠØ¯ Ø§Ù„Ù…Ø­ØªÙˆÙ‰', 'ØªØ­Ù„ÙŠÙ„Ø§Øª Ø°ÙƒÙŠØ©', 'Ù…Ø³Ø§Ø¹Ø¯ AI'],
    ),
    const OnboardingPage(
      title: 'Ø§Ø®ØªØµØ§Ø±Ø§Øª Ù…Ø®ØµØµØ©',
      subtitle: 'ÙˆØµÙˆÙ„ Ø³Ø±ÙŠØ¹ Ù„Ù…Ø§ ØªØ­ØªØ§Ø¬Ù‡',
      description:
          'Ø£Ù†Ø´Ø¦ Ø§Ø®ØªØµØ§Ø±Ø§ØªÙƒ Ø§Ù„Ø®Ø§ØµØ© Ù„Ù„Ù…ÙŠØ²Ø§Øª Ø§Ù„ØªÙŠ ØªØ³ØªØ®Ø¯Ù…Ù‡Ø§ ÙƒØ«ÙŠØ±Ø§Ù‹ ÙˆØ§Ø³ØªØ®Ø¯Ù… Ø§Ù„Ø¨Ø­Ø« Ø§Ù„Ø³Ø±ÙŠØ¹',
      icon: AppIcons.shortcuts,
      gradient: LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['Ø§Ø®ØªØµØ§Ø±Ø§Øª Ù…Ø®ØµØµØ©', 'Ø¨Ø­Ø« Ø³Ø±ÙŠØ¹', 'ØªÙØ¶ÙŠÙ„Ø§Øª Ø´Ø®ØµÙŠØ©'],
    ),
    const OnboardingPage(
      title: 'Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø°ÙƒÙŠØ©',
      subtitle: 'Ø§Ø¨Ù‚ÙŽ Ø¹Ù„Ù‰ Ø§Ø·Ù„Ø§Ø¹ Ø¯Ø§Ø¦Ù…',
      description:
          'ØªØ­ÙƒÙ… ÙƒØ§Ù…Ù„ ÙÙŠ Ø¥Ø´Ø¹Ø§Ø±Ø§ØªÙƒ - Ø§Ø®ØªØ± Ù…Ø§ ØªØ±ÙŠØ¯ Ù…Ø¹Ø±ÙØªÙ‡ ÙˆÙ…ØªÙ‰',
      icon: AppIcons.notifications,
      gradient: LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFF87171)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      features: ['Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª', 'ØªÙ†Ø¨ÙŠÙ‡Ø§Øª Ø§Ù„Ù…Ø®Ø²ÙˆÙ†', 'ÙˆÙ‚Øª Ø§Ù„Ù‡Ø¯ÙˆØ¡'],
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
          'ØªØ®Ø·ÙŠ Ø§Ù„Ø¬ÙˆÙ„Ø© Ø§Ù„ØªØ¹Ø±ÙŠÙÙŠØ©ØŸ',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'ÙŠÙ…ÙƒÙ†Ùƒ Ø¯Ø§Ø¦Ù…Ø§Ù‹ Ø¥Ø¹Ø§Ø¯Ø© Ø¹Ø±Ø¶ Ø§Ù„Ø¬ÙˆÙ„Ø© Ù…Ù† Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
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
            child: const Text('ØªØ®Ø·ÙŠ'),
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
      body: Stack(
        children: [
          // Ø®Ù„ÙÙŠØ© Ù…ØªØ­Ø±ÙƒØ©
          _buildAnimatedBackground(gradientColors),
          
          SafeArea(
            child: Column(
              children: [
                // Header Ù…Ø¹ progress
                _buildHeader(),
                
                // Ù…Ø­ØªÙˆÙ‰ Ø§Ù„ØµÙØ­Ø§Øª
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

                // Ø£Ø²Ø±Ø§Ø± Ø§Ù„ØªÙ†Ù‚Ù„
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
          // Ø²Ø± Ø±Ø¬ÙˆØ¹
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
          
          // Ø²Ø± ØªØ®Ø·ÙŠ
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
                'ØªØ®Ø·ÙŠ',
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
              // Ø§Ù„Ø£ÙŠÙ‚ÙˆÙ†Ø© Ø§Ù„Ù…ØªØ­Ø±ÙƒØ©
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
                            // ØªØ£Ø«ÙŠØ± Ø¯Ø§Ø¦Ø±ÙŠ Ù…ØªØ­Ø±Ùƒ
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

              // Ø§Ù„Ø¹Ù†ÙˆØ§Ù†
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

              // Ø§Ù„Ø¹Ù†ÙˆØ§Ù† Ø§Ù„ÙØ±Ø¹ÙŠ
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

              // Ø§Ù„ÙˆØµÙ
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
              
              // Ø§Ù„Ù…ÙŠØ²Ø§Øª
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
          // Ù…Ø¤Ø´Ø±Ø§Øª Ø§Ù„ØµÙØ­Ø§Øª
          Row(
            children: List.generate(
              _pages.length,
              (index) => _buildDot(index),
            ),
          ),
          const Spacer(),
          // Ø²Ø± Ø§Ù„ØªØ§Ù„ÙŠ/Ø§Ø¨Ø¯Ø£
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
                    isLastPage ? 'Ø§Ø¨Ø¯Ø£ Ø§Ù„Ø¢Ù†' : 'Ø§Ù„ØªØ§Ù„ÙŠ',
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

/// Ù†Ù…ÙˆØ°Ø¬ ØµÙØ­Ø© Onboarding Ù…Ø­Ø³Ù‘Ù†
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
