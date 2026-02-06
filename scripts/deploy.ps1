#Requires -Version 5.1
<#
.SYNOPSIS
    BMAD Forge Complete Deployment Script v3.0.0
.DESCRIPTION
    Deploys Django-based BMAD Forge application on Windows with IIS
.PARAMETER ProjectRoot
    Root installation directory (default: C:\inetpub\bmad-forge)
.PARAMETER PythonCommand
    Python executable to use (default: python3.13)
.PARAMETER CreateProject
    Create new Django project if it doesn't exist
.PARAMETER ProductionMode
    Deploy in production mode with IIS configuration
.PARAMETER SkipBackup
    Skip backup creation
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\inetpub\bmad-forge",
    [string]$PythonCommand = "python3.13",
    [switch]$CreateProject,
    [switch]$ProductionMode,
    [switch]$SkipBackup,
    [int]$DevServerPort = 8000
)

# Script configuration
$ErrorActionPreference = "Stop"
$DeploymentVersion = "3.0.0"
$ScriptRoot = Split-Path -Parent $PSCommandPath
$PackageRoot = Split-Path -Parent $ScriptRoot

# Color output functions
function Write-Header($message) {
    Write-Host "`n============================================================" -ForegroundColor Cyan
    Write-Host "  $message" -ForegroundColor Cyan
    Write-Host "============================================================`n" -ForegroundColor Cyan
}

function Write-Step($message) {
    Write-Host "[STEP] " -NoNewline -ForegroundColor Yellow
    Write-Host "====== $message ======" -ForegroundColor White
}

function Write-Success($message) {
    Write-Host "[OK] " -NoNewline -ForegroundColor Green
    Write-Host $message
}

function Write-Info($message) {
    Write-Host "[INFO] " -NoNewline -ForegroundColor Cyan
    Write-Host $message
}

function Write-Warning($message) {
    Write-Host "[WARN] " -NoNewline -ForegroundColor Yellow
    Write-Host $message
}

function Write-Error($message) {
    Write-Host "[ERROR] " -NoNewline -ForegroundColor Red
    Write-Host $message
}

# Path configuration
$WebAppPath = Join-Path $ProjectRoot "webapp"
$VenvPath = Join-Path $ProjectRoot "venv"
$PythonExe = Join-Path $VenvPath "Scripts\python.exe"  # Always python.exe in venv
$BackupPath = Join-Path $ProjectRoot "backup"
$LogPath = Join-Path $ProjectRoot "logs"

# Display configuration
Write-Header "BMAD Forge - Complete Windows Deployment v$DeploymentVersion"
Write-Host "Configuration:" -ForegroundColor White
Write-Host "  Project Root:     $ProjectRoot"
Write-Host "  Web App Path:     $WebAppPath"
Write-Host "  Virtual Env:      $VenvPath"
Write-Host "  Python:           $PythonCommand"
Write-Host "  Create Project:   $CreateProject"
Write-Host "  Production Mode:  $ProductionMode"
Write-Host "  Dev Server Port:  $DevServerPort"
Write-Host ""

# Confirm deployment
$confirm = Read-Host "Continue with deployment? (Y/n)"
if ($confirm -eq "n" -or $confirm -eq "N") {
    Write-Warning "Deployment cancelled by user"
    exit 0
}

# Deployment steps tracking
$deploymentSteps = @()
$currentStep = 0

function Start-DeploymentStep {
    param([string]$StepName)
    $script:currentStep++
    Write-Step $StepName
    return @{
        Name = $StepName
        StartTime = Get-Date
        Success = $false
    }
}

function Complete-DeploymentStep {
    param($StepInfo, [bool]$Success = $true)
    $StepInfo.Success = $Success
    $StepInfo.EndTime = Get-Date
    $StepInfo.Duration = ($StepInfo.EndTime - $StepInfo.StartTime).TotalSeconds
    $script:deploymentSteps += $StepInfo
    
    if ($Success) {
        Write-Success "Completed: $($StepInfo.Name)"
    } else {
        Write-Error "Failed: $($StepInfo.Name)"
    }
    return $Success
}

# === STEP 1: Create Directory Structure ===
$step = Start-DeploymentStep "Create Directory Structure"
try {
    Write-Info "Creating directories..."
    $directories = @(
        $ProjectRoot,
        $WebAppPath,
        $VenvPath,
        $BackupPath,
        $LogPath,
        (Join-Path $ProjectRoot "agents"),
        (Join-Path $ProjectRoot "templates"),
        (Join-Path $WebAppPath "static"),
        (Join-Path $WebAppPath "staticfiles"),
        (Join-Path $WebAppPath "media"),
        (Join-Path $WebAppPath "templates")
    )
    
    foreach ($dir in $directories) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    Write-Info "Directories created successfully"
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Failed to create directories: $_"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 2: Verify Python Installation ===
$step = Start-DeploymentStep "Verify Python Installation"
try {
    $pythonVersion = & $PythonCommand --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Python not found or not working"
    }
    Write-Info "Python version: $pythonVersion"
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Python verification failed: $_"
    Write-Error "Please install Python 3.13 from the Microsoft Store or python.org"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 3: Create Virtual Environment ===
$step = Start-DeploymentStep "Create Virtual Environment"
try {
    $pythonExeInVenv = Join-Path $VenvPath "Scripts\python.exe"
    
    # Check if venv exists AND has python.exe
    if ((Test-Path $VenvPath) -and (Test-Path $pythonExeInVenv)) {
        Write-Info "Virtual environment already exists and is valid"
    } else {
        # Remove incomplete venv if it exists
        if (Test-Path $VenvPath) {
            Write-Info "Removing incomplete virtual environment..."
            Remove-Item -Path $VenvPath -Recurse -Force
        }
        
        Write-Info "Creating virtual environment..."
        & $PythonCommand -m venv $VenvPath
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create virtual environment"
        }
        
        # Verify Python exists in venv
        if (!(Test-Path $pythonExeInVenv)) {
            throw "Python executable not found in virtual environment after creation"
        }
        
        Write-Info "Virtual environment created successfully"
    }
    
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Virtual environment creation failed: $_"
    Write-Error "Troubleshooting:"
    Write-Error "  1. Ensure Python 3.13 is properly installed"
    Write-Error "  2. Try: python3.13 -m venv C:\temp\test-venv"
    Write-Error "  3. Check Windows execution policy: Get-ExecutionPolicy"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 4: Install Python Dependencies ===
$step = Start-DeploymentStep "Install Python Dependencies"
try {
    $pipExe = Join-Path $VenvPath "Scripts\pip.exe"
    
    Write-Info "Upgrading pip..."
    & $PythonExe -m pip install --upgrade pip --quiet
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Pip upgrade had issues, continuing anyway..."
    }
    
    Write-Info "Installing Django and dependencies..."
    $dependencies = @(
        "django>=4.2,<5.0",
        "psycopg2-binary",
        "gunicorn",
        "whitenoise",
        "python-dotenv",
        "jinja2",
        "pyyaml",
        "python-docx",
        "markdown"
    )
    
    foreach ($dep in $dependencies) {
        Write-Info "Installing $dep..."
        & $pipExe install $dep --quiet
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install $dep"
        }
    }
    
    Write-Info "All dependencies installed"
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Dependency installation failed: $_"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 5: Create or Verify Django Project ===
$step = Start-DeploymentStep "Create/Verify Django Project"
try {
    $manageScript = Join-Path $WebAppPath "manage.py"
    $pythonVenv = Join-Path $VenvPath "Scripts\python.exe"
    
    if (!(Test-Path $manageScript)) {
        if ($CreateProject) {
            Write-Info "Creating Django project..."
            Push-Location $ProjectRoot
            & $pythonVenv -m django startproject bmad_forge $WebAppPath
            Pop-Location
            
            if (!(Test-Path $manageScript)) {
                throw "Django project creation failed"
            }
            Write-Info "Django project created"
        } else {
            throw "Django project not found and -CreateProject not specified"
        }
    } else {
        Write-Info "Django project found at: $WebAppPath"
    }
    
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Django project setup failed: $_"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 6: Create Backup ===
if (!$SkipBackup) {
    $step = Start-DeploymentStep "Create Backup"
    try {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupDir = Join-Path $BackupPath "backup_$timestamp"
        
        if (Test-Path $WebAppPath) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
            
            $filesToBackup = @(
                (Join-Path $WebAppPath "bmad_forge\settings.py"),
                (Join-Path $WebAppPath "bmad_forge\urls.py"),
                (Join-Path $WebAppPath "manage.py")
            )
            
            $backedUpCount = 0
            foreach ($file in $filesToBackup) {
                if (Test-Path $file) {
                    $relativePath = $file.Replace($WebAppPath, "").TrimStart('\')
                    $destPath = Join-Path $backupDir $relativePath
                    $destDir = Split-Path -Parent $destPath
                    
                    if (!(Test-Path $destDir)) {
                        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                    }
                    
                    Copy-Item -Path $file -Destination $destPath -Force
                    $backedUpCount++
                }
            }
            
            Write-Info "Backup created: $backupDir ($backedUpCount files)"
        } else {
            Write-Info "No existing installation to backup"
        }
        
        Complete-DeploymentStep $step $true
    } catch {
        Write-Warning "Backup failed: $_"
        Complete-DeploymentStep $step $false
    }
}

# === STEP 7: Deploy Django App Files ===
$step = Start-DeploymentStep "Deploy Django App Files"
try {
    Write-Info "Deploying Django app files..."
    
    $djangoAppSource = Join-Path $PackageRoot "django_app\forge"
    $djangoAppDest = Join-Path $WebAppPath "forge"
    
    if (Test-Path $djangoAppSource) {
        # Create forge app directory
        if (!(Test-Path $djangoAppDest)) {
            New-Item -ItemType Directory -Path $djangoAppDest -Force | Out-Null
        }
        
        # Copy all Python files
        Get-ChildItem -Path $djangoAppSource -Recurse -File | ForEach-Object {
            $relativePath = $_.FullName.Replace($djangoAppSource, "").TrimStart('\')
            $destPath = Join-Path $djangoAppDest $relativePath
            $destDir = Split-Path -Parent $destPath
            
            if (!(Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            
            Copy-Item -Path $_.FullName -Destination $destPath -Force
        }
        
        Write-Info "Django app deployed successfully"
    } else {
        Write-Warning "Django app source not found at: $djangoAppSource"
    }
    
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Django app deployment failed: $_"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 7.5: Copy Agents and Templates Folders ===
$step = Start-DeploymentStep "Copy Agents and Templates for Auto-Load"
try {
    Write-Info "Copying agents and templates folders..."
    
    # Copy agents folder
    $agentsSource = Join-Path $PackageRoot "agents"
    $agentsDest = Join-Path $ProjectRoot "agents"
    
    if (Test-Path $agentsSource) {
        if (!(Test-Path $agentsDest)) {
            New-Item -ItemType Directory -Path $agentsDest -Force | Out-Null
        }
        
        Get-ChildItem -Path $agentsSource -Filter "*.md" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $agentsDest -Force
        }
        
        $agentCount = (Get-ChildItem -Path $agentsDest -Filter "*.md").Count
        Write-Info "Copied $agentCount agent prompt files"
    } else {
        Write-Warning "Agents folder not found at: $agentsSource"
    }
    
    # Copy templates folder
    $templatesSource = Join-Path $PackageRoot "templates"
    $templatesDest = Join-Path $ProjectRoot "templates"
    
    if (Test-Path $templatesSource) {
        if (!(Test-Path $templatesDest)) {
            New-Item -ItemType Directory -Path $templatesDest -Force | Out-Null
        }
        
        Get-ChildItem -Path $templatesSource -Filter "*.md" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $templatesDest -Force
        }
        
        $templateCount = (Get-ChildItem -Path $templatesDest -Filter "*.md").Count
        Write-Info "Copied $templateCount document template files"
    } else {
        Write-Warning "Templates folder not found at: $templatesSource"
    }
    
    Write-Success "Agents and templates ready for auto-load feature"
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Failed to copy agents/templates: $_"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 8: Configure Django Settings ===
$step = Start-DeploymentStep "Configure Django Settings"
try {
    $settingsFile = Join-Path $WebAppPath "bmad_forge\settings.py"
    $configTemplate = Join-Path $PackageRoot "django_app\config\settings_addon.py"
    
    Write-Info "Configuring Django settings..."
    
    if (Test-Path $settingsFile) {
        $settings = Get-Content $settingsFile -Raw
        
        # Check if forge app is in INSTALLED_APPS
        if ($settings -notmatch "'forge'") {
            Write-Info "Adding 'forge' to INSTALLED_APPS..."
            $settings = $settings -replace "(INSTALLED_APPS\s*=\s*\[)", "`$1`n    'forge',"
        }
        
        # Check if static configuration exists
        if ($settings -notmatch "STATIC_ROOT") {
            Write-Info "Adding static files configuration..."
            
            $staticConfig = @"

# Static files configuration
import os

STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]

# WhiteNoise configuration
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# Media files configuration
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
"@
            $settings += $staticConfig
        }
        
        # Check if WhiteNoise middleware is configured
        if ($settings -notmatch "whitenoise.middleware.WhiteNoiseMiddleware") {
            Write-Info "Adding WhiteNoise middleware..."
            $settings = $settings -replace "(MIDDLEWARE\s*=\s*\[[^\]]*'django.middleware.security.SecurityMiddleware',)", "`$1`n    'whitenoise.middleware.WhiteNoiseMiddleware',"
        }
        
        # Save modified settings
        $settings | Set-Content $settingsFile -NoNewline
        Write-Info "Django settings configured successfully"
    } else {
        throw "Settings file not found: $settingsFile"
    }
    
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Settings configuration failed: $_"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 8b: Configure Django URLs ===
$step = Start-DeploymentStep "Configure Django URLs"
try {
    Write-Info "Configuring URL routing..."
    
    # Configure main project URLs
    $mainUrlsFile = Join-Path $WebAppPath "bmad_forge\urls.py"
    if (Test-Path $mainUrlsFile) {
        $mainUrlsContent = @"
from django.contrib import admin
from django.urls import path, include
from django.views.generic import RedirectView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', RedirectView.as_view(url='/forge/', permanent=False)),
    path('forge/', include('forge.urls')),
]
"@
        $mainUrlsContent | Set-Content $mainUrlsFile -NoNewline
        Write-Info "Main URLs configured"
    }
    
    # Configure forge app URLs
    $forgeUrlsFile = Join-Path $WebAppPath "forge\urls.py"
    if (!(Test-Path $forgeUrlsFile)) {
        Write-Info "Creating forge URLs..."
        $forgeUrlsContent = @"
from django.urls import path
from . import views

app_name = 'forge'

urlpatterns = [
    path('', views.index, name='index'),
    path('templates/', views.template_list, name='template_list'),
    path('templates/<int:template_id>/', views.template_detail, name='template_detail'),
    path('templates/<int:template_id>/generate/', views.generate_document, name='generate_document'),
    path('documents/', views.document_list, name='document_list'),
    path('documents/<int:document_id>/', views.document_detail, name='document_detail'),
    path('documents/<int:document_id>/approve/', views.document_approve, name='document_approve'),
    path('documents/<int:document_id>/download/<str:format>/', views.document_download, name='document_download'),
    path('api/templates/<int:template_id>/variables/', views.api_template_variables, name='api_template_variables'),
    path('api/validate/', views.api_validate_document, name='api_validate_document'),
]
"@
        $forgeUrlsContent | Set-Content $forgeUrlsFile -NoNewline
        Write-Info "Forge URLs created"
    } else {
        Write-Info "Forge URLs already exist"
    }
    
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "URL configuration failed: $_"
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 9: Run Django Management Commands ===
$step = Start-DeploymentStep "Run Django Management Commands"
try {
    $pythonVenv = Join-Path $VenvPath "Scripts\python.exe"
    $manageScript = Join-Path $WebAppPath "manage.py"
    
    Push-Location $WebAppPath
    
    Write-Info "Running makemigrations..."
    & $pythonVenv $manageScript makemigrations
    
    Write-Info "Running migrate..."
    & $pythonVenv $manageScript migrate
    
    Write-Info "Collecting static files..."
    & $pythonVenv $manageScript collectstatic --noinput
    
    Pop-Location
    
    Write-Info "Django management commands completed"
    Complete-DeploymentStep $step $true
} catch {
    Write-Error "Django management commands failed: $_"
    Pop-Location
    Complete-DeploymentStep $step $false
    exit 1
}

# === STEP 10: Create Environment File ===
$step = Start-DeploymentStep "Create Environment File"
try {
    $envFile = Join-Path $WebAppPath ".env"
    
    if (!(Test-Path $envFile)) {
        Write-Info "Creating .env file..."
        
        # Generate a random secret key
        $secretKey = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 50 | ForEach-Object {[char]$_})
        
        $envContent = @"
# Django Configuration
SECRET_KEY=$secretKey
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Configuration (PostgreSQL)
# DATABASE_URL=postgresql://user:password@localhost:5432/bmad_forge

# Static Files
STATIC_URL=/static/
STATIC_ROOT=$WebAppPath\staticfiles

# Media Files
MEDIA_URL=/media/
MEDIA_ROOT=$WebAppPath\media
"@
        
        $envContent | Set-Content $envFile
        Write-Info ".env file created"
    } else {
        Write-Info ".env file already exists"
    }
    
    Complete-DeploymentStep $step $true
} catch {
    Write-Warning ".env file creation failed: $_"
    Complete-DeploymentStep $step $false
}

# === STEP 11: Production Mode Configuration ===
if ($ProductionMode) {
    $step = Start-DeploymentStep "Configure Production Mode"
    try {
        Write-Info "Configuring for production..."
        
        # Update .env for production
        $envFile = Join-Path $WebAppPath ".env"
        if (Test-Path $envFile) {
            $envContent = Get-Content $envFile -Raw
            $envContent = $envContent -replace "DEBUG=True", "DEBUG=False"
            $envContent | Set-Content $envFile
        }
        
        Write-Info "Production mode configured"
        Write-Warning "Remember to:"
        Write-Warning "  1. Set up IIS Application Pool"
        Write-Warning "  2. Configure IIS site"
        Write-Warning "  3. Set ALLOWED_HOSTS in .env"
        Write-Warning "  4. Configure PostgreSQL database"
        
        Complete-DeploymentStep $step $true
    } catch {
        Write-Error "Production configuration failed: $_"
        Complete-DeploymentStep $step $false
    }
}

# === STEP 12: Create Test Script ===
$step = Start-DeploymentStep "Create Test Script"
try {
    $testScript = Join-Path $ProjectRoot "test-deployment.ps1"
    $testScriptContent = @"
# Test BMAD Forge Deployment
`$pythonVenv = "$VenvPath\Scripts\python.exe"
`$manageScript = "$WebAppPath\manage.py"

Write-Host "Testing Django installation..." -ForegroundColor Cyan
Push-Location $WebAppPath

Write-Host "Checking Django version..."
& `$pythonVenv -m django --version

Write-Host "Running Django check..."
& `$pythonVenv `$manageScript check

Write-Host "Testing development server (Ctrl+C to stop)..."
& `$pythonVenv `$manageScript runserver $DevServerPort

Pop-Location
"@
    
    $testScriptContent | Set-Content $testScript
    Write-Info "Test script created: $testScript"
    
    Complete-DeploymentStep $step $true
} catch {
    Write-Warning "Test script creation failed: $_"
    Complete-DeploymentStep $step $false
}

# === Deployment Summary ===
Write-Header "Deployment Summary"

$successCount = ($deploymentSteps | Where-Object { $_.Success }).Count
$totalCount = $deploymentSteps.Count

Write-Host "Completed: $successCount / $totalCount steps`n" -ForegroundColor $(if ($successCount -eq $totalCount) { "Green" } else { "Yellow" })

foreach ($step in $deploymentSteps) {
    $status = if ($step.Success) { "[OK]" } else { "[FAILED]" }
    $color = if ($step.Success) { "Green" } else { "Red" }
    $duration = [math]::Round($step.Duration, 2)
    
    Write-Host "$status " -NoNewline -ForegroundColor $color
    Write-Host "$($step.Name) " -NoNewline
    Write-Host "($duration s)" -ForegroundColor Gray
}

Write-Host "`nInstallation Path: $ProjectRoot" -ForegroundColor Cyan
Write-Host "Django Project:    $WebAppPath" -ForegroundColor Cyan
Write-Host "Virtual Env:       $VenvPath`n" -ForegroundColor Cyan

Write-Header "Next Steps"
Write-Host "1. Test the installation:"
Write-Host "   .\test-deployment.ps1`n"
Write-Host "2. Start development server:"
Write-Host "   cd $WebAppPath"
Write-Host "   $VenvPath\Scripts\python.exe manage.py runserver $DevServerPort`n"
Write-Host "3. Access the application:"
Write-Host "   http://localhost:$DevServerPort`n"

if ($ProductionMode) {
    Write-Host "4. Configure IIS for production deployment"
    Write-Host "   See docs\IIS-Setup.md for instructions`n"
}

Write-Success "Deployment completed successfully!"
