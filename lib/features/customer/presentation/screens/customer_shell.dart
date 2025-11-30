import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import 'explore_screen.dart';
import 'stores_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'map_screen.dart';
import 'customer_wallet_screen.dart';
import 'customer_points_screen.dart';
import 'customer_orders_screen.dart';

class CustomerShell extends StatefulWidget {
  final AppModeProvider appModeProvider;
  final String? userRole; // 'customer' أو 'merchant'

  const CustomerShell({
    super.key,
    required this.appModeProvider,
    this.userRole,
  });

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _currentIndex = 2; // Home هو الافتراضي (في المنتصف)

  List<Widget> get _screens => [
        ExploreScreen(userRole: widget.userRole),
        const StoresScreen(),
        HomeScreen(userRole: widget.userRole),
        CartScreen(userRole: widget.userRole),
        const MapScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    // التحقق إذا كان المستخدم تاجر (حتى لو في وضع customer كمشاهد)
    final bool isMerchant = widget.userRole == 'merchant';

    return Scaffold(
      appBar: isMerchant
          ? AppBar(
              title: const Text('Saleh - وضع العميل'),
              actions: [
                // زر "لوحة التحكم" - يظهر فقط للتاجر
                TextButton.icon(
                  onPressed: () {
                    // تغيير AppMode إلى merchant للعودة إلى لوحة التحكم
                    widget.appModeProvider.setMerchantMode();
                  },
                  icon: const Icon(Icons.dashboard),
                  label: const Text('لوحة التحكم'),
                ),
              ],
            )
          : AppBar(
              title: const Text('Saleh'),
              automaticallyImplyLeading: false,
            ),
      drawer: widget.userRole == 'customer'
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Saleh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'تطبيق التسوق',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: const Text('طلباتي'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerOrdersScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text('محفظتي'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerWalletScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.stars),
                    title: const Text('نقاطي'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerPointsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('الإعدادات'),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: إضافة شاشة الإعدادات
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false, // إلغاء النص
        showUnselectedLabels: false, // إلغاء النص
        items: [
          BottomNavigationBarItem(
            icon: _buildCircleIcon(
              isSelected: _currentIndex == 0,
              icon: Icons.explore,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildCircleIcon(
              isSelected: _currentIndex == 1,
              icon: Icons.store,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildCircleIcon(
              isSelected: _currentIndex == 2,
              icon: Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildCircleIcon(
              isSelected: _currentIndex == 3,
              icon: Icons.shopping_cart,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildCircleIcon(
              isSelected: _currentIndex == 4,
              icon: Icons.map,
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIcon({
    required bool isSelected,
    required IconData icon,
  }) {
    // دائرة كاملة أصغر بألوان ناعمة فخمة عند الضغط
    return SizedBox(
      width: 24, // أصغر قليلاً
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // دائرة الجراديانت الخارجية (عند الاختيار)
          if (isSelected)
            SizedBox(
              width: 24,
              height: 24,
              child: CustomPaint(
                painter: _CircleIconPainter(
                  gradient: MbuyColors.circularGradient,
                ),
              ),
            ),
          // الأيقونة
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : MbuyColors.textTertiary,
          ),
        ],
      ),
    );
  }
}

/// Painter لرسم دائرة كاملة بألوان الشعار
class _CircleIconPainter extends CustomPainter {
  final SweepGradient gradient;

  _CircleIconPainter({
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // إنشاء شادر للجراديانت
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final shader = gradient.createShader(rect);
    paint.shader = shader;

    // رسم دائرة كاملة
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_CircleIconPainter oldDelegate) {
    return oldDelegate.gradient != gradient;
  }
}

