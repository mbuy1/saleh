import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_dimensions.dart';
import '../widgets/shared_widgets.dart';

/// ============================================================================
/// Base Screen - الشاشة الأساسية
/// ============================================================================
///
/// شاشة أساسية توفر بنية موحدة لجميع شاشات التطبيق
///
/// الميزات:
/// - AppBar موحد
/// - حالات التحميل
/// - حالات الخطأ
/// - إعادة المحاولة
/// - Scaffold مع إعدادات موحدة
///
/// الاستخدام:
/// ```dart
/// class MyScreen extends BaseScreen {
///   @override
///   String get screenTitle => 'عنوان الشاشة';
///
///   @override
///   Widget buildBody(BuildContext context, WidgetRef ref) {
///     return ListView(...);
///   }
/// }
/// ```

/// Mixin يوفر وظائف مشتركة للشاشات
mixin ScreenMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// عرض حالة التحميل
  bool get isLoading => false;

  /// رسالة الخطأ (null إذا لا يوجد خطأ)
  String? get errorMessage => null;

  /// إعادة تحميل البيانات
  Future<void> onRefresh() async {}

  /// عرض SnackBar للخطأ
  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: onRefresh,
        ),
      ),
    );
  }

  /// عرض SnackBar للنجاح
  void showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// عرض Dialog للتأكيد
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDangerous
                ? TextButton.styleFrom(foregroundColor: AppTheme.errorColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// شاشة أساسية تستخدم ConsumerStatefulWidget
abstract class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key});
}

/// حالة الشاشة الأساسية
abstract class BaseScreenState<T extends BaseScreen> extends ConsumerState<T>
    with ScreenMixin<T> {
  /// عنوان الشاشة
  String get screenTitle;

  /// هل نعرض زر الرجوع؟
  bool get showBackButton => true;

  /// أزرار إضافية في AppBar
  List<Widget>? get actions => null;

  /// زر FAB (إذا وجد)
  Widget? get floatingActionButton => null;

  /// موقع FAB
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  /// شريط التنقل السفلي (إذا وجد)
  Widget? get bottomNavigationBar => null;

  /// لون الخلفية
  Color? get backgroundColor => AppTheme.backgroundColor;

  /// بناء محتوى الشاشة
  Widget buildBody(BuildContext context, WidgetRef ref);

  /// بناء widget للتحميل
  Widget buildLoading() {
    return const Center(child: MbuyLoadingIndicator());
  }

  /// بناء widget للخطأ
  Widget buildError(String message) {
    return MbuyEmptyState(
      icon: Icons.error_outline,
      title: 'حدث خطأ',
      subtitle: message,
      buttonLabel: 'إعادة المحاولة',
      onButtonPressed: onRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: MbuyAppBar(
        title: screenTitle,
        showBackButton: showBackButton,
        actions: actions,
      ),
      body: _buildContent(),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return buildLoading();
    }

    if (errorMessage != null) {
      return buildError(errorMessage!);
    }

    return buildBody(context, ref);
  }
}

/// ============================================================================
/// Base List Screen - شاشة قائمة أساسية
/// ============================================================================
///
/// شاشة مخصصة لعرض قوائم مع:
/// - Pull to refresh
/// - Infinite scrolling (pagination)
/// - حالة فارغة
/// - حالة تحميل أولي
/// - حالة تحميل المزيد
///
/// الاستخدام:
/// ```dart
/// class ProductsScreen extends BaseListScreen<Product> {
///   @override
///   String get screenTitle => 'المنتجات';
///
///   @override
///   Widget buildListItem(BuildContext context, Product item, int index) {
///     return ProductCard(product: item);
///   }
///
///   @override
///   Future<List<Product>> loadItems({int page = 1}) async {
///     return await productRepository.getProducts(page: page);
///   }
/// }
/// ```

abstract class BaseListScreen<T> extends BaseScreen {
  const BaseListScreen({super.key});
}

abstract class BaseListScreenState<W extends BaseListScreen<T>, T>
    extends BaseScreenState<W> {
  final ScrollController scrollController = ScrollController();
  final List<T> items = [];

  bool isLoadingMore = false;
  bool hasMoreItems = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// تحميل العناصر
  Future<List<T>> loadItems({int page = 1});

  /// بناء عنصر القائمة
  Widget buildListItem(BuildContext context, T item, int index);

  /// عنوان الحالة الفارغة
  String get emptyStateTitle => 'لا توجد عناصر';

  /// وصف الحالة الفارغة
  String? get emptyStateSubtitle => null;

  /// أيقونة الحالة الفارغة
  IconData get emptyStateIcon => Icons.inbox_outlined;

  /// هل نستخدم Separator بين العناصر؟
  bool get useSeparator => false;

  /// Padding للقائمة
  EdgeInsetsGeometry get listPadding => AppDimensions.screenPadding;

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        hasMoreItems) {
      _loadMoreItems();
    }
  }

  Future<void> _loadInitialData() async {
    currentPage = 1;
    items.clear();
    await _fetchItems();
  }

  Future<void> _loadMoreItems() async {
    if (isLoadingMore || !hasMoreItems) return;
    currentPage++;
    await _fetchItems(isLoadingMore: true);
  }

  Future<void> _fetchItems({bool isLoadingMore = false}) async {
    if (isLoadingMore) {
      setState(() => this.isLoadingMore = true);
    }

    try {
      final newItems = await loadItems(page: currentPage);
      setState(() {
        items.addAll(newItems);
        hasMoreItems = newItems.isNotEmpty;
        this.isLoadingMore = false;
      });
    } catch (e) {
      setState(() => this.isLoadingMore = false);
      showError(e.toString());
    }
  }

  @override
  Future<void> onRefresh() async {
    await _loadInitialData();
  }

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    if (items.isEmpty && !isLoadingMore) {
      return buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        padding: listPadding,
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        separatorBuilder: (context, index) => useSeparator
            ? const Divider()
            : const SizedBox(height: AppDimensions.spacing12),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spacing16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return buildListItem(context, items[index], index);
        },
      ),
    );
  }

  Widget buildEmptyState() {
    return MbuyEmptyState(
      icon: emptyStateIcon,
      title: emptyStateTitle,
      subtitle: emptyStateSubtitle,
    );
  }
}

/// ============================================================================
/// Base Form Screen - شاشة نموذج أساسية
/// ============================================================================
///
/// شاشة مخصصة للنماذج مع:
/// - Form validation
/// - حفظ التغييرات
/// - تحذير عند الخروج بدون حفظ
/// - حالة الإرسال
///
/// الاستخدام:
/// ```dart
/// class EditProfileScreen extends BaseFormScreen {
///   @override
///   String get screenTitle => 'تعديل الملف الشخصي';
///
///   @override
///   Widget buildForm(BuildContext context, WidgetRef ref) {
///     return Column(
///       children: [
///         TextFormField(
///           decoration: InputDecoration(labelText: 'الاسم'),
///           validator: (v) => v!.isEmpty ? 'مطلوب' : null,
///         ),
///       ],
///     );
///   }
///
///   @override
///   Future<void> onSubmit() async {
///     // حفظ البيانات
///   }
/// }
/// ```

abstract class BaseFormScreen extends BaseScreen {
  const BaseFormScreen({super.key});
}

abstract class BaseFormScreenState<T extends BaseFormScreen>
    extends BaseScreenState<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSubmitting = false;
  bool hasUnsavedChanges = false;

  /// نص زر الإرسال
  String get submitButtonText => 'حفظ';

  /// بناء حقول النموذج
  Widget buildForm(BuildContext context, WidgetRef ref);

  /// إرسال النموذج
  Future<void> onSubmit();

  /// هل النموذج صالح؟
  bool get isValid => formKey.currentState?.validate() ?? false;

  void markAsChanged() {
    if (!hasUnsavedChanges) {
      setState(() => hasUnsavedChanges = true);
    }
  }

  Future<void> _handleSubmit() async {
    if (!isValid) return;

    setState(() => isSubmitting = true);

    try {
      await onSubmit();
      hasUnsavedChanges = false;
    } catch (e) {
      showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!hasUnsavedChanges) return true;

    return await showConfirmDialog(
      title: 'تغييرات غير محفوظة',
      message: 'هل تريد الخروج بدون حفظ التغييرات؟',
      confirmText: 'خروج',
      cancelText: 'البقاء',
      isDangerous: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: AppDimensions.screenPadding,
      child: Form(
        key: formKey,
        onChanged: markAsChanged,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildForm(context, ref),
            const SizedBox(height: AppDimensions.spacing24),
            MbuyPrimaryButton(
              label: submitButtonText,
              onPressed: isSubmitting ? null : _handleSubmit,
              isLoading: isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// Base Details Screen - شاشة تفاصيل أساسية
/// ============================================================================
///
/// شاشة مخصصة لعرض تفاصيل عنصر واحد مع:
/// - تحميل البيانات
/// - أزرار الإجراءات
/// - حالة التحميل
///
/// الاستخدام:
/// ```dart
/// class ProductDetailsScreen extends BaseDetailsScreen<Product> {
///   final String productId;
///
///   ProductDetailsScreen({required this.productId});
///
///   @override
///   String get screenTitle => 'تفاصيل المنتج';
///
///   @override
///   Future<Product> loadItem() async {
///     return await productRepository.getProduct(productId);
///   }
///
///   @override
///   Widget buildDetails(BuildContext context, Product item) {
///     return Column(...);
///   }
/// }
/// ```

abstract class BaseDetailsScreen<T> extends BaseScreen {
  const BaseDetailsScreen({super.key});
}

abstract class BaseDetailsScreenState<W extends BaseDetailsScreen<T>, T>
    extends BaseScreenState<W> {
  T? item;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  /// تحميل العنصر
  Future<T> loadItem();

  /// بناء تفاصيل العنصر
  Widget buildDetails(BuildContext context, T item);

  /// أزرار الإجراءات
  List<Widget> buildActionButtons(T item) => [];

  Future<void> _loadItem() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      item = await loadItem();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Future<void> onRefresh() async {
    await _loadItem();
  }

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    if (item == null) {
      return buildError('لم يتم العثور على العنصر');
    }

    return SingleChildScrollView(
      padding: AppDimensions.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildDetails(context, item as T),
          if (buildActionButtons(item as T).isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacing24),
            ...buildActionButtons(item as T),
          ],
        ],
      ),
    );
  }
}
