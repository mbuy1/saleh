import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';

/// شاشة شروط الاستخدام
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
          'شروط الاستخدام',
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
                    'آخر تحديث: ديسمبر 2025',
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
مرحباً بك في Mbuy! هذه الشروط والأحكام تحكم استخدامك لتطبيق Mbuy وجميع الخدمات المرتبطة به.

باستخدامك للتطبيق، فإنك توافق على الالتزام بهذه الشروط. إذا كنت لا توافق على أي جزء منها، يرجى عدم استخدام التطبيق.
''',
            ),

            _buildSection(
              title: 'التعريفات',
              content: '''
• **"التطبيق":** تطبيق Mbuy للهواتف المحمولة والويب
• **"الخدمات":** جميع الخدمات المقدمة عبر التطبيق
• **"المستخدم":** أي شخص يستخدم التطبيق
• **"التاجر":** مستخدم لديه متجر على المنصة
• **"العميل":** مستخدم يشتري من المتاجر
• **"المحتوى":** أي نصوص، صور، فيديوهات، أو بيانات
• **"النقاط":** العملة الافتراضية داخل التطبيق
''',
            ),

            _buildSection(
              title: 'الأهلية',
              content: '''
لاستخدام Mbuy، يجب أن:

• يكون عمرك 18 سنة على الأقل
• تمتلك الأهلية القانونية لإبرام العقود
• تقدم معلومات صحيحة ودقيقة عند التسجيل
• تلتزم بجميع القوانين المعمول بها في بلدك
• لا تكون محظوراً من استخدام خدماتنا سابقاً
''',
            ),

            _buildSection(
              title: 'الحساب والأمان',
              content: '''
أنت مسؤول عن:

• الحفاظ على سرية بيانات حسابك
• جميع الأنشطة التي تتم من خلال حسابك
• إخطارنا فوراً بأي استخدام غير مصرح به
• عدم مشاركة حسابك مع الآخرين

نحتفظ بالحق في:
• تعليق أو إنهاء حسابك في حالة انتهاك الشروط
• طلب تأكيد هويتك في أي وقت
''',
            ),

            _buildSection(
              title: 'شروط التاجر',
              content: '''
كتاجر على Mbuy، تلتزم بما يلي:

**المنتجات:**
• بيع منتجات قانونية ومطابقة للوصف
• عدم بيع منتجات مقلدة أو محظورة
• توفير صور ووصف دقيق للمنتجات
• الالتزام بالأسعار المعلنة

**الطلبات:**
• معالجة الطلبات في الوقت المحدد
• توفير معلومات تتبع الشحن
• التعامل مع المرتجعات وفق السياسة

**الرسوم:**
• دفع رسوم المنصة في الوقت المحدد
• عمولة على كل عملية بيع ناجحة
''',
            ),

            _buildSection(
              title: 'النقاط والاشتراكات',
              content: '''
**النقاط:**
• النقاط عملة افتراضية غير قابلة للاسترداد نقداً
• يمكن استخدامها لأدوات AI والميزات المتقدمة
• لا تنتهي صلاحية النقاط المشتراة
• النقاط المكتسبة قد تخضع لشروط خاصة

**الاشتراكات:**
• تجدد تلقائياً ما لم يتم إلغاؤها
• يمكن إلغاء الاشتراك قبل نهاية الفترة
• لا يتم استرداد المبالغ المدفوعة
• تغييرات الأسعار تُعلن مسبقاً
''',
            ),

            _buildSection(
              title: 'المحتوى المحظور',
              content: '''
يُحظر على المستخدمين نشر أو بيع:

• منتجات غير قانونية أو مقلدة
• محتوى إباحي أو مسيء
• مواد تنتهك حقوق الملكية الفكرية
• معلومات شخصية للآخرين بدون إذن
• برامج ضارة أو روابط احتيالية
• محتوى يحرض على الكراهية أو العنف
• أي شيء ينتهك القوانين المحلية أو الدولية
''',
            ),

            _buildSection(
              title: 'حقوق الملكية الفكرية',
              content: '''
• Mbuy وشعاراتها علامات تجارية محمية
• جميع حقوق التطبيق محفوظة لـ Mbuy
• يحتفظ التجار بملكية محتواهم
• بنشر المحتوى، تمنحنا ترخيصاً لاستخدامه
• نحترم حقوق الملكية الفكرية للآخرين
''',
            ),

            _buildSection(
              title: 'إخلاء المسؤولية',
              content: '''
• التطبيق يُقدم "كما هو" دون ضمانات
• لا نضمن توفر الخدمة بشكل متواصل
• لسنا مسؤولين عن المعاملات بين التجار والعملاء
• لا نتحمل مسؤولية الأضرار غير المباشرة
• مسؤوليتنا محدودة بالمبلغ المدفوع لنا
''',
            ),

            _buildSection(
              title: 'التعديلات',
              content: '''
نحتفظ بالحق في تعديل هذه الشروط في أي وقت:

• سنُخطرك بالتغييرات الجوهرية
• استمرارك في الاستخدام يعني موافقتك
• التعديلات تسري من تاريخ نشرها
• ننصحك بمراجعة الشروط بشكل دوري
''',
            ),

            _buildSection(
              title: 'القانون المعمول به',
              content: '''
• تخضع هذه الشروط لقوانين المملكة العربية السعودية
• أي نزاع يُحل ودياً أولاً
• في حالة عدم الحل، تُحال للمحاكم المختصة
• اللغة العربية هي اللغة المعتمدة
''',
            ),

            _buildSection(
              title: 'تواصل معنا',
              content: '''
لأي استفسارات حول شروط الاستخدام:

• البريد الإلكتروني: legal@mbuy.app
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
