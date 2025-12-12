import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/mbuy_studio_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../merchant/data/merchant_store_provider.dart';

class MbuyStudioScreen extends ConsumerStatefulWidget {
  const MbuyStudioScreen({super.key});

  @override
  ConsumerState<MbuyStudioScreen> createState() => _MbuyStudioScreenState();
}

class _MbuyStudioScreenState extends ConsumerState<MbuyStudioScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  String _statusMessage = '';
  String? _generatedImageUrl;
  int _currentBannerPage = 0;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header بدلاً من AppBar
              _buildHeader(context),
              const SizedBox(height: AppDimensions.spacing16),
              _buildHeroBanner(),
              const SizedBox(height: AppDimensions.spacing24),
              _buildMainCategories(),
              const SizedBox(height: AppDimensions.spacing24),
              _buildSectionTitle('تطبيقات سريعة'),
              const SizedBox(height: AppDimensions.spacing12),
              _buildQuickApps(),
              const SizedBox(height: AppDimensions.spacing24),
              _buildSectionTitle('نموذج ثلاثي الأبعاد'),
              const SizedBox(height: AppDimensions.spacing12),
              _build3DModels(),
              const SizedBox(height: AppDimensions.spacing32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() => _currentBannerPage = index);
            },
            itemCount: 3,
            itemBuilder: (context, index) => _buildBannerCard(),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = _currentBannerPage == index;
            return AnimatedContainer(
              duration: AppDimensions.animationFast,
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing4,
              ),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: AppDimensions.borderRadiusXS,
                color: isActive ? AppTheme.accentColor : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      child: Row(
        children: [
          // زر الرجوع
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          // العنوان
          const Text(
            'MBUY Studio',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          // رصيد AI
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing10,
              vertical: AppDimensions.spacing6,
            ),
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              borderRadius: AppDimensions.borderRadiusL,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '8',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontBody,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing4),
                Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: AppDimensions.iconXS,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      margin: AppDimensions.screenPaddingHorizontalOnly,
      decoration: BoxDecoration(
        borderRadius: AppDimensions.borderRadiusL,
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentColor.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 50,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.infoColor.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: AppDimensions.screenPadding,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'تتضمن 16+ نموذج صور وفيديو',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontTitle,
                          fontWeight: FontWeight.w600,
                          height: AppDimensions.lineHeightNormal,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: AppDimensions.spacing16),
                      ElevatedButton(
                        onPressed: () => _showGenerateDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing24,
                            vertical: AppDimensions.spacing10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDimensions.borderRadiusXL,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'إنشاء',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.fontBody,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing16),
                _buildAppIconsGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIconsGrid() {
    return SizedBox(
      width: 100,
      child: Wrap(
        spacing: AppDimensions.spacing8,
        runSpacing: AppDimensions.spacing8,
        alignment: WrapAlignment.end,
        children: [
          _buildAppIcon(Icons.auto_awesome, AppTheme.accentColor),
          _buildAppIcon(Icons.palette, AppTheme.successColor),
          _buildAppIcon(Icons.camera_alt, AppTheme.infoColor),
          _buildAppIcon(Icons.movie, AppTheme.warningColor),
        ],
      ),
    );
  }

  Widget _buildAppIcon(IconData icon, Color color) {
    return Container(
      width: AppDimensions.buttonHeightM,
      height: AppDimensions.buttonHeightM,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: AppDimensions.iconM, color: color),
    );
  }

  Widget _buildMainCategories() {
    final categories = [
      _CategoryItem(
        title: 'توليد الصور',
        taskType: 'ai_image',
        icon: Icons.image_outlined,
        color: AppTheme.infoColor,
      ),
      _CategoryItem(
        title: 'توليد الفيديو',
        taskType: 'video_promo',
        icon: Icons.play_circle_outline,
        color: AppTheme.accentColor,
      ),
      _CategoryItem(
        title: 'توليد فوري',
        taskType: 'image_instant',
        icon: Icons.flash_on_outlined,
        color: AppTheme.successColor,
      ),
    ];

    return Padding(
      padding: AppDimensions.screenPaddingHorizontalOnly,
      child: Row(
        children: categories.map((cat) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing4,
              ),
              child: _buildCategoryCard(cat),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryCard(_CategoryItem category) {
    return Material(
      color: AppTheme.surfaceColor,
      borderRadius: AppDimensions.borderRadiusM,
      child: InkWell(
        onTap: () => _showGenerateDialog(taskType: category.taskType),
        borderRadius: AppDimensions.borderRadiusM,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusM,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: AppDimensions.borderRadiusM,
                ),
                child: Center(
                  child: Icon(
                    category.icon,
                    size: AppDimensions.iconXL,
                    color: category.color,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: AppDimensions.fontBody2,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: AppDimensions.screenPaddingHorizontalOnly,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('عرض جميع $title'),
                  backgroundColor: AppTheme.primaryColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'عرض الكل',
              style: TextStyle(
                fontSize: AppDimensions.fontBody2,
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppDimensions.fontHeadline,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickApps() {
    final apps = [
      _QuickAppItem(
        title: 'التحسين الجماعي',
        taskType: 'bulk_improve',
        icon: Icons.auto_awesome,
        isNew: true,
        isBulk: true,
      ),
      _QuickAppItem(
        title: 'نقل الأسلوب',
        taskType: 'style_transfer',
        icon: Icons.style_outlined,
        isNew: false,
      ),
      _QuickAppItem(
        title: 'الحفاظ على الوجه',
        taskType: 'face_preserve',
        icon: Icons.face_outlined,
        isNew: true,
      ),
      _QuickAppItem(
        title: 'إزالة العلامة المائية',
        taskType: 'remove_watermark',
        icon: Icons.layers_clear_outlined,
        isNew: true,
      ),
      _QuickAppItem(
        title: 'تحسين الصورة',
        taskType: 'enhance_image',
        icon: Icons.auto_fix_high,
        isNew: false,
      ),
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppDimensions.screenPaddingHorizontalOnly,
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return _buildQuickAppCard(app);
        },
      ),
    );
  }

  Widget _buildQuickAppCard(_QuickAppItem app) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(left: AppDimensions.spacing12),
      child: Material(
        color: AppTheme.surfaceColor,
        borderRadius: AppDimensions.borderRadiusM,
        child: InkWell(
          onTap: () {
            if (app.isBulk) {
              _showBulkImproveDialog();
            } else {
              _showGenerateDialog(taskType: app.taskType);
            }
          },
          borderRadius: AppDimensions.borderRadiusM,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppDimensions.borderRadiusM,
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.06),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppDimensions.radiusM),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            app.icon,
                            size: AppDimensions.iconHero,
                            color: AppTheme.primaryColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacing10),
                      child: Text(
                        app.title,
                        style: const TextStyle(
                          fontSize: AppDimensions.fontLabel,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (app.isNew)
                  Positioned(
                    top: AppDimensions.spacing8,
                    left: AppDimensions.spacing8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing8,
                        vertical: AppDimensions.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: AppDimensions.borderRadiusXS,
                      ),
                      child: const Text(
                        'جديد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontCaption,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _build3DModels() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppDimensions.screenPaddingHorizontalOnly,
        itemCount: 4,
        itemBuilder: (context, index) {
          return _build3DModelCard();
        },
      ),
    );
  }

  Widget _build3DModelCard() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: AppDimensions.spacing12),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppDimensions.borderRadiusM,
        child: InkWell(
          onTap: () => _showGenerateDialog(taskType: '3d_model'),
          borderRadius: AppDimensions.borderRadiusM,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppDimensions.borderRadiusM,
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.view_in_ar,
                    size: AppDimensions.iconDisplay,
                    color: Colors.cyan.withValues(alpha: 0.5),
                  ),
                ),
                Positioned(
                  bottom: AppDimensions.spacing12,
                  left: AppDimensions.spacing12,
                  right: AppDimensions.spacing12,
                  child: const Text(
                    'نموذج 3D',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimensions.fontBody2,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGenerateDialog({String taskType = 'ai_image'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.bottomSheetRadius),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: AppDimensions.spacing20,
          right: AppDimensions.spacing20,
          top: AppDimensions.spacing20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: AppDimensions.spacing40,
              height: AppDimensions.spacing4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: AppDimensions.borderRadiusXS,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing20),
            // Title
            const Text(
              'توليد محتوى إبداعي',
              style: TextStyle(
                fontSize: AppDimensions.fontDisplay3,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing20),
            // Input
            TextField(
              controller: _promptController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'اكتب وصف الصورة أو الفيديو...',
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyle(
                  color: AppTheme.textHintColor,
                  fontSize: AppDimensions.fontBody,
                ),
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                  borderSide: BorderSide.none,
                ),
                contentPadding: AppDimensions.screenPadding,
              ),
              maxLines: 3,
              style: const TextStyle(
                fontSize: AppDimensions.fontBody,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing20),
            // Status & Result
            if (_isGenerating) ...[
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              Text(
                _statusMessage,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: AppDimensions.fontBody,
                ),
              ),
            ] else if (_generatedImageUrl != null) ...[
              ClipRRect(
                borderRadius: AppDimensions.borderRadiusM,
                child: Image.network(
                  _generatedImageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              Text(
                _statusMessage,
                style: const TextStyle(
                  color: AppTheme.successColor,
                  fontSize: AppDimensions.fontBody,
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightXL,
                child: ElevatedButton(
                  onPressed: () => _startCloudflareGeneration(taskType),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDimensions.borderRadiusM,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'توليد الآن',
                    style: TextStyle(
                      fontSize: AppDimensions.fontTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.spacing24),
          ],
        ),
      ),
    );
  }

  Future<void> _startCloudflareGeneration(String taskType) async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('الرجاء كتابة وصف للمحتوى'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusS,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _statusMessage = 'جاري الإبداع...';
      _generatedImageUrl = null;
    });

    try {
      final service = ref.read(mbuyStudioServiceProvider);
      final result = await service.generateCloudflareContent(
        taskType: taskType,
        prompt: _promptController.text,
      );

      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _statusMessage = 'تم الانتهاء!';
        if (result['result'] != null && result['result']['image'] != null) {
          _generatedImageUrl = result['result']['image'];
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _statusMessage = 'حدث خطأ: $e';
      });
    }
  }

  // ============================================
  // Bulk Improve Dialog
  // ============================================
  void _showBulkImproveDialog() {
    String selectedMode = 'enhance'; // Default mode
    bool isProcessing = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('التحسين الجماعي للمنتجات'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'تحسين جميع صور منتجات متجرك تلقائياً',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  'اختر وضع التحسين:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildModeOption(
                  'تحسين الجودة',
                  'enhance',
                  selectedMode,
                  (value) => setState(() => selectedMode = value),
                  isProcessing,
                ),
                const SizedBox(height: 10),
                _buildModeOption(
                  'إزالة الخلفية',
                  'remove_bg',
                  selectedMode,
                  (value) => setState(() => selectedMode = value),
                  isProcessing,
                ),
                const SizedBox(height: 10),
                _buildModeOption(
                  'نمط استوديو',
                  'studio_style',
                  selectedMode,
                  (value) => setState(() => selectedMode = value),
                  isProcessing,
                ),
                const SizedBox(height: 20),
                if (isProcessing)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isProcessing ? null : () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() => isProcessing = true);
                      await _startBulkImprove(selectedMode);
                      if (context.mounted) {
                        setState(() => isProcessing = false);
                      }
                    },
              child: const Text('ابدأ التحسين'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
    String label,
    String value,
    String selectedMode,
    Function(String) onChanged,
    bool isProcessing,
  ) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: value,
        // ignore: deprecated_member_use
        groupValue: selectedMode,
        // ignore: deprecated_member_use
        onChanged: isProcessing ? null : (String? v) => onChanged(v ?? ''),
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
      onTap: isProcessing ? null : () => onChanged(value),
    );
  }

  Future<void> _startBulkImprove(String mode) async {
    try {
      // Get store ID
      final store = ref.read(merchantStoreProvider);
      if (store == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لم يتم العثور على المتجر'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Call API
      final response = await ref
          .read(apiServiceProvider)
          .post(
            '/secure/studio/bulk-improve',
            body: {'store_id': store.id, 'mode': mode},
          );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['ok'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'تم بدء التحسين'),
              backgroundColor: Colors.green,
            ),
          );
          // Wait a bit then close
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['error'] ?? 'حدث خطأ'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

// Helper classes
class _CategoryItem {
  final String title;
  final String taskType;
  final IconData icon;
  final Color color;

  const _CategoryItem({
    required this.title,
    required this.taskType,
    required this.icon,
    required this.color,
  });
}

class _QuickAppItem {
  final String title;
  final String taskType;
  final IconData icon;
  final bool isNew;
  final bool isBulk;

  const _QuickAppItem({
    required this.title,
    required this.taskType,
    required this.icon,
    required this.isNew,
    this.isBulk = false,
  });
}
