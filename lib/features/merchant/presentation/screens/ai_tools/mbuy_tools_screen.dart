import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// شاشة أدوات mBuy الذكية
class MbuyToolsScreen extends StatelessWidget {
  const MbuyToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.build_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أدوات mBuy',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'أدوات ذكية مدعومة بـ Gemini AI',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم أدوات المنتجات
            _buildSectionHeader('أدوات المنتجات', Icons.inventory_2),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.description,
              title: 'توليد وصف منتج',
              subtitle: 'احصل على وصف تسويقي احترافي لمنتجك',
              color: const Color(0xFF3B82F6),
              route: '/merchant/ai-tools/product-description',
            ),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.image_search,
              title: 'تحليل صورة منتج',
              subtitle: 'رفع صورة والحصول على وصف تفصيلي تلقائي',
              color: const Color(0xFF8B5CF6),
              route: '/merchant/ai-tools/image-analysis',
            ),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.key,
              title: 'اقتراح كلمات مفتاحية',
              subtitle: 'توليد كلمات SEO لتحسين ظهور منتجك',
              color: const Color(0xFFEC4899),
              route: '/merchant/ai-tools/keywords',
            ),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.compare_arrows,
              title: 'مقارنة منتجات',
              subtitle: 'قارن بين منتجين وأظهر المزايا',
              color: const Color(0xFFF59E0B),
              route: '/merchant/ai-tools/compare-products',
            ),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.auto_fix_high,
              title: 'تحسين وصف منتج',
              subtitle: 'حسّن وصف منتج موجود باستخدام AI',
              color: const Color(0xFF06B6D4),
              route: '/merchant/ai-tools/improve-description',
            ),

            const SizedBox(height: 24),

            // قسم أدوات التسويق
            _buildSectionHeader('أدوات التسويق', Icons.campaign),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.local_offer,
              title: 'توليد أفكار عروض',
              subtitle: 'احصل على اقتراحات لكوبونات وعروض ترويجية',
              color: const Color(0xFFEF4444),
              route: '/merchant/ai-tools/promo-ideas',
            ),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.trending_up,
              title: 'استراتيجية تسويقية',
              subtitle: 'خطة تسويقية مفصلة لمنتجك',
              color: const Color(0xFF10B981),
              route: '/merchant/ai-tools/marketing-strategy',
            ),

            const SizedBox(height: 24),

            // قسم أدوات التحليل
            _buildSectionHeader('أدوات التحليل', Icons.analytics),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.star_rate,
              title: 'تحليل التقييمات',
              subtitle: 'حلل مراجعات العملاء واستخرج النقاط المهمة',
              color: const Color(0xFFFBBF24),
              route: '/merchant/ai-tools/reviews-analysis',
            ),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.reply,
              title: 'رد على مراجعة',
              subtitle: 'توليد ردود احترافية على تقييمات العملاء',
              color: const Color(0xFF6366F1),
              route: '/merchant/ai-tools/review-response',
            ),

            const SizedBox(height: 24),

            // قسم أدوات إضافية
            _buildSectionHeader('أدوات إضافية', Icons.more_horiz),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              icon: Icons.translate,
              title: 'ترجمة نصوص',
              subtitle: 'ترجم أوصاف المنتجات لأي لغة',
              color: const Color(0xFF14B8A6),
              route: '/merchant/ai-tools/translate',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6B7280), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
