import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class MerchantShortcuts extends StatelessWidget {
  final VoidCallback? onStoreMgmtTap;
  final VoidCallback? onNotesTap;
  final VoidCallback? onRemindersTap;

  const MerchantShortcuts({
    super.key,
    this.onStoreMgmtTap,
    this.onNotesTap,
    this.onRemindersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'اختصاراتك',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MbuyColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildShortcutItem(
                'إدارة المتجر',
                Icons.store_outlined,
                onStoreMgmtTap,
              ),
              _buildShortcutItem(
                'الملاحظات',
                Icons.note_alt_outlined,
                onNotesTap,
              ),
              _buildShortcutItem(
                'التذكيرات',
                Icons.notifications_active_outlined,
                onRemindersTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutItem(String label, IconData icon, VoidCallback? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: MbuyColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MbuyColors.borderLight),
          ),
          child: Column(
            children: [
              Icon(icon, color: MbuyColors.primaryPurple, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MbuyColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
