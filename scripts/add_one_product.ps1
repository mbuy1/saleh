# Add ONE sample product
$serviceKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpcnFpZG9mdXZwaHFjeHFjaHljIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NDY3NTAxMCwiZXhwIjoyMDgwMjUxMDEwfQ.B1PRMsrqMSQ9KIC9-jnZbbxRVRb37uwGQy47CMKjWjI"
$baseUrl = "https://sirqidofuvphqcxqchyc.supabase.co/rest/v1"

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
