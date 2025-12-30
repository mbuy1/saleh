import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../../core/services/api_service.dart';
import '../../../../core/theme/app_theme.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _error;
  int _selectedDays = 7;

  // Stats
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _pages = [];
  List<Map<String, dynamic>> _sessions = [];
  Map<String, dynamic> _settings = {};

  // Selected page for heatmap
  Map<String, dynamic>? _selectedPage;
  Map<String, dynamic>? _pageHeatmap;
  bool _loadingHeatmap = false;

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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _api.get('/secure/heatmap/stats?days=$_selectedDays'),
        _api.get('/secure/heatmap/pages?days=$_selectedDays'),
        _api.get('/secure/heatmap/sessions?limit=20'),
        _api.get('/secure/heatmap/settings'),
      ]);

      if (!mounted) return;

      final statsRes = jsonDecode(results[0].body);
      final pagesRes = jsonDecode(results[1].body);
      final sessionsRes = jsonDecode(results[2].body);
      final settingsRes = jsonDecode(results[3].body);

      setState(() {
        _stats = statsRes['data'] ?? {};
        _pages = List<Map<String, dynamic>>.from(pagesRes['data'] ?? []);
        _sessions = List<Map<String, dynamic>>.from(sessionsRes['data'] ?? []);
        _settings = settingsRes['data'] ?? {};
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPageHeatmap(Map<String, dynamic> page) async {
    setState(() {
      _selectedPage = page;
      _loadingHeatmap = true;
    });

    try {
      final path = Uri.encodeComponent(page['page_path']);
      final response = await _api.get(
        '/secure/heatmap/page/$path?days=$_selectedDays',
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      setState(() {
        _pageHeatmap = data['data'];
        _loadingHeatmap = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingHeatmap = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تحميل الخريطة الحرارية: $e')));
    }
  }

  Future<void> _updateSettings(Map<String, dynamic> newSettings) async {
    try {
      final response = await _api.put(
        '/secure/heatmap/settings',
        body: newSettings,
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      if (data['ok'] == true) {
        setState(() {
          _settings = data['data'];
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل حفظ الإعدادات: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('الخريطة الحرارية'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
            Tab(text: 'الصفحات', icon: Icon(Icons.pages)),
            Tab(text: 'الجلسات', icon: Icon(Icons.videocam)),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'الفترة الزمنية',
            onSelected: (days) {
              setState(() => _selectedDays = days);
              _loadData();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'اليوم',
                  style: TextStyle(
                    fontWeight: _selectedDays == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 7,
                child: Text(
                  '7 أيام',
                  style: TextStyle(
                    fontWeight: _selectedDays == 7
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 30,
                child: Text(
                  '30 يوم',
                  style: TextStyle(
                    fontWeight: _selectedDays == 30
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 90,
                child: Text(
                  '90 يوم',
                  style: TextStyle(
                    fontWeight: _selectedDays == 90
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'الإعدادات',
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: AppDimensions.spacing16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: AppDimensions.spacing16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildPagesTab(),
                _buildSessionsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'إجمالي التفاعلات',
                    '${_stats['total_events'] ?? 0}',
                    Icons.touch_app,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'الجلسات الفريدة',
                    '${_stats['unique_sessions'] ?? 0}',
                    Icons.people,
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
                    'الصفحات المتتبعة',
                    '${_stats['total_pages'] ?? 0}',
                    Icons.description,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'إجمالي النقرات',
                    '${_stats['total_clicks'] ?? 0}',
                    Icons.mouse,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Status card
            _buildStatusCard(),

            const SizedBox(height: 24),

            // Top Pages Preview
            const Text(
              'أكثر الصفحات تفاعلاً',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            if (_pages.isEmpty)
              const Card(
                child: Padding(
                  padding: AppDimensions.paddingXXL,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: AppDimensions.spacing8),
                        Text(
                          'لا توجد بيانات بعد',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ..._pages.take(5).map((page) => _buildPagePreviewCard(page)),

            const SizedBox(height: AppDimensions.spacing16),

            // Quick Tips
            _buildTipsCard(),
          ],
        ),
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
            Icon(icon, size: 32, color: color),
            const SizedBox(height: AppDimensions.spacing8),
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
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final isEnabled = _settings['is_enabled'] ?? true;
    final trackClicks = _settings['track_clicks'] ?? true;
    final trackScrolls = _settings['track_scrolls'] ?? true;
    final recordSessions = _settings['record_sessions'] ?? false;

    return Card(
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isEnabled ? Icons.check_circle : Icons.cancel,
                  color: isEnabled ? Colors.green : Colors.red,
                ),
                const SizedBox(width: AppDimensions.spacing8),
                Text(
                  isEnabled ? 'التتبع نشط' : 'التتبع متوقف',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isEnabled ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('النقرات', trackClicks),
                _buildFeatureChip('التمرير', trackScrolls),
                _buildFeatureChip('تسجيل الجلسات', recordSessions),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, bool enabled) {
    return Chip(
      avatar: Icon(
        enabled ? Icons.check : Icons.close,
        size: 16,
        color: enabled ? Colors.green : Colors.grey,
      ),
      label: Text(label),
      backgroundColor: enabled
          ? Colors.green.withAlpha(25)
          : Colors.grey.withAlpha(25),
    );
  }

  Widget _buildPagePreviewCard(Map<String, dynamic> page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withAlpha(25),
          child: const Icon(Icons.description, color: AppTheme.primaryColor),
        ),
        title: Text(
          page['page_title'] ?? page['page_path'] ?? 'صفحة غير معروفة',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(page['page_path'] ?? ''),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${page['total_clicks'] ?? 0}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'نقرة',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          _tabController.animateTo(1);
          _loadPageHeatmap(page);
        },
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      color: Colors.blue.withAlpha(25),
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
                  'نصائح لتحسين التجربة',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _buildTipItem('راقب أماكن النقرات الأكثر شيوعاً'),
            _buildTipItem('حلل عمق التمرير لفهم اهتمام الزوار'),
            _buildTipItem('استخدم تسجيلات الجلسات لاكتشاف المشاكل'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.blue)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildPagesTab() {
    if (_selectedPage != null && _pageHeatmap != null) {
      return _buildPageHeatmapView();
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: _pages.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا توجد صفحات متتبعة بعد'),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'ستظهر الصفحات هنا عند بدء تتبع تفاعلات الزوار',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: AppDimensions.paddingM,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];
                return _buildPageCard(page);
              },
            ),
    );
  }

  Widget _buildPageCard(Map<String, dynamic> page) {
    final scrollDepth = (page['avg_scroll_depth'] ?? 0).toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _loadPageHeatmap(page),
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
                        Text(
                          page['page_title'] ?? 'بدون عنوان',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          page['page_path'] ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_left, color: Colors.grey),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPageStat(
                    'النقرات',
                    '${page['total_clicks'] ?? 0}',
                    Icons.touch_app,
                  ),
                  _buildPageStat(
                    'الزوار',
                    '${page['unique_visitors'] ?? 0}',
                    Icons.people,
                  ),
                  _buildPageStat(
                    'عمق التمرير',
                    '${scrollDepth.toStringAsFixed(0)}%',
                    Icons.swap_vert,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPageHeatmapView() {
    return Column(
      children: [
        // Header with back button
        Container(
          padding: AppDimensions.paddingM,
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _selectedPage = null;
                    _pageHeatmap = null;
                  });
                },
              ),
              const SizedBox(width: AppDimensions.spacing8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _pageHeatmap?['page_title'] ?? 'صفحة',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _pageHeatmap?['page_path'] ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: _loadingHeatmap
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: AppDimensions.paddingM,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats row
                      Row(
                        children: [
                          Expanded(
                            child: _buildMiniStatCard(
                              'النقرات',
                              '${_pageHeatmap?['total_clicks'] ?? 0}',
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacing8),
                          Expanded(
                            child: _buildMiniStatCard(
                              'الزوار',
                              '${_pageHeatmap?['unique_visitors'] ?? 0}',
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacing8),
                          Expanded(
                            child: _buildMiniStatCard(
                              'عمق التمرير',
                              '${(_pageHeatmap?['avg_scroll_depth'] ?? 0).toStringAsFixed(0)}%',
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Heatmap visualization
                      const Text(
                        'الخريطة الحرارية',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      _buildHeatmapVisualization(),

                      const SizedBox(height: 24),

                      // Hot zones
                      const Text(
                        'المناطق الساخنة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      _buildHotZonesList(),

                      const SizedBox(height: 24),

                      // Top clicked elements
                      const Text(
                        'العناصر الأكثر نقراً',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      _buildTopElementsList(),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildMiniStatCard(String label, String value, Color color) {
    return Container(
      padding: AppDimensions.paddingS,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: AppDimensions.borderRadiusS,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildHeatmapVisualization() {
    final clicks = List<Map<String, dynamic>>.from(
      _pageHeatmap?['clicks'] ?? [],
    );

    if (clicks.isEmpty) {
      return const Card(
        child: Padding(
          padding: AppDimensions.paddingXXL,
          child: Center(
            child: Text(
              'لا توجد بيانات نقرات كافية',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Card(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: AppDimensions.borderRadiusS,
          ),
          child: CustomPaint(painter: HeatmapPainter(clicks)),
        ),
      ),
    );
  }

  Widget _buildHotZonesList() {
    final hotZones = List<Map<String, dynamic>>.from(
      _pageHeatmap?['hot_zones'] ?? [],
    );

    if (hotZones.isEmpty) {
      return const Card(
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Text(
            'لا توجد مناطق ساخنة',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: hotZones.asMap().entries.map((entry) {
          final index = entry.key;
          final zone = entry.value;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getHeatColor(index),
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text('منطقة ${index + 1}'),
            subtitle: Text(
              'X: ${zone['x']?.toStringAsFixed(0)}%, Y: ${zone['y']?.toStringAsFixed(0)}%',
            ),
            trailing: Text(
              '${zone['count']} نقرة',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopElementsList() {
    final elements = List<Map<String, dynamic>>.from(
      _pageHeatmap?['top_elements'] ?? [],
    );

    if (elements.isEmpty) {
      return const Card(
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Text('لا توجد عناصر', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Card(
      child: Column(
        children: elements.map((elem) {
          final tag = elem['tag'] ?? 'element';
          final id = elem['id'] ?? '';
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withAlpha(25),
              child: Text(
                tag
                    .toString()
                    .substring(0, tag.toString().length.clamp(0, 2))
                    .toUpperCase(),
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
            title: Text('<$tag>${id.isNotEmpty ? '#$id' : ''}'),
            trailing: Text(
              '${elem['clicks']} نقرة',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getHeatColor(int index) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow[700]!,
      Colors.green,
      Colors.blue,
    ];
    return colors[index % colors.length];
  }

  Widget _buildSessionsTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _sessions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_off, size: 64, color: Colors.grey),
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا توجد تسجيلات جلسات'),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'فعّل تسجيل الجلسات من الإعدادات',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: AppDimensions.paddingM,
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                return _buildSessionCard(session);
              },
            ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final duration = session['duration_seconds'] ?? 0;
    final pagesVisited = session['pages_visited'] ?? 0;
    final isStarred = session['is_starred'] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withAlpha(25),
          child: const Icon(Icons.person, color: AppTheme.primaryColor),
        ),
        title: Text(
          session['visitor_id']?.toString().substring(0, 8) ?? 'زائر',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_formatDuration(duration)} • $pagesVisited صفحات'),
            Text(
              session['device_type'] ?? 'غير معروف',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isStarred ? Icons.star : Icons.star_border,
                color: isStarred ? Colors.amber : Colors.grey,
              ),
              onPressed: () => _toggleSessionStar(session['id']),
            ),
            const Icon(Icons.chevron_left, color: Colors.grey),
          ],
        ),
        onTap: () => _showSessionDetails(session),
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '$seconds ث';
    if (seconds < 3600) {
      final mins = seconds ~/ 60;
      return '$mins د';
    }
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '$hours س $minutes د';
  }

  Future<void> _toggleSessionStar(String sessionId) async {
    try {
      await _api.patch('/secure/heatmap/sessions/$sessionId/star', body: {});
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تحديث الجلسة: $e')));
    }
  }

  void _showSessionDetails(Map<String, dynamic> session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: AppDimensions.paddingM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'تفاصيل الجلسة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              _buildDetailRow('معرف الزائر', session['visitor_id'] ?? '-'),
              _buildDetailRow('الجهاز', session['device_type'] ?? '-'),
              _buildDetailRow(
                'المدة',
                _formatDuration(session['duration_seconds'] ?? 0),
              ),
              _buildDetailRow('الصفحات', '${session['pages_visited'] ?? 0}'),
              _buildDetailRow('الأحداث', '${session['events_count'] ?? 0}'),
              if (session['entry_page'] != null)
                _buildDetailRow('صفحة الدخول', session['entry_page']),
              if (session['exit_page'] != null)
                _buildDetailRow('صفحة الخروج', session['exit_page']),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSessionPlayback(session);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('تشغيل التسجيل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('إعدادات الخريطة الحرارية'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('تفعيل التتبع'),
                    subtitle: const Text('تشغيل/إيقاف تتبع التفاعلات'),
                    value: _settings['is_enabled'] ?? true,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['is_enabled'] = value;
                      });
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('تتبع النقرات'),
                    value: _settings['track_clicks'] ?? true,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['track_clicks'] = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('تتبع التمرير'),
                    value: _settings['track_scrolls'] ?? true,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['track_scrolls'] = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('تتبع حركة الماوس'),
                    subtitle: const Text('قد يزيد استهلاك البيانات'),
                    value: _settings['track_moves'] ?? false,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['track_moves'] = value;
                      });
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('تسجيل الجلسات'),
                    subtitle: const Text('تسجيل فيديو للجلسات'),
                    value: _settings['record_sessions'] ?? false,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['record_sessions'] = value;
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('فترة الاحتفاظ بالبيانات'),
                    trailing: DropdownButton<int>(
                      value: _settings['data_retention_days'] ?? 30,
                      items: const [
                        DropdownMenuItem(value: 7, child: Text('7 أيام')),
                        DropdownMenuItem(value: 14, child: Text('14 يوم')),
                        DropdownMenuItem(value: 30, child: Text('30 يوم')),
                        DropdownMenuItem(value: 60, child: Text('60 يوم')),
                        DropdownMenuItem(value: 90, child: Text('90 يوم')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          _settings['data_retention_days'] = value;
                        });
                      },
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
                onPressed: () {
                  Navigator.pop(context);
                  _updateSettings(_settings);
                },
                child: const Text('حفظ'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Custom painter for heatmap visualization
class HeatmapPainter extends CustomPainter {
  final List<Map<String, dynamic>> clicks;

  HeatmapPainter(this.clicks);

  @override
  void paint(Canvas canvas, Size size) {
    if (clicks.isEmpty) return;

    for (var click in clicks) {
      final x = (click['x'] ?? 0).toDouble() * size.width / 100;
      final y = (click['y'] ?? 0).toDouble() * size.height / 100;

      // Draw gradient circle
      final gradient = RadialGradient(
        colors: [
          Colors.red.withAlpha(150),
          Colors.orange.withAlpha(100),
          Colors.yellow.withAlpha(50),
          Colors.transparent,
        ],
      );

      final rect = Rect.fromCircle(center: Offset(x, y), radius: 30);
      final paint = Paint()..shader = gradient.createShader(rect);

      canvas.drawCircle(Offset(x, y), 30, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Session Playback Dialog
extension _SessionPlayback on _HeatmapScreenState {
  void _showSessionPlayback(Map<String, dynamic> session) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SessionPlaybackDialog(session: session),
    );
  }
}

class _SessionPlaybackDialog extends StatefulWidget {
  final Map<String, dynamic> session;

  const _SessionPlaybackDialog({required this.session});

  @override
  State<_SessionPlaybackDialog> createState() => _SessionPlaybackDialogState();
}

class _SessionPlaybackDialogState extends State<_SessionPlaybackDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;
  int _currentEventIndex = 0;
  double _playbackSpeed = 1.0;

  // محاكاة أحداث الجلسة
  late List<Map<String, dynamic>> _events;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    // إنشاء أحداث محاكاة بناءً على بيانات الجلسة
    _events = _generateMockEvents();

    _controller.addListener(() {
      if (_controller.isAnimating) {
        final progress = _controller.value;
        final newIndex = (progress * _events.length).floor();
        if (newIndex != _currentEventIndex && newIndex < _events.length) {
          setState(() => _currentEventIndex = newIndex);
        }
      }
    });
  }

  List<Map<String, dynamic>> _generateMockEvents() {
    final pagesVisited = widget.session['pages_visited'] ?? 3;
    final eventsCount = widget.session['events_count'] ?? 10;

    List<Map<String, dynamic>> events = [];

    // إضافة أحداث تنقل
    for (int i = 0; i < pagesVisited; i++) {
      events.add({
        'type': 'pageview',
        'page': i == 0 ? (widget.session['entry_page'] ?? '/') : '/page-$i',
        'time': '${i * 10}s',
      });
    }

    // إضافة أحداث نقر
    for (int i = 0; i < eventsCount - pagesVisited; i++) {
      events.add({
        'type': 'click',
        'x': (20 + (i * 15) % 60).toDouble(),
        'y': (30 + (i * 20) % 40).toDouble(),
        'element': ['زر', 'رابط', 'صورة', 'نص'][i % 4],
      });
    }

    // إضافة صفحة الخروج
    if (widget.session['exit_page'] != null) {
      events.add({'type': 'exit', 'page': widget.session['exit_page']});
    }

    return events;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.forward();
      } else {
        _controller.stop();
      }
    });
  }

  void _resetPlayback() {
    setState(() {
      _controller.reset();
      _currentEventIndex = 0;
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppDimensions.paddingM,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: AppDimensions.paddingM,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle, color: Colors.white),
                  const SizedBox(width: AppDimensions.spacing8),
                  Expanded(
                    child: Text(
                      'تشغيل جلسة: ${widget.session['session_id']?.toString().substring(0, 8) ?? 'غير معروف'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Playback Area
            Expanded(
              child: Container(
                margin: AppDimensions.paddingM,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: AppDimensions.borderRadiusS,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Stack(
                  children: [
                    // محاكاة صفحة الويب
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.web, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: AppDimensions.spacing16),
                          Text(
                            _currentEventIndex < _events.length
                                ? _events[_currentEventIndex]['page'] ??
                                      'الصفحة الرئيسية'
                                : 'انتهى التشغيل',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // مؤشر النقر
                    if (_currentEventIndex < _events.length &&
                        _events[_currentEventIndex]['type'] == 'click')
                      Positioned(
                        left:
                            (_events[_currentEventIndex]['x'] as double) *
                            MediaQuery.of(context).size.width /
                            100,
                        top:
                            (_events[_currentEventIndex]['y'] as double) *
                            300 /
                            100,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withAlpha(150),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.touch_app,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Event Timeline
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  final isActive = index == _currentEventIndex;

                  return Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.primaryColor.withAlpha(50)
                          : Colors.grey[100],
                      borderRadius: AppDimensions.borderRadiusS,
                      border: Border.all(
                        color: isActive
                            ? AppTheme.primaryColor
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          event['type'] == 'pageview'
                              ? Icons.web
                              : event['type'] == 'click'
                              ? Icons.touch_app
                              : Icons.exit_to_app,
                          size: 20,
                          color: isActive ? AppTheme.primaryColor : Colors.grey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isActive
                                ? AppTheme.primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Controls
            Container(
              padding: AppDimensions.paddingM,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay),
                    onPressed: _resetPlayback,
                    tooltip: 'إعادة',
                  ),
                  const SizedBox(width: AppDimensions.spacing16),
                  FloatingActionButton(
                    onPressed: _togglePlayback,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                  const SizedBox(width: AppDimensions.spacing16),
                  // Speed control
                  PopupMenuButton<double>(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.speed),
                        const SizedBox(width: 4),
                        Text(
                          '${_playbackSpeed}x',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    tooltip: 'سرعة التشغيل',
                    onSelected: (speed) {
                      setState(() => _playbackSpeed = speed);
                      _controller.duration = Duration(
                        milliseconds: (30000 / speed).round(),
                      );
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                      const PopupMenuItem(value: 1.0, child: Text('1x')),
                      const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                      const PopupMenuItem(value: 2.0, child: Text('2x')),
                    ],
                  ),
                ],
              ),
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => LinearProgressIndicator(
                  value: _controller.value,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
