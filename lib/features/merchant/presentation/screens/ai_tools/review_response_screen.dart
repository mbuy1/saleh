import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/services/gemini_service.dart';

/// شاشة توليد رد على مراجعة
class ReviewResponseScreen extends StatefulWidget {
  const ReviewResponseScreen({super.key});

  @override
  State<ReviewResponseScreen> createState() => _ReviewResponseScreenState();
}

class _ReviewResponseScreenState extends State<ReviewResponseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  final _ratingController = TextEditingController();

  String? _response;
  bool _isLoading = false;
  String _selectedTone = 'احترافي';

  final List<String> _tones = ['احترافي', 'ودي', 'رسمي', 'اعتذاري'];

  @override
  void dispose() {
    _reviewController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _generateResponse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final result = await GeminiService.generateReviewResponse(
        review: _reviewController.text,
        rating: _ratingController.text,
        tone: _selectedTone,
      );

      setState(() {
        _response = result;
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
    if (_response != null) {
      Clipboard.setData(ClipboardData(text: _response!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ الرد'),
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
          'رد على مراجعة',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6366F1),
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
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.reply, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مولد الردود الاحترافية',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'احصل على ردود مثالية على تقييمات العملاء',
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

              // المراجعة
              TextFormField(
                controller: _reviewController,
                maxLines: 4,
                validator: (value) =>
                    value?.isEmpty == true ? 'أدخل نص المراجعة' : null,
                decoration: InputDecoration(
                  labelText: 'نص المراجعة',
                  hintText: 'الصق هنا مراجعة العميل التي تريد الرد عليها...',
                  prefixIcon: const Icon(
                    Icons.comment,
                    color: Color(0xFF6366F1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF6366F1),
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

              // التقييم
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ratingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'التقييم (1-5)',
                        hintText: '5',
                        prefixIcon: const Icon(
                          Icons.star,
                          color: Color(0xFF6366F1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF6366F1),
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
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // نبرة الرد
              Text(
                'نبرة الرد',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _tones.map((tone) {
                  final isSelected = tone == _selectedTone;
                  return ChoiceChip(
                    label: Text(
                      tone,
                      style: GoogleFonts.cairo(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6366F1),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF6366F1),
                    backgroundColor: const Color(0xFFEEF2FF),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedTone = tone;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // زر التوليد
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _generateResponse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
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
                              'توليد الرد',
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
              if (_response != null) ...[
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
                            '💬 الرد المقترح',
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
                              color: Color(0xFF6366F1),
                            ),
                            tooltip: 'نسخ',
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        _response!,
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
