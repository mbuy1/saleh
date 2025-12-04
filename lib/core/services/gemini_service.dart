import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../supabase_client.dart';

/// خدمة Gemini AI للتطبيق (عبر Worker API)
/// ⚠️ تم تحديثها لاستخدام Worker بدلاً من الاتصال المباشر
class GeminiService {
  static String? _workerUrl;
  static bool _isInitialized = false;
  static final List<Map<String, String>> _chatHistory = [];

  /// تهيئة خدمة Gemini
  static Future<void> initialize() async {
    try {
      _workerUrl = dotenv.env['CF_WORKER_URL'];
      if (_workerUrl == null || _workerUrl!.isEmpty) {
        throw Exception('CF_WORKER_URL غير موجود في ملف .env');
      }

      _isInitialized = true;
      debugPrint('✅ تم تهيئة Gemini AI عبر Worker بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة Gemini: $e');
      rethrow;
    }
  }

  /// الحصول على Authorization header
  static Future<Map<String, String>> _getHeaders() async {
    final session = supabaseClient.auth.currentSession;
    if (session == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.accessToken}',
    };
  }

  /// التحقق من التهيئة
  static bool get isInitialized => _isInitialized;

  /// إنشاء محادثة جديدة (محاكاة للـ API القديم)
  static GeminiChatSession createChat({List<Map<String, String>>? history}) {
    if (!_isInitialized) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }
    return GeminiChatSession(history: history ?? []);
  }

  /// إرسال رسالة بسيطة
  static Future<String> sendMessage(String message, {String? model}) async {
    if (!_isInitialized) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }

    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_workerUrl/secure/ai/gemini/generate'),
        headers: headers,
        body: jsonEncode({
          'prompt': message,
          'model': model ?? 'gemini-1.5-flash',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'] ?? 'لم أتمكن من الإجابة';
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'خطأ في الاتصال بالذكاء الاصطناعي');
      }
    } catch (e) {
      debugPrint('❌ خطأ في Gemini: $e');
      throw Exception('خطأ في الاتصال بالذكاء الاصطناعي: $e');
    }
  }

  /// إرسال رسالة مع محادثة
  static Future<String> sendChatMessage(
    List<Map<String, String>> messages, {
    String? model,
  }) async {
    if (!_isInitialized) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }

    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_workerUrl/secure/ai/gemini/chat'),
        headers: headers,
        body: jsonEncode({
          'messages': messages,
          'model': model ?? 'gemini-1.5-flash',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'لم أتمكن من الإجابة';
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'خطأ في الاتصال بالذكاء الاصطناعي');
      }
    } catch (e) {
      debugPrint('❌ خطأ في Gemini Chat: $e');
      throw Exception('خطأ في الاتصال بالذكاء الاصطناعي');
    }
  }

  /// توليد وصف منتج
  static Future<String> generateProductDescription(
    String productName, {
    String? category,
  }) async {
    final prompt =
        '''
أنت مسوق محترف. اكتب وصفاً تسويقياً جذاباً وقصيراً (3-5 أسطر) للمنتج التالي:

المنتج: $productName
${category != null ? 'الفئة: $category' : ''}

الوصف يجب أن يكون:
- جذاب ومشوق
- يبرز فوائد المنتج
- مختصر وواضح
- بالعربية الفصحى
''';

    return await sendMessage(prompt);
  }

  /// تحليل صورة منتج
  static Future<String> analyzeProductImage(Uint8List imageBytes) async {
    if (!_isInitialized) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }

    try {
      final headers = await _getHeaders();
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('$_workerUrl/secure/ai/gemini/vision'),
        headers: headers,
        body: jsonEncode({
          'imageBase64': base64Image,
          'prompt':
              'صف هذا المنتج بالتفصيل واقترح وصفاً تسويقياً له. الرد باللغة العربية فقط.',
          'model': 'gemini-1.5-flash',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['analysis'] ?? 'لم أتمكن من تحليل الصورة';
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'خطأ في تحليل الصورة');
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحليل الصورة: $e');
      throw Exception('خطأ في تحليل الصورة');
    }
  }

  /// إنشاء مساعد خدمة العملاء
  static GeminiChatSession createCustomerSupportChat() {
    final systemPrompt = {
      'role': 'system',
      'content': '''
أنت مساعد خدمة عملاء لتطبيق mBuy - منصة تجارة إلكترونية سعودية.

دورك:
- مساعدة العملاء في استفساراتهم
- شرح طريقة الاستخدام
- حل المشاكل البسيطة
- توجيه العملاء للدعم الفني عند الحاجة

أسلوبك:
- ودود واحترافي
- الرد بالعربية الفصحى
- إجابات واضحة ومختصرة
- استخدام الإيموجي بشكل مناسب

معلومات عن mBuy:
- منصة للتجارة الإلكترونية
- يدعم العملاء والتجار
- يحتوي على نظام نقاط ومحفظة
- يدعم الكوبونات والعروض
''',
    };

    return createChat(history: [systemPrompt]);
  }

  /// إنشاء مساعد للتجار (mBuy Studio)
  static GeminiChatSession createMerchantAssistantChat() {
    final systemPrompt = {
      'role': 'system',
      'content': '''
أنت مساعد ذكي للتجار في mBuy Studio.

دورك:
- مساعدة التجار في إدارة متاجرهم
- اقتراحات لتحسين المبيعات
- نصائح تسويقية
- إنشاء أوصاف منتجات
- تحليل أداء المتجر
- مساعدة في إنشاء العروض والكوبونات

أسلوبك:
- احترافي وخبير
- نصائح عملية قابلة للتطبيق
- الرد بالعربية الفصحى
- استخدام الأمثلة والأرقام
- تحفيزي وإيجابي

معلومات:
- mBuy Studio هو قسم التجار
- يحتوي على لوحة تحكم متقدمة
- نظام نقاط للميزات المتقدمة
- تقارير وتحليلات مفصلة
''',
    };

    return createChat(history: [systemPrompt]);
  }

  /// توليد أفكار لتحسين المبيعات
  static Future<String> generateSalesImprovementIdeas(
    String storeName,
    String category,
  ) async {
    final prompt =
        '''
كمستشار تجاري، اقترح 5 أفكار عملية لزيادة مبيعات متجر "$storeName" في فئة "$category".

الأفكار يجب أن تكون:
- عملية وقابلة للتطبيق فوراً
- مناسبة للسوق السعودي
- مرقمة وواضحة
- مع شرح مختصر لكل فكرة
''';

    return await sendMessage(prompt);
  }

  /// اقتراح كوبونات
  static Future<String> suggestCouponStrategy(
    String productType,
    String targetAudience,
  ) async {
    final prompt =
        '''
اقترح استراتيجية كوبونات فعالة لـ:
- نوع المنتج: $productType
- الجمهور المستهدف: $targetAudience

الاقتراح يجب أن يتضمن:
- نوع الخصم المناسب (نسبة/قيمة ثابتة)
- مدة الكوبون
- شروط الاستخدام
- رسالة تسويقية للكوبون
''';

    return await sendMessage(prompt);
  }

  /// عد Tokens (تقدير تقريبي)
  static Future<int> countTokens(String text) async {
    // تقدير تقريبي: كلمة = ~1.3 token
    final words = text.split(RegExp(r'\s+')).length;
    return (words * 1.3).round();
  }

  /// تنظيف الموارد
  static void dispose() {
    _chatHistory.clear();
    _isInitialized = false;
  }
}

/// Session محادثة Gemini (محاكاة للـ API القديم)
class GeminiChatSession {
  final List<Map<String, String>> history;

  GeminiChatSession({required this.history});

  /// إرسال رسالة في المحادثة
  Future<String> sendMessage(String message) async {
    history.add({'role': 'user', 'content': message});

    final response = await GeminiService.sendChatMessage(history);

    history.add({'role': 'assistant', 'content': response});
    return response;
  }

  /// مسح المحادثة
  void clear() {
    history.clear();
  }
}
