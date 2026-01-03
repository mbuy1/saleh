import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          _buildStatsSection(),
          _buildOrdersSection(),
          _buildMenuSection(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً بك!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'تسجيل الدخول / إنشاء حساب',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = [
      {'icon': Icons.favorite_outline, 'label': 'المفضلة', 'count': '12'},
      {'icon': Icons.local_offer_outlined, 'label': 'الكوبونات', 'count': '3'},
      {'icon': Icons.star_outline, 'label': 'النقاط', 'count': '520'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) {
          return Column(
            children: [
              Icon(stat['icon'] as IconData, color: AppTheme.primaryColor),
              const SizedBox(height: 4),
              Text(
                stat['count'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                stat['label'] as String,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersSection() {
    final orderTypes = [
      {'icon': Icons.payment, 'label': 'بانتظار الدفع'},
      {'icon': Icons.local_shipping_outlined, 'label': 'قيد الشحن'},
      {'icon': Icons.inventory_2_outlined, 'label': 'قيد التوصيل'},
      {'icon': Icons.rate_review_outlined, 'label': 'بانتظار التقييم'},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'طلباتي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(onPressed: () {}, child: const Text('عرض الكل')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: orderTypes.map((type) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      type['icon'] as IconData,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    type['label'] as String,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    final menuGroups = [
      [
        {'icon': Icons.location_on_outlined, 'title': 'عناويني'},
        {'icon': Icons.credit_card_outlined, 'title': 'طرق الدفع'},
        {'icon': Icons.notifications_outlined, 'title': 'الإشعارات'},
      ],
      [
        {'icon': Icons.headset_mic_outlined, 'title': 'خدمة العملاء'},
        {'icon': Icons.help_outline, 'title': 'الأسئلة الشائعة'},
        {'icon': Icons.policy_outlined, 'title': 'سياسة الاستبدال والاسترجاع'},
      ],
      [
        {'icon': Icons.share_outlined, 'title': 'شارك التطبيق'},
        {'icon': Icons.info_outline, 'title': 'عن التطبيق'},
      ],
    ];

    return Column(
      children: menuGroups.map((group) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: group.map((item) {
              return ListTile(
                leading: Icon(
                  item['icon'] as IconData,
                  color: AppTheme.primaryColor,
                ),
                title: Text(item['title'] as String),
                trailing: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {},
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
