# BMAD Forge - Product Requirements Document (PRD)

**Document Version:** 1.1  
**Created:** January 2026  
**Last Updated:** January 2026  
**Status:** Draft/Final  
**Author:** Product Team  

---

## 1. Executive Summary

BMAD Forge is a web-based prompt engineering tool designed to generate, validate, and manage prompts that comply with the BMAD (Breakthrough Method for Agile AI-Driven Development) Framework. The application serves as a centralized platform for teams working with AI coding assistants, enabling them to create structured, consistent, and high-quality prompts that follow BMAD best practices.

The platform addresses the growing need for standardized prompt development in AI-assisted software development. As organizations increasingly adopt AI tools like GitHub Copilot, Claude, and ChatGPT for coding tasks, the quality and consistency of prompts become critical factors in achieving optimal results. BMAD Forge provides the tooling necessary to systematize prompt creation while ensuring compliance with established BMAD methodology.

This document outlines the complete requirements for building BMAD Forge, including functional specifications, technical architecture, user interface designs, and implementation guidelines. The application is built using Django 5.x for the backend, Bootstrap 5 for the frontend, and uses SQLite for development with PostgreSQL support for production deployments.

---

## 2. Problem Statement

### 2.1 Industry Context

The adoption of AI coding assistants has transformed software development workflows across organizations of all sizes. However, this transformation has introduced new challenges related to prompt quality, consistency, and knowledge management. Development teams struggle with several interconnected problems that impact their productivity and the quality of AI-generated outputs.

### 2.2 Core Problems

**Problem 1: Inconsistent Prompt Quality**  
Development team members create prompts independently, leading to significant variations in quality, structure, and effectiveness. Without standardized approaches, even experienced developers may miss critical context or fail to provide AI assistants with sufficient information to generate optimal responses. This inconsistency results in rework, frustration, and suboptimal AI output quality.

**Problem 2: Lack of BMAD Framework Compliance**  
The BMAD Framework provides proven methodologies for structuring effective prompts, but manual compliance checking is error-prone and time-consuming. Team members may not be familiar with all framework requirements, leading to prompts that miss essential sections or fail to follow prescribed structures. The absence of automated validation means non-compliant prompts enter the development workflow undetected.

**Problem 3: Poor Template Management**  
Organizations generate valuable prompt templates through experience and iteration, but these templates often exist only in individual developers' notes or chat histories. Without centralized management, templates are not easily discoverable, cannot be shared across teams, and are frequently recreated from scratch rather than built upon existing work.

**Problem 4: Limited GitHub Integration**  
Many organizations maintain template repositories on GitHub, but accessing and synchronizing these templates requires manual effort or custom scripts. The disconnect between template storage and the prompt engineering workflow creates friction and reduces adoption of shared templates.

### 2.5 Impact of Problems

These problems collectively result in decreased productivity, inconsistent AI output quality, wasted development effort, and limited organizational learning. Teams spend significant time recreating prompts that already exist in some form, while valuable insights about effective prompt strategies remain siloed within individual contributors.

---

## 3. Goals and Objectives

### 3.1 Primary Goals

The primary goals of BMAD Forge are organized into three categories that address the identified problems comprehensively.

**Goal Category 1: Prompt Quality Enhancement**  
The application must automatically validate prompts against BMAD Framework requirements, ensuring all generated prompts include required sections and follow prescribed structures. Validation should occur in real-time during prompt generation, providing immediate feedback when compliance issues are detected. The system should achieve a 95% compliance rate for prompts generated through the platform.

**Goal Category 2: Template Ecosystem Development**  
BMAD Forge must provide robust template management capabilities, including GitHub synchronization, discovery, filtering, and versioning. The platform should support seamless template imports from configured repositories and maintain metadata including agent roles, workflow phases, and update timestamps. Organizations should be able to build and share template libraries that evolve over time.

**Goal Category 3: User Experience Excellence**  
The application must deliver an intuitive, responsive user interface that encourages adoption and reduces friction in the prompt engineering workflow. Users should be able to generate compliant prompts in under five minutes from template selection to output generation. The interface must accommodate both technical and non-technical users effectively.

### 3.2 Measurable Objectives

The following specific, measurable objectives define success criteria for the project.

**Objective 1: Template Adoption**  
Achieve 80% template utilization rate, meaning 80% of generated prompts should originate from existing templates rather than being created from scratch.

**Objective 2: Validation Effectiveness**  
Achieve 100% detection rate for missing required sections and unreplaced template variables. False positive rates for validation warnings should remain below 5%.

**Objective 3: GitHub Integration**  
Enable successful synchronization of templates from GitHub repositories with 99% reliability. Sync operations should complete within 30 seconds for repositories containing fewer than 100 template files.

**Objective 4: User Satisfaction**  
Achieve average user satisfaction rating of 4.0 or higher on a 5-point scale. Target time-to-first-prompt-under-5-minutes for new users.

**Objective 5: Performance Targets**  
Page load times under 2 seconds, API response times under 500 milliseconds for 95% of requests, and 99.9% uptime for production deployments.

---

## 4. Target Users and Use Cases

### 4.1 Primary User Personas

BMAD Forge serves several distinct user personas, each with unique needs and interaction patterns.

**Persona 1: Software Developer**  
Software developers represent the largest user segment and primary consumers of generated prompts. They typically have moderate technical expertise and are primarily interested in quickly generating high-quality prompts for specific coding tasks. Their key needs include fast template discovery, intuitive form interfaces, and reliable validation. They access the platform several times per day, spending 2-5 minutes per session.

**Persona 2: AI/ML Engineer**  
AI and Machine Learning Engineers focus on advanced prompt engineering techniques and often create or modify templates. They have high technical expertise and require access to template source code, configuration options, and validation rules. Their needs include fine-grained control over template variables, batch operations, and integration capabilities.

**Persona 3: Project Manager**  
Project managers use BMAD Forge to understand prompt quality metrics, ensure team compliance with standards, and oversee template governance. They have moderate technical expertise and focus on aggregate views, reporting, and team-level analytics. Their key needs include dashboards, filtering capabilities, and export functionality.

**Persona 4: Product Owner**  
Product owners establish prompt engineering standards, define organizational requirements, and measure platform effectiveness. They have limited technical expertise but need visibility into usage metrics, template effectiveness, and compliance rates. Their needs include executive dashboards, ROI reporting, and strategic planning tools.

**Persona 5: DevOps Engineer**  
DevOps engineers manage platform deployment, infrastructure, and integrations. They have high technical expertise and focus on CI/CD integration, monitoring, and security. Their needs include API access, deployment automation, and operational visibility.

### 4.2 Use Cases

**Use Case 1: Prompt Generation from Template**  
A software developer needs to create a prompt for implementing user authentication. They browse the template library, filter by developer role and development phase, select an appropriate template, fill in required variables (project name, authentication requirements, technology stack), generate the prompt, validate compliance, and copy the output for use in their AI coding assistant.

**Use Case 2: GitHub Template Synchronization**  
An AI/ML engineer maintains a repository of BMAD templates for their organization. They configure GitHub synchronization settings, trigger a manual sync, review changes including new templates and updates, resolve any conflicts, and verify successful import of all templates.

**Use Case 3: Custom Template Creation**  
A senior developer identifies a need for a new template pattern. They create a new template definition with appropriate sections (Your Role, Input, Output Requirements), define template variables using standard syntax, specify agent role and workflow phase associations, test the template with sample data, and publish for team use.

**Use Case 4: Compliance Validation Review**  
A project manager reviews generated prompts for compliance. They access the prompt history view, filter by validation status (valid/invalid), drill down into specific prompts with issues, review validation notes and missing sections, and provide feedback to team members on compliance improvements.

**Use Case 5: Prompt History Analysis**  
A product owner analyzes prompt engineering effectiveness. They access the dashboard view, review template usage metrics and trends, identify underutilized templates, export usage reports, and make decisions about template investment and retirement.

---

## 5. Functional Requirements

### 5.1 Template Management

This section defines requirements for template discovery, management, and governance.

**FR-TM-001: Template Library Display**  
The system must display all active templates in a card-based grid layout. Each template card must show the title, agent role badge, workflow phase badge, variable count, and action buttons (View, Generate). The layout must be responsive and adapt to mobile, tablet, and desktop screen sizes. Templates must be sortable by creation date, last updated, and title alphabetically.

**FR-TM-002: Template Filtering**  
The system must provide filtering capabilities for templates by agent role (Orchestrator, Analyst, PM, Architect, Scrum Master, Developer, QA Engineer) and workflow phase (Planning Phase, Development Phase). Filter selections must be retained during user sessions and reflected in the URL for bookmarking and sharing.

**FR-TM-003: Template Search**  
The system must support full-text search across template titles and descriptions. Search must return results matching the search query in any position within the searchable fields. Search results must be highlighted to indicate matching terms.

**FR-TM-004: Template Detail View**  
The system must display complete template information including title, description, agent role, workflow phase, version, variables list, creation date, last updated date, source GitHub URL (if available), and full template content with syntax highlighting for markdown.

**FR-TM-005: Template Variable Detection**  
The system must automatically detect template variables using both `{{VARIABLE_NAME}}` and `[VARIABLE_NAME]` syntax patterns. Detected variables must be stored as metadata and used for dynamic form generation. The system must support variables with default values using `{{VAR:default}}` syntax.

**FR-TM-006: Template Versioning**  
The system must track template versions and update timestamps. When templates are synchronized from GitHub, the system must detect changes and update existing records. Version history should be maintainable with the ability to view previous versions.

**FR-TM-007: Template Activation/Deactivation**  
Administrators must be able to activate or deactivate templates. Inactive templates must be hidden from the library by default but remain accessible via direct URL for audit purposes. The system must provide bulk activation/deactivation capabilities.

### 5.2 Prompt Generation

**FR-PG-001: Dynamic Form Generation**  
The system must automatically generate input forms based on template variables. Form fields must include appropriate widgets (text input for short values, textarea for long content) based on variable naming conventions. Labels must be human-readable transformations of variable names (e.g., `project_name` becomes "Project Name").

**FR-PG-002: Variable Substitution**  
The system must substitute user-provided values into template content using both `{{VAR}}` and `[VAR]` syntax patterns. Substitution must preserve all non-variable content exactly as defined in the template. The system must handle special characters appropriately.

**FR-PG-003: Form Validation**  
All form fields must be required by default. The system must validate that all required fields are completed before allowing prompt generation. Validation errors must be displayed inline with clear error messages.

**FR-PG-004: Template Preview**  
The system must display the original template content alongside the form interface. The preview must update in real-time or provide a clear preview option to help users understand variable context.

**FR-PG-005: Output Generation**  
The system must generate the final prompt by combining template content with user-provided variable values. Generation must occur server-side to ensure consistency and enable validation. Output must be displayed in a read-only format with syntax highlighting.

### 5.3 BMAD Compliance Validation

**FR-CV-001: Required Section Detection**  
The system must detect the presence of BMAD required sections in generated prompts: `## Your Role`, `## Input`, and `## Output Requirements`. Validation must be case-insensitive and handle various header formats (markdown headers, alternative formatting).

**FR-CV-002: Variable Completion Check**  
The system must verify that all template variables have been replaced with user-provided values. Any unreplaced variables must be flagged with their variable names and positions in the content.

**FR-CV-003: Validation Status Display**  
The system must display clear validation status for each generated prompt. Valid prompts must show a positive indicator (green badge, check icon). Invalid prompts must show a warning indicator (red badge, warning icon) with detailed explanations of all validation failures.

**FR-CV-004: Validation Notes**  
The system must provide specific, actionable validation notes explaining each compliance issue. Notes must include the section or variable affected, the nature of the issue, and recommended remediation steps.

**FR-CV-005: Scoring System**  
The system should calculate and display a compliance score for each generated prompt. The score should reflect the severity of compliance issues (missing required sections = high severity, short content = medium severity, optional section missing = low severity).

### 5.4 GitHub Integration

**FR-GI-001: Repository Configuration**  
Users must be able to configure GitHub repository settings including owner/repo path, branch name, and directory path for templates. Settings should be persistable and editable. The system should support both public and private repositories with token-based authentication.

**FR-GI-002: Manual Synchronization**  
Users must be able to trigger manual synchronization from configured repositories. Sync operations must provide progress feedback and completion status. The system must display the number of templates created, updated, and any errors encountered.

**FR-GI-003: Automatic Detection**  
The system must automatically detect agent role and workflow phase from template content and filenames when synchronizing from GitHub. Detection should use filename patterns (e.g., `developer_` prefix, `_planning` suffix) and content analysis (section presence, keyword matching).

**FR-GI-004: Description Extraction**  
The system must automatically extract template descriptions from the content above the first markdown header. This description must be used for template cards and search indexing.

**FR-GI-005: Sync History**  
The system must maintain a record of sync operations including timestamp, repository configuration, templates created/updated, and any errors. Users must be able to view sync history and retry failed operations.

### 5.5 History and Management

**FR-HM-001: Prompt History Display**  
The system must display a searchable, filterable history of all generated prompts. Each history entry must show the template used, generation timestamp, validation status, and quick actions (view, download).

**FR-HM-002: History Filtering**  
Users must be able to filter history by validation status (all, valid, invalid), date range, and template. Filter state should be reflected in the URL for bookmarking.

**FR-HM-003: Input Data Preservation**  
The system must store all user-provided input data for each generated prompt. This data must be accessible when viewing prompt history and should enable regeneration with modified values.

**FR-HM-004: Bulk Export**  
Users must be able to export prompt history to CSV or JSON format. Exports must include all prompt metadata, input data, and generated content.

### 5.6 Export and Sharing

**FR-ES-001: Copy to Clipboard**  
Users must be able to copy generated prompt content to clipboard with a single click. The system must provide visual feedback confirming successful copy operations.

**FR-ES-002: File Download**  
Users must be able to download generated prompts as text files. Downloaded files must include the prompt content, template information, and generation metadata in a standard format.

**FR-ES-003: URL Sharing**  
The system should support sharing of generated prompts via unique URLs. Shared URLs must be accessible to users without authentication and should display the prompt content and validation results.

### 5.7 Template Creation and Multi-Role Support

This section defines requirements for creating templates and associating them with BMAD agent roles.

**FR-TC-001: YAML Frontmatter Parsing**  
The system must parse YAML frontmatter delimited by `---` markers at the beginning of template files. Frontmatter must support fields including `name`, `description`, `role`, `roles`, `workflow_phase`, `version`, `category`, and `tags`. The system must gracefully handle malformed or missing frontmatter.

**FR-TC-002: Single Role Association**  
Templates must support association with a single BMAD agent role using the `role` field in frontmatter. The role field must accept valid role identifiers: `orchestrator`, `analyst`, `pm`, `architect`, `scrum_master`, `developer`, `qa`.

**FR-TC-003: Multiple Role Association**  
Templates must support association with multiple BMAD agent roles using the `roles` field in frontmatter. The `roles` field must accept a YAML list of valid role identifiers. The first role in the list is considered the primary role for filtering and display purposes.

**FR-TC-004: Role Auto-Detection**  
When no explicit roles are specified in frontmatter, the system must attempt to auto-detect the role using:
1. Filename patterns (e.g., `developer_`, `architect_`, `qa_` prefixes)
2. Content analysis of the `## Your Role` section
3. Default to `developer` if no role can be detected

**FR-TC-005: Workflow Phase Detection**  
When no explicit workflow phase is specified in frontmatter, the system must attempt to auto-detect the phase using:
1. Filename patterns (e.g., `_planning`, `_development` suffixes)
2. Content analysis for phase-specific keywords
3. Default to `development` if no phase can be detected

**FR-TC-006: Template Role Display**  
Templates with multiple roles must display all associated role badges in the template library. The primary role (first in the `roles` list) must be prominently displayed, with secondary roles shown as additional badges.

**FR-TC-007: Multi-Role Filtering**  
Templates must be filterable by any of their associated roles. When filtering by a specific role, templates that include that role in their `roles` list must appear in results, regardless of whether it is the primary role.

**FR-TC-008: Template Database Model**  
The Template model must store both:
- `agent_role`: The primary role (CharField) for backward compatibility and efficient filtering
- `agent_roles`: The complete list of roles (JSONField) for multi-role support

### 5.8 Generate Document Wizard

This section defines requirements for the interactive document generation wizard feature.

**FR-DW-001: Section-Based Wizard**  
The system must provide an interactive wizard that guides users through creating a document section-by-section. Each section of the template must be presented as a separate step in the wizard.

**FR-DW-002: Wizard Navigation**  
Users must be able to navigate forward and backward through wizard steps. A progress indicator must show the current step and total number of steps. Users must be able to jump to any previously completed step.

**FR-DW-003: Section Content Entry**  
Each wizard step must display:
- The section name and description
- Input fields for any variables within that section
- A content textarea for additional user-provided content
- The original template content for reference

**FR-DW-004: Session Persistence**  
User input data must be persisted in the session during wizard progression. Users must be able to navigate between steps without losing previously entered data. Session data must be cleared upon successful document generation.

**FR-DW-005: Generate Document Action**  
Upon completing all wizard steps, users must be able to generate the final document. The system must combine template content with user-provided variable values and section content. The generated document must be validated and stored in the database.

**FR-DW-006: Template Selection Interface**  
The wizard must include a template selection interface with the same filtering capabilities as the main template library (agent role, workflow phase, search).

### 5.9 Real-time Validation

This section defines requirements for the real-time validation feature during document generation.

**FR-RV-001: Immediate Validation Feedback**  
The system must provide immediate validation feedback as users enter content in the document wizard. Validation must occur without page reload using asynchronous requests.

**FR-RV-002: Unreplaced Variable Detection**  
The system must detect unreplaced template variables (`{{VAR}}` or `[VAR]` syntax) in real-time with 100% detection rate. Detected unreplaced variables must be clearly highlighted and listed.

**FR-RV-003: Content Length Warnings**  
The system must warn users when section content appears too short (fewer than 10 words). Warnings must be advisory and not prevent document generation.

**FR-RV-004: Content Quality Suggestions**  
The system must provide contextual suggestions based on section type:
- Role sections: Suggest including responsibilities or objectives
- Input sections: Suggest specifying what inputs are provided
- Output sections: Suggest specifying expected output format

**FR-RV-005: Validation Status Indicators**  
The system must display clear validation status indicators:
- ✅ Green: Content looks good, no issues detected
- ⚠️ Yellow: Warnings detected (e.g., short content)
- ❌ Red: Issues that need attention (e.g., unreplaced variables)

**FR-RV-006: API Endpoint for Validation**  
The system must provide a JSON API endpoint for real-time section validation. The endpoint must accept section name and content, and return validation results including issues, warnings, suggestions, and unreplaced variables.

**FR-RV-007: Final Compliance Check**  
Upon document generation, the system must perform a final BMAD compliance check including:
- Verification of all required sections (## Your Role, ## Input, ## Output Requirements)
- Detection of any remaining unreplaced variables
- Compliance score calculation

**FR-RV-008: Validation Targets**  
The validation system must achieve:
- 95% compliance rate for prompts generated through the platform
- 100% detection rate for missing required sections
- 100% detection rate for unreplaced template variables
- Less than 5% false positive rate for validation warnings

---

## 6. Non-Functional Requirements

### 6.1 Performance Requirements

**NFR-PF-001: Page Load Time**  
All pages must load within 2 seconds on standard broadband connections (10+ Mbps). This requirement applies to initial page loads and subsequent navigations within the application.

**NFR-PF-002: API Response Time**  
API endpoints must respond within 500 milliseconds for 95% of requests. Complex operations like template synchronization may exceed this threshold but must provide progress feedback.

**NFR-PF-003: Concurrent Users**  
The system must support at least 100 concurrent users without degradation in performance. The architecture must support horizontal scaling for larger deployments.

**NFR-PF-004: Large Dataset Handling**  
The system must efficiently handle template libraries with 10,000+ templates and prompt history with 100,000+ entries. Pagination and lazy loading must be implemented for all list views.

### 6.2 Security Requirements

**NFR-SC-001: Authentication**  
For MVP, no user authentication is required. Future versions must support authentication via industry-standard providers (GitHub, Google, SSO). All authentication must use secure session management with appropriate session timeouts.

**NFR-SC-002: Authorization**  
The system must implement role-based access control with at minimum three roles: Administrator (full access), Contributor (create prompts, manage own templates), and Viewer (view prompts, export). Authorization checks must be enforced on all API endpoints.

**NFR-SC-003: Input Validation**  
All user inputs must be validated and sanitized to prevent injection attacks. Template content must be sanitized before display to prevent XSS attacks. File uploads must validate file types and sizes.

**NFR-SC-004: API Security**  
API endpoints must implement rate limiting to prevent abuse. All API communications must use HTTPS. API keys or tokens must be required for programmatic access.

**NFR-SC-005: Data Protection**  
Sensitive data must be encrypted at rest and in transit. Template and prompt data must be backed up regularly. The system must support data export for compliance with data portability requirements.

### 6.3 Availability Requirements

**NFR-AV-001: Uptime Target**  
Production deployments must achieve 99.9% uptime (maximum 8.76 hours of downtime per year). Planned maintenance windows should be scheduled during low-usage periods with appropriate advance notice.

**NFR-AV-002: Disaster Recovery**  
The system must support recovery from database corruption within 4 hours. Backup retention must follow a 7-30-365 strategy (daily for 7 days, weekly for 30 days, monthly for 365 days).

**NFR-AV-003: Graceful Degradation**  
Critical features (prompt generation, validation) must remain available during partial system failures. Non-critical features (GitHub sync, analytics) may display error states while core functionality continues.

### 6.4 Usability Requirements

**NFR-US-001: Accessibility**  
The application must meet WCAG 2.1 AA accessibility standards. All interactive elements must be keyboard accessible. Screen reader compatibility must be verified for all major views.

**NFR-US-002: Responsive Design**  
The application must function correctly on desktop (1024px+), tablet (768-1024px), and mobile (320-768px) viewport sizes. Touch targets must be appropriately sized for mobile interaction.

**NFR-US-003: Internationalization**  
The application interface must support English localization. String externalization must be implemented to facilitate future language additions. Date and time formats must adapt to user locale.

**NFR-US-004: Onboarding**  
New users must be able to generate their first prompt within 5 minutes of first access. Contextual help and inline documentation must guide users through key workflows.

---

## 7. Technical Architecture

### 7.1 Technology Stack

The following technology stack forms the foundation of the BMAD Forge application.

**Backend Technologies**

The backend is built using Python 3.11+ with Django 5.x framework. Django provides robust ORM capabilities, built-in admin interface, security features, and a mature ecosystem of extensions. The choice of Python aligns with AI/ML tooling ecosystems where BMAD Forge templates will be used.

Key backend dependencies include: Django 5.x for web framework, requests 2.31+ for HTTPS client operations (GitHub API integration), python-dotenv 1.0+ for environment configuration management, markdown 3.5+ for template content rendering, beautifulsoup4 4.12+ for HTML parsing during sync operations, and django-widget-tweaks 1.5+ for form rendering customization.

**Database Technologies**

SQLite is used for development and MVP deployments, providing zero-configuration setup and self-contained operation. PostgreSQL is required for production deployments, providing better concurrency, replication, and operational characteristics. Django's ORM provides database abstraction enabling both backends with identical application code.

**Frontend Technologies**

The frontend uses Bootstrap 5 for responsive UI components and grid system. Bootstrap provides consistent styling, responsive breakpoints, and accessible interactive components. Custom CSS extends Bootstrap with dark theme colors, scrollbar styling, and application-specific visual treatments.

Template rendering uses Django's template engine with Jinja2-compatible syntax. Dynamic interactions leverage vanilla JavaScript with no heavy client-side framework, keeping the application lightweight and fast.

**External Services**

GitHub API (v3) provides repository access for template synchronization. The API requires authentication tokens for private repositories and higher rate limits. No other external service dependencies exist for core functionality.

### 7.2 System Architecture

The system follows a standard three-tier architecture with clear separation between presentation, business logic, and data layers.

**Presentation Layer**  
The presentation layer handles HTTPS/TLS requests, renders HTML templates, and manages user sessions. Django views process incoming requests, invoke business logic services, and select appropriate templates for response rendering. Static assets (CSS, JavaScript) are served directly or through Django's static file handling.

**Business Logic Layer**  
The business logic layer contains all application services including template management, prompt generation, validation, and GitHub synchronization. Services are implemented as reusable Python modules with clean interfaces. This layer enforces all business rules and orchestrates operations across data access and external integrations.

**Data Layer**  
The data layer provides persistent storage for templates and generated prompts. Django models define the data schema and provide query interfaces. Database migrations manage schema evolution across versions.

**External Integration Layer**  
The external integration layer handles communication with GitHub's API. A dedicated GitHubSyncService encapsulates API interactions, authentication, and error handling. This layer provides a clean abstraction over external dependencies.

### 7.3 Component Diagram

The application comprises the following major components:

**Web Server Component**  
The web server handles HTTPS requests using Django's WSGI application. Requests are routed to appropriate views based on URL configuration. Middleware components provide session management, security filtering, and request processing hooks.

**Template Engine Component**  
The template engine parses template content, extracts variables using regex patterns, and performs variable substitution. The engine supports both double-brace (`{{VAR}}`) and single-brace (`[VAR]`) syntax variants.

**Validation Engine Component**  
The validation engine analyzes generated prompts against BMAD requirements. It checks for required sections, unreplaced variables, content length, and structural integrity. Validation results are persisted with each generated prompt.

**Sync Service Component**  
The sync service connects to GitHub API, retrieves repository contents, parses template files, and updates the local database. It handles authentication, rate limiting, and error recovery.

**Admin Interface Component**  
Django's built-in admin interface provides data management capabilities for administrators. Custom admin classes extend the base interface with appropriate display and filtering options.

### 7.4 Data Flow

**Prompt Generation Flow**  
The prompt generation flow begins when a user selects a template and accesses the generation form. The system retrieves template content and parses variable definitions. The dynamic form is generated and displayed to the user. When the user submits the form, the system validates all inputs and performs variable substitution. The generated prompt is validated against BMAD requirements. Results are stored in the database, and the user is redirected to the results view.

**Template Synchronization Flow**  
The synchronization flow begins with a user triggering a sync operation. The system authenticates with GitHub API using configured credentials. Repository contents are listed and filtered for template files. Each template file is fetched, parsed, and analyzed. Metadata including agent role and workflow phase are detected. New templates are created, existing templates are updated or skipped based on modification times. Results are logged and displayed to the user.

---

## 8. Data Models

### 8.1 Template Model

The Template model stores BMAD template definitions with all associated metadata.

```python
class Template(models.Model):
    # Core fields
    title = models.CharField(max_length=255, help_text="Template title")
    content = models.TextField(help_text="Template content with placeholders")
    agent_role = models.CharField(max_length=50, choices=AGENT_ROLES)
    workflow_phase = models.CharField(max_length=50, choices=WORKFLOW_PHASES)
    
    # Source tracking
    remote_url = models.URLField(max_length=500, null=True, blank=True)
    remote_path = models.CharField(max_length=500, null=True, blank=True)
    
    # Descriptive metadata
    description = models.TextField(null=True, blank=True)
    version = models.CharField(max_length=50, default="1.0.0")
    variables = models.JSONField(default=list, help_text="Detected variables")
    
    # Status and timestamps
    is_active = models.BooleanField(default=True)
    last_updated = models.DateTimeField(auto_now=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['agent_role', 'workflow_phase', 'title']
        indexes = [
            models.Index(fields=['agent_role', 'workflow_phase']),
            models.Index(fields=['is_active', 'created_at']),
        ]
```

**Field Descriptions**

The `title` field stores the human-readable template name displayed in lists and cards. Maximum length of 255 characters accommodates descriptive titles while maintaining database efficiency.

The `content` field stores the complete template markdown including sections, variable placeholders, and formatting. This is the source of truth for prompt generation.

The `agent_role` field identifies the BMAD agent role associated with the template. Valid values are: orchestrator, analyst, pm, architect, scrum_master, developer, qa.

The `workflow_phase` field identifies the BMAD workflow phase associated with the template. Valid values are: planning, development.

The `remote_url` field stores the GitHub URL where the template was sourced, enabling traceability and refresh operations.

The `remote_path` field stores the file path within the repository for change detection during synchronization.

The `variables` field stores a JSON array of detected variable names. This enables form generation without reparsing content and supports search/indexing use cases.

### 8.2 GeneratedPrompt Model

The GeneratedPrompt model stores generated prompts with input data and validation results.

```python
class GeneratedPrompt(models.Model):
    # Relationship
    template = models.ForeignKey(Template, on_delete=models.CASCADE, 
                                  related_name='generated_prompts')
    
    # Content
    input_data = models.JSONField(help_text="User input for variable substitution")
    final_output = models.TextField(help_text="Generated prompt content")
    
    # Validation
    is_valid = models.BooleanField(default=False)
    validation_notes = models.JSONField(default=list)
    missing_variables = models.JSONField(default=list)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['template', 'created_at']),
            models.Index(fields=['is_valid', 'created_at']),
        ]
```

**Field Descriptions**

The `template` foreign key links each generated prompt to its source template, enabling history views and usage analytics.

The `input_data` field stores the complete user input used for generation as a JSON object. This enables regeneration with modified values and audit of generation decisions.

The `final_output` field stores the complete generated prompt content after variable substitution. This is the primary output consumed by users.

The `is_valid` boolean indicates whether the generated prompt passed all BMAD validation checks. This enables quick filtering in history views.

The `validation_notes` field stores an array of validation notes explaining any compliance issues. Notes include severity, message, and affected sections.

The `missing_variables` field stores any template variables that were not replaced during generation. This helps users identify incomplete forms.

### 8.3 Enumerations

**Agent Roles Enumeration**

The BMAD framework defines seven agent roles with associated capabilities and responsibilities.

| Value | Display Name | Description |
|-------|--------------|-------------|
| orchestrator | Orchestrator | Coordination and oversight of multi-agent workflows |
| analyst | Analyst | Requirements gathering and data analysis |
| pm | Project Manager | Planning, tracking, and stakeholder management |
| architect | Architect | System design and technical architecture |
| scrum_master | Scrum Master | Agile process facilitation and team coordination |
| developer | Developer | Implementation and coding tasks |
| qa | QA Engineer | Testing and quality assurance activities |

**Workflow Phases Enumeration**

The BMAD framework defines two primary workflow phases representing major stages of software development.

| Value | Display Name | Description |
|-------|--------------|-------------|
| planning | Planning Phase | Requirements, analysis, estimation, and planning activities |
| development | Development Phase | Implementation, testing, deployment, and maintenance activities |

---

## 9. User Interface Design

### 9.1 Design System

The BMAD Forge user interface follows a dark theme design system optimized for developer workflows.

**Color Palette**

The primary color palette uses Bootstrap 5's dark mode colors as a foundation with custom extensions.

Background colors include body background at #212529, card background at #2c3034, and surface backgrounds at #1a1d20. These darker backgrounds reduce eye strain during extended use.

Primary accent color is Bootstrap primary blue (#0d6efd) for primary actions and interactive elements. Secondary colors include success green (#198754) for valid states and validation success, danger red (#dc3545) for errors and invalid states, and warning yellow (#ffc107) for cautions.

Border colors use #495057 for component borders and #6c757d for hover states.

**Typography**

The interface uses system fonts for body text with sans-serif fallbacks. Monospace fonts (Fira Code, Consolas) are used for code display in templates and generated prompts. Font sizes follow Bootstrap 5 defaults with slight adjustments for readability.

**Spacing and Layout**

The interface uses Bootstrap 5's spacing scale (0.25rem increments) for consistent padding and margins. Container widths are 1140px maximum for large screens, with full-width options for specific sections.

### 9.2 Page Layouts

**Base Layout (All Pages)**

The base layout provides consistent navigation and footer across all application pages.

The navigation bar includes the application logo (left), primary navigation links (center-left), and version indicator (right). Navigation collapses to a hamburger menu on mobile devices. The navbar uses the dark background color with light text.

The main content area uses a container with appropriate top padding to account for the fixed navbar. Content is vertically centered on the dashboard homepage.

The footer displays copyright information, a link to the BMAD Framework GitHub repository, and version information. The footer is sticky to the bottom of the viewport for shorter pages.

**Dashboard Page**

The dashboard provides an overview of system status and quick access to common actions.

The page is organized into four horizontal sections. The stats cards row displays four metric cards showing total templates, recent prompts, agent roles count, and workflow phases count.

The recent content section displays two side-by-side panels. The left panel lists recently added templates with badges showing agent role and workflow phase. The right panel lists recently generated prompts with validation status badges.

The quick actions section provides four large buttons arranged horizontally on desktop (stacked on mobile). Each button links to a major feature area with an icon and label.

**Template Library Page**

The template library provides browsing, filtering, and search capabilities.

The page header includes the page title, a description, and a Sync Templates button. Below the header, a filter panel provides controls for agent role dropdown, workflow phase dropdown, and search input. Filters use Bootstrap form controls with dark theme styling.

The template grid displays active templates in responsive cards. Each card shows role and phase badges, title, description preview, variable count, and action buttons (View, Generate). The grid uses CSS Grid with auto-fit columns for responsive behavior.

The empty state displays when no templates match filter criteria, providing guidance on clearing filters or initiating template synchronization.

**Template Detail Page**

The template detail page provides comprehensive template information and generation access.

The page header includes the template title, role/phase/version badges, and a Generate Prompt button. A breadcrumb navigation aid helps users maintain context.

The template details card displays metadata in a two-column table including agent role, workflow phase, variables, creation date, last updated date, and source URL if available.

The variables card displays detected variables as badges with code formatting, helping users understand what input will be required.

The template content card displays the full template markdown with syntax highlighting. A vertical scrollbar enables navigation through long templates.

**Prompt Form Page**

The prompt form page provides dynamic form generation and prompt preview.

The page header maintains context with breadcrumb navigation. The form card displays dynamically generated input fields based on template variables. Form fields use appropriate widgets based on variable naming conventions. Labels are human-readable transformations of variable names.

A template preview section below the form displays the original template content with variable highlighting.

**Prompt Result Page**

The prompt result page displays generated output and validation results.

The page header includes the generated prompt title, role/phase badges, validation status badge, and action buttons (Copy, Download, Regenerate).

A validation alert displays prominently at the top of the content area. Valid prompts show a green success alert. Invalid prompts show a yellow warning alert with issue summary.

The generated prompt display shows the complete output in a syntax-highlighted code block with a vertical scrollbar for long content.

An input data summary table shows all variable names and the values provided during generation.

A validation details section appears only for invalid prompts, listing specific issues with explanations and remediation guidance.

**GitHub Sync Page**

The GitHub sync page provides repository configuration and sync initiation.

The page header includes a page title and description. The sync form includes fields for repository URL, branch name, and path. Pre-populated values suggest defaults from configuration.

A default repository info card displays currently configured repository details.

A sync instructions section provides numbered steps explaining the sync process.

**Prompt History Page**

The prompt history page provides searchable, filterable access to generated prompts.

The page header includes title, description, and status filter buttons (All, Valid, Invalid). The history table displays generated prompts with columns for template, role, phase, created timestamp, validation status, and actions.

Pagination controls appear below the table for large result sets. The empty state guides users to browse templates when no history exists.

### 9.3 Component Specifications

**Badge Component**

Badges display categorical information with consistent styling.

Agent role badges use the secondary (grey) background color with uppercase text. Workflow phase badges use dark background with border. Validation status badges use success green for valid and danger red for invalid.

**Card Component**

Cards display related content with consistent borders and backgrounds. Card headers use semi-transparent backgrounds. Card footers use transparent backgrounds with top borders.

**Button Component**

Primary buttons use primary blue background. Secondary buttons use outline styling with primary text color. Button hover states provide visual feedback through background color changes and subtle shadow.

**Form Component**

Form controls use dark background, light text, and grey borders. Focus states use primary color for border and box-shadow. Error states use danger color for borders and error messages.

**Table Component**

Tables use dark background with light text. Header rows use semi-transparent secondary background. Hover states highlight table rows with slightly lighter background.

---

## 10. API Requirements

### 10.1 API Endpoints

The application implements a RESTful API for programmatic access and potential future front-end frameworks.

**Template Endpoints**

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/templates/ | List all templates with filtering |
| GET | /api/templates/{id}/ | Retrieve single template details |
| GET | /api/templates/{id}/content/ | Retrieve template content only |
| GET | /api/templates/{id}/variables/ | Retrieve detected variables |
| POST | /api/templates/ | Create new template (admin) |
| PUT | /api/templates/{id}/ | Update template (admin) |
| DELETE | /api/templates/{id}/ | Delete template (admin) |

**Prompt Endpoints**

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/prompts/ | List generated prompts with filtering |
| GET | /api/prompts/{id}/ | Retrieve single prompt details |
| POST | /api/prompts/generate/ | Generate new prompt from template |
| GET | /api/prompts/{id}/output/ | Retrieve prompt output only |
| GET | /api/prompts/{id}/download/ | Download prompt as file |
| DELETE | /api/prompts/{id}/ | Delete prompt |

**Sync Endpoints**

| Method | Path | Description |
|--------|------|-------------|
| POST | /api/sync/ | Trigger manual sync operation |
| GET | /api/sync/status/ | Check sync status and progress |
| GET | /api/sync/history/ | Retrieve sync operation history |

**Health Check Endpoints**

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/health/ | Basic health check |
| GET | /api/health/detailed/ | Detailed system status |

### 10.2 Request/Response Formats

All API requests and responses use JSON format with consistent structure.

**Template List Response**

```json
{
    "data": [
        {
            "id": 1,
            "title": "Developer Implementation Template",
            "agent_role": "developer",
            "workflow_phase": "development",
            "description": "Template for implementation prompts",
            "variables": ["feature_description", "technical_requirements"],
            "is_active": true,
            "created_at": "2024-01-15T10:30:00Z",
            "last_updated": "2024-01-15T10:30:00Z"
        }
    ],
    "pagination": {
        "page": 1,
        "per_page": 20,
        "total": 50,
        "total_pages": 3
    }
}
```

**Generate Prompt Request**

```json
{
    "template_id": 1,
    "input_data": {
        "feature_description": "User authentication system",
        "technical_requirements": "JWT-based auth with refresh tokens"
    }
}
```

**Generate Prompt Response**

```json
{
    "id": 100,
    "template_id": 1,
    "input_data": {...},
    "final_output": "## Your Role\n...",
    "is_valid": true,
    "validation_notes": [],
    "missing_variables": [],
    "created_at": "2024-01-15T10:35:00Z"
}
```

### 10.3 Authentication and Rate Limiting

API authentication uses token-based authentication for programmatic access. Tokens are issued through user settings and included in the Authorization header: `Authorization: Bearer <token>`.

Rate limiting restricts API calls to prevent abuse. Standard limits are 100 requests per minute for authenticated users and 20 requests per minute for unauthenticated requests. Rate limit headers are included in responses: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`.

---

## 11. Integration Requirements

### 11.1 GitHub Integration

The GitHub integration enables template synchronization from remote repositories.

**Authentication**

Authentication uses GitHub Personal Access Tokens (PAT). Tokens are stored securely in environment variables and never logged or exposed through APIs. Tokens require read permissions for repository contents.

**API Rate Handling**

GitHub API rate limits (5,000 requests/hour for authenticated requests) are respected. The sync service implements exponential backoff for rate limit errors and provides progress feedback during long operations.

**File Processing**

Template files are identified by extension (.md, .txt, .template). Files are fetched using GitHub Contents API with base64 decoding or from the local stored template folder. Content is parsed and validated before database storage.

**Change Detection**

Sync operations compare remote file modification times with local records. Only changed files are updated. Update operations preserve associations with generated prompts.

**Error Handling**

Network errors trigger retry with exponential backoff. Invalid template files are logged and skipped with detailed error messages. Partial sync results are reported with success/error counts.

### 11.2 No Other External Integrations

BMAD Forge does not require any other external service integrations for core functionality. All dependencies are managed internally or through standard Python packages.

---

## 12. Security Architecture

### 12.1 Authentication Strategy

For the MVP release, no user authentication is required. Access is open to all users with no access control.

Future versions will implement authentication through OAuth 2.0 with GitHub as the primary provider. GitHub authentication leverages existing organizational SSO where applicable and simplifies token management for GitHub integration.

Session management uses Django's built-in secure session handling with configurable session lifetimes. Sessions are stored server-side with session IDs in secure cookies.

### 12.2 Authorization Model

Authorization implements role-based access control with the following roles.

**Administrator Role**  
Administrators have full access to all features including user management, system configuration, template management (create, edit, delete), and all prompt operations.

**Contributor Role**  
Contributors can create and manage their own templates, generate prompts, view all templates and prompts, and export prompt history.

**Viewer Role**  
Viewers can view all templates and prompts and export prompt history. Viewers cannot create templates or generate prompts.

### 12.3 Data Protection

**Encryption**  
All data is encrypted in transit using HTTPS/TLS. Data at rest encryption is provided by the underlying database system (SQLite or PostgreSQL). Sensitive configuration values are stored in environment variables.

**Input Sanitization**  
All user inputs are validated on the server side. Template content is sanitized before display to prevent XSS attacks. File uploads validate file types and sizes.

**Access Control**  
Database access is restricted to application processes. API endpoints validate authorization for protected operations. Audit logging tracks all data modifications.

### 12.4 Privacy Considerations

The application does not collect personally identifiable information beyond user-provided data. Template and prompt data is considered organizational intellectual property and protected accordingly. Data export capabilities support organizational compliance requirements.

---

## 13. Testing Requirements

### 13.1 Unit Testing

Unit tests verify individual component functionality in isolation.

**Model Tests**  
Tests cover all model methods including variable extraction, prompt generation, and validation status calculation. Tests verify model relationships and constraints.

**Service Tests**  
Tests cover all service methods including template parsing, variable detection, validation logic, and GitHub synchronization. Tests use mocked external dependencies.

**View Tests**  
Tests cover view logic including template selection, form rendering, and redirect handling. Tests verify authentication and authorization enforcement.

**Form Tests**  
Tests cover form field generation based on template variables and form validation.

### 13.2 Integration Testing

Integration tests verify component interactions and end-to-end workflows.

**Prompt Generation Flow**  
Tests verify the complete flow from template selection through form submission to prompt generation and validation.

**Sync Workflow**  
Tests verify GitHub synchronization including API authentication, file parsing, and database updates.

**Validation Logic**  
Tests verify validation correctly identifies missing sections, unreplaced variables, and other compliance issues.

### 13.3 Test Coverage Requirements

Minimum test coverage requirements are 80% for models, 80% for services, and 60% for views. Overall project coverage must exceed 75%.

### 13.4 Testing Tools

Testing uses pytest as the test runner with pytest-django for Django integration. Tests are located in the `tests/` directory with organized test files matching application modules. Test fixtures provide sample templates and prompts for consistent test data.

---

## 14. Deployment Strategy

### 14.1 Environment Configuration

The application supports three environment configurations.

**Development Environment**  
SQLite database, debug mode enabled, minimal security settings, local file storage for static files.

**Staging Environment**  
PostgreSQL database, debug mode disabled, production-like security settings, Content Delivery Network for static files.

**Production Environment**  
PostgreSQL database with high availability configuration, debug mode disabled, full security hardening, load balancer with SSL termination, CDN for static files, monitoring and alerting enabled.

### 14.2 Container Support

The application is container-ready with a Dockerfile for Docker deployments. Containers use multi-stage builds for efficient image sizes. Container orchestration uses Kubernetes or Docker Compose depending on deployment scale.

### 14.3 CI/CD Pipeline

Continuous integration runs all tests on every pull request. Automated security scanning identifies vulnerabilities in dependencies. Continuous deployment triggers on main branch merges to staging, with manual promotion to production.

### 14.4 Database Migrations

Database migrations are managed through Django's migration system. Migrations are tested against both SQLite and PostgreSQL. Migration execution is automated during deployment with rollback capability.

### 14.5 Rollback Strategy

Application rollback reverts to previous container image. Database rollback uses Django migrations with the ability to migrate forward or backward. Static asset versioning enables instant rollbacks through URL changes.

---

## 15. Implementation Roadmap

### 15.1 Phase 1: Foundation (Weeks 1-2)

**Week 1: Project Setup and Core Models**
- Initialize Django project structure
- Configure development environment
- Implement Template and GeneratedPrompt models
- Create database migrations
- Set up admin interface for models
- Implement basic unit tests

**Week 2: Template Management**
- Implement template list view with filtering
- Implement template detail view
- Create template synchronization service
- Build GitHub API integration
- Implement template variable detection
- Write integration tests for sync workflow

### 15.2 Phase 2: Prompt Generation (Weeks 3-4)

**Week 3: Dynamic Form Generation**
- Implement dynamic form generation from template variables
- Create variable substitution logic
- Build form validation
- Implement prompt generation endpoint
- Write unit tests for form generation

**Week 4: BMAD Validation**
- Implement BMAD required section detection
- Implement variable completion checking
- Create validation result storage
- Build validation result display
- Write comprehensive validation tests

### 15.3 Phase 3: User Interface (Weeks 5-6)

**Week 5: Dashboard and Navigation**
- Implement dashboard with statistics
- Create responsive navigation
- Build consistent page layouts
- Implement dark theme styling
- Test cross-browser compatibility

**Week 6: Prompt Workflow UI**
- Implement template library UI
- Build prompt generation form UI
- Create prompt result display with validation
- Implement copy-to-clipboard and download
- Perform usability testing

### 15.4 Phase 4: Polish and Testing (Weeks 7-8)

**Week 7: History and Export**
- Implement prompt history view
- Build filtering and search for history
- Implement CSV/JSON export
- Create API endpoints for history
- Write API tests

**Week 8: Final Testing and Deployment**
- Complete integration testing
- Performance testing and optimization
- Security review and hardening
- Documentation finalization
- Production deployment

---

## 16. Success Metrics and KPIs

### 16.1 Adoption Metrics

**Metric: Active Users**  
Target: 100 registered users within 30 days of launch. Measurement: Count of unique users generating prompts.

**Metric: Template Utilization**  
Target: 80% of prompts generated from existing templates. Measurement: Ratio of template-origin prompts to total prompts.

**Metric: Daily Active Usage**  
Target: Average 50 daily active users. Measurement: Unique users generating prompts per day.

### 16.2 Quality Metrics

**Metric: Validation Pass Rate**  
Target: 95% of generated prompts pass all validation checks. Measurement: Count of valid prompts / total prompts.

**Metric: GitHub Sync Success Rate**  
Target: 99% of sync operations complete successfully. Measurement: Successful syncs / total sync operations.

**Metric: Template Sync Time**  
Target: 90% of sync operations complete within 30 seconds. Measurement: Sync operation duration.

### 16.3 Performance Metrics

**Metric: Page Load Time**  
Target: 95% of page loads under 2 seconds. Measurement: Server-side and client-side timing.

**Metric: API Response Time**  
Target: 95% of API responses under 500 milliseconds. Measurement: API endpoint timing.

**Metric: System Uptime**  
Target: 99.9% uptime in production. Measurement: Monitoring system uptime tracking.

### 16.4 User Satisfaction Metrics

**Metric: User Satisfaction Score**  
Target: Average rating of 4.0+ on 5-point scale. Measurement: In-app feedback collection.

**Metric: Time to First Prompt**  
Target: New users generate first prompt within 5 minutes. Measurement: Session timing from first visit to first generation.

---

## 17. Appendices

### 17.1 Glossary

| Term | Definition |
|------|------------|
| BMAD | Breakthrough Method for Agile AI-Driven Development - A framework for structuring effective AI prompts |
| Template | A reusable prompt structure with variable placeholders |
| Variable | A placeholder in templates marked with {{VAR}} or [VAR] syntax |
| Agent Role | BMAD persona classification (Developer, Analyst, etc.) |
| Workflow Phase | BMAD phase classification (Planning, Development) |
| Validation | Automated checking of BMAD compliance |
| Sync | GitHub repository synchronization operation |

### 17.2 Reference Links

- BMAD Framework Repository: https://github.com/bmadcode/BMAD-METHOD-v5
- Django Documentation: https://docs.djangoproject.com/
- Bootstrap 5 Documentation: https://getbootstrap.com/docs/5.3/
- GitHub REST API: https://docs.github.com/en/rest
- GitHub Templates: https://github.com/DXCSithlordPadawan/BMAD_Forge/tree/main/bmad_forge/forge/templates

### 17.3 Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-15 | Product Team | Initial document creation |
| 1.1 | 2026-01-28 | Product Team | Added FR-TC (Template Creation and Multi-Role Support), FR-DW (Generate Document Wizard), and FR-RV (Real-time Validation) functional requirements |

---

## 18. Document Approval

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Product Owner | | | |
| Engineering Lead | | | |
| UX Designer | | | |
| QA Lead | | | |

---

**End of Document**
