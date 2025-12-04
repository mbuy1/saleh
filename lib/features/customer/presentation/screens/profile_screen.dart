import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/widgets/skeleton/skeleton_loader.dart';
import '../../../auth/data/auth_service.dart';
import 'customer_wallet_screen.dart';
import 'customer_points_screen.dart';
import 'favorites_screen.dart';
import 'browse_history_screen.dart';
import 'coupons_screen.dart';
import 'orders_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/product_card_compact.dart';
import '../../../../core/data/dummy_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return;

      final response = await supabaseClient
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      setState(() {
        _userProfile = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب البيانات: ${e.toString()}'),
            backgroundColor: MbuyColors.alertRed,
          ),
        );
      }
    }
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تسجيل الخروج',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'إلغاء',
              style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: MbuyColors.alertRed,
            ),
            child: Text(
              'تسجيل الخروج',
              style: GoogleFonts.cairo(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AuthService.signOut();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في تسجيل الخروج: ${e.toString()}'),
              backgroundColor: MbuyColors.alertRed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MbuyScaffold(
      useSafeArea: false,
      backgroundColor: MbuyColors.background,
      body: _isLoading
          ? _buildSkeletonLoader()
          : CustomScrollView(
              slivers: [
                // 1. Header
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: MbuyColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: MbuyColors.primaryMaroon,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MbuyColors.borderLight,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                (_userProfile?['display_name'] ?? 'م')[0]
                                    .toUpperCase(),
                                style: GoogleFonts.cairo(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Name & Location
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _userProfile?['display_name'] ??
                                      'مستخدم mBuy',
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MbuyColors.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: MbuyColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'الرياض، السعودية',
                                      style: GoogleFonts.cairo(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: MbuyColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.headset_mic_outlined,
                        color: MbuyColors.textPrimary,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: MbuyColors.textPrimary,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SettingsScreen(themeProvider: ThemeProvider()),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // 2. Features Grid (Horizontal Scroll)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildFeatureItem(
                            Icons.favorite_border,
                            'المفضلة',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FavoritesScreen(),
                                ),
                              );
                            },
                          ),
                          _buildFeatureItem(Icons.history, 'سجل التصفح', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BrowseHistoryScreen(),
                              ),
                            );
                          }),
                          _buildFeatureItem(
                            Icons.confirmation_number_outlined,
                            'القسائم',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CouponsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildFeatureItem(
                            Icons.account_balance_wallet_outlined,
                            'المحفظة',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomerWalletScreen(),
                                ),
                              );
                            },
                          ),
                          _buildFeatureItem(Icons.star_outline, 'النقاط', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerPointsScreen(),
                              ),
                            );
                          }),
                          _buildFeatureItem(
                            Icons.location_on_outlined,
                            'العناوين',
                            () {},
                          ),
                          _buildFeatureItem(
                            Icons.credit_card_outlined,
                            'الدفع',
                            () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                // 3. Orders Section
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'طلباتي',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrdersScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'عرض الكل',
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      color: MbuyColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: MbuyColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildOrderStatus(
                              Icons.payment_outlined,
                              'قيد الدفع',
                              1,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrdersScreen(
                                      status: 'pending_payment',
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildOrderStatus(
                              Icons.local_shipping_outlined,
                              'قيد الشحن',
                              0,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OrdersScreen(status: 'shipping'),
                                  ),
                                );
                              },
                            ),
                            _buildOrderStatus(
                              Icons.inventory_2_outlined,
                              'قيد الاستلام',
                              2,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OrdersScreen(status: 'delivered'),
                                  ),
                                );
                              },
                            ),
                            _buildOrderStatus(
                              Icons.rate_review_outlined,
                              'قيد التقييم',
                              0,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrdersScreen(
                                      status: 'pending_review',
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildOrderStatus(
                              Icons.assignment_return_outlined,
                              'المرتجعات',
                              0,
                              () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                // 4. "Keep looking for" Section
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        MbuySectionHeader(
                          title: 'استمر في البحث عن',
                          subtitle: 'بناءً على تصفحك السابق',
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(
                          height: 180, // Slightly smaller cards for history
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              final products = DummyData.products;
                              if (index >= products.length) {
                                return const SizedBox();
                              }
                              return Container(
                                width: 140,
                                margin: const EdgeInsets.only(left: 12),
                                child: ProductCardCompact(
                                  product: products[index],
                                  width: 140,
                                  hideActions: true, // Simplified card
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // 5. Sign Out Button
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    child: ElevatedButton.icon(
                      onPressed: _handleSignOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: MbuyColors.textPrimary,
                        elevation: 0,
                        side: const BorderSide(color: MbuyColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.logout, size: 20),
                      label: Text(
                        'تسجيل الخروج',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: MbuyColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: MbuyColors.textPrimary, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: MbuyColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus(
    IconData icon,
    String label,
    int count, [
    VoidCallback? onTap,
  ]) {
    final orderWidget = Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: MbuyColors.textPrimary, size: 32),
            if (count > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: MbuyColors.primaryMaroon,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: GoogleFonts.cairo(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: MbuyColors.textPrimary,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: orderWidget);
    }
    return orderWidget;
  }

  Widget _buildSkeletonLoader() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Skeleton Profile Header
                SkeletonLoader(width: 100, height: 100, borderRadius: BorderRadius.circular(50)),
                const SizedBox(height: 16),
                SkeletonLoader(width: 150, height: 20),
                const SizedBox(height: 8),
                SkeletonLoader(width: 100, height: 16),
                const SizedBox(height: 24),
                // Skeleton Feature Items
                ...List.generate(6, (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SkeletonListItem(),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
