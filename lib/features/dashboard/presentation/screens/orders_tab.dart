import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/skeleton_loading.dart';

/// شاشة الطلبات - Orders Tab
/// تعرض قائمة طلبات العملاء
class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  bool _isLoading = false;

  Future<void> _refreshOrders() async {
    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();
    // محاكاة تحميل البيانات
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceColor,
          foregroundColor: AppTheme.textPrimaryColor,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'الطلبات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: AppTheme.primaryColor,
            size: AppDimensions.iconM,
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppIcons.filter,
                width: AppDimensions.iconM,
                height: AppDimensions.iconM,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                _showFilterBottomSheet(context);
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondaryColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'إدارة الطلبات'),
              Tab(text: 'إعدادات الطلبات'),
              Tab(text: 'تخصيص الفاتورة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1) إدارة الطلبات (المحتوى الأصلي)
            _buildOrdersContent(),
            // 2) إعدادات الطلبات
            _buildPlaceholder('إعدادات الطلبات'),
            // 3) تخصيص الفاتورة
            _buildPlaceholder('تخصيص الفاتورة'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersContent() {
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      color: AppTheme.accentColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // محتوى الطلبات
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: _isLoading
                  ? const SkeletonOrdersList()
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: AppDimensions.avatarProfile,
                            height: AppDimensions.avatarProfile,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.08,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppIcons.orders,
                              width: AppDimensions.iconDisplay,
                              height: AppDimensions.iconDisplay,
                              colorFilter: ColorFilter.mode(
                                AppTheme.primaryColor.withValues(alpha: 0.5),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing24),
                          Text(
                            'لا توجد طلبات',
                            style: TextStyle(
                              fontSize: AppDimensions.fontDisplay3,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Text(
                            'ستظهر الطلبات هنا عند استلامها',
                            style: TextStyle(
                              fontSize: AppDimensions.fontBody,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing16),
                          Text(
                            'اسحب للأسفل للتحديث',
                            style: TextStyle(
                              fontSize: AppDimensions.fontCaption,
                              color: AppTheme.textHintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.tools,
            width: 64,
            height: 64,
            colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text('قريباً...', style: TextStyle(color: Colors.grey[500])),
          // NOTE: شاشات الطلبات الفرعية قيد التطوير
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'تصفية الطلبات',
                style: TextStyle(
                  fontSize: AppDimensions.fontHeadline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              _buildFilterOption(context, 'جميع الطلبات', AppIcons.orders),
              _buildFilterOption(
                context,
                'طلبات جديدة',
                AppIcons.notifications,
              ),
              _buildFilterOption(context, 'قيد التنفيذ', AppIcons.time),
              _buildFilterOption(context, 'مكتملة', AppIcons.checkCircle),
              _buildFilterOption(context, 'ملغاة', AppIcons.close),
              const SizedBox(height: AppDimensions.spacing16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String label,
    String iconPath,
  ) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(
          AppTheme.primaryColor,
          BlendMode.srcIn,
        ),
      ),
      title: Text(label),
      trailing: SvgPicture.asset(
        AppIcons.chevronLeft,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم اختيار: $label'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }
}
