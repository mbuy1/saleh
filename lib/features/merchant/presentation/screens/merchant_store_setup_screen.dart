import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/services/media_service.dart';
import '../../data/merchant_points_service.dart';

class MerchantStoreSetupScreen extends StatefulWidget {
  const MerchantStoreSetupScreen({super.key});

  @override
  State<MerchantStoreSetupScreen> createState() =>
      _MerchantStoreSetupScreenState();
}

class _MerchantStoreSetupScreenState extends State<MerchantStoreSetupScreen> {
  Map<String, dynamic>? _store;
  bool _isLoading = true;
  bool _isCreating = false;
  bool _isBoosting = false;
  bool _isHighlighting = false;
  bool _isUploadingImage = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImageFile;
  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    _loadStore();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadStore() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return;

      // جلب المتجر المرتبط بهذا التاجر
      final response = await supabaseClient
          .from('stores')
          .select()
          .eq('owner_id', user.id)
          .maybeSingle();

      if (response != null) {
        setState(() {
          _store = response;
          _nameController.text = _store!['name'] ?? '';
          _cityController.text = _store!['city'] ?? '';
          _descriptionController.text = _store!['description'] ?? '';
          _logoUrl = _store!['logo_url'] as String?;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب بيانات المتجر: ${e.toString()}'),
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

  Future<void> _createStore() async {
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

      // إنشاء slug بسيط من الاسم
      final slug = _nameController.text
          .toLowerCase()
          .replaceAll(' ', '-')
          .replaceAll(RegExp(r'[^a-z0-9-]'), '');

      // رفع الصورة إذا تم اختيارها
      String? logoUrl = _logoUrl;
      if (_selectedImageFile != null) {
        setState(() {
          _isUploadingImage = true;
        });
        try {
          // استخدام MediaService الذي يعمل عبر Worker
          logoUrl = await MediaService.uploadImage(_selectedImageFile!);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في رفع الصورة: ${e.toString()}'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } finally {
          setState(() {
            _isUploadingImage = false;
          });
        }
      }

      // إنشاء متجر جديد
      final response = await supabaseClient
          .from('stores')
          .insert({
            'owner_id': user.id,
            'name': _nameController.text.trim(),
            'city': _cityController.text.trim(),
            'description': _descriptionController.text.trim(),
            'slug': slug,
            'visibility': 'public', // افتراضي: عام
            'status': 'active', // افتراضي: نشط
            if (logoUrl != null) 'logo_url': logoUrl,
          })
          .select()
          .single();

      setState(() {
        _store = response;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء المتجر بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إنشاء المتجر: ${e.toString()}'),
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

  Future<void> _boostStore() async {
    if (_store == null) {
      return;
    }

    final storeId = _store!['id'] as String;

    // تأكيد الدعم
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('دعم المتجر'),
        content: const Text(
          'هل تريد دعم متجرك لمدة 24 ساعة؟ سيتم خصم النقاط المطلوبة من رصيدك.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isBoosting = true;
    });

    try {
      final success = await MerchantPointsService.boostStore(storeId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم دعم المتجر بنجاح! سيظهر في أعلى قائمة المتاجر لمدة 24 ساعة',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // إعادة تحميل بيانات المتجر
          _loadStore();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لا توجد نقاط كافية لدعم المتجر'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBoosting = false;
        });
      }
    }
  }

  Future<void> _highlightStoreOnMap() async {
    if (_store == null) {
      return;
    }

    final storeId = _store!['id'] as String;

    // تأكيد الإبراز
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إبراز المتجر على الخريطة'),
        content: const Text(
          'هل تريد إبراز متجرك على الخريطة لمدة 24 ساعة؟ سيتم خصم النقاط المطلوبة من رصيدك.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isHighlighting = true;
    });

    try {
      final success = await MerchantPointsService.highlightStoreOnMap(storeId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم إبراز المتجر على الخريطة بنجاح! سيظهر بشكل مميز لمدة 24 ساعة',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // إعادة تحميل بيانات المتجر
          _loadStore();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لا توجد نقاط كافية لإبراز المتجر على الخريطة'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isHighlighting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_store == null ? 'إنشاء متجر' : 'إدارة المتجر'),
      ),
      body: _store == null ? _buildCreateStoreForm() : _buildStoreInfo(),
    );
  }

  Widget _buildCreateStoreForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'إنشاء متجر جديد',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم المتجر *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال اسم المتجر';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'المدينة *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال المدينة';
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
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            // اختيار صورة المتجر
            _buildImagePicker(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: (_isCreating || _isUploadingImage)
                  ? null
                  : _createStore,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isCreating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('إنشاء المتجر'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // عرض صورة المتجر
                      if (_logoUrl != null)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _logoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.store, size: 32);
                              },
                            ),
                          ),
                        )
                      else
                        const Icon(Icons.store, size: 32, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _store!['name'] ?? 'بدون اسم',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.location_city,
                    'المدينة',
                    _store!['city'] ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.description,
                    'الوصف',
                    _store!['description'] ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.visibility,
                    'الحالة',
                    _store!['visibility'] == 'public' ? 'عام' : 'خاص',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.info,
                    'حالة المتجر',
                    _store!['status'] == 'active' ? 'نشط' : 'غير نشط',
                  ),
                  // عرض حالة الدعم إذا كان موجوداً
                  if (_store!['boosted_until'] != null) ...[
                    const SizedBox(height: 8),
                    _buildBoostStatus(),
                  ],
                  // عرض حالة الإبراز على الخريطة إذا كان موجوداً
                  if (_store!['map_highlight_until'] != null) ...[
                    const SizedBox(height: 8),
                    _buildMapHighlightStatus(),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // زر دعم المتجر
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.rocket_launch, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'دعم المتجر',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'اجعل متجرك يظهر في أعلى قائمة المتاجر لمدة 24 ساعة',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isBoosting ? null : _boostStore,
                      icon: _isBoosting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.rocket_launch),
                      label: Text(
                        _isBoosting
                            ? 'جاري الدعم...'
                            : 'دعم المتجر لمدة 24 ساعة',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // زر إبراز المتجر على الخريطة
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.purple.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'إبراز المتجر على الخريطة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'اجعل متجرك يظهر بشكل مميز على الخريطة لمدة 24 ساعة',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isHighlighting ? null : _highlightStoreOnMap,
                      icon: _isHighlighting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.location_on),
                      label: Text(
                        _isHighlighting
                            ? 'جاري الإبراز...'
                            : 'إبراز المتجر على الخريطة لمدة 24 ساعة',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoostStatus() {
    final boostedUntil = _store!['boosted_until'] as String?;
    if (boostedUntil == null) return const SizedBox.shrink();

    try {
      final boostedDate = DateTime.parse(boostedUntil);
      final now = DateTime.now();
      final isActive = boostedDate.isAfter(now);

      if (!isActive) {
        return const SizedBox.shrink(); // انتهى الدعم، لا نعرضه
      }

      final remaining = boostedDate.difference(now);
      final hours = remaining.inHours;
      final minutes = remaining.inMinutes % 60;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.rocket_launch, color: Colors.green.shade700, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المتجر مدعوم حالياً',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  Text(
                    'المتبقي: $hours ساعة و $minutes دقيقة',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildMapHighlightStatus() {
    final highlightUntil = _store!['map_highlight_until'] as String?;
    if (highlightUntil == null) return const SizedBox.shrink();

    try {
      final highlightDate = DateTime.parse(highlightUntil);
      final now = DateTime.now();
      final isActive = highlightDate.isAfter(now);

      if (!isActive) {
        return const SizedBox.shrink(); // انتهى الإبراز، لا نعرضه
      }

      final remaining = highlightDate.difference(now);
      final hours = remaining.inHours;
      final minutes = remaining.inMinutes % 60;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.purple.shade700, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المتجر مميز على الخريطة حالياً',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  Text(
                    'المتبقي: $hours ساعة و $minutes دقيقة',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  /// Widget لاختيار صورة المتجر
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صورة المتجر',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // عرض الصورة المختارة أو الحالية
            if (_selectedImageFile != null || _logoUrl != null)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _selectedImageFile != null
                      ? Image.file(_selectedImageFile!, fit: BoxFit.cover)
                      : _logoUrl != null
                      ? Image.network(
                          _logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, size: 50);
                          },
                        )
                      : const Icon(Icons.image, size: 50),
                ),
              )
            else
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('اختر صورة'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// اختيار صورة من المعرض
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImageFile = File(image.path);
          _logoUrl = null; // إعادة تعيين URL القديم عند اختيار صورة جديدة
        });
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
}
