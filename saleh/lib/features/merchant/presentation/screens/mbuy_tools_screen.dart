import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة Mbuy Tools للتاجر
class MbuyToolsScreen extends StatefulWidget {
  const MbuyToolsScreen({super.key});

  @override
  State<MbuyToolsScreen> createState() => _MbuyToolsScreenState();
}

class _MbuyToolsScreenState extends State<MbuyToolsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('Mbuy Tools'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                      'Mbuy Tools يستخدم خدمات Cloudflare لمساعدتك في إدارة متجرك. المفاتيح السرية محفوظة في Worker Secrets.',
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
          const SizedBox(height: 16),

          // التحليلات في الوقت الفعلي
          _buildToolCard(
            icon: Icons.analytics,
            title: 'التحليلات في الوقت الفعلي',
            subtitle: 'مراقبة أداء متجرك لحظة بلحظة',
            onTap: () => _showRealtimeAnalytics(),
          ),

          // التفاعل داخل المتجر
          _buildToolCard(
            icon: Icons.people,
            title: 'التفاعل داخل المتجر',
            subtitle: 'مراقبة تفاعل العملاء في الوقت الفعلي',
            onTap: () => _showRealtimeInteractions(),
          ),

          // توليد وصف المنتج
          _buildToolCard(
            icon: Icons.description,
            title: 'توليد وصف المنتج',
            subtitle: 'استخدم AI لتوليد أوصاف منتجات احترافية',
            onTap: () => _showProductDescriptionGenerator(),
          ),

          // الاقتراحات الذكية
          _buildToolCard(
            icon: Icons.lightbulb,
            title: 'الاقتراحات الذكية',
            subtitle: 'اقتراحات ذكية لتحسين أداء متجرك',
            onTap: () => _showSmartSuggestions(),
          ),

          // أدوات التسويق
          _buildToolCard(
            icon: Icons.campaign,
            title: 'أدوات التسويق',
            subtitle: 'إدارة الحملات التسويقية',
            onTap: () => _showMarketingTools(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: MbuyColors.primaryMaroon.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: MbuyColors.primaryMaroon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: MbuyColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _showRealtimeAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة التحليلات في الوقت الفعلي قريباً')),
    );
  }

  void _showRealtimeInteractions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة التفاعل داخل المتجر قريباً')),
    );
  }

  void _showProductDescriptionGenerator() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة توليد وصف المنتج قريباً')),
    );
  }

  void _showSmartSuggestions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة الاقتراحات الذكية قريباً')),
    );
  }

  void _showMarketingTools() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة أدوات التسويق قريباً')),
    );
  }
}

