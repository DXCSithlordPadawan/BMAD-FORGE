# IIS Setup Guide for BMAD Forge

## Prerequisites

1. Windows Server 2019/2022 or Windows 10/11 Pro
2. IIS 10.0 or higher installed
3. BMAD Forge deployed to `C:\inetpub\bmad-forge`
4. wfastcgi installed

## Step 1: Install IIS Features

### Via PowerShell (Recommended)

Run as Administrator:

```powershell
# Install IIS with required features
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Install additional features
Install-WindowsFeature Web-CGI, Web-ISAPI-Ext, Web-ISAPI-Filter
```

### Via Server Manager

1. Open Server Manager
2. Click "Add Roles and Features"
3. Select "Web Server (IIS)"
4. Include:
   - CGI
   - ISAPI Extensions
   - ISAPI Filters
   - Management Tools

## Step 2: Install wfastcgi

```powershell
# Activate virtual environment
cd C:\inetpub\bmad-forge
.\venv\Scripts\Activate.ps1

# Install wfastcgi
pip install wfastcgi

# Enable wfastcgi in IIS
wfastcgi-enable
```

Save the output path - you'll need it later (e.g., `C:\inetpub\bmad-forge\venv\Scripts\wfastcgi.py`)

## Step 3: Create IIS Application Pool

### Via IIS Manager

1. Open IIS Manager
2. Right-click "Application Pools" → "Add Application Pool"
3. Settings:
   - **Name**: `BMADForgeAppPool`
   - **.NET CLR Version**: No Managed Code
   - **Managed Pipeline Mode**: Integrated
4. Click "OK"

### Configure Application Pool

1. Select `BMADForgeAppPool`
2. Click "Advanced Settings"
3. Configure:
   - **Start Mode**: AlwaysRunning
   - **Identity**: Custom account with file system access
   - **Idle Time-out**: 0 (disable)
   - **Maximum Worker Processes**: 1 (or more for load balancing)

### Via PowerShell

```powershell
Import-Module WebAdministration

# Create Application Pool
New-WebAppPool -Name "BMADForgeAppPool"

# Configure settings
Set-ItemProperty IIS:\AppPools\BMADForgeAppPool -Name "managedRuntimeVersion" -Value ""
Set-ItemProperty IIS:\AppPools\BMADForgeAppPool -Name "startMode" -Value "AlwaysRunning"
Set-ItemProperty IIS:\AppPools\BMADForgeAppPool -Name "processModel.idleTimeout" -Value "0.00:00:00"
```

## Step 4: Create IIS Website

### Via IIS Manager

1. Right-click "Sites" → "Add Website"
2. Settings:
   - **Site Name**: BMAD Forge
   - **Application Pool**: BMADForgeAppPool
   - **Physical Path**: `C:\inetpub\bmad-forge\webapp`
   - **Binding**: 
     - Type: http
     - IP: All Unassigned
     - Port: 80
     - Host name: (your domain or leave blank)

### Via PowerShell

```powershell
# Create website
New-Website -Name "BMAD Forge" `
    -ApplicationPool "BMADForgeAppPool" `
    -PhysicalPath "C:\inetpub\bmad-forge\webapp" `
    -Port 80
```

## Step 5: Configure FastCGI

### Create web.config

Create `C:\inetpub\bmad-forge\webapp\web.config`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <system.webServer>
    <handlers>
      <add name="Python FastCGI" 
           path="*" 
           verb="*" 
           modules="FastCgiModule" 
           scriptProcessor="C:\inetpub\bmad-forge\venv\Scripts\python.exe|C:\inetpub\bmad-forge\venv\Scripts\wfastcgi.py" 
           resourceType="Unspecified" 
           requireAccess="Script" />
    </handlers>
    
    <rewrite>
      <rules>
        <!-- Redirect to HTTPS (optional) -->
        <!-- <rule name="HTTP to HTTPS" stopProcessing="true">
          <match url="(.*)" />
          <conditions>
            <add input="{HTTPS}" pattern="off" />
          </conditions>
          <action type="Redirect" url="https://{HTTP_HOST}/{R:1}" redirectType="Permanent" />
        </rule> -->
        
        <!-- Django URL Rewrite -->
        <rule name="Django Application" stopProcessing="true">
          <match url="(.*)" />
          <conditions>
            <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
            <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
          </conditions>
          <action type="Rewrite" url="/" />
        </rule>
      </rules>
    </rewrite>
    
    <staticContent>
      <remove fileExtension=".woff" />
      <mimeMap fileExtension=".woff" mimeType="application/font-woff" />
      <remove fileExtension=".woff2" />
      <mimeMap fileExtension=".woff2" mimeType="application/font-woff2" />
    </staticContent>
    
    <security>
      <requestFiltering>
        <requestLimits maxAllowedContentLength="52428800" />
      </requestFiltering>
    </security>
  </system.webServer>
  
  <appSettings>
    <add key="WSGI_HANDLER" value="django.core.wsgi.get_wsgi_application()" />
    <add key="PYTHONPATH" value="C:\inetpub\bmad-forge\webapp" />
    <add key="DJANGO_SETTINGS_MODULE" value="bmad_forge.settings" />
  </appSettings>
</configuration>
```

## Step 6: Set Folder Permissions

```powershell
# Grant IIS_IUSRS access
$path = "C:\inetpub\bmad-forge"
$acl = Get-Acl $path

# Add IIS_IUSRS with full control
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "IIS_IUSRS",
    "FullControl",
    "ContainerInherit,ObjectInherit",
    "None",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl $path $acl

# Grant application pool identity access
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "IIS APPPOOL\BMADForgeAppPool",
    "FullControl",
    "ContainerInherit,ObjectInherit",
    "None",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl $path $acl
```

## Step 7: Configure Static Files

### Option 1: Use WhiteNoise (Recommended)

Already configured in `settings.py`. No additional IIS configuration needed.

### Option 2: Serve via IIS

Add to `web.config` under `<system.webServer>`:

```xml
<handlers>
  <add name="StaticFile" path="static/*" verb="*" modules="StaticFileModule" resourceType="File" requireAccess="Read" />
  <add name="MediaFile" path="media/*" verb="*" modules="StaticFileModule" resourceType="File" requireAccess="Read" />
</handlers>
```

## Step 8: Update Django Settings for Production

Edit `C:\inetpub\bmad-forge\webapp\.env`:

```env
DEBUG=False
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com,localhost
SECRET_KEY=generate-a-new-secret-key-here
```

Generate a new secret key:
```python
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

## Step 9: Collect Static Files

```powershell
cd C:\inetpub\bmad-forge\webapp
C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py collectstatic --noinput
```

## Step 10: Test Configuration

1. Restart IIS:
   ```powershell
   iisreset
   ```

2. Browse to:
   ```
   http://localhost
   ```

3. Check IIS logs:
   ```
   C:\inetpub\logs\LogFiles\
   ```

## Troubleshooting

### 500.0 Internal Server Error

**Cause**: Python or Django configuration issue

**Solutions**:
1. Check `web.config` paths are correct
2. Verify virtual environment exists
3. Check Django settings.py for errors
4. Review Windows Event Viewer

### 403 Forbidden

**Cause**: Permission issues

**Solution**:
```powershell
icacls C:\inetpub\bmad-forge /grant IIS_IUSRS:(OI)(CI)F /T
icacls C:\inetpub\bmad-forge /grant "IIS APPPOOL\BMADForgeAppPool":(OI)(CI)F /T
```

### Static Files Not Loading

**Cause**: Static files not collected or permissions

**Solutions**:
1. Run `collectstatic` again
2. Check `STATIC_ROOT` in settings.py
3. Verify `staticfiles` directory exists and has content
4. Check IIS_IUSRS has read access to staticfiles

### Application Pool Crashes

**Cause**: Python errors or missing dependencies

**Solutions**:
1. Check Application Event Log
2. Enable detailed error messages temporarily:
   ```env
   DEBUG=True
   ```
3. Test Django manually:
   ```powershell
   cd C:\inetpub\bmad-forge\webapp
   C:\inetpub\bmad-forge\venv\Scripts\python.exe manage.py check
   ```

### FastCGI Errors

**Cause**: wfastcgi not properly configured

**Solution**:
```powershell
cd C:\inetpub\bmad-forge
.\venv\Scripts\Activate.ps1
pip uninstall wfastcgi
pip install wfastcgi
wfastcgi-enable
```

Update `web.config` with new paths from output.

## SSL/HTTPS Configuration

### Install SSL Certificate

1. Obtain SSL certificate (Let's Encrypt, commercial CA)
2. Import to Windows Certificate Store
3. Bind to IIS site

### Bind Certificate in IIS

1. Open IIS Manager
2. Select "BMAD Forge" site
3. Right-click → "Edit Bindings"
4. Add new binding:
   - Type: https
   - Port: 443
   - SSL Certificate: (select your certificate)

### Force HTTPS

Uncomment HTTPS redirect in `web.config`:

```xml
<rule name="HTTP to HTTPS" stopProcessing="true">
  <match url="(.*)" />
  <conditions>
    <add input="{HTTPS}" pattern="off" />
  </conditions>
  <action type="Redirect" url="https://{HTTP_HOST}/{R:1}" redirectType="Permanent" />
</rule>
```

## Performance Optimization

### Enable Compression

Add to `web.config`:

```xml
<httpCompression directory="%SystemDrive%\inetpub\temp\IIS Temporary Compressed Files">
  <scheme name="gzip" dll="%Windir%\system32\inetsrv\gzip.dll" />
  <dynamicTypes>
    <add mimeType="text/*" enabled="true" />
    <add mimeType="application/javascript" enabled="true" />
    <add mimeType="application/json" enabled="true" />
  </dynamicTypes>
  <staticTypes>
    <add mimeType="text/*" enabled="true" />
    <add mimeType="application/javascript" enabled="true" />
  </staticTypes>
</httpCompression>
<urlCompression doStaticCompression="true" doDynamicCompression="true" />
```

### Enable Caching

Add to `web.config`:

```xml
<staticContent>
  <clientCache cacheControlMode="UseMaxAge" cacheControlMaxAge="7.00:00:00" />
</staticContent>
```

### Configure FastCGI Settings

```powershell
# Increase FastCGI timeout
Set-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' `
    -Filter "system.webServer/fastCgi/application[@fullPath='C:\inetpub\bmad-forge\venv\Scripts\python.exe']" `
    -Name "activityTimeout" `
    -Value 600

# Set max instances
Set-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' `
    -Filter "system.webServer/fastCgi/application[@fullPath='C:\inetpub\bmad-forge\venv\Scripts\python.exe']" `
    -Name "maxInstances" `
    -Value 4
```

## Monitoring and Logging

### Enable Detailed Logging

Edit `settings.py`:

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': r'C:\inetpub\bmad-forge\logs\django.log',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        },
    },
}
```

### Monitor Application Pool

```powershell
# Check application pool status
Get-WebAppPoolState -Name "BMADForgeAppPool"

# Restart application pool
Restart-WebAppPool -Name "BMADForgeAppPool"
```

## Backup and Recovery

### Backup IIS Configuration

```powershell
# Backup IIS configuration
Backup-WebConfiguration -Name "BMAD-Forge-Backup-$(Get-Date -Format 'yyyyMMdd')"
```

### Restore IIS Configuration

```powershell
# List backups
Get-WebConfigurationBackup

# Restore backup
Restore-WebConfiguration -Name "BMAD-Forge-Backup-20260204"
```

## Security Hardening

1. **Remove Server Header**:
   Add to `web.config`:
   ```xml
   <httpProtocol>
     <customHeaders>
       <remove name="X-Powered-By" />
       <add name="X-Content-Type-Options" value="nosniff" />
       <add name="X-Frame-Options" value="SAMEORIGIN" />
     </customHeaders>
   </httpProtocol>
   ```

2. **Request Filtering**:
   ```xml
   <security>
     <requestFiltering>
       <verbs>
         <add verb="TRACE" allowed="false" />
         <add verb="TRACK" allowed="false" />
       </verbs>
     </requestFiltering>
   </security>
   ```

3. **Enable WAF**: Consider installing ModSecurity for IIS

## Maintenance

### Regular Tasks

- **Weekly**: Check logs for errors
- **Monthly**: Apply Windows and Python updates
- **Quarterly**: Review security settings
- **Yearly**: Renew SSL certificates

### Update Django

```powershell
cd C:\inetpub\bmad-forge
.\venv\Scripts\Activate.ps1
pip install --upgrade django
python webapp\manage.py migrate
iisreset
```

## Support Resources

- IIS Documentation: https://docs.microsoft.com/en-us/iis/
- Django Deployment: https://docs.djangoproject.com/en/stable/howto/deployment/
- wfastcgi: https://pypi.org/project/wfastcgi/
