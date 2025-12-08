import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/packages_service.dart';
import '../../../../core/theme/app_theme.dart';
import 'package_bot_screen.dart';

/// شاشة الباقات
class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  List<Map<String, dynamic>> _packages = [];
  Map<String, dynamic>? _currentPackage;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final packages = await PackagesService.getAvailablePackages();
      final currentPackage = await PackagesService.getCurrentPackage();
      
      setState(() {
        _packages = packages;
        _currentPackage = currentPackage;
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
        title: const Text('الباقات'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PackageBotScreen(),
                ),
              );
            },
            tooltip: 'مساعدة في اختيار الباقة',
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
                      Icon(Icons.error_outline, size: 64, color: MbuyColors.alertRed),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPackages,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPackages,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // معلومات الباقة الحالية
                      if (_currentPackage != null) ...[
                        Card(
                          color: MbuyColors.primaryMaroon.withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: MbuyColors.primaryMaroon,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'الباقة الحالية',
                                      style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: MbuyColors.primaryMaroon,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _currentPackage!['name'] ?? 'غير معروف',
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    color: MbuyColors.textPrimary,
                                  ),
                                ),
                                if (_currentPackage!['expires_at'] != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'تنتهي في: ${_currentPackage!['expires_at']}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      color: MbuyColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // قائمة الباقات
                      Text(
                        'الباقات المتاحة',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._packages.map((package) => _buildPackageCard(package)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> package) {
    final isCurrent = _currentPackage?['id'] == package['id'];
    final isCustom = package['type'] == 'custom';
    final price = package['price'] ?? 0.0;
    final discountedPrice = isCustom
        ? PackagesService.calculateDiscountedPrice(
            originalPrice: price,
            packageType: 'custom',
          )
        : price;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isCurrent ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCurrent ? MbuyColors.primaryMaroon : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package['name'] ?? 'باقة',
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                      if (package['description'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          package['description'] ?? '',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: MbuyColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: MbuyColors.primaryMaroon,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'نشطة',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            // المميزات
            if (package['features'] != null) ...[
              ...(package['features'] as List).map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: MbuyColors.primaryMaroon,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature.toString(),
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 16),
            ],

            // السعر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCustom && price != discountedPrice) ...[
                      Text(
                        '$price ر.س',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          color: MbuyColors.textSecondary,
                        ),
                      ),
                    ],
                    Text(
                      '$discountedPrice ر.س',
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.primaryMaroon,
                      ),
                    ),
                    if (isCustom) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: MbuyColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'خصم 30%',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: MbuyColors.success,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (!isCurrent)
                  ElevatedButton(
                    onPressed: () => _purchasePackage(package),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MbuyColors.primaryMaroon,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'شراء',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchasePackage(Map<String, dynamic> package) async {
    if (package['type'] == 'custom') {
      // للباقة المخصصة، نحتاج إلى اختيار الأدوات
      // TODO: فتح شاشة اختيار الأدوات
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('سيتم فتح شاشة اختيار الأدوات قريباً'),
        ),
      );
      return;
    }

    try {
      await PackagesService.purchasePackage(
        packageId: package['id'] ?? '',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم شراء الباقة بنجاح!'),
            backgroundColor: MbuyColors.success,
          ),
        );
        _loadPackages();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: MbuyColors.alertRed,
          ),
        );
      }
    }
  }
}

