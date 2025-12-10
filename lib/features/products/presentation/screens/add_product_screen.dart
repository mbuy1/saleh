import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/products_controller.dart';

/// شاشة إضافة منتج جديد
class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await ref
          .read(productsControllerProvider.notifier)
          .addProduct(
            name: _nameController.text.trim(),
            price: double.parse(_priceController.text),
            stock: int.parse(_stockController.text),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            imageUrl: _imageUrlController.text.trim().isEmpty
                ? null
                : _imageUrlController.text.trim(),
          );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إضافة المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // العودة إلى قائمة المنتجات
      } else {
        final errorMessage =
            ref.read(productsControllerProvider).errorMessage ??
            'فشل إضافة المنتج';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج جديد'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // اسم المنتج
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم المنتج *',
                hintText: 'مثال: هاتف آيفون 15',
                prefixIcon: Icon(Icons.inventory_2),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال اسم المنتج';
                }
                if (value.trim().length < 3) {
                  return 'يجب أن يكون الاسم 3 أحرف على الأقل';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // الوصف
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                hintText: 'وصف تفصيلي للمنتج',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // السعر
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'السعر (ر.س) *',
                hintText: '0.00',
                prefixIcon: Icon(Icons.monetization_on),
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال السعر';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'يجب أن يكون السعر أكبر من 0';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // المخزون
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'المخزون *',
                hintText: '0',
                prefixIcon: Icon(Icons.inventory),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال كمية المخزون';
                }
                final stock = int.tryParse(value);
                if (stock == null || stock < 0) {
                  return 'يجب أن يكون المخزون 0 أو أكبر';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // رابط الصورة
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'رابط الصورة',
                hintText: 'https://example.com/image.jpg',
                prefixIcon: Icon(Icons.image),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),

            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : () => context.pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add),
                    label: Text(
                      _isSubmitting ? 'جاري الإضافة...' : 'إضافة المنتج',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
