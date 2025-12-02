import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// خدمة Gemini AI للتطبيق
class GeminiService {
  static GenerativeModel? _model;
  static GenerativeModel? _visionModel;
  static bool _isInitialized = false;

  /// تهيئة خدمة Gemini
  static Future<void> initialize() async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY غير موجود في ملف .env');
      }

      // نموذج النص السريع
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        ),
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(
            HarmCategory.sexuallyExplicit,
            HarmBlockThreshold.medium,
          ),
          SafetySetting(
            HarmCategory.dangerousContent,
            HarmBlockThreshold.medium,
          ),
        ],
      );

      // نموذج الرؤية (للصور)
      _visionModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      _isInitialized = true;
      debugPrint('✅ تم تهيئة Gemini AI بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة Gemini: $e');
      rethrow;
    }
  }

  /// التحقق من التهيئة
  static bool get isInitialized => _isInitialized;

  /// إنشاء محادثة جديدة
  static ChatSession createChat({List<Content>? history}) {
    if (!_isInitialized || _model == null) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }
    return _model!.startChat(history: history ?? []);
  }

  /// إرسال رسالة بسيطة
  static Future<String> sendMessage(String message) async {
    if (!_isInitialized || _model == null) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }

    try {
      final response = await _model!.generateContent([Content.text(message)]);
      return response.text ?? 'لم أتمكن من الإجابة';
    } on GenerativeAIException catch (e) {
      debugPrint('❌ خطأ في Gemini: ${e.message}');
      throw Exception('خطأ في الاتصال بالذكاء الاصطناعي: ${e.message}');
    }
  }

  /// إرسال رسالة مع streaming
  static Stream<String> sendMessageStream(String message) async* {
    if (!_isInitialized || _model == null) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }

    try {
      final stream = _model!.generateContentStream([Content.text(message)]);
      await for (final chunk in stream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } on GenerativeAIException catch (e) {
      debugPrint('❌ خطأ في Gemini Stream: ${e.message}');
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
    if (!_isInitialized || _visionModel == null) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }

    try {
      final response = await _visionModel!.generateContent([
        Content.multi([
          TextPart(
            'صف هذا المنتج بالتفصيل واقترح وصفاً تسويقياً له. الرد باللغة العربية فقط.',
          ),
          DataPart('image/jpeg', imageBytes),
        ]),
      ]);
      return response.text ?? 'لم أتمكن من تحليل الصورة';
    } on GenerativeAIException catch (e) {
      debugPrint('❌ خطأ في تحليل الصورة: ${e.message}');
      throw Exception('خطأ في تحليل الصورة');
    }
  }

  /// إنشاء مساعد خدمة العملاء
  static ChatSession createCustomerSupportChat() {
    final systemPrompt = Content.text('''
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
''');

    return createChat(history: [systemPrompt]);
  }

  /// إنشاء مساعد للتجار (mBuy Studio)
  static ChatSession createMerchantAssistantChat() {
    final systemPrompt = Content.text('''
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
''');

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

  /// عد Tokens
  static Future<int> countTokens(String text) async {
    if (!_isInitialized || _model == null) {
      throw Exception('يجب تهيئة GeminiService أولاً');
    }

    try {
      final count = await _model!.countTokens([Content.text(text)]);
      return count.totalTokens;
    } catch (e) {
      debugPrint('❌ خطأ في عد Tokens: $e');
      return 0;
    }
  }

  /// تنظيف الموارد
  static void dispose() {
    _model = null;
    _visionModel = null;
    _isInitialized = false;
  }
}
