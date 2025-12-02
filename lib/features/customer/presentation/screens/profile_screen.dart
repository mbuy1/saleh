import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/data/auth_service.dart';
import 'customer_wallet_screen.dart';
import 'customer_points_screen.dart';
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
    return MbuyScaffold(
      useSafeArea: false,
      backgroundColor: MbuyColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // 1. Alibaba-style Header
                SliverAppBar(
                  expandedHeight: 140,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: MbuyColors.primaryGradient,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
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
                                const SizedBox(height: 8),
                                Text(
                                  _userProfile?['display_name'] ??
                                      'مستخدم mBuy',
                                  style: GoogleFonts.cairo(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: MbuyColors.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: MbuyColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'التوصيل إلى الرياض',
                                      style: GoogleFonts.cairo(
                                        fontSize: 15,
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
                        Icons.help_outline,
                        color: MbuyColors.textSecondary,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: MbuyColors.textSecondary,
                        size: 24,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('قريباً: الإعدادات')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: MbuyColors.textSecondary,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                // 2. Features Bar (Horizontal Scroll)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
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
                          _buildFeatureItem(Icons.stars_outlined, 'النقاط', () {
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
                          _buildFeatureItem(Icons.payment, 'الدفع', () {}),
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
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'عرض الكل',
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  color: MbuyColors.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildOrderStatus(Icons.payment, 'قيد الدفع', 1),
                            _buildOrderStatus(
                              Icons.local_shipping_outlined,
                              'قيد الشحن',
                              0,
                            ),
                            _buildOrderStatus(
                              Icons.inventory_2_outlined,
                              'قيد الاستلام',
                              2,
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
                        foregroundColor: Colors.red,
                        elevation: 0,
                        side: BorderSide(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.logout, size: 22),
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
        width: 82,
        margin: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: MbuyColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: MbuyColors.primaryIndigo, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: MbuyColors.textPrimary,
                fontWeight: FontWeight.w600,
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MbuyColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: MbuyColors.primaryIndigo, size: 28),
            ),
            if (count > 0)
              Positioned(
                top: -4,
                left: -4,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    count.toString(),
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: MbuyColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
