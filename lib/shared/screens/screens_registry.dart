// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    📋 سجل الصفحات الموحد - SCREENS REGISTRY               ║
// ║                                                                           ║
// ║   هذا الملف هو المرجع الرسمي لجميع صفحات التطبيق                          ║
// ║   أي تغيير في الأسماء أو المسارات يجب أن يبدأ من هنا                      ║
// ║                                                                           ║
// ║   تاريخ الإنشاء: 17 ديسمبر 2025                                           ║
// ║   آخر تحديث: 17 ديسمبر 2025                                               ║
// ║                                                                           ║
// ║   ⚠️ تحذير: هذا الملف مرجع فقط - لا تحذف الملفات الأصلية                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// حالة الصفحة
enum ScreenStatus {
  /// مكتملة وتعمل بشكل صحيح
  complete,

  /// تحتاج إصلاح
  needsFix,

  /// قيد التطوير
  inProgress,

  /// مخططة للمستقبل
  planned,
}

/// معلومات الصفحة
class ScreenInfo {
  /// اسم الصفحة بالعربي (كما يظهر في التطبيق)
  final String nameAr;

  /// اسم الصفحة بالإنجليزي (اسم الملف)
  final String nameEn;

  /// المسار في الـ Router
  final String route;

  /// مسار الملف
  final String filePath;

  /// وصف الصفحة
  final String description;

  /// حالة الصفحة
  final ScreenStatus status;

  /// ملاحظات الإصلاح
  final String? fixNotes;

  /// القسم
  final ScreenCategory category;

  const ScreenInfo({
    required this.nameAr,
    required this.nameEn,
    required this.route,
    required this.filePath,
    required this.description,
    required this.status,
    required this.category,
    this.fixNotes,
  });
}

/// أقسام الصفحات
enum ScreenCategory {
  /// البار السفلي
  bottomNav,

  /// الصفحة الرئيسية
  home,

  /// المنتجات
  products,

  /// المتجر
  store,

  /// المالية
  finance,

  /// التسويق
  marketing,

  /// أدوات AI
  aiTools,

  /// الإعدادات
  settings,

  /// المصادقة
  auth,
}

/// ════════════════════════════════════════════════════════════════════════════
/// 📱 سجل الصفحات الرسمي
/// ════════════════════════════════════════════════════════════════════════════
class ScreensRegistry {
  ScreensRegistry._();

  // ══════════════════════════════════════════════════════════════════════════
  // 🔽 البار السفلي (5 تبويبات)
  // ══════════════════════════════════════════════════════════════════════════

  static const homeTab = ScreenInfo(
    nameAr: 'الرئيسية',
    nameEn: 'home_tab',
    route: '/dashboard',
    filePath: 'lib/features/dashboard/presentation/screens/home_tab.dart',
    description:
        'الصفحة الرئيسية للتاجر - تحتوي على الإحصائيات وشبكة الأيقونات',
    status: ScreenStatus.complete,
    category: ScreenCategory.bottomNav,
  );

  static const ordersTab = ScreenInfo(
    nameAr: 'الطلبات',
    nameEn: 'orders_tab',
    route: '/dashboard/orders',
    filePath: 'lib/features/dashboard/presentation/screens/orders_tab.dart',
    description: 'قائمة طلبات المتجر',
    status: ScreenStatus.complete,
    category: ScreenCategory.bottomNav,
  );

  static const addProduct = ScreenInfo(
    nameAr: 'إضافة منتج',
    nameEn: 'add_product_screen',
    route: '/dashboard/products/add',
    filePath:
        'lib/features/products/presentation/screens/add_product_screen.dart',
    description: 'إضافة منتج جديد',
    status: ScreenStatus.complete,
    category: ScreenCategory.bottomNav,
  );

  static const conversationsTab = ScreenInfo(
    nameAr: 'المحادثات',
    nameEn: 'conversations_screen',
    route: '/dashboard/conversations',
    filePath:
        'lib/features/conversations/presentation/screens/conversations_screen.dart',
    description: 'محادثات العملاء',
    status: ScreenStatus.complete,
    category: ScreenCategory.bottomNav,
  );

  static const dropshippingTab = ScreenInfo(
    nameAr: 'دروب شوبينق',
    nameEn: 'dropshipping_screen',
    route: '/dashboard/dropshipping',
    filePath:
        'lib/features/dropshipping/presentation/screens/dropshipping_screen.dart',
    description: 'دروب شوبينق - في البار السفلي',
    status: ScreenStatus.complete,
    category: ScreenCategory.bottomNav,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 🏠 صفحات من الرئيسية
  // ══════════════════════════════════════════════════════════════════════════

  static const storeManagement = ScreenInfo(
    nameAr: 'إدارة المتجر',
    nameEn: 'merchant_services_screen',
    route: '/dashboard/store-management',
    filePath:
        'lib/features/dashboard/presentation/screens/merchant_services_screen.dart',
    description: 'إدارة إعدادات المتجر والخدمات',
    status: ScreenStatus.complete, // ✅ تم إصلاحه
    category: ScreenCategory.store,
    fixNotes: 'تم تفعيل جميع الأزرار وإضافة routes للخدمات',
  );

  static const webstore = ScreenInfo(
    nameAr: 'المتجر الإلكتروني',
    nameEn: 'webstore_screen',
    route: '/dashboard/webstore',
    filePath: 'lib/apps/merchant/features/webstore/webstore_screen.dart',
    description: 'تخصيص مظهر وتصميم المتجر الإلكتروني',
    status: ScreenStatus.complete,
    category: ScreenCategory.store,
    fixNotes: 'استبدل صفحة متجرك على جوك القديمة',
  );

  static const viewMyStore = ScreenInfo(
    nameAr: 'عرض متجري',
    nameEn: 'view_my_store_screen',
    route: '/dashboard/view-store',
    filePath:
        'lib/features/store/presentation/screens/view_my_store_screen.dart',
    description: 'معاينة المتجر كما يراه العملاء',
    status: ScreenStatus.complete, // ✅ تم إصلاحه
    category: ScreenCategory.store,
    fixNotes: 'تم إضافة بانر المعاينة وفصل المحتوى',
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 💰 صفحات الإحصائيات (البطاقات الأربعة)
  // ══════════════════════════════════════════════════════════════════════════

  static const wallet = ScreenInfo(
    nameAr: 'المحفظة',
    nameEn: 'wallet_screen',
    route: '/dashboard/wallet',
    filePath: 'lib/features/finance/presentation/screens/wallet_screen.dart',
    description: 'رصيد المحفظة والمعاملات',
    status: ScreenStatus.complete,
    category: ScreenCategory.finance,
  );

  static const points = ScreenInfo(
    nameAr: 'النقاط',
    nameEn: 'points_screen',
    route: '/dashboard/points',
    filePath: 'lib/features/finance/presentation/screens/points_screen.dart',
    description: 'نقاط المكافآت',
    status: ScreenStatus.complete, // ✅ تم إصلاحه
    category: ScreenCategory.finance,
    fixNotes: 'تم تغيير كروت المكافآت من ListView أفقي إلى GridView',
  );

  static const customers = ScreenInfo(
    nameAr: 'العملاء',
    nameEn: 'customers_screen',
    route: '/dashboard/customers',
    filePath:
        'lib/features/dashboard/presentation/screens/customers_screen.dart',
    description: 'قائمة عملاء المتجر',
    status: ScreenStatus.complete,
    category: ScreenCategory.home,
  );

  static const sales = ScreenInfo(
    nameAr: 'المبيعات',
    nameEn: 'sales_screen',
    route: '/dashboard/sales',
    filePath: 'lib/features/finance/presentation/screens/sales_screen.dart',
    description: 'إحصائيات المبيعات',
    status: ScreenStatus.complete,
    category: ScreenCategory.finance,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 🔲 شبكة الأيقونات (6 أيقونات)
  // ══════════════════════════════════════════════════════════════════════════

  static const shortcuts = ScreenInfo(
    nameAr: 'اختصاراتي',
    nameEn: 'shortcuts_screen',
    route: '/dashboard/shortcuts',
    filePath:
        'lib/features/dashboard/presentation/screens/shortcuts_screen.dart',
    description: 'اختصارات سريعة للميزات المستخدمة',
    status: ScreenStatus.complete, // ✅ تم التحقق - لا توجد عناصر مكررة
    category: ScreenCategory.home,
  );

  static const reports = ScreenInfo(
    nameAr: 'السجلات والتقارير',
    nameEn: 'reports_screen',
    route: '/dashboard/reports',
    filePath: 'lib/features/dashboard/presentation/screens/reports_screen.dart',
    description: 'التقارير والإحصائيات',
    status: ScreenStatus.complete, // ✅ تم إصلاحه
    category: ScreenCategory.home,
    fixNotes: 'تم إزالة البيانات الوهمية وإضافة تحذير',
  );

  static const productsTab = ScreenInfo(
    nameAr: 'المنتجات',
    nameEn: 'products_tab',
    route: '/dashboard/products',
    filePath: 'lib/features/dashboard/presentation/screens/products_tab.dart',
    description: 'إدارة المنتجات - 5 تبويبات',
    status: ScreenStatus.inProgress,
    category: ScreenCategory.products,
    fixNotes: 'إعدادات المنتجات تم إصلاحها - باقي الحذف للمحذوفات',
  );

  static const storeTools = ScreenInfo(
    nameAr: 'المتجر',
    nameEn: 'store_tools_tab',
    route: '/dashboard/store-tools',
    filePath: 'lib/features/store/presentation/screens/store_tools_tab.dart',
    description: 'أدوات المتجر (تسويق + AI)',
    status: ScreenStatus.complete, // ✅ تم إعادة تصميمه
    category: ScreenCategory.store,
    fixNotes: 'تم تحسين التصميم بإضافة وصف وتحسين الكروت',
  );

  static const aiStudio = ScreenInfo(
    nameAr: 'توليد AI',
    nameEn: 'ai_studio_cards_screen',
    route: '/dashboard/studio',
    filePath:
        'lib/features/ai_studio/presentation/screens/ai_studio_cards_screen.dart',
    description: 'استوديو الذكاء الاصطناعي',
    status: ScreenStatus.complete, // ✅ تم إعادة تصميمه
    category: ScreenCategory.aiTools,
    fixNotes: 'تم إعادة تصميم الشاشة بالكامل مع إحصائيات الاستخدام',
  );

  static const packages = ScreenInfo(
    nameAr: 'حزم التوفير',
    nameEn: 'mbuy_packages_screen',
    route: '/dashboard/packages',
    filePath:
        'lib/features/dashboard/presentation/screens/mbuy_packages_screen.dart',
    description: 'باقات الاشتراكات',
    status: ScreenStatus.complete,
    category: ScreenCategory.home,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 🛍️ صفحات المنتجات الفرعية
  // ══════════════════════════════════════════════════════════════════════════

  static const productDetails = ScreenInfo(
    nameAr: 'تفاصيل المنتج',
    nameEn: 'product_details_screen',
    route: '/dashboard/products/:id',
    filePath:
        'lib/features/products/presentation/screens/product_details_screen.dart',
    description: 'عرض وتعديل تفاصيل المنتج',
    status: ScreenStatus.complete,
    category: ScreenCategory.products,
  );

  static const productSettings = ScreenInfo(
    nameAr: 'إعدادات المنتجات',
    nameEn: 'product_settings_view',
    route: '-', // تبويب داخلي وليس صفحة منفصلة
    filePath:
        'lib/features/dashboard/presentation/screens/product_settings_view.dart',
    description: 'إعدادات المنتجات العامة',
    status: ScreenStatus.complete, // ✅ تم إعادة تصميمه
    category: ScreenCategory.products,
    fixNotes: 'تم إعادة تصميم الشاشة ببطاقات مقسمة وتصميم حديث',
  );

  static const inventory = ScreenInfo(
    nameAr: 'المخزون',
    nameEn: 'inventory_screen',
    route: '/dashboard/inventory',
    filePath: 'lib/features/store/presentation/screens/inventory_screen.dart',
    description: 'إدارة المخزون',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.products,
    fixNotes: 'مربوط بصفحة منفصلة بدلاً من التبويب',
  );

  static const auditLogs = ScreenInfo(
    nameAr: 'سجل العمليات',
    nameEn: 'audit_logs_screen',
    route: '/dashboard/audit-logs',
    filePath:
        'lib/features/dashboard/presentation/screens/audit_logs_screen.dart',
    description: 'سجل جميع العمليات',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.products,
    fixNotes: 'مربوط بصفحة منفصلة بدلاً من التبويب',
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 🏪 صفحات المتجر
  // ══════════════════════════════════════════════════════════════════════════

  static const storeTab = ScreenInfo(
    nameAr: 'المتجر (تبويب)',
    nameEn: 'store_tab',
    route: '/dashboard/store',
    filePath: 'lib/features/store/presentation/screens/store_tab.dart',
    description: 'تبويب المتجر في البار السفلي (غير مستخدم حالياً)',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.store,
    fixNotes: 'تحتاج إعادة تصميم',
  );

  static const createStore = ScreenInfo(
    nameAr: 'إنشاء متجر',
    nameEn: 'create_store_screen',
    route: '/dashboard/store/create-store',
    filePath:
        'lib/features/merchant/presentation/screens/create_store_screen.dart',
    description: 'إنشاء متجر جديد',
    status: ScreenStatus.complete,
    category: ScreenCategory.store,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 📣 صفحات التسويق
  // ══════════════════════════════════════════════════════════════════════════

  static const marketing = ScreenInfo(
    nameAr: 'التسويق',
    nameEn: 'marketing_screen',
    route: '/dashboard/marketing',
    filePath:
        'lib/features/marketing/presentation/screens/marketing_screen.dart',
    description: 'أدوات التسويق',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  static const coupons = ScreenInfo(
    nameAr: 'الكوبونات',
    nameEn: 'coupons_screen',
    route: '/dashboard/coupons',
    filePath: 'lib/features/marketing/presentation/screens/coupons_screen.dart',
    description: 'إدارة الكوبونات',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  static const flashSales = ScreenInfo(
    nameAr: 'العروض الخاطفة',
    nameEn: 'flash_sales_screen',
    route: '/dashboard/flash-sales',
    filePath:
        'lib/features/marketing/presentation/screens/flash_sales_screen.dart',
    description: 'العروض والتخفيضات السريعة',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 🤖 صفحات أدوات AI
  // ══════════════════════════════════════════════════════════════════════════

  static const aiAssistant = ScreenInfo(
    nameAr: 'المساعد الذكي',
    nameEn: 'ai_assistant_screen',
    route: '/dashboard/ai-assistant',
    filePath: 'lib/features/merchant/screens/ai_assistant_screen.dart',
    description: 'المساعد الذكي',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  static const contentGenerator = ScreenInfo(
    nameAr: 'مولد المحتوى',
    nameEn: 'content_generator_screen',
    route: '/dashboard/content-generator',
    filePath: 'lib/features/merchant/screens/content_generator_screen.dart',
    description: 'توليد محتوى بالذكاء الاصطناعي',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  static const smartAnalytics = ScreenInfo(
    nameAr: 'التحليلات الذكية',
    nameEn: 'smart_analytics_screen',
    route: '/dashboard/smart-analytics',
    filePath: 'lib/features/merchant/screens/smart_analytics_screen.dart',
    description: 'تحليلات متقدمة',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  static const smartPricing = ScreenInfo(
    nameAr: 'التسعير الذكي',
    nameEn: 'smart_pricing_screen',
    route: '/dashboard/smart-pricing',
    filePath: 'lib/features/merchant/screens/smart_pricing_screen.dart',
    description: 'تسعير تلقائي ذكي',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // ⚙️ صفحات الإعدادات
  // ══════════════════════════════════════════════════════════════════════════

  static const accountSettings = ScreenInfo(
    nameAr: 'إعدادات الحساب',
    nameEn: 'account_settings_screen',
    route: '/settings',
    filePath:
        'lib/features/settings/presentation/screens/account_settings_screen.dart',
    description: 'إعدادات الحساب الشخصي',
    status: ScreenStatus.complete,
    category: ScreenCategory.settings,
  );

  static const notifications = ScreenInfo(
    nameAr: 'الإشعارات',
    nameEn: 'notifications_screen',
    route: '/dashboard/notifications',
    filePath:
        'lib/features/dashboard/presentation/screens/notifications_screen.dart',
    description: 'إشعارات التطبيق',
    status: ScreenStatus.complete,
    category: ScreenCategory.settings,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 🔐 صفحات المصادقة
  // ══════════════════════════════════════════════════════════════════════════

  static const login = ScreenInfo(
    nameAr: 'تسجيل الدخول',
    nameEn: 'login_screen',
    route: '/login',
    filePath: 'lib/shared/screens/login_screen.dart',
    description: 'صفحة تسجيل الدخول',
    status: ScreenStatus.complete,
    category: ScreenCategory.auth,
  );

  static const register = ScreenInfo(
    nameAr: 'إنشاء حساب',
    nameEn: 'register_screen',
    route: '/register',
    filePath: 'lib/features/auth/presentation/screens/register_screen.dart',
    description: 'إنشاء حساب جديد',
    status: ScreenStatus.complete,
    category: ScreenCategory.auth,
  );

  static const forgotPassword = ScreenInfo(
    nameAr: 'نسيت كلمة المرور',
    nameEn: 'forgot_password_screen',
    route: '/forgot-password',
    filePath:
        'lib/features/auth/presentation/screens/forgot_password_screen.dart',
    description: 'استعادة كلمة المرور',
    status: ScreenStatus.complete,
    category: ScreenCategory.auth,
  );

  static const onboarding = ScreenInfo(
    nameAr: 'التعريف بالتطبيق',
    nameEn: 'onboarding_screen',
    route: '/onboarding',
    filePath:
        'lib/features/onboarding/presentation/screens/onboarding_screen.dart',
    description: 'شاشات التعريف بالتطبيق للمستخدم الجديد',
    status: ScreenStatus.complete,
    category: ScreenCategory.auth,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 📦 صفحات إضافية للمنتجات
  // ══════════════════════════════════════════════════════════════════════════

  static const productVariants = ScreenInfo(
    nameAr: 'متغيرات المنتج',
    nameEn: 'product_variants_screen',
    route: '/dashboard/product-variants',
    filePath: 'lib/features/merchant/screens/product_variants_screen.dart',
    description: 'إدارة متغيرات المنتجات (ألوان، مقاسات)',
    status: ScreenStatus.complete,
    category: ScreenCategory.products,
  );

  static const productBundles = ScreenInfo(
    nameAr: 'حزم المنتجات',
    nameEn: 'product_bundles_screen',
    route: '/dashboard/product-bundles',
    filePath: 'lib/features/merchant/screens/product_bundles_screen.dart',
    description: 'إنشاء حزم من عدة منتجات',
    status: ScreenStatus.complete,
    category: ScreenCategory.products,
  );

  static const digitalProducts = ScreenInfo(
    nameAr: 'المنتجات الرقمية',
    nameEn: 'digital_products_screen',
    route: '/dashboard/digital-products',
    filePath: 'lib/features/merchant/screens/digital_products_screen.dart',
    description: 'إدارة المنتجات الرقمية',
    status: ScreenStatus.complete,
    category: ScreenCategory.products,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 🏪 صفحات إضافية للمتجر
  // ══════════════════════════════════════════════════════════════════════════

  static const shipping = ScreenInfo(
    nameAr: 'الشحن',
    nameEn: 'shipping_screen',
    route: '/dashboard/shipping',
    filePath: 'lib/apps/merchant/features/shipping/shipping_screen.dart',
    description: 'إعدادات الشحن والتوصيل',
    status: ScreenStatus.complete,
    category: ScreenCategory.store,
  );

  static const paymentMethods = ScreenInfo(
    nameAr: 'طرق الدفع',
    nameEn: 'payment_methods_screen',
    route: '/dashboard/payment-methods',
    filePath:
        'lib/apps/merchant/features/store_settings/payment_methods/payment_methods_screen.dart',
    description: 'إدارة طرق الدفع',
    status: ScreenStatus.complete,
    category: ScreenCategory.store,
  );

  static const deliveryOptions = ScreenInfo(
    nameAr: 'خيارات التوصيل',
    nameEn: 'delivery_options_screen',
    route: '/dashboard/delivery-options',
    filePath:
        'lib/apps/merchant/features/store_settings/delivery_options/delivery_options_screen.dart',
    description: 'خيارات التوصيل المتاحة',
    status: ScreenStatus.complete,
    category: ScreenCategory.store,
  );

  static const codSettings = ScreenInfo(
    nameAr: 'الدفع عند الاستلام',
    nameEn: 'cod_settings_screen',
    route: '/dashboard/cod-settings',
    filePath:
        'lib/apps/merchant/features/store_settings/cod_settings/cod_settings_screen.dart',
    description: 'إعدادات الدفع عند الاستلام',
    status: ScreenStatus.complete,
    category: ScreenCategory.store,
  );

  static const qrCode = ScreenInfo(
    nameAr: 'رمز QR',
    nameEn: 'qr_code_screen',
    route: '/dashboard/qr-code',
    filePath: 'lib/apps/merchant/features/webstore/screens/qr_code_screen.dart',
    description: 'رموز QR للمتجر',
    status: ScreenStatus.complete,
    category: ScreenCategory.store,
  );

  static const supplierOrders = ScreenInfo(
    nameAr: 'طلبات الموردين',
    nameEn: 'supplier_orders_screen',
    route: '/dashboard/supplier-orders',
    filePath:
        'lib/features/dashboard/presentation/screens/supplier_orders_screen.dart',
    description: 'طلبات الموردين',
    status: ScreenStatus.complete,
    category: ScreenCategory.store,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 📣 صفحات إضافية للتسويق
  // ══════════════════════════════════════════════════════════════════════════

  static const promotions = ScreenInfo(
    nameAr: 'العروض الترويجية',
    nameEn: 'promotions_screen',
    route: '/dashboard/promotions',
    filePath:
        'lib/features/marketing/presentation/screens/promotions_screen.dart',
    description: 'إدارة العروض الترويجية',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  static const boostSales = ScreenInfo(
    nameAr: 'تعزيز المبيعات',
    nameEn: 'boost_sales_screen',
    route: '/dashboard/boost-sales',
    filePath:
        'lib/features/marketing/presentation/screens/boost_sales_screen.dart',
    description: 'أدوات تعزيز المبيعات',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  static const referral = ScreenInfo(
    nameAr: 'الإحالات',
    nameEn: 'referral_screen',
    route: '/dashboard/referral',
    filePath: 'lib/features/merchant/screens/referral_screen.dart',
    description: 'برنامج الإحالات',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  static const loyaltyProgram = ScreenInfo(
    nameAr: 'برنامج الولاء',
    nameEn: 'loyalty_program_screen',
    route: '/dashboard/loyalty-program',
    filePath: 'lib/features/merchant/screens/loyalty_program_screen.dart',
    description: 'برنامج ولاء العملاء',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  static const customMessages = ScreenInfo(
    nameAr: 'الرسائل المخصصة',
    nameEn: 'custom_messages_screen',
    route: '/dashboard/custom-messages',
    filePath: 'lib/features/merchant/screens/custom_messages_screen.dart',
    description: 'رسائل مخصصة للعملاء',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  static const whatsapp = ScreenInfo(
    nameAr: 'واتساب',
    nameEn: 'whatsapp_screen',
    route: '/dashboard/whatsapp',
    filePath:
        'lib/apps/merchant/features/webstore/screens/whatsapp_screen.dart',
    description: 'إعدادات واتساب للمتجر',
    status: ScreenStatus.complete,
    category: ScreenCategory.marketing,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 🤖 صفحات إضافية لأدوات AI
  // ══════════════════════════════════════════════════════════════════════════

  static const abandonedCart = ScreenInfo(
    nameAr: 'السلات المتروكة',
    nameEn: 'abandoned_cart_screen',
    route: '/dashboard/abandoned-cart',
    filePath: 'lib/features/merchant/screens/abandoned_cart_screen.dart',
    description: 'استعادة السلات المتروكة بالذكاء الاصطناعي',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  static const autoReports = ScreenInfo(
    nameAr: 'التقارير التلقائية',
    nameEn: 'auto_reports_screen',
    route: '/dashboard/auto-reports',
    filePath: 'lib/features/merchant/screens/auto_reports_screen.dart',
    description: 'تقارير تلقائية ذكية',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  static const customerSegments = ScreenInfo(
    nameAr: 'تقسيم العملاء',
    nameEn: 'customer_segments_screen',
    route: '/dashboard/customer-segments',
    filePath: 'lib/features/merchant/screens/customer_segments_screen.dart',
    description: 'تقسيم العملاء بالذكاء الاصطناعي',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  static const heatmap = ScreenInfo(
    nameAr: 'خريطة الحرارة',
    nameEn: 'heatmap_screen',
    route: '/dashboard/heatmap',
    filePath: 'lib/features/merchant/screens/heatmap_screen.dart',
    description: 'خريطة حرارة تفاعل العملاء',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  static const mbuyTools = ScreenInfo(
    nameAr: 'أدوات Mbuy',
    nameEn: 'mbuy_tools_screen',
    route: '/dashboard/mbuy-tools',
    filePath:
        'lib/features/dashboard/presentation/screens/mbuy_tools_screen.dart',
    description: 'أدوات Mbuy الذكية',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  static const mbuyStudio = ScreenInfo(
    nameAr: 'استوديو Mbuy',
    nameEn: 'mbuy_studio_screen',
    route: '/dashboard/mbuy-studio',
    filePath:
        'lib/features/dashboard/presentation/screens/mbuy_studio_screen.dart',
    description: 'استوديو Mbuy للمحتوى',
    status: ScreenStatus.complete,
    category: ScreenCategory.aiTools,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // ⚙️ صفحات إضافية للإعدادات
  // ══════════════════════════════════════════════════════════════════════════

  static const support = ScreenInfo(
    nameAr: 'الدعم الفني',
    nameEn: 'support_screen',
    route: '/support',
    filePath: 'lib/features/settings/presentation/screens/support_screen.dart',
    description: 'التواصل مع الدعم الفني',
    status: ScreenStatus.complete,
    category: ScreenCategory.settings,
  );

  static const privacyPolicy = ScreenInfo(
    nameAr: 'سياسة الخصوصية',
    nameEn: 'privacy_policy_screen',
    route: '/privacy-policy',
    filePath:
        'lib/features/settings/presentation/screens/privacy_policy_screen.dart',
    description: 'سياسة الخصوصية',
    status: ScreenStatus.complete,
    category: ScreenCategory.settings,
  );

  static const about = ScreenInfo(
    nameAr: 'حول التطبيق',
    nameEn: 'about_screen',
    route: '/about',
    filePath: 'lib/features/settings/presentation/screens/about_screen.dart',
    description: 'معلومات عن التطبيق',
    status: ScreenStatus.complete,
    category: ScreenCategory.settings,
  );

  static const terms = ScreenInfo(
    nameAr: 'الشروط والأحكام',
    nameEn: 'terms_screen',
    route: '/terms',
    filePath: 'lib/features/settings/presentation/screens/terms_screen.dart',
    description: 'شروط وأحكام الاستخدام',
    status: ScreenStatus.complete,
    category: ScreenCategory.settings,
  );

  static const community = ScreenInfo(
    nameAr: 'المجتمع',
    nameEn: 'community_screen',
    route: '/dashboard/community',
    filePath:
        'lib/features/dashboard/presentation/screens/community_screen.dart',
    description: 'مجتمع التجار',
    status: ScreenStatus.complete,
    category: ScreenCategory.settings,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 📋 قائمة جميع الصفحات
  // ══════════════════════════════════════════════════════════════════════════

  static const List<ScreenInfo> allScreens = [
    // البار السفلي
    homeTab,
    ordersTab,
    addProduct,
    conversationsTab,
    dropshippingTab,
    // من الرئيسية
    storeManagement,
    viewMyStore,
    // الإحصائيات
    wallet,
    points,
    customers,
    sales,
    // شبكة الأيقونات
    shortcuts,
    reports,
    productsTab,
    storeTools,
    aiStudio,
    packages,
    // المنتجات
    productDetails,
    productSettings,
    inventory,
    auditLogs,
    productVariants,
    productBundles,
    digitalProducts,
    // المتجر
    storeTab,
    createStore,
    webstore,
    shipping,
    paymentMethods,
    deliveryOptions,
    codSettings,
    qrCode,
    supplierOrders,
    // التسويق
    marketing,
    coupons,
    flashSales,
    promotions,
    boostSales,
    referral,
    loyaltyProgram,
    customMessages,
    whatsapp,
    // AI
    aiAssistant,
    contentGenerator,
    smartAnalytics,
    smartPricing,
    abandonedCart,
    autoReports,
    customerSegments,
    heatmap,
    mbuyTools,
    mbuyStudio,
    // الإعدادات
    accountSettings,
    notifications,
    support,
    privacyPolicy,
    about,
    terms,
    community,
    // المصادقة
    login,
    register,
    forgotPassword,
    onboarding,
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // 🔧 دوال مساعدة
  // ══════════════════════════════════════════════════════════════════════════

  /// الحصول على الصفحات التي تحتاج إصلاح
  static List<ScreenInfo> get screensNeedingFix {
    return allScreens.where((s) => s.status == ScreenStatus.needsFix).toList();
  }

  /// الحصول على الصفحات حسب القسم
  static List<ScreenInfo> getScreensByCategory(ScreenCategory category) {
    return allScreens.where((s) => s.category == category).toList();
  }

  /// الحصول على صفحة بالمسار
  static ScreenInfo? getScreenByRoute(String route) {
    try {
      return allScreens.firstWhere((s) => s.route == route);
    } catch (_) {
      return null;
    }
  }

  /// الحصول على تقرير الصفحات كنص
  static String getReport() {
    final buffer = StringBuffer();
    buffer.writeln(
      '═══════════════════════════════════════════════════════════════',
    );
    buffer.writeln('📋 تقرير الصفحات');
    buffer.writeln(
      '═══════════════════════════════════════════════════════════════',
    );
    buffer.writeln('إجمالي الصفحات: ${allScreens.length}');
    buffer.writeln(
      'مكتملة: ${allScreens.where((s) => s.status == ScreenStatus.complete).length}',
    );
    buffer.writeln('تحتاج إصلاح: ${screensNeedingFix.length}');
    buffer.writeln('');
    buffer.writeln('📛 الصفحات التي تحتاج إصلاح:');
    for (final screen in screensNeedingFix) {
      buffer.writeln('  - ${screen.nameAr} (${screen.nameEn})');
      if (screen.fixNotes != null) {
        buffer.writeln('    ⚠️ ${screen.fixNotes}');
      }
    }
    buffer.writeln(
      '═══════════════════════════════════════════════════════════════',
    );
    return buffer.toString();
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 📊 ملخص المشاكل المطلوب إصلاحها
// ══════════════════════════════════════════════════════════════════════════════
//
// 1. صفحة النقاط (points_screen):
//    - كروت المكافآت المتاحة تحتوي على أخطاء في المقاس
//
// 2. صفحة اختصاراتي (shortcuts_screen):
//    - تحتوي على عناصر مكررة
//
// 3. صفحة السجلات والتقارير (reports_screen):
//    - تحتوي على بيانات وهمية
//
// 4. صفحة المنتجات (products_tab):
//    - عند حذف منتج لا يذهب للمحذوفات
//    - إعدادات المنتجات غير صحيحة وتصميم سيئ
//    - تبويب المخزون والسجلات مربوطين بصفحات ثانية
//
// 5. صفحة إدارة المتجر (merchant_services_screen):
//    - لا تضغط إلا على زرين
//    - تعرض نفس محتوى عرض متجري
//
// 6. صفحة المتجر (store_tools_tab):
//    - تحتاج إعادة تصميم
//
// 7. صفحة توليد AI (ai_studio_cards_screen):
//    - تحتاج إعادة تصميم وربط حقيقي
//
// 8. صفحة عرض متجري (view_my_store_screen):
//    - تعرض نفس محتوى إدارة المتجر
//
// ══════════════════════════════════════════════════════════════════════════════
