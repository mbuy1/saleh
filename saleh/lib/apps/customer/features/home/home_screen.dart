import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'widgets/home_banner_carousel.dart';
import 'widgets/featured_stores_section.dart';
import 'widgets/trending_products_section.dart';
import 'widgets/categories_grid.dart';
import 'widgets/flash_deals_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const HomeScreen({super.key, this.scrollController});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Banner Carousel
          const SliverToBoxAdapter(child: HomeBannerCarousel()),

          // Categories Grid
          const SliverToBoxAdapter(child: CategoriesGrid()),

          // Flash Deals
          const SliverToBoxAdapter(child: FlashDealsSection()),

          // Featured Stores
          const SliverToBoxAdapter(child: FeaturedStoresSection()),

          // Trending Products
          const SliverToBoxAdapter(child: TrendingProductsSection()),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    // TODO: Refresh data from API
    await Future.delayed(const Duration(seconds: 1));
  }
}
