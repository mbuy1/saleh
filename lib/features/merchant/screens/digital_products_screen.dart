import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';

class DigitalProductsScreen extends StatefulWidget {
  const DigitalProductsScreen({super.key});

  @override
  State<DigitalProductsScreen> createState() => _DigitalProductsScreenState();
}

class _DigitalProductsScreenState extends State<DigitalProductsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Stats
  int _totalProducts = 0;
  int _totalDownloads = 0;
  int _totalCourses = 0;

  // Data
  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic> _settings = {};

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
      _totalProducts = 15;
      _totalDownloads = 234;
      _totalCourses = 3;

      _products = [
        {
          'id': '1',
          'product_name': 'كتاب التسويق الرقمي',
          'digital_type': 'ebook',
          'file_name': 'digital-marketing.pdf',
          'file_size': 15728640, // 15MB
          'download_count': 45,
          'version': '2.0',
          'license_type': 'personal',
        },
        {
          'id': '2',
          'product_name': 'دورة التصوير الفوتوغرافي',
          'digital_type': 'course',
          'lessons_count': 24,
          'total_duration': 480, // 8 hours
          'enrolled_count': 67,
          'certificate_enabled': true,
        },
        {
          'id': '3',
          'product_name': 'قوالب تصميم السوشيال ميديا',
          'digital_type': 'template',
          'file_name': 'social-templates.zip',
          'file_size': 52428800, // 50MB
          'download_count': 89,
          'license_type': 'commercial',
        },
        {
          'id': '4',
          'product_name': 'مكتبة المؤثرات الصوتية',
          'digital_type': 'audio',
          'file_name': 'sound-effects.zip',
          'file_size': 104857600, // 100MB
          'download_count': 33,
          'license_type': 'extended',
        },
      ];

      _settings = {
        'default_max_downloads': 5,
        'default_download_expiry_days': 30,
        'enable_drm': false,
        'watermark_enabled': false,
        'auto_deliver': true,
      };

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
          title: const Text('المنتجات الرقمية'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showSettingsDialog,
            ),
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
              Tab(text: 'المنتجات', icon: Icon(Icons.cloud_download)),
              Tab(text: 'الدورات', icon: Icon(Icons.school)),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildProductsTab(),
                  _buildCoursesTab(),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateProductDialog,
          icon: const Icon(Icons.add),
          label: const Text('منتج رقمي'),
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
                  'المنتجات الرقمية',
                  _totalProducts.toString(),
                  Icons.cloud_download,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'إجمالي التحميلات',
                  _totalDownloads.toString(),
                  Icons.download_done,
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
                  'الدورات',
                  _totalCourses.toString(),
                  Icons.school,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(child: Container()),
            ],
          ),

          const SizedBox(height: 24),

          // Product types
          Card(
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أنواع المنتجات الرقمية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildProductTypeChip(
                        Icons.book,
                        'كتب إلكترونية',
                        'ebook',
                      ),
                      _buildProductTypeChip(Icons.school, 'دورات', 'course'),
                      _buildProductTypeChip(
                        Icons.music_note,
                        'ملفات صوتية',
                        'audio',
                      ),
                      _buildProductTypeChip(
                        Icons.video_library,
                        'فيديوهات',
                        'video',
                      ),
                      _buildProductTypeChip(
                        Icons.design_services,
                        'قوالب',
                        'template',
                      ),
                      _buildProductTypeChip(Icons.apps, 'برامج', 'software'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Features
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
                        'مميزات المنتجات الرقمية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildFeatureItem(
                    Icons.delivery_dining,
                    'توصيل فوري',
                    'يحصل العميل على الملف فور الدفع',
                  ),
                  _buildFeatureItem(
                    Icons.security,
                    'حماية الملفات',
                    'حماية ضد النسخ والتوزيع غير المصرح',
                  ),
                  _buildFeatureItem(
                    Icons.analytics,
                    'تتبع التحميلات',
                    'معرفة من قام بالتحميل ومتى',
                  ),
                  _buildFeatureItem(
                    Icons.workspace_premium,
                    'شهادات إتمام',
                    'إصدار شهادات تلقائية للدورات',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    final nonCourseProducts = _products
        .where((p) => p['digital_type'] != 'course')
        .toList();

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: nonCourseProducts.length,
      itemBuilder: (context, index) {
        final product = nonCourseProducts[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showProductDetails(product),
            borderRadius: AppDimensions.borderRadiusM,
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getTypeColor(
                        product['digital_type'],
                      ).withValues(alpha: 0.1),
                      borderRadius: AppDimensions.borderRadiusM,
                    ),
                    child: Icon(
                      _getTypeIcon(product['digital_type']),
                      color: _getTypeColor(product['digital_type']),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['product_name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildProductChip(
                              _getTypeName(product['digital_type']),
                              _getTypeColor(product['digital_type']),
                            ),
                            const SizedBox(width: AppDimensions.spacing8),
                            if (product['file_size'] != null)
                              Text(
                                _formatFileSize(product['file_size']),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        Row(
                          children: [
                            Icon(
                              Icons.download,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product['download_count']} تحميل',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing16),
                            Icon(
                              Icons.verified_user,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getLicenseName(product['license_type']),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showProductOptions(product),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoursesTab() {
    final courses = _products
        .where((p) => p['digital_type'] == 'course')
        .toList();

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64, color: Colors.grey[400]),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              'لا توجد دورات بعد',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _showCreateCourseDialog(),
              icon: const Icon(Icons.add),
              label: const Text('إنشاء دورة'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.school,
                    size: 48,
                    color: Colors.purple[700],
                  ),
                ),
              ),
              Padding(
                padding: AppDimensions.paddingM,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['product_name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing12),
                    Row(
                      children: [
                        _buildCourseInfo(
                          Icons.play_lesson,
                          '${course['lessons_count']} درس',
                        ),
                        const SizedBox(width: AppDimensions.spacing16),
                        _buildCourseInfo(
                          Icons.timer,
                          _formatDuration(course['total_duration']),
                        ),
                        const SizedBox(width: AppDimensions.spacing16),
                        _buildCourseInfo(
                          Icons.people,
                          '${course['enrolled_count']} طالب',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing12),
                    Row(
                      children: [
                        if (course['certificate_enabled'] == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: AppDimensions.borderRadiusM,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.workspace_premium,
                                  size: 14,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'شهادة إتمام',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text('إدارة الدروس'),
                        ),
                        FilledButton(
                          onPressed: () {},
                          child: const Text('تعديل'),
                        ),
                      ],
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
                fontSize: 24,
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

  Widget _buildProductTypeChip(IconData icon, String label, String type) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () => _showCreateProductDialog(type: type),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
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

  Widget _buildProductChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppDimensions.borderRadiusS,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCourseInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'ebook':
        return Icons.book;
      case 'course':
        return Icons.school;
      case 'audio':
        return Icons.music_note;
      case 'video':
        return Icons.video_library;
      case 'template':
        return Icons.design_services;
      case 'software':
        return Icons.apps;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'ebook':
        return Colors.blue;
      case 'course':
        return Colors.purple;
      case 'audio':
        return Colors.orange;
      case 'video':
        return Colors.red;
      case 'template':
        return Colors.teal;
      case 'software':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'ebook':
        return 'كتاب إلكتروني';
      case 'course':
        return 'دورة';
      case 'audio':
        return 'ملف صوتي';
      case 'video':
        return 'فيديو';
      case 'template':
        return 'قالب';
      case 'software':
        return 'برنامج';
      default:
        return 'أخرى';
    }
  }

  String _getLicenseName(String? type) {
    switch (type) {
      case 'personal':
        return 'شخصي';
      case 'commercial':
        return 'تجاري';
      case 'extended':
        return 'موسع';
      default:
        return 'شخصي';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }

  String _formatDuration(int? minutes) {
    if (minutes == null) return '0 دقيقة';
    if (minutes < 60) return '$minutes دقيقة';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours ساعة';
    return '$hours ساعة و $mins دقيقة';
  }

  void _showCreateProductDialog({String? type}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة منتج رقمي'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'نوع المنتج'),
                items: const [
                  DropdownMenuItem(
                    value: 'ebook',
                    child: Text('كتاب إلكتروني'),
                  ),
                  DropdownMenuItem(value: 'audio', child: Text('ملف صوتي')),
                  DropdownMenuItem(value: 'video', child: Text('فيديو')),
                  DropdownMenuItem(value: 'template', child: Text('قالب')),
                  DropdownMenuItem(value: 'software', child: Text('برنامج')),
                  DropdownMenuItem(value: 'other', child: Text('أخرى')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: AppDimensions.spacing16),
              const TextField(
                decoration: InputDecoration(labelText: 'اسم المنتج'),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file),
                label: const Text('رفع الملف'),
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم إضافة المنتج')));
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showCreateCourseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء دورة جديدة'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'عنوان الدورة')),
              SizedBox(height: AppDimensions.spacing16),
              TextField(
                decoration: InputDecoration(labelText: 'وصف الدورة'),
                maxLines: 3,
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم إنشاء الدورة')));
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> product) {
    // Show product details
  }

  void _showProductOptions(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('تعديل'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('نسخ رابط التحميل'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('سجل التحميلات'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('حذف', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعدادات المنتجات الرقمية'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _settings['default_max_downloads']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'عدد التحميلات الافتراضي',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextFormField(
                initialValue: _settings['default_download_expiry_days']
                    ?.toString(),
                decoration: const InputDecoration(
                  labelText: 'صلاحية الرابط (أيام)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              SwitchListTile(
                title: const Text('تسليم تلقائي'),
                subtitle: const Text('إرسال الملف فور الدفع'),
                value: _settings['auto_deliver'] ?? true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('علامة مائية'),
                subtitle: const Text('إضافة علامة مائية على الملفات'),
                value: _settings['watermark_enabled'] ?? false,
                onChanged: (value) {},
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات')));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
