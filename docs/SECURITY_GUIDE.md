# Security Hardening Guide for BMAD Forge

## Overview

This document provides comprehensive security hardening guidelines for deploying BMAD Forge to production. Security is implemented in layers following defense-in-depth principles.

## Table of Contents

1. [Django Security Settings](#django-security-settings)
2. [Security Headers](#security-headers)
3. [Database Security](#database-security)
4. [Application Security](#application-security)
5. [Infrastructure Security](#infrastructure-security)
6. [Secret Management](#secret-management)
7. [Monitoring and Incident Response](#monitoring-and-incident-response)
8. [Security Checklist](#security-checklist)

## Django Security Settings

### Production Configuration

**File:** `webapp/bmad_forge/settings/production.py`

```python
# CRITICAL: Never run with DEBUG=True in production
DEBUG = False

# CRITICAL: Use strong, random SECRET_KEY
SECRET_KEY = os.environ.get('SECRET_KEY')
if not SECRET_KEY or SECRET_KEY.startswith('django-insecure'):
    raise ImproperlyConfigured('SECRET_KEY must be set in production')

# CRITICAL: Restrict ALLOWED_HOSTS
ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', '').split(',')
if not ALLOWED_HOSTS or ALLOWED_HOSTS == ['']:
    raise ImproperlyConfigured('ALLOWED_HOSTS must be set in production')

# HTTPS Enforcement
SECURE_SSL_REDIRECT = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

# Cookie Security
SESSION_COOKIE_SECURE = True
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = 'Strict'
SESSION_COOKIE_AGE = 3600  # 1 hour

CSRF_COOKIE_SECURE = True
CSRF_COOKIE_HTTPONLY = True
CSRF_COOKIE_SAMESITE = 'Strict'

# HSTS (HTTP Strict Transport Security)
SECURE_HSTS_SECONDS = 31536000  # 1 year
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

# Content Security
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'

# Referrer Policy
SECURE_REFERRER_POLICY = 'same-origin'
```

### Password Validation

Enforce strong passwords:

```python
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        'OPTIONS': {
            'min_length': 12,  # Increased from default 8
        }
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]
```

### Admin Interface Security

```python
# Change default admin URL
ADMIN_URL = os.environ.get('ADMIN_URL', 'admin/')  # Use random string in production

# In urls.py:
urlpatterns = [
    path(settings.ADMIN_URL, admin.site.urls),  # Not 'admin/'
]

# Require HTTPS for admin
ADMIN_FORCE_HTTPS = True
```

## Security Headers

### Content Security Policy (CSP)

Install: `pip install django-csp`

**Configuration:**

```python
# settings/production.py
INSTALLED_APPS = [
    # ...
    'csp',
]

MIDDLEWARE = [
    # ...
    'csp.middleware.CSPMiddleware',
]

# Content Security Policy
CSP_DEFAULT_SRC = ("'none'",)
CSP_SCRIPT_SRC = ("'self'", "'unsafe-inline'")  # Remove unsafe-inline in future
CSP_STYLE_SRC = ("'self'", "'unsafe-inline'", "https://cdn.jsdelivr.net")
CSP_IMG_SRC = ("'self'", "data:", "https:")
CSP_FONT_SRC = ("'self'", "https://cdn.jsdelivr.net")
CSP_CONNECT_SRC = ("'self'",)
CSP_FRAME_ANCESTORS = ("'none'",)
CSP_BASE_URI = ("'self'",)
CSP_FORM_ACTION = ("'self'",)

# Report violations (optional)
CSP_REPORT_URI = os.environ.get('CSP_REPORT_URI', '')
CSP_REPORT_ONLY = False  # Set to True to test without blocking
```

### Permissions Policy

Install: `pip install django-permissions-policy`

**Configuration:**

```python
# settings/production.py
INSTALLED_APPS = [
    # ...
    'django_permissions_policy',
]

MIDDLEWARE = [
    # ...
    'django_permissions_policy.PermissionsPolicyMiddleware',
]

# Permissions Policy (formerly Feature Policy)
PERMISSIONS_POLICY = {
    "accelerometer": [],
    "ambient-light-sensor": [],
    "autoplay": [],
    "camera": [],
    "display-capture": [],
    "document-domain": [],
    "encrypted-media": [],
    "fullscreen": [],
    "geolocation": [],
    "gyroscope": [],
    "magnetometer": [],
    "microphone": [],
    "midi": [],
    "payment": [],
    "picture-in-picture": [],
    "publickey-credentials-get": [],
    "sync-xhr": [],
    "usb": [],
    "xr-spatial-tracking": [],
}
```

### Additional Security Headers

```python
# settings/production.py

# Prevent MIME type sniffing
SECURE_CONTENT_TYPE_NOSNIFF = True

# Enable XSS filtering in older browsers
SECURE_BROWSER_XSS_FILTER = True

# Prevent clickjacking
X_FRAME_OPTIONS = 'DENY'

# Referrer policy
SECURE_REFERRER_POLICY = 'same-origin'
```

## Database Security

### Connection Security

```python
# settings/production.py
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASSWORD'),
        'HOST': os.environ.get('DB_HOST'),
        'PORT': os.environ.get('DB_PORT', '5432'),
        'OPTIONS': {
            'sslmode': 'require',  # Enforce SSL/TLS
            'connect_timeout': 10,
        },
        'CONN_MAX_AGE': 600,  # Connection pooling
        'CONN_HEALTH_CHECKS': True,  # Django 4.1+
    }
}
```

### Database User Permissions

**Principle of Least Privilege:**

```sql
-- Create application database user
CREATE USER bmad_forge_app WITH PASSWORD 'strong_random_password';

-- Grant only necessary permissions
GRANT CONNECT ON DATABASE bmad_forge TO bmad_forge_app;
GRANT USAGE ON SCHEMA public TO bmad_forge_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO bmad_forge_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO bmad_forge_app;

-- Revoke dangerous permissions
REVOKE CREATE ON SCHEMA public FROM bmad_forge_app;
REVOKE ALL ON SCHEMA public FROM PUBLIC;

-- For migrations, use separate user with elevated privileges
CREATE USER bmad_forge_admin WITH PASSWORD 'different_strong_password';
GRANT ALL PRIVILEGES ON DATABASE bmad_forge TO bmad_forge_admin;
```

### Database Backups

```bash
# Automated daily backup script
#!/bin/bash
BACKUP_DIR="/var/backups/postgresql"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DB_NAME="bmad_forge"

# Create backup with compression
pg_dump -U bmad_forge_admin -h localhost $DB_NAME | gzip > $BACKUP_DIR/bmad_forge_$TIMESTAMP.sql.gz

# Encrypt backup
gpg --encrypt --recipient backup@example.com $BACKUP_DIR/bmad_forge_$TIMESTAMP.sql.gz

# Remove unencrypted backup
rm $BACKUP_DIR/bmad_forge_$TIMESTAMP.sql.gz

# Delete backups older than 30 days
find $BACKUP_DIR -name "*.sql.gz.gpg" -mtime +30 -delete

# Test backup integrity
gunzip < $BACKUP_DIR/bmad_forge_$TIMESTAMP.sql.gz.gpg | gpg --decrypt | head -n 10
```

## Application Security

### Input Validation

**Form Validation:**

```python
# forge/forms.py
from django import forms
from django.core.validators import MaxLengthValidator, MinLengthValidator
import bleach

class GeneratePromptForm(forms.Form):
    project_name = forms.CharField(
        max_length=200,
        validators=[MinLengthValidator(3)],
        widget=forms.TextInput(attrs={'class': 'form-control'})
    )

    project_description = forms.CharField(
        max_length=5000,
        widget=forms.Textarea(attrs={'class': 'form-control', 'rows': 5})
    )

    def clean_project_name(self):
        """Sanitize project name"""
        data = self.cleaned_data['project_name']
        # Remove any HTML tags
        return bleach.clean(data, tags=[], strip=True)

    def clean_project_description(self):
        """Sanitize project description"""
        data = self.cleaned_data['project_description']
        # Allow only safe HTML tags
        allowed_tags = ['p', 'br', 'strong', 'em', 'ul', 'ol', 'li']
        return bleach.clean(data, tags=allowed_tags, strip=True)
```

### CSRF Protection

**Ensure CSRF tokens on all forms:**

```html
<!-- templates/forge/generate_prompt.html -->
<form method="post">
    {% csrf_token %}  <!-- REQUIRED for all POST forms -->
    {{ form.as_p }}
    <button type="submit">Generate Prompt</button>
</form>
```

**AJAX CSRF Protection:**

```javascript
// static/forge/js/csrf.js
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

const csrftoken = getCookie('csrftoken');

// Include CSRF token in AJAX requests
fetch('/api/endpoint/', {
    method: 'POST',
    headers: {
        'X-CSRFToken': csrftoken,
        'Content-Type': 'application/json',
    },
    body: JSON.stringify(data)
});
```

### XSS Prevention

**Django templates auto-escape by default:**

```html
<!-- Safe: auto-escaped -->
<p>{{ user_input }}</p>

<!-- DANGEROUS: manual escaping disabled -->
<p>{{ user_input|safe }}</p>  <!-- Only use when absolutely necessary -->

<!-- Safe: explicit escaping -->
<p>{{ user_input|escape }}</p>
```

### SQL Injection Prevention

**Always use Django ORM or parameterized queries:**

```python
# SAFE: Django ORM
templates = Template.objects.filter(agent_role=user_role)

# SAFE: Parameterized query
from django.db import connection
with connection.cursor() as cursor:
    cursor.execute("SELECT * FROM forge_template WHERE agent_role = %s", [user_role])

# DANGEROUS: String concatenation (DON'T DO THIS)
# query = f"SELECT * FROM forge_template WHERE agent_role = '{user_role}'"
```

### File Upload Security

**If implementing file uploads:**

```python
# settings/base.py
FILE_UPLOAD_MAX_MEMORY_SIZE = 5242880  # 5MB
DATA_UPLOAD_MAX_MEMORY_SIZE = 5242880

# Allowed file types
ALLOWED_UPLOAD_EXTENSIONS = ['.md', '.toml', '.txt']

# Upload directory outside web root
MEDIA_ROOT = BASE_DIR.parent / 'media'
MEDIA_URL = '/media/'

# forge/views.py
import os
from django.core.exceptions import ValidationError

def validate_file_upload(uploaded_file):
    """Validate uploaded file"""
    # Check file size
    if uploaded_file.size > 5242880:  # 5MB
        raise ValidationError('File too large. Maximum size is 5MB.')

    # Check file extension
    ext = os.path.splitext(uploaded_file.name)[1].lower()
    if ext not in ['.md', '.toml', '.txt']:
        raise ValidationError(f'Invalid file type: {ext}')

    # Check MIME type
    import magic
    file_type = magic.from_buffer(uploaded_file.read(1024), mime=True)
    uploaded_file.seek(0)
    if file_type not in ['text/plain', 'text/markdown']:
        raise ValidationError(f'Invalid file content type: {file_type}')

    return True
```

### Rate Limiting

**Install:** `pip install django-ratelimit`

```python
# views.py
from django_ratelimit.decorators import ratelimit

@ratelimit(key='ip', rate='10/m', method='POST')
def generate_prompt(request):
    """Rate limit: 10 POST requests per minute per IP"""
    # View logic
    pass

@ratelimit(key='user', rate='100/h', method='POST')
def upload_template(request):
    """Rate limit: 100 uploads per hour per user"""
    # View logic
    pass
```

## Infrastructure Security

### HTTPS/TLS Configuration

**nginx configuration:**

```nginx
# /etc/nginx/sites-available/bmad-forge
server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://$server_name$request_uri;  # Redirect HTTP to HTTPS
}

server {
    listen 443 ssl http2;
    server_name example.com www.example.com;

    # TLS Certificate (Let's Encrypt recommended)
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # TLS Configuration (Mozilla Intermediate)
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

    # Security Headers
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "same-origin" always;

    # SSL Session Cache
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        alias /var/www/bmad-forge/staticfiles/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### Firewall Configuration

```bash
# ufw (Ubuntu)
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP (redirect to HTTPS)
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable

# Limit SSH brute force attempts
sudo ufw limit 22/tcp
```

### SSH Hardening

```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
PrintMotd no
ClientAliveInterval 300
ClientAliveCountMax 2
MaxAuthTries 3
MaxSessions 2

# Restart SSH service
sudo systemctl restart sshd
```

## Secret Management

### Environment Variables

**Never commit secrets to git:**

```bash
# .env (gitignored)
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=example.com,www.example.com
DATABASE_URL=postgresql://user:password@localhost/dbname
REDIS_URL=redis://localhost:6379/0
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
SENTRY_DSN=https://xxxxxx@sentry.io/xxxxxx
```

**.gitignore:**

```
.env
.env.*
!.env.example
*.key
*.pem
secrets/
```

### SECRET_KEY Generation

```python
# Generate new SECRET_KEY
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

```bash
# Or use openssl
openssl rand -base64 64
```

### Secret Rotation

**Rotate secrets regularly:**

1. **SECRET_KEY:** Every 90 days
2. **Database passwords:** Every 90 days
3. **API tokens:** Every 90 days
4. **TLS certificates:** Auto-renew with Let's Encrypt

**SECRET_KEY rotation process:**

```python
# settings/production.py
# Support multiple SECRET_KEYs during rotation
SECRET_KEY = os.environ.get('SECRET_KEY')
OLD_SECRET_KEYS = os.environ.get('OLD_SECRET_KEYS', '').split(',')

# Django will try OLD_SECRET_KEYs if SECRET_KEY fails
# Allows gradual migration without invalidating all sessions
```

## Monitoring and Incident Response

### Security Logging

```python
# settings/production.py
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'security': {
            'format': '{levelname} {asctime} {module} {message} {name} {pathname}',
            'style': '{',
        },
    },
    'handlers': {
        'security_file': {
            'level': 'WARNING',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '/var/log/bmad-forge/security.log',
            'maxBytes': 10485760,
            'backupCount': 10,
            'formatter': 'security',
        },
        'sentry': {
            'level': 'ERROR',
            'class': 'sentry_sdk.integrations.logging.EventHandler',
        },
    },
    'loggers': {
        'django.security': {
            'handlers': ['security_file', 'sentry'],
            'level': 'WARNING',
            'propagate': False,
        },
        'django.security.csrf': {
            'handlers': ['security_file'],
            'level': 'WARNING',
            'propagate': False,
        },
    },
}
```

### Security Event Monitoring

**Monitor for:**
- Failed login attempts (admin interface)
- CSRF token failures
- Invalid HTTP methods
- 403/404 patterns
- Unusual traffic patterns
- Database connection errors
- File system access violations

**Alert on:**
- > 10 failed logins from same IP in 5 minutes
- > 100 CSRF failures in 1 hour
- > 50 403 errors from same IP in 1 minute
- Database connection pool exhaustion
- Disk space < 10%
- Memory usage > 90%

### Incident Response Plan

**Detection → Containment → Eradication → Recovery → Lessons Learned**

1. **Detection:** Automated alerts, log monitoring, user reports
2. **Containment:** Block malicious IPs, disable compromised accounts, isolate affected systems
3. **Eradication:** Patch vulnerabilities, remove malware, reset credentials
4. **Recovery:** Restore from backups, verify system integrity, resume operations
5. **Lessons Learned:** Document incident, update procedures, improve defenses

## Security Checklist

### Pre-Deployment

- [ ] DEBUG = False in production
- [ ] SECRET_KEY is strong and random (64+ characters)
- [ ] SECRET_KEY not committed to git
- [ ] ALLOWED_HOSTS explicitly configured
- [ ] HTTPS enforced (SECURE_SSL_REDIRECT = True)
- [ ] HSTS enabled (SECURE_HSTS_SECONDS = 31536000)
- [ ] Secure cookies enabled (SESSION_COOKIE_SECURE = True)
- [ ] CSRF protection enabled on all forms
- [ ] XSS auto-escaping enabled
- [ ] SQL injection prevented (using ORM)
- [ ] Content Security Policy configured
- [ ] Permissions Policy configured
- [ ] Strong password validators enabled
- [ ] Admin URL changed from default
- [ ] Database SSL/TLS enforced
- [ ] Database user has minimal permissions
- [ ] Automated backups configured
- [ ] Firewall configured (only 22, 80, 443 open)
- [ ] SSH root login disabled
- [ ] SSH password authentication disabled
- [ ] TLS 1.2+ only (no SSLv3, TLS 1.0, TLS 1.1)
- [ ] Strong TLS cipher suites configured
- [ ] Security headers configured (nginx)
- [ ] Error tracking configured (Sentry)
- [ ] Security logging enabled
- [ ] Log rotation configured
- [ ] Incident response plan documented

### Post-Deployment

- [ ] Django deployment check passed: `python manage.py check --deploy`
- [ ] SSL Labs scan shows A+ rating: https://www.ssllabs.com/ssltest/
- [ ] Security headers verified: https://securityheaders.com/
- [ ] OWASP ZAP scan completed (no high/critical)
- [ ] Penetration testing completed
- [ ] Backup restoration tested
- [ ] Monitoring alerts tested
- [ ] Incident response plan rehearsed

### Regular Maintenance

- [ ] Weekly: Review security logs
- [ ] Weekly: Update dependencies (security patches)
- [ ] Monthly: Rotate API tokens
- [ ] Quarterly: Rotate SECRET_KEY
- [ ] Quarterly: Rotate database passwords
- [ ] Quarterly: Security scan (OWASP ZAP, Nessus)
- [ ] Annually: Penetration testing
- [ ] Annually: Security audit

## Security Testing Tools

### Automated Scanning

```bash
# Bandit - Python security linter
pip install bandit
bandit -r webapp/forge/

# Safety - Check dependencies for known vulnerabilities
pip install safety
safety check --file requirements.txt

# Django security check
python manage.py check --deploy
```

### Penetration Testing Tools

- **OWASP ZAP:** Web application security scanner
- **Burp Suite:** Web vulnerability scanner
- **Nmap:** Network port scanner
- **SQLMap:** SQL injection testing
- **Nikto:** Web server scanner

## Compliance Considerations

### GDPR (If Applicable)

- Data minimization (collect only necessary data)
- Data encryption (at rest and in transit)
- Data retention policy
- Right to erasure (delete user data on request)
- Privacy policy
- Cookie consent

### HIPAA (If Applicable)

- Access controls (role-based access)
- Audit logging (all data access logged)
- Data encryption (AES-256)
- Business Associate Agreements

### PCI DSS (If Processing Payments)

- Never store CVV
- Encrypt cardholder data
- Use secure payment gateway
- Regular security scans

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Django Security Documentation](https://docs.djangoproject.com/en/stable/topics/security/)
- [Mozilla Web Security Guidelines](https://infosec.mozilla.org/guidelines/web_security)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)

## Contact

For security issues:
- **Email:** security@example.com
- **Bug Bounty:** https://hackerone.com/example
- **Responsible Disclosure:** 90-day disclosure policy

**DO NOT** disclose security vulnerabilities publicly before coordinated disclosure.
