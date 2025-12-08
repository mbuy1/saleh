import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/shipping_service.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة اختيار طريقة الشحن
class ShippingSelectionScreen extends StatefulWidget {
  final String address;
  final String city;
  final double? totalWeight;

  const ShippingSelectionScreen({
    super.key,
    required this.address,
    required this.city,
    this.totalWeight,
  });

  @override
  State<ShippingSelectionScreen> createState() => _ShippingSelectionScreenState();
}

class _ShippingSelectionScreenState extends State<ShippingSelectionScreen> {
  List<Map<String, dynamic>> _providers = [];
  Map<String, dynamic>? _selectedProvider;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final providers = await ShippingService.getAvailableProviders();
      setState(() {
        _providers = providers;
        if (providers.isNotEmpty) {
          _selectedProvider = providers.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('اختر طريقة الشحن'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: MbuyColors.alertRed),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProviders,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // معلومات العنوان
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'عنوان التوصيل',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.address,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: MbuyColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.city,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: MbuyColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // قائمة مقدمي الخدمة
                    Text(
                      'مقدمي خدمة الشحن',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._providers.map((provider) => _buildProviderCard(provider)),
                  ],
                ),
      bottomNavigationBar: _selectedProvider != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MbuyColors.cardBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MbuyColors.primaryMaroon,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'تأكيد',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    final isSelected = _selectedProvider?['id'] == provider['id'];
    final cost = provider['cost'] ?? 0.0;
    final estimatedDays = provider['estimated_days'] ?? 3;
    final name = provider['name'] ?? 'غير معروف';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? MbuyColors.primaryMaroon : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedProvider = provider;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? MbuyColors.primaryMaroon.withValues(alpha: 0.1)
                      : MbuyColors.borderLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: isSelected ? MbuyColors.primaryMaroon : MbuyColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تقدير الوصول: $estimatedDays أيام',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$cost ر.س',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MbuyColors.primaryMaroon,
                ),
              ),
              const SizedBox(width: 8),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: MbuyColors.primaryMaroon,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

