# BMAD Forge Deployment Agent Template

## Agent Overview

**Agent Name:** BMAD Forge Deployment Specialist  
**Version:** 3.0.0  
**Purpose:** Automated deployment and configuration of BMAD Forge Django application on Windows  
**Target Platform:** Windows 10/11, Windows Server 2019/2022  

---

## Agent Capabilities

### Primary Functions

1. **Environment Validation**
   - Verify Python installation (3.13+)
   - Check PowerShell version (5.1+)
   - Validate disk space requirements
   - Confirm administrator privileges

2. **Automated Deployment**
   - Create directory structure
   - Set up Python virtual environment
   - Install dependencies
   - Create Django project
   - Deploy application code
   - Configure settings

3. **Configuration Management**
   - Generate .env file with secrets
   - Configure Django settings.py
   - Set up static files
   - Configure database connections
   - Create web.config for IIS

4. **Testing & Verification**
   - Run Django system checks
   - Verify database migrations
   - Test static file collection
   - Validate application structure
   - Generate test reports

5. **Documentation Generation**
   - Create deployment summary
   - Generate configuration reference
   - Produce troubleshooting guide
   - Generate command reference

---

## Agent Workflow

```
┌─────────────────────────────────────────────────────────┐
│  PHASE 1: Pre-Deployment Validation                    │
│  • Check prerequisites                                  │
│  • Validate environment                                 │
│  • Display configuration summary                        │
│  • Request confirmation                                 │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  PHASE 2: Environment Setup                             │
│  • Create directory structure                           │
│  • Create virtual environment                           │
│  • Install Python dependencies                          │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  PHASE 3: Application Deployment                        │
│  • Create/verify Django project                         │
│  • Deploy forge application                             │
│  • Configure settings                                   │
│  • Create .env file                                     │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  PHASE 4: Django Configuration                          │
│  • Run database migrations                              │
│  • Collect static files                                 │
│  • Create test script                                   │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│  PHASE 5: Verification & Reporting                      │
│  • Run system checks                                    │
│  • Generate deployment report                           │
│  • Display next steps                                   │
│  • Create summary documentation                         │
└─────────────────────────────────────────────────────────┘
```

---

## Agent Parameters

### Required Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `ProjectRoot` | String | Installation directory | `C:\inetpub\bmad-forge` |
| `PythonCommand` | String | Python executable name | `python3.13` |

### Optional Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `CreateProject` | Switch | Create new Django project | `false` |
| `ProductionMode` | Switch | Configure for production | `false` |
| `SkipBackup` | Switch | Skip backup creation | `false` |
| `DevServerPort` | Integer | Development server port | `8000` |

---

## Agent Decision Logic

### Virtual Environment Creation

```
IF venv exists AND python.exe exists THEN
    Use existing virtual environment
ELSE IF venv exists BUT python.exe missing THEN
    Remove incomplete venv
    Create new virtual environment
ELSE
    Create new virtual environment
END IF
```

### Django Project Creation

```
IF CreateProject = true THEN
    IF manage.py exists THEN
        Error: Project already exists
    ELSE
        Create new Django project
        Configure forge app
    END IF
ELSE IF CreateProject = false THEN
    IF manage.py exists THEN
        Use existing project
        Verify forge app exists
    ELSE
        Error: Project not found and CreateProject not specified
    END IF
END IF
```

### Settings Configuration

```
IF 'forge' NOT IN INSTALLED_APPS THEN
    Add 'forge' to INSTALLED_APPS
END IF

IF STATIC_ROOT not configured THEN
    Add static files configuration
    Configure WhiteNoise
END IF

IF WhiteNoise middleware not present THEN
    Add WhiteNoise to MIDDLEWARE
END IF
```

---

## Agent Error Handling

### Python Not Found
```powershell
ERROR: Python verification failed
ACTION: Install Python 3.13 from Microsoft Store or python.org
STATUS: Exit with code 1
```

### Virtual Environment Creation Failed
```powershell
ERROR: Failed to create virtual environment
TROUBLESHOOTING:
  1. Ensure Python is properly installed
  2. Try: python3.13 -m venv C:\temp\test-venv
  3. Check execution policy: Get-ExecutionPolicy
STATUS: Exit with code 1
```

### Django Project Not Found
```powershell
ERROR: manage.py not found
ACTION: Specify -CreateProject parameter to create new project
STATUS: Exit with code 1
```

### Static Files Collection Failed
```powershell
ERROR: collectstatic command failed
CAUSE: STATIC_ROOT not properly configured
ACTION: Reconfigure settings.py
STATUS: Continue with warning
```

---

## Agent Output

### Success Output

```
============================================================
  BMAD Forge - Complete Windows Deployment v3.0.0
============================================================

Deployment Summary
------------------
Completed: 12 / 12 steps

[OK] Create Directory Structure (0.5s)
[OK] Verify Python Installation (0.3s)
[OK] Create Virtual Environment (5.2s)
[OK] Install Python Dependencies (45.1s)
[OK] Create Django Project (2.3s)
[OK] Deploy Django App Files (1.1s)
[OK] Configure Django Settings (0.8s)
[OK] Run Django Management Commands (8.4s)
[OK] Create Environment File (0.2s)
[OK] Production Mode Configuration (0.5s)
[OK] Create Test Script (0.1s)
[OK] Generate Documentation (0.3s)

Installation Path: C:\inetpub\bmad-forge
Django Project:    C:\inetpub\bmad-forge\webapp
Virtual Env:       C:\inetpub\bmad-forge\venv

Next Steps
----------
1. Test the installation:
   .\test-deployment.ps1

2. Create superuser:
   cd C:\inetpub\bmad-forge\webapp
   C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py createsuperuser

3. Start development server:
   C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py runserver 8000

4. Access the application:
   http://localhost:8000

✅ Deployment completed successfully!
```

### Error Output Example

```
[ERROR] Failed: Install Python Dependencies
Traceback:
  pip install django>=4.2,<5.0 failed with exit code 1
  
Troubleshooting:
  1. Check internet connection
  2. Verify pip is working: pip --version
  3. Try manual installation: pip install django
  4. Check firewall/proxy settings

Deployment Status: FAILED
Review errors above and retry deployment
```

---

## Agent Logging

### Log Levels

- **INFO**: Normal operational messages
- **WARN**: Non-critical issues that don't stop deployment
- **ERROR**: Critical failures that stop deployment
- **SUCCESS**: Step completion confirmations

### Log Location

```
C:\inetpub\bmad-forge\logs\deployment_YYYYMMDD_HHMMSS.log
```

### Log Format

```
[2026-02-05 10:30:15] [INFO] Starting deployment
[2026-02-05 10:30:15] [INFO] Python version: Python 3.13.9
[2026-02-05 10:30:20] [INFO] Virtual environment created
[2026-02-05 10:31:05] [WARN] Static files not collected
[2026-02-05 10:31:10] [SUCCESS] Deployment completed
```

---

## Agent Integration

### Calling the Agent

```powershell
# Basic deployment
.\scripts\deploy.ps1 -CreateProject

# Custom location
.\scripts\deploy.ps1 -ProjectRoot "D:\apps\bmad" -CreateProject

# Production deployment
.\scripts\deploy.ps1 -CreateProject -ProductionMode

# Skip backup
.\scripts\deploy.ps1 -CreateProject -SkipBackup
```

### Agent as Module

```powershell
# Import agent functions
. .\scripts\deploy.ps1

# Call individual functions
$config = Initialize-DeploymentConfiguration
Test-Prerequisites $config
Deploy-Application $config
```

---

## Agent Maintenance

### Version Updates

When updating the agent:
1. Update `$DeploymentVersion` variable
2. Update documentation
3. Add new parameters to param block
4. Update help documentation
5. Test on clean Windows installation

### Testing Checklist

- [ ] Fresh Windows 10 installation
- [ ] Fresh Windows 11 installation
- [ ] Windows Server 2019
- [ ] Windows Server 2022
- [ ] With existing venv
- [ ] With existing Django project
- [ ] Production mode
- [ ] Custom paths
- [ ] Network restrictions

---

## Agent Documentation

- **README.md**: Quick start guide
- **DEPLOYMENT_COMPLETE.md**: Detailed deployment guide
- **Troubleshooting.md**: Common issues and solutions
- **IIS-Setup.md**: Production configuration

---

**Agent Template Version:** 1.0  
**Last Updated:** February 5, 2026  
**Maintained By:** BMAD Forge Development Team
