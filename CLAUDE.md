# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**BMAD Forge v3.1+** is a Django 5.x-based document generation and management system designed for the BMAD (Breakthrough Method for Agile AI-Driven Development) Framework. It provides a comprehensive web interface for:

- **Creating and managing document templates** with Jinja2/HTML or Markdown support
- **Generating documents via an intuitive wizard UI** with dynamic form field generation
- **Managing document lifecycles** through a complete workflow (draft → review → approved → published → archived)
- **Supporting BMAD agent roles and workflow phases** with multi-role template associations
- **Exporting documents** in multiple formats (HTML, Markdown with YAML frontmatter, DOCX)
- **Tracking document history** with activity logging and version control

The application follows Django MTV (Model-Template-View) architecture with Bootstrap 5 for the frontend. While the deployment package targets Windows (IIS), the Django app itself is platform-agnostic and can run on Linux/macOS.

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

- **models.py** — Three core models:
  - `DocumentTemplate`: Stores templates (Jinja2/HTML or Markdown) with JSON variable config, BMAD metadata (agent_role, agent_roles JSONField for multi-role support, workflow_phase, category, template_type), and source file tracking
  - `GeneratedDocument`: Generated output with status workflow (draft/review/approved/published/archived), versioning via self-referential FK, file management fields, and audit metadata
  - `DocumentActivity`: Complete audit log for all document lifecycle events
  
- **document_generator.py** — Dual-path document generation:
  - `DocumentGenerator`: Detects template type (markdown vs HTML), handles variable substitution (both `[VAR]` and `{{VAR}}` syntax), renders Jinja2 templates for HTML, converts markdown to HTML, wraps with CSS/JS
  - `TemplateValidator`: Validates Jinja2 syntax, variable JSON schemas (supports multiselect type), extracts variables from templates
  
- **views.py** — 12 views organized by functionality:
  - Homepage with role/phase statistics
  - Template management (list, detail, CRUD via admin)
  - Document generation wizard (login required)
  - Document lifecycle management (view, approve, download in multiple formats, delete)
  - Two JSON API endpoints: `/api/templates/<id>/variables/` and `/api/validate/`
  
- **forms.py** — Four form classes:
  - `DocumentTemplateForm`: Template creation with JSON validation
  - `GenerateDocumentForm`: Dynamic field generation from template variables (supports 8 field types)
  - `DocumentStatusForm`: Status workflow management
  - `DocumentSearchForm`: Advanced filtering
  
- **urls.py** — App namespace is `forge`. Key URL patterns: `/`, `/templates/`, `/documents/`, `/api/`

- **management/commands/load_templates.py** — Automates loading of BMAD templates from `templates/` and `agents/` directories with YAML frontmatter parsing, role normalization, and idempotent updates

### Template Variable System

Templates define their input requirements as JSON in `DocumentTemplate.template_variables`. Each variable specifies:
- **type**: `text`, `textarea`, `email`, `number`, `date`, `select`, `checkbox`, `multiselect`
- **required**: Boolean indicating if field is mandatory
- **label**: Human-readable field label
- **help_text**: Optional guidance text
- **choices**: Array of options for select/multiselect types

The wizard UI (`generate_document_wizard.html`) dynamically generates form fields from this JSON config using `GenerateDocumentForm.__init__()`.

Example:
```json
{
  "project_name": {
    "type": "text",
    "required": true,
    "label": "Project Name",
    "help_text": "Enter the name of your project"
  },
  "framework": {
    "type": "select",
    "required": true,
    "label": "Framework",
    "choices": ["React", "Vue", "Angular"]
  },
  "features": {
    "type": "multiselect",
    "required": false,
    "label": "Features",
    "choices": ["Authentication", "API", "Database", "Testing"]
  }
}
```

### Settings: `django_app/config/settings_addon.py`

This is a settings template, not a standalone settings file. It configures WhiteNoise for static files, SQLite by default (PostgreSQL commented out), file+console logging to `../logs/django.log`, and production security headers when `DEBUG=False`. Key env vars: `SECRET_KEY`, `DEBUG`, `ALLOWED_HOSTS`.

### Document Generation Flow

1. **Selection**: User browses templates (filterable by role, phase, type) and clicks "Generate"
2. **Wizard Loading**: GET `/templates/<id>/generate/` loads wizard with dynamic form fields
3. **Form Display**: Template variables rendered as appropriate field types (text, select, date, etc.)
4. **User Input**: User fills form fields with required data
5. **Submission**: POST to `/templates/<id>/generate/` with form data
6. **Processing**: 
   - `GenerateDocumentForm` validates user input
   - `DocumentGenerator` detects template type (markdown vs HTML)
   - For markdown: applies `[VAR]` and `{{VAR}}` substitution, converts to HTML
   - For HTML/Jinja2: renders template with Jinja2 engine, wraps with CSS/JS
7. **Storage**: `GeneratedDocument` created with status `draft`, activity logged
8. **Redirect**: User redirected to document detail page for preview/download

**Export Flow**:
- HTML: Wrapped content with inline styles
- Markdown: Original markdown with YAML frontmatter and metadata footer
- DOCX: HTML-to-Word conversion with inline styles preserved

### Static Assets

- `forge/static/css/` — Custom CSS (currently minimal, Bootstrap 5 provides most styling)
- `forge/static/js/` — JavaScript for interactive features (currently minimal, relying on Bootstrap JS)
- Frontend uses Bootstrap 5.3.0 via CDN with custom color scheme for status/role/phase badges
- Responsive grid layout (3-col → 2-col → 1-col based on viewport)
- No external JS libraries beyond Bootstrap bundle (includes Popper.js)

### Supplementary Content

- `templates/` — 15 markdown document templates (PRD, roadmap, backlog, technical specs, etc.)
- `agents/` — 15 AI agent prompt files for BMAD framework roles (orchestrator, analyst, PM, architect, etc.)
- `docs/` — Comprehensive documentation:
  - `ARCHITECTURE.md` — System design and data models
  - `USER_GUIDE.md` — End-user documentation
  - `SECURITY_GUIDE.md` — Security considerations
  - `UX_Design.md` — Complete UX/UI design specifications
  - `IIS-Setup.md` — Windows IIS deployment
  - `DEPLOYMENT_CHECKLIST.md` — Production deployment steps
  - Plus dependency analysis, template autoload docs, and Django 6 upgrade plan

## Current Implementation Status

### ✅ Implemented Features
- Template management with role/phase/type filtering
- Document generation wizard with dynamic forms (8 field types)
- Document lifecycle workflow (draft → review → approved → published → archived)
- Multi-role template support (agent_roles JSONField)
- Activity audit logging with full history
- Document versioning with parent-child relationships
- Export in multiple formats (HTML, Markdown, DOCX)
- Template import from file upload with YAML frontmatter parsing
- Search and filtering across templates and documents
- Admin interface with bulk actions

### ⚠️ Partially Implemented
- Real-time validation (client-side only, no async API calls)
- BMAD compliance checking (basic variable detection, not full framework validation)
- PDF export (marked as "Coming Soon" in UI)

### ❌ Not Yet Implemented
- GitHub repository synchronization for template import
- Section-based wizard (current implementation is field-based)
- BMAD compliance scoring engine
- Content quality suggestions
- Public URL sharing without authentication
- CSV/JSON bulk export
- Role auto-detection from filename/content analysis
