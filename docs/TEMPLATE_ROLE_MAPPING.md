# Template and Role Mapping Guide

This document provides a comprehensive mapping of all templates and agent templates to their associated BMAD roles, and explains how to configure role associations.

## Quick Reference Table

### Agent Templates (Prompts)

| Template Name | File | Roles | Workflow Phase | Description |
|--------------|------|-------|----------------|-------------|
| System Architect | `architect_prompt.md` | `architect` | Development | Transform product requirements into comprehensive technical architecture blueprints |
| Senior Backend Engineer | `backend_prompt.md` | `developer` | Development | Implement robust, scalable server-side systems from technical specifications |
| DevOps & Deployment Engineer | `devops_prompt.md` | `developer` | Development | Orchestrate complete software delivery lifecycle from containerization to production |
| Senior Frontend Engineer | `frontend_prompt.md` | `developer` | Development | Systematic frontend implementation specialist |
| Epic and Story Generator | `generate_epics.md` | `pm` | Planning | Transform PRDs into lightweight epics and user stories |
| Architecture Brainstorm | `phase1.md` | `analyst` | Planning | Phase 1 planning - brainstorm overall application structure and architecture |
| Feature Specification Engineer | `phase2.md` | `analyst` | Planning | Phase 2 planning - create detailed technical specifications |
| Task Planning Manager | `phase3.md` | `pm` | Planning | Phase 3 planning - create step-by-step action plans |
| Product Manager | `prd_generate_epic_prompt.md` | `pm` | Planning | Transform raw ideas into structured, actionable product plans |
| Product Manager | `productmanager_prompt.md` | `pm` | Planning | Strategic product planning specialist |
| QA Test Automation Engineer | `qa_prompt.md` | `qa` | Development | Comprehensive testing specialist for frontend, backend, or E2E contexts |
| Security Analyst | `security_prompt.md` | `qa` | Development | Comprehensive security analysis and vulnerability assessment |
| Feature Documenter | `selfdocagent_prompt.md` | `developer` | Development | Document new features and significant code changes |
| Quick Feature Documenter | `selfdocslashcommand_prompt.md` | `developer` | Development | Lightweight documentation assistant |
| UX/UI Designer | `uxdesigner_prompt.md` | `developer` | Development | Design user experiences and visual interfaces |

### Document Templates

| Template Name | File | Roles | Workflow Phase | Description |
|--------------|------|-------|----------------|-------------|
| API Documentation | `APIDocumentation_template.md` | `architect`, `developer` | Development | API documentation structure |
| Customer Journey Map | `CustomerJourneyMap_template.md` | `pm`, `analyst` | Planning | Customer journey documentation |
| Design Spec | `DesignSpec_template.md` | `developer`, `architect` | Development | Design specification template |
| Feature Request Document | `FeatureRequestDocument_template.md` | `pm` | Planning | Feature request documentation |
| KPI Dashboard | `KPIDashboard_template.md` | `pm`, `analyst` | Planning | KPI tracking template |
| MVP Feature List | `MVPFeatureList_template.md` | `pm` | Planning | MVP feature planning |
| PRD | `PRD_template.md` | `pm`, `analyst` | Planning | Product Requirements Document |
| Product Backlog | `ProductBacklog_template.md` | `scrum_master`, `pm` | Planning | Product backlog management |
| Product Roadmap | `ProductRoadmap_template.md` | `pm` | Planning | Product roadmap planning |
| Product Security Assessment | `ProductSecurityAssessment_template.md` | `qa`, `architect` | Development | Security assessment template |
| Product Strategy | `ProductStrategy_template.md` | `pm` | Planning | Product strategy documentation |
| Release Plan | `ReleasePlan_template.md` | `scrum_master`, `pm` | Planning | Release planning template |
| Usability Test Plan | `UsabilityTestPlan_template.md` | `qa`, `developer` | Development | Usability testing template |
| User Story Mapping | `UserStoryMapping_template.md` | `pm`, `scrum_master` | Planning | User story mapping template |
| Technical Design Document | `technicaldesigndocument_template.md` | `architect`, `developer` | Development | Technical design specification |

## Available Roles

The following BMAD agent roles are defined in the system (see `webapp/bmad_forge/settings.py`):

| Role ID | Display Name | Description |
|---------|--------------|-------------|
| `orchestrator` | Orchestrator | Coordinates overall workflow and agent interactions |
| `analyst` | Analyst | Performs analysis and research tasks |
| `pm` | Project Manager | Manages product planning and requirements |
| `architect` | Architect | Designs system architecture and technical specifications |
| `scrum_master` | Scrum Master | Manages sprints, backlogs, and release planning |
| `developer` | Developer | Implements frontend, backend, DevOps, and UX solutions |
| `qa` | QA Engineer | Handles testing, security analysis, and quality assurance |

## Available Workflow Phases

| Phase ID | Display Name | Description |
|----------|--------------|-------------|
| `planning` | Planning Phase | Requirements gathering, architecture design, and task planning |
| `development` | Development Phase | Implementation, testing, and deployment |

## How to Associate a Template with Roles

### Method 1: YAML Frontmatter (Recommended)

The easiest and most explicit way to associate a template with roles is to add a `roles` field (for multiple roles) or `role` field (for single role) in the YAML frontmatter at the top of the template file:

#### Single Role Example
```yaml
---
name: my-template-name
description: Brief description of what this template does
role: developer
workflow_phase: development
---

# Template content starts here...
```

#### Multiple Roles Example
```yaml
---
name: prd-template
description: Product Requirements Document template
roles:
  - pm
  - analyst
workflow_phase: planning
---

# Template content starts here...
```

#### Available Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier for the template |
| `description` | Yes | Brief description of template purpose |
| `roles` | Recommended | List of BMAD roles that can use this template |
| `role` | Alternative | Single BMAD role (use `roles` for multiple) |
| `workflow_phase` | Recommended | Either `planning` or `development` |
| `version` | Optional | Template version (e.g., "1.0", "2.0") |
| `category` | Optional | Category for organization (e.g., "documentation", "security") |
| `tags` | Optional | List of tags for searchability |
| `tools` | Optional | List of tools the agent uses |
| `model` | Optional | Preferred AI model (e.g., "sonnet") |

### Method 2: Configuration in config.yaml

For bulk role assignments or overrides, you can configure role mappings in `webapp/config.yaml`:

```yaml
# Template configuration
templates:
  # Role mappings for templates
  role_mappings:
    # Map by filename pattern
    "*_prompt.md": ["developer"]
    "*_template.md": ["pm"]
    "qa_*.md": ["qa"]
    "security_*.md": ["qa", "architect"]
    "architect_*.md": ["architect"]
    
    # Explicit file mappings (override pattern matches)
    explicit:
      "productmanager_prompt.md": ["pm"]
      "PRD_template.md": ["pm", "analyst"]
      "backend_prompt.md": ["developer"]
```

### Method 3: Auto-Detection (Fallback)

If no explicit roles are specified, the system will attempt to auto-detect the role based on:

1. **Filename patterns**: The `github_sync.py` service checks filename for keywords like:
   - `orchestrator` → `orchestrator` role
   - `analyst` → `analyst` role
   - `pm`, `project_manager` → `pm` role
   - `architect` → `architect` role
   - `scrum` → `scrum_master` role
   - `developer`, `dev`, `frontend`, `backend`, `devops` → `developer` role
   - `qa`, `test`, `quality`, `security` → `qa` role

2. **Content analysis**: If filename detection fails, the system analyzes the `## Your Role` section in the template content.

3. **Default**: If no role can be detected, defaults to `developer`.

## Best Practices

1. **Use `roles` for multi-role templates**: When a template can be used by multiple roles, use the `roles` list field
2. **Order roles by relevance**: Put the primary/most relevant role first in the `roles` list
3. **Keep roles consistent**: Use the exact role IDs defined in Available Roles
4. **Include workflow_phase**: Helps organize templates by development stage
5. **Use descriptive names**: The `name` field should clearly identify the template's purpose
6. **Add version information**: Track template versions for change management

## Example: Complete Template with Multiple Roles

```yaml
---
name: technical-design-document
description: Comprehensive technical design specification for system architecture and implementation
roles:
  - architect
  - developer
workflow_phase: development
version: "2.0"
category: documentation
tags:
  - architecture
  - design
  - specification
---

# Technical Design Document

## Overview
This template provides a structure for documenting technical designs...

## Your Role

Act as a technical architect or senior developer creating detailed design specifications...

## Input

You expect to receive:
- Requirements documentation
- System constraints...

## Output Requirements

Your output will include:
- System architecture diagrams
- Component specifications...
```

## Template Loading and Synchronization

Templates are loaded into the database using:

1. **Local loading**: `python manage.py load_local_templates` or `python load_local_templates.py`
2. **GitHub sync**: Through the admin interface or API endpoint

During loading, the system:
1. Parses YAML frontmatter to extract `roles` (or `role`) and `workflow_phase` if present
2. Falls back to auto-detection if not specified
3. Stores both the primary role (`agent_role`) and all roles (`agent_roles`) in the database

## Querying Templates by Role and Workflow Phase

Once loaded, templates can be queried using the TemplateManager's filtering methods:

```python
# In Django/Python
from forge.models import Template
from django.db.models import Q

# =============================
# ROLE FILTERING
# =============================

# Method 1: Use the custom filter_by_role manager method (recommended)
# This handles multi-role templates correctly
queryset = Template.objects.filter(is_active=True)
architect_templates = Template.objects.filter_by_role(queryset, 'architect')

# Method 2: Use primary role field (only matches primary role)
architect_primary_only = Template.objects.filter(agent_role='architect')

# Method 3: Use helper method for checking multiple roles
all_templates = Template.objects.all()
architect_usable = [t for t in all_templates if t.has_role('architect')]

# Method 4: JSONField contains lookup (PostgreSQL recommended)
# Note: This syntax works best with PostgreSQL. For SQLite, consider Method 1.
architect_templates = Template.objects.filter(agent_roles__contains=['architect'])

# =============================
# WORKFLOW PHASE FILTERING
# =============================

# Use the custom filter_by_workflow manager method (recommended)
queryset = Template.objects.filter(is_active=True)
planning_templates = Template.objects.filter_by_workflow(queryset, 'planning')
development_templates = Template.objects.filter_by_workflow(queryset, 'development')

# Direct filtering (alternative)
planning_templates = Template.objects.filter(workflow_phase='planning')

# =============================
# COMBINED FILTERING
# =============================

# Combine role and workflow phase filters
queryset = Template.objects.filter(is_active=True)
queryset = Template.objects.filter_by_workflow(queryset, 'planning')
queryset = Template.objects.filter_by_role(queryset, 'pm')
# Result: PM templates in the planning phase

# Using primary role (database-agnostic):
pm_planning = Template.objects.filter(agent_role='pm', workflow_phase='planning')

# =============================
# HELPER METHODS
# =============================

# Check if a template has a specific role
template = Template.objects.first()
if template.has_role('architect'):
    print(f"{template.title} can be used by architects")

# Get human-readable roles display
print(template.get_roles_display())  # e.g., "Architect, Developer"

# Get all roles as a list
roles = template.get_roles_list()  # e.g., ['architect', 'developer']
```

> **Database Compatibility Note**: The `agent_roles__contains` lookup works best with PostgreSQL. For SQLite or other databases, use the `filter_by_role()` manager method or use the `has_role()` helper method after fetching templates.

## Database Model

The Template model has fields for both role and workflow phase filtering:

| Field | Type | Description |
|-------|------|-------------|
| `agent_role` | CharField | Primary role (for backward compatibility and filtering) |
| `agent_roles` | JSONField | List of all roles that can use this template |
| `workflow_phase` | CharField | Workflow phase (planning or development) |

The `agent_role` field always contains the first/primary role, while `agent_roles` contains the complete list of roles.

## Download Format

When templates are generated and downloaded, they are saved in **Markdown format** (`.md`) to preserve formatting and enable easy viewing in any Markdown-compatible editor or viewer.
