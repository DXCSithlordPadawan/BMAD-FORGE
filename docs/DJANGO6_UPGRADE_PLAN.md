# Django 6 Upgrade Plan

## Executive Summary

This document provides a comprehensive guide for upgrading BMAD Forge from Django 5.2.10 (LTS) to Django 6.0+.

**Recommendation:** Stay on Django 5.2.10 LTS until Q2-Q3 2026. Django 6.0.1 was just released (January 6, 2026) and the ecosystem needs time to mature.

## Current State

- **Current Version:** Django 5.2.10 (LTS)
- **Target Version:** Django 6.0.1
- **Python Version:** 3.13 (compatible)
- **Blocking Issue:** `requirements.txt` pins `Django>=5.2,<6.0`

## Prerequisites Checklist

Before starting the upgrade:

- [ ] All tests passing on Django 5.2.10
- [ ] Full database backup created
- [ ] Production deployment working correctly
- [ ] All dependencies compatible with Django 6.0
- [ ] Team familiar with breaking changes
- [ ] Staging environment available for testing
- [ ] Rollback plan documented and tested

## Breaking Changes in Django 6.0

### 1. URLField HTTP Scheme Requirement

**Change:** URLField now requires `http://` or `https://` scheme by default.

**Impact:** Low - BMAD Forge doesn't use URLField in models.

**Action Required:** None for current codebase.

### 2. Deprecated Features Removed

**Removed in Django 6.0:**
- Features deprecated in Django 4.2
- Old-style middleware (already using new style)
- Legacy template tags (not used in BMAD Forge)

**Impact:** None - Codebase analysis found zero deprecated features.

### 3. Dependency Updates

**Third-Party Packages:**
- ✅ anthropic==0.42.0 (compatible)
- ✅ Django==5.2.10 → 6.0.1 (upgrade needed)
- ✅ django-widget-tweaks==1.5.0 (compatible)
- ✅ python-dotenv==1.0.1 (compatible)
- ✅ PyGithub==2.5.0 (compatible)
- ✅ requests==2.32.3 (compatible)
- ✅ toml==0.10.2 (compatible)

All dependencies confirmed compatible with Django 6.0.

## Upgrade Steps

### Step 1: Update Requirements

```bash
cd /home/sithlord/src/BMAD_Forge/webapp
```

Edit `requirements.txt`:
```txt
# Change from:
Django>=5.2,<6.0

# To:
Django>=6.0,<7.0
```

### Step 2: Create Backup

```bash
# Backup database
cp db.sqlite3 db.sqlite3.backup.$(date +%Y%m%d_%H%M%S)

# Backup virtual environment (optional)
pip freeze > requirements.backup.$(date +%Y%m%d_%H%M%S).txt
```

### Step 3: Install Django 6.0

```bash
# Activate virtual environment
source venv/bin/activate  # or your venv path

# Upgrade Django
pip install --upgrade Django

# Verify version
python -c "import django; print(django.VERSION)"
# Expected: (6, 0, 1, 'final', 0)
```

### Step 4: Update Dependencies

```bash
# Update all dependencies to latest compatible versions
pip install --upgrade -r requirements.txt

# Generate new frozen requirements
pip freeze > requirements-frozen.txt
```

### Step 5: Run Django System Checks

```bash
# Check for issues
python manage.py check

# Check for deployment issues
python manage.py check --deploy

# Check for deprecation warnings
python manage.py check --tag compatibility
```

### Step 6: Database Migration Check

```bash
# Check for new migrations needed
python manage.py makemigrations --dry-run

# If migrations detected, review them carefully
python manage.py makemigrations

# Apply migrations
python manage.py migrate
```

### Step 7: Run Test Suite

```bash
# Run all tests
pytest --cov=forge --cov-report=term-missing

# Run Django's test command
python manage.py test

# Check for deprecation warnings in tests
python -Wa manage.py test
```

### Step 8: Manual Testing Checklist

Test all critical workflows:

- [ ] Homepage loads correctly
- [ ] Admin interface accessible (`/admin/`)
- [ ] Template list displays
- [ ] Template detail view works
- [ ] Prompt generation functions
- [ ] GitHub sync works
- [ ] Custom template TOML upload
- [ ] Settings configuration
- [ ] Form validation works
- [ ] Error handling displays correctly

### Step 9: Check for Deprecation Warnings

```bash
# Run server with warnings enabled
python -Wa manage.py runserver

# Monitor logs for deprecation warnings
# Address any warnings before deploying to production
```

### Step 10: Performance Testing

```bash
# Test response times for key endpoints
# Compare with Django 5.2.10 baseline

# Check database query performance
# Use Django Debug Toolbar or django-silk

# Monitor memory usage
# Ensure no regression
```

## Testing Strategy

### Unit Tests

```bash
# Run forge app tests
pytest webapp/forge/tests/ -v

# Run with coverage
pytest --cov=forge --cov-report=html
```

### Integration Tests

```bash
# Test GitHub integration
python manage.py test forge.tests.test_github_sync

# Test template processing
python manage.py test forge.tests.test_templates
```

### Smoke Tests

```bash
# Health check endpoint
curl http://localhost:8000/health/

# Admin login
# Navigate to /admin/ and verify login works

# Template generation
# Create a new prompt and verify output
```

## Rollback Procedure

If issues arise during upgrade:

### Quick Rollback (Development)

```bash
# Restore database
cp db.sqlite3.backup.YYYYMMDD_HHMMSS db.sqlite3

# Downgrade Django
pip install Django==5.2.10

# Verify version
python -c "import django; print(django.VERSION)"

# Restart server
python manage.py runserver
```

### Full Rollback (Production)

```bash
# 1. Stop application server
sudo systemctl stop bmad-forge

# 2. Restore database backup
pg_restore -d bmad_forge backup.dump

# 3. Restore Python environment
pip install -r requirements.backup.YYYYMMDD_HHMMSS.txt

# 4. Run migrations to ensure consistency
python manage.py migrate

# 5. Restart application
sudo systemctl start bmad-forge

# 6. Verify application health
curl https://your-domain.com/health/
```

## Timeline and Phasing

### Phase 0: Preparation (Q1 2026)
**Duration:** Ongoing
- Monitor Django 6.0 ecosystem maturity
- Track third-party package updates
- Review Django 6.0 release notes
- Test upgrade in isolated environment

### Phase 1: Development Testing (Q2 2026)
**Duration:** 1 week
- Update local development environment
- Run full test suite
- Manual testing of all features
- Document any issues found

### Phase 2: Staging Deployment (Q2 2026)
**Duration:** 2 weeks
- Deploy to staging environment
- Run extended smoke tests
- Performance benchmarking
- Security audit
- Load testing

### Phase 3: Production Deployment (Q3 2026)
**Duration:** 1 day
- Deploy during maintenance window
- Monitor closely for 48 hours
- Keep rollback plan ready
- Document lessons learned

## Risk Assessment

### Low Risk ✅
- Python 3.13 compatibility (confirmed)
- Third-party dependencies (all compatible)
- Database migrations (simple schema)
- URLField changes (not used in codebase)

### Medium Risk ⚠️
- New Django 6.0 bugs (ecosystem immature)
- Performance regressions (need benchmarking)
- Security changes (need audit)

### High Risk ❌
- Production downtime (mitigate with staging tests)
- Data loss (mitigate with backups)
- Breaking changes not documented (mitigate with thorough testing)

## Success Criteria

Upgrade is successful when:

- ✅ All automated tests passing
- ✅ Zero deprecation warnings
- ✅ All manual test cases passing
- ✅ Performance metrics equal or better than Django 5.2.10
- ✅ No security regressions
- ✅ Production running stable for 48 hours
- ✅ No critical bugs reported

## Recommendation

**Stay on Django 5.2.10 LTS until Q2-Q3 2026.**

**Rationale:**
1. Django 5.2.10 is a Long-Term Support release with security updates until ~2027
2. Django 6.0.1 was just released (January 6, 2026) - ecosystem needs time to mature
3. Production stability is more important than latest features
4. Zero deprecated features in current codebase - no urgency to upgrade
5. LTS version provides predictable support timeline

**When to Revisit:**
- Q2 2026: Monitor Django 6.0 adoption and bug reports
- Q3 2026: Test upgrade in staging if ecosystem stable
- Q4 2026: Consider production upgrade if no blockers

## Resources

- [Django 6.0 Release Notes](https://docs.djangoproject.com/en/6.0/releases/6.0/)
- [Django Deprecation Timeline](https://docs.djangoproject.com/en/6.0/internals/deprecation/)
- [Django Upgrade Guide](https://docs.djangoproject.com/en/6.0/howto/upgrade-version/)

## Appendix: Version History

| Date | Django Version | Status | Notes |
|------|---------------|---------|-------|
| 2024-04-03 | 5.0.4 | Stable | Initial LTS release |
| 2025-12-02 | 5.2.10 | Current | Latest LTS with security updates |
| 2026-01-06 | 6.0.1 | Available | New major version released |
| 2026 Q2-Q3 | 6.0.x | Target | Planned upgrade window |

## Contact

For questions about this upgrade plan:
- Review with team before proceeding
- Test thoroughly in development first
- Document all findings and issues
- Update this document with lessons learned
