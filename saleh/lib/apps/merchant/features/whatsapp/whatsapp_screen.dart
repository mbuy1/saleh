import 'package:flutter/material.dart';

class WhatsappScreen extends StatefulWidget {
  const WhatsappScreen({super.key});

  @override
  State<WhatsappScreen> createState() => _WhatsappScreenState();
}

class _WhatsappScreenState extends State<WhatsappScreen>
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
          title: const Text('واتساب بزنس'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'المحادثات', icon: Icon(Icons.chat)),
              Tab(text: 'الردود السريعة', icon: Icon(Icons.quickreply)),
              Tab(text: 'الحملات', icon: Icon(Icons.campaign)),
              Tab(text: 'الإعدادات', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildConversationsTab(),
            _buildQuickRepliesTab(),
            _buildCampaignsTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationsTab() {
    return Column(
      children: [
        // Stats Row
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'المحادثات',
                  '0',
                  Icons.chat,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'غير مقروء',
                  '0',
                  Icons.mark_unread_chat_alt,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'قيد الانتظار',
                  '0',
                  Icons.pending,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ),

        // Filter Tabs
        DefaultTabController(
          length: 4,
          child: Column(
            children: [
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'الكل'),
                  Tab(text: 'نشط'),
                  Tab(text: 'قيد الانتظار'),
                  Tab(text: 'مغلق'),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 350,
                child: TabBarView(
                  children: [
                    _buildConversationsList(),
                    _buildConversationsList(),
                    _buildConversationsList(),
                    _buildConversationsList(),
                  ],
                ),
              ),
            ],
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationsList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'لا توجد محادثات',
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر محادثات واتساب هنا',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRepliesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الردود السريعة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddQuickReplyDialog(),
                icon: const Icon(Icons.add),
                label: const Text('إضافة رد'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildQuickReplyCard(
            '/مرحبا',
            'رسالة ترحيب',
            'أهلاً وسهلاً بك في متجرنا! كيف يمكنني مساعدتك؟',
          ),
          _buildQuickReplyCard(
            '/السعر',
            'استفسار عن السعر',
            'شكراً لاستفسارك! يمكنك الاطلاع على الأسعار في متجرنا: [رابط]',
          ),
          _buildQuickReplyCard(
            '/ساعات',
            'ساعات العمل',
            'ساعات العمل: السبت-الخميس من 9 صباحاً حتى 10 مساءً',
          ),
          _buildQuickReplyCard(
            '/شحن',
            'معلومات الشحن',
            'نوفر خدمة الشحن لجميع مناطق المملكة خلال 2-5 أيام عمل',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplyCard(String shortcut, String title, String message) {
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        shortcut,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(message, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Templates Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'قوالب الرسائل',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('قالب جديد'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTemplateItem(
                    'تأكيد الطلب',
                    'order_confirmation',
                    'approved',
                  ),
                  _buildTemplateItem(
                    'تحديث الشحن',
                    'shipping_update',
                    'approved',
                  ),
                  _buildTemplateItem('عرض خاص', 'special_offer', 'pending'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Broadcasts Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الحملات الجماعية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showCreateCampaignDialog(),
                        icon: const Icon(Icons.send),
                        label: const Text('حملة جديدة'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'لا توجد حملات',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Auto Replies
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الردود الآلية',
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
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('رد الترحيب'),
                    subtitle: const Text('عند أول رسالة من العميل'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('رد خارج ساعات العمل'),
                    subtitle: const Text('عند الرسائل خارج أوقات الدوام'),
                    value: true,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateItem(String name, String id, String status) {
    final isApproved = status == 'approved';
    return ListTile(
      leading: Icon(
        Icons.description,
        color: isApproved ? Colors.green : Colors.orange,
      ),
      title: Text(name),
      subtitle: Text(id),
      trailing: Chip(
        label: Text(
          isApproved ? 'معتمد' : 'قيد المراجعة',
          style: TextStyle(
            color: isApproved ? Colors.green : Colors.orange,
            fontSize: 12,
          ),
        ),
        backgroundColor: isApproved
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Connection Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 12),
                      const SizedBox(width: 8),
                      const Text(
                        'غير متصل',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.qr_code),
                      label: const Text('ربط واتساب بزنس'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Business Profile
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الملف التجاري',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'رقم الواتساب',
                      border: OutlineInputBorder(),
                      prefixText: '+966 ',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم النشاط',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'وصف النشاط',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'رابط الموقع',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Working Hours
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ساعات العمل',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildWorkingHoursRow('السبت', '09:00', '22:00', true),
                  _buildWorkingHoursRow('الأحد', '09:00', '22:00', true),
                  _buildWorkingHoursRow('الاثنين', '09:00', '22:00', true),
                  _buildWorkingHoursRow('الثلاثاء', '09:00', '22:00', true),
                  _buildWorkingHoursRow('الأربعاء', '09:00', '22:00', true),
                  _buildWorkingHoursRow('الخميس', '09:00', '22:00', true),
                  _buildWorkingHoursRow('الجمعة', '---', '---', false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notifications
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الإشعارات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('إشعارات الطلبات الجديدة'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('تحديثات الشحن'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('الرد الآلي'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  SwitchListTile(
                    title: const Text('مزامنة الكتالوج'),
                    value: false,
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

  Widget _buildWorkingHoursRow(
    String day,
    String from,
    String to,
    bool isActive,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(day)),
          Expanded(
            child: Row(
              children: [
                Text(
                  from,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
                const Text(' - '),
                Text(
                  to,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: isActive, onChanged: (v) {}),
        ],
      ),
    );
  }

  void _showAddQuickReplyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة رد سريع'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'الاختصار',
                  border: OutlineInputBorder(),
                  prefixText: '/',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'نص الرسالة',
                  border: OutlineInputBorder(),
                ),
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
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showCreateCampaignDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء حملة جماعية'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم الحملة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'القالب',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'order', child: Text('تأكيد الطلب')),
                  DropdownMenuItem(
                    value: 'shipping',
                    child: Text('تحديث الشحن'),
                  ),
                  DropdownMenuItem(value: 'offer', child: Text('عرض خاص')),
                ],
                onChanged: (v) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'الجمهور',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('جميع العملاء')),
                  DropdownMenuItem(
                    value: 'active',
                    child: Text('العملاء النشطين'),
                  ),
                  DropdownMenuItem(value: 'new', child: Text('العملاء الجدد')),
                ],
                onChanged: (v) {},
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('جدولة الإرسال'),
                trailing: Switch(value: false, onChanged: (v) {}),
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
