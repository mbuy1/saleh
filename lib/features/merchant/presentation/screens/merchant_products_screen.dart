import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/services/api_service.dart';
import '../../../customer/presentation/screens/product_details_screen.dart';

class MerchantProductsScreen extends StatefulWidget {
  const MerchantProductsScreen({super.key});

  @override
  State<MerchantProductsScreen> createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  bool _isCreating = false;
  bool _isUploadingImage = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImageFile;

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

      // جلب المنتجات عبر Worker API
      final result = await ApiService.get('/secure/merchant/products');

      if (result['ok'] == true && result['data'] != null) {
        final products = List<Map<String, dynamic>>.from(result['data']);

        // طباعة معلومات المنتجات للتشخيص
        for (var product in products) {
          debugPrint('📦 منتج: ${product['name']}');
          debugPrint('   image_url: ${product['image_url']}');
          debugPrint('   main_image_url: ${product['main_image_url']}');
        }

        setState(() {
          _products = products;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] ?? 'خطأ في جلب المنتجات'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
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
    setState(() {
      _selectedImageFile = null;
    });

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                  const SizedBox(height: 16),
                  // اختيار صورة المنتج
                  _buildImagePickerInDialog(setDialogState),
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
              onPressed: (_isCreating || _isUploadingImage)
                  ? null
                  : _createProduct,
              child: (_isCreating || _isUploadingImage)
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('إضافة'),
            ),
          ],
        ),
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

      // جلب المتجر عبر Worker API
      final storeResult = await ApiService.get('/secure/merchant/store');

      if (storeResult['ok'] != true || storeResult['data'] == null) {
        throw Exception(
          'لم يتم العثور على متجر. يرجى إنشاء متجر أولاً من قائمة "إعداد المتجر"',
        );
      }

      final storeId = storeResult['data']['id'];

      // رفع الصورة إذا تم اختيارها
      String? imageUrl;
      if (_selectedImageFile != null) {
        setState(() {
          _isUploadingImage = true;
        });
        try {
          // استخدام ApiService الذي يستخدم Cloudflare Worker
          imageUrl = await ApiService.uploadImage(_selectedImageFile!.path);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم رفع الصورة بنجاح'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في رفع الصورة: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          // لا نتابع إنشاء المنتج إذا فشل رفع الصورة
          setState(() {
            _isUploadingImage = false;
            _isCreating = false;
          });
          return;
        } finally {
          setState(() {
            _isUploadingImage = false;
          });
        }
      }

      // إنشاء منتج جديد
      final productData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text),
        'stock_quantity': int.parse(_stockController.text),
      };

      // إضافة URL الصورة إذا كان موجوداً
      if (imageUrl != null && imageUrl.isNotEmpty) {
        productData['main_image_url'] = imageUrl;
        productData['images'] = [imageUrl];
        debugPrint('✅ سيتم حفظ الصورة: $imageUrl');
      } else {
        debugPrint('⚠️ لا توجد صورة لحفظها');
      }

      debugPrint('📦 بيانات المنتج: $productData');

      // استخدام Worker API لإنشاء المنتج
      final result = await ApiService.post(
        '/secure/products',
        data: productData,
      );

      debugPrint('✅ تم إنشاء المنتج: $result');

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إضافة المنتج بنجاح!${imageUrl != null ? '\nالصورة: $imageUrl' : ''}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        // إعادة تحميل القائمة
        await _loadProducts();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // العودة إلى لوحة التحكم
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsScreen(productId: product['id']),
            ),
          );
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: _buildProductImage(product),
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

  /// Widget لاختيار صورة المنتج داخل Dialog
  Widget _buildImagePickerInDialog(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صورة المنتج',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // عرض الصورة المختارة
        if (_selectedImageFile != null)
          Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(_selectedImageFile!, fit: BoxFit.cover),
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image, size: 50, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  'لم يتم اختيار صورة',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImageInDialog(setDialogState),
                icon: const Icon(Icons.photo_library),
                label: const Text('اختر من المعرض'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImageFromCamera(setDialogState),
                icon: const Icon(Icons.camera_alt),
                label: const Text('التقط صورة'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        if (_selectedImageFile != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedImageFile = null;
              });
              setDialogState(() {
                _selectedImageFile = null;
              });
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'حذف الصورة',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  /// اختيار صورة من المعرض داخل Dialog
  Future<void> _pickImageInDialog(StateSetter setDialogState) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null) {
        final file = File(image.path);
        setState(() {
          _selectedImageFile = file;
        });
        // تحديث Dialog أيضاً
        setDialogState(() {
          _selectedImageFile = file;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم اختيار الصورة بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في اختيار الصورة: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// التقاط صورة من الكاميرا داخل Dialog
  Future<void> _pickImageFromCamera(StateSetter setDialogState) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null) {
        final file = File(image.path);
        setState(() {
          _selectedImageFile = file;
        });
        // تحديث Dialog أيضاً
        setDialogState(() {
          _selectedImageFile = file;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم التقاط الصورة بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في التقاط الصورة: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildProductImage(Map<String, dynamic> product) {
    // محاولة الحصول على URL الصورة من عدة مصادر
    var imageUrl =
        product['image_url'] ??
        product['main_image_url'] ??
        product['images']?[0];

    // إذا كان images قائمة، أخذ أول عنصر
    if (imageUrl == null && product['images'] != null) {
      final images = product['images'];
      if (images is List && images.isNotEmpty) {
        imageUrl = images[0];
      }
    }

    if (imageUrl == null || imageUrl.toString().trim().isEmpty) {
      debugPrint('⚠️ لا توجد صورة للمنتج: ${product['name']}');
      return const Icon(Icons.shopping_bag, color: Colors.grey);
    }

    final url = imageUrl.toString().trim();
    debugPrint('🖼️ جاري تحميل الصورة للمنتج ${product['name']}: $url');

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: 50,
        height: 50,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ خطأ في تحميل الصورة: $error');
          debugPrint('❌ URL: $url');
          debugPrint('❌ المنتج: ${product['name']}');
          return const Icon(Icons.broken_image, color: Colors.grey, size: 30);
        },
      ),
    );
  }
}
