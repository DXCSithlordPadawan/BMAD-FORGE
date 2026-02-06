# BMAD Forge Architecture Documentation

## System Overview

**BMAD Forge** is a Django-based web application for managing and generating structured prompts for the BMAD (Business, Mission, Analysis, Design) Framework. It provides a user-friendly interface for accessing prompt templates from GitHub repositories and generating customized prompts for various agent roles and workflow phases.

## Technology Stack

### Backend
- **Framework:** Django 5.2.10 (LTS)
- **Language:** Python 3.13
- **WSGI Server:** gunicorn (production)
- **Database:** SQLite (development), PostgreSQL (production)
- **Caching:** Redis (production)

### Frontend
- **Template Engine:** Django Templates
- **CSS Framework:** Bootstrap 5
- **Forms:** django-widget-tweaks
- **JavaScript:** Vanilla JS (minimal)

### External Services
- **GitHub API:** Template repository access
- **Anthropic API:** Claude AI integration (optional)

### Infrastructure
- **Static Files:** WhiteNoise (production)
- **Monitoring:** Sentry (error tracking)
- **Security:** Django CSP, Permissions Policy

## Application Structure

```
bmad-forge-deployment-v3/
├── django_app/                      # Django project root
│   ├── manage.py                    # Django management script
│   ├── config/                      # Project configuration
│   │   ├── __init__.py
│   │   ├── settings.py              # Django settings
│   │   ├── settings_addon.py        # Settings template (reference)
│   │   └── urls.py                  # Root URL routing
│   └── forge/                       # Main application
│       ├── __init__.py
│       ├── apps.py                  # App configuration
│       ├── models.py                # Data models (3 models)
│       ├── views.py                 # View functions (12 views)
│       ├── forms.py                 # Form definitions (4 forms)
│       ├── document_generator.py    # Document generation engine
│       ├── urls.py                  # App URL routing
│       ├── admin.py                 # Admin interface
│       ├── migrations/              # Database migrations
│       │   ├── __init__.py
│       │   └── 0001_initial.py
│       ├── management/              # Management commands
│       │   ├── __init__.py
│       │   └── commands/
│       │       ├── __init__.py
│       │       └── load_templates.py  # BMAD template loader
│       ├── templates/forge/         # HTML templates (7 files)
│       └── static/                  # CSS, JS assets
├── templates/                       # 15 BMAD document templates (.md)
├── agents/                          # 15 BMAD agent prompts (.md)
├── docs/                            # Documentation
├── scripts/                         # Deployment scripts (PowerShell)
└── archimate/                       # Architecture modeling docs
```

## Data Models

### DocumentTemplate

Stores document templates and BMAD agent prompts with metadata for role/phase filtering.

```python
class DocumentTemplate(models.Model):
    # Core fields
    name = CharField(max_length=200, unique=True)
    document_type = CharField(max_length=50, choices=DOCUMENT_TYPES, default='other')
    description = TextField(blank=True)
    template_content = TextField()          # Jinja2/HTML or Markdown body
    css_content = TextField(blank=True)     # Optional CSS styling
    js_content = TextField(blank=True)      # Optional JavaScript
    template_variables = TextField(blank=True)  # JSON variable definitions

    # BMAD fields
    agent_role = CharField(max_length=50, choices=AGENT_ROLES, blank=True)
    agent_roles = JSONField(default=list, blank=True)  # Full list of roles
    workflow_phase = CharField(max_length=50, choices=WORKFLOW_PHASES, blank=True)
    category = CharField(max_length=100, blank=True)
    template_type = CharField(max_length=20, choices=TEMPLATE_TYPES, default='template')
    source_file = CharField(max_length=255, blank=True, unique=True, null=True)

    # Metadata
    created_at = DateTimeField(auto_now_add=True)
    updated_at = DateTimeField(auto_now=True)
    created_by = ForeignKey(User, on_delete=SET_NULL, null=True)
    is_active = BooleanField(default=True)
```

**Choice Constants:**
- `AGENT_ROLES`: orchestrator, analyst, pm, architect, scrum_master, developer, qa
- `WORKFLOW_PHASES`: planning, development
- `TEMPLATE_TYPES`: template (Document Template), agent (Agent Prompt)

**Helper Methods:** `has_role(role)`, `get_roles_display()`, `get_roles_list()`

**Indexes:**
- Composite index on `(agent_role, workflow_phase)` for filtered listing

### GeneratedDocument

Documents generated from templates, with status workflow and versioning.

```python
class GeneratedDocument(models.Model):
    template = ForeignKey(DocumentTemplate, on_delete=PROTECT)
    title = CharField(max_length=300)
    status = CharField(max_length=20, choices=STATUS_CHOICES, default='draft')
    content = TextField()                    # Generated HTML content
    variables_used = TextField(blank=True)   # JSON of variables used

    # File management
    file_name = CharField(max_length=255, blank=True)
    file_path = CharField(max_length=500, blank=True)
    file_size = IntegerField(null=True)

    # Metadata & versioning
    created_at = DateTimeField(auto_now_add=True)
    updated_at = DateTimeField(auto_now=True)
    created_by = ForeignKey(User, on_delete=SET_NULL, null=True)
    reviewed_by = ForeignKey(User, on_delete=SET_NULL, null=True, blank=True)
    review_date = DateTimeField(null=True, blank=True)
    version = IntegerField(default=1)
    parent_document = ForeignKey('self', on_delete=SET_NULL, null=True, blank=True)
```

**Status Workflow:** draft → review → approved → published → archived

**Indexes:**
- `(status, created_at)` - Status-filtered listings
- `(template, status)` - Template-specific document queries

### DocumentActivity

Audit log for all document lifecycle events.

```python
class DocumentActivity(models.Model):
    document = ForeignKey(GeneratedDocument, on_delete=CASCADE)
    activity_type = CharField(max_length=20, choices=ACTIVITY_TYPES)
    description = TextField(blank=True)
    user = ForeignKey(User, on_delete=SET_NULL, null=True)
    timestamp = DateTimeField(auto_now_add=True)
    metadata = TextField(blank=True)  # JSON
```

**Activity Types:** created, updated, reviewed, approved, published, archived, downloaded, deleted

## Service Layer

### DocumentGenerator (`document_generator.py`)

Core document generation engine with dual-path rendering.

**Responsibilities:**
- Detect template type (markdown vs Jinja2/HTML) via `source_file` field
- Variable substitution (bracket `[VAR]` and brace `{{VAR}}` syntax)
- Jinja2 template rendering for HTML templates
- Markdown-to-HTML rendering for BMAD templates (using `markdown` library)
- CSS/JS wrapping for HTML templates
- Variable validation

**Key Methods:**
```python
class DocumentGenerator:
    def generate(self, variables: dict) -> str:
        """Generate document — branches on markdown vs Jinja2 path"""

    def _process_markdown_template(self, content: str, variables: dict) -> str:
        """Bracket/brace substitution + markdown.markdown() rendering"""

    def _process_template(self, template_content: str, variables: dict) -> str:
        """Jinja2 template rendering"""

class TemplateValidator:
    def validate_template_syntax(template_content: str) -> tuple:
        """Validate Jinja2 syntax"""

    def validate_variables(variables_json: dict) -> tuple:
        """Validate variable JSON schema (supports multiselect type)"""

    def extract_variables_from_template(template_content: str) -> set:
        """Extract {{VAR}} and [VAR] patterns from template"""
```

### load_templates Management Command

Loads 30 BMAD markdown files into the database from `templates/` and `agents/` directories.

**Responsibilities:**
- Parse YAML frontmatter using `yaml.safe_load`
- Normalize roles: handles both `role: pm` and `roles: [pm, analyst]`
- Normalize variables: maps `description` → `label`, `options` → `choices`, `input_type` → `type`
- Idempotent loading via `update_or_create(source_file=...)`
- Handle duplicate names by appending filename stem

**Usage:**
```bash
python manage.py load_templates              # Load all templates
python manage.py load_templates --dry-run    # Parse without saving
python manage.py load_templates --templates-dir /path --agents-dir /path
```

## Request Flow

### Template List View

```
User Request → Django URL Router → TemplateListView
    ↓
TemplateService.search_templates(filters)
    ↓
Database Query (filtered by role/phase)
    ↓
Render templates/forge/template_list.html
    ↓
HTTP Response to User
```

### Prompt Generation Flow

```
User Request (POST) → Django URL Router → GeneratePromptView
    ↓
Form Validation (GeneratePromptForm)
    ↓
PromptGenerationService.generate_prompt(template, context)
    ↓
Variable Substitution
    ↓
Save to GeneratedPrompt (history)
    ↓
Render templates/forge/prompt_generated.html
    ↓
HTTP Response with Generated Prompt
```

### GitHub Sync Flow

```
Admin Trigger → sync_templates() view
    ↓
GitHubService.fetch_templates(BMAD_METHOD_REPO)
    ↓
For each template file:
    - Fetch raw content
    - Parse TOML frontmatter
    - Validate structure
    - Create/Update Template model
    ↓
TemplateService.create_or_update(template_data)
    ↓
Database Transaction (bulk create/update)
    ↓
Redirect to Template List with success message
```

## Security Architecture

### Authentication & Authorization

- **Admin Interface:** Django's built-in admin authentication
- **User Access:** Public access to template browsing (no auth required for MVP)
- **Future:** OAuth integration for GitHub authentication

### Security Headers (Production)

```python
# HTTPS Enforcement
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# HSTS (HTTP Strict Transport Security)
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

# XSS Protection
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'

# Content Security Policy
CSP_DEFAULT_SRC = ("'self'",)
CSP_SCRIPT_SRC = ("'self'", "'unsafe-inline'")
CSP_STYLE_SRC = ("'self'", "'unsafe-inline'")
```

### Input Validation

- **Forms:** Django form validation for all user inputs
- **Template Upload:** TOML parsing with error handling
- **SQL Injection:** Django ORM prevents SQL injection
- **XSS:** Django template auto-escaping enabled

### Secret Management

- **Environment Variables:** Secrets stored in `.env` files (not in git)
- **SECRET_KEY:** Cryptographically secure, rotated regularly
- **GitHub Token:** Personal access token with minimal permissions
- **Database Password:** Strong password, environment-specific

### Rate Limiting

- **GitHub API:** Respect rate limits (5000 requests/hour)
- **Form Submissions:** CSRF protection on all POST requests
- **Future:** Django Ratelimit middleware for API endpoints

## Deployment Architecture

### Development Environment

```
Developer Machine
├── Python 3.13 (venv)
├── SQLite Database (db.sqlite3)
├── Django Dev Server (runserver)
└── Static Files (served by Django)
```

### Production Environment

```
                                    ┌─────────────────┐
                                    │   CloudFlare    │
                                    │   (CDN + WAF)   │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Load Balancer  │
                                    │    (nginx)      │
                                    └────────┬────────┘
                                             │
                        ┌────────────────────┼────────────────────┐
                        │                    │                    │
                ┌───────▼────────┐  ┌────────▼────────┐  ┌───────▼────────┐
                │   Web Server 1  │  │  Web Server 2   │  │  Web Server N  │
                │    (gunicorn)   │  │   (gunicorn)    │  │   (gunicorn)   │
                └───────┬─────────┘  └────────┬────────┘  └───────┬────────┘
                        │                     │                    │
                        └─────────────────────┼────────────────────┘
                                              │
                        ┌─────────────────────┼─────────────────────┐
                        │                     │                     │
                ┌───────▼────────┐   ┌────────▼────────┐   ┌───────▼────────┐
                │  PostgreSQL    │   │     Redis       │   │     Sentry     │
                │   (Database)   │   │    (Cache)      │   │   (Monitoring) │
                └────────────────┘   └─────────────────┘   └────────────────┘
```

### Static File Serving

**Development:**
- Django Dev Server serves static files directly
- STATIC_URL = '/static/'
- STATICFILES_DIRS = [BASE_DIR / 'forge' / 'static']

**Production:**
- WhiteNoise middleware serves static files
- Files collected to STATIC_ROOT during deployment
- Compression and caching headers enabled

```bash
# Collect static files
python manage.py collectstatic --noinput
```

### Database

**Development:**
- SQLite for simplicity
- Single file database (db.sqlite3)
- No configuration needed

**Production:**
- PostgreSQL 15+
- Connection pooling (CONN_MAX_AGE=600)
- Read replicas for scaling (future)
- Automated backups (daily)

### Caching Strategy

**Development:**
- No caching (dummy cache backend)

**Production:**
- Redis for session storage
- Cache template rendering
- Cache GitHub API responses (15 minutes)
- Cache database queries (5 minutes)

```python
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': os.environ.get('REDIS_URL'),
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',
        }
    }
}
```

## Monitoring and Observability

### Logging

**Log Levels:**
- DEBUG: Development only
- INFO: Application events (template sync, prompt generation)
- WARNING: Non-critical issues (GitHub API rate limit approaching)
- ERROR: Application errors (GitHub API failure, database errors)
- CRITICAL: System failures (database unavailable)

**Log Destinations:**
- Development: Console output
- Production: File + Sentry + CloudWatch/Stackdriver

**Example Configuration:**
```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '/var/log/bmad-forge/app.log',
            'maxBytes': 10485760,  # 10MB
            'backupCount': 5,
            'formatter': 'verbose',
        },
        'sentry': {
            'level': 'ERROR',
            'class': 'sentry_sdk.integrations.logging.EventHandler',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file', 'sentry'],
            'level': 'INFO',
            'propagate': False,
        },
        'forge': {
            'handlers': ['file', 'sentry'],
            'level': 'INFO',
            'propagate': False,
        },
    },
}
```

### Health Checks

**Endpoint:** `/health/`

**Checks:**
- Database connectivity
- Redis connectivity (production)
- Disk space (warn if < 10% free)
- Memory usage (warn if > 80%)

**Response:**
```json
{
  "status": "healthy",
  "checks": {
    "database": "ok",
    "cache": "ok",
    "disk_space": "ok",
    "memory": "ok"
  },
  "timestamp": "2026-01-28T12:00:00Z"
}
```

### Error Tracking

**Sentry Integration:**
- Automatic exception tracking
- User context (if authenticated)
- Request context (URL, method, headers)
- Breadcrumbs (navigation, API calls)
- Release tracking (git commit SHA)

**Performance Monitoring:**
- Transaction tracing
- Database query performance
- External API call timing
- Frontend performance (future)

## Scalability Considerations

### Current Capacity

- **Concurrent Users:** ~100 users
- **Database:** SQLite (development) / PostgreSQL (production)
- **Static Files:** WhiteNoise (single server)

### Scaling Strategy

**Horizontal Scaling (when needed):**
1. Add application servers behind load balancer
2. Shared PostgreSQL database
3. Shared Redis cache
4. Static files on CDN

**Vertical Scaling (immediate):**
1. Increase gunicorn workers
2. Tune PostgreSQL connection pool
3. Optimize database queries
4. Add database indexes

**Bottlenecks:**
- GitHub API rate limits (5000/hour per token)
- Database write contention (GitHub sync)
- Static file serving (mitigated by WhiteNoise)

## Future Architecture Enhancements

### Short Term (3-6 months)
- [ ] Add API endpoints (REST API)
- [ ] Implement user authentication
- [ ] Add rate limiting
- [ ] Migrate to CDN for static files

### Medium Term (6-12 months)
- [ ] Real-time collaboration (WebSockets)
- [ ] Background job processing (Celery)
- [ ] Full-text search (Elasticsearch)
- [ ] API versioning

### Long Term (12+ months)
- [ ] Microservices architecture
- [ ] GraphQL API
- [ ] Kubernetes deployment
- [ ] Multi-region deployment

## Technology Decisions

### Why Django?

- **Rapid Development:** Built-in admin, ORM, templates
- **Security:** CSRF, XSS, SQL injection protection
- **Scalability:** Proven at scale (Instagram, Pinterest)
- **Ecosystem:** Rich library ecosystem
- **LTS Support:** Django 5.2 supported until 2027

### Why SQLite → PostgreSQL?

- **Development:** SQLite for zero-configuration setup
- **Production:** PostgreSQL for reliability, performance, features
- **Migration Path:** Django ORM abstracts database differences

### Why WhiteNoise?

- **Simplicity:** No separate static file server needed
- **Performance:** Gzip compression, cache headers
- **Cost:** No CDN costs initially
- **Upgrade Path:** Easy migration to CDN later

### Why Redis?

- **Sessions:** Fast session storage
- **Caching:** High-performance cache backend
- **Future:** Task queue (Celery), real-time features

## Development Workflow

### Local Development

```bash
# Set up environment
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with local settings

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run development server
python manage.py runserver
```

### Testing

```bash
# Run all tests
pytest --cov=forge --cov-report=html

# Run specific test
pytest webapp/forge/tests/test_services.py::test_template_sync

# Run with warnings
python -Wa manage.py test
```

### Deployment

```bash
# Collect static files
python manage.py collectstatic --noinput

# Run migrations
python manage.py migrate --noinput

# Check deployment settings
python manage.py check --deploy

# Start gunicorn
gunicorn bmad_forge.wsgi:application --bind 0.0.0.0:8000
```

## Conclusion

BMAD Forge follows Django best practices with a clear separation of concerns:
- **Models** handle data persistence
- **Services** contain business logic
- **Views** orchestrate request handling
- **Templates** render HTML responses

The architecture prioritizes:
- **Simplicity:** Easy to understand and maintain
- **Security:** Defense in depth, secure by default
- **Scalability:** Horizontal and vertical scaling paths
- **Observability:** Comprehensive logging and monitoring

For questions or clarifications, refer to:
- Django Documentation: https://docs.djangoproject.com/
- BMAD Framework: https://github.com/bmadcode/BMAD-METHOD-v5
- Project README: /home/sithlord/src/BMAD_Forge/README.md
