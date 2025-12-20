import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

/// شاشة توليد السيناريو
class ScriptGeneratorScreen extends ConsumerStatefulWidget {
  final StudioTemplate? template;

  const ScriptGeneratorScreen({super.key, this.template});

  @override
  ConsumerState<ScriptGeneratorScreen> createState() =>
      _ScriptGeneratorScreenState();
}

class _ScriptGeneratorScreenState extends ConsumerState<ScriptGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescController = TextEditingController();
  final _priceController = TextEditingController();
  final _featuresController = TextEditingController();

  String _selectedTone = 'professional';
  String _selectedLanguage = 'ar';
  int _selectedDuration = 30;

  ScriptData? _generatedScript;

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescController.dispose();
    _priceController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiGenerationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('توليد السيناريو'),
        actions: [
          const CreditBalanceWidget(compact: true),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // القالب المختار
                if (widget.template != null) ...[
                  _buildTemplateInfo(),
                  const SizedBox(height: 24),
                ],

                // معلومات المنتج
                _buildSectionHeader(
                  'معلومات المنتج',
                  Icons.shopping_bag_outlined,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المنتج *',
                    hintText: 'مثال: سماعة بلوتوث لاسلكية',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _productDescController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'وصف المنتج *',
                    hintText: 'اكتب وصفاً مفصلاً للمنتج...',
                    prefixIcon: Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'السعر',
                          hintText: '99.99',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: 'SAR',
                        decoration: const InputDecoration(
                          labelText: 'العملة',
                          prefixIcon: Icon(Icons.currency_exchange),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'SAR', child: Text('ريال')),
                          DropdownMenuItem(value: 'USD', child: Text('دولار')),
                          DropdownMenuItem(value: 'AED', child: Text('درهم')),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _featuresController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'المميزات الرئيسية',
                    hintText: 'مثال: صوت نقي، بطارية 20 ساعة، مقاومة للماء',
                    prefixIcon: Icon(Icons.star_outline),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),

                // إعدادات السيناريو
                _buildSectionHeader('إعدادات السيناريو', Icons.tune),
                const SizedBox(height: 12),

                // اللغة
                _buildOptionSelector(
                  label: 'اللغة',
                  value: _selectedLanguage,
                  options: const [
                    ('ar', 'العربية', '🇸🇦'),
                    ('en', 'English', '🇺🇸'),
                  ],
                  onChanged: (v) => setState(() => _selectedLanguage = v),
                ),
                const SizedBox(height: 12),

                // النبرة
                _buildOptionSelector(
                  label: 'نبرة الخطاب',
                  value: _selectedTone,
                  options: const [
                    ('professional', 'احترافي', '👔'),
                    ('friendly', 'ودي', '😊'),
                    ('exciting', 'حماسي', '🔥'),
                    ('luxury', 'فاخر', '✨'),
                  ],
                  onChanged: (v) => setState(() => _selectedTone = v),
                ),
                const SizedBox(height: 12),

                // المدة
                _buildDurationSelector(),
                const SizedBox(height: 24),

                // تكلفة التوليد
                CreditCostCard(
                  cost: 10,
                  operation: 'توليد سيناريو AI',
                  currentBalance: ref
                      .watch(userCreditsProvider)
                      .valueOrNull
                      ?.balance,
                ),
                const SizedBox(height: 24),

                // السيناريو المُولّد
                if (_generatedScript != null) ...[
                  _buildGeneratedScript(),
                  const SizedBox(height: 24),
                ],

                // زر التوليد
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: aiState.isGenerating ? null : _generateScript,
                    icon: aiState.isGenerating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(
                      aiState.isGenerating
                          ? 'جاري التوليد...'
                          : _generatedScript != null
                          ? 'إعادة التوليد'
                          : 'توليد السيناريو',
                    ),
                  ),
                ),

                if (_generatedScript != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _proceedToEditor,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('متابعة للمحرر'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: widget.template!.thumbnailUrl != null
                ? Image.network(
                    widget.template!.thumbnailUrl!,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.movie_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'القالب المختار',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  widget.template!.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تغيير'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOptionSelector({
    required String label,
    required String value,
    required List<(String, String, String)> options,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = value == opt.$1;
            return FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(opt.$3),
                  const SizedBox(width: 6),
                  Text(opt.$2),
                ],
              ),
              onSelected: (_) => onChanged(opt.$1),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('مدة الفيديو', style: Theme.of(context).textTheme.labelLarge),
            Text(
              '$_selectedDuration ثانية',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _selectedDuration.toDouble(),
          min: 15,
          max: 60,
          divisions: 9,
          label: '$_selectedDuration ثانية',
          onChanged: (v) => setState(() => _selectedDuration = v.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('15 ثانية', style: Theme.of(context).textTheme.bodySmall),
            Text('60 ثانية', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildGeneratedScript() {
    final script = _generatedScript!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'السيناريو المُولّد',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  // نسخ للحافظة
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('تم النسخ')));
                },
              ),
            ],
          ),
          const Divider(),
          Text(
            script.headline ?? '',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...script.scenes.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value.narration ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${entry.value.duration} ثانية',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Text(
            script.cta ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateScript() async {
    if (!_formKey.currentState!.validate()) return;

    final productData = ProductData(
      name: _productNameController.text,
      description: _productDescController.text,
      price: double.tryParse(_priceController.text),
      features: _featuresController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );

    try {
      final script = await ref
          .read(aiGenerationProvider.notifier)
          .generateScript(
            productData: productData,
            templateId: widget.template?.id,
            language: _selectedLanguage,
            tone: _selectedTone,
            durationSeconds: _selectedDuration,
          );

      setState(() => _generatedScript = script);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _proceedToEditor() async {
    if (_generatedScript == null) return;

    try {
      final project = await ref
          .read(projectsProvider.notifier)
          .createProject(
            name: _productNameController.text,
            templateId: widget.template?.id,
            productData: ProductData(
              name: _productNameController.text,
              description: _productDescController.text,
              price: double.tryParse(_priceController.text),
              features: _featuresController.text
                  .split(',')
                  .map((e) => e.trim())
                  .toList(),
            ),
          );

      // حفظ السيناريو في المشروع
      ref.read(currentProjectProvider.notifier).setProject(project);
      ref
          .read(currentProjectProvider.notifier)
          .setScriptData(_generatedScript!);

      Navigator.pushReplacementNamed(
        context,
        '/studio/editor',
        arguments: {'projectId': project.id, 'script': _generatedScript},
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }
}
