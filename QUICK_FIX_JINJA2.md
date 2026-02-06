# Quick Fix: Missing Jinja2 Module

## Issue

If you see this error during deployment or when running the application:

```
ModuleNotFoundError: No module named 'jinja2'
```

## Cause

Jinja2 was not included in the original dependency list, even though the document generator requires it.

## Quick Fix

Run this command in PowerShell as Administrator:

```powershell
C:\inetpub\bmad-forge\venv\Scripts\pip.exe install jinja2
```

Then re-run the Django management commands:

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py makemigrations
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py migrate
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py collectstatic --noinput
```

## Verification

Test that the fix worked:

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py check
```

You should see:
```
System check identified no issues (0 silenced).
```

Then start the server:

```powershell
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py runserver 8000
```

Access http://localhost:8000 - you should see the BMAD Forge homepage.

## For New Deployments

**This issue is fixed in the latest deployment package v3.0.0 (updated February 5, 2026).**

Download the latest package and Jinja2 will be installed automatically.

## Technical Details

The `document_generator.py` file imports Jinja2:

```python
from jinja2 import Template, Environment, BaseLoader
```

This is used to process document templates with variable substitution. Jinja2 is NOT included with Django by default, so it must be explicitly installed.

The deployment script has been updated to include `jinja2` in the dependencies list.
