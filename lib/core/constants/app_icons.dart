// ============================================================
// APP ICONS - مركز الأيقونات الموحد
// ============================================================
// جميع مسارات الأيقونات SVG في مكان واحد
//
// الاستخدام:
// ```dart
// AppIcon(AppIcons.home)
// AppIcon(AppIcons.home, size: 28, color: Colors.blue)
// ```
// ============================================================

class AppIcons {
  AppIcons._();

  // ============================================================
  // المسار الأساسي للأيقونات
  // ============================================================
  static const String _basePath = 'assets/icons/';

  // ============================================================
  // التنقل والقوائم
  // ============================================================
  static const String home = '${_basePath}home.svg';
  static const String grid = '${_basePath}grid.svg';
  static const String menu = '${_basePath}menu.svg';
  static const String settings = '${_basePath}settings.svg';
  static const String moreVert = '${_basePath}more_vert.svg';
  static const String moreHoriz = '${_basePath}more_horiz.svg';

  // ============================================================
  // الأسهم والاتجاهات
  // ============================================================
  static const String arrowBack = '${_basePath}arrow_back.svg';
  static const String arrowForward = '${_basePath}arrow_forward.svg';
  static const String chevronDown = '${_basePath}chevron_down.svg';
  static const String chevronUp = '${_basePath}chevron_up.svg';
  static const String chevronLeft = '${_basePath}chevron_left.svg';
  static const String chevronRight = '${_basePath}chevron_right.svg';

  // ============================================================
  // الإجراءات الأساسية
  // ============================================================
  static const String add = '${_basePath}add.svg';
  static const String close = '${_basePath}close.svg';
  static const String edit = '${_basePath}edit.svg';
  static const String delete = '${_basePath}delete.svg';
  static const String search = '${_basePath}search.svg';
  static const String filter = '${_basePath}filter.svg';
  static const String sort = '${_basePath}sort.svg';
  static const String refresh = '${_basePath}refresh.svg';
  static const String share = '${_basePath}share.svg';
  static const String copy = '${_basePath}copy.svg';
  static const String download = '${_basePath}download.svg';
  static const String upload = '${_basePath}upload.svg';
  static const String link = '${_basePath}link.svg';

  // ============================================================
  // المستخدم والمصادقة
  // ============================================================
  static const String person = '${_basePath}person.svg';
  static const String email = '${_basePath}email.svg';
  static const String lock = '${_basePath}lock.svg';
  static const String visibility = '${_basePath}visibility.svg';
  static const String visibilityOff = '${_basePath}visibility_off.svg';
  static const String login = '${_basePath}login.svg';
  static const String logout = '${_basePath}logout.svg';

  // ============================================================
  // الوسائط والصور
  // ============================================================
  static const String camera = '${_basePath}camera.svg';
  static const String image = '${_basePath}image.svg';

  // ============================================================
  // التجارة والمتجر
  // ============================================================
  static const String store = '${_basePath}store.svg';
  static const String storefront = '${_basePath}storefront.svg';
  static const String shoppingBag = '${_basePath}shopping_bag.svg';
  static const String cart = '${_basePath}cart.svg';
  static const String inventory = '${_basePath}inventory.svg';
  static const String tag = '${_basePath}tag.svg';
  static const String discount = '${_basePath}discount.svg';

  // ============================================================
  // المال والإحصائيات
  // ============================================================
  static const String chart = '${_basePath}chart.svg';
  static const String money = '${_basePath}money.svg';
  static const String wallet = '${_basePath}wallet.svg';
  static const String trendingUp = '${_basePath}trending_up.svg';
  static const String trendingDown = '${_basePath}trending_down.svg';

  // ============================================================
  // التنبيهات والحالات
  // ============================================================
  static const String notifications = '${_basePath}notifications.svg';
  static const String check = '${_basePath}check.svg';
  static const String checkCircle = '${_basePath}check_circle.svg';
  static const String error = '${_basePath}error.svg';
  static const String errorOutline = '${_basePath}error_outline.svg';
  static const String warning = '${_basePath}warning.svg';
  static const String info = '${_basePath}info.svg';
  static const String help = '${_basePath}help.svg';

  // ============================================================
  // الوسائط والفيديو
  // ============================================================
  static const String save = '${_basePath}save.svg';
  static const String imageNotSupported = '${_basePath}image_not_supported.svg';
  static const String brokenImage = '${_basePath}broken_image.svg';
  static const String playArrow = '${_basePath}play_arrow.svg';
  static const String pause = '${_basePath}pause.svg';
  static const String fullscreen = '${_basePath}fullscreen.svg';

  // ============================================================
  // التسويق
  // ============================================================
  static const String megaphone = '${_basePath}megaphone.svg';

  // ============================================================
  // التواصل
  // ============================================================
  static const String chat = '${_basePath}chat.svg';

  // ============================================================
  // الشحن والتوصيل
  // ============================================================
  static const String shipping = '${_basePath}shipping.svg';

  // ============================================================
  // الطلبات
  // ============================================================
  static const String orders = '${_basePath}orders.svg';

  // ============================================================
  // المنتجات
  // ============================================================
  static const String product = '${_basePath}product.svg';

  // ============================================================
  // الاختصارات
  // ============================================================
  static const String shortcuts = '${_basePath}shortcuts.svg';

  // ============================================================
  // المفضلة والمستخدمين
  // ============================================================
  static const String favorites = '${_basePath}favorites.svg';
  static const String favorite = '${_basePath}favorite.svg';
  static const String users = '${_basePath}users.svg';
  static const String peopleOutline = '${_basePath}people_outline.svg';
  static const String shoppingBagOutlined =
      '${_basePath}shopping_bag_outlined.svg';

  // ============================================================
  // معلومات الاتصال
  // ============================================================
  static const String phone = '${_basePath}phone.svg';
  static const String globe = '${_basePath}globe.svg';
  static const String location = '${_basePath}location.svg';

  // ============================================================
  // الوقت والتاريخ
  // ============================================================
  static const String calendar = '${_basePath}calendar.svg';
  static const String time = '${_basePath}time.svg';

  // ============================================================
  // التفضيلات
  // ============================================================
  static const String star = '${_basePath}star.svg';
  static const String heart = '${_basePath}heart.svg';

  // ============================================================
  // أيقونات إضافية
  // ============================================================
  static const String flash = '${_basePath}flash.svg';
  static const String package = '${_basePath}package.svg';
  static const String write = '${_basePath}write.svg';
  static const String bot = '${_basePath}bot.svg';
  static const String tools = '${_basePath}tools.svg';
  static const String sparkle = '${_basePath}sparkle.svg';
  static const String gift = '${_basePath}gift.svg';
  static const String storeLocation = '${_basePath}store_location.svg';
  static const String creditCard = '${_basePath}credit_card.svg';
  static const String eye = '${_basePath}eye.svg';
  static const String cameraAlt = '${_basePath}camera_alt.svg';
  static const String monitor = '${_basePath}monitor.svg';
  static const String broadcast = '${_basePath}broadcast.svg';
  static const String activity = '${_basePath}activity.svg';
  static const String dollar = '${_basePath}dollar.svg';
  static const String pieChart = '${_basePath}pie_chart.svg';
  static const String analytics = '${_basePath}analytics.svg';
  static const String bulb = '${_basePath}bulb.svg';
  static const String sliders = '${_basePath}sliders.svg';
  static const String playCircle = '${_basePath}play_circle.svg';
  static const String verified = '${_basePath}verified.svg';
  static const String qrCode = '${_basePath}qr_code.svg';
  static const String document = '${_basePath}document.svg';
  static const String unlock = '${_basePath}unlock.svg';
  static const String growth = '${_basePath}growth.svg';
  static const String group = '${_basePath}group.svg';
  static const String key = '${_basePath}key.svg';
  static const String layout = '${_basePath}layout.svg';
  static const String building = '${_basePath}building.svg';
  static const String loyalty = '${_basePath}loyalty.svg';
  static const String inbox = '${_basePath}inbox.svg';
  static const String badgeCheck = '${_basePath}badge_check.svg';
  static const String sun = '${_basePath}sun.svg';
  static const String moon = '${_basePath}moon.svg';
  static const String uploadCloud = '${_basePath}upload_cloud.svg';
  static const String downloadCloud = '${_basePath}download_cloud.svg';
  static const String layers = '${_basePath}layers.svg';
  static const String shield = '${_basePath}shield.svg';
  static const String mic = '${_basePath}mic.svg';
  static const String pencil = '${_basePath}pencil.svg';

  // ============================================================
  // العضويات والدعم
  // ============================================================
  static const String cardMembership = '${_basePath}card_membership.svg';
  static const String supportAgent = '${_basePath}support_agent.svg';
  static const String points = '${_basePath}points.svg';

  // ============================================================
  // التصنيفات والإعدادات
  // ============================================================
  static const String category = '${_basePath}category.svg';
  static const String importExport = '${_basePath}import_export.svg';

  // ============================================================
  // الحملات والترويج
  // ============================================================
  static const String campaign = '${_basePath}campaign.svg';
  static const String pin = '${_basePath}pin.svg';
  static const String rocket = '${_basePath}rocket.svg';

  // ============================================================
  // السجل والتقارير
  // ============================================================
  static const String history = '${_basePath}history.svg';
  static const String assessment = '${_basePath}assessment.svg';

  // ============================================================
  // التحكم
  // ============================================================
  static const String stop = '${_basePath}stop.svg';
  static const String removeCircle = '${_basePath}remove_circle.svg';
  static const String addCircle = '${_basePath}add_circle.svg';

  // ============================================================
  // المخزون والمنتجات
  // ============================================================
  static const String inventory2 = '${_basePath}inventory_2.svg';
  static const String sync = '${_basePath}sync.svg';
  static const String returnIcon = '${_basePath}return.svg';

  // ============================================================
  // الدفع والمالية
  // ============================================================
  static const String payment = '${_basePath}payment.svg';

  // ============================================================
  // علامات التأكيد
  // ============================================================
  static const String doneAll = '${_basePath}done_all.svg';

  // ============================================================
  // الوسائط والفيديو
  // ============================================================
  static const String videocam = '${_basePath}videocam.svg';
  static const String addPhoto = '${_basePath}add_photo.svg';

  // ============================================================
  // المنتجات والإضافة
  // ============================================================
  static const String monetization = '${_basePath}monetization.svg';
  static const String scale = '${_basePath}scale.svg';
  static const String timer = '${_basePath}timer.svg';
  static const String subdirectory = '${_basePath}subdirectory.svg';
  static const String schedule = '${_basePath}schedule.svg';
  static const String autoAwesome = '${_basePath}auto_awesome.svg';
  static const String description = '${_basePath}description.svg';
  static const String cancel = '${_basePath}cancel.svg';

  // ============================================================
  // العملاء
  // ============================================================
  static const String people = '${_basePath}people.svg';
  static const String attachMoney = '${_basePath}attach_money.svg';

  // ============================================================
  // الباقات والعروض
  // ============================================================
  static const String localOffer = '${_basePath}local_offer.svg';
  static const String rocketLaunch = '${_basePath}rocket_launch.svg';
  static const String workspacePremium = '${_basePath}workspace_premium.svg';
  static const String businessCenter = '${_basePath}business_center.svg';
  static const String apartment = '${_basePath}apartment.svg';

  // ============================================================
  // أيقونات إضافية للتقارير
  // ============================================================
  static const String removeShoppingCart =
      '${_basePath}remove_shopping_cart.svg';
  static const String personAdd = '${_basePath}person_add.svg';
}
