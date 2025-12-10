import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/products_controller.dart';
import '../../domain/models/product.dart';

/// شاشة تفاصيل المنتج مع إمكانية التعديل والحذف
class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  bool _isEditing = false;
  bool _isSubmitting = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;

  Product? _currentProduct;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _initializeControllers(Product product) {
    if (_currentProduct?.id != product.id) {
      _currentProduct = product;
      _nameController.text = product.name;
      _descriptionController.text = product.description ?? '';
      _priceController.text = product.price.toStringAsFixed(2);
      _stockController.text = product.stock.toString();
      _imageUrlController.text = product.imageUrl ?? '';
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await ref
          .read(productsControllerProvider.notifier)
          .updateProduct(
            productId: widget.productId,
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
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorMessage =
            ref.read(productsControllerProvider).errorMessage ??
            'فشل تحديث المنتج';
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

  Future<void> _deleteProduct() async {
    // تأكيد الحذف
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: const Text(
          'هل أنت متأكد من حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);

    try {
      final success = await ref
          .read(productsControllerProvider.notifier)
          .deleteProduct(widget.productId);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // العودة إلى قائمة المنتجات
      } else {
        final errorMessage =
            ref.read(productsControllerProvider).errorMessage ??
            'فشل حذف المنتج';
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
    final productsState = ref.watch(productsControllerProvider);
    final product = productsState.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => Product(
        id: widget.productId,
        name: 'غير موجود',
        price: 0,
        stock: 0,
        storeId: '',
      ),
    );

    if (product.name == 'غير موجود') {
      return Scaffold(
        appBar: AppBar(title: const Text('المنتج غير موجود')),
        body: const Center(child: Text('لم يتم العثور على المنتج')),
      );
    }

    _initializeControllers(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'تعديل المنتج' : 'تفاصيل المنتج'),
        centerTitle: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'تعديل',
            ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteProduct,
              tooltip: 'حذف',
            ),
        ],
      ),
      body: _isEditing ? _buildEditForm(product) : _buildDetailsView(product),
    );
  }

  Widget _buildDetailsView(Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          if (product.imageUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 24),

          // اسم المنتج
          Text(
            product.name,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // السعر والمخزون
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.green),
                        const SizedBox(height: 8),
                        Text(
                          '${product.price.toStringAsFixed(2)} ر.س',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('السعر'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory,
                          color: product.stock > 0 ? Colors.blue : Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.stock.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('المخزون'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الحالة
          Card(
            child: ListTile(
              leading: Icon(
                product.isActive ? Icons.check_circle : Icons.visibility_off,
                color: product.isActive ? Colors.green : Colors.grey,
              ),
              title: Text(product.isActive ? 'نشط' : 'غير نشط'),
              subtitle: const Text('حالة المنتج'),
            ),
          ),
          const SizedBox(height: 16),

          // الوصف
          if (product.description != null && product.description!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الوصف', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(product.description!),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEditForm(Product product) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // اسم المنتج
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم المنتج *',
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
              prefixIcon: Icon(Icons.monetization_on),
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          setState(() => _isEditing = false);
                          _initializeControllers(product);
                        },
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: _isSubmitting ? null : _updateProduct,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isSubmitting ? 'جاري الحفظ...' : 'حفظ التعديلات',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
