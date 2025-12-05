import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/services/gemini_service.dart';

/// شاشة ترجمة نصوص
class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  String? _translation;
  bool _isLoading = false;
  String _targetLanguage = 'English';

  final Map<String, String> _languages = {
    'English': 'الإنجليزية',
    'French': 'الفرنسية',
    'Spanish': 'الإسبانية',
    'German': 'الألمانية',
    'Turkish': 'التركية',
    'Urdu': 'الأردية',
    'Hindi': 'الهندية',
    'Chinese': 'الصينية',
    'Japanese': 'اليابانية',
    'Korean': 'الكورية',
  };

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _translation = null;
    });

    try {
      final result = await GeminiService.translateText(
        text: _textController.text,
        targetLanguage: _targetLanguage,
      );

      setState(() {
        _translation = result;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_translation != null) {
      Clipboard.setData(ClipboardData(text: _translation!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ الترجمة'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _swapTexts() {
    if (_translation != null) {
      _textController.text = _translation!;
      setState(() {
        _translation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ترجمة النصوص',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF14B8A6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة معلومات
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.translate, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المترجم الذكي',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'ترجم أوصاف المنتجات ونصوص التسويق لأي لغة',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // النص الأصلي
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF14B8A6,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '🇸🇦 العربية',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF14B8A6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _textController,
                      maxLines: 5,
                      validator: (value) =>
                          value?.isEmpty == true ? 'أدخل النص للترجمة' : null,
                      decoration: InputDecoration(
                        hintText: 'أدخل النص الذي تريد ترجمته...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0FDFA),
                        hintStyle: GoogleFonts.cairo(color: Colors.grey),
                      ),
                      style: GoogleFonts.cairo(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // زر التبديل
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF14B8A6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _swapTexts,
                    icon: const Icon(Icons.swap_vert, color: Colors.white),
                    tooltip: 'تبديل',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // اللغة الهدف
              Text(
                'ترجم إلى:',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _languages.entries.map((entry) {
                  final isSelected = entry.key == _targetLanguage;
                  return ChoiceChip(
                    label: Text(
                      entry.value,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF14B8A6),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF14B8A6),
                    backgroundColor: const Color(0xFFF0FDFA),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _targetLanguage = entry.key;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // زر الترجمة
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _translate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.translate, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'ترجمة',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // النتيجة
              if (_translation != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF99F6E4)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF14B8A6).withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF14B8A6,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_languages[_targetLanguage]}',
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF14B8A6),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _copyToClipboard,
                            icon: const Icon(
                              Icons.copy,
                              color: Color(0xFF14B8A6),
                            ),
                            tooltip: 'نسخ',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        _translation!,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          height: 1.8,
                          color: const Color(0xFF4B5563),
                        ),
                        textDirection:
                            _targetLanguage == 'English' ||
                                _targetLanguage == 'French' ||
                                _targetLanguage == 'Spanish' ||
                                _targetLanguage == 'German'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
