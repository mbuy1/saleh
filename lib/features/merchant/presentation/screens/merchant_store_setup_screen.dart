/// MerchantStoreSetupScreen - إدارة المتجر
/// 
/// إذا لم يكن للتاجر متجر:
/// - يعرض Form لإنشاء متجر جديد
/// 
/// إذا كان له متجر:
/// - يعرض بيانات المتجر بشكل مختصر

import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';

class MerchantStoreSetupScreen extends StatefulWidget {
  const MerchantStoreSetupScreen({super.key});

  @override
  State<MerchantStoreSetupScreen> createState() => _MerchantStoreSetupScreenState();
}

class _MerchantStoreSetupScreenState extends State<MerchantStoreSetupScreen> {
  Map<String, dynamic>? _store;
  bool _isLoading = true;
  bool _isCreating = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();

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

      // إنشاء متجر جديد
      final response = await supabaseClient.from('stores').insert({
        'owner_id': user.id,
        'name': _nameController.text.trim(),
        'city': _cityController.text.trim(),
        'description': _descriptionController.text.trim(),
        'slug': slug,
        'visibility': 'public', // افتراضي: عام
        'status': 'active', // افتراضي: نشط
      }).select().single();

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: null,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_store == null ? 'إنشاء متجر' : 'إدارة المتجر'),
      ),
      body: _store == null
          ? _buildCreateStoreForm()
          : _buildStoreInfo(),
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
            ElevatedButton(
              onPressed: _isCreating ? null : _createStore,
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
                  _buildInfoRow(Icons.location_city, 'المدينة', _store!['city'] ?? '-'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.description, 'الوصف', _store!['description'] ?? '-'),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}

