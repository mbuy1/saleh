# Add ONE sample product
# ⚠️ يجب تعيين متغير البيئة قبل التشغيل:
# $env:SUPABASE_SERVICE_KEY = "your-service-key-here"

$serviceKey = $env:SUPABASE_SERVICE_KEY
$baseUrl = "https://sirqidofuvphqcxqchyc.supabase.co/rest/v1"

# التحقق من وجود المفتاح
if ([string]::IsNullOrWhiteSpace($serviceKey)) {
    Write-Host "❌ Error: SUPABASE_SERVICE_KEY environment variable is not set!" -ForegroundColor Red
    Write-Host "   Set it using: `$env:SUPABASE_SERVICE_KEY = 'your-key-here'" -ForegroundColor Yellow
    exit 1
}

$headers = @{
    "apikey" = $serviceKey
    "Authorization" = "Bearer $serviceKey"
    "Content-Type" = "application/json"
    "Prefer" = "return=representation"
}

Write-Host "Fetching first category..." -ForegroundColor Cyan
$category = Invoke-RestMethod -Uri "$baseUrl/categories?is_active=eq.true&select=id,name_ar&limit=1" -Headers $headers
Write-Host "Category: $($category[0].name_ar)" -ForegroundColor Green

$product = @{
    store_id = "98f67597-ad0f-459c-9f3f-4b8984a37a05"
    category_id = $category[0].id
    name = "Test Product"
    description = "This is a test product"
    price = 99.99
    stock = 50
    is_active = $true
    status = "active"
}

$body = @($product) | ConvertTo-Json -Depth 10
Write-Host "`nSending request..." -ForegroundColor Cyan
Write-Host "Body: $body" -ForegroundColor Yellow

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/products" -Method Post -Headers $headers -Body $body
    Write-Host "`nSuccess! Product ID: $($result[0].id)" -ForegroundColor Green
    $result | Format-Table name, price, stock_quantity
} catch {
    $errorDetails = $_.ErrorDetails.Message
    Write-Host "`nError: $errorDetails" -ForegroundColor Red
    exit 1
}
