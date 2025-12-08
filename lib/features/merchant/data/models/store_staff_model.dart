/// نموذج موظفي المتجر (Store Staff)
/// TODO: إكمال التنفيذ عند الحاجة
class StoreStaffModel {
  final String id;
  final String storeId;
  final String userId;
  final String role; // 'manager', 'staff', 'cashier', 'delivery'
  final List<String> permissions; // قائمة الصلاحيات
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActiveAt;

  // معلومات المستخدم (joined)
  final String? userName;
  final String? userEmail;
  final String? userPhone;

  StoreStaffModel({
    required this.id,
    required this.storeId,
    required this.userId,
    required this.role,
    required this.permissions,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.lastActiveAt,
    this.userName,
    this.userEmail,
    this.userPhone,
  });

  factory StoreStaffModel.fromJson(Map<String, dynamic> json) {
    return StoreStaffModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      permissions: List<String>.from(json['permissions'] ?? []),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'] as String)
          : null,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      userPhone: json['user_phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_id': userId,
      'role': role,
      'permissions': permissions,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
    };
  }
}

/// تعريف دور الموظف (Staff Role)
class StaffRole {
  final String id;
  final String name;
  final String? nameAr;
  final List<String> permissions;
  final String? description;

  StaffRole({
    required this.id,
    required this.name,
    this.nameAr,
    required this.permissions,
    this.description,
  });

  factory StaffRole.fromJson(Map<String, dynamic> json) {
    return StaffRole(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      permissions: List<String>.from(json['permissions'] ?? []),
      description: json['description'] as String?,
    );
  }
}

