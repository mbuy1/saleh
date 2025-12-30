# 📊 Database Overview - MBuy Platform

> ملخص سريع لقاعدة البيانات. للتفاصيل الكاملة راجع [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md)

## 📈 إحصائيات
- **إجمالي الجداول:** 149 جدول
- **قاعدة البيانات:** Supabase (PostgreSQL)

---

## 👥 إدارة المستخدمين (User Management)

| الجدول | الوصف | الأعمدة الرئيسية |
|--------|-------|------------------|
| `customers` | العملاء | id, email, phone, password_hash, status |
| `merchants` | التجار/المتاجر | id, name, email, password_hash, status |
| `merchant_users` | موظفي المتجر | id, merchant_id, email, password_hash, role |
| `admin_staff` | مدراء النظام | id, email, password_hash, is_active |
| `admin_roles` | صلاحيات المدراء | id, merchant_id, name |
| `admin_staff_roles` | ربط المدراء بالصلاحيات | staff_id, role_id |

### 🔐 ملاحظة المصادقة
جميع جداول المستخدمين تحتوي على `password_hash` - المصادقة تتم عبر Worker وليس Supabase Auth.

---

## 📦 المنتجات (Products)

| الجدول | الوصف | العلاقات |
|--------|-------|----------|
| `products` | المنتجات الرئيسية | → merchants (store_id, merchant_id) |
| `product_variants` | المتغيرات (ألوان/مقاسات) | → products |
| `product_categories` | التصنيفات | store_id |
| `product_category_assignments` | ربط المنتج بالتصنيف | product_id, category_id |
| `product_media` | صور وفيديو | → products |
| `product_options` | خيارات (مثل اللون) | → products |
| `product_option_values` | قيم الخيارات | → product_options |
| `product_attributes` | سمات المنتج | store_id |
| `product_attribute_values` | قيم السمات | → products, → product_attributes |
| `product_pricing` | التسعير | → products |
| `product_inventory_settings` | إعدادات المخزون | → products |

### ENUMs المنتجات
- `product_type`: simple, variable, digital, service, bundle
- `product_status`: draft, active, inactive, archived

---

## 🛒 الطلبات (Orders)

| الجدول | الوصف | العلاقات |
|--------|-------|----------|
| `orders` | الطلبات | → merchants, → customers |
| `order_items` | عناصر الطلب | → orders |
| `order_addresses` | عناوين التوصيل | → orders |
| `order_payments` | المدفوعات | → orders |
| `order_shipments` | الشحنات | → orders |
| `order_refunds` | المرتجعات | → orders |
| `order_status_history` | تاريخ الحالة | → orders |

### ENUMs الطلبات
- `order_status`: pending, paid, processing, shipped, delivered, cancelled, refunded, failed
- `order_source`: web, mobile, pos, api

---

## 📊 المخزون (Inventory)

| الجدول | الوصف |
|--------|-------|
| `inventory_items` | المخزون الأساسي |
| `inventory_movements` | حركات المخزون |
| `inventory_reservations` | الحجوزات |
| `inventory_batches` | الدفعات |
| `warehouses` | المستودعات |
| `warehouse_locations` | مواقع داخل المستودع |
| `inventory_items_advanced` | مخزون متقدم (multi-warehouse) |

---

## 💳 المدفوعات (Payments)

| الجدول | الوصف |
|--------|-------|
| `payment_providers` | مزودي الدفع (Moyasar, etc) |
| `payment_methods` | طرق الدفع |
| `payment_transactions` | المعاملات |
| `payment_logs` | سجلات الدفع |
| `merchant_payment_accounts` | حسابات الدفع للتجار |

---

## 🚚 الشحن (Shipping)

| الجدول | الوصف |
|--------|-------|
| `shipping_providers` | شركات الشحن |
| `shipping_zones` | مناطق الشحن |
| `shipping_rates` | أسعار الشحن |
| `shipping_labels` | بوالص الشحن |
| `shipping_pickups` | مواعيد الاستلام |

---

## 🎯 التسويق (Marketing)

| الجدول | الوصف |
|--------|-------|
| `coupons` | الكوبونات |
| `coupon_uses` | استخدامات الكوبون |
| `marketing_campaigns` | الحملات |
| `marketing_coupons` | كوبونات التسويق |
| `marketing_discounts` | الخصومات |
| `marketing_ab_tests` | اختبارات A/B |
| `marketing_popups` | النوافذ المنبثقة |
| `marketing_landing_pages` | صفحات الهبوط |

---

## ⭐ الولاء (Loyalty)

| الجدول | الوصف |
|--------|-------|
| `loyalty_programs` | برامج الولاء |
| `loyalty_points` | النقاط |
| `loyalty_tiers` | المستويات |
| `loyalty_rewards` | المكافآت |
| `loyalty_redemptions` | الاستبدالات |

---

## 📈 التحليلات (Analytics)

| الجدول | الوصف |
|--------|-------|
| `analytics_events` | الأحداث |
| `analytics_daily` | تقارير يومية |
| `analytics_products` | تحليلات المنتجات |
| `analytics_customers` | تحليلات العملاء |
| `analytics_customer_metrics` | مقاييس العملاء |
| `analytics_product_metrics` | مقاييس المنتجات |

---

## 🤖 الذكاء الاصطناعي (AI)

| الجدول | الوصف |
|--------|-------|
| `ai_tasks` | مهام AI |
| `ai_predictions` | التنبؤات |
| `ai_recommendations` | التوصيات |
| `ai_embeddings` | Vectors للبحث |
| `ai_logs` | سجلات AI |

---

## 🎓 الدورات (Courses)

| الجدول | الوصف |
|--------|-------|
| `courses` | الدورات |
| `course_sections` | الأقسام |
| `course_lessons` | الدروس |
| `course_enrollments` | التسجيلات |
| `course_progress` | التقدم |
| `course_certificates` | الشهادات |

---

## 📦 الباقات (Bundles)

| الجدول | الوصف |
|--------|-------|
| `bundles` | الباقات |
| `bundle_items` | عناصر الباقة |
| `bundle_pricing_rules` | قواعد التسعير |
| `bundle_analytics` | تحليلات الباقات |

---

## 🤝 الشراكات (Affiliates)

| الجدول | الوصف |
|--------|-------|
| `affiliates` | المسوقين |
| `affiliate_links` | روابط التسويق |
| `affiliate_commissions` | العمولات |
| `affiliate_payouts` | المدفوعات |
| `affiliate_events` | الأحداث |

---

## 🔔 الرسائل (Messaging)

| الجدول | الوصف |
|--------|-------|
| `messaging_providers` | مزودي الرسائل |
| `messaging_templates` | القوالب |
| `messaging_messages` | الرسائل |
| `messaging_automations` | الأتمتة |
| `messaging_events` | الأحداث |

---

## 🎫 الدعم الفني (Support)

| الجدول | الوصف |
|--------|-------|
| `support_tickets` | التذاكر |
| `support_messages` | الرسائل |
| `support_categories` | التصنيفات |
| `support_articles` | المقالات |
| `support_attachments` | المرفقات |

---

## 📝 المدونة (Blog)

| الجدول | الوصف |
|--------|-------|
| `blog_posts` | المقالات |
| `blog_categories` | التصنيفات |
| `blog_tags` | الوسوم |
| `blog_post_tags` | ربط الوسوم |
| `blog_comments` | التعليقات |

---

## ⭐ التقييمات (Reviews)

| الجدول | الوصف |
|--------|-------|
| `reviews` | التقييمات |
| `review_media` | صور التقييم |
| `review_replies` | الردود |
| `merchant_reviews` | تقييمات المتاجر |

---

## 🔄 الاشتراكات (Subscriptions)

| الجدول | الوصف |
|--------|-------|
| `subscription_plans` | الخطط |
| `subscriptions` | الاشتراكات |
| `subscription_invoices` | الفواتير |
| `subscription_payments` | المدفوعات |
| `subscription_events` | الأحداث |

---

## 📦 Dropshipping

| الجدول | الوصف |
|--------|-------|
| `ds_suppliers` | الموردين |
| `ds_products` | المنتجات |
| `ds_variants` | المتغيرات |
| `ds_orders` | الطلبات |
| `ds_order_items` | عناصر الطلب |
| `ds_sync_logs` | سجلات المزامنة |

---

## 🚚 التوصيل (Delivery)

| الجدول | الوصف |
|--------|-------|
| `delivery_providers` | مزودي التوصيل |
| `delivery_zones` | المناطق |
| `delivery_rates` | الأسعار |
| `delivery_webhooks` | Webhooks |

---

## ⚙️ الإعدادات (Settings)

| الجدول | الوصف |
|--------|-------|
| `merchant_settings` | إعدادات المتجر |
| `merchant_billing` | الفواتير |
| `merchant_feature_activations` | الميزات |
| `settings_taxes` | الضرائب |
| `settings_currency` | العملات |
| `settings_localization` | اللغات |
| `settings_checkout` | الدفع |

---

## 🔗 Webhooks

| الجدول | الوصف |
|--------|-------|
| `webhooks_endpoints` | نقاط النهاية |
| `webhooks_logs` | السجلات |
| `webhooks_retry_queue` | قائمة إعادة المحاولة |

---

## 📁 الملفات (Files)

| الجدول | الوصف |
|--------|-------|
| `files_storage` | الملفات |
| `files_usage` | استخدام الملفات |

---

## 🔍 البحث (Search)

| الجدول | الوصف |
|--------|-------|
| `search_logs` | سجلات البحث |
| `search_filters` | الفلاتر |
| `search_ranking_rules` | قواعد الترتيب |

---

## 💬 الدردشة (Chat)

| الجدول | الوصف |
|--------|-------|
| `chat_threads` | المحادثات |
| `chat_messages` | الرسائل |

---

## 🏪 Marketplace

| الجدول | الوصف |
|--------|-------|
| `marketplace_settings` | إعدادات السوق |
| `marketplace_owners` | مالكي السوق |
| `merchant_badges` | شارات التجار |
| `merchant_badges_assignments` | تعيين الشارات |
| `merchant_followers` | متابعي المتاجر |

---

## 📋 السجلات (Logs)

| الجدول | الوصف |
|--------|-------|
| `audit_logs` | سجل التدقيق |
| `admin_activity_logs` | نشاط المدراء |

---

## 🔑 العلاقات الرئيسية

```
merchants (المتاجر)
├── products → store_id, merchant_id
├── orders → store_id, merchant_id
├── customers → (عبر orders)
├── merchant_users → merchant_id
├── inventory_items → merchant_id
└── [معظم الجداول] → merchant_id

customers (العملاء)
├── orders → customer_id
├── customer_addresses → customer_id
├── reviews → customer_id
└── support_tickets → customer_id

products (المنتجات)
├── product_variants → product_id
├── product_media → product_id
├── order_items → product_id
├── inventory_items → product_id
└── reviews → product_id

orders (الطلبات)
├── order_items → order_id
├── order_addresses → order_id
├── order_payments → order_id
├── order_shipments → order_id
└── order_refunds → order_id
```

---

## 🔒 ملاحظات أمنية

1. **المصادقة**: جميع المستخدمين لديهم `password_hash` - نستخدم bcrypt
2. **التفويض**: كل جدول تقريباً لديه `merchant_id` للعزل
3. **RLS**: مفعّل على Supabase لكن Worker يستخدم service_role

---

> 📖 للتفاصيل الكاملة عن كل جدول (أعمدة، قيود، فهارس) راجع [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md)
