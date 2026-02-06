# BMAD Forge User Guide

**Version:** 1.3.0  
**Last Updated:** January 2026

## Table of Contents

1. [Introduction](#1-introduction)
2. [Getting Started](#2-getting-started)
3. [Dashboard Overview](#3-dashboard-overview)
4. [Template Library](#4-template-library)
5. [Generate Document Feature](#5-generate-document-feature)
6. [Prompt Generation](#6-prompt-generation)
7. [BMAD Validation](#7-bmad-validation)
8. [History Management](#8-history-management)
9. [GitHub Synchronization](#9-github-synchronization)
10. [Creating Templates](#10-creating-templates)
11. [Frequently Asked Questions](#11-frequently-asked-questions)

---

## 1. Introduction

### What is BMAD Forge?

BMAD Forge is a web-based prompt engineering tool designed to help teams create, validate, and manage prompts that comply with the BMAD (Breakthrough Method for Agile AI-Driven Development) Framework. The application provides a centralized platform for working with AI coding assistants, enabling the creation of structured, consistent, and high-quality prompts.

### Key Features

- **Template Library**: Browse and filter 15+ BMAD templates by agent role and workflow phase
- **Generate Document**: Interactive wizard for creating documents section-by-section with real-time validation
- **Dynamic Forms**: Auto-generated input forms based on template variables
- **BMAD Compliance**: Automated validation for required sections and unreplaced variables
- **Real-time Validation**: Immediate feedback during prompt generation with 100% detection rate
- **History Management**: Track and review all generated prompts
- **GitHub Sync**: Import templates from remote repositories

### BMAD Framework Requirements

All generated prompts must include these required sections:
- **## Your Role** - Defines the AI assistant's persona and expertise
- **## Input** - Specifies the input data or context provided
- **## Output Requirements** - Describes the expected output format and structure

---

## 2. Getting Started

### Accessing the Application

1. Navigate to BMAD Forge in your web browser (default: http://localhost:8000)
2. You'll land on the Dashboard showing:
   - Total template count
   - Recent prompts
   - Quick action buttons

### First Steps

1. **Browse Templates**: Click "Templates" in the navigation bar to see available templates
2. **Generate a Document**: Use the "Generate Document" menu to create a document step-by-step
3. **Review History**: Check "History" to see previously generated prompts

---

## 3. Dashboard Overview

The Dashboard provides a comprehensive overview of your prompt engineering activities.

### Statistics Cards

- **Total Templates**: Number of active templates available
- **Recent Prompts**: Count of recently generated prompts
- **Agent Roles**: Number of different agent roles represented
- **Workflow Phases**: Number of different workflow phases covered

### Recent Activity

- **Recent Templates**: Quick access to the 5 most recently added templates
- **Recent Prompts**: View the 5 most recently generated prompts with validation status

### Quick Actions

Access key features with one click:
- Browse Templates
- Generate Document
- Sync from GitHub
- View History

---

## 4. Template Library

### Browsing Templates

The Template Library displays all available BMAD templates in a grid layout.

### Filtering Options

BMAD Forge provides powerful filtering capabilities to help you quickly find the right template:

#### Agent Role Filter
Filter templates by BMAD agent role. This filter supports multi-role templates, meaning if a template is associated with multiple roles, it will appear when filtering by any of those roles.

Available roles:
- **Orchestrator**: Coordination and oversight
- **Analyst**: Requirements and data analysis
- **Project Manager (PM)**: Planning and tracking
- **Architect**: System design and architecture
- **Scrum Master**: Agile process facilitation
- **Developer**: Implementation and coding
- **QA Engineer**: Testing and quality assurance

#### Workflow Phase Filter
Filter templates by the BMAD workflow phase they belong to:
- **Planning Phase**: Requirements gathering, architecture design, and task planning
- **Development Phase**: Implementation, testing, and deployment

#### Search
Full-text search across template titles, descriptions, and content. Simply enter keywords to find templates that match your search terms.

#### Combined Filtering
All filters work together, allowing you to narrow down templates by combining multiple criteria. For example, you can filter for "Developer" role templates in the "Development" phase that contain "API" in their content.

### Template Cards

Each template card displays:
- Agent role badges (all roles for multi-role templates)
- Workflow phase badge
- Template title
- Brief description
- Variable count
- Action buttons (Preview, Generate)

### Template Details

Click "Preview" to view:
- Full template content
- List of variables
- Metadata (role, phase, version)

---

## 5. Generate Document Feature

### Overview

The **Generate Document** feature provides an interactive wizard that guides you through creating a document section-by-section. This approach ensures:

- 95%+ compliance rate for generated prompts
- Real-time validation feedback
- Step-by-step guidance

### How to Use

1. **Select a Template**
   - Navigate to "Generate Document" in the menu
   - Browse available templates using filters
   - Click "Generate" on your chosen template

2. **Follow the Wizard**
   - The wizard presents each section one at a time
   - Fill in required variables for each section
   - Add your custom content
   - Review real-time validation feedback

3. **Navigate Steps**
   - Use "Previous" to go back and edit
   - Use "Next" to proceed to the next section
   - A progress indicator shows your current position

4. **Generate Document**
   - After completing all sections, click "Generate Document"
   - Review the final output with validation results
   - Copy to clipboard or download the result

### Real-time Validation

As you enter content, the system provides immediate feedback:

- **✅ Green**: Content looks good, no issues detected
- **⚠️ Yellow**: Warnings (e.g., short content, missing suggestions)
- **❌ Red**: Issues that need attention (e.g., unreplaced variables)

### Validation Checks Performed

The wizard performs these checks in real-time:

| Check | Detection Rate | Description |
|-------|----------------|-------------|
| Unreplaced Variables | 100% | Detects any `{{variable}}` or `[variable]` syntax not replaced |
| Missing Sections | 100% | Ensures all required sections are present |
| Content Length | Advisory | Warns if section content is too short |
| Content Quality | Advisory | Suggests improvements based on section type |

---

## 6. Prompt Generation

### Standard Form-Based Generation

For simpler templates, you can use the standard prompt generation:

1. Select a template from the Template Library
2. Click "Generate Prompt"
3. Fill in all required variables in the form
4. Click "Generate"
5. Review the result with validation status

### Variable Syntax

BMAD Forge supports two variable syntaxes:
- Double braces: `{{VARIABLE_NAME}}`
- Square brackets: `[VARIABLE_NAME]`

### Best Practices

1. **Be Specific**: Provide detailed, specific values for variables
2. **Check Validation**: Review all validation warnings before using the prompt
3. **Save History**: Generated prompts are automatically saved for future reference

---

## 7. BMAD Validation

### Overview

BMAD Forge validates all generated prompts against BMAD Framework requirements to ensure quality and consistency.

### Validation Goals

- **95% compliance rate** for prompts generated through the platform
- **100% detection rate** for missing required sections
- **100% detection rate** for unreplaced template variables
- **< 5% false positive rate** for validation warnings

### Required Sections

Every BMAD-compliant prompt must include:

1. **## Your Role**
   - Defines who the AI should act as
   - Should include responsibilities and expertise

2. **## Input**
   - Specifies what information is being provided
   - Should describe the context and data

3. **## Output Requirements**
   - Describes expected output format
   - Should include structure and specifications

### Optional Sections (Recommended)

- **## Context**: Additional background information
- **## Constraints**: Limitations or requirements
- **## Examples**: Sample outputs or reference materials
- **## Step-by-Step Instructions**: Detailed guidance
- **## Success Criteria**: How to evaluate the output
- **## Notes**: Additional considerations

### Validation Indicators

| Indicator | Meaning |
|-----------|---------|
| ✅ BMAD Compliant | All requirements met |
| ❌ Needs Review | Issues detected - review and fix |

### Validation Report

Each generated prompt includes a detailed validation report showing:
- Overall compliance status
- Missing sections (if any)
- Unreplaced variables (if any)
- Compliance score
- Specific issues to address

---

## 8. History Management

### Viewing History

Access prompt history from "History" in the navigation bar.

### Features

- **Chronological List**: View all generated prompts sorted by date
- **Validation Status**: See at a glance which prompts are valid
- **Filter by Status**: Filter to show only valid or invalid prompts
- **Template Reference**: See which template was used

### Actions

From the history view, you can:
- View the full generated prompt
- Download as a text file
- Copy to clipboard
- Regenerate from the same template

---

## 9. GitHub Synchronization

### Overview

BMAD Forge can sync templates from GitHub repositories, enabling teams to share and version-control their templates.

### Default Repository

The default template repository is configured in `config.yaml`:
```yaml
templates:
  github:
    repository: "DXCSithlordPadawan/BMAD_Forge"
    branch: "main"
    remote_path: "webapp/forge/templates"
```

### Manual Sync

1. Navigate to "Sync" in the navigation bar
2. Enter the repository URL
3. Specify the path to templates
4. Select the branch
5. Click "Sync"

### Sync Results

After syncing, you'll see:
- Number of templates created
- Number of templates updated
- Any errors encountered

### Recursive Search

The sync feature recursively searches all subfolders for templates, making it easy to organize templates in nested directory structures.

---

## 10. Creating Templates

This section explains how to create custom BMAD templates and configure role associations.

### Template File Format

Templates are Markdown files (`.md`) that contain:
1. Optional YAML frontmatter for metadata
2. BMAD-compliant sections with variable placeholders

### YAML Frontmatter

The recommended way to create a template is to include YAML frontmatter at the beginning of the file. This frontmatter is delimited by `---` markers:

```yaml
---
name: my-template-name
description: Brief description of what this template does
role: developer
workflow_phase: development
version: "1.0"
---

# Template content starts here...
```

### Available Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier for the template |
| `description` | Yes | Brief description of template purpose |
| `roles` | Recommended | List of BMAD roles that can use this template |
| `role` | Alternative | Single BMAD role (use `roles` for multiple) |
| `workflow_phase` | Recommended | Either `planning` or `development` |
| `version` | Optional | Template version (e.g., "1.0", "2.0") |
| `category` | Optional | Category for organization |
| `tags` | Optional | List of tags for searchability |

### Associating a Template with a Single Role

For templates that are specific to one role, use the `role` field:

```yaml
---
name: backend-implementation
description: Template for backend feature implementation
role: developer
workflow_phase: development
---

## Your Role

You are a senior backend developer responsible for implementing server-side features.

## Input

You will receive:
- Feature requirements: {{FEATURE_REQUIREMENTS}}
- Technical specifications: {{TECHNICAL_SPECS}}

## Output Requirements

Provide:
- Implementation code
- Unit tests
- API documentation
```

### Associating a Template with Multiple Roles

Many templates can be useful for multiple roles. Use the `roles` field (note the plural) with a list:

```yaml
---
name: technical-design-document
description: Comprehensive technical design specification
roles:
  - architect
  - developer
workflow_phase: development
version: "2.0"
---

## Your Role

Act as a technical architect or senior developer creating detailed design specifications.

## Input

You will receive:
- Requirements documentation: {{REQUIREMENTS}}
- System constraints: {{CONSTRAINTS}}

## Output Requirements

Your output will include:
- System architecture diagrams
- Component specifications
- Implementation guidelines
```

### How Multiple Roles Work

When a template has multiple roles configured:

1. **Primary Role**: The first role in the `roles` list is considered the primary role. This is used for filtering and display purposes.

2. **Role Filtering**: The template will appear when filtering by any of its associated roles.

3. **Role Display**: All associated roles are displayed as badges on the template card.

4. **Backward Compatibility**: If you use the singular `role` field, it is automatically converted to a single-item `roles` list.

### Available Roles

| Role ID | Display Name | Description |
|---------|--------------|-------------|
| `orchestrator` | Orchestrator | Coordinates overall workflow and agent interactions |
| `analyst` | Analyst | Performs analysis and research tasks |
| `pm` | Project Manager | Manages product planning and requirements |
| `architect` | Architect | Designs system architecture and technical specifications |
| `scrum_master` | Scrum Master | Manages sprints, backlogs, and release planning |
| `developer` | Developer | Implements frontend, backend, DevOps, and UX solutions |
| `qa` | QA Engineer | Handles testing, security analysis, and quality assurance |

### Available Workflow Phases

| Phase ID | Display Name | Description |
|----------|--------------|-------------|
| `planning` | Planning Phase | Requirements gathering, architecture design, and task planning |
| `development` | Development Phase | Implementation, testing, and deployment |

### Auto-Detection (Fallback)

If no explicit roles are specified in the frontmatter, the system will attempt to auto-detect the role based on:

1. **Filename patterns**: Keywords like `developer`, `architect`, `qa`, `pm` in the filename
2. **Content analysis**: Examining the `## Your Role` section for role indicators
3. **Default**: If no role can be detected, defaults to `developer`

### Template Structure Requirements

All templates must include these required BMAD sections:

1. **## Your Role** - Defines who the AI should act as
2. **## Input** - Specifies what information is being provided
3. **## Output Requirements** - Describes expected output format

### Variable Syntax

Templates support two variable syntaxes:
- Double braces: `{{VARIABLE_NAME}}`
- Square brackets: `[VARIABLE_NAME]`

Example:
```markdown
## Input

- Project name: {{PROJECT_NAME}}
- Feature description: [FEATURE_DESCRIPTION]
- Technical stack: {{TECH_STACK}}
```

### Complete Template Example

Here's a complete example of a multi-role template:

```yaml
---
name: api-design-document
description: API design and documentation template for architects and developers
roles:
  - architect
  - developer
workflow_phase: development
version: "1.0"
category: documentation
tags:
  - api
  - design
  - rest
---

## Your Role

You are an experienced API designer responsible for creating comprehensive API specifications that balance developer experience with system performance.

## Input

You will receive:
- Service name: {{SERVICE_NAME}}
- Business requirements: {{BUSINESS_REQUIREMENTS}}
- Target consumers: {{TARGET_CONSUMERS}}
- Authentication requirements: {{AUTH_REQUIREMENTS}}

## Output Requirements

Your output must include:
1. **API Overview**: High-level description of the API
2. **Endpoint Definitions**: RESTful endpoint specifications
3. **Request/Response Schemas**: JSON schemas for all payloads
4. **Authentication**: Authentication and authorization details
5. **Error Handling**: Standard error response formats
6. **Rate Limiting**: Rate limiting policies

## Context

Consider these factors when designing the API:
- Backward compatibility requirements
- Performance constraints
- Security best practices

## Examples

Include sample requests and responses for each endpoint.
```

### Adding Templates to the System

Templates can be added in three ways:

1. **GitHub Sync**: Place templates in your GitHub repository and sync them using the GitHub Synchronization feature (see Section 9).

2. **Local Files**: Add template files directly to the `forge/templates/agents/` directory.

3. **Django Admin**: Use the Django admin interface at `/admin/` to manually create templates.

### Best Practices

1. **Use `roles` for multi-role templates**: When a template can be used by multiple roles, always use the `roles` list field
2. **Order roles by relevance**: Put the primary/most relevant role first in the `roles` list
3. **Keep roles consistent**: Use the exact role IDs defined in Available Roles
4. **Include workflow_phase**: Helps organize templates by development stage
5. **Use descriptive names**: The `name` field should clearly identify the template's purpose
6. **Add version information**: Track template versions for change management
7. **Write clear descriptions**: Help users understand when to use each template

---

## 11. Frequently Asked Questions

### General Questions

**Q: What is the BMAD Framework?**
A: BMAD (Breakthrough Method for Agile AI-Driven Development) is a methodology for structuring effective prompts for AI coding assistants.

**Q: Do I need to install anything?**
A: BMAD Forge is a web application. Once deployed, you only need a web browser.

**Q: Can I create my own templates?**
A: Yes, templates can be created manually or synced from GitHub repositories.

### Template Questions

**Q: What variable syntax should I use?**
A: Both `{{VARIABLE_NAME}}` and `[VARIABLE_NAME]` are supported.

**Q: How do I add new templates?**
A: Either sync from a GitHub repository or add template files to the `forge/templates/agents/` directory.

**Q: What makes a template BMAD-compliant?**
A: Templates must include ## Your Role, ## Input, and ## Output Requirements sections.

### Validation Questions

**Q: What causes a "Needs Review" status?**
A: Missing required sections, unreplaced variables, or other validation issues.

**Q: How can I fix unreplaced variables?**
A: Ensure all `{{variable}}` or `[variable]` patterns are filled with actual values.

**Q: What is the false positive rate for warnings?**
A: The validation system targets < 5% false positive rate for warnings.

### Generate Document Questions

**Q: What's the difference between "Generate Prompt" and "Generate Document"?**
A: "Generate Prompt" uses a simple form. "Generate Document" provides a step-by-step wizard with real-time validation for each section.

**Q: Can I go back to edit previous sections?**
A: Yes, use the "Previous" button or click on completed steps in the progress indicator.

**Q: How is my progress saved?**
A: Section data is saved in your session as you progress through the wizard.

### Technical Questions

**Q: What browsers are supported?**
A: BMAD Forge works with all modern browsers (Chrome, Firefox, Safari, Edge).

**Q: Can I use BMAD Forge offline?**
A: The application requires network access to the server, but GitHub sync is optional.

**Q: Where is my data stored?**
A: Generated prompts and templates are stored in the database (SQLite by default).

---

## Support

For additional help or to report issues:
- Check the [ARCHITECTURE.md](ARCHITECTURE.md) for technical details
- Review the [README_WEBAPP.md](../webapp/README_WEBAPP.md) for setup instructions
- Consult the [BMAD Framework](https://github.com/bmadcode/BMAD-METHOD-v5) documentation

---

*This user guide is part of the BMAD Forge documentation suite.*
