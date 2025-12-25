import 'dart:convert';
import 'dart:io';

/// سكريبت شامل لإصلاح جميع ملفات .dart المصابة
void main() async {
  print('🔍 البحث عن جميع ملفات .dart في المشروع...\n');

  final libDir = Directory('lib');
  final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  print('📁 وجدنا ${dartFiles.length} ملف .dart\n');

  int totalFixed = 0;
  int totalReplacements = 0;
  int totalSkipped = 0;

  for (final file in dartFiles) {
    final filePath = file.path.replaceAll('\\', '/');
    
    try {
      // قراءة المحتوى بترميز Latin1
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
        print('✅ $filePath - إصلاح $replacements حرف');
        totalFixed++;
        totalReplacements += replacements;
      } else {
        totalSkipped++;
      }
    } catch (e) {
      print('❌ خطأ في $filePath: $e');
    }
  }

  print('\n' + '='*60);
  print('🎉 اكتمل الفحص الشامل!');
  print('📊 إجمالي الملفات: ${dartFiles.length}');
  print('✅ الملفات المُصلحة: $totalFixed');
  print('✓  الملفات السليمة: $totalSkipped');
  print('🔢 إجمالي الأحرف المستبدلة: $totalReplacements');
  print('='*60);
}
