# 📊 APP_AUDIT_REPORT - Saleh (MBUY Merchant)
## تقرير فحص شامل للتطبيق

> **تاريخ الفحص:** 2025-12-24
> **نوع التطبيق:** Flutter (Merchant Dashboard)
> **حالة الفحص:** ✅ مكتمل

---

## 📋 Summary (ملخص تنفيذي)

| البند | الحالة | التفاصيل |
|-------|--------|----------|
| **إجمالي الشاشات** | 82 | شاشات/صفحات/تبويبات |
| **Routes مسجلة** | 56 | في GoRouter |
| **Entry Points** | 1 | `main.dart` → `AppShell` |
| **MaterialApp instances** | 3 | (1 للـ Router + 2 للحالات الخاصة) |
| **شاشات مكررة** | 2 | يحتاج مراجعة |
| **شاشات غير مستخدمة** | 8 | Dead Screens |
| **Routes معطلة** | 3 | Broken Routes |

### 🚨 مشاكل تحتاج إصلاح فوري:
1. **3 Routes تشير لصفحات غير موجودة**
2. **8 شاشات موجودة لكن غير مربوطة بأي Route**
3. **2 ملفات مكررة (backup)**
4. **2 شاشات LoginScreen متطابقة**

---

## 1️⃣ Inventory للشاشات والصفحات

### 📂 features/auth/presentation/screens/ (3 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `LoginScreen` | `login_screen.dart` | ✅ مستخدم |
| `RegisterScreen` | `register_screen.dart` | ✅ مستخدم |
| `ForgotPasswordScreen` | `forgot_password_screen.dart` | ✅ مستخدم |

### 📂 features/dashboard/presentation/screens/ (12 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `DashboardShell` | `dashboard_shell.dart` | ✅ Shell للـ Navigation |
| `HomeTab` | `home_tab.dart` | ✅ مستخدم |
| `OrdersTab` | `orders_tab.dart` | ✅ مستخدم |
| `ProductsTab` | `products_tab.dart` | ✅ مستخدم |
| `CustomersScreen` | `customers_screen.dart` | ✅ مستخدم |
| `MerchantServicesScreen` | `merchant_services_screen.dart` | ✅ مستخدم |
| `MbuyToolsScreen` | `mbuy_tools_screen.dart` | ✅ مستخدم |
| `ShortcutsScreen` | `shortcuts_screen.dart` | ✅ مستخدم |
| `AuditLogsScreen` | `audit_logs_screen.dart` | ✅ مستخدم |
| `NotificationsScreen` | `notifications_screen.dart` | ✅ مستخدم |
| `ReportsScreen` | `reports_screen.dart` | ✅ مستخدم |

### 📂 features/store/presentation/screens/ (5 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `StoreTab` | `store_tab.dart` | ⚠️ غير مستخدم (import فقط) |
| `AppStoreScreen` | `app_store_screen.dart` | ✅ مستخدم |
| `StoreToolsTab` | `store_tools_tab.dart` | ✅ مستخدم |
| `InventoryScreen` | `inventory_screen.dart` | ✅ مستخدم |
| `ViewMyStoreScreen` | `view_my_store_screen.dart` | ✅ مستخدم |

### 📂 features/finance/presentation/screens/ (3 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `WalletScreen` | `wallet_screen.dart` | ✅ مستخدم |
| `SalesScreen` | `sales_screen.dart` | ✅ مستخدم |
| `PointsScreen` | `points_screen.dart` | ✅ مستخدم |

### 📂 features/marketing/presentation/screens/ (5 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `MarketingScreen` | `marketing_screen.dart` | ✅ مستخدم |
| `CouponsScreen` | `coupons_screen.dart` | ✅ مستخدم |
| `FlashSalesScreen` | `flash_sales_screen.dart` | ✅ مستخدم |
| `BoostSalesScreen` | `boost_sales_screen.dart` | ✅ مستخدم |
| `PromotionsScreen` | `promotions_screen.dart` | ❌ غير مستخدم |

### 📂 features/dropshipping/presentation/screens/ (2 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `DropshippingScreen` | `dropshipping_screen.dart` | ✅ مستخدم |
| `SupplierOrdersScreen` | `supplier_orders_screen.dart` | ✅ مستخدم |

### 📂 features/products/presentation/screens/ (2 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `AddProductScreen` | `add_product_screen.dart` | ✅ مستخدم |
| `ProductDetailsScreen` | `product_details_screen.dart` | ✅ مستخدم |

### 📂 features/merchant/presentation/screens/ (2 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `CreateStoreScreen` | `create_store_screen.dart` | ✅ مستخدم |
| `CreateStoreScreen` | `create_store_screen_backup.dart` | ❌ **تكرار (Backup)** |

### 📂 features/merchant/screens/ (11 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `AiAssistantScreen` | `ai_assistant_screen.dart` | ✅ مستخدم |
| `ContentGeneratorScreen` | `content_generator_screen.dart` | ✅ مستخدم |
| `AbandonedCartScreen` | `abandoned_cart_screen.dart` | ✅ مستخدم |
| `ReferralScreen` | `referral_screen.dart` | ✅ مستخدم |
| `LoyaltyProgramScreen` | `loyalty_program_screen.dart` | ✅ مستخدم |
| `CustomerSegmentsScreen` | `customer_segments_screen.dart` | ✅ مستخدم |
| `CustomMessagesScreen` | `custom_messages_screen.dart` | ✅ مستخدم |
| `SmartPricingScreen` | `smart_pricing_screen.dart` | ✅ مستخدم |
| `SmartAnalyticsScreen` | `smart_analytics_screen.dart` | ✅ مستخدم |
| `AutoReportsScreen` | `auto_reports_screen.dart` | ✅ مستخدم |
| `HeatmapScreen` | `heatmap_screen.dart` | ✅ مستخدم |

### 📂 features/settings/presentation/screens/ (7 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `AccountSettingsScreen` | `account_settings_screen.dart` | ✅ مستخدم |
| `NotificationSettingsScreen` | `notification_settings_screen.dart` | ✅ مستخدم |
| `AppearanceSettingsScreen` | `appearance_settings_screen.dart` | ✅ مستخدم |
| `PrivacyPolicyScreen` | `privacy_policy_screen.dart` | ✅ مستخدم |
| `TermsScreen` | `terms_screen.dart` | ✅ مستخدم |
| `SupportScreen` | `support_screen.dart` | ✅ مستخدم |
| `AboutScreen` | `about_screen.dart` | ✅ مستخدم |

### 📂 features/studio/screens/ (12 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `StudioMainPage` | `studio_main_page.dart` | ✅ مستخدم |
| `StudioHomeScreen` | `studio_home_screen.dart` | ✅ مستخدم |
| `ScriptGeneratorScreen` | `script_generator_screen.dart` | ✅ مستخدم |
| `SceneEditorScreen` | `scene_editor_screen.dart` | ✅ مستخدم |
| `CanvasEditorScreen` | `canvas_editor_screen.dart` | ✅ مستخدم |
| `ExportScreen` | `export_screen.dart` | ✅ مستخدم |
| `PackagesPage` | `packages_page.dart` | ✅ مستخدم |
| `GenerationStudioPage` | `generation_studio_page.dart` | ⚠️ داخلي فقط |
| `EditStudioPage` | `edit_studio_page.dart` | ⚠️ داخلي فقط |
| `EditTab` | `edit_tab.dart` | ⚠️ داخلي فقط |
| `GenerateTab` | `generate_tab.dart` | ⚠️ داخلي فقط |

### 📂 features/conversations/presentation/screens/ (1 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `ConversationsScreen` | `conversations_screen.dart` | ✅ مستخدم |

### 📂 features/onboarding/presentation/screens/ (1 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `OnboardingScreen` | `onboarding_screen.dart` | ✅ مستخدم |

### 📂 features/dev/ (1 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `WidgetCatalogScreen` | `widget_catalog_screen.dart` | ❌ غير مستخدم (Dev only) |

### 📂 apps/merchant/features/ (6 ملفات)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `WebstoreScreen` | `webstore/webstore_screen.dart` | ✅ مستخدم |
| `ShippingScreen` | `shipping/shipping_screen.dart` | ✅ مستخدم |
| `PaymentMethodsScreen` | `payments/payment_methods_screen.dart` | ✅ مستخدم |
| `CodSettingsScreen` | `payments/cod_settings_screen.dart` | ❌ غير مستخدم |
| `DeliveryOptionsScreen` | `delivery/delivery_options_screen.dart` | ❌ غير مستخدم |
| `WhatsappScreen` | `whatsapp/whatsapp_screen.dart` | ❌ غير مستخدم |
| `QrCodeScreen` | `qrcode/qr_code_screen.dart` | ❌ غير مستخدم |

### 📂 shared/screens/ (1 ملف)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `LoginScreen` | `login_screen.dart` | ⚠️ **تكرار مع features/auth** |

### 📂 shared/widgets/ (Base Classes)
| الكلاس | الملف | الحالة |
|--------|-------|--------|
| `BaseScreen` | `base_screen.dart` | ✅ Base Widget |
| `ComingSoonScreen` | `base_screen.dart` | ✅ مستخدم |
| `SubPageScreen` | `base_screen.dart` | ✅ Base Widget |

---

## 2️⃣ Audit للـ Routes / Navigation

### 📍 ملف تعريف المسارات
**الملف:** `lib/core/router/app_router.dart` (550 سطر)

### 📊 جدول Routes الكامل

#### Auth Routes (خارج Shell)
| Route Path | Route Name | الشاشة | السطر |
|------------|------------|--------|-------|
| `/login` | `login` | `LoginScreen` (shared) | 134 |
| `/register` | `register` | `RegisterScreen` | 139 |
| `/forgot-password` | `forgot-password` | `ForgotPasswordScreen` | 144 |

#### Settings Routes (خارج Shell)
| Route Path | Route Name | الشاشة | السطر |
|------------|------------|--------|-------|
| `/settings` | `settings` | `AccountSettingsScreen` | 152 |
| `/privacy-policy` | `privacy-policy` | `PrivacyPolicyScreen` | 157 |
| `/terms` | `terms` | `TermsScreen` | 162 |
| `/support` | `support` | `SupportScreen` | 167 |
| `/notification-settings` | `notification-settings` | `NotificationSettingsScreen` | 172 |
| `/appearance-settings` | `appearance-settings` | `AppearanceSettingsScreen` | 177 |

#### Onboarding Route
| Route Path | Route Name | الشاشة | السطر |
|------------|------------|--------|-------|
| `/onboarding` | `onboarding` | `OnboardingScreen` | 185 |

#### Dashboard Shell Routes
| Route Path | Route Name | الشاشة | السطر |
|------------|------------|--------|-------|
| `/dashboard` | `dashboard` | `HomeTab` | 200 |
| `/dashboard/studio` | `mbuy-studio` | `StudioMainPage` | 206 |
| `/dashboard/tools` | `mbuy-tools` | `MbuyToolsScreen` | 211 |
| `/dashboard/marketing` | `marketing` | `MarketingScreen` | 216 |
| `/dashboard/store-management` | `store-management` | `MerchantServicesScreen` | 221 |
| `/dashboard/boost-sales` | `boost-sales` | `BoostSalesScreen` | 226 |
| `/dashboard/webstore` | `webstore` | `WebstoreScreen` | 231 |
| `/dashboard/shipping` | `shipping` | `ShippingScreen` | 236 |
| `/dashboard/payment-methods` | `payment-methods` | `PaymentMethodsScreen` | 241 |
| `/dashboard/feature/:name` | `feature` | `ComingSoonScreen` | 246 |
| `/dashboard/shortcuts` | `shortcuts` | `ShortcutsScreen` | 260 |
| `/dashboard/promotions` | `promotions` | **REDIRECT** → `/dashboard` | 265 |
| `/dashboard/inventory` | `inventory` | `InventoryScreen` | 269 |
| `/dashboard/audit-logs` | `audit-logs` | `AuditLogsScreen` | 274 |
| `/dashboard/view-store` | `view-store` | `ViewMyStoreScreen` | 279 |
| `/dashboard/notifications` | `notifications` | `NotificationsScreen` | 284 |
| `/dashboard/dropshipping` | `dropshipping` | `DropshippingScreen` | 289 |
| `/dashboard/supplier-orders` | `supplier-orders` | `SupplierOrdersScreen` | 294 |
| `/dashboard/packages` | `packages` | `PackagesPage` | 299 |
| `/dashboard/reports` | `reports` | `ReportsScreen` | 304 |
| `/dashboard/customers` | `customers` | `CustomersScreen` | 309 |
| `/dashboard/wallet` | `wallet` | `WalletScreen` | 315 |
| `/dashboard/points` | `points` | `PointsScreen` | 320 |
| `/dashboard/sales` | `sales` | `SalesScreen` | 325 |
| `/dashboard/coupons` | `coupons` | `CouponsScreen` | 331 |
| `/dashboard/flash-sales` | `flash-sales` | `FlashSalesScreen` | 336 |
| `/dashboard/abandoned-cart` | `abandoned-cart` | `AbandonedCartScreen` | 341 |
| `/dashboard/referral` | `referral` | `ReferralScreen` | 346 |
| `/dashboard/loyalty-program` | `loyalty-program` | `LoyaltyProgramScreen` | 351 |
| `/dashboard/customer-segments` | `customer-segments` | `CustomerSegmentsScreen` | 356 |
| `/dashboard/custom-messages` | `custom-messages` | `CustomMessagesScreen` | 361 |
| `/dashboard/smart-pricing` | `smart-pricing` | `SmartPricingScreen` | 366 |
| `/dashboard/store-tools` | `store-tools` | `StoreToolsTab` | 372 |
| `/dashboard/ai-generation` | `ai-generation` | `StudioMainPage` | 378 |
| `/dashboard/content-studio` | `content-studio` | `StudioHomeScreen` | 384 |
| `/dashboard/content-studio/script-generator` | `studio-script` | `ScriptGeneratorScreen` | 390 |
| `/dashboard/content-studio/editor` | `studio-editor` | `SceneEditorScreen` | 400 |
| `/dashboard/content-studio/canvas` | `studio-canvas` | `CanvasEditorScreen` | 415 |
| `/dashboard/content-studio/preview` | `studio-preview` | `ComingSoonScreen` | 425 |
| `/dashboard/content-studio/export` | `studio-export` | `ExportScreen` | 432 |
| `/dashboard/ai-assistant` | `ai-assistant` | `AiAssistantScreen` | 444 |
| `/dashboard/content-generator` | `content-generator` | `ContentGeneratorScreen` | 449 |
| `/dashboard/smart-analytics` | `smart-analytics` | `SmartAnalyticsScreen` | 455 |
| `/dashboard/auto-reports` | `auto-reports` | `AutoReportsScreen` | 460 |
| `/dashboard/heatmap` | `heatmap` | `HeatmapScreen` | 465 |
| `/dashboard/orders` | `orders` | `OrdersTab` | 473 |
| `/dashboard/products` | `products` | `ProductsTab` | 479 |
| `/dashboard/products/add` | `add-product` | `AddProductScreen` | 485 |
| `/dashboard/products/:id` | `product-details` | `ProductDetailsScreen` | 498 |
| `/dashboard/conversations` | `conversations` | `ConversationsScreen` | 509 |
| `/dashboard/store` | `store` | `AppStoreScreen` | 515 |
| `/dashboard/store/create-store` | `create-store` | `CreateStoreScreen` | 521 |
| `/dashboard/about` | `about` | `AboutScreen` | 528 |

---

## 3️⃣ 🚨 Routes المعطلة (Broken Routes)

### Routes تُستخدم في الكود لكن غير موجودة في Router:

| Route المستخدم | الملف | السطر | المشكلة |
|---------------|-------|-------|---------|
| `/dashboard/settings` | `store_tab.dart` | 96 | ❌ **غير موجود في Router** |
| `/dashboard/account-settings` | `store_tab.dart` | 105 | ❌ **غير موجود في Router** |
| `/dashboard/store/settings` | `view_my_store_screen.dart` | 476 | ❌ **غير موجود في Router** |

### 🔧 الحل المقترح:
```
1. إضافة Route: /dashboard/settings → AccountSettingsScreen
2. إضافة Route: /dashboard/account-settings → AccountSettingsScreen  
3. إضافة Route: /dashboard/store/settings → CreateStoreScreen (تعديل)
```

---

## 4️⃣ 🔴 الشاشات غير المستخدمة (Dead Screens)

| الشاشة | الملف | السبب |
|--------|-------|-------|
| `PromotionsScreen` | `features/marketing/presentation/screens/promotions_screen.dart` | لا يوجد Route يشير إليها |
| `CodSettingsScreen` | `apps/merchant/features/payments/cod_settings_screen.dart` | لا يوجد Route |
| `DeliveryOptionsScreen` | `apps/merchant/features/delivery/delivery_options_screen.dart` | لا يوجد Route |
| `WhatsappScreen` | `apps/merchant/features/whatsapp/whatsapp_screen.dart` | لا يوجد Route |
| `QrCodeScreen` | `apps/merchant/features/qrcode/qr_code_screen.dart` | لا يوجد Route |
| `WidgetCatalogScreen` | `features/dev/widget_catalog_screen.dart` | Dev screen - لا يوجد Route |
| `StoreTab` | `features/store/presentation/screens/store_tab.dart` | Import فقط، غير مستخدم |
| `LoginScreen` (shared) | `shared/screens/login_screen.dart` | تكرار - يستخدم بدلاً منه auth version |

---

## 5️⃣ 🔄 اكتشاف التكرار والنسخ (Duplicates)

### ملفات مكررة:

| الملف الأصلي | الملف المكرر | سبب الاشتباه |
|--------------|--------------|--------------|
| `create_store_screen.dart` | `create_store_screen_backup.dart` | نسخة احتياطية - نفس الكلاس `CreateStoreScreen` |
| `features/auth/.../login_screen.dart` | `shared/screens/login_screen.dart` | شاشتي تسجيل دخول - نفس الاسم |

### 🔧 التوصية:
1. **حذف** `create_store_screen_backup.dart` بعد التأكد أن النسخة الأصلية تعمل
2. **حذف** `shared/screens/login_screen.dart` واستخدام النسخة في `features/auth`

---

## 6️⃣ ✅ Entry Points & MaterialApp

### Entry Point الرئيسي:
```
main.dart → AppShell → MerchantApp (GoRouter)
```

### MaterialApp Instances:
| الموقع | النوع | الغرض |
|--------|-------|-------|
| `merchant_app.dart:24` | `MaterialApp.router` | ✅ **الأساسي** - GoRouter |
| `app_shell.dart:92` | `MaterialApp` | ⚠️ Loading state |
| `app_shell.dart:107` | `MaterialApp` | ⚠️ Pre-login state |

### 🔧 ملاحظة:
- `MaterialApp` في `app_shell.dart` تُستخدم للحالات المؤقتة قبل التوجيه لـ `MerchantApp`
- هذا **مقبول** لأنها حالات مؤقتة (loading/pre-auth)

---

## 7️⃣ 📱 شجرة التنقل (Navigation Tree)

### Bottom Navigation Bar (5 تبويبات):
```
DashboardShell
├── [0] الرئيسية → /dashboard → HomeTab
├── [1] الطلبات → /dashboard/orders → OrdersTab  
├── [2] المنتجات → /dashboard/products → ProductsTab
├── [3] المحادثات → /dashboard/conversations → ConversationsScreen
└── [4] دروب شيب → /dashboard/dropshipping → DropshippingScreen
```

### Nested Routes من الرئيسية:
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
└── ... (المزيد)
```

### Routes خارج Shell:
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

---

## 8️⃣ 📝 Recommendations (التوصيات)

### 🔴 عاجل (High Priority):

1. **إضافة Routes المفقودة:**
   ```dart
   // في app_router.dart داخل Dashboard routes:
   GoRoute(
     path: 'settings',
     name: 'dashboard-settings',
     builder: (context, state) => const AccountSettingsScreen(),
   ),
   GoRoute(
     path: 'account-settings', 
     name: 'account-settings',
     builder: (context, state) => const AccountSettingsScreen(),
   ),
   ```

2. **إصلاح Route `/dashboard/store/settings`:**
   - إما إضافته كـ nested route تحت `/dashboard/store`
   - أو تغيير الكود في `view_my_store_screen.dart` لاستخدام route موجود

### 🟡 متوسط (Medium Priority):

3. **حذف الملفات المكررة:**
   - `create_store_screen_backup.dart` → حذف بعد التأكد
   - `shared/screens/login_screen.dart` → توحيد مع `features/auth`

4. **تفعيل أو حذف الشاشات غير المستخدمة:**
   - `PromotionsScreen` → إضافة Route أو حذف
   - `CodSettingsScreen` → إضافة Route أو حذف
   - `DeliveryOptionsScreen` → إضافة Route أو حذف
   - `WhatsappScreen` → إضافة Route أو حذف
   - `QrCodeScreen` → إضافة Route أو حذف

### 🟢 منخفض (Low Priority):

5. **توحيد LoginScreen:**
   - تحديث `app_router.dart` ليستخدم `features/auth/.../login_screen.dart`
   - حذف `shared/screens/login_screen.dart`

6. **تنظيف Dev Screen:**
   - `WidgetCatalogScreen` يمكن إبقاؤه للتطوير أو إضافة Route له

---

## 📈 إحصائيات الفحص

| المقياس | القيمة |
|---------|--------|
| إجمالي ملفات الشاشات | 82 |
| شاشات مستخدمة | 66 |
| شاشات غير مستخدمة | 8 |
| شاشات داخلية (Internal) | 6 |
| ملفات مكررة | 2 |
| Routes مسجلة | 56 |
| Routes معطلة | 3 |
| MaterialApp instances | 3 |
| GoRouter instances | 1 |

---

> **الخلاصة:** التطبيق بحالة جيدة بشكل عام مع بعض المشاكل البسيطة في Routes والملفات المكررة. الأولوية الأولى هي إصلاح الـ 3 Routes المعطلة.

---
*تم إنشاء هذا التقرير تلقائياً بتاريخ 2025-12-24*
