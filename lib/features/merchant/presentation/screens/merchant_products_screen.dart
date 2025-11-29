/// MerchantProductsScreen - إدارة المنتجات
/// 
/// عرض قائمة منتجات المتجر وإضافة منتجات جديدة

import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';

class MerchantProductsScreen extends StatefulWidget {
  const MerchantProductsScreen({super.key});

  @override
  State<MerchantProductsScreen> createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  bool _isCreating = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return;

      // جلب المتجر أولاً
      final storeResponse = await supabaseClient
          .from('stores')
          .select('id')
          .eq('owner_id', user.id)
          .maybeSingle();

      if (storeResponse == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يجب إنشاء متجر أولاً'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final storeId = storeResponse['id'];

      // جلب منتجات المتجر
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('store_id', storeId)
          .order('created_at', ascending: false);

      setState(() {
        _products = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب المنتجات: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showAddProductDialog() async {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة منتج جديد'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المنتج *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم المنتج';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'السعر *',
                    border: OutlineInputBorder(),
                    prefixText: 'ر.س ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال السعر';
                    }
                    if (double.tryParse(value) == null) {
                      return 'السعر يجب أن يكون رقماً';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: 'الكمية المتوفرة *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الكمية';
                    }
                    if (int.tryParse(value) == null) {
                      return 'الكمية يجب أن تكون رقماً';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: _isCreating ? null : _createProduct,
            child: _isCreating
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('المستخدم غير مسجل');
      }

      // جلب المتجر
      final storeResponse = await supabaseClient
          .from('stores')
          .select('id')
          .eq('owner_id', user.id)
          .single();

      final storeId = storeResponse['id'];

      // إنشاء منتج جديد
      await supabaseClient.from('products').insert({
        'store_id': storeId,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'status': 'active', // افتراضي: نشط
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إضافة المنتج بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadProducts(); // إعادة تحميل القائمة
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إضافة المنتج: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inventory_2_outlined,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'لا توجد منتجات',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _showAddProductDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة منتج جديد'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(_products[index]);
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.shopping_bag, color: Colors.grey),
        ),
        title: Text(product['name'] ?? 'بدون اسم'),
        subtitle: Text(
          '${product['price'] ?? 0} ر.س - الكمية: ${product['stock'] ?? 0}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            // TODO: إضافة منطق حذف المنتج
          },
        ),
      ),
    );
  }
}

