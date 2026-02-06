#Requires -Version 5.1
<#
.SYNOPSIS
    Quick Fix for BMAD Forge v3.1.0 - Install Missing PyYAML
.DESCRIPTION
    Installs the missing PyYAML dependency for the template auto-load feature
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
Write-Host "  BMAD Forge v3.1.0 - Quick Fix Script" -ForegroundColor Cyan
Write-Host "  Installing Missing PyYAML Dependency" -ForegroundColor Cyan
Write-Host "============================================================`n" -ForegroundColor Cyan

# Check if project exists
if (!(Test-Path $ProjectRoot)) {
    Write-Error "Project root not found: $ProjectRoot"
    Write-Host "Please specify correct path with -ProjectRoot parameter"
    exit 1
}

# Check virtual environment
$VenvPath = Join-Path $ProjectRoot "venv"
$PipExe = Join-Path $VenvPath "Scripts\pip.exe"

if (!(Test-Path $PipExe)) {
    Write-Error "Virtual environment not found at: $VenvPath"
    Write-Host "Please run full deployment script first"
    exit 1
}

Write-Info "Found project at: $ProjectRoot"
Write-Info "Found virtual environment at: $VenvPath"

# Install PyYAML
try {
    Write-Info "Installing PyYAML..."
    & $PipExe install pyyaml>=6.0.0 --quiet
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "PyYAML installed successfully!"
    } else {
        throw "pip install failed with exit code $LASTEXITCODE"
    }
} catch {
    Write-Error "Failed to install PyYAML: $_"
    Write-Host "`nTry manual installation:"
    Write-Host "  cd $ProjectRoot"
    Write-Host "  .\venv\Scripts\pip.exe install pyyaml"
    exit 1
}

# Verify installation
try {
    Write-Info "Verifying installation..."
    $PythonExe = Join-Path $VenvPath "Scripts\python.exe"
    $verification = & $PythonExe -c "import yaml; print(yaml.__version__)" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Verification successful! PyYAML version: $verification"
    } else {
        Write-Error "Verification failed"
    }
} catch {
    Write-Error "Verification failed: $_"
}

Write-Host "`n============================================================" -ForegroundColor Green
Write-Host "  Fix Applied Successfully!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "  1. Restart your Django server"
Write-Host "  2. Check logs for 'Template auto-load completed'"
Write-Host "  3. Visit http://localhost:8000/forge/templates/"
Write-Host "`nTo start server:"
Write-Host "  cd $ProjectRoot\webapp"
Write-Host "  ..\venv\Scripts\python.exe manage.py runserver 8000"
Write-Host ""
