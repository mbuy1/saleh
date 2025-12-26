/// Revenue Engine API Models
/// نماذج البيانات للتواصل مع Worker
library;

import 'package:flutter/material.dart';

// =====================================================
// Enums
// =====================================================

enum ProjectType {
  ugcVideo(
    'ugc_video',
    'UGC Video',
    'فيديو UGC',
    '👤',
    'فيديو بشخصية حقيقية أو افتراضية',
    299,
    Icons.videocam,
    Color(0xFFE91E63),
  ),
  motionGraphics(
    'motion_graphics',
    'Motion Graphics',
    'موشن جرافيك',
    '🎬',
    'فيديو رسوم متحركة احترافي',
    199,
    Icons.animation,
    Color(0xFF9C27B0),
  ),
  brandIdentity(
    'brand_identity',
    'Brand Identity',
    'هوية تجارية',
    '🎨',
    'تصميم هوية كاملة للعلامة التجارية',
    499,
    Icons.palette,
    Color(0xFF2196F3),
  ),
  fullCampaign(
    'full_campaign',
    'Full Campaign',
    'حملة متكاملة',
    '🚀',
    'حملة تسويقية شاملة متعددة القنوات',
    999,
    Icons.campaign,
    Color(0xFFFF9800),
  );

  final String value;
  final String displayName;
  final String displayNameAr;
  final String emoji;
  final String description;
  final int basePriceSAR;
  final IconData icon;
  final Color color;

  const ProjectType(
    this.value,
    this.displayName,
    this.displayNameAr,
    this.emoji,
    this.description,
    this.basePriceSAR,
    this.icon,
    this.color,
  );

  static ProjectType fromString(String value) {
    return ProjectType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProjectType.ugcVideo,
    );
  }
}

enum ProductionQuality {
  standard('standard', 'Standard', 'قياسي'),
  high('high', 'High', 'عالي'),
  ultra('ultra', 'Ultra', 'فائق');

  final String value;
  final String displayName;
  final String displayNameAr;

  const ProductionQuality(this.value, this.displayName, this.displayNameAr);

  static ProductionQuality fromString(String value) {
    return ProductionQuality.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProductionQuality.standard,
    );
  }
}

enum VideoDuration {
  seconds15('15', '15 ثانية', 15),
  seconds30('30', '30 ثانية', 30),
  seconds60('60', '60 ثانية', 60);

  final String value;
  final String displayName;
  final int seconds;

  const VideoDuration(this.value, this.displayName, this.seconds);

  static VideoDuration fromString(String value) {
    return VideoDuration.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VideoDuration.seconds15,
    );
  }
}

enum VoiceType {
  none('none', 'No Voice', 'بدون صوت'),
  aiArabic('ai_arabic', 'AI Arabic', 'صوت ذكي عربي'),
  aiEnglish('ai_english', 'AI English', 'صوت ذكي إنجليزي'),
  humanArabic('human_arabic', 'Human Arabic', 'صوت بشري عربي'),
  humanEnglish('human_english', 'Human English', 'صوت بشري إنجليزي');

  final String value;
  final String displayName;
  final String displayNameAr;

  const VoiceType(this.value, this.displayName, this.displayNameAr);

  static VoiceType fromString(String value) {
    return VoiceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VoiceType.none,
    );
  }
}

enum RevisionPolicy {
  basic('basic', 'Basic', 'أساسي', 1),
  standard('standard', 'Standard', 'قياسي', 2),
  professional('professional', 'Professional', 'احترافي', 3),
  unlimited('unlimited', 'Unlimited', 'غير محدود', -1);

  final String value;
  final String displayName;
  final String displayNameAr;
  final int freeRevisions;

  const RevisionPolicy(
    this.value,
    this.displayName,
    this.displayNameAr,
    this.freeRevisions,
  );

  static RevisionPolicy fromString(String value) {
    return RevisionPolicy.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RevisionPolicy.basic,
    );
  }
}

enum ProjectStatus {
  draft('draft', 'Draft', 'مسودة', '📝', Colors.grey),
  pendingPayment(
    'pending_payment',
    'Pending Payment',
    'بانتظار الدفع',
    '⏳',
    Colors.orange,
  ),
  paid('paid', 'Paid', 'مدفوع', '💰', Colors.green),
  inProgress('in_progress', 'In Progress', 'قيد التنفيذ', '🔄', Colors.blue),
  review('review', 'Under Review', 'قيد المراجعة', '👁️', Colors.purple),
  revision('revision', 'Revision', 'تعديل', '✏️', Colors.amber),
  approved('approved', 'Approved', 'معتمد', '✅', Colors.teal),
  locked('locked', 'Locked', 'مقفل', '🔒', Colors.red),
  completed('completed', 'Completed', 'مكتمل', '🎉', Colors.green),
  cancelled('cancelled', 'Cancelled', 'ملغي', '❌', Colors.grey);

  final String value;
  final String displayName;
  final String displayNameAr;
  final String emoji;
  final Color color;

  const ProjectStatus(
    this.value,
    this.displayName,
    this.displayNameAr,
    this.emoji,
    this.color,
  );

  static ProjectStatus fromString(String value) {
    return ProjectStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProjectStatus.draft,
    );
  }
}

enum PaymentType {
  cash('cash', 'Cash', 'نقدي'),
  points('points', 'Points', 'نقاط'),
  mixed('mixed', 'Mixed', 'مختلط');

  final String value;
  final String displayName;
  final String displayNameAr;

  const PaymentType(this.value, this.displayName, this.displayNameAr);

  static PaymentType fromString(String value) {
    return PaymentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentType.cash,
    );
  }
}

// =====================================================
// Data Models
// =====================================================

class PriceBreakdownItem {
  final String label;
  final String labelAr;
  final int amount;

  PriceBreakdownItem({
    required this.label,
    required this.labelAr,
    required this.amount,
  });

  factory PriceBreakdownItem.fromJson(Map<String, dynamic> json) {
    return PriceBreakdownItem(
      label: json['label'] ?? '',
      labelAr: json['labelAr'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'labelAr': labelAr,
    'amount': amount,
  };
}

class PricingQuote {
  final bool success;
  final int pricePoints;
  final int priceCash;
  final PaymentType paymentType;
  final int includedRevisions;
  final int maxGenerations;
  final bool locksAfterApproval;
  final List<PriceBreakdownItem> breakdown;
  final List<String> warnings;

  PricingQuote({
    required this.success,
    required this.pricePoints,
    required this.priceCash,
    required this.paymentType,
    required this.includedRevisions,
    required this.maxGenerations,
    required this.locksAfterApproval,
    required this.breakdown,
    required this.warnings,
  });

  factory PricingQuote.fromJson(Map<String, dynamic> json) {
    return PricingQuote(
      success: json['success'] ?? false,
      pricePoints: json['pricePoints'] ?? 0,
      priceCash: json['priceCash'] ?? 0,
      paymentType: PaymentType.fromString(json['paymentType'] ?? 'cash'),
      includedRevisions: json['includedRevisions'] ?? 1,
      maxGenerations: json['maxGenerations'] ?? 3,
      locksAfterApproval: json['locksAfterApproval'] ?? true,
      breakdown:
          (json['breakdown'] as List<dynamic>?)
              ?.map((e) => PriceBreakdownItem.fromJson(e))
              .toList() ??
          [],
      warnings: List<String>.from(json['warnings'] ?? []),
    );
  }

  bool get isCashOnly => paymentType == PaymentType.cash;
  bool get isPointsOnly => paymentType == PaymentType.points;

  String get formattedPrice {
    if (isCashOnly) {
      return '$priceCash ر.س';
    } else if (isPointsOnly) {
      return '$pricePoints نقطة';
    }
    return '$priceCash ر.س / $pricePoints نقطة';
  }
}

class ProjectStep {
  final String id;
  final int stepIndex;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final String inputType;
  final String? value;
  final bool isCompleted;
  final bool isLocked;
  final int generationCount;
  final int maxGenerations;

  ProjectStep({
    required this.id,
    required this.stepIndex,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.inputType,
    this.value,
    required this.isCompleted,
    required this.isLocked,
    required this.generationCount,
    required this.maxGenerations,
  });

  factory ProjectStep.fromJson(Map<String, dynamic> json) {
    return ProjectStep(
      id: json['id'] ?? 'step_${json['stepIndex'] ?? 0}',
      stepIndex: json['stepIndex'] ?? 0,
      title: json['title'] ?? '',
      titleAr: json['titleAr'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      inputType: json['inputType'] ?? 'text',
      value: json['value'],
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? false,
      generationCount: json['generationCount'] ?? 0,
      maxGenerations: json['maxGenerations'] ?? 3,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'stepIndex': stepIndex,
    'title': title,
    'titleAr': titleAr,
    'description': description,
    'descriptionAr': descriptionAr,
    'inputType': inputType,
    'value': value,
    'isCompleted': isCompleted,
    'isLocked': isLocked,
    'generationCount': generationCount,
    'maxGenerations': maxGenerations,
  };

  IconData get icon {
    switch (inputType) {
      case 'text':
        return Icons.edit_note;
      case 'image':
        return Icons.image;
      case 'video':
        return Icons.videocam;
      case 'file':
        return Icons.attach_file;
      case 'selection':
        return Icons.check_circle_outline;
      case 'ai_generate':
        return Icons.auto_awesome;
      default:
        return Icons.circle_outlined;
    }
  }
}

class PricingSnapshot {
  final int priceCash;
  final int pricePoints;
  final PaymentType paymentType;
  final int includedRevisions;
  final int maxGenerations;
  final List<PriceBreakdownItem> breakdown;
  final DateTime createdAt;

  // Original request details for display
  final ProductionQuality quality;
  final VideoDuration? duration;
  final VoiceType voiceType;
  final RevisionPolicy revisionPolicy;

  PricingSnapshot({
    required this.priceCash,
    required this.pricePoints,
    required this.paymentType,
    required this.includedRevisions,
    required this.maxGenerations,
    required this.breakdown,
    required this.createdAt,
    required this.quality,
    this.duration,
    required this.voiceType,
    required this.revisionPolicy,
  });

  factory PricingSnapshot.fromJson(Map<String, dynamic> json) {
    return PricingSnapshot(
      priceCash: json['priceCash'] ?? 0,
      pricePoints: json['pricePoints'] ?? 0,
      paymentType: PaymentType.fromString(json['paymentType'] ?? 'cash'),
      includedRevisions: json['includedRevisions'] ?? 1,
      maxGenerations: json['maxGenerations'] ?? 3,
      breakdown:
          (json['breakdown'] as List<dynamic>?)
              ?.map((e) => PriceBreakdownItem.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      quality: ProductionQuality.fromString(json['quality'] ?? 'standard'),
      duration: json['duration'] != null
          ? VideoDuration.fromString(json['duration'])
          : null,
      voiceType: VoiceType.fromString(json['voiceType'] ?? 'none'),
      revisionPolicy: RevisionPolicy.fromString(
        json['revisionPolicy'] ?? 'basic',
      ),
    );
  }
}

class Project {
  final String id;
  final String userId;
  final String? storeId;
  final String name;
  final ProjectType projectType;
  final String templateId;
  final VideoDuration? duration;
  final ProductionQuality quality;
  final VoiceType voiceType;
  final RevisionPolicy revisionPolicy;
  final List<String> extras;
  final PricingSnapshot pricingSnapshot;
  final ProjectStatus status;
  final int currentStepIndex;
  final List<ProjectStep> steps;
  final int revisionsUsed;
  final int totalGenerations;
  final bool isLocked;
  final DateTime? lockedAt;
  final String? lockedReason;
  final String? outputUrl;
  final List<String> outputFiles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;
  final DateTime? completedAt;

  Project({
    required this.id,
    required this.userId,
    this.storeId,
    required this.name,
    required this.projectType,
    required this.templateId,
    this.duration,
    required this.quality,
    required this.voiceType,
    required this.revisionPolicy,
    required this.extras,
    required this.pricingSnapshot,
    required this.status,
    required this.currentStepIndex,
    required this.steps,
    required this.revisionsUsed,
    required this.totalGenerations,
    required this.isLocked,
    this.lockedAt,
    this.lockedReason,
    this.outputUrl,
    required this.outputFiles,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
    this.completedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      storeId: json['storeId'],
      name: json['name'] ?? '',
      projectType: ProjectType.fromString(json['projectType'] ?? 'ugc_video'),
      templateId: json['templateId'] ?? '',
      duration: json['duration'] != null
          ? VideoDuration.fromString(json['duration'])
          : null,
      quality: ProductionQuality.fromString(json['quality'] ?? 'standard'),
      voiceType: VoiceType.fromString(json['voiceType'] ?? 'none'),
      revisionPolicy: RevisionPolicy.fromString(
        json['revisionPolicy'] ?? 'basic',
      ),
      extras: List<String>.from(json['extras'] ?? []),
      pricingSnapshot: PricingSnapshot.fromJson(json['pricingSnapshot'] ?? {}),
      status: ProjectStatus.fromString(json['status'] ?? 'draft'),
      currentStepIndex: json['currentStepIndex'] ?? 0,
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => ProjectStep.fromJson(e))
              .toList() ??
          [],
      revisionsUsed: json['revisionsUsed'] ?? 0,
      totalGenerations: json['totalGenerations'] ?? 0,
      isLocked: json['isLocked'] ?? false,
      lockedAt: json['lockedAt'] != null
          ? DateTime.parse(json['lockedAt'])
          : null,
      lockedReason: json['lockedReason'],
      outputUrl: json['outputUrl'],
      outputFiles: List<String>.from(json['outputFiles'] ?? []),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  bool get isPaid =>
      status != ProjectStatus.pendingPayment && status != ProjectStatus.draft;
  bool get canExecute => isPaid && !isLocked;
  bool get isComplete => status == ProjectStatus.completed;

  double get progressPercent {
    if (steps.isEmpty) return 0;
    final completed = steps.where((s) => s.isCompleted).length;
    return completed / steps.length;
  }

  int get remainingFreeRevisions {
    if (pricingSnapshot.includedRevisions == -1) return -1;
    return (pricingSnapshot.includedRevisions - revisionsUsed).clamp(
      0,
      pricingSnapshot.includedRevisions,
    );
  }

  bool get canRequestFreeRevision {
    if (isLocked) return false;
    if (pricingSnapshot.includedRevisions == -1) return true;
    return revisionsUsed < pricingSnapshot.includedRevisions;
  }

  ProjectStep? get currentStep {
    if (steps.isEmpty || currentStepIndex >= steps.length) return null;
    return steps[currentStepIndex];
  }

  int get generationCount => totalGenerations;
}

class ProjectTemplate {
  final String id;
  final ProjectType projectType;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String? thumbnailUrl;
  final String? demoUrl;
  final int basePriceSar;
  final List<String> supportedDurations;
  final List<String> supportedQualities;
  final bool isActive;
  final int sortOrder;

  ProjectTemplate({
    required this.id,
    required this.projectType,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    this.thumbnailUrl,
    this.demoUrl,
    required this.basePriceSar,
    required this.supportedDurations,
    required this.supportedQualities,
    required this.isActive,
    required this.sortOrder,
  });

  factory ProjectTemplate.fromJson(Map<String, dynamic> json) {
    return ProjectTemplate(
      id: json['id'] ?? '',
      projectType: ProjectType.fromString(json['project_type'] ?? 'ugc_video'),
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      demoUrl: json['demo_url'],
      basePriceSar: json['base_price_sar'] ?? 0,
      supportedDurations: List<String>.from(
        json['supported_durations'] ?? ['15', '30', '60'],
      ),
      supportedQualities: List<String>.from(
        json['supported_qualities'] ?? ['standard', 'high', 'ultra'],
      ),
      isActive: json['is_active'] ?? true,
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}

// =====================================================
// Request/Response Models
// =====================================================

class PricingQuoteRequest {
  final ProjectType projectType;
  final String templateId;
  final VideoDuration? duration;
  final ProductionQuality quality;
  final VoiceType voiceType;
  final RevisionPolicy revisionPolicy;
  final List<String>? extras;

  PricingQuoteRequest({
    required this.projectType,
    required this.templateId,
    this.duration,
    required this.quality,
    required this.voiceType,
    required this.revisionPolicy,
    this.extras,
  });

  Map<String, dynamic> toJson() => {
    'projectType': projectType.value,
    'templateId': templateId,
    if (duration != null) 'duration': duration!.value,
    'quality': quality.value,
    'voiceType': voiceType.value,
    'revisionPolicy': revisionPolicy.value,
    if (extras != null && extras!.isNotEmpty) 'extras': extras,
  };
}

class CreateProjectRequest {
  final ProjectType projectType;
  final String templateId;
  final String name;
  final VideoDuration? duration;
  final ProductionQuality quality;
  final VoiceType voiceType;
  final RevisionPolicy revisionPolicy;
  final List<String>? extras;

  CreateProjectRequest({
    required this.projectType,
    required this.templateId,
    required this.name,
    this.duration,
    required this.quality,
    required this.voiceType,
    required this.revisionPolicy,
    this.extras,
  });

  Map<String, dynamic> toJson() => {
    'projectType': projectType.value,
    'templateId': templateId,
    'name': name,
    if (duration != null) 'duration': duration!.value,
    'quality': quality.value,
    'voiceType': voiceType.value,
    'revisionPolicy': revisionPolicy.value,
    if (extras != null && extras!.isNotEmpty) 'extras': extras,
  };
}

class PaymentRequirement {
  final String type;
  final int amountCash;
  final int amountPoints;
  final String? reason;

  PaymentRequirement({
    required this.type,
    required this.amountCash,
    required this.amountPoints,
    this.reason,
  });

  factory PaymentRequirement.fromJson(Map<String, dynamic> json) {
    return PaymentRequirement(
      type: json['type'] ?? '',
      amountCash: json['amountCash'] ?? 0,
      amountPoints: json['amountPoints'] ?? 0,
      reason: json['reason'],
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final List<String> warnings;
  final PaymentRequirement? requiresPayment;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.warnings = const [],
    this.requiresPayment,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: fromJson != null && json['project'] != null
          ? fromJson(json['project'])
          : null,
      error: json['error'],
      warnings: List<String>.from(json['warnings'] ?? []),
      requiresPayment: json['requiresPayment'] != null
          ? PaymentRequirement.fromJson(json['requiresPayment'])
          : (json['paymentDetails'] != null
                ? PaymentRequirement.fromJson(json['paymentDetails'])
                : null),
    );
  }
}
