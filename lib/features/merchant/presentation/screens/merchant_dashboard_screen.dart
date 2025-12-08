import 'package:flutter/material.dart';
import '../../../auth/data/auth_repository.dart';
import 'merchant_products_screen.dart';
import 'merchant_orders_screen.dart';
import 'merchant_store_setup_screen.dart';
import '../widgets/merchant_bottom_bar.dart';
import '../widgets/merchant_profile_tab.dart';

// لوحة تحكم التاجر المعاد بناؤها بشكل نظيف ومنظم
class MerchantDashboardScreen extends StatefulWidget {
  const MerchantDashboardScreen({super.key});

  @override
  State<MerchantDashboardScreen> createState() =>
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState extends State<MerchantDashboardScreen> {
  int _selectedIndex = 0;

  // قائمة التبويبات
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _initializeTabs();
    _showWelcomeMessage();
  }

  void _showWelcomeMessage() {
    // عرض رسالة ترحيب للتاجر الجديد
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'مرحباً بك في لوحة تحكم التاجر! ابدأ بإضافة منتجاتك الأولى.',
            ),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }

  void _initializeTabs() {
    _tabs = [
      const MerchantProductsScreen(), // المنتجات
      const MerchantOrdersScreen(), // الطلبات
      const MerchantStoreSetupScreen(), // المتجر
      const MerchantProfileTab(), // الملف
    ];
  }

  void _onTabTapped(int index) {
    if (index >= 0 && index < _tabs.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<bool> _onWillPop() async {
    // عرض حوار تأكيد الخروج
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text('هل تريد تسجيل الخروج من لوحة التحكم؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('خروج'),
          ),
        ],
      ),
    );

    if (result == true) {
      // تسجيل الخروج وإعادة التوجيه للشاشة الرئيسية
      await AuthRepository.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }

    return result ?? false; // لا تسمح بالرجوع التلقائي
  }

  void _onPopInvokedWithResult(bool didPop, dynamic result) {
    if (!didPop) {
      _onWillPop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم'),
          centerTitle: true,
          elevation: 0,
        ),
        body: _tabs[_selectedIndex],
        bottomNavigationBar: MerchantBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          onAddTap: () {
            // منطق إضافة منتج جديد - يمكن إضافته لاحقاً
            debugPrint('إضافة منتج جديد');
          },
        ),
      ),
    );
  }
}
