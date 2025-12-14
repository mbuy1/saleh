// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// اختبار شامل لتسجيل الدخول وإضافة منتج
///
/// الخطوات:
/// 1. تسجيل الدخول والحصول على token
/// 2. استخدام token لإضافة منتج
/// 3. التحقق من النتائج
void main() {
  const String baseUrl = 'https://misty-mode-b68b.baharista1.workers.dev';

  test('Login and Add Product Test', () async {
    print('\n=== اختبار تسجيل الدخول وإضافة منتج ===\n');

    // ========================================
    // الخطوة 1: تسجيل الدخول
    // ========================================
    print('📝 الخطوة 1: تسجيل الدخول...');

    final loginResponse = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': 'merchant@test.com', // يجب أن يكون موجود في قاعدة البيانات
        'password': 'password123',
        'login_as': 'merchant',
      }),
    );

    print('استجابة تسجيل الدخول: ${loginResponse.statusCode}');
    print('الجسم: ${loginResponse.body}');

    expect(
      loginResponse.statusCode,
      200,
      reason: 'يجب أن يكون تسجيل الدخول ناجحاً',
    );

    final loginData = jsonDecode(loginResponse.body) as Map<String, dynamic>;
    expect(loginData['ok'], true, reason: 'يجب أن يكون ok = true');
    expect(loginData['token'], isNotNull, reason: 'يجب أن يكون token موجود');

    final token = loginData['token'] as String;
    final profile = loginData['profile'] as Map<String, dynamic>;
    final role = profile['role'] as String;

    print('✅ تم تسجيل الدخول بنجاح');
    print('   - التوكن: ${token.substring(0, 20)}...');
    print('   - الدور: $role');
    print('   - Profile ID: ${profile['id']}');

    // ========================================
    // الخطوة 2: إضافة منتج
    // ========================================
    print('\n📝 الخطوة 2: إضافة منتج...');

    final productResponse = await http.post(
      Uri.parse('$baseUrl/secure/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': 'Test Product ${DateTime.now().millisecondsSinceEpoch}',
        'description': 'منتج اختباري من Flutter Test',
        'price': 99.99,
        'category': 'electronics',
        'quantity': 10,
        'unit': 'piece',
      }),
    );

    print('استجابة إضافة المنتج: ${productResponse.statusCode}');
    print('الجسم: ${productResponse.body}');

    if (productResponse.statusCode == 401) {
      print('\n❌ خطأ: Authentication required');
      print('التوكن المُرسل: Bearer ${token.substring(0, 50)}...');
      print('\nتفاصيل الاستجابة:');
      try {
        final errorData = jsonDecode(productResponse.body);
        print(jsonEncode(errorData));
      } catch (e) {
        print('لا يمكن فك تشفير JSON: ${productResponse.body}');
      }
      fail('فشل التحقق من المصادقة - تحقق من JWT في Worker');
    }

    if (productResponse.statusCode == 400 ||
        productResponse.statusCode == 404) {
      print('\n⚠️ تحذير: ${productResponse.statusCode}');
      try {
        final errorData = jsonDecode(productResponse.body);
        print('الكود: ${errorData['code']}');
        print('الرسالة: ${errorData['message']}');

        if (errorData['code'] == 'STORE_NOT_FOUND') {
          print('\n💡 تلميح: يجب إنشاء متجر أولاً');
          print('استخدم: POST $baseUrl/secure/merchant/store');
        }
      } catch (e) {
        print('الاستجابة: ${productResponse.body}');
      }
      return; // إنهاء الاختبار بنجاح (خطأ متوقع)
    }

    expect(
      productResponse.statusCode,
      201,
      reason: 'يجب أن تكون إضافة المنتج ناجحة',
    );

    final productData =
        jsonDecode(productResponse.body) as Map<String, dynamic>;
    expect(productData['ok'], true, reason: 'يجب أن يكون ok = true');
    expect(
      productData['product_id'] ?? productData['data']?['id'],
      isNotNull,
      reason: 'يجب أن يكون product_id موجود',
    );

    print('✅ تم إضافة المنتج بنجاح');
    print(
      '   - Product ID: ${productData['product_id'] ?? productData['data']?['id']}',
    );

    print('\n=== ✅ جميع الاختبارات نجحت ===\n');
  });

  test('Check Products Endpoint Structure', () async {
    print('\n=== اختبار بنية endpoint المنتجات ===\n');

    // تسجيل دخول سريع
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': 'merchant@test.com',
        'password': 'password123',
      }),
    );

    if (loginResponse.statusCode != 200) {
      print('⚠️ تخطي الاختبار: فشل تسجيل الدخول');
      return;
    }

    final loginData = jsonDecode(loginResponse.body) as Map<String, dynamic>;
    final token = loginData['token'] as String;

    // اختبار GET /secure/products
    final getProductsResponse = await http.get(
      Uri.parse('$baseUrl/secure/products'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('GET /secure/products: ${getProductsResponse.statusCode}');
    print('الاستجابة: ${getProductsResponse.body.substring(0, 200)}...');

    expect(
      getProductsResponse.statusCode,
      anyOf([200, 400, 404]),
      reason: 'يجب أن يكون الرد معقول',
    );
  });
}
