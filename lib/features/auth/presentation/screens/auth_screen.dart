import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_service.dart';
import '../../../../core/app_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _cityController = TextEditingController();

  bool _isSignUp = false; // true = تسجيل جديد، false = تسجيل دخول
  bool _isLoading = false;
  String? _selectedRole; // null = لم يتم الاختيار بعد، 'customer' أو 'merchant'

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _storeNameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignUp) {
        // تسجيل جديد
        final result = await AuthService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim(),
          role: _selectedRole ?? 'customer',
          accountType:
              _selectedRole ?? 'customer', // Send account_type to backend
          storeName: _selectedRole == 'merchant'
              ? _storeNameController.text.trim()
              : null,
          city: _selectedRole == 'merchant'
              ? _cityController.text.trim()
              : null,
        );

        if (mounted) {
          final user = result['user'] as Map<String, dynamic>;
          debugPrint('✅ تم تسجيل المستخدم: ${user['email']}');

          // التحقق من وجود token بعد التسجيل
          final isLoggedIn = await AuthRepository.isLoggedIn();
          if (mounted && isLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم التسجيل بنجاح! جاري تحميل التطبيق...'),
                backgroundColor: Colors.green,
              ),
            );

            // الانتظار قليلاً ثم إعادة بناء
            await Future.delayed(const Duration(milliseconds: 500));
          } else if (mounted) {
            // إذا لم يكن هناك token محفوظ
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء الحساب! يرجى تسجيل الدخول الآن'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
            // التبديل إلى وضع تسجيل الدخول
            setState(() {
              _isSignUp = false;
            });
          }
        }
      } else {
        // تسجيل دخول
        final email = _emailController.text.trim().toLowerCase();
        final password = _passwordController.text;

        debugPrint('🔐 محاولة تسجيل الدخول: $email');

        // Step 1: Login and save token
        // Send login_as based on selected role (merchant or customer)
        final result = await AuthService.signIn(
          email: email,
          password: password,
          loginAs: _selectedRole ?? 'customer', // Send login_as to backend
        );

        if (!mounted) return;

        final user = result['user'] as Map<String, dynamic>;
        debugPrint('✅ تم تسجيل الدخول: ${user['email']}');
        debugPrint('✅ Token محفوظ في secure storage');

        // Step 2: Verify token by calling /auth/me
        try {
          debugPrint('📡 استدعاء /auth/me للتحقق من Token...');
          final verifiedUser = await AuthRepository.verifyAndLoadUser();

          if (mounted) {
            debugPrint('✅ تم التحقق من Token بنجاح');
            debugPrint('✅ User ID: ${verifiedUser['id']}');
            debugPrint('✅ User Email: ${verifiedUser['email']}');

            // Success - Navigate to root which will check auth and show appropriate screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تسجيل الدخول بنجاح! جاري تحميل التطبيق...'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );

            // Navigate directly based on chosen role
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) {
              // If user logged in as merchant, open merchant dashboard directly
              if ((_selectedRole ?? 'customer') == 'merchant') {
                Navigator.of(
                  context,
                ).pushReplacementNamed(AppRouter.merchantDashboard);
              } else {
                Navigator.of(context).pushReplacementNamed('/');
              }
            }
          }
        } catch (e) {
          // Step 3: If /auth/me fails, clear token and show error
          debugPrint('❌ فشل التحقق من Token: $e');

          // Clear token (already done in verifyAndLoadUser, but ensure it's cleared)
          await AuthRepository.logout();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في التحقق من الجلسة: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );

            // Stay on login screen (don't navigate)
            // Don't throw exception here, just show error and stay on screen
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // إذا لم يتم اختيار نوع الحساب بعد، اعرض شاشة الاختيار
    if (_selectedRole == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // عنوان الشاشة
                const Text(
                  'اختر نوع الحساب',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'اختر نوع الحساب للبدء',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // خياران كبيران: Merchant و Customer
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        icon: Icons.store,
                        title: 'بائع',
                        subtitle: 'تاجر',
                        color: Colors.green,
                        onTap: () {
                          setState(() {
                            _selectedRole = 'merchant';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRoleCard(
                        icon: Icons.shopping_bag,
                        title: 'عميل',
                        subtitle: 'زبون',
                        color: Colors.blue,
                        onTap: () {
                          setState(() {
                            _selectedRole = 'customer';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    }

    // بعد اختيار نوع الحساب، اعرض نموذج تسجيل الدخول/التسجيل
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // زر العودة لاختيار نوع الحساب
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _selectedRole = null;
                        _emailController.clear();
                        _passwordController.clear();
                        _displayNameController.clear();
                        _storeNameController.clear();
                        _cityController.clear();
                        _isSignUp = false;
                      });
                    },
                  ),
                ),

                // عنوان الشاشة
                Text(
                  _isSignUp ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isSignUp
                      ? 'أنشئ حسابك كـ ${_selectedRole == 'merchant' ? 'تاجر' : 'عميل'} للبدء في استخدام التطبيق'
                      : 'مرحباً بعودتك! سجل دخولك للمتابعة',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // حقل الاسم المعروض (فقط عند التسجيل)
                if (_isSignUp) ...[
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم المعروض',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال الاسم المعروض';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // عرض نوع الحساب المختار (غير قابل للتعديل)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedRole == 'merchant'
                          ? Colors.green.shade50
                          : Colors.blue.shade50,
                      border: Border.all(
                        color: _selectedRole == 'merchant'
                            ? Colors.green
                            : Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedRole == 'merchant'
                              ? Icons.store
                              : Icons.shopping_bag,
                          color: _selectedRole == 'merchant'
                              ? Colors.green
                              : Colors.blue,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'نوع الحساب',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedRole == 'merchant' ? 'تاجر' : 'عميل',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedRole == 'merchant'
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // حقول إضافية للتاجر
                  if (_selectedRole == 'merchant') ...[
                    TextFormField(
                      controller: _storeNameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المتجر *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.storefront),
                      ),
                      validator: (value) {
                        if (_selectedRole == 'merchant' &&
                            (value == null || value.trim().isEmpty)) {
                          return 'الرجاء إدخال اسم المتجر';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'المدينة *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator: (value) {
                        if (_selectedRole == 'merchant' &&
                            (value == null || value.trim().isEmpty)) {
                          return 'الرجاء إدخال المدينة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ],

                // حقل البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'البريد الإلكتروني غير صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // حقل كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
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
                const SizedBox(height: 32),

                // زر الإرسال
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          _isSignUp ? 'إنشاء الحساب' : 'تسجيل الدخول',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                // زر التبديل بين تسجيل دخول وتسجيل جديد
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                            _displayNameController.clear();
                          });
                        },
                  child: Text(
                    _isSignUp
                        ? 'لديك حساب؟ تسجيل الدخول'
                        : 'ليس لديك حساب؟ إنشاء حساب جديد',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 64),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
