import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import 'explore_screen.dart';
import 'stores_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';
import 'customer_wallet_screen.dart';
import 'customer_points_screen.dart';
import 'customer_orders_screen.dart';
import 'profile_screen.dart';

class CustomerShell extends StatefulWidget {
  final AppModeProvider appModeProvider;
  final String? userRole; // 'customer' أو 'merchant'
  final ThemeProvider? themeProvider;

  const CustomerShell({
    super.key,
    required this.appModeProvider,
    this.userRole,
    this.themeProvider,
  });

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _currentIndex = 2; // Home هو الافتراضي (في المنتصف)
  Offset _backButtonPosition = const Offset(16, 16); // موقع زر العودة

  List<Widget> get _screens => [
    ExploreScreen(userRole: widget.userRole),
    const StoresScreen(),
    const HomeScreen(),
    CartScreen(userRole: widget.userRole),
    const MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.userRole == 'customer'
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: MbuyColors.primaryGradient,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'mBuy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'تطبيق التسوق',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
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
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('الملف الشخصي'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
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
                      if (widget.themeProvider != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              themeProvider: widget.themeProvider!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          : null,
      body: Stack(
        children: [
          _screens[_currentIndex],
          // زر العودة للتاجر قابل للتحريك
          if (widget.userRole == 'merchant')
            Positioned(
              left: _backButtonPosition.dx,
              top: _backButtonPosition.dy + MediaQuery.of(context).padding.top,
              child: Draggable(
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'العودة',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    // حساب الموقع الجديد مع مراعاة حدود الشاشة
                    final screenSize = MediaQuery.of(context).size;
                    final padding = MediaQuery.of(context).padding;
                    final buttonWidth = 100.0;
                    final buttonHeight = 40.0;

                    double newX = details.offset.dx;
                    double newY = details.offset.dy - padding.top;

                    // التأكد من بقاء الزر داخل الشاشة
                    newX = newX.clamp(0.0, screenSize.width - buttonWidth);
                    newY = newY.clamp(
                      0.0,
                      screenSize.height -
                          buttonHeight -
                          padding.top -
                          padding.bottom,
                    );

                    _backButtonPosition = Offset(newX, newY);
                  });
                },
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      widget.appModeProvider.setMerchantMode();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'العودة',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // أبيض في صفحة الخريطة، رمادي شفاف في الصفحات الأخرى
          color: _currentIndex == 4
              ? Colors.white
              : Colors.grey.withValues(alpha: 0.85),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
          ),
          // ألوان الأيقونات تتغير حسب خلفية الصفحة
          selectedItemColor: _currentIndex == 4
              ? MbuyColors.primaryPurple
              : Colors.white,
          unselectedItemColor: _currentIndex == 4
              ? Colors.grey.shade600
              : Colors.white.withValues(alpha: 0.6),
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                isSelected: _currentIndex == 0,
                outlineIcon: Icons.explore_outlined,
                filledIcon: Icons.explore,
              ),
              label: 'اكسبلور',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                isSelected: _currentIndex == 1,
                outlineIcon: Icons.store_outlined,
                filledIcon: Icons.store,
              ),
              label: 'المتاجر',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                isSelected: _currentIndex == 2,
                outlineIcon: Icons.home_outlined,
                filledIcon: Icons.home,
              ),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                isSelected: _currentIndex == 3,
                outlineIcon: Icons.shopping_cart_outlined,
                filledIcon: Icons.shopping_cart,
              ),
              label: 'السلة',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                isSelected: _currentIndex == 4,
                outlineIcon: Icons.map_outlined,
                filledIcon: Icons.map,
              ),
              label: 'الخريطة',
            ),
          ],
        ),
      ),
    );
  }

  /// بناء أيقونة التنقل - outline للعادي، filled للمحدد
  /// نظام موحد: أسود/رمادي بدون ألوان زرقاء
  Widget _buildNavIcon({
    required bool isSelected,
    required IconData outlineIcon,
    required IconData filledIcon,
  }) {
    // في صفحة الخريطة نستخدم خلفية بيضاء
    final bool isMapPage = _currentIndex == 4;

    if (isSelected) {
      // الأيقونة المحددة - filled
      if (isMapPage) {
        // صفحة الخريطة - لون داكن
        return Icon(filledIcon, size: 28, color: MbuyColors.textPrimary);
      } else {
        // باقي الصفحات - لون أبيض
        return Icon(filledIcon, size: 28, color: Colors.white);
      }
    } else {
      // الأيقونة غير المحددة - outline
      if (isMapPage) {
        // صفحة الخريطة - رمادي
        return Icon(outlineIcon, size: 28, color: MbuyColors.textSecondary);
      } else {
        // باقي الصفحات - أبيض شفاف
        return Icon(
          outlineIcon,
          size: 28,
          color: Colors.white.withValues(alpha: 0.6),
        );
      }
    }
  }
}
