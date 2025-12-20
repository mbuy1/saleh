import 'package:flutter/material.dart';

/// أنواع المنتجات المتاحة
enum ProductType {
  physical, // منتج مادي عادي
  digital, // منتج رقمي
  service, // خدمة حسب الطلب
  foodAndBeverage, // أكل ومشروبات
  subscription, // اشتراك
  ticket, // تذكرة/حجز
  customizable, // منتج قابل للتخصيص
}

/// معلومات نوع المنتج
class ProductTypeInfo {
  final ProductType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> specificFields;
  final bool hasStock;
  final bool hasWeight;
  final bool hasDelivery;
  final bool hasPrepTime;
  final bool hasDigitalFile;
  final bool hasVariants;

  const ProductTypeInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.specificFields,
    this.hasStock = true,
    this.hasWeight = false,
    this.hasDelivery = true,
    this.hasPrepTime = false,
    this.hasDigitalFile = false,
    this.hasVariants = false,
  });
}

/// تعريفات أنواع المنتجات
const Map<ProductType, ProductTypeInfo> productTypes = {
  ProductType.physical: ProductTypeInfo(
    type: ProductType.physical,
    name: 'منتج مادي',
    description: 'منتج يتم شحنه للعميل',
    icon: Icons.inventory_2,
    color: Color(0xFF2196F3),
    specificFields: ['weight', 'dimensions', 'shipping'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasVariants: true,
  ),
  ProductType.digital: ProductTypeInfo(
    type: ProductType.digital,
    name: 'منتج رقمي',
    description: 'ملفات، برامج، كتب إلكترونية',
    icon: Icons.cloud_download,
    color: Color(0xFF9C27B0),
    specificFields: ['file_url', 'file_type', 'download_limit'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
    hasDigitalFile: true,
  ),
  ProductType.service: ProductTypeInfo(
    type: ProductType.service,
    name: 'خدمة حسب الطلب',
    description: 'خدمات مثل التصميم، البرمجة، الاستشارات',
    icon: Icons.handyman,
    color: Color(0xFF4CAF50),
    specificFields: ['duration', 'delivery_time', 'revisions'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
    hasPrepTime: true,
  ),
  ProductType.foodAndBeverage: ProductTypeInfo(
    type: ProductType.foodAndBeverage,
    name: 'أكل ومشروبات',
    description: 'وجبات، حلويات، مشروبات',
    icon: Icons.restaurant,
    color: Color(0xFFFF9800),
    specificFields: ['prep_time', 'calories', 'ingredients', 'allergens'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasPrepTime: true,
    hasVariants: true,
  ),
  ProductType.subscription: ProductTypeInfo(
    type: ProductType.subscription,
    name: 'اشتراك',
    description: 'اشتراكات شهرية أو سنوية',
    icon: Icons.autorenew,
    color: Color(0xFF00BCD4),
    specificFields: ['billing_cycle', 'trial_days', 'features'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
  ),
  ProductType.ticket: ProductTypeInfo(
    type: ProductType.ticket,
    name: 'تذكرة / حجز',
    description: 'فعاليات، حجوزات، مواعيد',
    icon: Icons.confirmation_number,
    color: Color(0xFFE91E63),
    specificFields: ['event_date', 'location', 'seats', 'time_slots'],
    hasStock: true,
    hasWeight: false,
    hasDelivery: false,
  ),
  ProductType.customizable: ProductTypeInfo(
    type: ProductType.customizable,
    name: 'منتج قابل للتخصيص',
    description: 'منتجات يمكن للعميل تخصيصها',
    icon: Icons.tune,
    color: Color(0xFF795548),
    specificFields: ['customization_options', 'preview_enabled'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasPrepTime: true,
    hasVariants: true,
  ),
};
