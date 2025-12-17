import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../data/auth_controller.dart';
import '../widgets/primary_button.dart';
import '../widgets/auth_text_form_field.dart';

/// شاشة التسجيل
/// تسمح للمستخدمين الجدد بإنشاء حساب تاجر
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يجب الموافقة على الشروط والأحكام'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusS,
          ),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();

    await ref
        .read(authControllerProvider.notifier)
        .register(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: 'merchant',
        );
  }

  @override
  Widget build(BuildContext context) {
    // الاستماع لحالة المصادقة لعرض الأخطاء أو التوجيه
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // مسح الخطأ بعد عرضه
        ref.read(authControllerProvider.notifier).clearError();
      } else if (next.isAuthenticated) {
        // نجح التسجيل - توجيه لإنشاء المتجر
        context.go('/dashboard/store/create-store');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم إنشاء حسابك بنجاح! قم بإنشاء متجرك الآن'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.paddingL,
          child: Form(
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
                    icon: AppIcon(
                      AppIcons.arrowForward,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // الشعار
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.metallicGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AppIcon(
                        AppIcons.store,
                        size: 40,
                        color: AppTheme.surfaceColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // العنوان
                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'انضم إلى Mbuy وابدأ رحلتك التجارية',
                  style: TextStyle(fontSize: 14, color: AppTheme.mutedSlate),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // حقل الاسم
                AuthTextFormField(
                  controller: _nameController,
                  labelText: 'الاسم الكامل',
                  hintText: 'أدخل اسمك',
                  prefixIcon: AppIcons.person,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الاسم';
                    }
                    if (value.trim().length < 2) {
                      return 'الاسم قصير جداً';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // حقل الإيميل
                AuthTextFormField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني',
                  hintText: 'example@email.com',
                  prefixIcon: AppIcons.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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

                const SizedBox(height: 16),

                // حقل كلمة المرور
                AuthTextFormField(
                  controller: _passwordController,
                  labelText: 'كلمة المرور',
                  hintText: '••••••••',
                  prefixIcon: AppIcons.lock,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: AppIcon(
                      _obscurePassword
                          ? AppIcons.visibility
                          : AppIcons.visibilityOff,
                      size: 22,
                      color: AppTheme.mutedSlate,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // تأكيد كلمة المرور
                AuthTextFormField(
                  controller: _confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور',
                  hintText: '••••••••',
                  prefixIcon: AppIcons.lock,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleRegister(),
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                    icon: AppIcon(
                      _obscureConfirmPassword
                          ? AppIcons.visibility
                          : AppIcons.visibilityOff,
                      size: 22,
                      color: AppTheme.mutedSlate,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة المرور';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // الموافقة على الشروط
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) =>
                          setState(() => _acceptTerms = value ?? false),
                      activeColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _acceptTerms = !_acceptTerms),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.mutedSlate,
                            ),
                            children: [
                              const TextSpan(text: 'أوافق على '),
                              TextSpan(
                                text: 'شروط الاستخدام',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.push('/terms');
                                  },
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: ' و '),
                              TextSpan(
                                text: 'سياسة الخصوصية',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.push('/privacy-policy');
                                  },
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // زر التسجيل
                PrimaryButton(
                  text: 'إنشاء حساب',
                  onPressed: _handleRegister,
                  isLoading: authState.isLoading,
                ),

                const SizedBox(height: 24),

                // رابط تسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(
                        color: AppTheme.mutedSlate,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
