import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          title: const Text('طرق الدفع'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
              Tab(text: 'المعاملات', icon: Icon(Icons.receipt_long)),
              Tab(text: 'الإعدادات', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildTransactionsTab(),
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
          // Stats
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'طرق الدفع النشطة',
                '5',
                Icons.payment,
                Colors.blue,
              ),
              _buildStatCard(
                'إجمالي المعاملات',
                '0',
                Icons.receipt,
                Colors.green,
              ),
              _buildStatCard('قيد الانتظار', '0', Icons.pending, Colors.orange),
              _buildStatCard('المبالغ المستردة', '0', Icons.undo, Colors.red),
            ],
          ),
          const SizedBox(height: 24),

          // Payment Methods
          const Text(
            'طرق الدفع المتاحة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppDimensions.spacing12),
          _buildPaymentMethodCard(
            'مدى',
            'mada.png',
            'بطاقات مدى المحلية',
            true,
            Colors.green,
          ),
          _buildPaymentMethodCard(
            'فيزا / ماستركارد',
            'visa.png',
            'البطاقات الائتمانية الدولية',
            true,
            Colors.blue,
          ),
          _buildPaymentMethodCard(
            'Apple Pay',
            'applepay.png',
            'الدفع عبر آبل باي',
            true,
            Colors.black,
          ),
          _buildPaymentMethodCard(
            'STC Pay',
            'stcpay.png',
            'الدفع عبر STC Pay',
            false,
            Colors.purple,
          ),
          _buildPaymentMethodCard(
            'تمارا',
            'tamara.png',
            'اشتر الآن وادفع لاحقاً',
            true,
            Colors.teal,
          ),
          _buildPaymentMethodCard(
            'تابي',
            'tabby.png',
            'التقسيط على 4 دفعات',
            true,
            Colors.indigo,
          ),
          _buildPaymentMethodCard(
            'التحويل البنكي',
            'bank.png',
            'تحويل مباشر للحساب',
            true,
            Colors.grey,
          ),
          _buildPaymentMethodCard(
            'الدفع عند الاستلام',
            'cod.png',
            'COD',
            true,
            Colors.orange,
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

  Widget _buildPaymentMethodCard(
    String name,
    String logo,
    String description,
    bool isActive,
    Color color,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppDimensions.borderRadiusS,
          ),
          child: Icon(Icons.payment, color: color),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(value: isActive, onChanged: (v) {}),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showPaymentSettings(name),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'مكتملة'),
              Tab(text: 'قيد الانتظار'),
              Tab(text: 'مستردة'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTransactionsList('all'),
                _buildTransactionsList('completed'),
                _buildTransactionsList('pending'),
                _buildTransactionsList('refunded'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: AppDimensions.spacing16),
          Text(
            'لا توجد معاملات',
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
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
          // Currency Settings
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إعدادات العملة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'العملة الرئيسية',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: 'SAR',
                    items: const [
                      DropdownMenuItem(
                        value: 'SAR',
                        child: Text('ريال سعودي (SAR)'),
                      ),
                      DropdownMenuItem(
                        value: 'AED',
                        child: Text('درهم إماراتي (AED)'),
                      ),
                      DropdownMenuItem(
                        value: 'USD',
                        child: Text('دولار أمريكي (USD)'),
                      ),
                    ],
                    onChanged: (v) {},
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  SwitchListTile(
                    title: const Text('دعم عملات متعددة'),
                    subtitle: const Text('السماح بالدفع بعملات مختلفة'),
                    value: false,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Capture Settings
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إعدادات الخصم',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('خصم تلقائي'),
                    subtitle: const Text('خصم المبلغ تلقائياً عند الدفع'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'تأخير الخصم (بالساعات)',
                      border: OutlineInputBorder(),
                      helperText: 'اترك فارغاً للخصم الفوري',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Partial Payment
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الدفع الجزئي',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('تفعيل الدفع الجزئي'),
                    subtitle: const Text('السماح للعميل بدفع جزء من المبلغ'),
                    value: false,
                    onChanged: (v) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الحد الأدنى للدفعة (%)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '20',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Notifications
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الإشعارات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('إيصال بالبريد الإلكتروني'),
                    subtitle: const Text('إرسال إيصال الدفع للعميل'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('إشعار SMS'),
                    subtitle: const Text('إرسال رسالة نصية عند الدفع'),
                    value: true,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Refund Policy
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'سياسة الاسترداد',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('استرداد تلقائي'),
                    subtitle: const Text(
                      'السماح بالاسترداد التلقائي للمرتجعات',
                    ),
                    value: false,
                    onChanged: (v) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'مدة سياسة الاسترداد (أيام)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '14',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Bank Accounts
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
                        'الحسابات البنكية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showAddBankAccount(),
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  ListTile(
                    leading: const CircleAvatar(child: Text('🏦')),
                    title: const Text('البنك الأهلي'),
                    subtitle: const Text('SA*************1234'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Chip(
                          label: Text(
                            'الرئيسي',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ],
                    ),
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

  void _showPaymentSettings(String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: AppDimensions.paddingXL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إعدادات $name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensions.spacing16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Merchant ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'API Key',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'API Secret',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: AppDimensions.spacing12),
              SwitchListTile(
                title: const Text('وضع الاختبار'),
                value: true,
                onChanged: (v) {},
              ),
              SizedBox(height: AppDimensions.spacing12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'الحد الأدنى',
                        border: OutlineInputBorder(),
                        suffixText: 'ر.س',
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'الحد الأقصى',
                        border: OutlineInputBorder(),
                        suffixText: 'ر.س',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.spacing16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('حفظ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBankAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة حساب بنكي'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم البنك',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم صاحب الحساب',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الحساب',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم IBAN',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              SwitchListTile(
                title: const Text('حساب رئيسي'),
                value: false,
                onChanged: (v) {},
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
            onPressed: () => Navigator.pop(context),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
