# 🌲 هيكل مشروع Saleh (MBUY Flutter App)

```
saleh/
│
├── 📱 lib/                                    # Main Flutter application code
│   ├── 🎯 main.dart                          # Entry point
│   │
│   ├── ⚙️ core/                              # Core infrastructure
│   │   ├── constants/
│   │   │   └── app_constants.dart            # App-wide constants
│   │   │
│   │   ├── data/
│   │   │   ├── repositories/                 # Data repositories
│   │   │   ├── dummy_data.dart               # Sample data for testing
│   │   │   └── models.dart                   # Core data models
│   │   │
│   │   ├── errors/
│   │   │   └── app_error_codes.dart          # Error code definitions
│   │   │
│   │   ├── exceptions/
│   │   │   ├── app_exception.dart            # Custom exceptions
│   │   │   └── error_handler.dart            # Global error handling
│   │   │
│   │   ├── services/                         # Core services
│   │   │   ├── api_service.dart              # ✅ Main API Gateway to Worker
│   │   │   ├── mbuy_auth_helper.dart         # 🔐 MBUY Custom JWT Auth
│   │   │   ├── secure_storage_service.dart   # 🔒 Encrypted storage
│   │   │   ├── logger_service.dart           # 📝 Logging service
│   │   │   ├── preferences_service.dart      # 💾 User preferences
│   │   │   ├── cloudflare_images_service.dart # 🖼️ Image uploads
│   │   │   ├── media_service.dart            # 🎥 Video/Media handling
│   │   │   ├── ai_service.dart               # 🤖 AI features
│   │   │   ├── payment_service.dart          # 💳 Payment processing
│   │   │   ├── wallet_service.dart           # 👛 Wallet operations
│   │   │   ├── points_service.dart           # ⭐ Loyalty points
│   │   │   ├── order_service.dart            # 📦 Order management
│   │   │   ├── shipping_service.dart         # 🚚 Shipping tracking
│   │   │   ├── bnpl_service.dart             # 💰 Buy Now Pay Later
│   │   │   ├── fraud_detection_service.dart  # 🛡️ Security
│   │   │   ├── smart_search_service.dart     # 🔍 AI Search
│   │   │   └── automation_service.dart       # ⚡ Workflow automation
│   │   │
│   │   ├── session/
│   │   │   └── store_session.dart            # 🏪 Store session management
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart                # 🎨 App theming
│   │   │   ├── theme_provider.dart           # Theme state management
│   │   │   └── mbuy_widgets.dart             # Custom themed widgets
│   │   │
│   │   ├── utils/
│   │   │   └── auth_utils.dart               # Authentication utilities
│   │   │
│   │   ├── widgets/                          # Core reusable widgets
│   │   │   ├── mbuy_app_bar.dart             # Custom AppBar
│   │   │   ├── mbuy_scaffold.dart            # Custom Scaffold
│   │   │   └── mbuy_section_header.dart      # Section headers
│   │   │
│   │   ├── app_config.dart                   # App configuration
│   │   ├── app_router.dart                   # Navigation routing
│   │   ├── firebase_service.dart             # Firebase integration
│   │   ├── permissions_helper.dart           # Permissions management
│   │   ├── root_widget.dart                  # Root widget with auth
│   │   ├── role_based_root.dart              # Role-based navigation
│   │   └── merchant_admin_shell.dart         # Merchant/Admin shell
│   │
│   ├── 🎭 features/                          # Feature modules
│   │   │
│   │   ├── 👤 customer/                      # Customer features
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   ├── repositories/
│   │   │   │   └── services/
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── customer_home_screen.dart
│   │   │       │   ├── customer_products_screen.dart
│   │   │       │   ├── customer_cart_screen.dart
│   │   │       │   ├── customer_orders_screen.dart
│   │   │       │   ├── customer_wishlist_screen.dart
│   │   │       │   ├── customer_profile_screen.dart
│   │   │       │   ├── checkout_screen.dart
│   │   │       │   ├── order_tracking_screen.dart
│   │   │       │   └── product_details_screen.dart
│   │   │       │
│   │   │       └── widgets/
│   │   │           ├── cart_item_card.dart
│   │   │           ├── order_card.dart
│   │   │           └── checkout_summary.dart
│   │   │
│   │   ├── 🏪 merchant/                      # Merchant features
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── merchant_store.dart
│   │   │   │   │   ├── merchant_product.dart
│   │   │   │   │   └── merchant_order.dart
│   │   │   │   │
│   │   │   │   ├── repositories/
│   │   │   │   │   ├── merchant_repository.dart
│   │   │   │   │   └── store_repository.dart
│   │   │   │   │
│   │   │   │   └── services/
│   │   │   │       └── merchant_service.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── merchant_dashboard_screen.dart
│   │   │       │   ├── merchant_store_setup_screen.dart  # ✅ Store creation
│   │   │       │   ├── merchant_products_screen.dart
│   │   │       │   ├── merchant_add_product_screen.dart
│   │   │       │   ├── merchant_orders_screen.dart
│   │   │       │   ├── merchant_analytics_screen.dart
│   │   │       │   ├── merchant_profile_tab.dart
│   │   │       │   └── merchant_settings_screen.dart
│   │   │       │
│   │   │       └── widgets/
│   │   │           ├── analytics_card.dart
│   │   │           ├── order_management_card.dart
│   │   │           └── product_form_widgets.dart
│   │   │
│   │   ├── 🔐 auth/                          # Authentication
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   │
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository.dart   # 🔑 MBUY Custom JWT Auth
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart
│   │   │       │
│   │   │       └── screens/
│   │   │           ├── login_screen.dart
│   │   │           ├── signup_screen.dart
│   │   │           ├── reset_password_screen.dart
│   │   │           └── role_selection_screen.dart
│   │   │
│   │   ├── 👨‍💼 admin/                          # Admin features
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── admin_dashboard_screen.dart
│   │   │           ├── user_management_screen.dart
│   │   │           └── system_settings_screen.dart
│   │   │
│   │   ├── 💬 chat/                          # Chat/Support
│   │   │   └── domain/
│   │   │       └── chat_room.dart
│   │   │
│   │   ├── 🔄 common/                        # Common screens
│   │   │   ├── splash_screen.dart
│   │   │   └── smiley_cart_demo_screen.dart
│   │   │
│   │   └── 🤝 shared/                        # Shared feature components
│   │       ├── models/
│   │       │   ├── product_model.dart
│   │       │   ├── category_model.dart
│   │       │   ├── store_model.dart
│   │       │   └── order_model.dart
│   │       │
│   │       └── services/
│   │           ├── product_service.dart
│   │           └── category_service.dart
│   │
│   ├── 🎨 shared/                            # Shared UI components
│   │   ├── widgets/
│   │   │   ├── accessibility/                # Accessibility widgets
│   │   │   ├── error_widget/                 # Error displays
│   │   │   ├── shein/                        # SHEIN-style components
│   │   │   ├── skeleton/                     # Loading skeletons
│   │   │   │
│   │   │   ├── animated_smiley_cart_icon.dart
│   │   │   ├── smiley_cart_icon.dart         # 😊 Brand cart icon
│   │   │   ├── smiley_cart_logo.dart
│   │   │   ├── mbuy_logo.dart
│   │   │   ├── mbuy_search_bar.dart          # 🔍 Custom search
│   │   │   ├── enhanced_search_bar.dart
│   │   │   ├── product_card_compact.dart
│   │   │   ├── store_card_compact.dart
│   │   │   ├── hero_banner_carousel.dart
│   │   │   ├── categories_bar.dart
│   │   │   ├── bubble_categories_widget.dart
│   │   │   ├── story_ring.dart               # Stories feature
│   │   │   └── stats_card.dart
│   │   │
│   │   └── utils/
│   │       └── README.md
│   │
│   ├── 🧩 shared_widgets/                    # Additional shared widgets
│   │   ├── appbars/
│   │   │   └── shared_appbar.dart
│   │   ├── buttons/
│   │   │   └── primary_button.dart
│   │   ├── cards/
│   │   │   ├── product_card.dart
│   │   │   └── protection_banner.dart
│   │   ├── media/
│   │   │   └── image_text_widget.dart
│   │   └── navigation/
│   │       └── shared_bottom_nav.dart
│   │
│   └── 📚 examples/                          # Code examples
│       ├── api_service_examples.dart
│       ├── checkout_screen_example.dart
│       └── README.md
│
├── 🤖 android/                               # Android platform code
│   ├── app/
│   │   ├── src/
│   │   │   ├── debug/
│   │   │   ├── main/                         # AndroidManifest, etc.
│   │   │   └── profile/
│   │   ├── build.gradle.kts
│   │   └── google-services.json              # Firebase config
│   ├── gradle/
│   └── build.gradle.kts
│
├── 🍎 ios/                                   # iOS platform code
│   ├── Runner/
│   │   ├── Assets.xcassets/
│   │   ├── Base.lproj/
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   └── googleservice-info.plist          # Firebase config
│   └── Runner.xcodeproj/
│
├── 🖥️ windows/                               # Windows platform (not used)
├── 🐧 linux/                                 # Linux platform (not used)
├── 🌐 web/                                   # Web platform (not used)
│
├── 🧪 test/                                  # Unit/Widget tests
│
├── 📜 scripts/                               # Utility scripts
│   ├── add_one_product.ps1
│   ├── add_products.ps1
│   ├── add_sample_products.sql
│   └── clear_all_data.sql
│
├── ⚙️ Configuration Files
│   ├── pubspec.yaml                          # Dependencies & assets
│   ├── pubspec.lock                          # Locked versions
│   ├── analysis_options.yaml                 # Linter rules
│   ├── README.md                             # Project documentation
│   └── .gitignore
│
└── 🔧 IDE Configuration
    └── .vscode/
        ├── settings.json
        ├── launch.json
        ├── tasks.json
        └── extensions.json

```

## 🏗️ معمارية التطبيق (Architecture)

### 📊 Clean Architecture Pattern
```
Presentation Layer (UI)
    ↓
Business Logic Layer (Providers/Services)
    ↓
Data Layer (Repositories)
    ↓
External APIs (Cloudflare Worker)
```

### 🔗 التكامل الخارجي (External Integrations)

#### 1. **Cloudflare Worker** (API Gateway)
- URL: `https://misty-mode-b68b.baharista1.workers.dev`
- الوصول عبر: `lib/core/services/api_service.dart`
- المصادقة: MBUY Custom JWT (Bearer Token)

#### 2. **Supabase** (Backend)
- الوصول عبر Worker فقط (لا يوجد Supabase SDK في Flutter)
- Database: PostgreSQL
- Authentication: يتم عبر Worker

#### 3. **Firebase**
- Analytics: تتبع الأحداث
- Cloud Messaging (FCM): إشعارات push
- الوصول عبر: `lib/core/firebase_service.dart`

#### 4. **Cloudflare Images**
- رفع الصور عبر: `lib/core/services/cloudflare_images_service.dart`
- URL Upload Flow: Flutter → Worker → Cloudflare

## 🔑 المميزات الرئيسية (Key Features)

### 👥 للعملاء (Customers)
- 🏠 الصفحة الرئيسية مع منتجات مميزة
- 🔍 بحث ذكي متقدم
- 🛒 عربة التسوق
- ❤️ قائمة الأمنيات
- 📦 تتبع الطلبات
- 💳 الدفع الآمن
- 👛 محفظة إلكترونية
- ⭐ نظام النقاط

### 🏪 للتجار (Merchants)
- 📊 لوحة تحكم تحليلية
- ➕ إضافة/تعديل المنتجات
- 📦 إدارة الطلبات
- 🏪 إعداد المتجر
- 📈 تقارير المبيعات
- 💰 إدارة المحفظة

### 👨‍💼 للإدارة (Admins)
- 👥 إدارة المستخدمين
- 🏪 إدارة المتاجر
- ⚙️ إعدادات النظام
- 📊 تقارير شاملة

## 🔐 نظام المصادقة (Authentication)

### MBUY Custom JWT Authentication
```dart
// Login Flow:
1. User enters credentials
2. Worker validates & generates JWT + Refresh Token
3. Tokens stored in SecureStorage (encrypted)
4. JWT sent in Authorization header: "Bearer {token}"
5. Auto-refresh on 401 response
```

**الملفات المسؤولة:**
- `lib/core/services/mbuy_auth_helper.dart` - Helper functions
- `lib/features/auth/data/repositories/auth_repository.dart` - Main auth logic
- `lib/core/services/secure_storage_service.dart` - Token storage
- `lib/core/services/api_service.dart` - Auto-refresh & retry

## 📱 حالة التطبيق (State Management)

**Provider Pattern:**
- `AuthProvider` - حالة المصادقة
- `ThemeProvider` - حالة الثيم
- `CartProvider` - عربة التسوق
- `StoreSession` - جلسة المتجر للتاجر

## 🎨 التصميم (UI/UX)

### الثيمات:
- 🌞 Light Mode
- 🌙 Dark Mode
- ⚙️ System Default

### Brand Colors:
- Primary: MBUY Blue
- Secondary: MBUY Orange
- Accent: MBUY Green

### الخطوط:
- Arabic: Cairo
- English: Roboto

## 📦 الحزم الرئيسية (Main Dependencies)

```yaml
# State Management
provider: ^6.1.2

# HTTP & API
http: ^1.2.2

# Storage
flutter_secure_storage: ^9.2.2
shared_preferences: ^2.3.4

# Firebase
firebase_core: ^3.12.0
firebase_analytics: ^11.4.0
firebase_messaging: ^15.2.3

# UI
cached_network_image: ^3.4.1
image_picker: ^1.1.2
photo_view: ^0.15.0

# Utils
intl: ^0.20.1
uuid: ^4.5.1
```

## 🚀 بناء التطبيق (Build)

### Android:
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS:
```bash
flutter build ios --release
```

## 📊 الإحصائيات (Statistics)

- **عدد الملفات:** ~200+ Dart files
- **عدد الشاشات:** ~30+ screens
- **عدد الـ Services:** ~20+ services
- **عدد الـ Models:** ~15+ models
- **الحجم التقريبي:** ~10MB (APK)

## 🔧 الصيانة والتطوير (Maintenance)

### الملفات المهمة للمراجعة:
1. ✅ `lib/core/services/api_service.dart` - API calls
2. ✅ `lib/core/root_widget.dart` - App initialization
3. ✅ `lib/features/auth/data/repositories/auth_repository.dart` - Auth
4. ✅ `lib/features/merchant/presentation/screens/` - Merchant screens
5. ✅ `lib/core/session/store_session.dart` - Store management

### آخر التحديثات:
- ✅ إصلاح مشكلة إنشاء المتجر (Worker direct DB access)
- ✅ إزالة أزرار الرجوع من navigation tabs
- ✅ MBUY Custom JWT Authentication system
- ✅ Auto token refresh mechanism

---

**آخر تحديث:** 9 ديسمبر 2025
**الإصدار:** 1.0.0+1
**حالة المشروع:** ✅ Production Ready
