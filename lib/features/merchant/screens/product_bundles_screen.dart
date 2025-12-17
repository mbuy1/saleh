import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';

class ProductBundlesScreen extends StatefulWidget {
  const ProductBundlesScreen({super.key});

  @override
  State<ProductBundlesScreen> createState() => _ProductBundlesScreenState();
}

class _ProductBundlesScreenState extends State<ProductBundlesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Stats
  int _totalBundles = 0;
  int _activeBundles = 0;
  int _totalOrders = 0;
  double _totalSavings = 0;

  // Data
  List<Map<String, dynamic>> _bundles = [];
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _totalBundles = 12;
      _activeBundles = 8;
      _totalOrders = 156;
      _totalSavings = 4520;

      _bundles = [
        {
          'id': '1',
          'name': 'باقة العيد المميزة',
          'description': 'مجموعة منتجات مختارة بمناسبة العيد',
          'bundle_type': 'fixed',
          'original_price': 500,
          'bundle_price': 399,
          'status': 'active',
          'items_count': 5,
          'order_count': 45,
          'featured': true,
          'image_url': null,
        },
        {
          'id': '2',
          'name': 'طقم الشتاء',
          'description': 'كل ما تحتاجه لموسم الشتاء',
          'bundle_type': 'discount_percent',
          'discount_value': 20,
          'original_price': 350,
          'bundle_price': 280,
          'status': 'active',
          'items_count': 3,
          'order_count': 28,
          'featured': false,
          'image_url': null,
        },
        {
          'id': '3',
          'name': 'مجموعة الهدايا',
          'description': 'هدية مثالية لأحبائك',
          'bundle_type': 'fixed',
          'original_price': 200,
          'bundle_price': 159,
          'status': 'scheduled',
          'start_date': DateTime.now()
              .add(const Duration(days: 7))
              .toIso8601String(),
          'items_count': 4,
          'order_count': 0,
          'featured': true,
          'image_url': null,
        },
      ];

      _categories = [
        {'id': '1', 'name': 'عروض موسمية', 'bundles_count': 4},
        {'id': '2', 'name': 'هدايا', 'bundles_count': 3},
        {'id': '3', 'name': 'باقات توفيرية', 'bundles_count': 5},
      ];

      _isLoading = false;
    });
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
          title: const Text('باقات المنتجات'),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
              Tab(text: 'الباقات', icon: Icon(Icons.inventory_2)),
              Tab(text: 'الفئات', icon: Icon(Icons.category)),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildBundlesTab(),
                  _buildCategoriesTab(),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateBundleDialog(),
          icon: const Icon(Icons.add),
          label: const Text('باقة جديدة'),
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
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'إجمالي الباقات',
                  _totalBundles.toString(),
                  Icons.inventory_2,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'باقات نشطة',
                  _activeBundles.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'إجمالي الطلبات',
                  _totalOrders.toString(),
                  Icons.shopping_bag,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'إجمالي التوفير',
                  '${_totalSavings.toStringAsFixed(0)} ر.س',
                  Icons.savings,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Benefits
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber[700]),
                      const SizedBox(width: AppDimensions.spacing8),
                      const Text(
                        'مزايا الباقات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildBenefitItem(
                    Icons.trending_up,
                    'زيادة المبيعات',
                    'تشجيع العملاء على شراء أكثر بعرض أسعار مخفضة',
                  ),
                  _buildBenefitItem(
                    Icons.inventory,
                    'تصريف المخزون',
                    'بيع المنتجات بطيئة الحركة ضمن باقات',
                  ),
                  _buildBenefitItem(
                    Icons.card_giftcard,
                    'هدايا جاهزة',
                    'تقديم خيارات هدايا مغلفة ومعدة مسبقاً',
                  ),
                  _buildBenefitItem(
                    Icons.star,
                    'تجربة مميزة',
                    'تسهيل عملية الشراء للعملاء',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Featured bundles
          const Text(
            'الباقات المميزة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          ..._bundles
              .where((b) => b['featured'] == true)
              .map((bundle) => _buildFeaturedBundleCard(bundle)),
        ],
      ),
    );
  }

  Widget _buildBundlesTab() {
    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: _bundles.length,
      itemBuilder: (context, index) {
        final bundle = _bundles[index];
        final status = bundle['status'] as String;
        final originalPrice = (bundle['original_price'] as num?)?.toDouble() ?? 0.0;
        final bundlePrice = (bundle['bundle_price'] as num?)?.toDouble() ?? 0.0;
        final savings = originalPrice - bundlePrice;
        final savingsPercent = (savings / originalPrice * 100).round();

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showBundleDetails(bundle),
            borderRadius: AppDimensions.borderRadiusM,
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  bundle['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spacing8),
                                if (bundle['featured'] == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'مميز',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bundle['description'] ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(status),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'السعر',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${bundlePrice.toStringAsFixed(0)} ر.س',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spacing8),
                                Text(
                                  '${originalPrice.toStringAsFixed(0)} ر.س',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: AppDimensions.borderRadiusXL,
                        ),
                        child: Text(
                          'وفر $savingsPercent%',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  Row(
                    children: [
                      _buildBundleInfo(
                        Icons.inventory_2,
                        '${bundle['items_count']} منتج',
                      ),
                      const SizedBox(width: AppDimensions.spacing16),
                      _buildBundleInfo(
                        Icons.shopping_cart,
                        '${bundle['order_count']} طلب',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    return ListView(
      padding: AppDimensions.paddingM,
      children: [
        // Add category button
        OutlinedButton.icon(
          onPressed: _showAddCategoryDialog,
          icon: const Icon(Icons.add),
          label: const Text('إضافة فئة جديدة'),
        ),
        const SizedBox(height: AppDimensions.spacing16),

        ..._categories.map(
          (category) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.folder, color: Colors.blue[700]),
              ),
              title: Text(
                category['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${category['bundles_count']} باقة'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppDimensions.paddingXS,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: AppDimensions.borderRadiusS,
            ),
            child: Icon(icon, color: Colors.blue[700], size: 20),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBundleCard(Map<String, dynamic> bundle) {
    final originalPrice = (bundle['original_price'] as num?)?.toDouble() ?? 0.0;
    final bundlePrice = (bundle['bundle_price'] as num?)?.toDouble() ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: AppDimensions.borderRadiusS,
          ),
          child: Icon(Icons.star, color: Colors.amber[700]),
        ),
        title: Text(
          bundle['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${bundle['items_count']} منتج • ${bundlePrice.toStringAsFixed(0)} ر.س',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: AppDimensions.borderRadiusM,
          ),
          child: Text(
            'وفر ${(originalPrice - bundlePrice).toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'active':
        color = Colors.green;
        label = 'نشط';
        break;
      case 'inactive':
        color = Colors.grey;
        label = 'غير نشط';
        break;
      case 'scheduled':
        color = Colors.blue;
        label = 'مجدول';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBundleInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  void _showCreateBundleDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    String bundleType = 'fixed';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء باقة جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الباقة',
                  hintText: 'مثال: باقة العيد',
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'الوصف'),
                maxLines: 2,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              DropdownButtonFormField<String>(
                initialValue: bundleType,
                decoration: const InputDecoration(labelText: 'نوع التسعير'),
                items: const [
                  DropdownMenuItem(value: 'fixed', child: Text('سعر ثابت')),
                  DropdownMenuItem(
                    value: 'discount_percent',
                    child: Text('خصم نسبي'),
                  ),
                  DropdownMenuItem(
                    value: 'discount_fixed',
                    child: Text('خصم مبلغ ثابت'),
                  ),
                ],
                onChanged: (value) {
                  bundleType = value!;
                },
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: bundleType == 'fixed'
                      ? 'سعر الباقة'
                      : 'قيمة الخصم',
                  suffixText: bundleType == 'discount_percent' ? '%' : 'ر.س',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إنشاء الباقة بنجاح')),
              );
              _loadData();
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showBundleDetails(Map<String, dynamic> bundle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: AppDimensions.paddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  bundle['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  bundle['description'] ?? '',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                const Text(
                  'منتجات الباقة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                const Text('لم يتم إضافة منتجات بعد'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة منتج'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('تعديل الباقة'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة فئة'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'اسم الفئة'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم إضافة الفئة')));
              _loadData();
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
