import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';

const String _lastUpdatedDate = 'ديسمبر 2025';

/// شاشة سياسة الخصوصية
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.arrowBack, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'سياسة الخصوصية',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.paddingL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تاريخ التحديث
            Container(
              padding: AppDimensions.paddingS,
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    AppIcons.calendar,
                    size: 16,
                    color: AppTheme.infoColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'آخر تحديث: $_lastUpdatedDate',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.infoColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSection(
              title: 'مقدمة',
              content: '''
نحن في Mbuy نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. توضح سياسة الخصوصية هذه كيفية جمع واستخدام وحماية المعلومات التي تقدمها لنا عند استخدام تطبيقنا.

باستخدامك لتطبيق Mbuy، فإنك توافق على جمع واستخدام المعلومات وفقاً لهذه السياسة.
''',
            ),

            _buildSection(
              title: 'المعلومات التي نجمعها',
              content: '''
نقوم بجمع أنواع مختلفة من المعلومات لأغراض متعددة:

• **معلومات الحساب:** الاسم، البريد الإلكتروني، رقم الهاتف
• **معلومات المتجر:** اسم المتجر، الوصف، الشعار، المنتجات
• **بيانات المعاملات:** سجل الطلبات، المبيعات، المدفوعات
• **بيانات الاستخدام:** كيفية تفاعلك مع التطبيق
• **معلومات الجهاز:** نوع الجهاز، نظام التشغيل، معرف الجهاز
''',
            ),

            _buildSection(
              title: 'كيف نستخدم معلوماتك',
              content: '''
نستخدم المعلومات المجمعة للأغراض التالية:

• تقديم خدمات التطبيق وتحسينها
• معالجة الطلبات والمعاملات
• إرسال إشعارات مهمة حول حسابك
• تقديم الدعم الفني
• تحليل استخدام التطبيق لتحسين التجربة
• الكشف عن الاحتيال والأنشطة غير المصرح بها
• الامتثال للمتطلبات القانونية
''',
            ),

            _buildSection(
              title: 'مشاركة المعلومات',
              content: '''
لا نبيع أو نؤجر معلوماتك الشخصية لأطراف ثالثة. قد نشارك معلوماتك في الحالات التالية:

• **مع مزودي الخدمة:** شركات الدفع، خدمات التوصيل
• **للامتثال القانوني:** عند طلب السلطات المختصة
• **لحماية الحقوق:** لحماية حقوق Mbuy ومستخدميها
• **في عمليات الدمج:** في حالة اندماج أو استحواذ
''',
            ),

            _buildSection(
              title: 'أمان البيانات',
              content: '''
نتخذ إجراءات أمنية مناسبة لحماية بياناتك:

• تشفير البيانات أثناء النقل والتخزين (SSL/TLS)
• استخدام خوادم آمنة ومحمية
• تقييد الوصول للموظفين المصرح لهم فقط
• المراجعة الدورية لإجراءات الأمان
• عدم تخزين بيانات البطاقات البنكية على خوادمنا
''',
            ),

            _buildSection(
              title: 'حقوقك',
              content: '''
لديك الحقوق التالية بخصوص بياناتك:

• **الوصول:** طلب نسخة من بياناتك الشخصية
• **التصحيح:** تعديل أي معلومات غير صحيحة
• **الحذف:** طلب حذف بياناتك (مع بعض الاستثناءات)
• **الاعتراض:** الاعتراض على معالجة بياناتك
• **نقل البيانات:** طلب نقل بياناتك لمنصة أخرى
''',
            ),

            _buildSection(
              title: 'ملفات تعريف الارتباط (Cookies)',
              content: '''
نستخدم ملفات تعريف الارتباط وتقنيات مشابهة لـ:

• تذكر تفضيلاتك وإعداداتك
• تحليل استخدام التطبيق
• تحسين أداء التطبيق
• توفير تجربة مخصصة

يمكنك التحكم في إعدادات الكوكيز من خلال إعدادات جهازك.
''',
            ),

            _buildSection(
              title: 'التغييرات على السياسة',
              content: '''
قد نقوم بتحديث سياسة الخصوصية من وقت لآخر. سنقوم بإعلامك بأي تغييرات جوهرية عبر:

• إشعار داخل التطبيق
• بريد إلكتروني إلى العنوان المسجل
• تحديث تاريخ "آخر تحديث"

ننصحك بمراجعة هذه السياسة بشكل دوري.
''',
            ),

            _buildSection(
              title: 'تواصل معنا',
              content: '''
إذا كان لديك أي أسئلة حول سياسة الخصوصية، يمكنك التواصل معنا:

• البريد الإلكتروني: privacy@mbuy.app
• الدعم الفني: support@mbuy.app
• واتساب: +966 50 000 0000

سنرد على استفساراتك خلال 48 ساعة عمل.
''',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content.trim(),
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.mutedSlate,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
