import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/services/gemini_service.dart';

/// شاشة تحسين وصف منتج
class ImproveDescriptionScreen extends StatefulWidget {
  const ImproveDescriptionScreen({super.key});

  @override
  State<ImproveDescriptionScreen> createState() =>
      _ImproveDescriptionScreenState();
}

class _ImproveDescriptionScreenState extends State<ImproveDescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? _improvedDescription;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _improveDescription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _improvedDescription = null;
    });

    try {
      final improved = await GeminiService.improveDescription(
        originalDescription: _descriptionController.text,
      );

      setState(() {
        _improvedDescription = improved;
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
    if (_improvedDescription != null) {
      Clipboard.setData(ClipboardData(text: _improvedDescription!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ الوصف المحسّن'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _replaceOriginal() {
    if (_improvedDescription != null) {
      _descriptionController.text = _improvedDescription!;
      setState(() {
        _improvedDescription = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم استبدال الوصف الأصلي'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تحسين وصف منتج',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF06B6D4),
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
                    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'محسّن الوصف الذكي',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'حوّل وصفك العادي إلى وصف تسويقي احترافي',
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

              // الوصف الأصلي
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
                        const Icon(Icons.edit_note, color: Color(0xFF06B6D4)),
                        const SizedBox(width: 8),
                        Text(
                          'الوصف الأصلي',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0E7490),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 6,
                      validator: (value) => value?.isEmpty == true
                          ? 'أدخل الوصف الذي تريد تحسينه'
                          : null,
                      decoration: InputDecoration(
                        hintText:
                            'الصق هنا وصف المنتج الحالي الذي تريد تحسينه...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF06B6D4),
                            width: 2,
                          ),
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
              const SizedBox(height: 24),

              // زر التحسين
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _improveDescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4),
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
                            const Icon(Icons.auto_awesome, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'تحسين الوصف',
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
              if (_improvedDescription != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF99F6E4)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
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
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF06B6D4),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'الوصف المحسّن',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0E7490),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _copyToClipboard,
                                icon: const Icon(
                                  Icons.copy,
                                  color: Color(0xFF06B6D4),
                                ),
                                tooltip: 'نسخ',
                              ),
                              IconButton(
                                onPressed: _replaceOriginal,
                                icon: const Icon(
                                  Icons.swap_horiz,
                                  color: Color(0xFF06B6D4),
                                ),
                                tooltip: 'استبدال الأصلي',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        _improvedDescription!,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          height: 1.8,
                          color: const Color(0xFF4B5563),
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
    );
  }
}
