import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class MerchantHeader extends StatelessWidget {
  final String storeName;
  final String? storeImageUrl;
  final VoidCallback? onSwitchAccount;

  const MerchantHeader({
    super.key,
    required this.storeName,
    this.storeImageUrl,
    this.onSwitchAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top Row: Avatar, Name, Switch Arrow
          Row(
            children: [
              // Store Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: MbuyColors.borderLight, width: 1),
                  image: storeImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(storeImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: storeImageUrl == null
                    ? const Icon(
                        Icons.store,
                        color: MbuyColors.textSecondary,
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Store Name & Label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    Text(
                      'حساب المتجر',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Switch Account Arrow
              IconButton(
                onPressed: onSwitchAccount,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MbuyColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.swap_horiz,
                    color: MbuyColors.primaryPurple,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats Row
          Row(
            children: [
              _buildStatItem('المنتجات', '124'),
              _buildDivider(),
              _buildStatItem('الطلبات الجديدة', '5', isHighlight: true),
              _buildDivider(),
              _buildStatItem('التقييم', '4.8 ⭐'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isHighlight
                  ? MbuyColors.primaryPurple
                  : MbuyColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: MbuyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: MbuyColors.borderLight);
  }
}
