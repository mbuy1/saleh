import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exports.dart';
import '../../data/merchant_store_provider.dart';

/// شاشة إعدادات المتجر - Store Settings Screen
/// تحتوي على الهوية ومعلومات الاتصال والسياسات وأوقات العمل
class CreateStoreScreen extends ConsumerStatefulWidget {
  const CreateStoreScreen({super.key});

  @override
  ConsumerState<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends ConsumerState<CreateStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _shippingPolicyController = TextEditingController();
  final _returnPolicyController = TextEditingController();

  bool _isEditMode = false;
  String? _storeId;
  bool _isStoreOpen = true;
  TimeOfDay _openTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 22, minute: 0);
  int _selectedDayIndex = 0; // 0 = الكل

  // Colors - App Store Design Style

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final storeAsync = ref.read(merchantStoreControllerProvider);
        final store = storeAsync.hasValue ? storeAsync.value : null;

        if (store != null) {
          setState(() {
            _isEditMode = true;
            _storeId = store.id;
            _nameController.text = store.name;
            _descriptionController.text = store.description ?? '';
            _cityController.text = store.city ?? '';
          });
        }
      } catch (e) {
        // في حالة حدوث خطأ، نبقى في وضع الإنشاء
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _shippingPolicyController.dispose();
    _returnPolicyController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveStore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(merchantStoreControllerProvider.notifier);
    bool success;

    if (_isEditMode && _storeId != null) {
      success = await controller.updateStoreInfo(
        storeId: _storeId!,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        city: _cityController.text.trim(),
      );
    } else {
      success = await controller.createStore(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        city: _cityController.text.trim(),
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode ? 'تم تحديث المتجر بنجاح' : 'تم إنشاء المتجر بنجاح',
          ),
          backgroundColor: Colors.green,
        ),
      );

      if (_isEditMode) {
        context.pop();
      } else {
        context.go('/dashboard');
      }
    } else {
      final error = ref.read(merchantStoreErrorProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error ?? (_isEditMode ? 'فشل تحديث المتجر' : 'فشل إنشاء المتجر'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(merchantStoreLoadingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppTheme.backgroundColorDark
        : AppTheme.backgroundLight;
    final cardColor = isDark ? AppTheme.cardColorDark : Colors.white;
    final textColor = isDark
        ? AppTheme.textPrimaryColorDark
        : AppTheme.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppTheme.textSecondaryColorDark
        : AppTheme.textSecondaryColor;
    final borderColor = isDark ? AppTheme.borderColorDark : Colors.grey[200]!;
    final inputBgColor = isDark
        ? AppTheme.backgroundColorDark
        : Colors.grey[50]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(
              context,
              isDark,
              textColor,
              backgroundColor,
              isLoading,
            ),
            // Content
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Section 1: Identity (الهوية)
                    _buildSectionHeader('الهوية', textColor),
                    _buildIdentitySection(
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      borderColor,
                      inputBgColor,
                      isDark,
                    ),

                    // Section 2: Contact Info (معلومات الاتصال)
                    _buildSectionHeader('معلومات الاتصال', textColor),
                    _buildContactSection(
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      borderColor,
                      inputBgColor,
                      isDark,
                    ),

                    // Section 3: Policies (السياسات)
                    _buildSectionHeader('السياسات', textColor),
                    _buildPoliciesSection(
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      borderColor,
                      inputBgColor,
                      isDark,
                    ),

                    // Section 4: Business Hours (أوقات العمل)
                    _buildBusinessHoursHeader(textColor, secondaryTextColor),
                    _buildBusinessHoursSection(
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      borderColor,
                      inputBgColor,
                      isDark,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color backgroundColor,
    bool isLoading,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.canPop() ? context.pop() : null,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(Icons.arrow_forward, color: textColor, size: 24),
            ),
          ),
          // Title
          Expanded(
            child: Text(
              'إعدادات المتجر',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          // Save Button
          GestureDetector(
            onTap: isLoading ? null : _handleSaveStore,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : const Text(
                      'حفظ',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildIdentitySection(
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
    Color inputBgColor,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.5)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Logo Upload
          InkWell(
            onTap: () {
              // TODO: Implement logo upload
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borderColor.withValues(alpha: 0.3)),
                ),
              ),
              child: Row(
                children: [
                  // Logo with edit badge
                  Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: const Icon(
                          Icons.store,
                          color: AppTheme.primaryColor,
                          size: 32,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: AppTheme.backgroundColorDark,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'شعار المتجر',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PNG, JPG بحد أقصى 2MB',
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_left, color: secondaryTextColor),
                ],
              ),
            ),
          ),

          // Store Name
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor.withValues(alpha: 0.3)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اسم المتجر',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'أدخل اسم المتجر',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    filled: true,
                    fillColor: inputBgColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال اسم المتجر';
                    }
                    if (value.trim().length < 3) {
                      return 'اسم المتجر يجب أن يكون 3 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),

          // Description
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نبذة عن المتجر',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(color: textColor),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'اكتب وصفاً مختصراً لمتجرك...',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    filled: true,
                    fillColor: inputBgColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
    Color inputBgColor,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.5)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Phone
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم الهاتف',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: '+966 50 123 4567',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    filled: true,
                    fillColor: inputBgColor,
                    prefixIcon: Icon(
                      Icons.call,
                      color: secondaryTextColor,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Email
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: borderColor.withValues(alpha: 0.3)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'البريد الإلكتروني',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'contact@storename.com',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    filled: true,
                    fillColor: inputBgColor,
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: secondaryTextColor,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Address/Location
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: borderColor.withValues(alpha: 0.3)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العنوان',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Container(
                        height: 128,
                        width: double.infinity,
                        color: isDark
                            ? AppTheme.backgroundColorDark
                            : Colors.grey[200],
                        child: Icon(
                          Icons.map_outlined,
                          size: 64,
                          color: secondaryTextColor.withValues(alpha: 0.5),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.4),
                          child: Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement location picker
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.surfaceColorDark
                                    .withValues(alpha: 0.8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: AppTheme.borderColorDark,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.location_on, size: 18),
                              label: const Text(
                                'تحديد الموقع',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoliciesSection(
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
    Color inputBgColor,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.5)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Shipping Policy
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor.withValues(alpha: 0.3)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سياسة الشحن',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                    Icon(
                      Icons.local_shipping_outlined,
                      color: secondaryTextColor,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _shippingPolicyController,
                  style: TextStyle(color: textColor, fontSize: 14),
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'مثال: الشحن خلال 3-5 أيام عمل لجميع مناطق المملكة...',
                    hintStyle: TextStyle(
                      color: secondaryTextColor.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: inputBgColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Return Policy
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سياسة الاسترجاع',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                    Icon(
                      Icons.assignment_return_outlined,
                      color: secondaryTextColor,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _returnPolicyController,
                  style: TextStyle(color: textColor, fontSize: 14),
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'مثال: الاسترجاع متاح خلال 14 يوم من تاريخ الشراء بشرط عدم فتح العبوة...',
                    hintStyle: TextStyle(
                      color: secondaryTextColor.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: inputBgColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHoursHeader(Color textColor, Color secondaryTextColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'أوقات العمل',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Row(
            children: [
              Text(
                _isStoreOpen ? 'مفتوح الآن' : 'مغلق',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _isStoreOpen
                      ? AppTheme.primaryColor
                      : secondaryTextColor,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isStoreOpen = !_isStoreOpen;
                  });
                },
                child: Container(
                  width: 40,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _isStoreOpen
                        ? AppTheme.primaryColor.withValues(alpha: 0.2)
                        : secondaryTextColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        right: _isStoreOpen ? 4 : null,
                        left: _isStoreOpen ? null : 4,
                        top: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _isStoreOpen
                                ? AppTheme.primaryColor
                                : secondaryTextColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHoursSection(
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
    Color inputBgColor,
    bool isDark,
  ) {
    final days = ['الكل', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.5)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Time Pickers
          Row(
            children: [
              // From Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'من الساعة',
                      style: TextStyle(fontSize: 12, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _openTime,
                        );
                        if (time != null) {
                          setState(() {
                            _openTime = time;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: inputBgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Center(
                          child: Text(
                            '${_openTime.hour.toString().padLeft(2, '0')}:${_openTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(color: textColor, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
                child: Text(
                  '-',
                  style: TextStyle(color: secondaryTextColor, fontSize: 16),
                ),
              ),
              // To Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إلى الساعة',
                      style: TextStyle(fontSize: 12, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _closeTime,
                        );
                        if (time != null) {
                          setState(() {
                            _closeTime = time;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: inputBgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Center(
                          child: Text(
                            '${_closeTime.hour.toString().padLeft(2, '0')}:${_closeTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(color: textColor, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Day Selector
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(days.length, (index) {
              final isSelected = _selectedDayIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDayIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : borderColor,
                    ),
                  ),
                  child: Text(
                    days[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : secondaryTextColor,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
