import 'package:flutter/material.dart';

class WebstoreScreen extends StatefulWidget {
  const WebstoreScreen({super.key});

  @override
  State<WebstoreScreen> createState() => _WebstoreScreenState();
}

class _WebstoreScreenState extends State<WebstoreScreen>
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
          title: const Text('متجرك الإلكتروني'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'التصميم', icon: Icon(Icons.palette)),
              Tab(text: 'الصفحات', icon: Icon(Icons.article)),
              Tab(text: 'البانرات', icon: Icon(Icons.image)),
              Tab(text: 'SEO', icon: Icon(Icons.search)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.visibility),
              tooltip: 'معاينة المتجر',
              onPressed: () {},
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDesignTab(),
            _buildPagesTab(),
            _buildBannersTab(),
            _buildSeoTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesignTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اختر الثيم',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildThemeCard('عصري', 'modern', true),
                        _buildThemeCard('كلاسيكي', 'classic', false),
                        _buildThemeCard('بسيط', 'minimal', false),
                        _buildThemeCard('جريء', 'bold', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Colors
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الألوان',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildColorPicker('اللون الرئيسي', Colors.indigo),
                  _buildColorPicker('اللون الثانوي', Colors.green),
                  _buildColorPicker('لون التمييز', Colors.amber),
                  _buildColorPicker('لون الخلفية', Colors.white),
                  _buildColorPicker('لون النص', Colors.grey[800]!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Typography
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الخطوط',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'خط العناوين',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: 'Cairo',
                    items: const [
                      DropdownMenuItem(value: 'Cairo', child: Text('Cairo')),
                      DropdownMenuItem(
                        value: 'Tajawal',
                        child: Text('Tajawal'),
                      ),
                      DropdownMenuItem(
                        value: 'Almarai',
                        child: Text('Almarai'),
                      ),
                    ],
                    onChanged: (v) {},
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'خط النص',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: 'Tajawal',
                    items: const [
                      DropdownMenuItem(value: 'Cairo', child: Text('Cairo')),
                      DropdownMenuItem(
                        value: 'Tajawal',
                        child: Text('Tajawal'),
                      ),
                      DropdownMenuItem(
                        value: 'Almarai',
                        child: Text('Almarai'),
                      ),
                    ],
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Layout
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التخطيط',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'نوع التخطيط',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: 'wide',
                    items: const [
                      DropdownMenuItem(value: 'wide', child: Text('عريض')),
                      DropdownMenuItem(value: 'boxed', child: Text('محاط')),
                      DropdownMenuItem(value: 'fluid', child: Text('مرن')),
                    ],
                    onChanged: (v) {},
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'عدد أعمدة المنتجات',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '4',
                    items: const [
                      DropdownMenuItem(value: '3', child: Text('3 أعمدة')),
                      DropdownMenuItem(value: '4', child: Text('4 أعمدة')),
                      DropdownMenuItem(value: '5', child: Text('5 أعمدة')),
                    ],
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Features
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المميزات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('شريط البحث'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('قائمة الأقسام'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('أيقونة السلة'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('قائمة الأمنيات'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('المعاينة السريعة'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('مشاركة المنتجات'),
                    value: true,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('حفظ التصميم'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(String name, String type, bool isSelected) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.web,
            size: 40,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'صفحات المتجر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddPageDialog(),
                icon: const Icon(Icons.add),
                label: const Text('إضافة صفحة'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPageCard('الرئيسية', '/', 'home', true),
          _buildPageCard('من نحن', '/about', 'about', true),
          _buildPageCard('اتصل بنا', '/contact', 'contact', true),
          _buildPageCard('سياسة الخصوصية', '/privacy', 'privacy', true),
          _buildPageCard('الشروط والأحكام', '/terms', 'terms', true),
          _buildPageCard(
            'سياسة الاسترجاع',
            '/return-policy',
            'return_policy',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildPageCard(
    String title,
    String slug,
    String type,
    bool isPublished,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          type == 'home' ? Icons.home : Icons.article,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        subtitle: Text(slug),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPublished
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPublished ? 'منشور' : 'مسودة',
                style: TextStyle(
                  color: isPublished ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'البانرات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddBannerDialog(),
                icon: const Icon(Icons.add),
                label: const Text('إضافة بانر'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'لا توجد بانرات',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'أضف بانرات لتظهر في متجرك',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Basic SEO
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SEO الأساسي',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'عنوان الصفحة الرئيسية',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'وصف الموقع',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الكلمات المفتاحية',
                      border: OutlineInputBorder(),
                      helperText: 'افصل بين الكلمات بفاصلة',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Social Media
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'وسائل التواصل',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'حساب تويتر',
                      border: OutlineInputBorder(),
                      prefixText: '@',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('صورة المشاركة'),
                    subtitle: const Text('الصورة التي تظهر عند مشاركة الرابط'),
                    trailing: OutlinedButton(
                      onPressed: () {},
                      child: const Text('رفع'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Analytics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التحليلات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Google Analytics ID',
                      border: OutlineInputBorder(),
                      hintText: 'G-XXXXXXXXXX',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Facebook Pixel ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'TikTok Pixel ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Verification
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التحقق',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Google Verification Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('تفعيل خريطة الموقع'),
                    subtitle: const Text('Sitemap'),
                    value: true,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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

  void _showAddPageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة صفحة جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'عنوان الصفحة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'الرابط (slug)',
                  border: OutlineInputBorder(),
                  prefixText: '/',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'نوع الصفحة',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'custom', child: Text('صفحة مخصصة')),
                  DropdownMenuItem(value: 'about', child: Text('من نحن')),
                  DropdownMenuItem(value: 'contact', child: Text('اتصل بنا')),
                  DropdownMenuItem(
                    value: 'faq',
                    child: Text('الأسئلة الشائعة'),
                  ),
                ],
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
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showAddBannerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة بانر'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'العنوان الفرعي',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload),
                label: const Text('رفع الصورة'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رابط البانر',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'موقع البانر',
                  border: OutlineInputBorder(),
                ),
                initialValue: 'hero',
                items: const [
                  DropdownMenuItem(
                    value: 'hero',
                    child: Text('الرئيسية (Hero)'),
                  ),
                  DropdownMenuItem(
                    value: 'sidebar',
                    child: Text('الشريط الجانبي'),
                  ),
                  DropdownMenuItem(value: 'footer', child: Text('أسفل الصفحة')),
                ],
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
