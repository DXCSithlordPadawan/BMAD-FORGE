# BMAD Forge: Production Readiness Guide

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Settings Split Strategy](#settings-split-strategy)
4. [Database Migration](#database-migration)
5. [Static Files](#static-files)
6. [Security Hardening](#security-hardening)
7. [WSGI Server](#wsgi-server)
8. [Reverse Proxy](#reverse-proxy)
9. [Monitoring and Logging](#monitoring-and-logging)
10. [Deployment Platforms](#deployment-platforms)
11. [Environment Variables](#environment-variables)
12. [Backup and Recovery](#backup-and-recovery)

---

## Overview

This guide covers everything needed to deploy BMAD Forge to production. The application is a Django-based prompt engineering tool for the BMAD Framework, currently configured for development with SQLite and Django's built-in server.

**Current State:**
- Django 5.2.10 LTS (Python 3.13)
- SQLite database
- Single settings file
- Development configuration
- No production monitoring

**Production Target:**
- Environment-specific settings (development, production, test)
- PostgreSQL database with connection pooling
- WhiteNoise for static file serving
- Gunicorn WSGI server
- Nginx reverse proxy
- SSL/TLS encryption
- Security headers (HSTS, CSP, XSS protection)
- Sentry error tracking
- Comprehensive logging
- Health check endpoints
- Automated CI/CD pipeline

---

## Architecture

### High-Level Architecture

```
Internet
    ↓
[Load Balancer / CDN] (Optional)
    ↓
[Nginx Reverse Proxy]
    ↓ (port 8000)
[Gunicorn WSGI Server] (4-8 workers)
    ↓
[Django Application]
    ↓
[PostgreSQL Database]
[Redis Cache] (Optional)
[Sentry Error Tracking]
```

### Component Responsibilities

**Nginx:**
- SSL/TLS termination
- Request routing
- Static file serving (backup)
- Rate limiting
- Security headers

**Gunicorn:**
- WSGI application server
- Worker process management
- Request handling
- Graceful restarts

**Django:**
- Business logic
- Template rendering
- GitHub synchronization
- Prompt generation

**PostgreSQL:**
- Persistent data storage
- Template management
- User authentication

**Redis (Optional):**
- Session storage
- Cache backend
- Rate limiting

---

## Settings Split Strategy

### Directory Structure

```
webapp/bmad_forge/settings/
├── __init__.py          # Environment auto-detection
├── base.py              # Common settings
├── development.py       # Development overrides
├── production.py        # Production settings
└── test.py              # Test configuration
```

### Environment Detection

The `__init__.py` file automatically loads the correct settings based on the `DJANGO_ENV` environment variable:

```python
import os

env = os.environ.get('DJANGO_ENV', 'development')

if env == 'production':
    from .production import *
elif env == 'test':
    from .test import *
else:
    from .development import *
```

### Usage

```bash
# Development (default)
python manage.py runserver

# Production
DJANGO_ENV=production python manage.py check --deploy

# Testing
DJANGO_ENV=test pytest
```

### Key Differences by Environment

| Setting | Development | Production | Test |
|---------|-------------|------------|------|
| DEBUG | True | False | True |
| Database | SQLite | PostgreSQL | SQLite (in-memory) |
| ALLOWED_HOSTS | localhost | Specific domains | localhost |
| SSL Redirect | False | True | False |
| Static Files | Django | WhiteNoise | Django |
| Logging | Console (INFO) | File + Sentry (WARNING) | Console (ERROR) |
| Caching | Dummy | Redis | Dummy |

---

## Database Migration

### Why PostgreSQL?

SQLite is excellent for development but has limitations in production:
- No concurrent writes
- Limited connection pooling
- No advanced features (full-text search, array fields)
- File-based locking issues

PostgreSQL provides:
- ACID compliance
- Concurrent connections
- Advanced data types
- Better performance at scale
- Backup and replication

### Migration Steps

#### 1. Install PostgreSQL

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
```

**macOS:**
```bash
brew install postgresql@15
brew services start postgresql@15
```

#### 2. Create Database and User

```bash
sudo -u postgres psql

# In PostgreSQL shell
CREATE DATABASE bmad_forge_prod;
CREATE USER bmad_admin WITH PASSWORD 'secure_password_here';
ALTER ROLE bmad_admin SET client_encoding TO 'utf8';
ALTER ROLE bmad_admin SET default_transaction_isolation TO 'read committed';
ALTER ROLE bmad_admin SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE bmad_forge_prod TO bmad_admin;
\q
```

#### 3. Configure Database URL

Add to `.env` or environment variables:

```bash
DATABASE_URL=postgresql://bmad_admin:secure_password_here@localhost:5432/bmad_forge_prod
```

#### 4. Install Python PostgreSQL Adapter

```bash
pip install psycopg2-binary
```

#### 5. Export Data from SQLite (if needed)

```bash
# Dump existing data
python manage.py dumpdata --natural-foreign --natural-primary -e contenttypes -e auth.Permission > data.json

# Switch to PostgreSQL settings
export DJANGO_ENV=production

# Create tables
python manage.py migrate

# Load data
python manage.py loaddata data.json
```

#### 6. Verify Migration

```bash
python manage.py dbshell
\dt  # List tables
SELECT COUNT(*) FROM forge_template;
\q
```

### Connection Pooling

Production settings use `CONN_MAX_AGE` for persistent connections:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME', 'bmad_forge_prod'),
        'USER': os.environ.get('DB_USER', 'bmad_admin'),
        'PASSWORD': os.environ.get('DB_PASSWORD', ''),
        'HOST': os.environ.get('DB_HOST', 'localhost'),
        'PORT': os.environ.get('DB_PORT', '5432'),
        'CONN_MAX_AGE': 600,  # 10 minutes
        'OPTIONS': {
            'connect_timeout': 10,
        }
    }
}
```

For high-traffic applications, consider PgBouncer for advanced pooling.

---

## Static Files

### Development Configuration

In development, Django serves static files automatically:

```python
STATIC_URL = 'static/'
STATICFILES_DIRS = [BASE_DIR / 'forge' / 'static']
```

### Production Configuration with WhiteNoise

WhiteNoise allows Django to serve static files efficiently in production without needing a separate web server.

#### 1. Install WhiteNoise

```bash
pip install whitenoise
```

#### 2. Configure Middleware

Add to `production.py`:

```python
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',  # Add after SecurityMiddleware
    # ... rest of middleware
]
```

#### 3. Configure Static Files

```python
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
```

#### 4. Collect Static Files

```bash
python manage.py collectstatic --noinput
```

### Alternative: CDN or Object Storage

For high-traffic applications, consider:
- Amazon S3 + CloudFront
- Google Cloud Storage + CDN
- Azure Blob Storage + CDN
- DigitalOcean Spaces

Use `django-storages` for integration:

```python
# production.py with S3
DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
STATICFILES_STORAGE = 'storages.backends.s3boto3.S3StaticStorage'
AWS_STORAGE_BUCKET_NAME = 'bmad-forge-static'
AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com'
STATIC_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/static/'
```

---

## Security Hardening

### SSL/TLS Configuration

**Always use HTTPS in production.** Configure Django to enforce SSL:

```python
# production.py
SECURE_SSL_REDIRECT = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
```

### HSTS (HTTP Strict Transport Security)

```python
SECURE_HSTS_SECONDS = 31536000  # 1 year
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
```

**Note:** Test thoroughly before enabling HSTS. Start with a short duration (e.g., 300 seconds) and gradually increase.

### Security Headers

```python
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'
```

### Content Security Policy

Install `django-csp`:

```bash
pip install django-csp
```

Configure in `production.py`:

```python
MIDDLEWARE.append('csp.middleware.CSPMiddleware')

CSP_DEFAULT_SRC = ("'self'",)
CSP_SCRIPT_SRC = ("'self'", "'unsafe-inline'")  # Adjust as needed
CSP_STYLE_SRC = ("'self'", "'unsafe-inline'")
CSP_IMG_SRC = ("'self'", "data:", "https:")
CSP_FONT_SRC = ("'self'",)
CSP_CONNECT_SRC = ("'self'",)
```

### Permissions Policy

Install `django-permissions-policy`:

```bash
pip install django-permissions-policy
```

Configure in `production.py`:

```python
MIDDLEWARE.append('django_permissions_policy.PermissionsPolicyMiddleware')

PERMISSIONS_POLICY = {
    "geolocation": [],
    "microphone": [],
    "camera": [],
    "payment": [],
}
```

### Secret Key Management

**Never commit SECRET_KEY to version control.**

Generate a strong secret key:

```python
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

Store in environment variables:

```bash
export SECRET_KEY='your-secret-key-here'
```

Rotate regularly (at least annually).

### ALLOWED_HOSTS Configuration

Explicitly list allowed domains:

```python
ALLOWED_HOSTS = [
    'bmadforge.example.com',
    'www.bmadforge.example.com',
]
```

### Password Validation

Keep strong password validators (already configured):

```python
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]
```

### CSRF Protection

Django's CSRF protection is enabled by default. Ensure CSRF cookies are secure:

```python
CSRF_COOKIE_SECURE = True
CSRF_COOKIE_HTTPONLY = True
CSRF_COOKIE_SAMESITE = 'Strict'
```

---

## WSGI Server

### Why Gunicorn?

Django's `runserver` is for development only. Gunicorn provides:
- Production-grade request handling
- Worker process management
- Graceful reloads
- Performance optimization

### Installation

```bash
pip install gunicorn
```

### Basic Configuration

Create `webapp/gunicorn_config.py`:

```python
import multiprocessing

# Server socket
bind = '0.0.0.0:8000'
backlog = 2048

# Worker processes
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = 'sync'
worker_connections = 1000
timeout = 30
keepalive = 2

# Logging
accesslog = '/var/log/gunicorn/access.log'
errorlog = '/var/log/gunicorn/error.log'
loglevel = 'info'

# Process naming
proc_name = 'bmad_forge'

# Server mechanics
daemon = False
pidfile = '/var/run/gunicorn.pid'
user = None
group = None
tmp_upload_dir = None

# SSL (if not using Nginx)
# keyfile = '/path/to/key.pem'
# certfile = '/path/to/cert.pem'
```

### Running Gunicorn

```bash
cd /home/sithlord/src/BMAD_Forge/webapp
gunicorn --config gunicorn_config.py bmad_forge.wsgi:application
```

### Systemd Service

Create `/etc/systemd/system/bmad-forge.service`:

```ini
[Unit]
Description=BMAD Forge Gunicorn Application
After=network.target

[Service]
Type=notify
User=www-data
Group=www-data
WorkingDirectory=/home/sithlord/src/BMAD_Forge/webapp
Environment="PATH=/home/sithlord/src/BMAD_Forge/venv/bin"
Environment="DJANGO_ENV=production"
ExecStart=/home/sithlord/src/BMAD_Forge/venv/bin/gunicorn \
    --config gunicorn_config.py \
    bmad_forge.wsgi:application
ExecReload=/bin/kill -s HUP $MAINPID
KillMode=mixed
TimeoutStopSec=5
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable bmad-forge
sudo systemctl start bmad-forge
sudo systemctl status bmad-forge
```

### Worker Calculation

**Formula:** `(2 * CPU cores) + 1`

For a 4-core server: 9 workers

Adjust based on:
- Memory availability (each worker ~50-100MB)
- I/O vs CPU bound workload
- Database connection limits

---

## Reverse Proxy

### Why Nginx?

Nginx provides:
- SSL/TLS termination
- Static file serving (backup)
- Request buffering
- Rate limiting
- Load balancing
- Security headers

### Installation

```bash
sudo apt install nginx
```

### Configuration

Create `/etc/nginx/sites-available/bmad-forge`:

```nginx
upstream bmad_forge {
    server 127.0.0.1:8000 fail_timeout=0;
}

server {
    listen 80;
    server_name bmadforge.example.com;

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name bmadforge.example.com;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/bmadforge.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/bmadforge.example.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Logging
    access_log /var/log/nginx/bmad-forge-access.log;
    error_log /var/log/nginx/bmad-forge-error.log;

    # Client settings
    client_max_body_size 10M;

    # Static files (fallback, WhiteNoise handles this)
    location /static/ {
        alias /home/sithlord/src/BMAD_Forge/webapp/staticfiles/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Proxy to Gunicorn
    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_buffering off;
        proxy_pass http://bmad_forge;
    }

    # Health check endpoint
    location /health/ {
        access_log off;
        proxy_pass http://bmad_forge;
    }
}
```

Enable site:

```bash
sudo ln -s /etc/nginx/sites-available/bmad-forge /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### SSL Certificate (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d bmadforge.example.com
```

Auto-renewal is handled by systemd timer.

---

## Monitoring and Logging

### Application Logging

Configure comprehensive logging in `production.py`:

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
        'simple': {
            'format': '{levelname} {message}',
            'style': '{',
        },
    },
    'filters': {
        'require_debug_false': {
            '()': 'django.utils.log.RequireDebugFalse',
        },
    },
    'handlers': {
        'file': {
            'level': 'WARNING',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '/var/log/bmad_forge/django.log',
            'maxBytes': 1024 * 1024 * 10,  # 10MB
            'backupCount': 5,
            'formatter': 'verbose',
        },
        'console': {
            'level': 'INFO',
            'class': 'logging.StreamHandler',
            'formatter': 'simple',
        },
        'sentry': {
            'level': 'ERROR',
            'class': 'sentry_sdk.integrations.logging.EventHandler',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file', 'console', 'sentry'],
            'level': 'INFO',
            'propagate': False,
        },
        'forge': {
            'handlers': ['file', 'console', 'sentry'],
            'level': 'INFO',
            'propagate': False,
        },
    },
}
```

### Sentry Integration

Install Sentry SDK:

```bash
pip install sentry-sdk
```

Configure in `production.py`:

```python
import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration

sentry_sdk.init(
    dsn=os.environ.get('SENTRY_DSN', ''),
    integrations=[DjangoIntegration()],
    traces_sample_rate=0.1,
    send_default_pii=False,
    environment='production',
)
```

### Health Check Endpoint

Health checks are provided via:
- HTTP endpoint: `GET /health/`
- Management command: `python manage.py health_check`

Implement in your monitoring system (Uptime Robot, Pingdom, etc.).

### System Monitoring

Consider tools like:
- **Prometheus + Grafana:** Metrics and dashboards
- **Datadog:** All-in-one monitoring
- **New Relic:** Application performance monitoring
- **CloudWatch (AWS):** Native AWS monitoring

### Log Aggregation

For centralized logging:
- **ELK Stack:** Elasticsearch, Logstash, Kibana
- **Splunk:** Enterprise log management
- **Papertrail:** Simple cloud logging
- **CloudWatch Logs (AWS):** AWS-native solution

---

## Deployment Platforms

### 1. AWS (Elastic Beanstalk / EC2)

**Elastic Beanstalk (Easiest):**
```bash
pip install awsebcli
eb init -p python-3.13 bmad-forge
eb create bmad-forge-prod
eb deploy
```

**EC2 (More Control):**
- Launch Ubuntu 24.04 LTS instance
- Install PostgreSQL, Redis, Nginx, Python 3.13
- Configure security groups (80, 443, 22)
- Deploy application with Gunicorn + systemd
- Use RDS for PostgreSQL, ElastiCache for Redis

### 2. Heroku

```bash
pip install gunicorn
echo "web: gunicorn bmad_forge.wsgi" > Procfile
heroku create bmad-forge
heroku addons:create heroku-postgresql:hobby-dev
heroku config:set DJANGO_ENV=production
git push heroku main
heroku run python manage.py migrate
```

### 3. DigitalOcean App Platform

Create `app.yaml`:

```yaml
name: bmad-forge
services:
  - name: web
    github:
      repo: yourusername/BMAD_Forge
      branch: main
      deploy_on_push: true
    environment_slug: python
    run_command: gunicorn --config gunicorn_config.py bmad_forge.wsgi:application
    envs:
      - key: DJANGO_ENV
        value: production
databases:
  - name: postgres
    engine: PG
    version: "15"
```

### 4. Google Cloud Platform (Cloud Run)

Create `Dockerfile`:

```dockerfile
FROM python:3.13-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY webapp/ .
RUN python manage.py collectstatic --noinput
CMD gunicorn --bind :$PORT bmad_forge.wsgi:application
```

Deploy:

```bash
gcloud builds submit --tag gcr.io/PROJECT_ID/bmad-forge
gcloud run deploy bmad-forge --image gcr.io/PROJECT_ID/bmad-forge --platform managed
```

### 5. Azure App Service

```bash
az webapp up --name bmad-forge --resource-group bmad-rg --runtime "PYTHON:3.13"
az webapp config connection-string set --connection-string-type PostgreSQL ...
```

---

## Environment Variables

### Required Variables

```bash
# Django Core
SECRET_KEY=your-secret-key-here
DJANGO_ENV=production
DEBUG=False
ALLOWED_HOSTS=bmadforge.example.com,www.bmadforge.example.com

# Database
DATABASE_URL=postgresql://user:pass@host:5432/dbname
# OR individual components:
DB_NAME=bmad_forge_prod
DB_USER=bmad_admin
DB_PASSWORD=secure_password
DB_HOST=localhost
DB_PORT=5432

# Redis (Optional)
REDIS_URL=redis://localhost:6379/0

# GitHub Integration
GITHUB_TOKEN=ghp_your_token_here
GITHUB_RAW_BASE_URL=https://raw.githubusercontent.com
BMAD_METHOD_REPO=bmadcode/BMAD-METHOD-v5
TEMPLATE_REPO=DXCSithlordPadawan/training

# Sentry (Optional)
SENTRY_DSN=https://your-sentry-dsn@sentry.io/project-id

# Application
APP_NAME=BMAD Forge
APP_VERSION=1.0.0
```

### Setting Environment Variables

**Systemd Service:**
```ini
[Service]
Environment="SECRET_KEY=..."
Environment="DJANGO_ENV=production"
```

**Docker:**
```bash
docker run -e SECRET_KEY=... -e DJANGO_ENV=production ...
```

**Shell:**
```bash
export SECRET_KEY=...
export DJANGO_ENV=production
```

**.env file (development only):**
```bash
# .env
SECRET_KEY=...
DJANGO_ENV=development
```

---

## Backup and Recovery

### Database Backups

**Automated Daily Backups:**

Create `/etc/cron.daily/backup-bmad-forge`:

```bash
#!/bin/bash
BACKUP_DIR="/var/backups/bmad_forge"
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump -U bmad_admin bmad_forge_prod | gzip > "$BACKUP_DIR/db_backup_$DATE.sql.gz"
find "$BACKUP_DIR" -name "db_backup_*.sql.gz" -mtime +30 -delete
```

Make executable:

```bash
sudo chmod +x /etc/cron.daily/backup-bmad-forge
```

### Media Files Backup

```bash
rsync -avz /home/sithlord/src/BMAD_Forge/webapp/media/ backup-server:/backups/bmad_forge/media/
```

### Off-site Backups

Use cloud storage:
- AWS S3
- Google Cloud Storage
- DigitalOcean Spaces
- Backblaze B2

```bash
aws s3 sync /var/backups/bmad_forge/ s3://bmad-forge-backups/
```

### Recovery Procedure

1. **Restore Database:**
```bash
gunzip -c db_backup_20260128.sql.gz | psql -U bmad_admin bmad_forge_prod
```

2. **Restore Media Files:**
```bash
rsync -avz backup-server:/backups/bmad_forge/media/ /home/sithlord/src/BMAD_Forge/webapp/media/
```

3. **Verify Application:**
```bash
python manage.py check
python manage.py migrate
python manage.py health_check
```

### Disaster Recovery

**RTO (Recovery Time Objective):** 4 hours
**RPO (Recovery Point Objective):** 24 hours

Maintain:
- Database backups (daily)
- Infrastructure as Code (Terraform/CloudFormation)
- Configuration management (Ansible)
- Documented recovery procedures

---

## Next Steps

1. Review [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) before deploying
2. Test deployment in staging environment
3. Configure monitoring and alerts
4. Set up automated backups
5. Document incident response procedures
6. Review [SECURITY_GUIDE.md](SECURITY_GUIDE.md) regularly

## Support

For issues or questions:
- Check documentation: `/home/sithlord/src/BMAD_Forge/docs/`
- Review Django deployment checklist: `python manage.py check --deploy`
- Consult Django documentation: https://docs.djangoproject.com/en/5.2/howto/deployment/

---

**Document Version:** 1.0
**Last Updated:** 2026-01-28
**Django Version:** 5.2.10 LTS
