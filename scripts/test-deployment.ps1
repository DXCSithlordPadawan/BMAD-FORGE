# Test BMAD Forge Deployment
# This script verifies the deployment was successful

param(
    [string]$ProjectRoot = "C:\inetpub\bmad-forge"
)

$ErrorActionPreference = "Continue"
$WebAppPath = Join-Path $ProjectRoot "webapp"
$VenvPath = Join-Path $ProjectRoot "venv"
$PythonExe = Join-Path $VenvPath "Scripts\python.exe"

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "  BMAD Forge Deployment Test" -ForegroundColor Cyan
Write-Host "============================================================`n" -ForegroundColor Cyan

$testResults = @()

# Test 1: Check directory structure
Write-Host "[TEST] Checking directory structure..." -ForegroundColor Yellow
$requiredDirs = @($ProjectRoot, $WebAppPath, $VenvPath)
$dirTest = $true
foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Host "  [OK] $dir" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing: $dir" -ForegroundColor Red
        $dirTest = $false
    }
}
$testResults += @{Name="Directory Structure"; Pass=$dirTest}

# Test 2: Check Python
Write-Host "`n[TEST] Checking Python installation..." -ForegroundColor Yellow
if (Test-Path $PythonExe) {
    $pythonVersion = & $PythonExe --version 2>&1
    Write-Host "  [OK] Python found: $pythonVersion" -ForegroundColor Green
    $testResults += @{Name="Python"; Pass=$true}
} else {
    Write-Host "  [FAIL] Python not found at: $PythonExe" -ForegroundColor Red
    $testResults += @{Name="Python"; Pass=$false}
}

# Test 3: Check Django installation
Write-Host "`n[TEST] Checking Django installation..." -ForegroundColor Yellow
try {
    Push-Location $WebAppPath
    $djangoVersion = & $PythonExe -m django --version 2>&1
    Write-Host "  [OK] Django version: $djangoVersion" -ForegroundColor Green
    $testResults += @{Name="Django"; Pass=$true}
} catch {
    Write-Host "  [FAIL] Django not properly installed" -ForegroundColor Red
    $testResults += @{Name="Django"; Pass=$false}
} finally {
    Pop-Location
}

# Test 4: Check Django project
Write-Host "`n[TEST] Checking Django project..." -ForegroundColor Yellow
$manageScript = Join-Path $WebAppPath "manage.py"
if (Test-Path $manageScript) {
    Write-Host "  [OK] manage.py found" -ForegroundColor Green
    
    # Run Django check
    try {
        Push-Location $WebAppPath
        $checkOutput = & $PythonExe manage.py check 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Django check passed" -ForegroundColor Green
            $testResults += @{Name="Django Project"; Pass=$true}
        } else {
            Write-Host "  [WARN] Django check had issues:" -ForegroundColor Yellow
            Write-Host $checkOutput
            $testResults += @{Name="Django Project"; Pass=$false}
        }
    } catch {
        Write-Host "  [FAIL] Error running Django check: $_" -ForegroundColor Red
        $testResults += @{Name="Django Project"; Pass=$false}
    } finally {
        Pop-Location
    }
} else {
    Write-Host "  [FAIL] manage.py not found" -ForegroundColor Red
    $testResults += @{Name="Django Project"; Pass=$false}
}

# Test 5: Check forge app
Write-Host "`n[TEST] Checking forge app..." -ForegroundColor Yellow
$forgeAppPath = Join-Path $WebAppPath "forge"
if (Test-Path $forgeAppPath) {
    $forgeFiles = @("__init__.py", "models.py", "views.py", "urls.py")
    $forgeTest = $true
    foreach ($file in $forgeFiles) {
        $filePath = Join-Path $forgeAppPath $file
        if (Test-Path $filePath) {
            Write-Host "  [OK] $file found" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] Missing: $file" -ForegroundColor Red
            $forgeTest = $false
        }
    }
    $testResults += @{Name="Forge App"; Pass=$forgeTest}
} else {
    Write-Host "  [FAIL] Forge app directory not found" -ForegroundColor Red
    $testResults += @{Name="Forge App"; Pass=$false}
}

# Test 5b: Check URL configuration
Write-Host "`n[TEST] Checking URL configuration..." -ForegroundColor Yellow
$urlsConfigured = $true

# Check main URLs
$mainUrlsFile = Join-Path $WebAppPath "bmad_forge\urls.py"
if (Test-Path $mainUrlsFile) {
    $mainUrlsContent = Get-Content $mainUrlsFile -Raw
    if ($mainUrlsContent -match "forge.urls") {
        Write-Host "  [OK] Main URLs include forge app" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Main URLs don't include forge app" -ForegroundColor Yellow
        $urlsConfigured = $false
    }
} else {
    Write-Host "  [FAIL] Main URLs file not found" -ForegroundColor Red
    $urlsConfigured = $false
}

# Check forge URLs
$forgeUrlsFile = Join-Path $WebAppPath "forge\urls.py"
if (Test-Path $forgeUrlsFile) {
    Write-Host "  [OK] Forge URLs file exists" -ForegroundColor Green
} else {
    Write-Host "  [WARN] Forge URLs file not found" -ForegroundColor Yellow
    $urlsConfigured = $false
}

$testResults += @{Name="URL Configuration"; Pass=$urlsConfigured}

# Test 6: Check database
Write-Host "`n[TEST] Checking database..." -ForegroundColor Yellow
$dbPath = Join-Path $WebAppPath "db.sqlite3"
if (Test-Path $dbPath) {
    Write-Host "  [OK] Database file found" -ForegroundColor Green
    $testResults += @{Name="Database"; Pass=$true}
} else {
    Write-Host "  [WARN] Database not initialized. Run migrations." -ForegroundColor Yellow
    $testResults += @{Name="Database"; Pass=$false}
}

# Test 7: Check static files
Write-Host "`n[TEST] Checking static files..." -ForegroundColor Yellow
$staticFilesPath = Join-Path $WebAppPath "staticfiles"
if (Test-Path $staticFilesPath) {
    $fileCount = (Get-ChildItem -Path $staticFilesPath -Recurse -File).Count
    Write-Host "  [OK] Static files directory found ($fileCount files)" -ForegroundColor Green
    $testResults += @{Name="Static Files"; Pass=$true}
} else {
    Write-Host "  [WARN] Static files not collected. Run collectstatic." -ForegroundColor Yellow
    $testResults += @{Name="Static Files"; Pass=$false}
}

# Test 8: Check environment file
Write-Host "`n[TEST] Checking environment configuration..." -ForegroundColor Yellow
$envFile = Join-Path $WebAppPath ".env"
if (Test-Path $envFile) {
    Write-Host "  [OK] .env file found" -ForegroundColor Green
    $testResults += @{Name="Environment Config"; Pass=$true}
} else {
    Write-Host "  [WARN] .env file not found" -ForegroundColor Yellow
    $testResults += @{Name="Environment Config"; Pass=$false}
}

# Summary
Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "  Test Summary" -ForegroundColor Cyan
Write-Host "============================================================`n" -ForegroundColor Cyan

$passedCount = ($testResults | Where-Object { $_.Pass }).Count
$totalCount = $testResults.Count

foreach ($result in $testResults) {
    $status = if ($result.Pass) { "[PASS]" } else { "[FAIL]" }
    $color = if ($result.Pass) { "Green" } else { "Red" }
    Write-Host "$status " -NoNewline -ForegroundColor $color
    Write-Host $result.Name
}

Write-Host "`nTotal: $passedCount / $totalCount tests passed" -ForegroundColor $(if ($passedCount -eq $totalCount) { "Green" } else { "Yellow" })

if ($passedCount -eq $totalCount) {
    Write-Host "`n[SUCCESS] All tests passed! Deployment is ready." -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Create superuser:" -ForegroundColor White
    Write-Host "   cd $WebAppPath" -ForegroundColor Gray
    Write-Host "   $PythonExe manage.py createsuperuser" -ForegroundColor Gray
    Write-Host "`n2. Start development server:" -ForegroundColor White
    Write-Host "   $PythonExe manage.py runserver 8000" -ForegroundColor Gray
    Write-Host "`n3. Access application at: http://localhost:8000" -ForegroundColor White
} else {
    Write-Host "`n[WARNING] Some tests failed. Review errors above." -ForegroundColor Yellow
    Write-Host "`nTroubleshooting:" -ForegroundColor Cyan
    Write-Host "- Run migrations: $PythonExe manage.py migrate" -ForegroundColor Gray
    Write-Host "- Collect static files: $PythonExe manage.py collectstatic" -ForegroundColor Gray
    Write-Host "- Check Django configuration: $PythonExe manage.py check" -ForegroundColor Gray
}

Write-Host ""
