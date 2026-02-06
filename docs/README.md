# BMAD Forge - Complete Deployment Package v3.2.0

## Overview

BMAD Forge is a Django-based document generation and management system designed for Windows environments with IIS deployment capabilities.

## Features

- 📝 **Template Management**: Create and manage document templates with dynamic variables
- 🔄 **Document Generation**: Generate documents from templates with user-provided data
- 📊 **Document Tracking**: Track document status, versions, and activity history
- 👥 **User Management**: Role-based access control and audit logging
- 🎨 **Rich Editor**: Wizard-based document generation interface
- 📦 **Export Formats**: Export documents in HTML, PDF, and DOCX formats

## System Requirements

### Minimum Requirements
- **Operating System**: Windows 10/11 or Windows Server 2019/2022
- **Python**: Python 3.13.x (from Microsoft Store or python.org)
- **RAM**: 4GB minimum, 8GB recommended
- **Disk Space**: 500MB for application + space for generated documents
- **Database**: SQLite (included) or PostgreSQL 12+ (recommended for production)

### Optional Components
- **IIS**: 10.0+ (for production deployment)
- **PostgreSQL**: 12+ (recommended for production)
- **wkhtmltopdf**: For PDF generation
- **python-docx**: For DOCX export

## Quick Start

### 1. Download and Extract

Extract the deployment package to a temporary location:
```
C:\BMAD_FORGE_DEPLOYMENT_PACKAGE_v3.0\
```

### 2. Run Deployment Script

Open PowerShell as Administrator and run:

```powershell
cd C:\BMAD_FORGE_DEPLOYMENT_PACKAGE_v3.0\scripts
.\deploy.ps1 -CreateProject
```

### 3. Test Installation

After deployment completes:

```powershell
cd C:\inetpub\bmad-forge
.\test-deployment.ps1
```

### 4. Access Application

Open your browser and navigate to:
```
http://localhost:8000
```

## Deployment Options

### Development Deployment

For testing and development:

```powershell
.\deploy.ps1 -CreateProject
```

This creates a development environment with:
- SQLite database
- DEBUG mode enabled
- Development server on port 8000

### Production Deployment

For production with IIS:

```powershell
.\deploy.ps1 -CreateProject -ProductionMode
```

This configures:
- Production settings (DEBUG=False)
- Static files collection
- Security configurations
- Database connection setup

See [IIS-Setup.md](IIS-Setup.md) for IIS configuration.

## Deployment Script Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-ProjectRoot` | Installation directory | `C:\inetpub\bmad-forge` |
| `-PythonCommand` | Python executable name | `python3.13` |
| `-CreateProject` | Create new Django project | `$false` |
| `-ProductionMode` | Configure for production | `$false` |
| `-SkipBackup` | Skip backup creation | `$false` |
| `-DevServerPort` | Dev server port | `8000` |

### Examples

**Custom installation path:**
```powershell
.\deploy.ps1 -ProjectRoot "D:\apps\bmad-forge" -CreateProject
```

**Production with custom port:**
```powershell
.\deploy.ps1 -CreateProject -ProductionMode -DevServerPort 8080
```

**Skip backup for fresh install:**
```powershell
.\deploy.ps1 -CreateProject -SkipBackup
```

## Directory Structure

After deployment:

```
C:\inetpub\bmad-forge\
├── webapp/                 # Django application
│   ├── bmad_forge/         # Project settings
│   ├── forge/              # Main app
│   │   ├── migrations/     # Database migrations
│   │   ├── templates/      # HTML templates
│   │   ├── static/         # Static files
│   │   ├── models.py       # Data models
│   │   ├── views.py        # View logic
│   │   ├── forms.py        # Form definitions
│   │   └── document_generator.py  # Document engine
│   ├── static/             # Static source files
│   ├── staticfiles/        # Collected static files
│   ├── media/              # User uploads
│   └── manage.py           # Django management
├── venv/                   # Python virtual environment
├── backup/                 # Deployment backups
├── logs/                   # Application logs
├── .env                    # Environment configuration
└── test-deployment.ps1     # Testing script
```

## Configuration

### Environment Variables

Edit `C:\inetpub\bmad-forge\webapp\.env`:

```env
# Django Configuration
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1,your-domain.com

# Database Configuration (PostgreSQL)
DATABASE_URL=postgresql://user:password@localhost:5432/bmad_forge

# Static Files
STATIC_URL=/static/
STATIC_ROOT=C:\inetpub\bmad-forge\webapp\staticfiles

# Media Files
MEDIA_URL=/media/
MEDIA_ROOT=C:\inetpub\bmad-forge\webapp\media
```

### Django Settings

The deployment script automatically configures:
- ✅ Adds 'forge' to INSTALLED_APPS
- ✅ Configures static files with WhiteNoise
- ✅ Sets up media files directory
- ✅ Configures URL routing for the forge app
- ✅ Creates main project URLs with redirect to /forge/
- ✅ Creates forge app URLs with all endpoints

No manual URL configuration is needed - the application is ready to use after deployment!

## Database Setup

### SQLite (Default)

SQLite is configured automatically for development.

### PostgreSQL (Recommended for Production)

1. Install PostgreSQL
2. Create database:
   ```sql
   CREATE DATABASE bmad_forge;
   CREATE USER bmad_user WITH PASSWORD 'secure_password';
   GRANT ALL PRIVILEGES ON DATABASE bmad_forge TO bmad_user;
   ```

3. Update `.env`:
   ```env
   DATABASE_URL=postgresql://bmad_user:secure_password@localhost:5432/bmad_forge
   ```

4. Run migrations:
   ```powershell
   cd C:\inetpub\bmad-forge\webapp
   C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py migrate
   ```

## Creating Admin User

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py createsuperuser
```

Follow the prompts to create your admin account.

## Running the Application

### Development Server

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py runserver 8000
```

Access at: http://localhost:8000

### Production with IIS

See [IIS-Setup.md](IIS-Setup.md) for complete IIS configuration.

## Common Tasks

### Collect Static Files

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py collectstatic --noinput
```

### Run Migrations

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py makemigrations
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py migrate
```

### Backup Database

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py dumpdata > backup.json
```

### Restore Database

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py loaddata backup.json
```

## Troubleshooting

### Python Not Found

Ensure Python 3.13 is installed and accessible from PowerShell:
```powershell
python3.13 --version
```

If not found, install from Microsoft Store or python.org.

### Virtual Environment Issues

Recreate virtual environment:
```powershell
cd C:\inetpub\bmad-forge
Remove-Item -Recurse -Force venv
python3.13 -m venv venv
.\venv\Scripts\Activate.ps1
pip install django psycopg2-binary gunicorn whitenoise python-dotenv jinja2
```

### Static Files Not Loading

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py collectstatic --clear --noinput
```

### Database Migration Errors

Reset migrations (WARNING: Data loss):
```powershell
cd C:\inetpub\bmad-forge\webapp
# Delete db.sqlite3 or drop PostgreSQL database
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py migrate --run-syncdb
```

### Permission Errors

Run PowerShell as Administrator and check folder permissions:
```powershell
icacls C:\inetpub\bmad-forge /grant IIS_IUSRS:F /T
```

## Security Checklist

For production deployment:

- [ ] Set `DEBUG=False` in `.env`
- [ ] Generate new `SECRET_KEY`
- [ ] Configure `ALLOWED_HOSTS` properly
- [ ] Use PostgreSQL instead of SQLite
- [ ] Enable HTTPS in IIS
- [ ] Set up regular backups
- [ ] Configure firewall rules
- [ ] Review user permissions
- [ ] Enable logging and monitoring
- [ ] Keep Python and Django updated

## Support and Documentation

- **Django Documentation**: https://docs.djangoproject.com/
- **Python Documentation**: https://docs.python.org/3.13/
- **IIS Configuration**: See [IIS-Setup.md](IIS-Setup.md)
- **Troubleshooting**: See [Troubleshooting.md](Troubleshooting.md)

## Version History

### v3.0.0 (Current)
- Complete refactor of deployment system
- Improved error handling and validation
- Enhanced Django app with full CRUD operations
- Document versioning and activity tracking
- Rich text editor integration
- Comprehensive documentation

### v2.0.0
- Initial Django implementation
- Basic template management
- Document generation wizard

## License

Copyright © 2026 BMAD Forge
All rights reserved.
