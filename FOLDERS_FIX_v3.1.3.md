# BMAD Forge v3.1.3 - Agents & Templates Folder Fix
## Template Auto-Load Missing Folders Issue

**Date:** February 5, 2026  
**Version:** 3.1.3 (Patch)  
**Status:** ✅ **READY**

---

## Issue Fixed

### Problem: Agents and Templates Folders Not Created

**Symptoms:**
- Template auto-load runs but finds 0 templates
- Log shows: "Directory not found: /path/to/agents" or "/path/to/templates"
- Database has 0 templates after startup
- Templates page shows empty list

**Root Cause:**
The deployment script (`deploy.ps1`) didn't copy the `agents/` and `templates/` folders from the package to the project root directory.

**Expected Structure:**
```
C:\inetpub\bmad-forge\
├── agents\                  ← Missing!
│   ├── architect_prompt.md
│   ├── backend_prompt.md
│   └── ... (15 files total)
├── templates\               ← Missing!
│   ├── DesignSpec_template.md
│   ├── PRD_template.md
│   └── ... (15 files total)
└── webapp\
    └── forge\
```

**Impact:**
- Template auto-load feature fails silently
- No templates available in the application
- Users cannot generate documents

---

## Solution Implemented

### Changes Made

#### 1. Updated Deployment Script

**File:** `scripts/deploy.ps1`

**Added:**
- New Step 7.5: "Copy Agents and Templates for Auto-Load"
- Copies all `.md` files from package to project root
- Creates `agents/` and `templates/` directories at project root
- Reports count of files copied

**Code Added (after Step 7):**
```powershell
# === STEP 7.5: Copy Agents and Templates Folders ===
$step = Start-DeploymentStep "Copy Agents and Templates for Auto-Load"
try {
    Write-Info "Copying agents and templates folders..."
    
    # Copy agents folder
    $agentsSource = Join-Path $PackageRoot "agents"
    $agentsDest = Join-Path $ProjectRoot "agents"
    
    if (Test-Path $agentsSource) {
        if (!(Test-Path $agentsDest)) {
            New-Item -ItemType Directory -Path $agentsDest -Force | Out-Null
        }
        
        Get-ChildItem -Path $agentsSource -Filter "*.md" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $agentsDest -Force
        }
        
        $agentCount = (Get-ChildItem -Path $agentsDest -Filter "*.md").Count
        Write-Info "Copied $agentCount agent prompt files"
    }
    
    # Copy templates folder (similar logic)
    ...
}
```

**Also Updated:**
Directory creation in Step 1 to include:
```powershell
(Join-Path $ProjectRoot "agents"),
(Join-Path $ProjectRoot "templates"),
```

#### 2. Created Quick Fix Script

**File:** `scripts/quick-fix-folders.ps1` (NEW)

**Purpose:** Copy folders to existing installations without redeployment

**Usage:**
```powershell
.\quick-fix-folders.ps1 -PackageRoot C:\path\to\extracted\package
```

---

## How It Works Now

### Deployment Flow

```
1. Extract package
   ↓
2. Run deploy.ps1
   ↓
3. Step 1: Create directories
   - Creates C:\inetpub\bmad-forge\agents\
   - Creates C:\inetpub\bmad-forge\templates\
   ↓
4. Step 7.5: Copy files (NEW)
   - Copies 15 agent .md files to agents\
   - Copies 15 template .md files to templates\
   ↓
5. Django starts
   ↓
6. Auto-load runs
   - Finds agents\ folder ✓
   - Finds templates\ folder ✓
   - Loads 30 templates to database ✓
```

### Directory Structure After Fix

```
C:\inetpub\bmad-forge\
├── agents\                          ← NOW CREATED
│   ├── architect_prompt.md
│   ├── backend_prompt.md
│   ├── devops_prompt.md
│   ├── frontend_prompt.md
│   ├── generate_epics.md
│   ├── phase1.md
│   ├── phase2.md
│   ├── phase3.md
│   ├── prd_generate_epic_prompt.md
│   ├── productmanager_prompt.md
│   ├── qa_prompt.md
│   ├── security_prompt.md
│   ├── selfdocagent_prompt.md
│   ├── selfdocslashcommand_prompt.md
│   └── uxdesigner_prompt.md          (15 files)
│
├── templates\                        ← NOW CREATED
│   ├── APIDocumentation_template.md
│   ├── CustomerJourneyMap_template.md
│   ├── DesignSpec_template.md
│   ├── FeatureRequestDocument_template.md
│   ├── KPIDashboard_template.md
│   ├── MVPFeatureList_template.md
│   ├── PRD_template.md
│   ├── ProductBacklog_template.md
│   ├── ProductRoadmap_template.md
│   ├── ProductSecurityAssessment_template.md
│   ├── ProductStrategy_template.md
│   ├── ReleasePlan_template.md
│   ├── UsabilityTestPlan_template.md
│   ├── UserStoryMapping_template.md
│   └── technicaldesigndocument_template.md  (15 files)
│
├── venv\
├── webapp\
│   ├── forge\
│   ├── manage.py
│   └── ...
└── logs\
```

---

## Testing Performed

### Test 1: Fresh Installation ✅

**Steps:**
1. Extracted package
2. Ran `deploy.ps1 -CreateProject`
3. Checked for folders
4. Started server
5. Checked logs

**Expected Result:**
- `C:\inetpub\bmad-forge\agents\` exists with 15 files
- `C:\inetpub\bmad-forge\templates\` exists with 15 files
- Log shows: "Copied 15 agent prompt files"
- Log shows: "Copied 15 document template files"
- Auto-load log: "Template auto-load completed: 30 created"

**Actual Result:** ✅ PASS

### Test 2: Quick Fix on Existing Installation ✅

**Steps:**
1. Ran quick-fix-folders.ps1
2. Verified folders created
3. Restarted server
4. Checked database

**Expected Result:**
- Folders copied successfully
- Server starts without errors
- Auto-load loads 30 templates

**Actual Result:** ✅ PASS

### Test 3: Manual Load Command ✅

**Steps:**
1. With folders in place
2. Ran `python manage.py load_templates`

**Expected Result:**
- Command finds both directories
- Loads 30 templates
- No errors

**Actual Result:** ✅ PASS

---

## Deployment Instructions

### For New Installations

Use the updated deploy.ps1 script:

```powershell
# Extract package
# cd to scripts folder
.\deploy.ps1 -CreateProject
```

The script now automatically:
1. Creates `agents/` and `templates/` folders
2. Copies all `.md` files
3. Prepares for auto-load

### For Existing Installations (Quick Fix)

**Method 1: Quick Fix Script (Recommended)**

```powershell
# Keep the extracted package
cd scripts
.\quick-fix-folders.ps1 -PackageRoot C:\path\to\extracted\package

# Example:
.\quick-fix-folders.ps1 -PackageRoot C:\temp\bmad-forge-v3.1-autoload-package

# Restart server
cd C:\inetpub\bmad-forge\webapp
..\venv\Scripts\python.exe manage.py runserver 8000
```

**Method 2: Manual Copy**

```powershell
# From extracted package, copy folders
$packageRoot = "C:\temp\bmad-forge-v3.1-autoload-package"
$projectRoot = "C:\inetpub\bmad-forge"

# Copy agents
Copy-Item "$packageRoot\agents" -Destination "$projectRoot\agents" -Recurse -Force

# Copy templates  
Copy-Item "$packageRoot\templates" -Destination "$projectRoot\templates" -Recurse -Force

# Verify
Get-ChildItem "$projectRoot\agents" -Filter "*.md"
Get-ChildItem "$projectRoot\templates" -Filter "*.md"
```

**Method 3: Manual Template Load (Fallback)**

If auto-load still fails:

```powershell
cd C:\inetpub\bmad-forge\webapp
..\venv\Scripts\python.exe manage.py load_templates
```

---

## Verification

After applying the fix, verify:

### 1. Check Folders Exist
```powershell
Test-Path C:\inetpub\bmad-forge\agents
Test-Path C:\inetpub\bmad-forge\templates

# Should both return: True
```

### 2. Check File Counts
```powershell
(Get-ChildItem C:\inetpub\bmad-forge\agents -Filter "*.md").Count
# Should return: 15

(Get-ChildItem C:\inetpub\bmad-forge\templates -Filter "*.md").Count
# Should return: 15
```

### 3. Check Auto-Load Logs
```powershell
# Start server and watch logs
..\venv\Scripts\python.exe manage.py runserver 8000

# Look for:
# "Found 15 .md files in agents/"
# "Found 15 .md files in templates/"
# "Template auto-load completed: 30 created, 0 updated, 0 errors"
```

### 4. Check Database
```powershell
# In Django shell
..\venv\Scripts\python.exe manage.py shell

>>> from forge.models import DocumentTemplate
>>> DocumentTemplate.objects.count()
30  # Should see 30 templates

>>> DocumentTemplate.objects.filter(template_type='agent').count()
15  # Should see 15 agent templates

>>> DocumentTemplate.objects.filter(template_type='template').count()
15  # Should see 15 document templates
```

### 5. Check Web Interface

Visit: http://localhost:8000/forge/templates/

Should see:
- 30 templates listed
- Mix of agent prompts and document templates
- Each with title, description, type

---

## Troubleshooting

### Issue: Folders Still Not There

**Check:**
```powershell
# Verify package extraction
Test-Path C:\temp\bmad-forge-v3.1-autoload-package\agents
Test-Path C:\temp\bmad-forge-v3.1-autoload-package\templates
```

**Solution:** Re-extract package, ensure you have the complete archive

### Issue: Auto-Load Says "Directory not found"

**Check Log Path:**
The auto-loader looks relative to project root:
- Expected: `C:\inetpub\bmad-forge\agents\`
- Not: `C:\inetpub\bmad-forge\webapp\agents\`

**Solution:** Folders must be at `$ProjectRoot`, not `$WebAppPath`

### Issue: Files Copied But Not Loading

**Check:**
1. Files have `.md` extension
2. Files have proper YAML frontmatter
3. PyYAML is installed

**Solution:**
```powershell
# Verify PyYAML
pip list | findstr pyyaml

# Manual load with verbose output
python manage.py load_templates
```

### Issue: Permission Denied Copying Files

**Solution:** Run PowerShell as Administrator

---

## Files Changed

### Modified Files (1)

1. **`scripts/deploy.ps1`**
   - Added Step 7.5 for copying folders
   - Updated Step 1 directory creation
   - Lines added: ~50

### New Files (2)

2. **`scripts/quick-fix-folders.ps1`** (NEW)
   - Quick fix script for existing installations
   - Lines: ~180

3. **`FOLDERS_FIX_v3.1.3.md`** (NEW - This file)
   - Complete fix documentation
   - Lines: ~600

---

## Version History

### v3.1.3 (Current) - February 5, 2026
- 🐛 Fixed missing agents/ and templates/ folders in deployment
- ✨ Added Step 7.5 to deploy.ps1
- ✨ Added quick-fix-folders.ps1 script
- 📝 Complete documentation

### v3.1.2 - February 5, 2026
- 🐛 Fixed authentication redirect
- ✨ Added root URL redirect

### v3.1.1 - February 5, 2026
- 🐛 Fixed missing PyYAML dependency
- 🐛 Fixed pip upgrade method

### v3.1.0 - February 5, 2026
- ✨ Template auto-load feature
- ❌ Folders not copied (fixed in v3.1.3)

---

## Impact Assessment

**Severity:** HIGH (auto-load completely non-functional)

**Who is affected:**
- ALL installations (both fresh and existing)
- Anyone relying on template auto-load feature

**Workaround (before fix):**
1. Manually copy folders from package
2. Or manually run `load_templates` command

**After fix:**
- Fresh installations: Works automatically
- Existing installations: Use quick-fix script

---

## Security Notes

This fix:
- ✅ Only copies `.md` files (no executables)
- ✅ Creates folders with standard permissions
- ✅ No changes to authentication or authorization
- ✅ No database schema changes
- ✅ No security implications

---

## Approval

### Development ✅
- [x] Issue identified
- [x] Fix implemented
- [x] Testing completed
- [x] Documentation written

### Quality Assurance ✅
- [x] Fresh install tested
- [x] Quick fix tested
- [x] No regressions found

---

## Conclusion

The agents and templates folders are now properly copied during deployment:

✅ **Folders created** at project root  
✅ **Files copied** (15 agents + 15 templates)  
✅ **Auto-load works** - 30 templates loaded  
✅ **Quick fix available** for existing installations

**Status:** ✅ **READY FOR DEPLOYMENT**

---

**Document Version:** 1.0  
**Last Updated:** February 5, 2026  
**Prepared By:** BMAD Forge Development Team
