# Add sample products to Supabase
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

Write-Host "Fetching categories..." -ForegroundColor Cyan
$categories = Invoke-RestMethod -Uri "$baseUrl/categories?is_active=eq.true&select=id,name_ar&limit=20" -Headers $headers
Write-Host "Found $($categories.Count) categories" -ForegroundColor Green

Write-Host "`nCreating sample products..." -ForegroundColor Cyan
$products = @()

foreach($cat in $categories) {
    $price = Get-Random -Minimum 50 -Maximum 550
    $stock = Get-Random -Minimum 10 -Maximum 110
    
    $products += @{
        store_id = "98f67597-ad0f-459c-9f3f-4b8984a37a05"
        category_id = $cat.id
        name = "Sample Product - " + $cat.name_ar
        description = "This is a sample product for testing purposes."
        price = $price
        stock = $stock
        is_active = $true
        status = "active"
    }
}

$body = $products | ConvertTo-Json -Depth 10
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/products" -Method Post -Headers $headers -Body $body
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "Response: $($_.Exception.Response)" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Successfully added $($result.Count) products!" -ForegroundColor Green
Write-Host "`nFirst 5 products:" -ForegroundColor Cyan
$result | Select-Object -First 5 | Format-Table name_ar, price, stock_quantity -AutoSize
