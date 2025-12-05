import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/services/gemini_service.dart';

/// شاشة اقتراح كلمات مفتاحية
class KeywordsScreen extends StatefulWidget {
  const KeywordsScreen({super.key});

  @override
  State<KeywordsScreen> createState() => _KeywordsScreenState();
}

class _KeywordsScreenState extends State<KeywordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<String> _keywords = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _productController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _generateKeywords() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _keywords = [];
    });

    try {
      final keywords = await GeminiService.generateKeywords(
        productName: _productController.text,
        description: _descriptionController.text,
      );

      setState(() {
        _keywords = keywords;
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

  void _copyKeyword(String keyword) {
    Clipboard.setData(ClipboardData(text: keyword));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ: $keyword'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _copyAllKeywords() {
    if (_keywords.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _keywords.join(', ')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ جميع الكلمات'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'اقتراح كلمات مفتاحية',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEC4899),
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
                    colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.key, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مولد الكلمات المفتاحية',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'احصل على كلمات SEO لتحسين ظهور منتجك',
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

              // اسم المنتج
              TextFormField(
                controller: _productController,
                validator: (value) =>
                    value?.isEmpty == true ? 'أدخل اسم المنتج' : null,
                decoration: InputDecoration(
                  labelText: 'اسم المنتج',
                  hintText: 'مثال: ساعة ذكية رياضية',
                  prefixIcon: const Icon(
                    Icons.shopping_bag,
                    color: Color(0xFFEC4899),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFEC4899),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: GoogleFonts.cairo(),
                  hintStyle: GoogleFonts.cairo(color: Colors.grey),
                ),
                style: GoogleFonts.cairo(),
              ),
              const SizedBox(height: 16),

              // وصف المنتج
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'وصف المنتج (اختياري)',
                  hintText: 'أضف وصفاً للمنتج للحصول على كلمات أكثر دقة',
                  prefixIcon: const Icon(
                    Icons.description,
                    color: Color(0xFFEC4899),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFEC4899),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: GoogleFonts.cairo(),
                  hintStyle: GoogleFonts.cairo(color: Colors.grey),
                ),
                style: GoogleFonts.cairo(),
              ),
              const SizedBox(height: 24),

              // زر التوليد
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _generateKeywords,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC4899),
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
                              'توليد الكلمات المفتاحية',
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
              if (_keywords.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
                          Text(
                            'الكلمات المفتاحية (${_keywords.length})',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _copyAllKeywords,
                            icon: const Icon(Icons.copy_all, size: 18),
                            label: Text('نسخ الكل', style: GoogleFonts.cairo()),
                          ),
                        ],
                      ),
                      const Divider(),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _keywords.map((keyword) {
                          return ActionChip(
                            label: Text(
                              keyword,
                              style: GoogleFonts.cairo(
                                color: const Color(0xFFEC4899),
                              ),
                            ),
                            backgroundColor: const Color(0xFFFCE7F3),
                            side: const BorderSide(color: Color(0xFFFBCFE8)),
                            onPressed: () => _copyKeyword(keyword),
                            avatar: const Icon(
                              Icons.tag,
                              size: 16,
                              color: Color(0xFFEC4899),
                            ),
                          );
                        }).toList(),
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
