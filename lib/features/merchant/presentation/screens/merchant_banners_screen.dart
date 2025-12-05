import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// شاشة إدارة البانرات للتاجر
class MerchantBannersScreen extends StatefulWidget {
  const MerchantBannersScreen({super.key});

  @override
  State<MerchantBannersScreen> createState() => _MerchantBannersScreenState();
}

class _MerchantBannersScreenState extends State<MerchantBannersScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _banners = [];

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.getMerchantBanners();

      if (response['ok'] == true || response['success'] == true) {
        final data = response['data'];
        final bannersData = (data is List) ? data : [];
        _banners = bannersData.map((b) => b as Map<String, dynamic>).toList();
      } else {
        _loadDummyData();
      }
    } catch (e) {
      debugPrint('Error loading banners: $e');
      _loadDummyData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _loadDummyData() {
    _banners = [
      {
        'id': '1',
        'title': 'عروض الجمعة البيضاء',
        'subtitle': 'خصومات تصل إلى 70%',
        'image_url':
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
        'link_type': 'category',
        'link_id': 'electronics',
        'position': 1,
        'is_active': true,
        'start_date': DateTime.now().toIso8601String(),
        'end_date': DateTime.now()
            .add(const Duration(days: 7))
            .toIso8601String(),
        'views': 1250,
        'clicks': 340,
      },
      {
        'id': '2',
        'title': 'منتجات جديدة',
        'subtitle': 'اكتشف أحدث المنتجات',
        'image_url':
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
        'link_type': 'collection',
        'link_id': 'new_arrivals',
        'position': 2,
        'is_active': true,
        'start_date': DateTime.now().toIso8601String(),
        'end_date': null,
        'views': 890,
        'clicks': 210,
      },
      {
        'id': '3',
        'title': 'شحن مجاني',
        'subtitle': 'للطلبات فوق 200 ريال',
        'image_url':
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800',
        'link_type': 'page',
        'link_id': 'shipping_policy',
        'position': 3,
        'is_active': false,
        'start_date': null,
        'end_date': null,
        'views': 450,
        'clicks': 89,
      },
    ];
  }

  Future<void> _addBanner() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddBannerSheet(),
    );

    if (result != null) {
      setState(() {
        _banners.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          ...result,
          'position': _banners.length + 1,
          'views': 0,
          'clicks': 0,
        });
      });

      try {
        await ApiService.createBanner(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم إضافة البانر بنجاح',
                style: GoogleFonts.cairo(),
              ),
              backgroundColor: MbuyColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم إضافة البانر محلياً',
                style: GoogleFonts.cairo(),
              ),
              backgroundColor: MbuyColors.success,
            ),
          );
        }
      }
    }
  }

  Future<void> _editBanner(Map<String, dynamic> banner) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddBannerSheet(banner: banner),
    );

    if (result != null) {
      setState(() {
        final index = _banners.indexWhere((b) => b['id'] == banner['id']);
        if (index != -1) {
          _banners[index] = {..._banners[index], ...result};
        }
      });

      try {
        await ApiService.updateBanner(banner['id'] as String, result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تحديث البانر بنجاح',
                style: GoogleFonts.cairo(),
              ),
              backgroundColor: MbuyColors.success,
            ),
          );
        }
      } catch (e) {
        // تم التحديث محلياً
      }
    }
  }

  Future<void> _toggleBannerStatus(Map<String, dynamic> banner) async {
    final newStatus = !(banner['is_active'] as bool? ?? false);

    setState(() {
      final index = _banners.indexWhere((b) => b['id'] == banner['id']);
      if (index != -1) {
        _banners[index]['is_active'] = newStatus;
      }
    });

    try {
      await ApiService.updateBanner(banner['id'] as String, {
        'is_active': newStatus,
      });
    } catch (e) {
      // تم التحديث محلياً
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus ? 'تم تفعيل البانر' : 'تم إيقاف البانر',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: newStatus ? MbuyColors.success : MbuyColors.warning,
        ),
      );
    }
  }

  Future<void> _deleteBanner(Map<String, dynamic> banner) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف البانر',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من حذف "${banner['title']}"؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: MbuyColors.error),
            child: Text('حذف', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _banners.removeWhere((b) => b['id'] == banner['id']);
      });

      try {
        await ApiService.deleteBanner(banner['id'] as String);
      } catch (e) {
        // تم الحذف محلياً
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف البانر', style: GoogleFonts.cairo()),
            backgroundColor: MbuyColors.error,
          ),
        );
      }
    }
  }

  void _reorderBanners(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _banners.removeAt(oldIndex);
      _banners.insert(newIndex, item);

      // تحديث الترتيب
      for (int i = 0; i < _banners.length; i++) {
        _banners[i]['position'] = i + 1;
      }
    });

    // إرسال الترتيب الجديد للخادم
    try {
      ApiService.reorderBanners(
        _banners.map((b) => b['id'] as String).toList(),
      );
    } catch (e) {
      // تم التحديث محلياً
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'غير محدد';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('إدارة البانرات'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadBanners),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addBanner,
        backgroundColor: MbuyColors.primaryIndigo,
        icon: const Icon(Icons.add),
        label: Text('إضافة بانر', style: GoogleFonts.cairo()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: MbuyColors.error),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: GoogleFonts.cairo(color: MbuyColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadBanners,
                    child: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
                  ),
                ],
              ),
            )
          : _banners.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: MbuyColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد بانرات',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: MbuyColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'أضف بانرات لجذب انتباه العملاء',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: MbuyColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _addBanner,
                    icon: const Icon(Icons.add),
                    label: Text('إضافة بانر', style: GoogleFonts.cairo()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MbuyColors.primaryIndigo,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // إحصائيات
                _buildStats(),
                // نصيحة
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MbuyColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: MbuyColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: MbuyColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'اسحب البانرات لإعادة ترتيبها',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: MbuyColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // قائمة البانرات
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: _banners.length,
                    onReorder: _reorderBanners,
                    itemBuilder: (context, index) {
                      return _buildBannerCard(
                        _banners[index],
                        key: ValueKey(_banners[index]['id']),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStats() {
    final activeBanners = _banners.where((b) => b['is_active'] == true).length;
    final totalViews = _banners.fold<int>(
      0,
      (sum, b) => sum + ((b['views'] as num?)?.toInt() ?? 0),
    );
    final totalClicks = _banners.fold<int>(
      0,
      (sum, b) => sum + ((b['clicks'] as num?)?.toInt() ?? 0),
    );
    final ctr = totalViews > 0
        ? (totalClicks / totalViews * 100).toStringAsFixed(1)
        : '0.0';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: MbuyColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildStatItem('البانرات', '${_banners.length}', Icons.image),
          _buildStatItem('النشطة', '$activeBanners', Icons.check_circle),
          _buildStatItem(
            'المشاهدات',
            _formatNumber(totalViews),
            Icons.visibility,
          ),
          _buildStatItem('النقرات', '$ctr%', Icons.touch_app),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.cairo(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildBannerCard(Map<String, dynamic> banner, {Key? key}) {
    final isActive = banner['is_active'] as bool? ?? false;
    final views = (banner['views'] as num?)?.toInt() ?? 0;
    final clicks = (banner['clicks'] as num?)?.toInt() ?? 0;
    final ctr = views > 0 ? (clicks / views * 100).toStringAsFixed(1) : '0.0';

    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة البانر
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    banner['image_url'] as String? ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: MbuyColors.background,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: MbuyColors.textTertiary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Badge الحالة
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? MbuyColors.success
                        : MbuyColors.textTertiary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isActive ? 'نشط' : 'متوقف',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // ترتيب البانر
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      '${banner['position'] ?? 0}',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // مقبض السحب
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.drag_handle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          // معلومات البانر
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner['title'] as String? ?? 'بدون عنوان',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MbuyColors.textPrimary,
                  ),
                ),
                if (banner['subtitle'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    banner['subtitle'] as String,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: MbuyColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                // إحصائيات البانر
                Row(
                  children: [
                    _buildMiniStat(Icons.visibility, '$views مشاهدة'),
                    const SizedBox(width: 16),
                    _buildMiniStat(Icons.touch_app, '$clicks نقرة'),
                    const SizedBox(width: 16),
                    _buildMiniStat(Icons.percent, '$ctr% CTR'),
                  ],
                ),
                // تواريخ العرض
                if (banner['start_date'] != null ||
                    banner['end_date'] != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: MbuyColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatDate(banner['start_date'] as String?)} - ${_formatDate(banner['end_date'] as String?)}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: MbuyColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                // أزرار الإجراءات
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _toggleBannerStatus(banner),
                        icon: Icon(
                          isActive ? Icons.pause : Icons.play_arrow,
                          size: 18,
                        ),
                        label: Text(
                          isActive ? 'إيقاف' : 'تفعيل',
                          style: GoogleFonts.cairo(),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isActive
                              ? MbuyColors.warning
                              : MbuyColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editBanner(banner),
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text('تعديل', style: GoogleFonts.cairo()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: MbuyColors.primaryIndigo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _deleteBanner(banner),
                      icon: const Icon(Icons.delete_outline),
                      color: MbuyColors.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: MbuyColors.textTertiary),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: MbuyColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// شاشة إضافة/تعديل بانر
class _AddBannerSheet extends StatefulWidget {
  final Map<String, dynamic>? banner;

  const _AddBannerSheet({this.banner});

  @override
  State<_AddBannerSheet> createState() => _AddBannerSheetState();
}

class _AddBannerSheetState extends State<_AddBannerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _linkType = 'none';
  String? _linkId;
  bool _isActive = true;
  DateTime? _startDate;
  DateTime? _endDate;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.banner != null) {
      _titleController.text = widget.banner!['title'] as String? ?? '';
      _subtitleController.text = widget.banner!['subtitle'] as String? ?? '';
      _imageUrlController.text = widget.banner!['image_url'] as String? ?? '';
      _linkType = widget.banner!['link_type'] as String? ?? 'none';
      _linkId = widget.banner!['link_id'] as String?;
      _isActive = widget.banner!['is_active'] as bool? ?? true;
      if (widget.banner!['start_date'] != null) {
        _startDate = DateTime.tryParse(widget.banner!['start_date'] as String);
      }
      if (widget.banner!['end_date'] != null) {
        _endDate = DateTime.tryParse(widget.banner!['end_date'] as String);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageUrlController.text = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(bool isStart) async {
    final initialDate = isStart ? _startDate : _endDate;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'title': _titleController.text,
        'subtitle': _subtitleController.text.isEmpty
            ? null
            : _subtitleController.text,
        'image_url': _imageUrlController.text,
        'link_type': _linkType,
        'link_id': _linkId,
        'is_active': _isActive,
        'start_date': _startDate?.toIso8601String(),
        'end_date': _endDate?.toIso8601String(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MbuyColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    widget.banner != null ? 'تعديل البانر' : 'إضافة بانر جديد',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // صورة البانر
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MbuyColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MbuyColors.border),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : _imageUrlController.text.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder();
                            },
                          ),
                        )
                      : _buildImagePlaceholder(),
                ),
              ),
              const SizedBox(height: 16),

              // URL الصورة (اختياري)
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'رابط الصورة (اختياري)',
                  labelStyle: GoogleFonts.cairo(),
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: GoogleFonts.cairo(),
              ),
              const SizedBox(height: 16),

              // العنوان
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'العنوان',
                  labelStyle: GoogleFonts.cairo(),
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: GoogleFonts.cairo(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'العنوان مطلوب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // العنوان الفرعي
              TextFormField(
                controller: _subtitleController,
                decoration: InputDecoration(
                  labelText: 'العنوان الفرعي (اختياري)',
                  labelStyle: GoogleFonts.cairo(),
                  prefixIcon: const Icon(Icons.subtitles),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: GoogleFonts.cairo(),
              ),
              const SizedBox(height: 16),

              // نوع الرابط
              DropdownButtonFormField<String>(
                initialValue: _linkType,
                decoration: InputDecoration(
                  labelText: 'الرابط عند النقر',
                  labelStyle: GoogleFonts.cairo(),
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'none',
                    child: Text('بدون رابط', style: GoogleFonts.cairo()),
                  ),
                  DropdownMenuItem(
                    value: 'category',
                    child: Text('فئة', style: GoogleFonts.cairo()),
                  ),
                  DropdownMenuItem(
                    value: 'product',
                    child: Text('منتج', style: GoogleFonts.cairo()),
                  ),
                  DropdownMenuItem(
                    value: 'collection',
                    child: Text('مجموعة', style: GoogleFonts.cairo()),
                  ),
                  DropdownMenuItem(
                    value: 'url',
                    child: Text('رابط خارجي', style: GoogleFonts.cairo()),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _linkType = value ?? 'none';
                    _linkId = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // تواريخ العرض
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: MbuyColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: MbuyColors.textTertiary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _startDate != null
                                  ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                  : 'تاريخ البداية',
                              style: GoogleFonts.cairo(
                                color: _startDate != null
                                    ? MbuyColors.textPrimary
                                    : MbuyColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: MbuyColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: MbuyColors.textTertiary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _endDate != null
                                  ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                  : 'تاريخ النهاية',
                              style: GoogleFonts.cairo(
                                color: _endDate != null
                                    ? MbuyColors.textPrimary
                                    : MbuyColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // تفعيل البانر
              SwitchListTile(
                title: Text('تفعيل البانر', style: GoogleFonts.cairo()),
                subtitle: Text(
                  _isActive ? 'البانر سيظهر للعملاء' : 'البانر مخفي',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: MbuyColors.textTertiary,
                  ),
                ),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
                activeTrackColor: MbuyColors.primaryIndigo.withValues(
                  alpha: 0.5,
                ),
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return MbuyColors.primaryIndigo;
                  }
                  return null;
                }),
              ),
              const SizedBox(height: 24),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MbuyColors.primaryIndigo,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.banner != null ? 'حفظ التغييرات' : 'إضافة البانر',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.add_photo_alternate,
          size: 48,
          color: MbuyColors.textTertiary,
        ),
        const SizedBox(height: 8),
        Text(
          'انقر لاختيار صورة',
          style: GoogleFonts.cairo(color: MbuyColors.textTertiary),
        ),
      ],
    );
  }
}
