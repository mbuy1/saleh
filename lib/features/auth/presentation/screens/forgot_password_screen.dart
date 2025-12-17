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
/// ترسل رابط إعادة تعيين كلمة المرور للبريد الإلكتروني
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
      backgroundColor: AppTheme.backgroundColor,
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

          // زر العودة
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

          // الأيقونة
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

          // العنوان
          const Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontSize: AppDimensions.fontDisplay1,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacing12),

          Text(
            'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور',
            style: TextStyle(
              fontSize: AppDimensions.fontBody,
              color: AppTheme.mutedSlate,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacing40),

          // حقل الإيميل
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
                return 'الرجاء إدخال البريد الإلكتروني';
              }
              final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
              if (!emailRegex.hasMatch(value)) {
                return 'البريد الإلكتروني غير صحيح';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.spacing32),

          // زر الإرسال
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
                          'إرسال رابط إعادة التعيين',
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

          // رابط العودة لتسجيل الدخول
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'العودة لتسجيل الدخول',
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

        // أيقونة النجاح
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

        // رسالة النجاح
        Text(
          'تم إرسال الرابط!',
          style: TextStyle(
            fontSize: AppDimensions.fontDisplay1,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacing16),

        Text(
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى\n${_emailController.text}',
          style: TextStyle(
            fontSize: AppDimensions.fontBody,
            color: AppTheme.mutedSlate,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacing16),

        // تعليمات
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
                    'تعليمات:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.infoColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                '• تحقق من صندوق الوارد في بريدك الإلكتروني\n'
                '• قد يصل الرابط إلى مجلد الرسائل غير المرغوب فيها\n'
                '• الرابط صالح لمدة 24 ساعة',
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

        // زر العودة
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
              'العودة لتسجيل الدخول',
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacing16),

        // إعادة الإرسال
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: Text(
            'لم تستلم الرابط؟ إعادة الإرسال',
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
