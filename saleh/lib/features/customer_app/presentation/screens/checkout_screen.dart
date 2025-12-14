import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';
import '../../data/customer_providers.dart';

/// شاشة إتمام الشراء
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final ApiService _api = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  // State
  String _paymentMethod = 'cash';
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartState = ref.read(cartControllerProvider);
    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('السلة فارغة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.post(
        '/secure/orders/create',
        body: {
          'customer_name': _nameController.text.trim(),
          'customer_phone': _phoneController.text.trim(),
          'shipping_address': _addressController.text.trim(),
          'notes': _notesController.text.trim(),
          'payment_method': _paymentMethod,
          'items': cartState.items
              .map(
                (item) => {
                  'product_id': item.productId,
                  'quantity': item.quantity,
                  'price': item.price,
                },
              )
              .toList(),
          'subtotal': cartState.subtotal,
          'shipping_cost': 0,
          'total': cartState.total,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          // Clear cart
          ref.read(cartControllerProvider.notifier).clearCart();
          HapticFeedback.heavyImpact();

          if (mounted) {
            // Show success dialog
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تم إرسال طلبك بنجاح!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'رقم الطلب: ${data['data']?['id'] ?? '--'}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'سيتم التواصل معك قريباً',
                      style: TextStyle(color: AppTheme.textHintColor),
                    ),
                  ],
                ),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('العودة للرئيسية'),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          throw Exception(data['error'] ?? 'فشل في إرسال الطلب');
        }
      } else {
        throw Exception('فشل في الاتصال بالخادم');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'إتمام الشراء',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              _buildOrderSummary(cartState),
              const SizedBox(height: 24),

              // Customer Info
              _buildSectionTitle('معلومات التوصيل'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                label: 'الاسم الكامل',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'الاسم مطلوب' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _phoneController,
                label: 'رقم الجوال',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v!.isEmpty) return 'رقم الجوال مطلوب';
                  if (v.length < 10) return 'رقم غير صالح';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _addressController,
                label: 'عنوان التوصيل',
                icon: Icons.location_on_outlined,
                maxLines: 2,
                validator: (v) => v!.isEmpty ? 'العنوان مطلوب' : null,
              ),
              const SizedBox(height: 24),

              // Payment Method
              _buildSectionTitle('طريقة الدفع'),
              const SizedBox(height: 12),
              _buildPaymentOption(
                value: 'cash',
                title: 'الدفع عند الاستلام',
                subtitle: 'نقداً أو بالبطاقة',
                icon: Icons.money,
              ),
              _buildPaymentOption(
                value: 'transfer',
                title: 'تحويل بنكي',
                subtitle: 'سيتم إرسال بيانات الحساب',
                icon: Icons.account_balance,
              ),
              const SizedBox(height: 24),

              // Notes
              _buildSectionTitle('ملاحظات إضافية'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _notesController,
                label: 'ملاحظات (اختياري)',
                icon: Icons.note_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Error
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppTheme.accentColor.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'تأكيد الطلب (${cartState.total.toStringAsFixed(2)} ر.س)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                'ملخص الطلب',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${state.itemCount} منتج',
                style: const TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ],
          ),
          const Divider(height: 24),
          ...state.items
              .take(3)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        '${item.quantity}x',
                        style: const TextStyle(color: AppTheme.textHintColor),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.productName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${(item.price * item.quantity).toStringAsFixed(2)} ر.س',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
          if (state.items.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+ ${state.items.length - 3} منتجات أخرى',
                style: const TextStyle(
                  color: AppTheme.textHintColor,
                  fontSize: 12,
                ),
              ),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المجموع الفرعي'),
              Text('${state.subtotal.toStringAsFixed(2)} ر.س'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('التوصيل'),
              const Text('مجاني', style: TextStyle(color: Colors.green)),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${state.total.toStringAsFixed(2)} ر.س',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withValues(alpha: 0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ],
              ),
            ),
            // ignore: deprecated_member_use
            Radio<String>(
              value: value,
              // ignore: deprecated_member_use
              groupValue: _paymentMethod,
              // ignore: deprecated_member_use
              onChanged: (v) {
                if (v != null) {
                  setState(() => _paymentMethod = v);
                }
              },
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
