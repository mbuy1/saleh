import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen>
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
          title: const Text('إدارة الشحن'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
              Tab(text: 'الشحنات', icon: Icon(Icons.local_shipping)),
              Tab(text: 'الإعدادات', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildShipmentsTab(),
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
          // Stats Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'إجمالي الشحنات',
                '0',
                Icons.local_shipping,
                Colors.blue,
              ),
              _buildStatCard('قيد الانتظار', '0', Icons.pending, Colors.orange),
              _buildStatCard(
                'قيد التوصيل',
                '0',
                Icons.delivery_dining,
                Colors.purple,
              ),
              _buildStatCard(
                'تم التوصيل',
                '0',
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing24),

          // Carriers Section
          const Text(
            'شركات الشحن المتاحة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppDimensions.spacing12),
          _buildCarriersList(),
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
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCarriersList() {
    final carriers = [
      {'name': 'أرامكس', 'logo': '📦', 'services': 'Express, Economy'},
      {'name': 'سمسا', 'logo': '🚚', 'services': 'Standard, Express'},
      {'name': 'DHL', 'logo': '✈️', 'services': 'International'},
      {'name': 'زاجل', 'logo': '📬', 'services': 'Local Delivery'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: carriers.length,
      itemBuilder: (context, index) {
        final carrier = carriers[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(carrier['logo']!)),
            title: Text(carrier['name']!),
            subtitle: Text(carrier['services']!),
            trailing: Switch(value: index < 2, onChanged: (v) {}),
          ),
        );
      },
    );
  }

  Widget _buildShipmentsTab() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'قيد الانتظار'),
              Tab(text: 'قيد التوصيل'),
              Tab(text: 'تم التوصيل'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildShipmentsList('all'),
                _buildShipmentsList('pending'),
                _buildShipmentsList('in_transit'),
                _buildShipmentsList('delivered'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentsList(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: AppDimensions.spacing16),
          Text(
            'لا توجد شحنات',
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
          ),
          SizedBox(height: AppDimensions.spacing8),
          ElevatedButton.icon(
            onPressed: () => _showCreateShipmentDialog(),
            icon: const Icon(Icons.add),
            label: const Text('إنشاء شحنة جديدة'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shipping Zones
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
                        'مناطق الشحن',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة منطقة'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: const Text('المنطقة الوسطى'),
                    subtitle: const Text('الرياض، القصيم'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: const Text('المنطقة الغربية'),
                    subtitle: const Text('جدة، مكة'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Default Settings
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الإعدادات الافتراضية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('تأمين الشحنات'),
                    subtitle: const Text('إضافة تأمين تلقائي على الشحنات'),
                    value: false,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('الدفع عند الاستلام'),
                    subtitle: const Text('السماح بالدفع عند الاستلام'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('رسوم الدفع عند الاستلام'),
                    subtitle: const Text('15 ر.س'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ),
                  ListTile(
                    title: const Text('حد الشحن المجاني'),
                    subtitle: const Text('200 ر.س'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Sender Info
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'معلومات المرسل',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم المرسل',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: 'متجري',
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'رقم الجوال',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '05xxxxxxxx',
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'العنوان',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'المدينة',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'الرمز البريدي',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
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
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateShipmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء شحنة جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'شركة الشحن',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'aramex', child: Text('أرامكس')),
                  DropdownMenuItem(value: 'smsa', child: Text('سمسا')),
                ],
                onChanged: (v) {},
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الطلب',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم المستلم',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الجوال',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'العنوان',
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
            onPressed: () => Navigator.pop(context),
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }
}
