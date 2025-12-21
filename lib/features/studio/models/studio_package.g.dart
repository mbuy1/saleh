// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageDefinition _$PackageDefinitionFromJson(Map<String, dynamic> json) =>
    _PackageDefinition(
      id: $enumDecode(_$PackageTypeEnumMap, json['id']),
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String,
      icon: json['icon'] as String,
      creditsCost: (json['creditsCost'] as num).toInt(),
      estimatedTimeMinutes: (json['estimatedTimeMinutes'] as num).toInt(),
      deliverables: (json['deliverables'] as List<dynamic>)
          .map((e) => PackageDeliverable.fromJson(e as Map<String, dynamic>))
          .toList(),
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      featuresAr: (json['featuresAr'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isPremium: json['isPremium'] as bool? ?? false,
      isPopular: json['isPopular'] as bool? ?? false,
    );

Map<String, dynamic> _$PackageDefinitionToJson(_PackageDefinition instance) =>
    <String, dynamic>{
      'id': _$PackageTypeEnumMap[instance.id]!,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'description': instance.description,
      'descriptionAr': instance.descriptionAr,
      'icon': instance.icon,
      'creditsCost': instance.creditsCost,
      'estimatedTimeMinutes': instance.estimatedTimeMinutes,
      'deliverables': instance.deliverables,
      'features': instance.features,
      'featuresAr': instance.featuresAr,
      'isPremium': instance.isPremium,
      'isPopular': instance.isPopular,
    };

const _$PackageTypeEnumMap = {
  PackageType.motionGraphics: 'motion_graphics',
  PackageType.vlog: 'vlog',
  PackageType.adCampaign: 'ad_campaign',
  PackageType.ugcVideo: 'ugc_video',
  PackageType.socialAds: 'social_ads',
  PackageType.brandIdentity: 'brand_identity',
};

_PackageDeliverable _$PackageDeliverableFromJson(Map<String, dynamic> json) =>
    _PackageDeliverable(
      type: json['type'] as String,
      format: json['format'] as String,
      quantity: (json['quantity'] as num).toInt(),
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String,
    );

Map<String, dynamic> _$PackageDeliverableToJson(_PackageDeliverable instance) =>
    <String, dynamic>{
      'type': instance.type,
      'format': instance.format,
      'quantity': instance.quantity,
      'description': instance.description,
      'descriptionAr': instance.descriptionAr,
    };

_PackageOrder _$PackageOrderFromJson(Map<String, dynamic> json) =>
    _PackageOrder(
      id: json['id'] as String,
      userId: json['userId'] as String,
      storeId: json['storeId'] as String,
      packageType: $enumDecode(_$PackageTypeEnumMap, json['packageType']),
      status: $enumDecode(_$PackageStatusEnumMap, json['status']),
      productId: json['productId'] as String?,
      productData: json['productData'] as Map<String, dynamic>,
      brandData: json['brandData'] as Map<String, dynamic>?,
      preferences: json['preferences'] as Map<String, dynamic>,
      deliverables:
          (json['deliverables'] as List<dynamic>?)
              ?.map(
                (e) => PackageDeliverableResult.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      currentStep: json['currentStep'] as String?,
      errorMessage: json['errorMessage'] as String?,
      creditsCost: (json['creditsCost'] as num).toInt(),
      creditsRefunded: (json['creditsRefunded'] as num?)?.toInt(),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PackageOrderToJson(_PackageOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'storeId': instance.storeId,
      'packageType': _$PackageTypeEnumMap[instance.packageType]!,
      'status': _$PackageStatusEnumMap[instance.status]!,
      'productId': instance.productId,
      'productData': instance.productData,
      'brandData': instance.brandData,
      'preferences': instance.preferences,
      'deliverables': instance.deliverables,
      'progress': instance.progress,
      'currentStep': instance.currentStep,
      'errorMessage': instance.errorMessage,
      'creditsCost': instance.creditsCost,
      'creditsRefunded': instance.creditsRefunded,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PackageStatusEnumMap = {
  PackageStatus.draft: 'draft',
  PackageStatus.pending: 'pending',
  PackageStatus.processing: 'processing',
  PackageStatus.completed: 'completed',
  PackageStatus.failed: 'failed',
  PackageStatus.cancelled: 'cancelled',
};

_PackageDeliverableResult _$PackageDeliverableResultFromJson(
  Map<String, dynamic> json,
) => _PackageDeliverableResult(
  id: json['id'] as String,
  type: json['type'] as String,
  format: json['format'] as String,
  url: json['url'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
  durationMs: (json['durationMs'] as num?)?.toInt(),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  metadata: json['metadata'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PackageDeliverableResultToJson(
  _PackageDeliverableResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'format': instance.format,
  'url': instance.url,
  'thumbnailUrl': instance.thumbnailUrl,
  'fileSizeBytes': instance.fileSizeBytes,
  'durationMs': instance.durationMs,
  'width': instance.width,
  'height': instance.height,
  'metadata': instance.metadata,
  'createdAt': instance.createdAt.toIso8601String(),
};

_ProductInputData _$ProductInputDataFromJson(
  Map<String, dynamic> json,
) => _ProductInputData(
  name: json['name'] as String,
  nameAr: json['nameAr'] as String?,
  description: json['description'] as String?,
  descriptionAr: json['descriptionAr'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  category: json['category'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  features:
      (json['features'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  targetAudience: json['targetAudience'] as String?,
  uniqueSellingPoints:
      (json['uniqueSellingPoints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProductInputDataToJson(_ProductInputData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nameAr': instance.nameAr,
      'description': instance.description,
      'descriptionAr': instance.descriptionAr,
      'price': instance.price,
      'currency': instance.currency,
      'category': instance.category,
      'images': instance.images,
      'features': instance.features,
      'targetAudience': instance.targetAudience,
      'uniqueSellingPoints': instance.uniqueSellingPoints,
    };

_BrandInputData _$BrandInputDataFromJson(Map<String, dynamic> json) =>
    _BrandInputData(
      storeName: json['storeName'] as String,
      storeNameAr: json['storeNameAr'] as String?,
      tagline: json['tagline'] as String?,
      taglineAr: json['taglineAr'] as String?,
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
      existingLogoUrl: json['existingLogoUrl'] as String?,
      industry: json['industry'] as String?,
      stylePreferences:
          (json['stylePreferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BrandInputDataToJson(_BrandInputData instance) =>
    <String, dynamic>{
      'storeName': instance.storeName,
      'storeNameAr': instance.storeNameAr,
      'tagline': instance.tagline,
      'taglineAr': instance.taglineAr,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'existingLogoUrl': instance.existingLogoUrl,
      'industry': instance.industry,
      'stylePreferences': instance.stylePreferences,
    };

_PackagePreferences _$PackagePreferencesFromJson(Map<String, dynamic> json) =>
    _PackagePreferences(
      language: json['language'] as String? ?? 'ar',
      tone: json['tone'] as String?,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      aspectRatio: json['aspectRatio'] as String?,
      platforms:
          (json['platforms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      musicStyle: json['musicStyle'] as String?,
      voiceGender: json['voiceGender'] as String?,
      includeSubtitles: json['includeSubtitles'] as bool? ?? false,
      customInstructions: json['customInstructions'] as String?,
    );

Map<String, dynamic> _$PackagePreferencesToJson(_PackagePreferences instance) =>
    <String, dynamic>{
      'language': instance.language,
      'tone': instance.tone,
      'durationSeconds': instance.durationSeconds,
      'aspectRatio': instance.aspectRatio,
      'platforms': instance.platforms,
      'musicStyle': instance.musicStyle,
      'voiceGender': instance.voiceGender,
      'includeSubtitles': instance.includeSubtitles,
      'customInstructions': instance.customInstructions,
    };
