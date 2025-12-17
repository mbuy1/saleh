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
    description: 'الصفحة الرئيسية للتاجر - تحتوي على الإحصائيات وشبكة الأيقونات',
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
    filePath: 'lib/features/products/presentation/screens/add_product_screen.dart',
    description: 'إضافة منتج جديد',
    status: ScreenStatus.complete,
    category: ScreenCategory.bottomNav,
  );

  static const conversationsTab = ScreenInfo(
    nameAr: 'المحادثات',
    nameEn: 'conversations_screen',
    route: '/dashboard/conversations',
    filePath: 'lib/features/conversations/presentation/screens/conversations_screen.dart',
    description: 'محادثات العملاء',
    status: ScreenStatus.complete,
    category: ScreenCategory.bottomNav,
  );

  static const dropshippingTab = ScreenInfo(
    nameAr: 'دروب شوبينق',
    nameEn: 'dropshipping_screen',
    route: '/dashboard/dropshipping',
    filePath: 'lib/features/dropshipping/presentation/screens/dropshipping_screen.dart',
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
    filePath: 'lib/features/dashboard/presentation/screens/merchant_services_screen.dart',
    description: 'إدارة إعدادات المتجر والخدمات',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.store,
    fixNotes: 'تعرض نفس محتوى عرض متجري - تحتاج فصل المحتوى',
  );

  static const storeAppearance = ScreenInfo(
    nameAr: 'مظهر المتجر',
    nameEn: 'store_on_jock_screen',
    route: '/dashboard/store-on-jock',
    filePath: 'lib/features/store/presentation/screens/store_on_jock_screen.dart',
    description: 'تخصيص مظهر المتجر على جوك',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.store,
    fixNotes: 'المسار كان خاطئ - تم التصحيح',
  );

  static const viewMyStore = ScreenInfo(
    nameAr: 'عرض متجري',
    nameEn: 'view_my_store_screen',
    route: '/dashboard/view-store',
    filePath: 'lib/features/store/presentation/screens/view_my_store_screen.dart',
    description: 'معاينة المتجر كما يراه العملاء',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.store,
    fixNotes: 'تعرض نفس محتوى إدارة المتجر',
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
    status: ScreenStatus.needsFix,
    category: ScreenCategory.finance,
    fixNotes: 'كروت المكافآت المتاحة تحتوي على أخطاء في المقاس',
  );

  static const customers = ScreenInfo(
    nameAr: 'العملاء',
    nameEn: 'customers_screen',
    route: '/dashboard/customers',
    filePath: 'lib/features/dashboard/presentation/screens/customers_screen.dart',
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
    filePath: 'lib/features/dashboard/presentation/screens/shortcuts_screen.dart',
    description: 'اختصارات سريعة للميزات المستخدمة',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.home,
    fixNotes: 'تحتوي على عناصر مكررة',
  );

  static const reports = ScreenInfo(
    nameAr: 'السجلات والتقارير',
    nameEn: 'reports_screen',
    route: '/dashboard/reports',
    filePath: 'lib/features/dashboard/presentation/screens/reports_screen.dart',
    description: 'التقارير والإحصائيات',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.home,
    fixNotes: 'تحتوي على بيانات وهمية',
  );

  static const productsTab = ScreenInfo(
    nameAr: 'المنتجات',
    nameEn: 'products_tab',
    route: '/dashboard/products',
    filePath: 'lib/features/dashboard/presentation/screens/products_tab.dart',
    description: 'إدارة المنتجات - 5 تبويبات',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.products,
    fixNotes: '''
    المشاكل:
    1. عند حذف منتج لا يذهب للمحذوفات
    2. إعدادات المنتجات غير صحيحة وتصميم سيئ
    3. تبويب المخزون والسجلات مربوطين بصفحات ثانية
    ''',
  );

  static const storeTools = ScreenInfo(
    nameAr: 'المتجر',
    nameEn: 'store_tools_tab',
    route: '/dashboard/store-tools',
    filePath: 'lib/features/store/presentation/screens/store_tools_tab.dart',
    description: 'أدوات المتجر (تسويق + AI)',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.store,
    fixNotes: 'تحتاج إعادة تصميم',
  );

  static const aiStudio = ScreenInfo(
    nameAr: 'توليد AI',
    nameEn: 'ai_studio_cards_screen',
    route: '/dashboard/studio',
    filePath: 'lib/features/ai_studio/presentation/screens/ai_studio_cards_screen.dart',
    description: 'استوديو الذكاء الاصطناعي',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.aiTools,
    fixNotes: 'تحتاج إعادة تصميم وربط حقيقي',
  );

  static const packages = ScreenInfo(
    nameAr: 'حزم التوفير',
    nameEn: 'mbuy_packages_screen',
    route: '/dashboard/packages',
    filePath: 'lib/features/dashboard/presentation/screens/mbuy_packages_screen.dart',
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
    filePath: 'lib/features/products/presentation/screens/product_details_screen.dart',
    description: 'عرض وتعديل تفاصيل المنتج',
    status: ScreenStatus.complete,
    category: ScreenCategory.products,
  );

  static const productSettings = ScreenInfo(
    nameAr: 'إعدادات المنتجات',
    nameEn: 'product_settings_view',
    route: '-', // تبويب داخلي وليس صفحة منفصلة
    filePath: 'lib/features/dashboard/presentation/screens/product_settings_view.dart',
    description: 'إعدادات المنتجات العامة',
    status: ScreenStatus.needsFix,
    category: ScreenCategory.products,
    fixNotes: 'تصميم سيئ - تحتاج إعادة تصميم',
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
    filePath: 'lib/features/dashboard/presentation/screens/audit_logs_screen.dart',
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
    filePath: 'lib/features/merchant/presentation/screens/create_store_screen.dart',
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
    filePath: 'lib/features/marketing/presentation/screens/marketing_screen.dart',
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
    filePath: 'lib/features/marketing/presentation/screens/flash_sales_screen.dart',
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
    filePath: 'lib/features/settings/presentation/screens/account_settings_screen.dart',
    description: 'إعدادات الحساب الشخصي',
    status: ScreenStatus.complete,
    category: ScreenCategory.settings,
  );

  static const notifications = ScreenInfo(
    nameAr: 'الإشعارات',
    nameEn: 'notifications_screen',
    route: '/dashboard/notifications',
    filePath: 'lib/features/dashboard/presentation/screens/notifications_screen.dart',
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
    storeAppearance,
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
    // المتجر
    storeTab,
    createStore,
    // التسويق
    marketing,
    coupons,
    flashSales,
    // AI
    aiAssistant,
    contentGenerator,
    smartAnalytics,
    smartPricing,
    // الإعدادات
    accountSettings,
    notifications,
    // المصادقة
    login,
    register,
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // 🔧 دوال مساعدة
  // ══════════════════════════════════════════════════════════════════════════

  /// الحصول على الصفحات التي تحتاج إصلاح
  static List<ScreenInfo> get screensNeedingFix {
    return allScreens
        .where((s) => s.status == ScreenStatus.needsFix)
        .toList();
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
    buffer.writeln('═══════════════════════════════════════════════════════════════');
    buffer.writeln('📋 تقرير الصفحات');
    buffer.writeln('═══════════════════════════════════════════════════════════════');
    buffer.writeln('إجمالي الصفحات: ${allScreens.length}');
    buffer.writeln('مكتملة: ${allScreens.where((s) => s.status == ScreenStatus.complete).length}');
    buffer.writeln('تحتاج إصلاح: ${screensNeedingFix.length}');
    buffer.writeln('');
    buffer.writeln('📛 الصفحات التي تحتاج إصلاح:');
    for (final screen in screensNeedingFix) {
      buffer.writeln('  - ${screen.nameAr} (${screen.nameEn})');
      if (screen.fixNotes != null) {
        buffer.writeln('    ⚠️ ${screen.fixNotes}');
      }
    }
    buffer.writeln('═══════════════════════════════════════════════════════════════');
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
