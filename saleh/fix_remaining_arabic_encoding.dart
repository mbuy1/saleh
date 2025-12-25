import 'dart:convert';
import 'dart:io';

/// سكريبت شامل لإصلاح جميع النصوص العربية المشوهة
/// يعالج جميع الملفات التي لم يتم إصلاحها سابقاً
void main() async {
  print('🔍 البحث عن جميع الملفات المصابة بمشكلة UTF-8...\n');

  final files = [
    'lib/shared/widgets/error_boundary.dart',
    'lib/shared/screens/login_screen.dart',
    'lib/features/settings/presentation/screens/about_screen.dart',
    'lib/features/finance/presentation/screens/wallet_screen.dart',
    'lib/features/marketing/presentation/screens/coupons_screen.dart',
    'lib/features/marketing/presentation/screens/flash_sales_screen.dart',
    'lib/features/marketing/presentation/screens/marketing_screen.dart',
  ];

  int totalFixed = 0;
  int totalReplacements = 0;

  for (final filePath in files) {
    final file = File(filePath);
    if (!file.existsSync()) {
      print('⚠️  الملف غير موجود: $filePath');
      continue;
    }

    print('📄 معالجة: $filePath');
    
    // قراءة المحتوى بترميز Latin1 (ISO-8859-1)
    final bytes = await file.readAsBytes();
    final latin1Content = latin1.decode(bytes);
    
    // إعادة ترميزه كـ UTF-8
    final fixedContent = utf8.decode(latin1.encode(latin1Content));
    
    // حساب عدد التغييرات
    int replacements = 0;
    for (int i = 0; i < latin1Content.length && i < fixedContent.length; i++) {
      if (latin1Content[i] != fixedContent[i]) {
        replacements++;
      }
    }
    
    if (replacements > 0) {
      // حفظ النسخة المصلحة
      await file.writeAsString(fixedContent, encoding: utf8, flush: true);
      print('   ✅ تم الإصلاح: $replacements حرف');
      totalFixed++;
      totalReplacements += replacements;
    } else {
      print('   ℹ️  الملف سليم (لا يحتاج إصلاح)');
    }
  }

  print('\n' + '='*50);
  print('🎉 اكتمل الإصلاح!');
  print('📊 الملفات المعالجة: ${files.length}');
  print('✅ الملفات المُصلحة: $totalFixed');
  print('🔢 إجمالي الأحرف المستبدلة: $totalReplacements');
  print('='*50);
}
