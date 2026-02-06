# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BMAD Forge v3.0.0 is a Django-based document generation and management system. It provides a web interface for creating document templates (with Jinja2 syntax), generating documents via a wizard UI, and managing document lifecycles (draft → review → approved → published → archived). The deployment package targets Windows (IIS) but the Django app itself is platform-agnostic.

## Development Commands

```bash
# Setup (from project root, assumes Django project at C:\inetpub\bmad-forge\webapp or equivalent)
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install django jinja2 whitenoise

# Run migrations
python manage.py migrate

# Create admin user
python manage.py createsuperuser

# Start dev server
python manage.py runserver 8000

# Collect static files (required before production deployment)
python manage.py collectstatic --noinput

# Check deployment readiness
python manage.py check --deploy

# Run tests (architecture doc references pytest)
pytest --cov=forge --cov-report=html
pytest webapp/forge/tests/test_services.py::test_specific_test  # single test
```

Windows deployment uses PowerShell:
```powershell
# Full deployment
.\scripts\deploy.ps1 -CreateProject
# Verify deployment
.\scripts\test-deployment.ps1
```

## Architecture

### Core Application: `django_app/forge/`

The app follows Django MTV (Model-Template-View) with a dedicated document generation engine:

- **models.py** — Three models: `DocumentTemplate` (stores Jinja2 templates + JSON variable config), `GeneratedDocument` (generated output with status workflow and versioning via self-referential FK), `DocumentActivity` (audit log)
- **document_generator.py** — `DocumentGenerator` class renders Jinja2 templates with variable substitution, CSS wrapping, and JS injection. `TemplateValidator` validates syntax, CSS, and variable JSON schemas.
- **views.py** — 12 views: CRUD for templates/documents, wizard-based generation (login required), approval workflow, download (HTML/PDF/DOCX), plus two JSON API endpoints for template variables and validation
- **forms.py** — `DocumentTemplateForm` (with JSON validation), `GenerateDocumentForm` (dynamic field generation from template variables), `DocumentStatusForm`, `DocumentSearchForm`
- **urls.py** — App namespace is `forge`. Key URL patterns: `/templates/`, `/documents/`, `/api/templates/<id>/variables/`, `/api/validate/`

### Template Variable System

Templates define their input requirements as JSON in `DocumentTemplate.template_variables`. Each variable specifies type (`text`, `textarea`, `email`, `number`, `date`, `select`, `checkbox`), whether it's required, and choices for select types. The wizard UI dynamically generates form fields from this JSON config.

### Settings: `django_app/config/settings_addon.py`

This is a settings template, not a standalone settings file. It configures WhiteNoise for static files, SQLite by default (PostgreSQL commented out), file+console logging to `../logs/django.log`, and production security headers when `DEBUG=False`. Key env vars: `SECRET_KEY`, `DEBUG`, `ALLOWED_HOSTS`.

### Document Generation Flow

1. User selects template → wizard loads template variables via `/api/templates/<id>/variables/`
2. User fills form → POST to `/templates/<id>/generate/`
3. `DocumentGenerator` validates required variables, renders Jinja2 template, wraps with CSS/JS
4. `GeneratedDocument` saved with status `draft`, `DocumentActivity` logged

### Static Assets

- `forge/static/css/forge.css` — Custom styles
- `forge/static/js/wizard-editor.js` — Wizard functionality
- Frontend uses Bootstrap 5 via CDN

### Supplementary Content

- `templates/` — 15 markdown document templates (PRD, roadmap, backlog, etc.)
- `agents/` — 15 AI agent prompt files for BMAD framework roles
- `docs/` — Comprehensive documentation including architecture, security guide, IIS setup, deployment checklist
