#Requires -Version 5.1
<#
.SYNOPSIS
    Quick Fix for BMAD Forge - Copy Agents and Templates Folders
.DESCRIPTION
    Copies the agents and templates folders to the project root for
    the template auto-load feature to work correctly
.PARAMETER ProjectRoot
    Root installation directory (default: C:\inetpub\bmad-forge)
.PARAMETER PackageRoot
    Location of extracted deployment package (required)
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\inetpub\bmad-forge",
    [Parameter(Mandatory=$true)]
    [string]$PackageRoot
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
Write-Host "  BMAD Forge - Copy Agents & Templates Folders" -ForegroundColor Cyan
Write-Host "  Quick Fix Script" -ForegroundColor Cyan
Write-Host "============================================================`n" -ForegroundColor Cyan

# Validate project root
if (!(Test-Path $ProjectRoot)) {
    Write-Error "Project root not found: $ProjectRoot"
    Write-Host "Please specify correct path with -ProjectRoot parameter"
    exit 1
}

# Validate package root
if (!(Test-Path $PackageRoot)) {
    Write-Error "Package root not found: $PackageRoot"
    Write-Host "Please specify the extracted package location with -PackageRoot parameter"
    Write-Host "Example: .\quick-fix-folders.ps1 -PackageRoot C:\temp\bmad-forge-v3.1-autoload-package"
    exit 1
}

Write-Info "Project root: $ProjectRoot"
Write-Info "Package root: $PackageRoot"

# Copy agents folder
Write-Info "`nCopying agents folder..."
$agentsSource = Join-Path $PackageRoot "agents"
$agentsDest = Join-Path $ProjectRoot "agents"

if (!(Test-Path $agentsSource)) {
    Write-Error "Agents source folder not found: $agentsSource"
    Write-Host "Make sure you're pointing to the correct package root"
    exit 1
}

try {
    # Create destination if it doesn't exist
    if (!(Test-Path $agentsDest)) {
        New-Item -ItemType Directory -Path $agentsDest -Force | Out-Null
        Write-Info "Created agents directory"
    }
    
    # Copy all .md files
    $copiedCount = 0
    Get-ChildItem -Path $agentsSource -Filter "*.md" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $agentsDest -Force
        $copiedCount++
    }
    
    Write-Success "Copied $copiedCount agent prompt files to: $agentsDest"
} catch {
    Write-Error "Failed to copy agents: $_"
    exit 1
}

# Copy templates folder
Write-Info "`nCopying templates folder..."
$templatesSource = Join-Path $PackageRoot "templates"
$templatesDest = Join-Path $ProjectRoot "templates"

if (!(Test-Path $templatesSource)) {
    Write-Error "Templates source folder not found: $templatesSource"
    Write-Host "Make sure you're pointing to the correct package root"
    exit 1
}

try {
    # Create destination if it doesn't exist
    if (!(Test-Path $templatesDest)) {
        New-Item -ItemType Directory -Path $templatesDest -Force | Out-Null
        Write-Info "Created templates directory"
    }
    
    # Copy all .md files
    $copiedCount = 0
    Get-ChildItem -Path $templatesSource -Filter "*.md" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $templatesDest -Force
        $copiedCount++
    }
    
    Write-Success "Copied $copiedCount document template files to: $templatesDest"
} catch {
    Write-Error "Failed to copy templates: $_"
    exit 1
}

# Verify the auto-loader can find them
Write-Info "`nVerifying folder structure..."
$agentFiles = (Get-ChildItem -Path $agentsDest -Filter "*.md" -ErrorAction SilentlyContinue).Count
$templateFiles = (Get-ChildItem -Path $templatesDest -Filter "*.md" -ErrorAction SilentlyContinue).Count

Write-Host "`n============================================================" -ForegroundColor Green
Write-Host "  Copy Complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green

Write-Host "`nFolder Structure:" -ForegroundColor White
Write-Host "  $ProjectRoot\"
Write-Host "    ├── agents\        ($agentFiles files)"
Write-Host "    └── templates\     ($templateFiles files)"

Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "  1. Restart your Django server"
Write-Host "  2. On first startup, template auto-load will run"
Write-Host "  3. Check logs for: 'Template auto-load completed: 30 created'"
Write-Host "  4. Visit http://localhost:8000/forge/templates/"
Write-Host "  5. You should see 30 templates loaded"

Write-Host "`nTo restart server:"
Write-Host "  cd $ProjectRoot\webapp"
Write-Host "  ..\venv\Scripts\python.exe manage.py runserver 8000"

Write-Host "`nIf templates don't auto-load, run manually:"
Write-Host "  cd $ProjectRoot\webapp"
Write-Host "  ..\venv\Scripts\python.exe manage.py load_templates"
Write-Host ""
