import 'package:flutter/material.dart';
import '../../data/services/product_variant_service.dart';
import '../../data/models/product_variant_model.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة إدارة Variants المنتج (المقاسات والألوان والخيارات)
class ProductVariantsScreen extends StatefulWidget {
  final String productId;
  final String? productName;

  const ProductVariantsScreen({
    super.key,
    required this.productId,
    this.productName,
  });

  @override
  State<ProductVariantsScreen> createState() => _ProductVariantsScreenState();
}

class _ProductVariantsScreenState extends State<ProductVariantsScreen> {
  List<ProductVariantModel> _variants = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVariants();
  }

  Future<void> _loadVariants() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final variants = await ProductVariantService.getProductVariants(widget.productId);
      setState(() {
        _variants = variants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddVariantDialog({ProductVariantModel? existingVariant}) async {
    final isEditing = existingVariant != null;
    
    final variantNameController = TextEditingController(
      text: existingVariant?.variantName ?? '',
    );
    final variantValueController = TextEditingController(
      text: existingVariant?.variantValue ?? '',
    );
    final priceModifierController = TextEditingController(
      text: existingVariant?.priceModifier?.toString() ?? '',
    );
    final stockQuantityController = TextEditingController(
      text: existingVariant?.stockQuantity?.toString() ?? '',
    );
    final skuController = TextEditingController(
      text: existingVariant?.sku ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'تعديل Variant' : 'إضافة Variant جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: variantNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الخيار (مثال: اللون، المقاس)',
                  hintText: 'اللون',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: variantValueController,
                decoration: const InputDecoration(
                  labelText: 'قيمة الخيار (مثال: أحمر، كبير)',
                  hintText: 'أحمر',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceModifierController,
                decoration: const InputDecoration(
                  labelText: 'تعديل السعر (اختياري، مثال: +10 أو -5)',
                  hintText: '0',
                  helperText: 'اتركه فارغاً للاستخدام الافتراضي',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockQuantityController,
                decoration: const InputDecoration(
                  labelText: 'الكمية المتوفرة (اختياري)',
                  hintText: '0',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: skuController,
                decoration: const InputDecoration(
                  labelText: 'SKU (اختياري)',
                  hintText: 'SKU-001',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (variantNameController.text.trim().isEmpty ||
                  variantValueController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرجاء إدخال اسم الخيار وقيمته'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                if (isEditing) {
                  await ProductVariantService.updateVariant(
                    variantId: existingVariant.id,
                    variantName: variantNameController.text.trim(),
                    variantValue: variantValueController.text.trim(),
                    priceModifier: priceModifierController.text.trim().isNotEmpty
                        ? double.tryParse(priceModifierController.text.trim())
                        : null,
                    stockQuantity: stockQuantityController.text.trim().isNotEmpty
                        ? int.tryParse(stockQuantityController.text.trim())
                        : null,
                    sku: skuController.text.trim().isNotEmpty
                        ? skuController.text.trim()
                        : null,
                  );
                } else {
                  await ProductVariantService.addVariant(
                    productId: widget.productId,
                    variantName: variantNameController.text.trim(),
                    variantValue: variantValueController.text.trim(),
                    priceModifier: priceModifierController.text.trim().isNotEmpty
                        ? double.tryParse(priceModifierController.text.trim())
                        : null,
                    stockQuantity: stockQuantityController.text.trim().isNotEmpty
                        ? int.tryParse(stockQuantityController.text.trim())
                        : null,
                    sku: skuController.text.trim().isNotEmpty
                        ? skuController.text.trim()
                        : null,
                  );
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
                await _loadVariants();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing
                          ? 'تم تحديث Variant بنجاح'
                          : 'تم إضافة Variant بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(isEditing ? 'حفظ' : 'إضافة'),
          ),
        ],
      ),
    );

    variantNameController.dispose();
    variantValueController.dispose();
    priceModifierController.dispose();
    stockQuantityController.dispose();
    skuController.dispose();
  }

  Future<void> _deleteVariant(ProductVariantModel variant) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text(
          'هل أنت متأكد من حذف ${variant.variantName}: ${variant.variantValue}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ProductVariantService.deleteVariant(variant.id);
        await _loadVariants();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف Variant بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في الحذف: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: Text(widget.productName != null
            ? 'Variants - ${widget.productName}'
            : 'إدارة Variants'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddVariantDialog(),
            tooltip: 'إضافة Variant',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('خطأ: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadVariants,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : _variants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.style_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد Variants لهذا المنتج',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => _showAddVariantDialog(),
                            child: const Text('إضافة Variant جديد'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadVariants,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _variants.length,
                        itemBuilder: (context, index) {
                          final variant = _variants[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: variant.imageUrl != null
                                  ? Image.network(
                                      variant.imageUrl!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.image);
                                      },
                                    )
                                  : const Icon(Icons.style),
                              title: Text('${variant.variantName}: ${variant.variantValue}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (variant.priceModifier != null)
                                    Text(
                                      variant.priceModifier! >= 0
                                          ? 'سعر إضافي: +${variant.priceModifier}'
                                          : 'خصم: ${variant.priceModifier}',
                                    ),
                                  if (variant.stockQuantity != null)
                                    Text('الكمية: ${variant.stockQuantity}'),
                                  if (variant.sku != null) Text('SKU: ${variant.sku}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showAddVariantDialog(existingVariant: variant),
                                    tooltip: 'تعديل',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteVariant(variant),
                                    tooltip: 'حذف',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

