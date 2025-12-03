# سكريبت لإعادة بناء التطبيق بالكامل
# استخدم: .\rebuild_app.ps1

Write-Host "🧹 تنظيف المشروع..." -ForegroundColor Yellow
flutter clean

Write-Host "📦 إعادة تثبيت الحزم..." -ForegroundColor Yellow
flutter pub get

Write-Host "🔍 فحص الكود..." -ForegroundColor Yellow
flutter analyze

Write-Host "✅ جاهز للبناء!" -ForegroundColor Green
Write-Host "قم بتشغيل: flutter run" -ForegroundColor Cyan

