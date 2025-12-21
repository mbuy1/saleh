import 'package:freezed_annotation/freezed_annotation.dart';

part 'studio_package.freezed.dart';
part 'studio_package.g.dart';

/// أنواع الحزم
enum PackageType {
  @JsonValue('motion_graphics')
  motionGraphics,
  @JsonValue('vlog')
  vlog,
  @JsonValue('ad_campaign')
  adCampaign,
  @JsonValue('ugc_video')
  ugcVideo,
  @JsonValue('social_ads')
  socialAds,
  @JsonValue('brand_identity')
  brandIdentity,
}

/// حالة الطلب
enum PackageStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
}

/// تعريف الحزمة
@freezed
abstract class PackageDefinition with _$PackageDefinition {
  const factory PackageDefinition({
    required PackageType id,
    required String name,
    required String nameAr,
    required String description,
    required String descriptionAr,
    required String icon,
    required int creditsCost,
    required int estimatedTimeMinutes,
    required List<PackageDeliverable> deliverables,
    required List<String> features,
    required List<String> featuresAr,
    @Default(false) bool isPremium,
    @Default(false) bool isPopular,
  }) = _PackageDefinition;

  factory PackageDefinition.fromJson(Map<String, dynamic> json) =>
      _$PackageDefinitionFromJson(json);
}

/// محتوى التسليم
@freezed
abstract class PackageDeliverable with _$PackageDeliverable {
  const factory PackageDeliverable({
    required String type,
    required String format,
    required int quantity,
    required String description,
    required String descriptionAr,
  }) = _PackageDeliverable;

  factory PackageDeliverable.fromJson(Map<String, dynamic> json) =>
      _$PackageDeliverableFromJson(json);
}

/// طلب حزمة
@freezed
abstract class PackageOrder with _$PackageOrder {
  const factory PackageOrder({
    required String id,
    required String userId,
    required String storeId,
    required PackageType packageType,
    required PackageStatus status,
    String? productId,
    required Map<String, dynamic> productData,
    Map<String, dynamic>? brandData,
    required Map<String, dynamic> preferences,
    @Default([]) List<PackageDeliverableResult> deliverables,
    @Default(0) int progress,
    String? currentStep,
    String? errorMessage,
    required int creditsCost,
    int? creditsRefunded,
    DateTime? startedAt,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PackageOrder;

  factory PackageOrder.fromJson(Map<String, dynamic> json) =>
      _$PackageOrderFromJson(json);
}

/// نتيجة التسليم
@freezed
abstract class PackageDeliverableResult with _$PackageDeliverableResult {
  const factory PackageDeliverableResult({
    required String id,
    required String type,
    required String format,
    required String url,
    String? thumbnailUrl,
    int? fileSizeBytes,
    int? durationMs,
    int? width,
    int? height,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _PackageDeliverableResult;

  factory PackageDeliverableResult.fromJson(Map<String, dynamic> json) =>
      _$PackageDeliverableResultFromJson(json);
}

/// بيانات المنتج المدخلة
@freezed
abstract class ProductInputData with _$ProductInputData {
  const factory ProductInputData({
    required String name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    String? currency,
    String? category,
    @Default([]) List<String> images,
    @Default([]) List<String> features,
    String? targetAudience,
    @Default([]) List<String> uniqueSellingPoints,
  }) = _ProductInputData;

  factory ProductInputData.fromJson(Map<String, dynamic> json) =>
      _$ProductInputDataFromJson(json);
}

/// بيانات العلامة التجارية
@freezed
abstract class BrandInputData with _$BrandInputData {
  const factory BrandInputData({
    required String storeName,
    String? storeNameAr,
    String? tagline,
    String? taglineAr,
    String? primaryColor,
    String? secondaryColor,
    String? existingLogoUrl,
    String? industry,
    @Default([]) List<String> stylePreferences,
  }) = _BrandInputData;

  factory BrandInputData.fromJson(Map<String, dynamic> json) =>
      _$BrandInputDataFromJson(json);
}

/// تفضيلات الحزمة
@freezed
abstract class PackagePreferences with _$PackagePreferences {
  const factory PackagePreferences({
    @Default('ar') String language,
    String? tone,
    int? durationSeconds,
    String? aspectRatio,
    @Default([]) List<String> platforms,
    String? musicStyle,
    String? voiceGender,
    @Default(false) bool includeSubtitles,
    String? customInstructions,
  }) = _PackagePreferences;

  factory PackagePreferences.fromJson(Map<String, dynamic> json) =>
      _$PackagePreferencesFromJson(json);
}

/// الحزم الافتراضية (للعرض دون اتصال)
List<PackageDefinition> getDefaultPackages() => [
  const PackageDefinition(
    id: PackageType.motionGraphics,
    name: 'Motion Graphics',
    nameAr: 'موشن جرافيك',
    description: 'Professional animated video for your product',
    descriptionAr: 'فيديو متحرك احترافي لمنتجك',
    icon: 'movie_filter',
    creditsCost: 50,
    estimatedTimeMinutes: 15,
    deliverables: [
      PackageDeliverable(
        type: 'video',
        format: 'mp4',
        quantity: 1,
        description: '30s Motion Graphics Video',
        descriptionAr: 'فيديو موشن جرافيك 30 ثانية',
      ),
      PackageDeliverable(
        type: 'video',
        format: 'mp4',
        quantity: 1,
        description: '15s Short Version',
        descriptionAr: 'نسخة قصيرة 15 ثانية',
      ),
    ],
    features: [
      'AI-generated script',
      'Professional animations',
      'Background music',
    ],
    featuresAr: [
      'سيناريو بالذكاء الاصطناعي',
      'رسوم متحركة احترافية',
      'موسيقى خلفية',
    ],
    isPremium: false,
    isPopular: true,
  ),
  const PackageDefinition(
    id: PackageType.vlog,
    name: 'Vlog Video',
    nameAr: 'فلوق فيديو',
    description: 'AI presenter talking about your product',
    descriptionAr: 'مقدم ذكاء اصطناعي يتحدث عن منتجك',
    icon: 'person_play',
    creditsCost: 80,
    estimatedTimeMinutes: 20,
    deliverables: [
      PackageDeliverable(
        type: 'video',
        format: 'mp4',
        quantity: 1,
        description: '1-2 min Vlog Video',
        descriptionAr: 'فيديو فلوق 1-2 دقيقة',
      ),
    ],
    features: ['AI Avatar presenter', 'Natural voice', 'Product showcase'],
    featuresAr: ['مقدم أفاتار ذكي', 'صوت طبيعي', 'عرض المنتج'],
    isPremium: true,
    isPopular: false,
  ),
  const PackageDefinition(
    id: PackageType.adCampaign,
    name: 'Ad Campaign',
    nameAr: 'حملة إعلانية',
    description: 'Complete ad package for all platforms',
    descriptionAr: 'حزمة إعلانية كاملة لجميع المنصات',
    icon: 'campaign',
    creditsCost: 100,
    estimatedTimeMinutes: 25,
    deliverables: [
      PackageDeliverable(
        type: 'video',
        format: 'mp4',
        quantity: 3,
        description: 'Ad Videos (15s, 30s, 60s)',
        descriptionAr: 'فيديوهات إعلانية',
      ),
      PackageDeliverable(
        type: 'image',
        format: 'png',
        quantity: 5,
        description: 'Static Ad Images',
        descriptionAr: 'صور إعلانية ثابتة',
      ),
    ],
    features: ['Multi-platform formats', 'A/B variations', 'Ad copy included'],
    featuresAr: ['صيغ لجميع المنصات', 'نسخ A/B', 'نصوص إعلانية جاهزة'],
    isPremium: false,
    isPopular: true,
  ),
  const PackageDefinition(
    id: PackageType.ugcVideo,
    name: 'UGC Video',
    nameAr: 'فيديو UGC',
    description: 'User-generated content style review video',
    descriptionAr: 'فيديو مراجعة بأسلوب UGC',
    icon: 'video_camera_front',
    creditsCost: 70,
    estimatedTimeMinutes: 18,
    deliverables: [
      PackageDeliverable(
        type: 'video',
        format: 'mp4',
        quantity: 1,
        description: '30-60s UGC Review',
        descriptionAr: 'مراجعة UGC 30-60 ثانية',
      ),
    ],
    features: ['Realistic AI presenter', 'Authentic style', 'Call to action'],
    featuresAr: ['مقدم واقعي', 'أسلوب أصيل', 'دعوة للإجراء'],
    isPremium: true,
    isPopular: true,
  ),
  const PackageDefinition(
    id: PackageType.socialAds,
    name: 'Social Media Ads',
    nameAr: 'إعلانات سوشل ميديا',
    description: 'Ready-to-post content for all platforms',
    descriptionAr: 'محتوى جاهز للنشر',
    icon: 'share',
    creditsCost: 40,
    estimatedTimeMinutes: 10,
    deliverables: [
      PackageDeliverable(
        type: 'image',
        format: 'png',
        quantity: 10,
        description: 'Social Media Posts',
        descriptionAr: 'منشورات سوشل ميديا',
      ),
      PackageDeliverable(
        type: 'video',
        format: 'mp4',
        quantity: 3,
        description: 'Story/Reel Videos',
        descriptionAr: 'فيديوهات ستوري/ريلز',
      ),
    ],
    features: ['All platform sizes', 'Stories & Reels', 'Captions included'],
    featuresAr: ['جميع أحجام المنصات', 'ستوريز وريلز', 'نصوص جاهزة'],
    isPremium: false,
    isPopular: false,
  ),
  const PackageDefinition(
    id: PackageType.brandIdentity,
    name: 'Brand Identity',
    nameAr: 'هوية بصرية',
    description: 'Complete visual identity for your store',
    descriptionAr: 'هوية بصرية كاملة لمتجرك',
    icon: 'palette',
    creditsCost: 150,
    estimatedTimeMinutes: 30,
    deliverables: [
      PackageDeliverable(
        type: 'logo',
        format: 'svg',
        quantity: 1,
        description: 'Primary Logo',
        descriptionAr: 'الشعار الرئيسي',
      ),
      PackageDeliverable(
        type: 'image',
        format: 'png',
        quantity: 5,
        description: 'Social Media Kit',
        descriptionAr: 'حزمة سوشل ميديا',
      ),
      PackageDeliverable(
        type: 'document',
        format: 'pdf',
        quantity: 1,
        description: 'Brand Guidelines',
        descriptionAr: 'دليل الهوية البصرية',
      ),
    ],
    features: [
      'Logo design',
      'Color palette',
      'Typography',
      'Brand guidelines',
    ],
    featuresAr: ['تصميم الشعار', 'لوحة الألوان', 'الخطوط', 'دليل الهوية'],
    isPremium: true,
    isPopular: true,
  ),
];
