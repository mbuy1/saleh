import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/services/gemini_service.dart';

/// شاشة استراتيجية تسويقية
class MarketingStrategyScreen extends StatefulWidget {
  const MarketingStrategyScreen({super.key});

  @override
  State<MarketingStrategyScreen> createState() =>
      _MarketingStrategyScreenState();
}

class _MarketingStrategyScreenState extends State<MarketingStrategyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _targetController = TextEditingController();
  final _budgetController = TextEditingController();
  final _goalsController = TextEditingController();

  String? _strategy;
  bool _isLoading = false;

  @override
  void dispose() {
    _productController.dispose();
    _targetController.dispose();
    _budgetController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  Future<void> _generateStrategy() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _strategy = null;
    });

    try {
      final result = await GeminiService.generateMarketingStrategy(
        product: _productController.text,
        targetAudience: _targetController.text,
        budget: _budgetController.text,
        goals: _goalsController.text,
      );

      setState(() {
        _strategy = result;
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
    if (_strategy != null) {
      Clipboard.setData(ClipboardData(text: _strategy!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ الاستراتيجية'),
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
          'استراتيجية تسويقية',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF10B981),
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
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مخطط الاستراتيجية',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'احصل على خطة تسويقية مفصلة لمنتجك أو متجرك',
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

              // المنتج أو المتجر
              _buildTextField(
                controller: _productController,
                label: 'المنتج أو المتجر',
                hint: 'مثال: متجر إلكترونيات متخصص في الجوالات',
                icon: Icons.shopping_bag,
                validator: (value) =>
                    value?.isEmpty == true ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),

              // الجمهور المستهدف
              _buildTextField(
                controller: _targetController,
                label: 'الجمهور المستهدف',
                hint: 'مثال: شباب من 18-35 سنة، مهتمين بالتقنية',
                icon: Icons.people,
                validator: (value) =>
                    value?.isEmpty == true ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),

              // الميزانية
              _buildTextField(
                controller: _budgetController,
                label: 'الميزانية الشهرية (اختياري)',
                hint: 'مثال: 5000 ريال، محدودة، مرنة',
                icon: Icons.attach_money,
              ),
              const SizedBox(height: 16),

              // الأهداف
              _buildTextField(
                controller: _goalsController,
                label: 'الأهداف',
                hint: 'مثال: زيادة المبيعات 50%، جذب 1000 متابع جديد',
                icon: Icons.flag,
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // زر التوليد
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _generateStrategy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
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
                              'توليد الاستراتيجية',
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
              if (_strategy != null) ...[
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
                            '📊 الخطة التسويقية',
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
                              color: Color(0xFF10B981),
                            ),
                            tooltip: 'نسخ',
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        _strategy!,
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
        prefixIcon: Icon(icon, color: const Color(0xFF10B981)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
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
