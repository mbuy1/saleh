import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';

class DeliveryOptionsScreen extends StatefulWidget {
  const DeliveryOptionsScreen({super.key});

  @override
  State<DeliveryOptionsScreen> createState() => _DeliveryOptionsScreenState();
}

class _DeliveryOptionsScreenState extends State<DeliveryOptionsScreen>
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
          title: const Text('خيارات التوصيل'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'طرق التوصيل', icon: Icon(Icons.delivery_dining)),
              Tab(text: 'نقاط الاستلام', icon: Icon(Icons.store)),
              Tab(text: 'الإعدادات', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDeliveryMethodsTab(),
            _buildPickupPointsTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryMethodsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        children: [
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'طرق التوصيل',
                  '4',
                  Icons.delivery_dining,
                  Colors.blue,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'نشطة',
                  '3',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing24),

          // Delivery Methods List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'طرق التوصيل',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddMethodDialog(),
                icon: const Icon(Icons.add),
                label: const Text('إضافة'),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          _buildMethodCard(
            'توصيل عادي',
            'التوصيل خلال 2-3 أيام عمل',
            '15 ر.س',
            Icons.local_shipping,
            Colors.blue,
            true,
          ),
          _buildMethodCard(
            'توصيل سريع',
            'التوصيل خلال 24 ساعة',
            '30 ر.س',
            Icons.flash_on,
            Colors.orange,
            true,
          ),
          _buildMethodCard(
            'توصيل نفس اليوم',
            'التوصيل خلال ساعات',
            '50 ر.س',
            Icons.rocket_launch,
            Colors.purple,
            false,
          ),
          _buildMethodCard(
            'استلام من المتجر',
            'استلام مجاني من الفرع',
            'مجاني',
            Icons.store,
            Colors.green,
            true,
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

  Widget _buildMethodCard(
    String name,
    String description,
    String price,
    IconData icon,
    Color color,
    bool isActive,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: AppDimensions.paddingS,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusM,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(value: isActive, onChanged: (v) {}),
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupPointsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'نقاط الاستلام',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddPickupPointDialog(),
                icon: const Icon(Icons.add),
                label: const Text('إضافة نقطة'),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),
          _buildPickupPointCard(
            'الفرع الرئيسي',
            'شارع الملك فهد، الرياض',
            '8:00 ص - 10:00 م',
            true,
          ),
          _buildPickupPointCard(
            'فرع جدة',
            'شارع التحلية، جدة',
            '9:00 ص - 11:00 م',
            true,
          ),
          _buildPickupPointCard(
            'فرع الدمام',
            'شارع الأمير محمد، الدمام',
            '8:00 ص - 9:00 م',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildPickupPointCard(
    String name,
    String address,
    String hours,
    bool isActive,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: AppDimensions.borderRadiusM,
                      ),
                      child: Text(
                        isActive ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          color: isActive ? Colors.green : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: AppDimensions.spacing4),
                Text(address, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: AppDimensions.spacing4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: AppDimensions.spacing4),
                Text(hours, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        children: [
          // Same Day Delivery
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التوصيل في نفس اليوم',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('تفعيل التوصيل في نفس اليوم'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'آخر وقت للطلب',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    initialValue: '14:00',
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'رسوم التوصيل في نفس اليوم',
                      border: OutlineInputBorder(),
                      suffixText: 'ر.س',
                    ),
                    initialValue: '50',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Express Delivery
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التوصيل السريع',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('تفعيل التوصيل السريع'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'مدة التوصيل (بالساعات)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '2',
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'رسوم التوصيل السريع',
                      border: OutlineInputBorder(),
                      suffixText: 'ر.س',
                    ),
                    initialValue: '30',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Delivery Slots
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'فترات التوصيل',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('تفعيل اختيار فترة التوصيل'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الحد الأقصى للحجز (أيام مقدماً)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '7',
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'وقت التجهيز الافتراضي (دقيقة)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '60',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),

          // Tracking Settings
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إعدادات التتبع',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  SwitchListTile(
                    title: const Text('تتبع العميل للشحنة'),
                    subtitle: const Text('السماح للعميل بتتبع موقع الشحنة'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('صورة إثبات التسليم'),
                    subtitle: const Text('مطلوب من السائق'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('توقيع العميل'),
                    subtitle: const Text('مطلوب عند التسليم'),
                    value: false,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('تقييم التوصيل'),
                    subtitle: const Text('السماح للعميل بتقييم التوصيل'),
                    value: true,
                    onChanged: (v) {},
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

  void _showAddMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة طريقة توصيل'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم الطريقة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'الوصف',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'نوع الطريقة',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'shipping', child: Text('شحن')),
                  DropdownMenuItem(value: 'same_day', child: Text('نفس اليوم')),
                  DropdownMenuItem(value: 'express', child: Text('سريع')),
                  DropdownMenuItem(value: 'pickup', child: Text('استلام')),
                ],
                onChanged: (v) {},
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'السعر',
                  border: OutlineInputBorder(),
                  suffixText: 'ر.س',
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'الشحن المجاني فوق',
                  border: OutlineInputBorder(),
                  suffixText: 'ر.س',
                ),
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

  void _showAddPickupPointDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة نقطة استلام'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم النقطة',
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
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'المدينة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ساعات العمل',
                  border: OutlineInputBorder(),
                ),
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
