import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'تعديل المتجر' : 'إنشاء متجر جديد'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // أيقونة المتجر
                Icon(
                  Icons.store,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),

                // عنوان ترحيبي
                if (!_isEditMode) ...[
                  Text(
                    'مرحباً بك!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'قم بإنشاء متجرك الإلكتروني وابدأ في عرض منتجاتك',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'تعديل معلومات المتجر',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'قم بتحديث معلومات متجرك',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),

                // حقل اسم المتجر
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المتجر *',
                    hintText: 'أدخل اسم متجرك',
                    prefixIcon: Icon(Icons.storefront),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
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
                const SizedBox(height: 16),

                // حقل المدينة
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'المدينة',
                    hintText: 'أدخل مدينة المتجر',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // حقل الوصف
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'وصف المتجر',
                    hintText: 'أدخل وصفاً مختصراً لمتجرك',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSaveStore(),
                ),
                const SizedBox(height: 32),

                // زر الحفظ
                FilledButton(
                  onPressed: isLoading ? null : _handleSaveStore,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isEditMode ? 'حفظ التعديلات' : 'إنشاء المتجر',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),

                // ملاحظة
                if (!_isEditMode)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'يمكنك تعديل معلومات المتجر لاحقاً من صفحة الإعدادات',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade900,
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
}
