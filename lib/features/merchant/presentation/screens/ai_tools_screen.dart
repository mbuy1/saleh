import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة أدوات الذكاء الاصطناعي للتاجر
class AIToolsScreen extends StatefulWidget {
  const AIToolsScreen({super.key});

  @override
  State<AIToolsScreen> createState() => _AIToolsScreenState();
}

class _AIToolsScreenState extends State<AIToolsScreen> {
  final _productNameController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isGenerating = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _generateProductDescription() async {
    if (_productNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال اسم المنتج')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final result = await AIService.generateProductDescription(
        productName: _productNameController.text.trim(),
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('وصف المنتج المولد'),
            content: SingleChildScrollView(
              child: Text(
                result['description'] ?? 'لا يوجد وصف',
                style: GoogleFonts.cairo(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: نسخ الوصف
                  Navigator.pop(context);
                },
                child: const Text('نسخ'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _generateCommentResponse() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال التعليق')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final result = await AIService.generateCommentResponse(
        comment: _commentController.text.trim(),
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('رد مقترح'),
            content: SingleChildScrollView(
              child: Text(
                result['response'] ?? 'لا يوجد رد',
                style: GoogleFonts.cairo(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: نسخ الرد
                  Navigator.pop(context);
                },
                child: const Text('نسخ'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('أدوات الذكاء الاصطناعي'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: _isGenerating
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // توليد وصف منتج
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.description, color: MbuyColors.primaryMaroon),
                            const SizedBox(width: 8),
                            Text(
                              'توليد وصف منتج',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _productNameController,
                          decoration: InputDecoration(
                            labelText: 'اسم المنتج',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.shopping_bag),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _generateProductDescription,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MbuyColors.primaryMaroon,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('توليد الوصف'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // توليد رد على تعليق
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.comment, color: MbuyColors.primaryMaroon),
                            const SizedBox(width: 8),
                            Text(
                              'توليد رد على تعليق',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _commentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'نص التعليق',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.comment_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _generateCommentResponse,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MbuyColors.primaryMaroon,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('توليد الرد'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // معلومات
                Card(
                  color: MbuyColors.primaryMaroon.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: MbuyColors.primaryMaroon),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'هذه الأدوات تستخدم الذكاء الاصطناعي لمساعدتك في إدارة متجرك. المفاتيح السرية محفوظة في Worker Secrets.',
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: MbuyColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

