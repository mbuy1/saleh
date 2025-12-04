import 'package:flutter/material.dart';
import '../../data/auth_service.dart';
import '../../../../core/supabase_client.dart';

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
  String _selectedRole = 'customer'; // 'customer' أو 'merchant'

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
        final user = await AuthService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim(),
          role: _selectedRole,
          storeName: _selectedRole == 'merchant'
              ? _storeNameController.text.trim()
              : null,
          city: _selectedRole == 'merchant'
              ? _cityController.text.trim()
              : null,
        );

        if (mounted) {
          debugPrint('✅ تم تسجيل المستخدم: ${user.email}');

          // التحقق من وجود جلسة بعد التسجيل
          final session = supabaseClient.auth.currentSession;
          if (session != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم التسجيل بنجاح! جاري تحميل التطبيق...'),
                backgroundColor: Colors.green,
              ),
            );
            // الانتظار قليلاً ثم إعادة بناء
            await Future.delayed(const Duration(milliseconds: 500));
          } else {
            // إذا لم تكن هناك جلسة، قد يتطلب تأكيد البريد
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

        final session = await AuthService.signIn(
          email: email,
          password: password,
        );

        if (mounted) {
          debugPrint('✅ تم تسجيل الدخول: ${session.user.email}');
          debugPrint('✅ Session expires: ${session.expiresAt}');

          // التحقق من أن Session محفوظة
          final currentSession = supabaseClient.auth.currentSession;
          if (currentSession != null) {
            debugPrint('✅ Session محفوظة بنجاح');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تسجيل الدخول بنجاح! جاري تحميل التطبيق...'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            // الانتظار قليلاً ثم إعادة بناء
            await Future.delayed(const Duration(milliseconds: 1000));
          } else {
            debugPrint('⚠️ Session غير محفوظة - إعادة المحاولة...');
            throw Exception('فشل حفظ الجلسة. يرجى المحاولة مرة أخرى.');
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
                const SizedBox(height: 60),

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
                      ? 'أنشئ حسابك للبدء في استخدام التطبيق'
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

                  // اختيار نوع الحساب
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'نوع الحساب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _selectedRole = 'customer'),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'customer'
                                        ? Colors.blue.shade50
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: _selectedRole == 'customer'
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag,
                                        color: _selectedRole == 'customer'
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'عميل',
                                        style: TextStyle(
                                          fontWeight:
                                              _selectedRole == 'customer'
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: _selectedRole == 'customer'
                                              ? Colors.blue
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _selectedRole = 'merchant'),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'merchant'
                                        ? Colors.green.shade50
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: _selectedRole == 'merchant'
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.store,
                                        color: _selectedRole == 'merchant'
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'تاجر',
                                        style: TextStyle(
                                          fontWeight:
                                              _selectedRole == 'merchant'
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: _selectedRole == 'merchant'
                                              ? Colors.green
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
}
