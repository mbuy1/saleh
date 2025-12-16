import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';

class CodSettingsScreen extends StatefulWidget {
  const CodSettingsScreen({super.key});

  @override
  State<CodSettingsScreen> createState() => _CodSettingsScreenState();
}

class _CodSettingsScreenState extends State<CodSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(AppIcons.arrowBack, width: 24, height: 24),
            onPressed: () => context.pop(),
          ),
          title: const Text('الدفع عند الاستلام'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
              Tab(text: 'الطلبات', icon: Icon(Icons.shopping_bag)),
              Tab(text: 'القائمة السوداء', icon: Icon(Icons.block)),
              Tab(text: 'الإعدادات', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildOrdersTab(),
            _buildBlacklistTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Stats
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('طلبات COD', '0', Icons.shopping_bag, Colors.blue),
              _buildStatCard(
                'قيد التحصيل',
                '0',
                Icons.pending_actions,
                Colors.orange,
              ),
              _buildStatCard(
                'تم التحصيل',
                '0',
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatCard('فشل التحصيل', '0', Icons.cancel, Colors.red),
            ],
          ),
          const SizedBox(height: 24),

          // Financial Summary
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الملخص المالي',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  _buildFinancialRow(
                    'المبالغ قيد التحصيل',
                    '0 ر.س',
                    Colors.orange,
                  ),
                  const Divider(),
                  _buildFinancialRow(
                    'المبالغ المحصلة اليوم',
                    '0 ر.س',
                    Colors.green,
                  ),
                  const Divider(),
                  _buildFinancialRow(
                    'المبالغ المحصلة هذا الشهر',
                    '0 ر.س',
                    Colors.blue,
                  ),
                  const Divider(),
                  _buildFinancialRow(
                    'رسوم COD المحصلة',
                    '0 ر.س',
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Customer Trust Levels
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مستويات ثقة العملاء',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  _buildTrustLevelRow(
                    'عملاء موثوقون',
                    '0',
                    Colors.green,
                    Icons.verified,
                  ),
                  _buildTrustLevelRow(
                    'عملاء جدد',
                    '0',
                    Colors.blue,
                    Icons.person_add,
                  ),
                  _buildTrustLevelRow(
                    'عملاء معلقون',
                    '0',
                    Colors.orange,
                    Icons.warning,
                  ),
                  _buildTrustLevelRow(
                    'قائمة سوداء',
                    '0',
                    Colors.red,
                    Icons.block,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Quick Actions
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إجراءات سريعة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text('تصدير التقرير'),
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.sms),
                          label: const Text('تذكير العملاء'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: AppDimensions.spacing8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustLevelRow(
    String label,
    String count,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: AppDimensions.spacing8),
          Expanded(child: Text(label)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusM,
            ),
            child: Text(
              count,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'قيد التحصيل'),
              Tab(text: 'تم التحصيل'),
              Tab(text: 'فشل'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildOrdersList('all'),
                _buildOrdersList('pending'),
                _buildOrdersList('collected'),
                _buildOrdersList('failed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: AppDimensions.spacing16),
          Text(
            'لا توجد طلبات',
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBlacklistTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        children: [
          // Add to Blacklist
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'القائمة السوداء',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddToBlacklistDialog(),
                icon: const Icon(Icons.add),
                label: const Text('إضافة'),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Info Card
          Card(
            color: Colors.red[50],
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red[700]),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Text(
                      'العملاء في القائمة السوداء لن يتمكنوا من استخدام خيار الدفع عند الاستلام',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Blacklist Items (Empty State)
          Center(
            child: Column(
              children: [
                SizedBox(height: AppDimensions.spacing40),
                Icon(Icons.block, size: 64, color: Colors.grey[400]),
                SizedBox(height: AppDimensions.spacing16),
                Text(
                  'لا يوجد عملاء في القائمة السوداء',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        children: [
          // General Settings
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الإعدادات العامة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('تفعيل الدفع عند الاستلام'),
                    subtitle: const Text(
                      'السماح للعملاء باختيار الدفع عند الاستلام',
                    ),
                    value: true,
                    onChanged: (v) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الحد الأدنى للطلب',
                      border: OutlineInputBorder(),
                      suffixText: 'ر.س',
                    ),
                    initialValue: '50',
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الحد الأقصى للطلب',
                      border: OutlineInputBorder(),
                      suffixText: 'ر.س',
                    ),
                    initialValue: '2000',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // COD Fees
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'رسوم COD',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'نوع الرسوم',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: 'fixed',
                    items: const [
                      DropdownMenuItem(
                        value: 'fixed',
                        child: Text('مبلغ ثابت'),
                      ),
                      DropdownMenuItem(
                        value: 'percentage',
                        child: Text('نسبة مئوية'),
                      ),
                    ],
                    onChanged: (v) {},
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'قيمة الرسوم',
                      border: OutlineInputBorder(),
                      suffixText: 'ر.س',
                    ),
                    initialValue: '10',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Verification Settings
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إعدادات التحقق',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('التحقق من رقم الجوال'),
                    subtitle: const Text('إرسال رمز تحقق للعميل'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('التحقق من الهوية'),
                    subtitle: const Text('طلب رقم الهوية للطلبات الكبيرة'),
                    value: false,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('التحقق من العنوان'),
                    subtitle: const Text('التأكد من العنوان قبل الشحن'),
                    value: true,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Trust Score Settings
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'نظام الثقة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'حد درجة الثقة للـ COD',
                      border: OutlineInputBorder(),
                      helperText:
                          'العملاء بدرجة أقل من هذا الحد لن يتمكنوا من استخدام COD',
                    ),
                    initialValue: '50',
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الحد الأقصى للتوصيلات الفاشلة',
                      border: OutlineInputBorder(),
                      helperText:
                          'بعد هذا العدد يتم إضافة العميل للقائمة السوداء تلقائياً',
                    ),
                    initialValue: '3',
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  SwitchListTile(
                    title: const Text('الإضافة التلقائية للقائمة السوداء'),
                    subtitle: const Text(
                      'إضافة العملاء الذين يرفضون الاستلام تلقائياً',
                    ),
                    value: true,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Excluded Zones
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المناطق المستثناة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: const Text('المناطق النائية'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('حفظ الإعدادات'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToBlacklistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة للقائمة السوداء'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الجوال',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الهوية (اختياري)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'سبب الحظر',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'refused',
                    child: Text('رفض الاستلام'),
                  ),
                  DropdownMenuItem(
                    value: 'fake_order',
                    child: Text('طلب وهمي'),
                  ),
                  DropdownMenuItem(value: 'fraud', child: Text('احتيال')),
                  DropdownMenuItem(value: 'other', child: Text('أخرى')),
                ],
                onChanged: (v) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'نوع الحظر',
                  border: OutlineInputBorder(),
                ),
                initialValue: 'permanent',
                items: const [
                  DropdownMenuItem(value: 'permanent', child: Text('دائم')),
                  DropdownMenuItem(value: 'temporary', child: Text('مؤقت')),
                ],
                onChanged: (v) {},
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ملاحظات',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text('إضافة للقائمة'),
          ),
        ],
      ),
    );
  }
}
