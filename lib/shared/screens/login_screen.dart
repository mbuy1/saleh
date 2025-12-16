import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';
import '../../core/controllers/root_controller.dart';
import '../../features/auth/data/auth_controller.dart';
import '../../features/merchant/data/merchant_store_provider.dart';

/// شاشة تسجيل الدخول مع اختيار نوع المستخدم (بائع/عميل)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  // تم تثبيت الدخول كتاجر فقط
  final LoginIntent _selectedIntent = LoginIntent.merchant;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // حفظ النية مؤقتاً
    ref.read(rootControllerProvider.notifier).setLoginIntent(_selectedIntent);

    // تنفيذ تسجيل الدخول
    await ref
        .read(authControllerProvider.notifier)
        .login(
          identifier: _emailController.text.trim(),
          password: _passwordController.text,
          loginAs: 'merchant',
        );

    final authState = ref.read(authControllerProvider);

    if (!mounted) return;

    if (authState.isAuthenticated) {
      // تحميل بيانات المتجر (دائماً merchant)
      final storeController = ref.read(
        merchantStoreControllerProvider.notifier,
      );
      await storeController.loadMerchantStore();

      if (!mounted) return;

      final hasStore = ref.read(hasMerchantStoreProvider);

      // التهيئة وفتح تطبيق التاجر
      ref.read(rootControllerProvider.notifier).switchToMerchantApp();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasStore ? 'مرحباً بعودتك!' : 'مرحباً! يرجى إنشاء متجرك',
          ),
          backgroundColor: hasStore
              ? AppTheme.successColor
              : AppTheme.warningColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusS,
          ),
        ),
      );
    } else if (authState.errorMessage != null) {
      // مسح النية عند الفشل
      ref.read(rootControllerProvider.notifier).clearLoginIntent();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.errorMessage!),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusS,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppDimensions.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  _buildLogo(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // Title
                  _buildTitle(),
                  const SizedBox(height: AppDimensions.spacing32),

                  // اختيار نوع المستخدم (تم إخفاؤه - الدخول كتاجر فقط)
                  // _buildUserTypeSelection(),
                  // const SizedBox(height: AppDimensions.spacing32),

                  // Email Field
                  _buildEmailField(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // Password Field
                  _buildPasswordField(),
                  const SizedBox(height: AppDimensions.spacing32),

                  // Error Message
                  if (authState.errorMessage != null) ...[
                    _buildErrorMessage(authState.errorMessage!),
                    const SizedBox(height: AppDimensions.spacing16),
                  ],

                  // Login Button
                  _buildLoginButton(isLoading),
                  const SizedBox(height: AppDimensions.spacing24),

                  // Demo Info
                  _buildDemoInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: AppDimensions.avatarProfile,
      height: AppDimensions.avatarProfile,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        AppIcons.shoppingBag,
        width: AppDimensions.iconDisplay,
        height: AppDimensions.iconDisplay,
        colorFilter: const ColorFilter.mode(
          AppTheme.primaryColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'MBUY',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          'تسجيل الدخول',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppDimensions.fontTitle,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textDirection: TextDirection.ltr,
      style: const TextStyle(
        fontSize: AppDimensions.fontBody,
        color: AppTheme.textPrimaryColor,
      ),
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        hintText: 'example@domain.com',
        hintStyle: TextStyle(
          color: AppTheme.textHintColor,
          fontSize: AppDimensions.fontBody,
        ),
        labelStyle: TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: AppDimensions.fontBody,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            AppIcons.email,
            width: AppDimensions.iconS,
            height: AppDimensions.iconS,
            colorFilter: const ColorFilter.mode(
              AppTheme.textSecondaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال البريد الإلكتروني';
        }
        if (!value.contains('@')) {
          return 'الرجاء إدخال بريد إلكتروني صحيح';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(
        fontSize: AppDimensions.fontBody,
        color: AppTheme.textPrimaryColor,
      ),
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        hintText: '••••••••',
        hintStyle: TextStyle(
          color: AppTheme.textHintColor,
          fontSize: AppDimensions.fontBody,
        ),
        labelStyle: TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: AppDimensions.fontBody,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            AppIcons.lock,
            width: AppDimensions.iconS,
            height: AppDimensions.iconS,
            colorFilter: const ColorFilter.mode(
              AppTheme.textSecondaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        suffixIcon: IconButton(
          icon: SvgPicture.asset(
            _obscurePassword ? AppIcons.visibility : AppIcons.visibilityOff,
            width: AppDimensions.iconS,
            height: AppDimensions.iconS,
            colorFilter: const ColorFilter.mode(
              AppTheme.textSecondaryColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
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
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    const buttonColor = AppTheme.primaryColor;

    return SizedBox(
      height: AppDimensions.buttonHeightXL,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusM,
          ),
          elevation: 0,
          disabledBackgroundColor: buttonColor.withValues(alpha: 0.6),
        ),
        child: isLoading
            ? const SizedBox(
                height: AppDimensions.iconS,
                width: AppDimensions.iconS,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.store,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'دخول كبائع',
                    style: TextStyle(
                      fontSize: AppDimensions.fontTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: AppDimensions.screenPadding,
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.error,
            width: AppDimensions.iconM,
            height: AppDimensions.iconM,
            colorFilter: const ColorFilter.mode(
              AppTheme.errorColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppTheme.errorColor,
                fontSize: AppDimensions.fontBody,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoInfo() {
    return Container(
      padding: AppDimensions.screenPadding,
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withValues(alpha: 0.08),
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: AppTheme.infoColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'للتجربة:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.infoColor,
                  fontSize: AppDimensions.fontBody,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              SvgPicture.asset(
                AppIcons.info,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: ColorFilter.mode(
                  AppTheme.infoColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'البريد: baharista1@gmail.com',
            style: TextStyle(
              color: AppTheme.infoColor.withValues(alpha: 0.8),
              fontSize: AppDimensions.fontBody2,
            ),
            textDirection: TextDirection.ltr,
          ),
          Text(
            'كلمة المرور: أي شيء (6 أحرف أو أكثر)',
            style: TextStyle(
              color: AppTheme.infoColor.withValues(alpha: 0.8),
              fontSize: AppDimensions.fontBody2,
            ),
          ),
        ],
      ),
    );
  }
}
