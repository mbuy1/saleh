import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/auth_service.dart';
import 'wallet_screen.dart';
import 'points_screen.dart';
import '../../../../shared/widgets/product_card_compact.dart';
import '../../../../shared/widgets/section_header.dart';
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
            backgroundColor: Colors.red,
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
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // AppBar مخصص
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  floating: true,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      // Avatar + اسم المستخدم
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: MbuyColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'م',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userProfile?['display_name'] ?? 'مستخدم mBuy',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 12,
                                  color: MbuyColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'التوصيل إلى الرياض',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
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
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.help_outline,
                        color: MbuyColors.textSecondary,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: MbuyColors.textSecondary,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('قريباً: الإعدادات')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: MbuyColors.textSecondary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                // شريط المميزات
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildFeatureItem(
                            Icons.favorite_border,
                            'المفضلة',
                            () {},
                          ),
                          _buildFeatureItem(Icons.history, 'سجل التصفح', () {}),
                          _buildFeatureItem(
                            Icons.local_offer_outlined,
                            'القسائم',
                            () {},
                          ),
                          _buildFeatureItem(
                            Icons.account_balance_wallet_outlined,
                            'رصيد mBuy',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WalletScreen(),
                                ),
                              );
                            },
                          ),
                          _buildFeatureItem(Icons.stars_outlined, 'النقاط', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PointsScreen(),
                              ),
                            );
                          }),
                          _buildFeatureItem(
                            Icons.location_on_outlined,
                            'عناوين الشحن',
                            () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // قسم الطلبات
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'طلباتي',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MbuyColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildOrderStatus(Icons.payment, 'قيد الدفع', 0),
                            _buildOrderStatus(
                              Icons.local_shipping_outlined,
                              'قيد الشحن',
                              0,
                            ),
                            _buildOrderStatus(
                              Icons.inventory_2_outlined,
                              'قيد الاستلام',
                              0,
                            ),
                            _buildOrderStatus(
                              Icons.rate_review_outlined,
                              'قيد التقييم',
                              0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // قسم "استمر في البحث"
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: SectionHeader(
                      title: 'استمر في البحث',
                      subtitle: 'منتجات شاهدتها مؤخراً',
                      icon: Icons.history,
                      onViewMore: () {},
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final products = DummyData.products;
                        if (index >= products.length) return const SizedBox();
                        return ProductCardCompact(product: products[index]);
                      },
                    ),
                  ),
                ),
                // زر تسجيل الخروج
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: _handleSignOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        'تسجيل الخروج',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: MbuyColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MbuyColors.borderLight),
              ),
              child: Icon(icon, color: MbuyColors.primaryPurple, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: MbuyColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus(IconData icon, String label, int count) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: MbuyColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: MbuyColors.textSecondary, size: 22),
            ),
            if (count > 0)
              Positioned(
                top: -4,
                left: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count.toString(),
                    style: GoogleFonts.cairo(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: MbuyColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
