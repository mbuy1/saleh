# Add sample products to Supabase
$serviceKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpcnFpZG9mdXZwaHFjeHFjaHljIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NDY3NTAxMCwiZXhwIjoyMDgwMjUxMDEwfQ.B1PRMsrqMSQ9KIC9-jnZbbxRVRb37uwGQy47CMKjWjI"
$baseUrl = "https://sirqidofuvphqcxqchyc.supabase.co/rest/v1"

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
