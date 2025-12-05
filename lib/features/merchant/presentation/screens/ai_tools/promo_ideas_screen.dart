import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/services/gemini_service.dart';

/// شاشة توليد أفكار عروض
class PromoIdeasScreen extends StatefulWidget {
  const PromoIdeasScreen({super.key});

  @override
  State<PromoIdeasScreen> createState() => _PromoIdeasScreenState();
}

class _PromoIdeasScreenState extends State<PromoIdeasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeTypeController = TextEditingController();
  final _productsController = TextEditingController();
  final _occasionController = TextEditingController();

  String? _promoIdeas;
  bool _isLoading = false;

  @override
  void dispose() {
    _storeTypeController.dispose();
    _productsController.dispose();
    _occasionController.dispose();
    super.dispose();
  }

  Future<void> _generateIdeas() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _promoIdeas = null;
    });

    try {
      final ideas = await GeminiService.generatePromoIdeas(
        storeType: _storeTypeController.text,
        products: _productsController.text,
        occasion: _occasionController.text,
      );

      setState(() {
        _promoIdeas = ideas;
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
    if (_promoIdeas != null) {
      Clipboard.setData(ClipboardData(text: _promoIdeas!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ الأفكار'),
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
          'أفكار العروض والكوبونات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEF4444),
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
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_offer,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مولد أفكار العروض',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'احصل على أفكار إبداعية للكوبونات والعروض الترويجية',
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

              // نوع المتجر
              _buildTextField(
                controller: _storeTypeController,
                label: 'نوع المتجر',
                hint: 'مثال: متجر إلكترونيات، ملابس نسائية، أدوات منزلية',
                icon: Icons.store,
                validator: (value) =>
                    value?.isEmpty == true ? 'أدخل نوع متجرك' : null,
              ),
              const SizedBox(height: 16),

              // المنتجات الرئيسية
              _buildTextField(
                controller: _productsController,
                label: 'المنتجات الرئيسية',
                hint: 'مثال: هواتف، سماعات، شواحن',
                icon: Icons.inventory_2,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // المناسبة (اختياري)
              _buildTextField(
                controller: _occasionController,
                label: 'المناسبة (اختياري)',
                hint: 'مثال: رمضان، العيد، الجمعة البيضاء، يوم التأسيس',
                icon: Icons.celebration,
              ),
              const SizedBox(height: 24),

              // زر التوليد
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _generateIdeas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
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
                              'توليد أفكار العروض',
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
              if (_promoIdeas != null) ...[
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
                            '💡 أفكار العروض',
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
                              color: Color(0xFFEF4444),
                            ),
                            tooltip: 'نسخ',
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        _promoIdeas!,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFEF4444)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: GoogleFonts.cairo(),
        hintStyle: GoogleFonts.cairo(color: Colors.grey),
      ),
      style: GoogleFonts.cairo(),
    );
  }
}
