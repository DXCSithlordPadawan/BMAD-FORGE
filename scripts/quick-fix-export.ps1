#Requires -Version 5.1
<#
.SYNOPSIS
    Quick Fix for BMAD Forge - Install Document Export Packages
.DESCRIPTION
    Installs python-docx and markdown packages required for DOCX and Markdown export
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
Write-Host "  BMAD Forge - Install Document Export Packages" -ForegroundColor Cyan
Write-Host "  Enables DOCX and Markdown Export" -ForegroundColor Cyan
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
$PythonExe = Join-Path $VenvPath "Scripts\python.exe"

if (!(Test-Path $PipExe)) {
    Write-Error "Virtual environment not found at: $VenvPath"
    Write-Host "Please run full deployment script first"
    exit 1
}

Write-Info "Found project at: $ProjectRoot"
Write-Info "Found virtual environment at: $VenvPath"

# Install python-docx
try {
    Write-Info "Installing python-docx for DOCX export..."
    & $PipExe install "python-docx>=1.1.0" --quiet
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "python-docx installed successfully!"
    } else {
        throw "pip install failed with exit code $LASTEXITCODE"
    }
} catch {
    Write-Error "Failed to install python-docx: $_"
    Write-Host "`nTry manual installation:"
    Write-Host "  cd $ProjectRoot"
    Write-Host "  .\venv\Scripts\pip.exe install python-docx"
    exit 1
}

# Install markdown
try {
    Write-Info "Installing markdown for Markdown export..."
    & $PipExe install "markdown>=3.5.0" --quiet
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "markdown installed successfully!"
    } else {
        throw "pip install failed with exit code $LASTEXITCODE"
    }
} catch {
    Write-Error "Failed to install markdown: $_"
    Write-Host "`nTry manual installation:"
    Write-Host "  cd $ProjectRoot"
    Write-Host "  .\venv\Scripts\pip.exe install markdown"
    exit 1
}

# Verify installations
Write-Info "Verifying installations..."
try {
    $docxVersion = & $PythonExe -c "import docx; print(docx.__version__)" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "python-docx verified! Version: $docxVersion"
    }
    
    $markdownVersion = & $PythonExe -c "import markdown; print(markdown.__version__)" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "markdown verified! Version: $markdownVersion"
    }
} catch {
    Write-Error "Verification failed: $_"
}

Write-Host "`n============================================================" -ForegroundColor Green
Write-Host "  Packages Installed Successfully!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "`nInstalled Packages:" -ForegroundColor White
Write-Host "  ✓ python-docx - For DOCX (Word) export"
Write-Host "  ✓ markdown - For Markdown export"

Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "  1. Restart your Django server (if running)"
Write-Host "  2. Generate a document"
Write-Host "  3. Click 'Download' button"
Write-Host "  4. Choose format:"
Write-Host "     - DOCX (Word document)"
Write-Host "     - Markdown (.md file)"
Write-Host "     - HTML (already available)"

Write-Host "`nTo restart server:"
Write-Host "  cd $ProjectRoot\webapp"
Write-Host "  ..\venv\Scripts\python.exe manage.py runserver 8000"

Write-Host "`nExport formats now available:"
Write-Host "  • HTML - Native format"
Write-Host "  • Markdown - Plain text with formatting"
Write-Host "  • DOCX - Microsoft Word format"
Write-Host "  • PDF - Not yet implemented (use DOCX and convert in Word)"
Write-Host ""
