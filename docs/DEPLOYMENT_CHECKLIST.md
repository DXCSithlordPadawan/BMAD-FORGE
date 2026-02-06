# BMAD Forge: Deployment Checklist

This comprehensive checklist ensures all critical steps are completed before, during, and after deployment to production.

## Pre-Deployment Tasks

### Code Preparation

- [ ] **Code Review Complete**
  - All pull requests reviewed and approved
  - No pending code review comments
  - All CI/CD checks passing

- [ ] **Tests Passing**
  - All unit tests passing: `pytest`
  - Integration tests passing
  - Test coverage above threshold (>80%)
  - Manual testing completed for critical workflows

- [ ] **Dependencies Updated**
  - All dependencies at secure, stable versions
  - Security vulnerabilities resolved: `safety check`
  - No deprecated packages in use

- [ ] **Static Analysis Clean**
  - No security issues: `bandit -r webapp/forge/`
  - Code quality checks passing
  - No critical linting errors

### Configuration

- [ ] **Settings Split Implemented**
  - `webapp/bmad_forge/settings/` directory structure created
  - `base.py`, `development.py`, `production.py`, `test.py` configured
  - Environment detection in `__init__.py` working
  - Production settings tested: `DJANGO_ENV=production python manage.py check`

- [ ] **Environment Variables Configured**
  - All required variables documented in `.env.production.example`
  - Production values set in deployment environment
  - Secrets stored securely (not in version control)
  - Variables validated: no missing or default values in production

- [ ] **Database Configuration**
  - PostgreSQL database created
  - Database user and permissions configured
  - Connection string tested
  - Connection pooling configured (`CONN_MAX_AGE`)
  - Database backups scheduled

- [ ] **Static Files**
  - WhiteNoise configured in middleware
  - `STATIC_ROOT` set correctly
  - Static files collected: `python manage.py collectstatic`
  - Static files serving tested

### Security

- [ ] **Django Security Settings**
  - `DEBUG = False` in production
  - Strong `SECRET_KEY` generated and stored securely
  - `ALLOWED_HOSTS` explicitly configured (no wildcards)
  - SSL/TLS redirect enabled: `SECURE_SSL_REDIRECT = True`
  - Session cookies secure: `SESSION_COOKIE_SECURE = True`
  - CSRF cookies secure: `CSRF_COOKIE_SECURE = True`

- [ ] **HSTS Configuration**
  - `SECURE_HSTS_SECONDS` set (start with 300, increase to 31536000)
  - `SECURE_HSTS_INCLUDE_SUBDOMAINS = True`
  - `SECURE_HSTS_PRELOAD = True` (only after testing)

- [ ] **Security Headers**
  - `SECURE_BROWSER_XSS_FILTER = True`
  - `SECURE_CONTENT_TYPE_NOSNIFF = True`
  - `X_FRAME_OPTIONS = 'DENY'`
  - Content Security Policy configured
  - Permissions Policy configured

- [ ] **Django Deployment Check**
  - Pass deployment check: `python manage.py check --deploy`
  - Address all warnings and errors
  - Review security recommendations

- [ ] **Secrets Management**
  - No secrets in version control
  - GitHub token has minimal required permissions
  - Database credentials rotated
  - SECRET_KEY unique to production

### Infrastructure

- [ ] **Server Provisioned**
  - Server created (EC2, Droplet, VM, etc.)
  - Operating system updated: `apt update && apt upgrade`
  - Firewall configured (ports 80, 443, 22 only)
  - SSH key authentication configured
  - Password authentication disabled

- [ ] **Software Installed**
  - Python 3.13 installed
  - PostgreSQL 15+ installed
  - Nginx installed
  - Redis installed (if using caching)
  - System dependencies installed

- [ ] **Application Deployed**
  - Code cloned or deployed to server
  - Virtual environment created
  - Dependencies installed: `pip install -r requirements-prod.txt`
  - Application files have correct permissions

- [ ] **Gunicorn Configured**
  - `gunicorn_config.py` created
  - Worker count configured (2 * CPU + 1)
  - Systemd service created: `/etc/systemd/system/bmad-forge.service`
  - Service enabled: `systemctl enable bmad-forge`
  - Log directories created with correct permissions

- [ ] **Nginx Configured**
  - Site configuration created: `/etc/nginx/sites-available/bmad-forge`
  - Site enabled: `ln -s /etc/nginx/sites-available/bmad-forge /etc/nginx/sites-enabled/`
  - Configuration tested: `nginx -t`
  - SSL certificate obtained (Let's Encrypt)
  - Security headers configured

### Database

- [ ] **Database Setup**
  - PostgreSQL running and accessible
  - Database created
  - User created with appropriate permissions
  - Connection tested from application server

- [ ] **Migrations**
  - Migration files reviewed
  - Migrations applied: `python manage.py migrate`
  - No migration conflicts
  - Database schema verified

- [ ] **Data Migration (if applicable)**
  - Existing data exported from SQLite
  - Data imported to PostgreSQL
  - Data integrity verified
  - Record counts match between old and new database

### Monitoring and Logging

- [ ] **Logging Configured**
  - Log directories created: `/var/log/bmad_forge/`
  - Log rotation configured
  - Log levels appropriate for production (WARNING+)
  - Application logs to file and console

- [ ] **Sentry Configured**
  - Sentry project created
  - `SENTRY_DSN` configured
  - Error tracking tested
  - Sentry SDK initialized in `production.py`

- [ ] **Health Checks**
  - Health check endpoint created: `/health/`
  - Health check management command created
  - Health check responding correctly
  - Monitoring service configured (UptimeRobot, Pingdom, etc.)

- [ ] **Backups Configured**
  - Database backup script created
  - Backup cron job scheduled
  - Backup retention policy set (30 days)
  - Backup restoration tested
  - Off-site backups configured

### CI/CD

- [ ] **Pipeline Configured**
  - `.github/workflows/ci.yml` created
  - Tests run on pull requests
  - Security scans configured (bandit, safety)
  - Coverage reporting enabled
  - Deployment automation configured (optional)

---

## Deployment Steps

### Step 1: Final Preparations

- [ ] **Announce Maintenance Window** (if applicable)
  - Notify users of deployment
  - Set maintenance page (if needed)
  - Schedule during low-traffic period

- [ ] **Backup Current State**
  - Backup production database
  - Backup current code version
  - Document current configuration
  - Tag release in git: `git tag v1.0.0`

### Step 2: Deploy Application

- [ ] **Deploy Code**
  ```bash
  cd /home/sithlord/src/BMAD_Forge
  git pull origin main
  source venv/bin/activate
  pip install -r webapp/requirements-prod.txt
  ```

- [ ] **Collect Static Files**
  ```bash
  cd webapp
  python manage.py collectstatic --noinput
  ```

- [ ] **Apply Database Migrations**
  ```bash
  python manage.py migrate
  ```

- [ ] **Restart Application**
  ```bash
  sudo systemctl restart bmad-forge
  sudo systemctl status bmad-forge
  ```

- [ ] **Restart Nginx**
  ```bash
  sudo nginx -t
  sudo systemctl reload nginx
  ```

### Step 3: Verify Deployment

- [ ] **Service Status**
  - Gunicorn running: `systemctl status bmad-forge`
  - Nginx running: `systemctl status nginx`
  - PostgreSQL running: `systemctl status postgresql`
  - No errors in service logs

- [ ] **Check Logs**
  - Application logs: `tail -f /var/log/bmad_forge/django.log`
  - Gunicorn logs: `tail -f /var/log/gunicorn/error.log`
  - Nginx logs: `tail -f /var/log/nginx/bmad-forge-error.log`
  - No error messages present

---

## Post-Deployment Verification

### Automated Checks

- [ ] **Health Check Endpoint**
  ```bash
  curl https://bmadforge.example.com/health/
  # Expected: {"status": "healthy"}
  ```

- [ ] **Django Check**
  ```bash
  python manage.py check --deploy
  # Expected: System check identified no issues
  ```

- [ ] **Management Command Health Check**
  ```bash
  python manage.py health_check
  # Expected: exit code 0
  ```

### Smoke Tests

- [ ] **Homepage Loads**
  - Visit: `https://bmadforge.example.com/`
  - Page loads without errors
  - Static files loading correctly
  - No 404 errors in browser console

- [ ] **Admin Interface**
  - Visit: `https://bmadforge.example.com/admin/`
  - Login successful
  - Can view templates
  - Can create/edit templates

- [ ] **Template List**
  - Visit template list page
  - Templates display correctly
  - Search functionality works
  - Pagination works (if applicable)

- [ ] **Prompt Generation**
  - Select a template
  - Fill in form
  - Generate prompt
  - Prompt displays correctly
  - Can copy prompt to clipboard

- [ ] **GitHub Sync**
  - Trigger template sync
  - Templates fetch from GitHub successfully
  - Database updates correctly
  - No authentication errors

### Security Verification

- [ ] **SSL/TLS**
  - HTTPS working: `https://bmadforge.example.com/`
  - HTTP redirects to HTTPS
  - SSL certificate valid
  - SSL Labs grade A or A+: https://www.ssllabs.com/ssltest/

- [ ] **Security Headers**
  ```bash
  curl -I https://bmadforge.example.com/
  ```
  - Verify `Strict-Transport-Security` header present
  - Verify `X-Content-Type-Options: nosniff`
  - Verify `X-Frame-Options: DENY`
  - Verify `X-XSS-Protection` header

- [ ] **Django Security**
  - Admin not accessible without authentication
  - CSRF protection working
  - Session cookies secure
  - No debug information exposed

### Performance Checks

- [ ] **Response Times**
  - Homepage loads in < 2 seconds
  - Admin loads in < 3 seconds
  - API endpoints respond in < 1 second
  - No slow query warnings in logs

- [ ] **Database Performance**
  - Connection pooling working
  - Query count reasonable (use Django Debug Toolbar in staging)
  - No N+1 query problems

- [ ] **Static Files**
  - Static files served correctly
  - Compression enabled (WhiteNoise)
  - Cache headers set correctly

### Monitoring Verification

- [ ] **Sentry**
  - Test error tracking: trigger a test error
  - Error appears in Sentry dashboard
  - Notifications working (if configured)

- [ ] **Uptime Monitoring**
  - Monitoring service receiving health checks
  - Alerting configured
  - Test alert notification

- [ ] **Log Aggregation**
  - Logs flowing to aggregation service (if configured)
  - Log queries working
  - Alerts configured

---

## Rollback Plan

If critical issues are discovered after deployment:

### Step 1: Assess Impact

- [ ] **Identify Issue**
  - Review error logs
  - Check Sentry for exceptions
  - Verify user reports

- [ ] **Determine Severity**
  - Critical: Immediate rollback required
  - High: Rollback within 1 hour
  - Medium: Fix forward or scheduled rollback
  - Low: Fix in next deployment

### Step 2: Execute Rollback

- [ ] **Revert Code**
  ```bash
  cd /home/sithlord/src/BMAD_Forge
  git checkout v1.0.0  # Previous version tag
  source venv/bin/activate
  pip install -r webapp/requirements-prod.txt
  ```

- [ ] **Rollback Database (if needed)**
  ```bash
  # Only if migrations were applied
  python manage.py migrate forge 0001_previous_migration
  ```

- [ ] **Restore Database Backup (if needed)**
  ```bash
  gunzip -c /var/backups/bmad_forge/db_backup_pre_deploy.sql.gz | \
    psql -U bmad_admin bmad_forge_prod
  ```

- [ ] **Restart Services**
  ```bash
  sudo systemctl restart bmad-forge
  sudo systemctl reload nginx
  ```

### Step 3: Verify Rollback

- [ ] **Run Post-Deployment Checks Again**
  - All smoke tests passing
  - No errors in logs
  - Monitoring healthy

- [ ] **Notify Stakeholders**
  - Inform team of rollback
  - Document issue for post-mortem
  - Schedule fix and re-deployment

---

## Post-Deployment Tasks

### Immediate (within 1 hour)

- [ ] **Monitor Logs**
  - Watch for errors in application logs
  - Monitor Sentry for new exceptions
  - Review Nginx access logs for anomalies

- [ ] **Check Metrics**
  - Response times normal
  - Error rates acceptable (< 1%)
  - Server resources (CPU, memory, disk) healthy

- [ ] **User Verification**
  - Confirm users can access application
  - Verify no user-reported issues
  - Test critical workflows from user perspective

### Short-term (within 24 hours)

- [ ] **Update Documentation**
  - Document deployment process
  - Update runbook with any issues encountered
  - Update architecture diagrams if changed

- [ ] **Team Communication**
  - Announce successful deployment
  - Share release notes
  - Thank team members

- [ ] **Performance Baseline**
  - Establish performance metrics baseline
  - Set up monitoring alerts
  - Review database query performance

### Long-term (within 1 week)

- [ ] **Post-Mortem (if issues occurred)**
  - Document what went wrong
  - Identify root causes
  - Create action items to prevent recurrence

- [ ] **Security Audit**
  - Review access logs for anomalies
  - Verify no unauthorized access attempts
  - Confirm all security headers working

- [ ] **Backup Verification**
  - Verify first automated backup successful
  - Test backup restoration procedure
  - Confirm off-site backup working

- [ ] **Monitoring Tuning**
  - Adjust alert thresholds based on actual traffic
  - Add additional metrics if needed
  - Configure notification preferences

---

## Production Maintenance

### Daily

- [ ] Review error logs
- [ ] Check uptime monitoring status
- [ ] Verify backups completed successfully

### Weekly

- [ ] Review Sentry error trends
- [ ] Check server resource usage
- [ ] Review security logs for anomalies
- [ ] Update dependencies (security patches only)

### Monthly

- [ ] Review performance metrics
- [ ] Rotate logs (if not automated)
- [ ] Test backup restoration procedure
- [ ] Review access logs for suspicious activity
- [ ] Update non-security dependencies

### Quarterly

- [ ] Security audit
- [ ] Performance optimization review
- [ ] Disaster recovery drill
- [ ] Review and update documentation
- [ ] Rotate secrets (SECRET_KEY, database passwords)

---

## Emergency Contacts

Maintain a list of emergency contacts for production issues:

| Role | Name | Contact | Availability |
|------|------|---------|--------------|
| Lead Developer | | | |
| DevOps Engineer | | | |
| Database Admin | | | |
| Security Lead | | | |

---

## Useful Commands

### Check Service Status
```bash
systemctl status bmad-forge
systemctl status nginx
systemctl status postgresql
```

### View Logs
```bash
# Application logs
tail -f /var/log/bmad_forge/django.log

# Gunicorn logs
tail -f /var/log/gunicorn/error.log

# Nginx logs
tail -f /var/log/nginx/bmad-forge-error.log

# System logs
journalctl -u bmad-forge -f
```

### Restart Services
```bash
sudo systemctl restart bmad-forge
sudo systemctl reload nginx
```

### Database Operations
```bash
# Connect to database
psql -U bmad_admin bmad_forge_prod

# Backup database
pg_dump -U bmad_admin bmad_forge_prod | gzip > backup_$(date +%Y%m%d).sql.gz

# Restore database
gunzip -c backup_20260128.sql.gz | psql -U bmad_admin bmad_forge_prod
```

### Django Management
```bash
cd /home/sithlord/src/BMAD_Forge/webapp
source ../venv/bin/activate

# Run migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput

# Check deployment settings
python manage.py check --deploy

# Health check
python manage.py health_check
```

---

## Success Criteria

Deployment is successful when:

1. All pre-deployment checklist items completed
2. Deployment steps executed without errors
3. All post-deployment smoke tests passing
4. No critical errors in logs for 1 hour
5. Monitoring shows healthy status
6. Users can access and use the application
7. Security headers configured correctly
8. SSL/TLS working properly
9. Backups configured and tested
10. Team notified of successful deployment

---

## Additional Resources

- [Django Deployment Checklist](https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/)
- [Production Readiness Guide](PRODUCTION_READINESS.md)
- [Security Guide](SECURITY_GUIDE.md)
- [Django 6 Upgrade Plan](DJANGO6_UPGRADE_PLAN.md)
- [Architecture Documentation](ARCHITECTURE.md)

---

**Document Version:** 1.0
**Last Updated:** 2026-01-28
**Django Version:** 5.2.10 LTS
