/// شاشة Stores
/// 
/// عرض قائمة متاجر حقيقية من Supabase
/// 
/// الاستعلامات المستخدمة:
/// - supabaseClient.from('stores').select().eq('visibility', 'public').eq('status', 'active')

import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  List<Map<String, dynamic>> _stores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // جلب المتاجر العامة والنشطة
      final response = await supabaseClient
          .from('stores')
          .select()
          .eq('visibility', 'public')
          .eq('status', 'active')
          .order('created_at', ascending: false);

      setState(() {
        _stores = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب المتاجر: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتاجر'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stores.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد متاجر متاحة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _stores.length,
                  itemBuilder: (context, index) {
                    return _buildStoreCard(_stores[index]);
                  },
                ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.store, color: Colors.blue, size: 32),
        ),
        title: Text(
          store['name'] ?? 'بدون اسم',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (store['city'] != null)
              Text('${store['city']}'),
            if (store['description'] != null)
              Text(
                store['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: الانتقال إلى صفحة المتجر
        },
      ),
    );
  }
}

