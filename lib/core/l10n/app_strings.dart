// ============================================================================
// MBUY Localization - Arabic Strings
// ============================================================================
//
// هذا الملف يحتوي على جميع النصوص العربية المستخدمة في التطبيق
// يُستخدم لضمان تناسق الترجمة وتسهيل التعديل المستقبلي

class AppStrings {
  // Prevent instantiation
  AppStrings._();

  // =========================================================================
  // General
  // =========================================================================

  static const String appName = 'MBUY';
  static const String loading = 'جاري التحميل...';
  static const String error = 'حدث خطأ';
  static const String retry = 'إعادة المحاولة';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String save = 'حفظ';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String add = 'إضافة';
  static const String search = 'بحث';
  static const String filter = 'تصفية';
  static const String sort = 'ترتيب';
  static const String all = 'الكل';
  static const String none = 'لا شيء';
  static const String yes = 'نعم';
  static const String no = 'لا';
  static const String ok = 'حسناً';
  static const String done = 'تم';
  static const String next = 'التالي';
  static const String back = 'رجوع';
  static const String close = 'إغلاق';
  static const String comingSoon = 'قريباً';
  static const String underDevelopment = 'قيد التطوير';

  // =========================================================================
  // Authentication
  // =========================================================================

  static const String login = 'تسجيل الدخول';
  static const String logout = 'تسجيل الخروج';
  static const String register = 'إنشاء حساب';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String resetPassword = 'إعادة تعيين كلمة المرور';
  static const String welcomeBack = 'مرحباً بك مجدداً';
  static const String createAccount = 'إنشاء حساب جديد';
  static const String alreadyHaveAccount = 'لديك حساب بالفعل؟';
  static const String dontHaveAccount = 'ليس لديك حساب؟';
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';
  static const String logoutSuccess = 'تم تسجيل الخروج بنجاح';
  static const String invalidCredentials = 'بيانات الدخول غير صحيحة';
  static const String emailRequired = 'البريد الإلكتروني مطلوب';
  static const String passwordRequired = 'كلمة المرور مطلوبة';
  static const String invalidEmail = 'البريد الإلكتروني غير صالح';
  static const String weakPassword = 'كلمة المرور ضعيفة';
  static const String passwordsDontMatch = 'كلمتا المرور غير متطابقتين';

  // =========================================================================
  // Navigation
  // =========================================================================

  static const String home = 'الرئيسية';
  static const String orders = 'الطلبات';
  static const String products = 'المنتجات';
  static const String store = 'المتجر';
  static const String profile = 'الملف الشخصي';
  static const String settings = 'الإعدادات';
  static const String notifications = 'الإشعارات';
  static const String conversations = 'المحادثات';
  static const String shortcuts = 'اختصاراتي';
  static const String marketing = 'التسويق';
  static const String analytics = 'التحليلات';
  static const String reports = 'التقارير';
  static const String customers = 'العملاء';
  static const String inventory = 'المخزون';
  static const String wallet = 'المحفظة';
  static const String points = 'النقاط';

  // =========================================================================
  // Dashboard
  // =========================================================================

  static const String dashboard = 'لوحة التحكم';
  static const String totalSales = 'إجمالي المبيعات';
  static const String totalOrders = 'إجمالي الطلبات';
  static const String totalProducts = 'إجمالي المنتجات';
  static const String totalCustomers = 'إجمالي العملاء';
  static const String todayOrders = 'طلبات اليوم';
  static const String pendingOrders = 'طلبات معلقة';
  static const String completedOrders = 'طلبات مكتملة';
  static const String cancelledOrders = 'طلبات ملغية';
  static const String revenue = 'الإيرادات';
  static const String profit = 'الأرباح';
  static const String expenses = 'المصروفات';

  // =========================================================================
  // Products
  // =========================================================================

  static const String addProduct = 'إضافة منتج';
  static const String editProduct = 'تعديل المنتج';
  static const String productName = 'اسم المنتج';
  static const String productDescription = 'وصف المنتج';
  static const String productPrice = 'سعر المنتج';
  static const String productStock = 'المخزون';
  static const String productCategory = 'التصنيف';
  static const String productImages = 'صور المنتج';
  static const String outOfStock = 'نفذ المخزون';
  static const String inStock = 'متوفر';
  static const String lowStock = 'مخزون منخفض';
  static const String sku = 'رمز المنتج (SKU)';
  static const String barcode = 'الباركود';
  static const String weight = 'الوزن';
  static const String dimensions = 'الأبعاد';
  static const String discount = 'الخصم';
  static const String comparePrice = 'السعر قبل الخصم';
  static const String costPrice = 'سعر التكلفة';
  static const String sellingPrice = 'سعر البيع';
  static const String noProducts = 'لا توجد منتجات';
  static const String addFirstProduct = 'أضف منتجك الأول';
  static const String productAddedSuccess = 'تم إضافة المنتج بنجاح';
  static const String productUpdatedSuccess = 'تم تحديث المنتج بنجاح';
  static const String productDeletedSuccess = 'تم حذف المنتج بنجاح';
  static const String deleteProductConfirm = 'هل أنت متأكد من حذف هذا المنتج؟';

  // =========================================================================
  // Orders
  // =========================================================================

  static const String orderNumber = 'رقم الطلب';
  static const String orderDate = 'تاريخ الطلب';
  static const String orderStatus = 'حالة الطلب';
  static const String orderTotal = 'إجمالي الطلب';
  static const String orderDetails = 'تفاصيل الطلب';
  static const String orderItems = 'عناصر الطلب';
  static const String orderPending = 'قيد الانتظار';
  static const String orderProcessing = 'قيد التجهيز';
  static const String orderShipped = 'تم الشحن';
  static const String orderDelivered = 'تم التسليم';
  static const String orderCancelled = 'ملغي';
  static const String orderRefunded = 'مسترجع';
  static const String shippingAddress = 'عنوان الشحن';
  static const String billingAddress = 'عنوان الفاتورة';
  static const String paymentMethod = 'طريقة الدفع';
  static const String shippingMethod = 'طريقة الشحن';
  static const String noOrders = 'لا توجد طلبات';
  static const String newOrderReceived = 'تم استلام طلب جديد';

  // =========================================================================
  // Store
  // =========================================================================

  static const String storeName = 'اسم المتجر';
  static const String storeDescription = 'وصف المتجر';
  static const String storeLogo = 'شعار المتجر';
  static const String storeBanner = 'بانر المتجر';
  static const String storeLink = 'رابط المتجر';
  static const String copyStoreLink = 'نسخ رابط المتجر';
  static const String shareStore = 'مشاركة المتجر';
  static const String viewStore = 'عرض المتجر';
  static const String storeSettings = 'إعدادات المتجر';
  static const String webstore = 'المتجر الإلكتروني';
  static const String linkCopied = 'تم نسخ الرابط';

  // =========================================================================
  // Marketing
  // =========================================================================

  static const String coupons = 'الكوبونات';
  static const String flashSales = 'العروض الخاطفة';
  static const String promotions = 'الترويج';
  static const String referrals = 'الإحالات';
  static const String abandonedCarts = 'السلات المتروكة';
  static const String createCoupon = 'إنشاء كوبون';
  static const String couponCode = 'كود الكوبون';
  static const String discountType = 'نوع الخصم';
  static const String discountValue = 'قيمة الخصم';
  static const String fixedDiscount = 'خصم ثابت';
  static const String percentageDiscount = 'نسبة مئوية';
  static const String minimumPurchase = 'الحد الأدنى للشراء';
  static const String usageLimit = 'حد الاستخدام';
  static const String validFrom = 'صالح من';
  static const String validUntil = 'صالح حتى';
  static const String couponCreatedSuccess = 'تم إنشاء الكوبون بنجاح';
  static const String noCoupons = 'لا توجد كوبونات';

  // =========================================================================
  // AI Studio
  // =========================================================================

  static const String aiStudio = 'استوديو AI';
  static const String aiTools = 'أدوات AI';
  static const String generateImage = 'توليد صورة';
  static const String generateVideo = 'توليد فيديو';
  static const String generate3D = 'توليد 3D';
  static const String generateAudio = 'توليد صوت';
  static const String generateText = 'توليد نص';
  static const String productDescriptionAI = 'وصف المنتج بالذكاء الاصطناعي';
  static const String aiAssistant = 'المساعد الذكي';
  static const String contentGenerator = 'منشئ المحتوى';
  static const String smartPricing = 'التسعير الذكي';
  static const String generating = 'جاري التوليد...';
  static const String generationComplete = 'اكتمل التوليد';
  static const String generationFailed = 'فشل التوليد';

  // =========================================================================
  // Analytics
  // =========================================================================

  static const String smartAnalytics = 'تحليلات ذكية';
  static const String salesChart = 'مخطط المبيعات';
  static const String topProducts = 'المنتجات الأكثر مبيعاً';
  static const String customerSegments = 'شرائح العملاء';
  static const String conversionRate = 'معدل التحويل';
  static const String averageOrderValue = 'متوسط قيمة الطلب';
  static const String pageViews = 'مشاهدات الصفحة';
  static const String visitors = 'الزوار';
  static const String bounceRate = 'معدل الارتداد';
  static const String timeOnSite = 'الوقت على الموقع';
  static const String heatmap = 'الخريطة الحرارية';
  static const String autoReports = 'تقارير تلقائية';

  // =========================================================================
  // Dropshipping
  // =========================================================================

  static const String dropshipping = 'دروب شيبينج';
  static const String supplierProducts = 'منتجات الموردين';
  static const String resellerListings = 'قوائم الموزعين';
  static const String supplierOrders = 'طلبات الموردين';
  static const String addToStore = 'إضافة للمتجر';
  static const String importProduct = 'استيراد منتج';
  static const String supplierPrice = 'سعر المورد';
  static const String yourPrice = 'سعرك';
  static const String profitMargin = 'هامش الربح';

  // =========================================================================
  // Inventory
  // =========================================================================

  static const String inventoryOverview = 'نظرة عامة على المخزون';
  static const String adjustStock = 'تعديل المخزون';
  static const String stockMovements = 'حركات المخزون';
  static const String lowStockAlert = 'تنبيه مخزون منخفض';
  static const String reorderLevel = 'مستوى إعادة الطلب';
  static const String stockIn = 'إضافة للمخزون';
  static const String stockOut = 'خصم من المخزون';
  static const String stockAdjustment = 'تعديل المخزون';
  static const String reason = 'السبب';
  static const String quantity = 'الكمية';

  // =========================================================================
  // Wallet & Points
  // =========================================================================

  static const String currentBalance = 'الرصيد الحالي';
  static const String availableBalance = 'الرصيد المتاح';
  static const String pendingBalance = 'الرصيد المعلق';
  static const String withdraw = 'سحب';
  static const String deposit = 'إيداع';
  static const String transactions = 'المعاملات';
  static const String pointsBalance = 'رصيد النقاط';
  static const String earnPoints = 'اكسب نقاط';
  static const String redeemPoints = 'استبدال النقاط';
  static const String pointsHistory = 'سجل النقاط';
  static const String noTransactions = 'لا توجد معاملات';
  static const String currency = 'ر.س';

  // =========================================================================
  // Notifications
  // =========================================================================

  static const String noNotifications = 'لا توجد إشعارات';
  static const String markAllRead = 'تحديد الكل كمقروء';
  static const String clearAll = 'مسح الكل';
  static const String newNotification = 'إشعار جديد';
  static const String orderNotification = 'إشعار طلب';
  static const String systemNotification = 'إشعار نظام';
  static const String promotionNotification = 'إشعار ترويجي';

  // =========================================================================
  // Errors
  // =========================================================================

  static const String unexpectedError = 'حدث خطأ غير متوقع';
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String serverError = 'خطأ في الخادم';
  static const String sessionExpired = 'انتهت صلاحية الجلسة';
  static const String unauthorized = 'غير مصرح';
  static const String notFound = 'غير موجود';
  static const String validationError = 'خطأ في البيانات';
  static const String tryAgainLater = 'يرجى المحاولة مرة أخرى لاحقاً';
  static const String contactSupport = 'تواصل مع الدعم إذا استمرت المشكلة';

  // =========================================================================
  // Empty States
  // =========================================================================

  static const String noData = 'لا توجد بيانات';
  static const String emptyList = 'القائمة فارغة';
  static const String noResults = 'لا توجد نتائج';
  static const String startAddingData = 'ابدأ بإضافة البيانات';
  static const String noCustomers = 'لا يوجد عملاء بعد';
  static const String noReports = 'لا توجد تقارير';
  static const String noConversations = 'لا توجد محادثات';

  // =========================================================================
  // Success Messages
  // =========================================================================

  static const String savedSuccessfully = 'تم الحفظ بنجاح';
  static const String deletedSuccessfully = 'تم الحذف بنجاح';
  static const String updatedSuccessfully = 'تم التحديث بنجاح';
  static const String createdSuccessfully = 'تم الإنشاء بنجاح';
  static const String operationSuccessful = 'تمت العملية بنجاح';
  static const String changesSaved = 'تم حفظ التغييرات';

  // =========================================================================
  // Confirmations
  // =========================================================================

  static const String areYouSure = 'هل أنت متأكد؟';
  static const String confirmDelete = 'هل تريد الحذف؟';
  static const String confirmCancel = 'هل تريد الإلغاء؟';
  static const String confirmLogout = 'هل تريد تسجيل الخروج؟';
  static const String unsavedChanges = 'لديك تغييرات غير محفوظة';
  static const String discardChanges = 'تجاهل التغييرات';
  static const String keepEditing = 'متابعة التعديل';
  static const String cannotBeUndone = 'لا يمكن التراجع عن هذا الإجراء';

  // =========================================================================
  // Settings
  // =========================================================================

  static const String accountSettings = 'إعدادات الحساب';
  static const String notificationSettings = 'إعدادات الإشعارات';
  static const String privacySettings = 'إعدادات الخصوصية';
  static const String language = 'اللغة';
  static const String arabic = 'العربية';
  static const String english = 'English';
  static const String darkMode = 'الوضع الداكن';
  static const String lightMode = 'الوضع الفاتح';
  static const String systemDefault = 'افتراضي النظام';
  static const String pushNotifications = 'الإشعارات الفورية';
  static const String emailNotifications = 'إشعارات البريد';
  static const String smsNotifications = 'إشعارات SMS';
  static const String about = 'حول التطبيق';
  static const String version = 'الإصدار';
  static const String termsOfService = 'شروط الخدمة';
  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String contactUs = 'تواصل معنا';
  static const String rateApp = 'قيّم التطبيق';
  static const String shareApp = 'شارك التطبيق';

  // =========================================================================
  // Time & Dates
  // =========================================================================

  static const String today = 'اليوم';
  static const String yesterday = 'أمس';
  static const String thisWeek = 'هذا الأسبوع';
  static const String thisMonth = 'هذا الشهر';
  static const String thisYear = 'هذه السنة';
  static const String lastWeek = 'الأسبوع الماضي';
  static const String lastMonth = 'الشهر الماضي';
  static const String lastYear = 'السنة الماضية';
  static const String selectDate = 'اختر التاريخ';
  static const String selectTime = 'اختر الوقت';
  static const String from = 'من';
  static const String to = 'إلى';
  static const String dateRange = 'نطاق التاريخ';
}
