# BMAD Forge Deployment Package v3.2.0 - File Manifest

## Package Structure

```
BMAD_FORGE_DEPLOYMENT_PACKAGE_v3.2.0/
│
├── scripts/
│   ├── deploy.ps1                      # Main deployment script
│   └── test-deployment.ps1             # Deployment verification script
│
├── django_app/
│   ├── forge/                          # Django application
│   │   ├── __init__.py                 # App initialization
│   │   ├── apps.py                     # App configuration
│   │   ├── models.py                   # Database models
│   │   ├── views.py                    # View logic
│   │   ├── forms.py                    # Form definitions
│   │   ├── urls.py                     # URL routing
│   │   ├── admin.py                    # Admin interface
│   │   ├── document_generator.py       # Document generation engine
│   │   │
│   │   ├── migrations/                 # Database migrations
│   │   │   └── __init__.py
│   │   │
│   │   ├── templates/forge/            # HTML templates
│   │   │   ├── base.html               # Base template
│   │   │   ├── index.html              # Homepage
│   │   │   ├── template_list.html      # Template listing
│   │   │   ├── template_detail.html    # Template details
│   │   │   ├── generate_document_wizard.html  # Document wizard
│   │   │   ├── document_list.html      # Document listing
│   │   │   └── document_detail.html    # Document details
│   │   │
│   │   └── static/                     # Static assets
│   │       ├── css/                    # Stylesheets
│   │       │   └── forge.css
│   │       └── js/                     # JavaScript
│   │           └── wizard-editor.js
│   │
│   └── config/
│       └── settings_addon.py           # Django settings template
│
├── docs/
│   ├── README.md                       # Main documentation
│   ├── IIS-Setup.md                    # IIS configuration guide
│   ├── Troubleshooting.md              # Troubleshooting guide
│   └── MANIFEST.md                     # This file
│
└── tests/
    └── test_deployment.py              # Python deployment tests
```

## File Descriptions

### Deployment Scripts

| File | Purpose | Required |
|------|---------|----------|
| `scripts/deploy.ps1` | Main PowerShell deployment script | Yes |
| `scripts/test-deployment.ps1` | Verify deployment success | Yes |

### Django Application Files

| File | Purpose | Required |
|------|---------|----------|
| `forge/__init__.py` | App package initialization | Yes |
| `forge/apps.py` | Django app configuration | Yes |
| `forge/models.py` | Database models for templates, documents, activities | Yes |
| `forge/views.py` | View functions and API endpoints | Yes |
| `forge/forms.py` | Django forms for user input | Yes |
| `forge/urls.py` | URL routing configuration | Yes |
| `forge/admin.py` | Django admin customization | Yes |
| `forge/document_generator.py` | Document generation engine | Yes |
| `forge/migrations/__init__.py` | Migrations package | Yes |

### Templates

| File | Purpose | Required |
|------|---------|----------|
| `templates/forge/base.html` | Base layout template | Yes |
| `templates/forge/index.html` | Homepage | Yes |
| `templates/forge/template_list.html` | Template browser | Yes |
| `templates/forge/template_detail.html` | Template details | Yes |
| `templates/forge/generate_document_wizard.html` | Document creation wizard | Yes |
| `templates/forge/document_list.html` | Document browser | Yes |
| `templates/forge/document_detail.html` | Document viewer | Yes |

### Static Files

| File | Purpose | Required |
|------|---------|----------|
| `static/css/forge.css` | Custom stylesheets | Optional |
| `static/js/wizard-editor.js` | Document wizard JavaScript | Optional |

### Documentation

| File | Purpose | Required |
|------|---------|----------|
| `docs/README.md` | Main documentation and quick start | Yes |
| `docs/IIS-Setup.md` | IIS production deployment guide | Yes |
| `docs/Troubleshooting.md` | Common issues and solutions | Recommended |
| `docs/MANIFEST.md` | This file - package contents | Reference |

### Configuration

| File | Purpose | Required |
|------|---------|----------|
| `config/settings_addon.py` | Django settings template | Reference |

## Dependencies

### Python Packages (installed by deployment script)
- django>=4.2,<5.0
- psycopg2-binary
- gunicorn
- whitenoise
- python-dotenv
- jinja2

### System Requirements
- Python 3.13.x
- PowerShell 5.1+
- Windows 10/11 or Server 2019/2022
- IIS 10.0+ (for production)

## Installation Files Created

The deployment script creates the following structure at the installation location:

```
C:\inetpub\bmad-forge/
├── webapp/
│   ├── bmad_forge/              # Django project (created by script)
│   │   ├── settings.py
│   │   ├── urls.py
│   │   ├── wsgi.py
│   │   └── asgi.py
│   │
│   ├── forge/                   # Copied from package
│   │   └── (all forge app files)
│   │
│   ├── static/                  # Static source files
│   ├── staticfiles/             # Collected static files
│   ├── media/                   # User uploads
│   ├── manage.py                # Django management
│   ├── db.sqlite3               # SQLite database
│   ├── .env                     # Environment variables
│   └── web.config               # IIS configuration
│
├── venv/                        # Python virtual environment
├── backup/                      # Deployment backups
├── logs/                        # Application logs
└── test-deployment.ps1          # Test script (copied)
```

## Checksum Verification

To verify package integrity, check file counts:

- Python files (.py): 9 files
- PowerShell scripts (.ps1): 2 files
- HTML templates (.html): 7 files
- Documentation files (.md): 4 files
- Configuration files: 1 file

Total core files: 23

## Version History

### v3.0.0 (Current)
- Complete deployment system refactor
- All required files included
- Enhanced error handling
- Comprehensive documentation
- Production-ready IIS configuration

### What's New in v3.2.0
- ✅ Complete Django app with all models, views, forms
- ✅ Document generation engine
- ✅ Full template system
- ✅ Activity logging and versioning
- ✅ Admin interface customization
- ✅ Static file handling with WhiteNoise
- ✅ Environment configuration
- ✅ Automated deployment script
- ✅ Testing and verification
- ✅ IIS production setup guide

## Support

For issues or questions:
1. Check docs/Troubleshooting.md
2. Review docs/README.md
3. Examine deployment logs in C:\inetpub\bmad-forge\logs

## License

Copyright © 2026 BMAD Forge
All rights reserved.
