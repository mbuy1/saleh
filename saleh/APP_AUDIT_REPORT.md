# 📊 APP_AUDIT_REPORT - Saleh (MBUY Merchant)
## تقرير فحص شامل للتطبيق

> **تاريخ الفحص:** 2025-12-24  
> **نوع التطبيق:** Flutter (Merchant Dashboard)  
> **حالة الفحص:** ✅ مكتمل - تحليل شامل بدون تعديلات

---

## 📋 Summary (ملخص تنفيذي)

| البند | الحالة | التفاصيل |
|-------|--------|----------|
| **إجمالي الشاشات** | **85+** | شاشات/صفحات/تبويبات |
| **Routes مسجلة** | **54+** | في GoRouter |
| **Entry Points** | **1** | `main.dart` → `AppShell` |
| **MaterialApp instances** | **3** | (1 للـ Router + 2 للحالات الخاصة) |
| **شاشات مكررة** | **2** | يحتاج مراجعة |
| **شاشات غير مستخدمة** | **8+** | Dead Screens |
| **Routes معطلة** | **1** | Redirect Route |

### 🚨 مشاكل تحتاج إصلاح فوري:
1. **8+ شاشات موجودة لكن غير مربوطة بأي Route**
2. **2 ملفات مكررة (backup)**
3. **2 شاشات LoginScreen متطابقة** (shared vs auth)
4. **1 Route redirect** (`/dashboard/promotions` → `/dashboard`)

### ✅ آخر التحديثات (25 ديسمبر 2025):
1. **البار السفلي:** تم تثبيته على 4 تبويبات فقط (الرئيسية، الطلبات، المنتجات، استديو AI)
2. **المحادثات:** تم نقلها من البار السفلي - الوصول عبر أيقونة الإشعارات في الهيدر
3. **Dropshipping:** تم حذف الميزة نهائياً (Routes، Screens، References)

---

## 1️⃣ Inventory للشاشات والصفحات

### 📂 features/auth/presentation/screens/ (3 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `LoginScreen` | `login_screen.dart` | ✅ مستخدم في Route `/login` |
| `RegisterScreen` | `register_screen.dart` | ✅ مستخدم في Route `/register` |
| `ForgotPasswordScreen` | `forgot_password_screen.dart` | ✅ مستخدم في Route `/forgot-password` |

### 📂 features/dashboard/presentation/screens/ (12 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `DashboardShell` | `dashboard_shell.dart` | ✅ Shell للـ Navigation |
| `HomeTab` | `home_tab.dart` | ✅ مستخدم في Route `/dashboard` |
| `OrdersTab` | `orders_tab.dart` | ✅ مستخدم في Route `/dashboard/orders` |
| `ProductsTab` | `products_tab.dart` | ✅ مستخدم في Route `/dashboard/products` |
| `CustomersScreen` | `customers_screen.dart` | ✅ مستخدم في Route `/dashboard/customers` |
| `MerchantServicesScreen` | `merchant_services_screen.dart` | ✅ مستخدم في Route `/dashboard/store-management` |
| `MbuyToolsScreen` | `mbuy_tools_screen.dart` | ✅ مستخدم في Route `/dashboard/tools` |
| `ShortcutsScreen` | `shortcuts_screen.dart` | ✅ مستخدم في Route `/dashboard/shortcuts` |
| `AuditLogsScreen` | `audit_logs_screen.dart` | ✅ مستخدم في Route `/dashboard/audit-logs` |
| `NotificationsScreen` | `notifications_screen.dart` | ✅ مستخدم في Route `/dashboard/notifications` |
| `ReportsScreen` | `reports_screen.dart` | ✅ مستخدم في Route `/dashboard/reports` |
| `ProductSettingsView` | `product_settings_view.dart` | ⚠️ Widget داخلي (ليس Route) |

### 📂 features/store/presentation/screens/ (5 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `StoreTab` | `store_tab.dart` | ❌ **غير مستخدم** - Import فقط في router لكن لا Route |
| `AppStoreScreen` | `app_store_screen.dart` | ✅ مستخدم في Route `/dashboard/store` |
| `StoreToolsTab` | `store_tools_tab.dart` | ✅ مستخدم في Route `/dashboard/store-tools` |
| `InventoryScreen` | `inventory_screen.dart` | ✅ مستخدم في Route `/dashboard/inventory` |
| `ViewMyStoreScreen` | `view_my_store_screen.dart` | ✅ مستخدم في Route `/dashboard/view-store` |

### 📂 features/finance/presentation/screens/ (3 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `WalletScreen` | `wallet_screen.dart` | ✅ مستخدم في Route `/dashboard/wallet` |
| `SalesScreen` | `sales_screen.dart` | ✅ مستخدم في Route `/dashboard/sales` |
| `PointsScreen` | `points_screen.dart` | ✅ مستخدم في Route `/dashboard/points` |

### 📂 features/marketing/presentation/screens/ (5 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `MarketingScreen` | `marketing_screen.dart` | ✅ مستخدم في Route `/dashboard/marketing` |
| `CouponsScreen` | `coupons_screen.dart` | ✅ مستخدم في Route `/dashboard/coupons` |
| `FlashSalesScreen` | `flash_sales_screen.dart` | ✅ مستخدم في Route `/dashboard/flash-sales` |
| `BoostSalesScreen` | `boost_sales_screen.dart` | ✅ مستخدم في Route `/dashboard/boost-sales` |
| `PromotionsScreen` | `promotions_screen.dart` | ⚠️ **Route redirect** - Route موجود لكن redirect لـ `/dashboard` |

### 📂 features/dropshipping/presentation/screens/ (تم حذفها ✅)
**تم حذف ميزة Dropshipping بالكامل - 25 ديسمبر 2025**

### 📂 features/products/presentation/screens/ (3 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `AddProductScreen` | `add_product_screen.dart` | ✅ مستخدم في Route `/dashboard/products/add` |
| `ProductDetailsScreen` | `product_details_screen.dart` | ✅ مستخدم في Route `/dashboard/products/:id` |
| `_FullScreenGalleryPage` | `product_details_screen.dart` | ⚠️ Widget داخلي (ليس Route) |

### 📂 features/merchant/presentation/screens/ (2 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `CreateStoreScreen` | `create_store_screen.dart` | ✅ مستخدم في Route `/dashboard/store/create-store` |
| `CreateStoreScreen` | `create_store_screen_backup.dart` | ❌ **تكرار (Backup)** - نفس الكلاس، ملف احتياطي |

### 📂 features/merchant/screens/ (11 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `AiAssistantScreen` | `ai_assistant_screen.dart` | ✅ مستخدم في Route `/dashboard/ai-assistant` |
| `ContentGeneratorScreen` | `content_generator_screen.dart` | ✅ مستخدم في Route `/dashboard/content-generator` |
| `SmartAnalyticsScreen` | `smart_analytics_screen.dart` | ✅ مستخدم في Route `/dashboard/smart-analytics` |
| `AutoReportsScreen` | `auto_reports_screen.dart` | ✅ مستخدم في Route `/dashboard/auto-reports` |
| `HeatmapScreen` | `heatmap_screen.dart` | ✅ مستخدم في Route `/dashboard/heatmap` |
| `AbandonedCartScreen` | `abandoned_cart_screen.dart` | ✅ مستخدم في Route `/dashboard/abandoned-cart` |
| `ReferralScreen` | `referral_screen.dart` | ✅ مستخدم في Route `/dashboard/referral` |
| `LoyaltyProgramScreen` | `loyalty_program_screen.dart` | ✅ مستخدم في Route `/dashboard/loyalty-program` |
| `CustomerSegmentsScreen` | `customer_segments_screen.dart` | ✅ مستخدم في Route `/dashboard/customer-segments` |
| `CustomMessagesScreen` | `custom_messages_screen.dart` | ✅ مستخدم في Route `/dashboard/custom-messages` |
| `SmartPricingScreen` | `smart_pricing_screen.dart` | ✅ مستخدم في Route `/dashboard/smart-pricing` |

### 📂 features/settings/presentation/screens/ (7 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `AccountSettingsScreen` | `account_settings_screen.dart` | ✅ مستخدم في Route `/settings` |
| `PrivacyPolicyScreen` | `privacy_policy_screen.dart` | ✅ مستخدم في Route `/privacy-policy` |
| `TermsScreen` | `terms_screen.dart` | ✅ مستخدم في Route `/terms` |
| `SupportScreen` | `support_screen.dart` | ✅ مستخدم في Route `/support` |
| `AboutScreen` | `about_screen.dart` | ✅ مستخدم في Route `/dashboard/about` |
| `NotificationSettingsScreen` | `notification_settings_screen.dart` | ✅ مستخدم في Route `/notification-settings` |
| `AppearanceSettingsScreen` | `appearance_settings_screen.dart` | ✅ مستخدم في Route `/appearance-settings` |

### 📂 features/onboarding/presentation/screens/ (1 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `OnboardingScreen` | `onboarding_screen.dart` | ✅ مستخدم في Route `/onboarding` |

### 📂 features/conversations/presentation/screens/ (1 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `ConversationsScreen` | `conversations_screen.dart` | ✅ مستخدم في Route `/dashboard/conversations` |
| `_ChatDetailScreen` | `conversations_screen.dart` | ⚠️ Widget داخلي (ليس Route) |

### 📂 features/studio/screens/ (9 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `StudioMainPage` | `studio_main_page.dart` | ✅ مستخدم في Route `/dashboard/studio` |
| `StudioHomeScreen` | `studio_home_screen.dart` | ✅ مستخدم في Route `/dashboard/content-studio` |
| `ScriptGeneratorScreen` | `script_generator_screen.dart` | ✅ مستخدم في Route `/dashboard/content-studio/script-generator` |
| `SceneEditorScreen` | `scene_editor_screen.dart` | ✅ مستخدم في Route `/dashboard/content-studio/editor` |
| `CanvasEditorScreen` | `canvas_editor_screen.dart` | ✅ مستخدم في Route `/dashboard/content-studio/canvas` |
| `ExportScreen` | `export_screen.dart` | ✅ مستخدم في Route `/dashboard/content-studio/export` |
| `PackagesPage` | `packages_page.dart` | ✅ مستخدم في Route `/dashboard/packages` |
| `EditTab` | `edit_tab.dart` | ⚠️ Widget داخلي (Tab داخل Studio) |
| `GenerateTab` | `generate_tab.dart` | ⚠️ Widget داخلي (Tab داخل Studio) |
| `EditStudioPage` | `edit_studio_page.dart` | ❌ **غير مستخدم** - لا Route |
| `GenerationStudioPage` | `generation_studio_page.dart` | ❌ **غير مستخدم** - لا Route |

### 📂 apps/merchant/features/ (4 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `WebstoreScreen` | `webstore/webstore_screen.dart` | ✅ مستخدم في Route `/dashboard/webstore` |
| `ShippingScreen` | `shipping/shipping_screen.dart` | ✅ مستخدم في Route `/dashboard/shipping` |
| `PaymentMethodsScreen` | `payments/payment_methods_screen.dart` | ✅ مستخدم في Route `/dashboard/payment-methods` |
| `QrCodeScreen` | `qrcode/qr_code_screen.dart` | ❌ **غير مستخدم** - لا Route |
| `DeliveryOptionsScreen` | `delivery/delivery_options_screen.dart` | ❌ **غير مستخدم** - لا Route |
| `CodSettingsScreen` | `payments/cod_settings_screen.dart` | ❌ **غير مستخدم** - لا Route |
| `WhatsappScreen` | `whatsapp/whatsapp_screen.dart` | ❌ **غير مستخدم** - لا Route |

### 📂 shared/screens/ (1 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `LoginScreen` | `login_screen.dart` | ⚠️ **تكرار** - نفس الاسم في `features/auth` |

### 📂 shared/widgets/ (Base Classes)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `BaseScreen` | `base_screen.dart` | ✅ Base class (ليس Route) |
| `SubPageScreen` | `base_screen.dart` | ✅ Base class (ليس Route) |
| `ComingSoonScreen` | `base_screen.dart` | ✅ مستخدم في Route `/dashboard/feature/:name` |
| `BaseListScreen` | `base_screen.dart` | ✅ Base class (ليس Route) |
| `BaseFormScreen` | `base_screen.dart` | ✅ Base class (ليس Route) |
| `BaseDetailsScreen` | `base_screen.dart` | ✅ Base class (ليس Route) |
| `SubPageScaffold` | `sub_page_scaffold.dart` | ✅ Widget مساعد (ليس Route) |

### 📂 features/dev/ (1 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `WidgetCatalogScreen` | `widget_catalog_screen.dart` | ❌ **Dev Screen** - لا Route (للاختبار فقط) |

---

## 2️⃣ Audit للـ Routes / Navigation

### 📍 Router Configuration
- **الملف:** `lib/core/router/app_router.dart`
- **النوع:** GoRouter (declarative routing)
- **Entry Point:** `MerchantApp` → `AppRouter.createRouter()`
- **Initial Location:** `/login`

### 📊 Routes Table (جدول المسارات)

#### Auth Routes (3 routes)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/login` | `login` | `LoginScreen` (shared) | 136 | ✅ |
| `/register` | `register` | `RegisterScreen` | 141 | ✅ |
| `/forgot-password` | `forgot-password` | `ForgotPasswordScreen` | 146 | ✅ |

#### Settings Routes (6 routes)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/settings` | `settings` | `AccountSettingsScreen` | 155 | ✅ |
| `/privacy-policy` | `privacy-policy` | `PrivacyPolicyScreen` | 160 | ✅ |
| `/terms` | `terms` | `TermsScreen` | 165 | ✅ |
| `/support` | `support` | `SupportScreen` | 170 | ✅ |
| `/notification-settings` | `notification-settings` | `NotificationSettingsScreen` | 175 | ✅ |
| `/appearance-settings` | `appearance-settings` | `AppearanceSettingsScreen` | 180 | ✅ |

#### Onboarding Route (1 route)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/onboarding` | `onboarding` | `OnboardingScreen` | 189 | ✅ |

#### Dashboard Shell Routes (Main Tab - 0)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/dashboard` | `dashboard` | `HomeTab` | 202 | ✅ |
| `/dashboard/studio` | `mbuy-studio` | `StudioMainPage` | 208 | ✅ |
| `/dashboard/tools` | `mbuy-tools` | `MbuyToolsScreen` | 213 | ✅ |
| `/dashboard/marketing` | `marketing` | `MarketingScreen` | 218 | ✅ |
| `/dashboard/store-management` | `store-management` | `MerchantServicesScreen` | 223 | ✅ |
| `/dashboard/boost-sales` | `boost-sales` | `BoostSalesScreen` | 228 | ✅ |
| `/dashboard/webstore` | `webstore` | `WebstoreScreen` | 233 | ✅ |
| `/dashboard/shipping` | `shipping` | `ShippingScreen` | 238 | ✅ |
| `/dashboard/payment-methods` | `payment-methods` | `PaymentMethodsScreen` | 243 | ✅ |
| `/dashboard/feature/:name` | `feature` | `ComingSoonScreen` | 248 | ✅ |
| `/dashboard/shortcuts` | `shortcuts` | `ShortcutsScreen` | 265 | ✅ |
| `/dashboard/promotions` | `promotions` | **REDIRECT** → `/dashboard` | 270 | ⚠️ |
| `/dashboard/inventory` | `inventory` | `InventoryScreen` | 275 | ✅ |
| `/dashboard/audit-logs` | `audit-logs` | `AuditLogsScreen` | 280 | ✅ |
| `/dashboard/view-store` | `view-store` | `ViewMyStoreScreen` | 285 | ✅ |
| `/dashboard/notifications` | `notifications` | `NotificationsScreen` | 290 | ✅ |
| `/dashboard/dropshipping` | `dropshipping` | `DropshippingScreen` | 295 | ✅ |
| `/dashboard/supplier-orders` | `supplier-orders` | `SupplierOrdersScreen` | 300 | ✅ |
| `/dashboard/packages` | `packages` | `PackagesPage` | 305 | ✅ |
| `/dashboard/reports` | `reports` | `ReportsScreen` | 310 | ✅ |
| `/dashboard/customers` | `customers` | `CustomersScreen` | 315 | ✅ |
| `/dashboard/wallet` | `wallet` | `WalletScreen` | 321 | ✅ |
| `/dashboard/points` | `points` | `PointsScreen` | 326 | ✅ |
| `/dashboard/sales` | `sales` | `SalesScreen` | 331 | ✅ |
| `/dashboard/coupons` | `coupons` | `CouponsScreen` | 337 | ✅ |
| `/dashboard/flash-sales` | `flash-sales` | `FlashSalesScreen` | 342 | ✅ |
| `/dashboard/abandoned-cart` | `abandoned-cart` | `AbandonedCartScreen` | 347 | ✅ |
| `/dashboard/referral` | `referral` | `ReferralScreen` | 352 | ✅ |
| `/dashboard/loyalty-program` | `loyalty-program` | `LoyaltyProgramScreen` | 357 | ✅ |
| `/dashboard/customer-segments` | `customer-segments` | `CustomerSegmentsScreen` | 362 | ✅ |
| `/dashboard/custom-messages` | `custom-messages` | `CustomMessagesScreen` | 367 | ✅ |
| `/dashboard/smart-pricing` | `smart-pricing` | `SmartPricingScreen` | 372 | ✅ |
| `/dashboard/store-tools` | `store-tools` | `StoreToolsTab` | 378 | ✅ |
| `/dashboard/ai-generation` | `ai-generation` | `StudioMainPage` (redirect) | 384 | ✅ |
| `/dashboard/content-studio` | `content-studio` | `StudioHomeScreen` | 390 | ✅ |
| `/dashboard/content-studio/script-generator` | `studio-script` | `ScriptGeneratorScreen` | 395 | ✅ |
| `/dashboard/content-studio/editor` | `studio-editor` | `SceneEditorScreen` | 404 | ✅ |
| `/dashboard/content-studio/canvas` | `studio-canvas` | `CanvasEditorScreen` | 417 | ✅ |
| `/dashboard/content-studio/preview` | `studio-preview` | `ComingSoonScreen` | 426 | ✅ |
| `/dashboard/content-studio/export` | `studio-export` | `ExportScreen` | 433 | ✅ |
| `/dashboard/ai-assistant` | `ai-assistant` | `AiAssistantScreen` | 445 | ✅ |
| `/dashboard/content-generator` | `content-generator` | `ContentGeneratorScreen` | 450 | ✅ |
| `/dashboard/smart-analytics` | `smart-analytics` | `SmartAnalyticsScreen` | 456 | ✅ |
| `/dashboard/auto-reports` | `auto-reports` | `AutoReportsScreen` | 461 | ✅ |
| `/dashboard/heatmap` | `heatmap` | `HeatmapScreen` | 466 | ✅ |

#### Dashboard Shell Routes (Orders Tab - 1)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/dashboard/orders` | `orders` | `OrdersTab` | 474 | ✅ |

#### Dashboard Shell Routes (Products Tab - 2)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/dashboard/products` | `products` | `ProductsTab` | 480 | ✅ |
| `/dashboard/products/add` | `add-product` | `AddProductScreen` | 485 | ✅ |
| `/dashboard/products/:id` | `product-details` | `ProductDetailsScreen` | 502 | ✅ |

#### Dashboard Shell Routes (Conversations Tab - 3)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/dashboard/conversations` | `conversations` | `ConversationsScreen` | 513 | ✅ |

#### Dashboard Shell Routes (Store Tab - 4)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/dashboard/store` | `store` | `AppStoreScreen` | 519 | ✅ |
| `/dashboard/store/create-store` | `create-store` | `CreateStoreScreen` | 524 | ✅ |

#### Dashboard Shell Routes (About)
| Route Path | Route Name | الشاشة | السطر | الحالة |
|------------|------------|--------|-------|--------|
| `/dashboard/about` | `about` | `AboutScreen` | 532 | ✅ |

### 🔍 Routes Issues (مشاكل المسارات)

#### ⚠️ Routes مع Redirect
| Route | الحالة | السبب |
|-------|--------|-------|
| `/dashboard/promotions` | Redirect → `/dashboard` | Route موجود لكن redirect فقط |

#### ❌ Routes مفقودة (شاشات موجودة بدون Routes)
| الشاشة | الملف | السبب |
|--------|-------|-------|
| `QrCodeScreen` | `apps/merchant/features/qrcode/qr_code_screen.dart` | لا يوجد Route |
| `DeliveryOptionsScreen` | `apps/merchant/features/delivery/delivery_options_screen.dart` | لا يوجد Route |
| `CodSettingsScreen` | `apps/merchant/features/payments/cod_settings_screen.dart` | لا يوجد Route |
| `WhatsappScreen` | `apps/merchant/features/whatsapp/whatsapp_screen.dart` | لا يوجد Route |
| `StoreTab` | `features/store/presentation/screens/store_tab.dart` | Import فقط، غير مستخدم |
| `EditStudioPage` | `features/studio/screens/edit_studio_page.dart` | لا يوجد Route |
| `GenerationStudioPage` | `features/studio/screens/generation_studio_page.dart` | لا يوجد Route |
| `WidgetCatalogScreen` | `features/dev/widget_catalog_screen.dart` | Dev screen - لا Route |

---

## 3️⃣ اكتشاف التكرار والنسخ (Duplicates)

### 🔄 ملفات مكررة:

| الملف الأصلي | الملف المكرر | سبب الاشتباه | الحالة |
|--------------|--------------|--------------|--------|
| `features/merchant/presentation/screens/create_store_screen.dart` | `features/merchant/presentation/screens/create_store_screen_backup.dart` | نسخة احتياطية - نفس الكلاس `CreateStoreScreen` | ❌ **يجب حذف** |
| `features/auth/presentation/screens/login_screen.dart` | `shared/screens/login_screen.dart` | شاشتي تسجيل دخول - نفس الاسم لكن مختلفة | ⚠️ **يجب توحيد** |

### 📝 تفاصيل التكرار:

#### 1. CreateStoreScreen Backup
- **الملف الأصلي:** `create_store_screen.dart` (مستخدم في Route)
- **الملف المكرر:** `create_store_screen_backup.dart` (غير مستخدم)
- **السبب:** نسخة احتياطية قديمة
- **التوصية:** حذف `create_store_screen_backup.dart` بعد التأكد أن النسخة الأصلية تعمل

#### 2. LoginScreen Duplicate
- **الملف 1:** `features/auth/presentation/screens/login_screen.dart` (غير مستخدم في Router)
- **الملف 2:** `shared/screens/login_screen.dart` (مستخدم في Router - السطر 4)
- **السبب:** نسختان مختلفتان لنفس الوظيفة
- **التوصية:** 
  - استخدام نسخة واحدة فقط
  - حذف النسخة غير المستخدمة أو توحيدها

---

## 4️⃣ الصفحات غير المستخدمة (Dead Screens)

### ❌ شاشات موجودة لكن غير مربوطة بأي Route:

| الشاشة | الملف | السبب | التوصية |
|---------|------|-------|---------|
| `QrCodeScreen` | `apps/merchant/features/qrcode/qr_code_screen.dart` | لا يوجد Route | إضافة Route أو حذف |
| `DeliveryOptionsScreen` | `apps/merchant/features/delivery/delivery_options_screen.dart` | لا يوجد Route | إضافة Route أو حذف |
| `CodSettingsScreen` | `apps/merchant/features/payments/cod_settings_screen.dart` | لا يوجد Route | إضافة Route أو حذف |
| `WhatsappScreen` | `apps/merchant/features/whatsapp/whatsapp_screen.dart` | لا يوجد Route | إضافة Route أو حذف |
| `StoreTab` | `features/store/presentation/screens/store_tab.dart` | Import فقط، غير مستخدم | حذف Import أو إضافة Route |
| `EditStudioPage` | `features/studio/screens/edit_studio_page.dart` | لا يوجد Route | إضافة Route أو حذف |
| `GenerationStudioPage` | `features/studio/screens/generation_studio_page.dart` | لا يوجد Route | إضافة Route أو حذف |
| `WidgetCatalogScreen` | `features/dev/widget_catalog_screen.dart` | Dev screen - للاختبار فقط | يمكن الاحتفاظ للاختبار |

### ⚠️ شاشات مستخدمة بشكل غير مباشر:

| الشاشة | الملف | الاستخدام |
|---------|------|----------|
| `PromotionsScreen` | `features/marketing/presentation/screens/promotions_screen.dart` | Route موجود لكن redirect فقط |

---

## 5️⃣ التأكد من Entry Points

### 📍 Entry Point الرئيسي:
```
main.dart (line 15)
  └─> AppShell (shared/app_shell.dart)
      ├─> MerchantApp (apps/merchant/merchant_app.dart) [MaterialApp.router]
      └─> MaterialApp (pre-login state) [MaterialApp]
```

### 🔍 MaterialApp Instances:

| الموقع | النوع | الغرض | الحالة |
|--------|-------|-------|--------|
| `merchant_app.dart:24` | `MaterialApp.router` | ✅ **الأساسي** - GoRouter | ✅ صحيح |
| `app_shell.dart:92` | `MaterialApp` | ⚠️ Loading state (مؤقت) | ✅ مقبول |
| `app_shell.dart:107` | `MaterialApp` | ⚠️ Pre-login state (مؤقت) | ✅ مقبول |

### 📝 ملاحظات:
- ✅ **Entry Point واحد فقط:** `main.dart`
- ✅ **MaterialApp.router واحد فقط:** في `MerchantApp`
- ⚠️ **MaterialApp مؤقتان:** في `AppShell` للحالات الخاصة (loading/pre-auth) - **مقبول**
- ✅ **لا يوجد تضارب:** كل MaterialApp له غرض محدد

---

## 6️⃣ Audit للمسارات داخل التطبيق (Deep Navigation)

### 📱 شجرة التنقل الأساسية:

#### Bottom Navigation Bar (4 تبويبات):
```
DashboardShell
├── [0] الرئيسية → /dashboard → HomeTab
├── [1] الطلبات → /dashboard/orders → OrdersTab  
├── [2] المنتجات → /dashboard/products → ProductsTab
└── [3] استديو AI → /dashboard/studio → StudioMainPage

ملاحظة: المحادثات متاحة عبر أيقونة الإشعارات في الهيدر العلوي
```

#### Nested Routes من الرئيسية (/dashboard):
```
/dashboard
├── /studio → StudioMainPage
├── /tools → MbuyToolsScreen
├── /marketing → MarketingScreen
├── /store-management → MerchantServicesScreen
├── /wallet → WalletScreen
├── /points → PointsScreen
├── /sales → SalesScreen
├── /customers → CustomersScreen
├── /reports → ReportsScreen
├── /packages → PackagesPage
├── /shortcuts → ShortcutsScreen
├── /ai-assistant → AiAssistantScreen
├── /content-generator → ContentGeneratorScreen
├── /content-studio/... → Studio Nested Routes
│   ├── /script-generator → ScriptGeneratorScreen
│   ├── /editor → SceneEditorScreen
│   ├── /canvas → CanvasEditorScreen
│   ├── /preview → ComingSoonScreen
│   └── /export → ExportScreen
└── ... (المزيد)
```

#### Routes خارج Shell:
```
/login → LoginScreen
/register → RegisterScreen
/forgot-password → ForgotPasswordScreen
/settings → AccountSettingsScreen
/privacy-policy → PrivacyPolicyScreen
/terms → TermsScreen
/support → SupportScreen
/notification-settings → NotificationSettingsScreen
/appearance-settings → AppearanceSettingsScreen
/onboarding → OnboardingScreen
```

### 🔍 Navigation Flow التحقق:

#### ✅ Bottom Navigation:
- **5 تبويبات:** جميعها مربوطة بـ Routes صحيحة
- **التبديل:** يعمل عبر `context.go()` في `DashboardShell`
- **الحالة النشطة:** يتم حسابها بناءً على المسار الحالي

#### ✅ Nested Navigation:
- **Products Tab:** يحتوي على nested routes (`/add`, `/:id`)
- **Store Tab:** يحتوي على nested route (`/create-store`)
- **Content Studio:** يحتوي على nested routes متعددة

#### ✅ Back Navigation:
- **GoRouter:** يدعم Back navigation تلقائياً
- **Shell Routes:** Back يعمل منطقياً داخل Shell

---

## 7️⃣ Recommendations (التوصيات)

### 🔴 عاجل (High Priority):

#### 1. إضافة Routes المفقودة:
```dart
// في app_router.dart داخل Dashboard routes:
GoRoute(
  path: 'qr-code',
  name: 'qr-code',
  builder: (context, state) => const QrCodeScreen(),
),
GoRoute(
  path: 'delivery-options',
  name: 'delivery-options',
  builder: (context, state) => const DeliveryOptionsScreen(),
),
GoRoute(
  path: 'cod-settings',
  name: 'cod-settings',
  builder: (context, state) => const CodSettingsScreen(),
),
GoRoute(
  path: 'whatsapp',
  name: 'whatsapp',
  builder: (context, state) => const WhatsappScreen(),
),
```

#### 2. حذف الملفات المكررة:
- ✅ **حذف** `create_store_screen_backup.dart` بعد التأكد أن النسخة الأصلية تعمل
- ✅ **توحيد** `LoginScreen` - استخدام نسخة واحدة فقط (يفضل `shared/screens/login_screen.dart`)

#### 3. إصلاح Route Redirect:
- ✅ **إزالة redirect** من `/dashboard/promotions` أو إضافة Route فعلي لـ `PromotionsScreen`

#### 4. تنظيف Imports غير المستخدمة:
- ✅ **حذف** `StoreTab` import من `app_router.dart` إذا لم يكن مستخدماً

### 🟡 متوسط (Medium Priority):

#### 5. إضافة Routes للـ Studio Pages:
```dart
// إضافة routes لـ EditStudioPage و GenerationStudioPage
// أو حذفها إذا لم تكن مطلوبة
```

#### 6. توثيق Dead Screens:
- ✅ **توثيق** سبب وجود `WidgetCatalogScreen` (Dev screen)
- ✅ **قرار** حول `EditStudioPage` و `GenerationStudioPage`

### 🟢 منخفض (Low Priority):

#### 7. تحسين التنظيم:
- ✅ **نقل** `QrCodeScreen`, `DeliveryOptionsScreen`, etc. إلى مجلدات مناسبة
- ✅ **توحيد** بنية الملفات (screens vs pages vs tabs)

#### 8. إضافة Documentation:
- ✅ **توثيق** Navigation flow في README
- ✅ **إضافة** comments في `app_router.dart` لكل section

---

## 8️⃣ Statistics (إحصائيات)

| الفئة | العدد |
|-------|------|
| **إجمالي الشاشات** | 83 |
| **Routes مسجلة** | 54 |
| **Nested Routes** | 5 |
| **Shell Routes** | 1 (DashboardShell) |
| **Auth Routes** | 3 |
| **Settings Routes** | 6 |
| **Dashboard Routes** | 43 |
| **Dead Screens** | 8 |
| **Duplicate Files** | 2 |
| **MaterialApp Instances** | 3 (1 router + 2 temp) |
| **Entry Points** | 1 |

**التحديثات الأخيرة (25 ديسمبر 2025):**
- ✅ تم تقليص البار السفلي من 5 إلى 4 تبويبات
- ✅ تم حذف ميزة Dropshipping كاملةً (2 screens، 2 routes)
- ✅ تم نقل المحادثات من البار السفلي إلى الهيدر العلوي

---

## 9️⃣ الخلاصة

### ✅ النقاط الإيجابية:
1. ✅ **بنية واضحة:** Routes منظمة في `app_router.dart`
2. ✅ **Entry Point واحد:** لا يوجد تضارب
3. ✅ **Navigation منطقي:** Bottom Nav + Nested Routes
4. ✅ **معظم الشاشات مربوطة:** 90%+ من الشاشات لها Routes

### ⚠️ النقاط التي تحتاج تحسين:
1. ⚠️ **8 شاشات غير مستخدمة:** تحتاج إضافة Routes أو حذف
2. ⚠️ **2 ملفات مكررة:** تحتاج تنظيف
3. ⚠️ **1 Route redirect:** يحتاج إصلاح
4. ⚠️ **LoginScreen مكرر:** يحتاج توحيد

### 📊 التقييم العام:
- **البنية:** ⭐⭐⭐⭐ (4/5)
- **التنظيم:** ⭐⭐⭐⭐ (4/5)
- **الاكتمال:** ⭐⭐⭐ (3/5)
- **التوثيق:** ⭐⭐⭐ (3/5)

---

**تم إنشاء التقرير:** 2025-12-24  
**آخر تحديث:** 2025-12-24  
**الحالة:** ✅ مكتمل - جاهز للمراجعة
