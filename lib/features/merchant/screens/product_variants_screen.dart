import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';

class ProductVariantsScreen extends StatefulWidget {
  const ProductVariantsScreen({super.key});

  @override
  State<ProductVariantsScreen> createState() => _ProductVariantsScreenState();
}

class _ProductVariantsScreenState extends State<ProductVariantsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Stats
  int _totalVariants = 0;
  int _activeVariants = 0;
  int _lowStockCount = 0;
  int _outOfStock = 0;

  // Data
  List<Map<String, dynamic>> _variantOptions = [];
  List<Map<String, dynamic>> _priceRules = [];

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
      _totalVariants = 156;
      _activeVariants = 142;
      _lowStockCount = 8;
      _outOfStock = 3;

      _variantOptions = [
        {
          'id': '1',
          'name': 'color',
          'display_name': 'اللون',
          'option_type': 'color',
          'values': [
            {'value': 'black', 'label': 'أسود', 'color': '#000000'},
            {'value': 'white', 'label': 'أبيض', 'color': '#FFFFFF'},
            {'value': 'red', 'label': 'أحمر', 'color': '#FF0000'},
            {'value': 'blue', 'label': 'أزرق', 'color': '#0000FF'},
          ],
          'is_active': true,
        },
        {
          'id': '2',
          'name': 'size',
          'display_name': 'المقاس',
          'option_type': 'size',
          'values': [
            {'value': 'XS', 'label': 'XS'},
            {'value': 'S', 'label': 'S'},
            {'value': 'M', 'label': 'M'},
            {'value': 'L', 'label': 'L'},
            {'value': 'XL', 'label': 'XL'},
            {'value': 'XXL', 'label': 'XXL'},
          ],
          'is_active': true,
        },
        {
          'id': '3',
          'name': 'material',
          'display_name': 'الخامة',
          'option_type': 'select',
          'values': [
            {'value': 'cotton', 'label': 'قطن'},
            {'value': 'polyester', 'label': 'بوليستر'},
            {'value': 'wool', 'label': 'صوف'},
          ],
          'is_active': true,
        },
      ];

      _priceRules = [
        {
          'id': '1',
          'name': 'زيادة سعر المقاسات الكبيرة',
          'rule_type': 'option_value',
          'conditions': {
            'option': 'size',
            'values': ['XL', 'XXL'],
          },
          'adjustment_type': 'fixed',
          'adjustment_value': 10,
          'is_active': true,
        },
        {
          'id': '2',
          'name': 'خصم للقطن',
          'rule_type': 'option_value',
          'conditions': {
            'option': 'material',
            'values': ['cotton'],
          },
          'adjustment_type': 'percent',
          'adjustment_value': -5,
          'is_active': true,
        },
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
          title: const Text('المنتجات المتغيرة'),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
              Tab(text: 'الخيارات', icon: Icon(Icons.tune)),
              Tab(text: 'قواعد التسعير', icon: Icon(Icons.price_change)),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildOptionsTab(),
                  _buildPriceRulesTab(),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(),
          child: const Icon(Icons.add),
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
          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'إجمالي المتغيرات',
                  _totalVariants.toString(),
                  Icons.inventory_2,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'متغيرات نشطة',
                  _activeVariants.toString(),
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
                  'مخزون منخفض',
                  _lowStockCount.toString(),
                  Icons.warning,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'نفاد المخزون',
                  _outOfStock.toString(),
                  Icons.cancel,
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // How it works
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber[700]),
                      const SizedBox(width: AppDimensions.spacing8),
                      const Text(
                        'كيف تعمل المتغيرات؟',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildHowItWorksStep(
                    '1',
                    'إنشاء خيارات',
                    'أنشئ خيارات مثل اللون، المقاس، الخامة',
                    Icons.tune,
                  ),
                  _buildHowItWorksStep(
                    '2',
                    'تطبيق على المنتج',
                    'اختر الخيارات والقيم لكل منتج',
                    Icons.add_box,
                  ),
                  _buildHowItWorksStep(
                    '3',
                    'توليد المتغيرات',
                    'سيتم إنشاء المتغيرات تلقائياً',
                    Icons.auto_awesome,
                  ),
                  _buildHowItWorksStep(
                    '4',
                    'إدارة المخزون',
                    'حدد الكمية والسعر لكل متغير',
                    Icons.inventory,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quick actions
          const Text(
            'إجراءات سريعة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickAction('تحديث المخزون بالجملة', Icons.update, () {}),
              _buildQuickAction('تصدير المتغيرات', Icons.download, () {}),
              _buildQuickAction('استيراد من Excel', Icons.upload_file, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsTab() {
    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: _variantOptions.length,
      itemBuilder: (context, index) {
        final option = _variantOptions[index];
        final values = option['values'] as List;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: _buildOptionTypeIcon(option['option_type']),
            title: Text(
              option['display_name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${values.length} قيمة'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: option['is_active'] ?? true,
                  onChanged: (value) {
                    setState(() {
                      option['is_active'] = value;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditOptionDialog(option),
                ),
              ],
            ),
            children: [
              Padding(
                padding: AppDimensions.paddingM,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'القيم المتاحة:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: values.map<Widget>((v) {
                        if (option['option_type'] == 'color' &&
                            v['color'] != null) {
                          return Chip(
                            avatar: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    v['color'].replaceFirst('#', '0xFF'),
                                  ),
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                            label: Text(v['label']),
                          );
                        }
                        return Chip(label: Text(v['label']));
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    OutlinedButton.icon(
                      onPressed: () => _showAddValueDialog(option),
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة قيمة'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceRulesTab() {
    return ListView(
      padding: AppDimensions.paddingM,
      children: [
        // Info card
        Card(
          color: Colors.blue[50],
          child: Padding(
            padding: AppDimensions.paddingM,
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue[700]),
                const SizedBox(width: AppDimensions.spacing12),
                const Expanded(
                  child: Text(
                    'قواعد التسعير تُطبق تلقائياً على المتغيرات حسب الشروط المحددة',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacing16),

        ..._priceRules.map(
          (rule) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: rule['adjustment_value'] > 0
                    ? Colors.red[100]
                    : Colors.green[100],
                child: Icon(
                  rule['adjustment_value'] > 0
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: rule['adjustment_value'] > 0
                      ? Colors.red
                      : Colors.green,
                ),
              ),
              title: Text(
                rule['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    _buildRuleConditionText(rule),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _buildRuleAdjustmentText(rule),
                    style: TextStyle(
                      color: rule['adjustment_value'] > 0
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: rule['is_active'] ?? true,
                    onChanged: (value) {
                      setState(() {
                        rule['is_active'] = value;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteRule(rule['id']),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacing16),

        OutlinedButton.icon(
          onPressed: _showAddPriceRuleDialog,
          icon: const Icon(Icons.add),
          label: const Text('إضافة قاعدة تسعير'),
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
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksStep(
    String number,
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: AppDimensions.spacing8),
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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

  Widget _buildQuickAction(String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }

  Widget _buildOptionTypeIcon(String? type) {
    switch (type) {
      case 'color':
        return const CircleAvatar(
          backgroundColor: Colors.purple,
          child: Icon(Icons.palette, color: Colors.white, size: 20),
        );
      case 'size':
        return const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.straighten, color: Colors.white, size: 20),
        );
      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.list, color: Colors.white, size: 20),
        );
    }
  }

  String _buildRuleConditionText(Map<String, dynamic> rule) {
    final conditions = rule['conditions'] as Map<String, dynamic>?;
    if (conditions == null) return 'جميع المتغيرات';

    final option = conditions['option'] ?? '';
    final values = (conditions['values'] as List?)?.join(', ') ?? '';

    return 'عند $option = $values';
  }

  String _buildRuleAdjustmentText(Map<String, dynamic> rule) {
    final type = rule['adjustment_type'];
    final value = rule['adjustment_value'];

    if (type == 'percent') {
      return '${value > 0 ? '+' : ''}$value%';
    } else {
      return '${value > 0 ? '+' : ''} $value ر.س';
    }
  }

  void _showAddDialog() {
    if (_tabController.index == 1) {
      _showAddOptionDialog();
    } else if (_tabController.index == 2) {
      _showAddPriceRuleDialog();
    }
  }

  void _showAddOptionDialog() {
    final nameController = TextEditingController();
    final displayNameController = TextEditingController();
    String selectedType = 'select';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة خيار جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الخيار (بالإنجليزية)',
                  hintText: 'مثال: color',
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم العرض',
                  hintText: 'مثال: اللون',
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: const InputDecoration(labelText: 'نوع الخيار'),
                items: const [
                  DropdownMenuItem(
                    value: 'select',
                    child: Text('قائمة منسدلة'),
                  ),
                  DropdownMenuItem(value: 'color', child: Text('اختيار لون')),
                  DropdownMenuItem(value: 'size', child: Text('مقاس')),
                ],
                onChanged: (value) {
                  selectedType = value!;
                },
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
              // Add option
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إضافة الخيار بنجاح')),
              );
              _loadData();
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditOptionDialog(Map<String, dynamic> option) {
    // Edit option dialog
  }

  void _showAddValueDialog(Map<String, dynamic> option) {
    final valueController = TextEditingController();
    final labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة قيمة لـ ${option['display_name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'القيمة',
                hintText: 'مثال: green',
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            TextField(
              controller: labelController,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                hintText: 'مثال: أخضر',
              ),
            ),
          ],
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
              ).showSnackBar(const SnackBar(content: Text('تم إضافة القيمة')));
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showAddPriceRuleDialog() {
    final nameController = TextEditingController();
    String ruleType = 'option_value';
    String adjustmentType = 'fixed';
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة قاعدة تسعير'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم القاعدة'),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              DropdownButtonFormField<String>(
                initialValue: ruleType,
                decoration: const InputDecoration(labelText: 'نوع القاعدة'),
                items: const [
                  DropdownMenuItem(
                    value: 'option_value',
                    child: Text('حسب قيمة الخيار'),
                  ),
                  DropdownMenuItem(value: 'bulk', child: Text('تسعير الجملة')),
                ],
                onChanged: (value) {
                  ruleType = value!;
                },
              ),
              const SizedBox(height: AppDimensions.spacing16),
              DropdownButtonFormField<String>(
                initialValue: adjustmentType,
                decoration: const InputDecoration(labelText: 'نوع التعديل'),
                items: const [
                  DropdownMenuItem(value: 'fixed', child: Text('مبلغ ثابت')),
                  DropdownMenuItem(value: 'percent', child: Text('نسبة مئوية')),
                ],
                onChanged: (value) {
                  adjustmentType = value!;
                },
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: valueController,
                decoration: InputDecoration(
                  labelText: 'القيمة',
                  suffixText: adjustmentType == 'percent' ? '%' : 'ر.س',
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
                const SnackBar(content: Text('تم إضافة قاعدة التسعير')),
              );
              _loadData();
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _deleteRule(String ruleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف القاعدة'),
        content: const Text('هل أنت متأكد من حذف هذه القاعدة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _priceRules.removeWhere((r) => r['id'] == ruleId);
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حذف القاعدة')));
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
