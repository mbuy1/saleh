import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/services/gemini_service.dart';

/// شاشة توليد وصف منتج
class ProductDescriptionScreen extends StatefulWidget {
  const ProductDescriptionScreen({super.key});

  @override
  State<ProductDescriptionScreen> createState() =>
      _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _featuresController = TextEditingController();
  final _priceController = TextEditingController();

  String? _generatedDescription;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _featuresController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _generateDescription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _generatedDescription = null;
    });

    try {
      final description = await GeminiService.generateProductDescription(
        productName: _nameController.text,
        category: _categoryController.text,
        features: _featuresController.text,
        price: _priceController.text,
      );

      setState(() {
        _generatedDescription = description;
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
    if (_generatedDescription != null) {
      Clipboard.setData(ClipboardData(text: _generatedDescription!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ الوصف'),
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
          'توليد وصف منتج',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3B82F6),
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
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مولد الوصف الذكي',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'أدخل معلومات المنتج واحصل على وصف تسويقي احترافي',
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
              _buildTextField(
                controller: _nameController,
                label: 'اسم المنتج',
                hint: 'مثال: سماعة بلوتوث لاسلكية',
                icon: Icons.shopping_bag,
                validator: (value) =>
                    value?.isEmpty == true ? 'أدخل اسم المنتج' : null,
              ),
              const SizedBox(height: 16),

              // الفئة
              _buildTextField(
                controller: _categoryController,
                label: 'الفئة',
                hint: 'مثال: إلكترونيات، ملابس، أدوات منزلية',
                icon: Icons.category,
                validator: (value) =>
                    value?.isEmpty == true ? 'أدخل فئة المنتج' : null,
              ),
              const SizedBox(height: 16),

              // المميزات
              _buildTextField(
                controller: _featuresController,
                label: 'المميزات الرئيسية',
                hint: 'مثال: مقاومة للماء، بطارية تدوم 24 ساعة، صوت ستيريو',
                icon: Icons.star,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // السعر
              _buildTextField(
                controller: _priceController,
                label: 'السعر (اختياري)',
                hint: 'مثال: 150 ريال',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // زر التوليد
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _generateDescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
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
                              'توليد الوصف',
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
              if (_generatedDescription != null) ...[
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
                            'الوصف المُولّد',
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
                              color: Color(0xFF3B82F6),
                            ),
                            tooltip: 'نسخ',
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        _generatedDescription!,
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
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
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
