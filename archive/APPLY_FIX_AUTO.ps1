# ============================================================================
# تطبيق إصلاح التسجيل - تلقائي
# ============================================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  تطبيق إصلاح CREATE_FAILED" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# الخطوة 1: نسخ SQL إلى Clipboard
Write-Host "الخطوة 1: نسخ SQL..." -ForegroundColor White
Get-Content "c:\muath\COMPREHENSIVE_REGISTRATION_FIX.sql" | Set-Clipboard
Write-Host "✅ تم نسخ 254 سطر إلى Clipboard" -ForegroundColor Green
Write-Host ""

# الخطوة 2: الحصول على Project Ref
Write-Host "Step 2: Getting Project Reference..." -ForegroundColor White
$projectRef = "sirqidofuvphqcxqchyc"
Write-Host "Project Ref: $projectRef" -ForegroundColor Green
Write-Host ""

# الخطوة 3: فتح Supabase Dashboard
Write-Host "الخطوة 3: فتح Supabase Dashboard..." -ForegroundColor White
$dashboardUrl = "https://supabase.com/dashboard/project/$projectRef/sql/new"
Start-Process $dashboardUrl
Write-Host "✅ تم فتح Dashboard في المتصفح" -ForegroundColor Green
Write-Host ""

# الخطوة 4: التعليمات
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  الآن في Dashboard:" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. انتظر حتى يفتح SQL Editor" -ForegroundColor White
Write-Host "2. اضغط Ctrl+V (اللصق)" -ForegroundColor White
Write-Host "3. اضغط Run أو Ctrl+Enter" -ForegroundColor White
Write-Host "4. انتظر النتيجة (15-20 ثانية)" -ForegroundColor White
Write-Host "5. إذا رأيت ✅ SUCCESS في النتائج، عُد هنا" -ForegroundColor White
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# الخطوة 5: الانتظار
Write-Host "منتظر تطبيقك للـ SQL..." -ForegroundColor Yellow
Write-Host "اضغط أي مفتاح بعد تطبيق SQL في Dashboard..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  اختبار التسجيل" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# الخطوة 6: اختبار التسجيل
$random = Get-Random -Minimum 1000 -Maximum 9999
$email = "test-cli-fix-$random@mbuy.com"

Write-Host "اختبار التسجيل مع: $email" -ForegroundColor Cyan
Write-Host ""

$body = @{
    email = $email
    password = "Test123456"
    role = "merchant"
    full_name = "CLI Fix Test"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod `
        -Uri "https://misty-mode-b68b.baharista1.workers.dev/auth/supabase/register" `
        -Method POST `
        -ContentType "application/json" `
        -Body $body `
        -ErrorAction Stop
    
    Write-Host "✅✅✅ نجح التسجيل!" -ForegroundColor Green
    Write-Host ""
    Write-Host "النتيجة:" -ForegroundColor Yellow
    $response | ConvertTo-Json -Depth 5
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "  الإصلاح نجح بالكامل!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "الخطوات التالية:" -ForegroundColor Yellow
    Write-Host "1. ✅ اختبار Login" -ForegroundColor Cyan
    Write-Host "2. ✅ اختبار GET /auth/profile" -ForegroundColor Cyan
    Write-Host "3. ✅ اختبار Create Store" -ForegroundColor Cyan
    Write-Host ""
    
} catch {
    Write-Host "❌ فشل التسجيل" -ForegroundColor Red
    Write-Host "الخطأ: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        Write-Host ""
        Write-Host "التفاصيل:" -ForegroundColor Yellow
        $_.ErrorDetails.Message | ConvertFrom-Json | ConvertTo-Json -Depth 5
    }
    
    Write-Host ""
    Write-Host "SQL may not have been applied correctly." -ForegroundColor Yellow
    Write-Host "Check error messages in Dashboard" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "اضغط أي مفتاح للخروج..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
