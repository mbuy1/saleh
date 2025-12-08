// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../data/services/bulk_operations_service.dart';
import '../../data/models/bulk_operation_model.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة العمليات المجمعة (Bulk Operations)
class BulkOperationsScreen extends StatefulWidget {
  const BulkOperationsScreen({super.key});

  @override
  State<BulkOperationsScreen> createState() => _BulkOperationsScreenState();
}

class _BulkOperationsScreenState extends State<BulkOperationsScreen> {
  List<String> _selectedProductIds = [];
  String _selectedOperation = 'update';
  final Map<String, TextEditingController> _updateControllers = {
    'price': TextEditingController(),
    'stock': TextEditingController(),
    'status': TextEditingController(),
  };
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _updateControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _executeBulkOperation() async {
    if (_selectedProductIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار منتج واحد على الأقل'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      BulkOperationModel? result;

      switch (_selectedOperation) {
        case 'update':
          final updateData = <String, dynamic>{};
          if (_updateControllers['price']!.text.trim().isNotEmpty) {
            updateData['price'] = double.parse(_updateControllers['price']!.text.trim());
          }
          if (_updateControllers['stock']!.text.trim().isNotEmpty) {
            updateData['stock'] = int.parse(_updateControllers['stock']!.text.trim());
          }
          if (_updateControllers['status']!.text.trim().isNotEmpty) {
            updateData['status'] = _updateControllers['status']!.text.trim();
          }

          if (updateData.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('الرجاء إدخال بيانات التحديث'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }

          result = await BulkOperationsService.bulkUpdateProducts(
            productIds: _selectedProductIds,
            updateData: updateData,
          );
          break;

        case 'delete':
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('تأكيد الحذف'),
              content: Text(
                'هل أنت متأكد من حذف ${_selectedProductIds.length} منتج؟',
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

          if (confirm != true) {
            setState(() {
              _isLoading = false;
            });
            return;
          }

          result = await BulkOperationsService.bulkDeleteProducts(
            productIds: _selectedProductIds,
          );
          break;

        case 'activate':
          result = await BulkOperationsService.bulkActivateProducts(
            productIds: _selectedProductIds,
          );
          break;

        case 'deactivate':
          result = await BulkOperationsService.bulkDeactivateProducts(
            productIds: _selectedProductIds,
          );
          break;
      }

      if (mounted && result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم تنفيذ العملية بنجاح: ${result.successCount} نجح، ${result.failureCount} فشل',
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // TODO: Navigate back or refresh products list
        Navigator.pop(context, true);
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
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Get selected products from arguments or provider
    final selectedProducts = ModalRoute.of(context)?.settings.arguments as List<String>? ?? [];

    if (selectedProducts.isNotEmpty) {
      _selectedProductIds = selectedProducts;
    }

    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('العمليات المجمعة'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المنتجات المحددة',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('عدد المنتجات: ${_selectedProductIds.length}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نوع العملية',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    RadioListTile<String>(
                      title: const Text('تحديث'),
                      value: 'update',
                      groupValue: _selectedOperation,
                      onChanged: (value) {
                        setState(() {
                          _selectedOperation = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('حذف'),
                      value: 'delete',
                      groupValue: _selectedOperation,
                      onChanged: (value) {
                        setState(() {
                          _selectedOperation = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('تفعيل'),
                      value: 'activate',
                      groupValue: _selectedOperation,
                      onChanged: (value) {
                        setState(() {
                          _selectedOperation = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('إلغاء تفعيل'),
                      value: 'deactivate',
                      groupValue: _selectedOperation,
                      onChanged: (value) {
                        setState(() {
                          _selectedOperation = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedOperation == 'update') ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'بيانات التحديث',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _updateControllers['price'],
                        decoration: const InputDecoration(
                          labelText: 'السعر (اختياري)',
                          hintText: '99.99',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _updateControllers['stock'],
                        decoration: const InputDecoration(
                          labelText: 'الكمية (اختياري)',
                          hintText: '100',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _updateControllers['status'],
                        decoration: const InputDecoration(
                          labelText: 'الحالة (active/inactive) (اختياري)',
                          hintText: 'active',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _executeBulkOperation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _selectedOperation == 'delete'
                    ? Colors.red
                    : MbuyColors.primaryMaroon,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _selectedOperation == 'update'
                          ? 'تحديث المنتجات'
                          : _selectedOperation == 'delete'
                              ? 'حذف المنتجات'
                              : _selectedOperation == 'activate'
                                  ? 'تفعيل المنتجات'
                                  : 'إلغاء تفعيل المنتجات',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}

