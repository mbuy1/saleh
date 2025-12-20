import 'package:freezed_annotation/freezed_annotation.dart';
import 'scene.dart';

part 'template.freezed.dart';
part 'template.g.dart';

/// فئة القالب
enum TemplateCategory {
  @JsonValue('product_ad')
  productAd,
  @JsonValue('ugc')
  ugc,
  @JsonValue('promo')
  promo,
  @JsonValue('story')
  story,
}

/// تكوين مشهد في القالب
@freezed
abstract class SceneConfig with _$SceneConfig {
  const factory SceneConfig({
    @Default(SceneType.image) SceneType type,
    @Default(5000) int duration,
    @Default('') String prompt,
  }) = _SceneConfig;

  factory SceneConfig.fromJson(Map<String, dynamic> json) =>
      _$SceneConfigFromJson(json);
}

/// قالب الاستوديو
@freezed
abstract class StudioTemplate with _$StudioTemplate {
  const StudioTemplate._();

  const factory StudioTemplate({
    required String id,
    required String name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    @Default(TemplateCategory.productAd) TemplateCategory category,
    String? thumbnailUrl,
    String? previewVideoUrl,
    @Default([]) List<SceneConfig> scenesConfig,
    @Default(30) int durationSeconds,
    @Default('9:16') String aspectRatio,
    @Default(false) bool isPremium,
    @Default(false) bool isPro, // للتوافق مع template_card
    @Default(true) bool isActive,
    @Default(0) int usageCount,
    @Default(10) int creditsCost,
    @Default([]) List<String> tags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudioTemplate;

  factory StudioTemplate.fromJson(Map<String, dynamic> json) =>
      _$StudioTemplateFromJson(json);

  /// الاسم المعروض (عربي أو إنجليزي)
  String get displayName => nameAr ?? name;

  /// الوصف المعروض
  String get displayDescription => descriptionAr ?? description ?? '';

  /// عدد المشاهد
  int get scenesCount => scenesConfig.length;

  /// أيقونة الفئة
  String get categoryIcon {
    switch (category) {
      case TemplateCategory.productAd:
        return '📦';
      case TemplateCategory.ugc:
        return '🎭';
      case TemplateCategory.promo:
        return '🔥';
      case TemplateCategory.story:
        return '📱';
    }
  }

  /// اسم الفئة بالعربي
  String get categoryNameAr {
    switch (category) {
      case TemplateCategory.productAd:
        return 'إعلان منتج';
      case TemplateCategory.ugc:
        return 'محتوى UGC';
      case TemplateCategory.promo:
        return 'عرض ترويجي';
      case TemplateCategory.story:
        return 'قصة';
    }
  }
}

/// قوالب افتراضية للعرض
List<StudioTemplate> getDefaultTemplates() {
  final now = DateTime.now();
  return [
    StudioTemplate(
      id: 'template_1',
      name: 'Product Showcase',
      nameAr: 'عرض المنتج',
      description: 'Professional product showcase',
      descriptionAr: 'عرض احترافي للمنتج مع انتقالات سلسة',
      category: TemplateCategory.productAd,
      durationSeconds: 30,
      creditsCost: 10,
      scenesConfig: const [
        SceneConfig(type: SceneType.intro, duration: 3000, prompt: 'intro'),
        SceneConfig(type: SceneType.image, duration: 5000, prompt: 'hero'),
        SceneConfig(type: SceneType.image, duration: 5000, prompt: 'features'),
        SceneConfig(type: SceneType.cta, duration: 4000, prompt: 'cta'),
      ],
      tags: ['product', 'showcase'],
      createdAt: now,
      updatedAt: now,
    ),
    StudioTemplate(
      id: 'template_2',
      name: 'UGC Review',
      nameAr: 'مراجعة UGC',
      description: 'User-generated content style',
      descriptionAr: 'أسلوب محتوى المستخدم مع وجه متحدث',
      category: TemplateCategory.ugc,
      durationSeconds: 45,
      creditsCost: 20,
      isPremium: true,
      scenesConfig: const [
        SceneConfig(type: SceneType.ugc, duration: 8000, prompt: 'intro'),
        SceneConfig(type: SceneType.image, duration: 4000, prompt: 'product'),
        SceneConfig(type: SceneType.ugc, duration: 10000, prompt: 'benefits'),
        SceneConfig(type: SceneType.cta, duration: 5000, prompt: 'cta'),
      ],
      tags: ['ugc', 'review'],
      createdAt: now,
      updatedAt: now,
    ),
    StudioTemplate(
      id: 'template_3',
      name: 'Flash Sale',
      nameAr: 'عرض سريع',
      description: 'High-energy promotional video',
      descriptionAr: 'فيديو ترويجي عالي الطاقة للعروض',
      category: TemplateCategory.promo,
      durationSeconds: 15,
      creditsCost: 8,
      scenesConfig: const [
        SceneConfig(type: SceneType.text, duration: 2000, prompt: 'sale'),
        SceneConfig(type: SceneType.image, duration: 3000, prompt: 'product'),
        SceneConfig(type: SceneType.text, duration: 3000, prompt: 'discount'),
        SceneConfig(type: SceneType.cta, duration: 4000, prompt: 'limited'),
      ],
      tags: ['sale', 'promo'],
      createdAt: now,
      updatedAt: now,
    ),
    StudioTemplate(
      id: 'template_4',
      name: 'Instagram Story',
      nameAr: 'قصة انستقرام',
      description: 'Perfect for Instagram stories',
      descriptionAr: 'مثالي لتنسيق قصص انستقرام',
      category: TemplateCategory.story,
      durationSeconds: 15,
      creditsCost: 5,
      scenesConfig: const [
        SceneConfig(type: SceneType.image, duration: 3000, prompt: 'opener'),
        SceneConfig(type: SceneType.image, duration: 4000, prompt: 'highlight'),
        SceneConfig(type: SceneType.text, duration: 4000, prompt: 'message'),
        SceneConfig(type: SceneType.cta, duration: 4000, prompt: 'swipe'),
      ],
      tags: ['story', 'instagram'],
      createdAt: now,
      updatedAt: now,
    ),
  ];
}
