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
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
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
          const SizedBox(height: 20),

          // زر العودة
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: AppIcon(AppIcons.arrowForward, color: AppTheme.primaryColor),
            ),
          ),

          const SizedBox(height: 40),

          // الأيقونة
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: AppIcon(AppIcons.lock, size: 48, color: AppTheme.primaryColor),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // العنوان
          const Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mutedSlate,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

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
                padding: const EdgeInsets.all(12),
                child: AppIcon(AppIcons.email, size: 22, color: AppTheme.mutedSlate),
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
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
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

          const SizedBox(height: 32),

          // زر الإرسال
          SizedBox(
            height: 56,
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
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'إرسال رابط إعادة التعيين',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppIcon(AppIcons.email, size: 20, color: Colors.white),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // رابط العودة لتسجيل الدخول
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'العودة لتسجيل الدخول',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
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
        const SizedBox(height: 80),

        // أيقونة النجاح
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: AppIcon(AppIcons.checkCircle, size: 64, color: AppTheme.successColor),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // رسالة النجاح
        const Text(
          'تم إرسال الرابط!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        Text(
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى\n${_emailController.text}',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.mutedSlate,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // تعليمات
        Container(
          padding: AppDimensions.paddingM,
          decoration: BoxDecoration(
            color: AppTheme.infoColor.withValues(alpha: 0.1),
            borderRadius: AppDimensions.borderRadiusM,
            border: Border.all(color: AppTheme.infoColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  AppIcon(AppIcons.info, size: 20, color: AppTheme.infoColor),
                  const SizedBox(width: 8),
                  const Text(
                    'تعليمات:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.infoColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• تحقق من صندوق الوارد في بريدك الإلكتروني\n'
                '• قد يصل الرابط إلى مجلد الرسائل غير المرغوب فيها\n'
                '• الرابط صالح لمدة 24 ساعة',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.infoColor.withValues(alpha: 0.9),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // زر العودة
        SizedBox(
          height: 56,
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
            child: const Text(
              'العودة لتسجيل الدخول',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // إعادة الإرسال
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: const Text(
            'لم تستلم الرابط؟ إعادة الإرسال',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
