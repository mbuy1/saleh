import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exports.dart';
import '../../data/merchant_store_provider.dart';

/// شاشة إنشاء أو تعديل متجر
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

  bool _isEditMode = false;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    // تحميل بيانات المتجر إذا كان موجوداً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final storeState = ref.read(merchantStoreControllerProvider);
        final store = storeState.store;

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
    super.dispose();
  }

  Future<void> _handleSaveStore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(merchantStoreControllerProvider.notifier);
    bool success;

    if (_isEditMode && _storeId != null) {
      // وضع التعديل
      success = await controller.updateStoreInfo(
        storeId: _storeId!,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        city: _cityController.text.trim(),
      );
    } else {
      // وضع الإنشاء
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

      // الانتقال للوحة التحكم أو العودة
      if (_isEditMode) {
        context.pop();
      } else {
        context.go('/dashboard');
      }
    } else {
      // عرض رسالة الخطأ
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

    return MbuyScaffold(
      showAppBar: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSubPageHeader(
                  context,
                  _isEditMode ? 'تعديل المتجر' : 'إنشاء متجر جديد',
                ),
                // أيقونة المتجر
                MbuyCircleIcon(
                  icon: Icons.store,
                  size: 80,
                  backgroundColor: AppTheme.primaryColor,
                  iconColor: Colors.white,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // عنوان ترحيبي
                if (!_isEditMode) ...[
                  Text(
                    'مرحباً بك!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  const Text(
                    'قم بإنشاء متجرك الإلكتروني وابدأ في عرض منتجاتك',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: AppDimensions.fontBody,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'تعديل معلومات المتجر',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  const Text(
                    'قم بتحديث معلومات متجرك',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: AppDimensions.fontBody,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppDimensions.spacing32),

                // حقل اسم المتجر
                MbuyInputField(
                  controller: _nameController,
                  label: 'اسم المتجر *',
                  hint: 'أدخل اسم متجرك',
                  prefixIcon: const Icon(
                    Icons.storefront,
                    color: AppTheme.textSecondaryColor,
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
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // حقل المدينة
                MbuyInputField(
                  controller: _cityController,
                  label: 'المدينة',
                  hint: 'أدخل مدينة المتجر',
                  prefixIcon: const Icon(
                    Icons.location_city,
                    color: AppTheme.textSecondaryColor,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // حقل الوصف
                MbuyInputField(
                  controller: _descriptionController,
                  label: 'وصف المتجر',
                  hint: 'أدخل وصفاً مختصراً لمتجرك',
                  prefixIcon: const Icon(
                    Icons.description,
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSaveStore(),
                ),
                const SizedBox(height: AppDimensions.spacing32),

                // زر الحفظ
                MbuyButton(
                  text: _isEditMode ? 'حفظ التعديلات' : 'إنشاء المتجر',
                  onPressed: isLoading ? null : _handleSaveStore,
                  isLoading: isLoading,
                  type: MbuyButtonType.primary,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // ملاحظة
                if (!_isEditMode)
                  Container(
                    padding: AppDimensions.paddingS,
                    decoration: BoxDecoration(
                      color: AppTheme.infoColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      border: Border.all(
                        color: AppTheme.infoColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.infoColor,
                          size: AppDimensions.iconM,
                        ),
                        const SizedBox(width: AppDimensions.spacing12),
                        const Expanded(
                          child: Text(
                            'يمكنك تعديل معلومات المتجر لاحقاً من صفحة الإعدادات',
                            style: TextStyle(
                              fontSize: AppDimensions.fontBody2,
                              color: AppTheme.infoColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubPageHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: AppDimensions.paddingXS,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          const SizedBox(width: AppDimensions.iconM + AppDimensions.spacing16),
        ],
      ),
    );
  }
}
