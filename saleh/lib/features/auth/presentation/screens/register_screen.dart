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

/// Ø´Ø§Ø´Ø© Ø§Ù„ØªØ³Ø¬ÙŠÙ„
/// ØªØ³Ù…Ø­ Ù„Ù„Ù…Ø³ØªØ®Ø¯Ù…ÙŠÙ† Ø§Ù„Ø¬Ø¯Ø¯ Ø¨Ø¥Ù†Ø´Ø§Ø¡ Ø­Ø³Ø§Ø¨ ØªØ§Ø¬Ø±
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
          content: const Text('ÙŠØ¬Ø¨ Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø© Ø¹Ù„Ù‰ Ø§Ù„Ø´Ø±ÙˆØ· ÙˆØ§Ù„Ø£Ø­ÙƒØ§Ù…'),
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
    // Ø§Ù„Ø§Ø³ØªÙ…Ø§Ø¹ Ù„Ø­Ø§Ù„Ø© Ø§Ù„Ù…ØµØ§Ø¯Ù‚Ø© Ù„Ø¹Ø±Ø¶ Ø§Ù„Ø£Ø®Ø·Ø§Ø¡ Ø£Ùˆ Ø§Ù„ØªÙˆØ¬ÙŠÙ‡
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Ù…Ø³Ø­ Ø§Ù„Ø®Ø·Ø£ Ø¨Ø¹Ø¯ Ø¹Ø±Ø¶Ù‡
        ref.read(authControllerProvider.notifier).clearError();
      } else if (next.isAuthenticated) {
        // Ù†Ø¬Ø­ Ø§Ù„ØªØ³Ø¬ÙŠÙ„ - ØªÙˆØ¬ÙŠÙ‡ Ù„Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„Ù…ØªØ¬Ø±
        context.go('/dashboard/store/create-store');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ø­Ø³Ø§Ø¨Ùƒ Ø¨Ù†Ø¬Ø§Ø­! Ù‚Ù… Ø¨Ø¥Ù†Ø´Ø§Ø¡ Ù…ØªØ¬Ø±Ùƒ Ø§Ù„Ø¢Ù†'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.paddingL,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

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

                const SizedBox(height: 20),

                // Ø§Ù„Ø´Ø¹Ø§Ø±
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

                // Ø§Ù„Ø¹Ù†ÙˆØ§Ù†
                const Text(
                  'Ø¥Ù†Ø´Ø§Ø¡ Ø­Ø³Ø§Ø¨ Ø¬Ø¯ÙŠØ¯',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Ø§Ù†Ø¶Ù… Ø¥Ù„Ù‰ Mbuy ÙˆØ§Ø¨Ø¯Ø£ Ø±Ø­Ù„ØªÙƒ Ø§Ù„ØªØ¬Ø§Ø±ÙŠØ©',
                  style: TextStyle(fontSize: 14, color: AppTheme.mutedSlate),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Ø­Ù‚Ù„ Ø§Ù„Ø§Ø³Ù…
                AuthTextFormField(
                  controller: _nameController,
                  labelText: 'Ø§Ù„Ø§Ø³Ù… Ø§Ù„ÙƒØ§Ù…Ù„',
                  hintText: 'Ø£Ø¯Ø®Ù„ Ø§Ø³Ù…Ùƒ',
                  prefixIcon: AppIcons.person,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ø§Ù„Ø±Ø¬Ø§Ø¡ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„Ø§Ø³Ù…';
                    }
                    if (value.trim().length < 2) {
                      return 'Ø§Ù„Ø§Ø³Ù… Ù‚ØµÙŠØ± Ø¬Ø¯Ø§Ù‹';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Ø­Ù‚Ù„ Ø§Ù„Ø¥ÙŠÙ…ÙŠÙ„
                AuthTextFormField(
                  controller: _emailController,
                  labelText: 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
                  hintText: 'example@email.com',
                  prefixIcon: AppIcons.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ø§Ù„Ø±Ø¬Ø§Ø¡ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ';
                    }
                    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ ØºÙŠØ± ØµØ­ÙŠØ­';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Ø­Ù‚Ù„ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±
                AuthTextFormField(
                  controller: _passwordController,
                  labelText: 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
                  hintText: 'â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢',
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
                      return 'Ø§Ù„Ø±Ø¬Ø§Ø¡ Ø¥Ø¯Ø®Ø§Ù„ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±';
                    }
                    if (value.length < 6) {
                      return 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ÙŠØ¬Ø¨ Ø£Ù† ØªÙƒÙˆÙ† 6 Ø£Ø­Ø±Ù Ø¹Ù„Ù‰ Ø§Ù„Ø£Ù‚Ù„';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ØªØ£ÙƒÙŠØ¯ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±
                AuthTextFormField(
                  controller: _confirmPasswordController,
                  labelText: 'ØªØ£ÙƒÙŠØ¯ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
                  hintText: 'â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢',
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
                      return 'Ø§Ù„Ø±Ø¬Ø§Ø¡ ØªØ£ÙƒÙŠØ¯ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±';
                    }
                    if (value != _passwordController.text) {
                      return 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ØºÙŠØ± Ù…ØªØ·Ø§Ø¨Ù‚Ø©';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø© Ø¹Ù„Ù‰ Ø§Ù„Ø´Ø±ÙˆØ·
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
                              const TextSpan(text: 'Ø£ÙˆØ§ÙÙ‚ Ø¹Ù„Ù‰ '),
                              TextSpan(
                                text: 'Ø´Ø±ÙˆØ· Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù…',
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
                              const TextSpan(text: ' Ùˆ '),
                              TextSpan(
                                text: 'Ø³ÙŠØ§Ø³Ø© Ø§Ù„Ø®ØµÙˆØµÙŠØ©',
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

                // Ø²Ø± Ø§Ù„ØªØ³Ø¬ÙŠÙ„
                PrimaryButton(
                  text: 'Ø¥Ù†Ø´Ø§Ø¡ Ø­Ø³Ø§Ø¨',
                  onPressed: _handleRegister,
                  isLoading: authState.isLoading,
                ),

                const SizedBox(height: 24),

                // Ø±Ø§Ø¨Ø· ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ù„Ø¯ÙŠÙƒ Ø­Ø³Ø§Ø¨ Ø¨Ø§Ù„ÙØ¹Ù„ØŸ',
                      style: TextStyle(
                        color: AppTheme.mutedSlate,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text(
                        'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„',
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
