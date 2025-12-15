import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
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
      length: 4,
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
              icon: const Icon(
                Icons.filter_list,
                size: AppDimensions.iconM,
                color: AppTheme.primaryColor,
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
              Tab(text: 'الطلبات الخاصة'),
              Tab(text: 'إعدادات الطلبات'),
              Tab(text: 'تخصيص الفاتورة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1) إدارة الطلبات (المحتوى الأصلي)
            _buildOrdersContent(),
            // 2) الطلبات الخاصة
            _buildPlaceholder('الطلبات الخاصة'),
            // 3) إعدادات الطلبات
            _buildPlaceholder('إعدادات الطلبات'),
            // 4) تخصيص الفاتورة
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
            // كرت الطلبات الخاصة
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSpecialOrdersCard(context),
            ),
            // كرت طلبات التوريد (للمورد)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSupplierOrdersCard(context),
            ),
            const SizedBox(height: 16),
            // محتوى الطلبات
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
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
                            child: Icon(
                              Icons.receipt_long_outlined,
                              size: AppDimensions.iconDisplay,
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.5,
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
          Icon(Icons.build_circle_outlined, size: 64, color: Colors.grey[400]),
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
          // TODO: Implement $title screen
        ],
      ),
    );
  }

  /// كرت الطلبات الخاصة - نُقل من الصفحة الرئيسية
  Widget _buildSpecialOrdersCard(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => context.push(
          '/dashboard/feature/${Uri.encodeComponent('الطلبات الخاصة')}',
        ),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  size: 26,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الطلبات الخاصة',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'طلبات مخصصة من العملاء',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  /// كرت طلبات التوريد - للمورد
  Widget _buildSupplierOrdersCard(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => context.push('/dashboard/supplier-orders'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 26,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلبات التوريد',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'طلبات دروب شوبينق للتجهيز',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
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
              _buildFilterOption(context, 'جميع الطلبات', Icons.all_inbox),
              _buildFilterOption(context, 'طلبات جديدة', Icons.fiber_new),
              _buildFilterOption(context, 'قيد التنفيذ', Icons.pending_actions),
              _buildFilterOption(context, 'مكتملة', Icons.check_circle_outline),
              _buildFilterOption(context, 'ملغاة', Icons.cancel_outlined),
              const SizedBox(height: AppDimensions.spacing16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(BuildContext context, String label, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(label),
      trailing: const Icon(Icons.chevron_left),
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
