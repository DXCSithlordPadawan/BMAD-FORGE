#Requires -Version 5.1
<#
.SYNOPSIS
    Quick Fix for BMAD Forge Authentication Redirect Issue
.DESCRIPTION
    Fixes the 404 error when trying to generate documents by updating
    authentication settings in Django configuration
.PARAMETER ProjectRoot
    Root installation directory (default: C:\inetpub\bmad-forge)
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\inetpub\bmad-forge"
)

$ErrorActionPreference = "Stop"

function Write-Success($message) {
    Write-Host "[OK] " -NoNewline -ForegroundColor Green
    Write-Host $message
}

function Write-Info($message) {
    Write-Host "[INFO] " -NoNewline -ForegroundColor Cyan
    Write-Host $message
}

function Write-Error($message) {
    Write-Host "[ERROR] " -NoNewline -ForegroundColor Red
    Write-Host $message
}

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "  BMAD Forge v3.1.2 - Authentication Fix Script" -ForegroundColor Cyan
Write-Host "  Fixing Login Redirect 404 Error" -ForegroundColor Cyan
Write-Host "============================================================`n" -ForegroundColor Cyan

# Check if project exists
$WebAppPath = Join-Path $ProjectRoot "webapp"
if (!(Test-Path $WebAppPath)) {
    Write-Error "Web application not found at: $WebAppPath"
    Write-Host "Please specify correct path with -ProjectRoot parameter"
    exit 1
}

$SettingsFile = Join-Path $WebAppPath "config\settings.py"
$UrlsFile = Join-Path $WebAppPath "config\urls.py"

Write-Info "Found project at: $ProjectRoot"

# Backup files
$BackupSuffix = (Get-Date -Format "yyyyMMdd_HHmmss")
Write-Info "Creating backups..."

try {
    Copy-Item $SettingsFile "$SettingsFile.backup_$BackupSuffix"
    Copy-Item $UrlsFile "$UrlsFile.backup_$BackupSuffix"
    Write-Success "Backups created"
} catch {
    Write-Error "Failed to create backups: $_"
    exit 1
}

# Fix settings.py
Write-Info "Updating settings.py..."
try {
    $content = Get-Content $SettingsFile -Raw
    
    # Check if already fixed
    if ($content -match "LOGIN_REDIRECT_URL") {
        Write-Info "Settings already contain LOGIN_REDIRECT_URL - skipping"
    } else {
        # Add LOGIN_REDIRECT_URL and LOGOUT_REDIRECT_URL after LOGIN_URL
        $content = $content -replace `
            "(LOGIN_URL = '/admin/login/')", `
            "`$1`n`n# Authentication Redirects`nLOGIN_REDIRECT_URL = '/forge/'`nLOGOUT_REDIRECT_URL = '/forge/'"
        
        Set-Content -Path $SettingsFile -Value $content -NoNewline
        Write-Success "Updated settings.py"
    }
} catch {
    Write-Error "Failed to update settings.py: $_"
    Write-Host "Restoring backup..."
    Copy-Item "$SettingsFile.backup_$BackupSuffix" $SettingsFile -Force
    exit 1
}

# Fix urls.py
Write-Info "Updating urls.py..."
try {
    $content = Get-Content $UrlsFile -Raw
    
    # Check if already fixed
    if ($content -match "RedirectView") {
        Write-Info "URLs already contain RedirectView - skipping"
    } else {
        # Add RedirectView import
        $content = $content -replace `
            "(from django.urls import path, include)", `
            "`$1`nfrom django.views.generic import RedirectView"
        
        # Add root URL redirect
        $content = $content -replace `
            "(urlpatterns = \[`n    path\('admin/')", `
            "urlpatterns = [`n    path('', RedirectView.as_view(url='/forge/', permanent=False), name='home'),`n    path('admin/'"
        
        Set-Content -Path $UrlsFile -Value $content -NoNewline
        Write-Success "Updated urls.py"
    }
} catch {
    Write-Error "Failed to update urls.py: $_"
    Write-Host "Restoring backups..."
    Copy-Item "$SettingsFile.backup_$BackupSuffix" $SettingsFile -Force
    Copy-Item "$UrlsFile.backup_$BackupSuffix" $UrlsFile -Force
    exit 1
}

Write-Host "`n============================================================" -ForegroundColor Green
Write-Host "  Fix Applied Successfully!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green

Write-Host "`nChanges Made:" -ForegroundColor White
Write-Host "  1. Added LOGIN_REDIRECT_URL = '/forge/' to settings.py"
Write-Host "  2. Added LOGOUT_REDIRECT_URL = '/forge/' to settings.py"
Write-Host "  3. Added root URL redirect in urls.py"

Write-Host "`nBackups Created:" -ForegroundColor White
Write-Host "  - $SettingsFile.backup_$BackupSuffix"
Write-Host "  - $UrlsFile.backup_$BackupSuffix"

Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "  1. Restart your Django server (no migration needed)"
Write-Host "  2. Visit http://localhost:8000/forge/templates/"
Write-Host "  3. Click 'Generate Document' on any template"
Write-Host "  4. Should redirect to /admin/login/ (not /accounts/login/)"
Write-Host "  5. Log in and you'll return to document generation"

Write-Host "`nTo restart server:"
Write-Host "  cd $WebAppPath"
Write-Host "  ..\venv\Scripts\python.exe manage.py runserver 8000"

Write-Host "`nIf you need to rollback:"
Write-Host "  Copy-Item '$SettingsFile.backup_$BackupSuffix' '$SettingsFile' -Force"
Write-Host "  Copy-Item '$UrlsFile.backup_$BackupSuffix' '$UrlsFile' -Force"
Write-Host ""
