# 🧪 Quick Test Script - Registration Fix
# Run this after applying the fix to verify registration works

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MBUY Registration Fix - Test Script  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$WORKER_URL = "https://misty-mode-b68b.baharista1.workers.dev"
$REGISTER_ENDPOINT = "$WORKER_URL/auth/supabase/register"
$LOGIN_ENDPOINT = "$WORKER_URL/auth/supabase/login"

# Generate random email to avoid conflicts
$random = Get-Random -Minimum 1000 -Maximum 9999
$testEmail = "test-fix-$random@mbuy.com"
$testPassword = "test123456"
$testName = "Test Fix User $random"

Write-Host "📋 Test Configuration:" -ForegroundColor Yellow
Write-Host "   Email: $testEmail" -ForegroundColor Gray
Write-Host "   Password: $testPassword" -ForegroundColor Gray
Write-Host "   Name: $testName" -ForegroundColor Gray
Write-Host ""

# Test 1: Registration
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test 1: User Registration (Customer)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$registerBody = @{
    email = $testEmail
    password = $testPassword
    full_name = $testName
    role = "customer"
} | ConvertTo-Json

Write-Host "🚀 Sending registration request..." -ForegroundColor Gray

try {
    $registerResponse = Invoke-WebRequest `
        -Uri $REGISTER_ENDPOINT `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body $registerBody `
        -ErrorAction Stop
    
    $registerData = $registerResponse.Content | ConvertFrom-Json
    
    Write-Host "✅ Registration Status: $($registerResponse.StatusCode)" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Response Data:" -ForegroundColor Yellow
    $registerData | ConvertTo-Json -Depth 5 | Write-Host
    Write-Host ""
    
    if ($registerData.success -eq $true) {
        Write-Host "✅ TEST 1 PASSED: User registered successfully" -ForegroundColor Green
        
        # Extract tokens for next test
        $accessToken = $registerData.session.access_token
        $userId = $registerData.user.id
        $profileId = $registerData.profile.id
        
        Write-Host ""
        Write-Host "📝 Extracted Info:" -ForegroundColor Yellow
        Write-Host "   User ID: $userId" -ForegroundColor Gray
        Write-Host "   Profile ID: $profileId" -ForegroundColor Gray
        Write-Host "   Access Token: $($accessToken.Substring(0, 20))..." -ForegroundColor Gray
        
    } else {
        Write-Host "❌ TEST 1 FAILED: Registration returned success=false" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host "❌ TEST 1 FAILED: Registration request failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $errorResponse = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $errorBody = $reader.ReadToEnd()
        Write-Host "Error Body: $errorBody" -ForegroundColor Red
    }
    
    exit 1
}

Write-Host ""

# Test 2: Login with same credentials
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test 2: User Login (Same User)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$loginBody = @{
    email = $testEmail
    password = $testPassword
} | ConvertTo-Json

Write-Host "🚀 Sending login request..." -ForegroundColor Gray

try {
    $loginResponse = Invoke-WebRequest `
        -Uri $LOGIN_ENDPOINT `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body $loginBody `
        -ErrorAction Stop
    
    $loginData = $loginResponse.Content | ConvertFrom-Json
    
    Write-Host "✅ Login Status: $($loginResponse.StatusCode)" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Response Data:" -ForegroundColor Yellow
    $loginData | ConvertTo-Json -Depth 5 | Write-Host
    Write-Host ""
    
    if ($loginData.success -eq $true) {
        Write-Host "✅ TEST 2 PASSED: User logged in successfully" -ForegroundColor Green
    } else {
        Write-Host "❌ TEST 2 FAILED: Login returned success=false" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host "❌ TEST 2 FAILED: Login request failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 3: Register as Merchant
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test 3: Merchant Registration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$merchantRandom = Get-Random -Minimum 1000 -Maximum 9999
$merchantEmail = "merchant-fix-$merchantRandom@mbuy.com"
$merchantName = "Merchant Fix $merchantRandom"

$merchantBody = @{
    email = $merchantEmail
    password = $testPassword
    full_name = $merchantName
    role = "merchant"
} | ConvertTo-Json

Write-Host "🚀 Sending merchant registration request..." -ForegroundColor Gray
Write-Host "   Email: $merchantEmail" -ForegroundColor Gray

try {
    $merchantResponse = Invoke-WebRequest `
        -Uri $REGISTER_ENDPOINT `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body $merchantBody `
        -ErrorAction Stop
    
    $merchantData = $merchantResponse.Content | ConvertFrom-Json
    
    Write-Host "✅ Merchant Registration Status: $($merchantResponse.StatusCode)" -ForegroundColor Green
    Write-Host ""
    
    if ($merchantData.success -eq $true -and $merchantData.profile.role -eq "merchant") {
        Write-Host "✅ TEST 3 PASSED: Merchant registered with correct role" -ForegroundColor Green
        Write-Host "   Profile Role: $($merchantData.profile.role)" -ForegroundColor Gray
    } else {
        Write-Host "❌ TEST 3 FAILED: Merchant role not set correctly" -ForegroundColor Red
        Write-Host "   Expected: merchant" -ForegroundColor Red
        Write-Host "   Got: $($merchantData.profile.role)" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host "❌ TEST 3 FAILED: Merchant registration failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TEST SUMMARY  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Test 1: Customer Registration" -ForegroundColor Green
Write-Host "✅ Test 2: User Login" -ForegroundColor Green
Write-Host "✅ Test 3: Merchant Registration" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 ALL TESTS PASSED!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Test Users Created:" -ForegroundColor Yellow
Write-Host "   Customer: $testEmail" -ForegroundColor Gray
Write-Host "   Merchant: $merchantEmail" -ForegroundColor Gray
Write-Host "   Password: $testPassword" -ForegroundColor Gray
Write-Host ""
Write-Host "✅ Registration fix is working correctly!" -ForegroundColor Green
Write-Host ""
