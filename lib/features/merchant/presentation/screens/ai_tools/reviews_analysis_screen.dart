import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/services/gemini_service.dart';

/// شاشة تحليل التقييمات
class ReviewsAnalysisScreen extends StatefulWidget {
  const ReviewsAnalysisScreen({super.key});

  @override
  State<ReviewsAnalysisScreen> createState() => _ReviewsAnalysisScreenState();
}

class _ReviewsAnalysisScreenState extends State<ReviewsAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewsController = TextEditingController();

  String? _analysis;
  bool _isLoading = false;

  @override
  void dispose() {
    _reviewsController.dispose();
    super.dispose();
  }

  Future<void> _analyzeReviews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _analysis = null;
    });

    try {
      final result = await GeminiService.analyzeReviews(
        reviews: _reviewsController.text,
      );

      setState(() {
        _analysis = result;
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
    if (_analysis != null) {
      Clipboard.setData(ClipboardData(text: _analysis!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ التحليل'),
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
          'تحليل التقييمات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFBBF24),
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
                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rate, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'محلل التقييمات الذكي',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'حلل مراجعات العملاء واستخرج الأفكار والنقاط المهمة',
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

              // التقييمات
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
                        const Icon(Icons.reviews, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 8),
                        Text(
                          'تقييمات العملاء',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'الصق هنا مجموعة من تقييمات العملاء لتحليلها',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _reviewsController,
                      maxLines: 8,
                      validator: (value) =>
                          value?.isEmpty == true ? 'أدخل التقييمات' : null,
                      decoration: InputDecoration(
                        hintText:
                            'مثال:\n- منتج ممتاز جداً والتوصيل سريع ⭐⭐⭐⭐⭐\n- الجودة متوسطة لكن السعر مناسب ⭐⭐⭐\n- لم يصل المنتج بالموعد المحدد ⭐⭐',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFBBF24),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFEFCE8),
                        hintStyle: GoogleFonts.cairo(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      style: GoogleFonts.cairo(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // زر التحليل
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _analyzeReviews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBBF24),
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
                            const Icon(Icons.analytics, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'تحليل التقييمات',
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
              if (_analysis != null) ...[
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
                            '📊 نتيجة التحليل',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          IconButton(
                            onPressed: _copyToClipboard,
                            icon: const Icon(
                              Icons.copy,
                              color: Color(0xFFFBBF24),
                            ),
                            tooltip: 'نسخ',
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        _analysis!,
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
