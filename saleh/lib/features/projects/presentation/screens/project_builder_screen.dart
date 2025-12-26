import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/revenue_api_client.dart';
import '../../data/revenue_models.dart';

/// صفحة إنشاء مشروع جديد (Builder Flow)
/// جميع الأسعار تأتي من Worker - Flutter لا يحسب شيء
class ProjectBuilderScreen extends ConsumerStatefulWidget {
  final String projectTypeName;

  const ProjectBuilderScreen({super.key, required this.projectTypeName});

  @override
  ConsumerState<ProjectBuilderScreen> createState() =>
      _ProjectBuilderScreenState();
}

class _ProjectBuilderScreenState extends ConsumerState<ProjectBuilderScreen> {
  late ProjectType _projectType;
  int _currentStep = 0;

  // الاختيارات
  ProjectTemplate? _selectedTemplate;
  ProductionQuality _selectedQuality = ProductionQuality.standard;
  VideoDuration? _selectedDuration;
  VoiceType _selectedVoice = VoiceType.none;
  RevisionPolicy _selectedRevision = RevisionPolicy.basic;

  final _nameController = TextEditingController();

  // السعر من API
  PricingQuote? _currentQuote;
  bool _isLoadingQuote = false;
  String? _quoteError;

  // إنشاء المشروع
  bool _isCreatingProject = false;

  @override
  void initState() {
    super.initState();
    _projectType = ProjectType.values.firstWhere(
      (t) =>
          t.value == widget.projectTypeName || t.name == widget.projectTypeName,
      orElse: () => ProjectType.motionGraphics,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  int get _totalSteps {
    if (_projectType == ProjectType.brandIdentity ||
        _projectType == ProjectType.fullCampaign) {
      return 5;
    }
    return 7;
  }

  bool get _hasDuration =>
      _projectType == ProjectType.motionGraphics ||
      _projectType == ProjectType.ugcVideo;

  bool get _hasVoice =>
      _projectType == ProjectType.motionGraphics ||
      _projectType == ProjectType.ugcVideo;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final templatesAsync = ref.watch(templatesByTypeProvider(_projectType));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _projectType.color,
        title: Text(
          'مشروع ${_projectType.displayNameAr}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _confirmExit(),
        ),
      ),
      body: Column(
        children: [
          _buildProgressBar(isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: templatesAsync.when(
                data: (templates) => _buildCurrentStep(templates, isDark),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('خطأ: $e')),
              ),
            ),
          ),
          _buildNavigationButtons(isDark),
        ],
      ),
    );
  }

  Widget _buildProgressBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDark ? const Color(0xFF1E293B) : Colors.grey[50],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الخطوة ${_currentStep + 1} من $_totalSteps',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _projectType.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(_projectType.color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(List<ProjectTemplate> templates, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildTemplateStep(templates, isDark);
      case 1:
        return _buildQualityStep(isDark);
      case 2:
        if (_hasDuration) return _buildDurationStep(isDark);
        return _buildRevisionStep(isDark);
      case 3:
        if (_hasDuration && _hasVoice) return _buildVoiceStep(isDark);
        if (_hasDuration) return _buildRevisionStep(isDark);
        return _buildNameStep(isDark);
      case 4:
        if (_hasDuration && _hasVoice) return _buildRevisionStep(isDark);
        if (_hasDuration || _hasVoice) return _buildNameStep(isDark);
        return _buildSummaryStep(isDark);
      case 5:
        if (_hasDuration && _hasVoice) return _buildNameStep(isDark);
        return _buildSummaryStep(isDark);
      case 6:
        return _buildSummaryStep(isDark);
      default:
        return const SizedBox();
    }
  }

  // ============================================================
  // الخطوة 1: اختيار القالب
  // ============================================================

  Widget _buildTemplateStep(List<ProjectTemplate> templates, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('اختر القالب', 'اختر القالب المناسب لمشروعك', isDark),
        const SizedBox(height: 20),
        if (templates.isEmpty)
          Center(
            child: Text(
              'لا توجد قوالب متاحة',
              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
            ),
          )
        else
          ...templates.map((t) => _buildTemplateCard(t, isDark)),
      ],
    );
  }

  Widget _buildTemplateCard(ProjectTemplate template, bool isDark) {
    final isSelected = _selectedTemplate?.id == template.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : (isDark ? 0 : 1),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? _projectType.color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedTemplate = template;
            if (template.supportedDurations.isNotEmpty) {
              _selectedDuration = VideoDuration.fromString(
                template.supportedDurations.first,
              );
            }
          });
          _fetchPricingQuote();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? _projectType.color : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected ? _projectType.color : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.nameAr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template.descriptionAr,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${template.basePriceSar} ر.س',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _projectType.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // الخطوة 2: اختيار الجودة
  // ============================================================

  Widget _buildQualityStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'اختر الجودة',
          'جودة الإنتاج تؤثر على النتيجة النهائية',
          isDark,
        ),
        const SizedBox(height: 20),
        ...ProductionQuality.values.map((q) => _buildQualityCard(q, isDark)),
      ],
    );
  }

  Widget _buildQualityCard(ProductionQuality quality, bool isDark) {
    final isSelected = _selectedQuality == quality;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : (isDark ? 0 : 1),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? _projectType.color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedQuality = quality);
          _fetchPricingQuote();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? _projectType.color : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected ? _projectType.color : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                quality.displayNameAr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // الخطوة 3: اختيار المدة
  // ============================================================

  Widget _buildDurationStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('اختر المدة', 'مدة الفيديو بالثواني', isDark),
        const SizedBox(height: 20),
        ...VideoDuration.values.map((d) => _buildDurationCard(d, isDark)),
      ],
    );
  }

  Widget _buildDurationCard(VideoDuration duration, bool isDark) {
    final isSelected = _selectedDuration == duration;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : (isDark ? 0 : 1),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? _projectType.color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedDuration = duration);
          _fetchPricingQuote();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? _projectType.color : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected ? _projectType.color : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                duration.displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // الخطوة 4: اختيار الصوت
  // ============================================================

  Widget _buildVoiceStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('اختر الصوت', 'نوع الصوت أو التعليق', isDark),
        const SizedBox(height: 20),
        ...VoiceType.values.map((v) => _buildVoiceCard(v, isDark)),
      ],
    );
  }

  Widget _buildVoiceCard(VoiceType voice, bool isDark) {
    final isSelected = _selectedVoice == voice;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : (isDark ? 0 : 1),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? _projectType.color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedVoice = voice);
          _fetchPricingQuote();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? _projectType.color : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected ? _projectType.color : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                voice.displayNameAr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // الخطوة 5: سياسة التعديلات
  // ============================================================

  Widget _buildRevisionStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('سياسة التعديلات', 'عدد التعديلات المجانية', isDark),
        const SizedBox(height: 20),
        ...RevisionPolicy.values.map((r) => _buildRevisionCard(r, isDark)),
      ],
    );
  }

  Widget _buildRevisionCard(RevisionPolicy revision, bool isDark) {
    final isSelected = _selectedRevision == revision;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : (isDark ? 0 : 1),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? _projectType.color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedRevision = revision);
          _fetchPricingQuote();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? _projectType.color : Colors.grey,
                        width: 2,
                      ),
                      color: isSelected
                          ? _projectType.color
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    revision.displayNameAr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    revision.freeRevisions == -1
                        ? 'غير محدود'
                        : '${revision.freeRevisions} تعديلات',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // الخطوة 6: اسم المشروع
  // ============================================================

  Widget _buildNameStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('اسم المشروع', 'أدخل اسماً مميزاً لمشروعك', isDark),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'اسم المشروع',
            hintText: 'مثال: إعلان المنتج الجديد',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.edit),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  // ============================================================
  // الخطوة 7: الملخص - السعر من API
  // ============================================================

  Widget _buildSummaryStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'ملخص الطلب',
          'راجع تفاصيل مشروعك قبل التأكيد',
          isDark,
        ),
        const SizedBox(height: 20),

        // تفاصيل المشروع
        Card(
          elevation: isDark ? 0 : 2,
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow('النوع', _projectType.displayNameAr, isDark),
                _buildSummaryRow(
                  'القالب',
                  _selectedTemplate?.nameAr ?? '-',
                  isDark,
                ),
                _buildSummaryRow(
                  'الجودة',
                  _selectedQuality.displayNameAr,
                  isDark,
                ),
                if (_hasDuration)
                  _buildSummaryRow(
                    'المدة',
                    _selectedDuration?.displayName ?? '-',
                    isDark,
                  ),
                if (_hasVoice)
                  _buildSummaryRow(
                    'الصوت',
                    _selectedVoice.displayNameAr,
                    isDark,
                  ),
                _buildSummaryRow(
                  'التعديلات',
                  _selectedRevision.displayNameAr,
                  isDark,
                ),
                const Divider(height: 24),

                // السعر من API
                if (_isLoadingQuote)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                else if (_quoteError != null)
                  Text(_quoteError!, style: const TextStyle(color: Colors.red))
                else if (_currentQuote != null) ...[
                  // تفاصيل السعر من API
                  ...(_currentQuote!.breakdown.map(
                    (item) => _buildSummaryRow(
                      item.labelAr,
                      '${item.amount} ر.س',
                      isDark,
                    ),
                  )),
                  const Divider(height: 16),
                  _buildSummaryRow(
                    'الإجمالي',
                    _currentQuote!.formattedPrice,
                    isDark,
                    isTotal: true,
                  ),
                  if (_currentQuote!.isCashOnly)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: Colors.green,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'دفع نقدي فقط',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // التحذيرات من API
        if (_currentQuote != null && _currentQuote!.warnings.isNotEmpty) ...[
          ...(_currentQuote!.warnings.map(
            (warning) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      warning,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],

        // تحذير القفل
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'بعد الاعتماد النهائي سيتم قفل المشروع',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal
                  ? _projectType.color
                  : (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Helpers
  // ============================================================

  Widget _buildStepHeader(String title, String subtitle, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// جلب التسعير من API
  Future<void> _fetchPricingQuote() async {
    if (_selectedTemplate == null) return;

    setState(() {
      _isLoadingQuote = true;
      _quoteError = null;
    });

    try {
      final client = ref.read(revenueApiClientProvider);
      final quote = await client.getPricingQuote(
        PricingQuoteRequest(
          projectType: _projectType,
          templateId: _selectedTemplate!.id,
          duration: _hasDuration ? _selectedDuration : null,
          quality: _selectedQuality,
          voiceType: _selectedVoice,
          revisionPolicy: _selectedRevision,
        ),
      );

      if (mounted) {
        setState(() {
          _currentQuote = quote;
          _isLoadingQuote = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _quoteError = 'فشل في جلب السعر: $e';
          _isLoadingQuote = false;
        });
      }
    }
  }

  Widget _buildNavigationButtons(bool isDark) {
    final isLastStep = _currentStep == _totalSteps - 1;
    final canProceed = _canProceed();

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() => _currentStep--);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: _projectType.color),
                ),
                child: Text(
                  'السابق',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _projectType.color,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canProceed && !_isCreatingProject
                  ? () {
                      HapticFeedback.mediumImpact();
                      if (isLastStep) {
                        _submitProject();
                      } else {
                        setState(() => _currentStep++);
                        // جلب السعر عند الوصول للملخص
                        if (_currentStep == _totalSteps - 1) {
                          _fetchPricingQuote();
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _projectType.color,
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isCreatingProject
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isLastStep ? 'تأكيد الطلب' : 'التالي',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedTemplate != null;
      case 1:
        return true;
      case 2:
        if (_hasDuration) return _selectedDuration != null;
        return true;
      case 3:
        return true;
      case 4:
        return true;
      case 5:
        if (_hasDuration && _hasVoice) {
          return _nameController.text.trim().isNotEmpty;
        }
        return true;
      case 6:
        return _nameController.text.trim().isNotEmpty && _currentQuote != null;
      default:
        return true;
    }
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: const Text('هل تريد إلغاء إنشاء المشروع؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لا'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('نعم', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// إنشاء المشروع عبر API
  Future<void> _submitProject() async {
    if (_selectedTemplate == null) return;

    setState(() => _isCreatingProject = true);

    try {
      final client = ref.read(revenueApiClientProvider);
      final response = await client.createProject(
        CreateProjectRequest(
          projectType: _projectType,
          templateId: _selectedTemplate!.id,
          name: _nameController.text.trim().isEmpty
              ? '${_projectType.displayNameAr} جديد'
              : _nameController.text.trim(),
          duration: _hasDuration ? _selectedDuration : null,
          quality: _selectedQuality,
          voiceType: _selectedVoice,
          revisionPolicy: _selectedRevision,
        ),
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        // عرض التحذيرات إن وجدت
        if (response.warnings.isNotEmpty) {
          for (final warning in response.warnings) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(warning), backgroundColor: Colors.orange),
            );
          }
        }
        // الانتقال لصفحة التفاصيل
        context.go('/dashboard/projects/view/${response.data!.id}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'فشل في إنشاء المشروع'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingProject = false);
      }
    }
  }
}
