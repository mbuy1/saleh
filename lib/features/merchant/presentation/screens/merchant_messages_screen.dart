import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة الرسائل للتاجر
class MerchantMessagesScreen extends StatefulWidget {
  const MerchantMessagesScreen({super.key});

  @override
  State<MerchantMessagesScreen> createState() => _MerchantMessagesScreenState();
}

class _MerchantMessagesScreenState extends State<MerchantMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('الرسائل'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // رسالة وهمية
          _buildMessageCard(
            customerName: 'أحمد محمد',
            lastMessage: 'متى سيتم توصيل الطلب؟',
            time: 'منذ ساعتين',
            unreadCount: 2,
          ),
          _buildMessageCard(
            customerName: 'فاطمة علي',
            lastMessage: 'شكراً لك على المنتج الرائع',
            time: 'منذ 5 ساعات',
            unreadCount: 0,
          ),
          _buildMessageCard(
            customerName: 'خالد سعيد',
            lastMessage: 'هل المنتج متوفر باللون الأحمر؟',
            time: 'أمس',
            unreadCount: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard({
    required String customerName,
    required String lastMessage,
    required String time,
    required int unreadCount,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MbuyColors.primaryIndigo,
          child: Text(
            customerName[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          customerName,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w600,
            color: MbuyColors.textPrimary,
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: GoogleFonts.cairo(
            color: MbuyColors.textSecondary,
            fontSize: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: MbuyColors.textTertiary,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: MbuyColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unreadCount',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          // TODO: فتح شاشة المحادثة
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('سيتم إضافة شاشة المحادثة قريباً')),
          );
        },
      ),
    );
  }
}

