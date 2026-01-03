/// Store Model - نموذج المتجر
///
/// Represents a store/merchant in the MBUY platform
library;

class Store {
  final String id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String? logoUrl;
  final String? bannerUrl;
  final String? phone;
  final String? email;
  final String? website;
  final String? address;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String status;
  final bool isVerified;
  final double? rating;
  final int? reviewCount;
  final int? productsCount;
  final int? ordersCount;
  final int? followersCount;
  final String? category;
  final List<String> categories;
  final Map<String, dynamic>? workingHours;
  final Map<String, dynamic>? socialLinks;
  final Map<String, dynamic>? settings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Store({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.logoUrl,
    this.bannerUrl,
    this.phone,
    this.email,
    this.website,
    this.address,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.status = 'active',
    this.isVerified = false,
    this.rating,
    this.reviewCount,
    this.productsCount,
    this.ordersCount,
    this.followersCount,
    this.category,
    this.categories = const [],
    this.workingHours,
    this.socialLinks,
    this.settings,
    this.createdAt,
    this.updatedAt,
  });

  /// Create Store from JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    // Handle categories - could be array or nested
    List<String> categoryList = [];
    if (json['categories'] != null) {
      if (json['categories'] is List) {
        categoryList = (json['categories'] as List)
            .map((e) {
              if (e is String) return e;
              if (e is Map) return e['name']?.toString() ?? '';
              return e.toString();
            })
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    return Store(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['name_ar'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      logoUrl: json['logo_url'],
      bannerUrl: json['banner_url'] ?? json['cover_url'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      status: json['status'] ?? 'active',
      isVerified: json['is_verified'] ?? false,
      rating: json['rating']?.toDouble(),
      reviewCount: json['review_count'],
      productsCount: json['products_count'],
      ordersCount: json['orders_count'],
      followersCount: json['followers_count'],
      category: json['category'],
      categories: categoryList,
      workingHours: json['working_hours'],
      socialLinks: json['social_links'],
      settings: json['settings'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Convert Store to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'is_verified': isVerified,
      'rating': rating,
      'review_count': reviewCount,
      'products_count': productsCount,
      'categories': categories,
      'working_hours': workingHours,
      'social_links': socialLinks,
      'settings': settings,
    };
  }

  /// Check if store is active
  bool get isActive => status == 'active';

  /// Get display logo with fallback
  String get displayLogo =>
      logoUrl ?? 'https://via.placeholder.com/100?text=${name[0]}';

  /// Copy with modifications
  Store copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? logoUrl,
    String? bannerUrl,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? status,
    bool? isVerified,
    double? rating,
    int? reviewCount,
    int? productsCount,
    int? ordersCount,
    int? followersCount,
    String? category,
    List<String>? categories,
    Map<String, dynamic>? workingHours,
    Map<String, dynamic>? socialLinks,
    Map<String, dynamic>? settings,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      productsCount: productsCount ?? this.productsCount,
      ordersCount: ordersCount ?? this.ordersCount,
      followersCount: followersCount ?? this.followersCount,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      workingHours: workingHours ?? this.workingHours,
      socialLinks: socialLinks ?? this.socialLinks,
      settings: settings ?? this.settings,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Store && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Store($id: $name)';
}
