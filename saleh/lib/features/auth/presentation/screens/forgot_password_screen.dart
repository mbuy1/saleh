import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../data/auth_repository.dart';

/// شاشة نسيت كلمة المرور
/// ØªØ±Ø³Ù„ Ø±Ø§Ø¨Ø· Ø¥Ø¹Ø§Ø¯Ø© ØªØ¹ÙŠÙŠÙ† كلمة المرور Ù„Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.forgotPassword(email: _emailController.text.trim());

      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusS,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.paddingL,
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.spacing20),

          // Ø²Ø± Ø§Ù„Ø¹ÙˆØ¯Ø©
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: AppIcon(
                AppIcons.arrowForward,
                color: AppTheme.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacing40),

          // Ø§Ù„Ø£ÙŠÙ‚ÙˆÙ†Ø©
          Center(
            child: Container(
              width: AppDimensions.avatarProfile,
              height: AppDimensions.avatarProfile,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusXXL,
              ),
              child: Center(
                child: AppIcon(
                  AppIcons.lock,
                  size: AppDimensions.iconHero,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacing32),

          // Ø§Ù„Ø¹Ù†ÙˆØ§Ù†
          const Text(
            'نسيت كلمة المرورØŸ',
            style: TextStyle(
              fontSize: AppDimensions.fontDisplay1,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacing12),

          Text(
            'Ø£Ø¯Ø®Ù„ Ø¨Ø±ÙŠØ¯Ùƒ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ ÙˆØ³Ù†Ø±Ø³Ù„ Ù„Ùƒ Ø±Ø§Ø¨Ø· Ù„Ø¥Ø¹Ø§Ø¯Ø© ØªØ¹ÙŠÙŠÙ† كلمة المرور',
            style: TextStyle(
              fontSize: AppDimensions.fontBody,
              color: AppTheme.mutedSlate,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacing40),

          // Ø­Ù‚Ù„ Ø§Ù„Ø¥ÙŠÙ…ÙŠÙ„
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
            decoration: InputDecoration(
              labelText: 'البريد الإلكتروني',
              hintText: 'example@email.com',
              prefixIcon: Padding(
                padding: AppDimensions.paddingS,
                child: AppIcon(
                  AppIcons.email,
                  size: AppDimensions.iconS,
                  color: AppTheme.mutedSlate,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusM,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusM,
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusM,
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ø§Ù„Ø±Ø¬Ø§Ø¡ Ø¥Ø¯Ø®Ø§Ù„ البريد الإلكتروني';
              }
              final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
              if (!emailRegex.hasMatch(value)) {
                return 'البريد الإلكتروني ØºÙŠØ± ØµØ­ÙŠØ­';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.spacing32),

          // Ø²Ø± Ø§Ù„Ø¥Ø±Ø³Ø§Ù„
          SizedBox(
            height: AppDimensions.buttonHeightXL,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: AppDimensions.iconM,
                      height: AppDimensions.iconM,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ø¥Ø±Ø³Ø§Ù„ Ø±Ø§Ø¨Ø· Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„ØªØ¹ÙŠÙŠÙ†',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        AppIcon(
                          AppIcons.email,
                          size: AppDimensions.iconS,
                          color: Colors.white,
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacing24),

          // Ø±Ø§Ø¨Ø· Ø§Ù„Ø¹ÙˆØ¯Ø© Ù„تسجيل الدخول
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Ø§Ù„Ø¹ÙˆØ¯Ø© Ù„تسجيل الدخول',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: AppDimensions.fontBody,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AppDimensions.spacing64 + AppDimensions.spacing16),

        // Ø£ÙŠÙ‚ÙˆÙ†Ø© Ø§Ù„Ù†Ø¬Ø§Ø­
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXXL + 6),
            ),
            child: Center(
              child: AppIcon(
                AppIcons.checkCircle,
                size: AppDimensions.iconDisplay,
                color: AppTheme.successColor,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacing32),

        // Ø±Ø³Ø§Ù„Ø© Ø§Ù„Ù†Ø¬Ø§Ø­
        Text(
          'ØªÙ… Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø±Ø§Ø¨Ø·!',
          style: TextStyle(
            fontSize: AppDimensions.fontDisplay1,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacing16),

        Text(
          'ØªÙ… Ø¥Ø±Ø³Ø§Ù„ Ø±Ø§Ø¨Ø· Ø¥Ø¹Ø§Ø¯Ø© ØªØ¹ÙŠÙŠÙ† كلمة المرور Ø¥Ù„Ù‰\n${_emailController.text}',
          style: TextStyle(
            fontSize: AppDimensions.fontBody,
            color: AppTheme.mutedSlate,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacing16),

        // ØªØ¹Ù„ÙŠÙ…Ø§Øª
        Container(
          padding: AppDimensions.paddingM,
          decoration: BoxDecoration(
            color: AppTheme.infoColor.withValues(alpha: 0.1),
            borderRadius: AppDimensions.borderRadiusM,
            border: Border.all(
              color: AppTheme.infoColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  AppIcon(
                    AppIcons.info,
                    size: AppDimensions.iconS,
                    color: AppTheme.infoColor,
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  const Text(
                    'ØªØ¹Ù„ÙŠÙ…Ø§Øª:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.infoColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'â€¢ ØªØ­Ù‚Ù‚ Ù…Ù† ØµÙ†Ø¯ÙˆÙ‚ Ø§Ù„ÙˆØ§Ø±Ø¯ ÙÙŠ Ø¨Ø±ÙŠØ¯Ùƒ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ\n'
                'â€¢ Ù‚Ø¯ ÙŠØµÙ„ Ø§Ù„Ø±Ø§Ø¨Ø· Ø¥Ù„Ù‰ Ù…Ø¬Ù„Ø¯ Ø§Ù„Ø±Ø³Ø§Ø¦Ù„ ØºÙŠØ± Ø§Ù„Ù…Ø±ØºÙˆØ¨ ÙÙŠÙ‡Ø§\n'
                'â€¢ Ø§Ù„Ø±Ø§Ø¨Ø· ØµØ§Ù„Ø­ Ù„Ù…Ø¯Ø© 24 ساعة',
                style: TextStyle(
                  fontSize: AppDimensions.fontBody2,
                  color: AppTheme.infoColor.withValues(alpha: 0.9),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spacing32),

        // Ø²Ø± Ø§Ù„Ø¹ÙˆØ¯Ø©
        SizedBox(
          height: AppDimensions.buttonHeightXL,
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: AppDimensions.borderRadiusM,
              ),
              elevation: 0,
            ),
            child: Text(
              'Ø§Ù„Ø¹ÙˆØ¯Ø© Ù„تسجيل الدخول',
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacing16),

        // Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„Ø¥Ø±Ø³Ø§Ù„
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: Text(
            'Ù„Ù… ØªØ³ØªÙ„Ù… Ø§Ù„Ø±Ø§Ø¨Ø·ØŸ Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„Ø¥Ø±Ø³Ø§Ù„',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: AppDimensions.fontBody,
            ),
          ),
        ),
      ],
    );
  }
}
