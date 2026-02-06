# BMAD-FORGE UX Design Documentation

**Version:** 3.0.0  
**Last Updated:** January 2026  
**Document Type:** UX Design System & Guidelines

---

## Table of Contents

1. [Design System Overview](#design-system-overview)
2. [Visual Language](#visual-language)
3. [Navigation & Information Architecture](#navigation--information-architecture)
4. [Page Layouts](#page-layouts)
5. [Interactive Components](#interactive-components)
6. [Document Generation Workflow](#document-generation-workflow)
7. [Document Management UX](#document-management-ux)
8. [Admin Interface](#admin-interface)
9. [Feedback & Messaging](#feedback--messaging)
10. [Export & Download Features](#export--download-features)
11. [Responsive Design](#responsive-design)
12. [Accessibility](#accessibility)

---

## Design System Overview

BMAD-FORGE employs a **modern, professional design system** built on Bootstrap 5.3.0 with minimal custom CSS enhancements. The design philosophy emphasizes:

- **Clarity**: Clean layouts with clear visual hierarchy
- **Usability**: Intuitive workflows with minimal cognitive load
- **Professional Aesthetics**: Corporate-appropriate styling
- **Consistency**: Reusable components throughout the application
- **Efficiency**: Fast interactions with progressive enhancement

### Technology Stack

- **Framework**: Bootstrap 5.3.0 (CDN-delivered)
- **JavaScript**: Vanilla JavaScript (no jQuery)
- **Font Stack**: `'Segoe UI', Tahoma, Geneva, Verdana, sans-serif`
- **Icons**: Unicode emojis (🔨 for brand identity)
- **Layout Engine**: CSS Flexbox & Bootstrap Grid System

---

## Visual Language

### Color Scheme

The application uses a carefully selected color palette optimized for readability and professional appearance:

#### Primary Colors

```css
:root {
    --primary-color: #2c3e50;     /* Dark slate blue - Navigation, footer */
    --secondary-color: #3498db;   /* Bright blue - CTAs, primary actions */
    --success-color: #27ae60;     /* Green - Success states, approved */
    --warning-color: #f39c12;     /* Amber/Gold - Planning phase, warnings */
    --danger-color: #e74c3c;      /* Red - Errors, required fields, delete */
}
```

#### Semantic Colors

- **Primary (#2c3e50)**: Headers, footers, navigation elements
- **Secondary (#3498db)**: Call-to-action buttons, links, informational badges
- **Success (#27ae60)**: Approved documents, development phase, positive feedback
- **Warning (#f39c12)**: Planning phase, cautionary messages
- **Danger (#e74c3c)**: Delete actions, error states, required field indicators
- **Info (#17a2b8)**: Informational messages, statistics
- **Light (#f8f9fa, #f5f5f5)**: Background panels, card backgrounds
- **Dark (#2c3e50)**: Text, navigation

#### Status-Specific Colors

Document status badges use Bootstrap's semantic color system:

- **Draft**: `bg-secondary` (gray-blue)
- **Under Review**: `bg-warning` (amber, with dark text)
- **Approved**: `bg-success` (green)
- **Published**: `bg-primary` (blue)
- **Archived**: `bg-dark` (gray)

#### Role Badge Colors

Agent roles are displayed with primary blue badges (`bg-primary`):
- Orchestrator, Analyst, Project Manager, Architect, Scrum Master, Developer, QA Engineer

#### Phase Badge Colors

- **Planning Phase**: `bg-warning text-dark` (amber with dark text)
- **Development Phase**: `bg-success` (green)

### Typography

#### Font System

```css
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}
```

#### Hierarchy

- **Navbar Brand**: `font-size: 1.5rem; font-weight: bold;`
- **Display Headings**: Bootstrap `.display-4` class (2.5rem)
- **Page Titles**: `<h1>` (2rem, inherited from Bootstrap)
- **Section Headers**: `<h2>` to `<h5>` (1.75rem to 1.25rem)
- **Body Text**: 1rem (16px base)
- **Small Text**: `<small>` or `.text-muted` (0.875rem)
- **Badge Text**: 0.9rem for larger badges, default for standard

#### Text Utilities

- **Bold**: Used for headings, navbar brand, status emphasis
- **Muted**: `text-muted` class for secondary information (timestamps, help text)
- **Lead**: `.lead` class for introductory paragraphs (1.25rem)

### Spacing System

Bootstrap's spacing utilities are used consistently throughout:

#### Padding

- **Component padding**: `p-3` (1rem), `p-4` (1.5rem), `p-5` (3rem)
- **Card bodies**: Default Bootstrap card-body padding
- **Jumbotron**: `p-5` (3rem)
- **Variable groups**: `1rem` custom padding

#### Margins

- **Vertical rhythm**: `mb-2` (0.5rem), `mb-3` (1rem), `mb-4` (1.5rem)
- **Section spacing**: 1.5rem to 2rem between major sections
- **Badge clusters**: `gap-2` (0.5rem) for flexbox spacing

#### Container Spacing

```css
.content {
    padding: 2rem 0;  /* Top and bottom padding for main content area */
}
```

### Shadows & Elevation

Cards use subtle shadows to create depth:

```css
.card {
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.card:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    transform: translateY(-2px);
}

.navbar {
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
```

### Borders & Radius

- **Card borders**: None (relying on shadows for definition)
- **Border radius**: Bootstrap defaults (0.375rem for cards, buttons)
- **Variable groups**: `border-radius: 0.5rem` for slight rounding

---

## Navigation & Information Architecture

### Global Navigation

#### Navbar Structure

```html
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand">🔨 BMAD Forge</a>
        <button class="navbar-toggler">...</button>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li><a href="/">Home</a></li>
                <li><a href="/templates/">Templates</a></li>
                <li><a href="/documents/">Documents</a></li>
                <!-- Conditional auth links -->
                <li><a href="/admin/">Admin</a></li>
                <li><a href="/admin/logout/">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>
```

**Key Features:**
- Fixed top navigation with dark background (`var(--primary-color)`)
- Brand logo with emoji identifier (🔨) on the left
- Right-aligned navigation links (`ms-auto`)
- Responsive collapse for mobile views
- Conditional links based on authentication state

### URL Structure

The application uses Django's namespaced URL routing (`forge:name`):

```python
# Homepage
/                                 # Dashboard/index

# Templates
/templates/                       # Template list with filters
/templates/{id}/                  # Template detail view
/templates/{id}/generate/         # Document generation wizard

# Documents
/documents/                       # Document list with filters
/documents/{id}/                  # Document detail view
/documents/{id}/approve/          # Approve document (POST)
/documents/{id}/download/{format}/  # Download in specified format
/documents/{id}/delete/           # Delete document (POST)

# API Endpoints
/api/templates/{id}/variables/    # Get template variables JSON
/api/validate/                    # Validate document data
```

### Breadcrumb Navigation

Detail pages include Bootstrap breadcrumbs for context and easy navigation:

```html
<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="/">Home</a></li>
        <li class="breadcrumb-item"><a href="/templates/">Templates</a></li>
        <li class="breadcrumb-item active">Template Name</li>
    </ol>
</nav>
```

**Used on:**
- Template detail pages
- Document generation wizard
- Document detail pages

### Filter Persistence

List views (templates, documents) use URL query parameters for filter state:

```
/templates/?role=architect&phase=planning&type=template
/documents/?status=draft&template=5&search=requirements
```

**Benefits:**
- Shareable filtered views
- Browser back/forward support
- Bookmark-able filtered states

**Implementation:**
```javascript
function updateFilter(filterType, value) {
    const url = new URL(window.location);
    if (value) {
        url.searchParams.set(filterType, value);
    } else {
        url.searchParams.delete(filterType);
    }
    window.location.href = url.toString();
}
```

---

## Page Layouts

### 1. Homepage/Dashboard (`index.html`)

**Purpose:** Landing page providing system overview and quick access to key resources

**Layout Structure:**
```
┌─────────────────────────────────────────┐
│ Jumbotron (Welcome Banner + CTA)        │
└─────────────────────────────────────────┘
┌──────────┬──────────┬──────────┐
│ Stat     │ Stat     │ Stat     │ ← 3-column grid
│ Card 1   │ Card 2   │ Card 3   │
└──────────┴──────────┴──────────┘
┌────────────────┬────────────────┐
│ Role Stats     │ Phase Stats    │ ← 2-column grid
│ (Badge Cloud)  │ (Badge Cloud)  │
└────────────────┴────────────────┘
┌─────────────────────────────────────────┐
│ Recent Documents (List Group)           │
└─────────────────────────────────────────┘
```

**Components:**
- **Jumbotron**: Light gray background (`bg-light`), large heading (`.display-4`), lead text, primary CTA button
- **Statistics Cards**: Centered text, large colored numbers, 3-column grid (`col-md-4`)
- **Role/Phase Stats**: Clickable badge clouds with counts, filterable links
- **Recent Documents**: List group with document cards showing title, template, status, date

**Responsive Behavior:**
- Desktop: 3 columns for stats, 2 columns for role/phase
- Tablet: 2 columns for stats, single column for role/phase
- Mobile: Single column layout

### 2. Template List (`template_list.html`)

**Purpose:** Browse and filter available document templates

**Layout Structure:**
```
┌─────────────────────────────────────────┐
│ Search Bar (Full Width)                 │
└─────────────────────────────────────────┘
┌──────────┬──────────┬──────────┐
│ Role     │ Phase    │ Type     │ ← Filter dropdowns
│ Filter   │ Filter   │ Filter   │
└──────────┴──────────┴──────────┘
┌──────────┬──────────┬──────────┐
│ Template │ Template │ Template │ ← 3-column card grid
│ Card     │ Card     │ Card     │
├──────────┼──────────┼──────────┤
│ Template │ Template │ Template │
│ Card     │ Card     │ Card     │
└──────────┴──────────┴──────────┘
```

**Template Card Structure:**
```html
<div class="card h-100">
    <div class="card-body">
        <h5 class="card-title">[Template Name]</h5>
        <p class="card-text">[Description]</p>
        <div class="mb-2">
            <span class="badge bg-primary">[Role]</span>
            <span class="badge bg-warning/success">[Phase]</span>
            <span class="badge bg-info">[Type]</span>
        </div>
    </div>
    <div class="card-footer">
        <a class="btn btn-outline-primary">View Details</a>
        <a class="btn btn-primary">Generate</a>
    </div>
</div>
```

**Interaction Features:**
- Filter dropdowns update URL parameters dynamically
- Cards have hover effects (lift + shadow increase)
- Empty state message when no templates match filters
- Direct "Generate" button for quick document creation

### 3. Template Detail (`template_detail.html`)

**Purpose:** Display comprehensive template information before generation

**Layout Structure:**
```
┌─────────────────────────────────────────┐
│ Breadcrumbs                             │
└─────────────────────────────────────────┘
┌─────────────────────────┬───────────────┐
│                         │               │
│ Template Metadata       │  Action       │
│ (Name, Description,     │  Sidebar      │
│  Badges, Attributes)    │               │
│                         │  • Generate   │
│ Variables Table         │  • Edit       │
│ (Name, Type, Required,  │               │
│  Description, Default)  │  Recent Docs  │
│                         │               │
└─────────────────────────┴───────────────┘
     8-column                  4-column
```

**Metadata Display:**
- **Header**: Template name, description, status badges (role, phase, type)
- **Attributes Table**: 4 rows showing role, phase, category, timestamps
- **Variables Table**: Comprehensive list of template variables with:
  - Variable name
  - Field type (text, textarea, email, number, date, select, checkbox, multiselect)
  - Required indicator (✓ or ✗)
  - Description/help text
  - Default value (if any)

**Sidebar Actions:**
- Large primary button: "Generate Document"
- Secondary link: "Edit Template" (auth required)
- Recent documents list with quick view links

### 4. Document Generation Wizard (`generate_document_wizard.html`)

**Purpose:** Step-through form interface for creating documents from templates

**Layout Structure:**
```
┌─────────────────────────────────────────┐
│ Breadcrumbs                             │
│ Page Title + Template Description       │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Card 1: Document Information            │
│ ┌─────────────────────────────────────┐ │
│ │ Title Input Field                   │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Card 2: Document Content (Variables)    │
│ ┌─────────────────────────────────────┐ │
│ │ Variable Group 1 (gray background)  │ │
│ │ • Label with required indicator (*) │ │
│ │ • Input field (dynamically typed)   │ │
│ │ • Help text (muted)                 │ │
│ │ • Error display (if validation fails)│ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ Variable Group 2                    │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Actions Card                            │
│ [Cancel Button]     [Generate Document] │
└─────────────────────────────────────────┘
```

**Styling Details:**
```css
.wizard-container {
    max-width: 800px;
    margin: 0 auto;
}

.variable-group {
    margin-bottom: 1.5rem;
    padding: 1rem;
    background: #f8f9fa;
    border-radius: 0.5rem;
}

.required-indicator {
    color: #e74c3c;
    font-weight: bold;
}
```

**Dynamic Field Types:**
- **text**: Single-line input (`<input type="text">`)
- **textarea**: Multi-line input with 4 rows
- **email**: Email input with validation
- **number**: Number input
- **date**: HTML5 date picker
- **select**: Dropdown with predefined choices
- **multiselect**: Multiple selection dropdown
- **checkbox**: Boolean checkbox

**Form Validation:**
- Client-side JavaScript validation on submit
- Visual feedback with `.is-invalid` class on empty required fields
- Real-time error removal as user types
- Alert popup if validation fails

### 5. Document List (`document_list.html`)

**Purpose:** Browse, search, and manage generated documents

**Layout Structure:**
```
┌─────────────────────────────────────────┐
│ Search Bar (Full Width)                 │
└─────────────────────────────────────────┘
┌────────────────────┬────────────────────┐
│ Status Filter      │ Template Filter    │
└────────────────────┴────────────────────┘
┌─────────────────────────────────────────┐
│ Responsive Table with Hover Effects     │
│ ┌───────┬─────────┬────────┬──────────┐ │
│ │ Title │Template │ Status │ Actions  │ │
│ ├───────┼─────────┼────────┼──────────┤ │
│ │ Doc 1 │ Template│ Badge  │ View Del │ │
│ │ Doc 2 │ Template│ Badge  │ View Del │ │
│ └───────┴─────────┴────────┴──────────┘ │
└─────────────────────────────────────────┘
```

**Table Columns:**
1. **Title** (linked to detail page)
2. **Template** (template name)
3. **Status** (colored badge)
4. **Created By** (username/full name)
5. **Created Date** (formatted as "M d, Y")
6. **Version** (version number)
7. **Actions** (View button + Delete form)

**Features:**
- Table rows have hover effect for better interaction feedback
- Status badges use semantic colors
- Delete action requires inline confirmation
- Empty state with helpful message and filter reset suggestion
- Filter dropdowns update URL parameters

### 6. Document Detail (`document_detail.html`)

**Purpose:** View generated document with metadata, history, and actions

**Layout Structure:**
```
┌─────────────────────────────────────────┐
│ Breadcrumbs                             │
└─────────────────────────────────────────┘
┌─────────────────────────┬───────────────┐
│                         │               │
│ Document Info Card      │ Actions Card  │
│ • Title + Status Badge  │ • Download    │
│ • Template Link         │   HTML        │
│ • Created timestamp     │   Markdown    │
│ • Reviewer info         │   DOCX        │
│ • Version number        │   PDF (soon)  │
│                         │ • Approve     │
│ Document Preview Card   │ • Delete      │
│ ┌─────────────────────┐ │               │
│ │ Scrollable HTML     │ │ Versions Card │
│ │ Content Display     │ │ • Version 3   │
│ │ (max-height: 600px) │ │ • Version 2   │
│ │                     │ │ • Version 1   │
│ └─────────────────────┘ │               │
│                         │ Activity Card │
│                         │ • Timeline    │
│                         │               │
└─────────────────────────┴───────────────┘
     8-column                  4-column
```

**Document Preview:**
```html
<div class="border p-3" style="max-height: 600px; overflow-y: auto;">
    {{ document.content|safe }}
</div>
```
- Renders sanitized HTML content
- Scrollable container with max height
- Border and padding for visual containment

**Action Sidebar:**

1. **Download Actions** (stacked buttons with `d-grid gap-2`):
   - Primary: Download HTML
   - Outline Primary: Download Markdown
   - Outline Primary: Download DOCX
   - Disabled: Download PDF (coming soon)

2. **Approval Action** (conditional on status='review' + auth):
   - Success button: "Approve Document"

3. **Delete Action** (auth required):
   - Danger button with confirmation dialog
   - Separated from other actions by horizontal rule

**Versions Card:**
- List of clickable version links
- Current version highlighted with `.active` class
- Shows version number and creation date

**Activity History:**
- Timeline-style list of activities
- Each entry shows:
  - Activity type (bold)
  - Timestamp (right-aligned, muted)
  - User who performed action
  - Optional description

---

## Interactive Components

### Forms & Form Validation

#### Django Form Rendering

Forms use Bootstrap 5 styling via widget attributes:

```python
widgets = {
    'name': forms.TextInput(attrs={'class': 'form-control'}),
    'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 3}),
    'status': forms.Select(attrs={'class': 'form-control'}),
    'is_active': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
}
```

#### Client-Side Validation

JavaScript validation in the generation wizard:

```javascript
form.addEventListener('submit', function(e) {
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;
    
    requiredFields.forEach(function(field) {
        if (!field.value.trim()) {
            isValid = false;
            field.classList.add('is-invalid');
        } else {
            field.classList.remove('is-invalid');
        }
    });
    
    if (!isValid) {
        e.preventDefault();
        alert('Please fill in all required fields.');
    }
});
```

#### Real-Time Error Removal

```javascript
inputs.forEach(function(input) {
    input.addEventListener('input', function() {
        this.classList.remove('is-invalid');
    });
});
```

### Dynamic Filter Dropdowns

Filter dropdowns in list views use the `updateFilter()` function:

```html
<select class="form-control" onchange="updateFilter('status', this.value)">
    <option value="">All Statuses</option>
    <option value="draft">Draft</option>
    <option value="review">Under Review</option>
    ...
</select>
```

```javascript
function updateFilter(filterType, value) {
    const url = new URL(window.location);
    if (value) {
        url.searchParams.set(filterType, value);
    } else {
        url.searchParams.delete(filterType);
    }
    window.location.href = url.toString();
}
```

### Search Functionality

Search forms with immediate submission on filter change:

```html
<form method="get" action="">
    <input type="text" name="search" class="form-control" 
           placeholder="Search documents..." value="{{ search_query }}">
</form>
```

Server-side search using Django ORM:
- Case-insensitive search across document titles
- Combined with filter parameters

### Status Badges

**Implementation:**
```html
<span class="badge bg-{{ document.status }}">
    {{ document.get_status_display }}
</span>
```

**Visual Mapping:**
- **Draft** → Gray-blue secondary badge
- **Under Review** → Amber warning badge
- **Approved** → Green success badge
- **Published** → Blue primary badge
- **Archived** → Gray dark badge

### Role Badges

```html
<span class="badge bg-primary">{{ role_display }}</span>
```

All roles use primary blue color for consistency:
- Orchestrator, Analyst, PM, Architect, Scrum Master, Developer, QA

### Phase Badges

```html
<span class="badge {% if phase == 'planning' %}bg-warning text-dark{% else %}bg-success{% endif %}">
    {{ phase_display }}
</span>
```

- **Planning**: Amber with dark text for contrast
- **Development**: Green success badge

### Action Buttons

#### Primary Actions
```html
<button type="submit" class="btn btn-primary">Generate Document</button>
<a href="..." class="btn btn-primary">Download HTML</a>
```

#### Secondary Actions
```html
<a href="..." class="btn btn-outline-primary">View Details</a>
<a href="..." class="btn btn-outline-secondary">Cancel</a>
```

#### Destructive Actions
```html
<button type="submit" class="btn btn-danger w-100">Delete Document</button>
```

#### Disabled Actions
```html
<a href="#" class="btn btn-outline-secondary" disabled>
    Download PDF (Coming Soon)
</a>
```

### Inline Confirmations

Delete actions use native browser confirmation:

```html
<form method="post" action="..." 
      onsubmit="return confirm('Are you sure you want to delete this document? This action cannot be undone.');">
    <button type="submit" class="btn btn-danger">Delete</button>
</form>
```

### Card Hover Effects

```css
.card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
```

- Subtle lift animation (2px upward)
- Enhanced shadow on hover
- Smooth transition (0.2s)

---

## Document Generation Workflow

### User Journey

```
1. Browse Templates
   ↓
2. Select Template → View Template Details
   ↓
3. Click "Generate Document"
   ↓
4. Fill Document Information (Title)
   ↓
5. Fill Template Variables (Dynamic Form)
   ↓
6. Submit Form → Client-Side Validation
   ↓
7. Server Processing → Document Created
   ↓
8. Redirect to Document Detail Page
   ↓
9. View Document → Download/Approve/Share
```

### Step 1: Template Selection

**Entry Points:**
- Homepage CTA: "Browse Templates"
- Navigation: "Templates" link
- Filtered links from homepage stats

**User Actions:**
- Browse template cards in 3-column grid
- Apply filters (role, phase, type)
- Search templates by keyword
- Click "View Details" for more information
- Click "Generate" to start creation process

### Step 2: Template Detail Review

**Information Presented:**
- Template name and description
- Agent role, workflow phase, category
- Complete variable specification table
- Recent documents generated from this template

**Decision Point:**
- User reviews variables required
- Determines if template meets needs
- Clicks "Generate Document" to proceed

### Step 3: Document Generation Wizard

**Wizard Structure:**

**Card 1: Document Information**
- Single required field: Document title
- Help text guides user on naming conventions

**Card 2: Document Content**
- Dynamically generated form fields based on template variables
- Each variable displayed in a gray-background group:
  - Label with visual required indicator (red asterisk)
  - Appropriate input type (text, textarea, date, select, etc.)
  - Help text below field (muted color)
  - Real-time validation feedback

**Progressive Disclosure:**
- Only shows relevant fields for selected template
- Complex variables (multiselect, textarea) given more visual weight
- Required fields clearly marked

### Step 4: Form Submission & Validation

**Client-Side Validation:**
1. User clicks "Generate Document"
2. JavaScript checks all required fields
3. Empty fields highlighted with `.is-invalid` class
4. Alert message if validation fails
5. Form submission prevented until valid

**Server-Side Processing:**
1. Django form validation
2. Template variable extraction
3. Jinja2 template rendering
4. HTML content generation
5. Document saved with status='draft'
6. Activity log created

### Step 5: Post-Generation

**Success Flow:**
- User redirected to document detail page
- Success message displayed: "Document generated successfully"
- Document preview shown immediately
- Action buttons available (download, approve, delete)

**Error Handling:**
- Validation errors displayed above form
- Field-specific errors shown in red below inputs
- User can correct and resubmit without losing data

---

## Document Management UX

### Document List Interface

**Primary Use Cases:**
1. Browse all generated documents
2. Filter by status or template
3. Search by title
4. Quick access to document details
5. Bulk management via admin

**Filtering Capabilities:**
- **Status Filter**: Draft, Review, Approved, Published, Archived
- **Template Filter**: Dropdown of all active templates
- **Search**: Real-time search by document title
- **Date Range**: From/To date filters (available in search form)

**Table Interaction:**
- Sortable by clicking column headers (future enhancement)
- Hover effect on rows for better selection feedback
- Clickable title links to detail page
- Inline delete action with confirmation

### Document Detail Interface

**Information Architecture:**

**Left Column (8-width):**
1. **Metadata Card**: Essential document information
   - Title with status badge
   - Template reference (linked)
   - Creation timestamp and author
   - Review information (if applicable)
   - Version number

2. **Preview Card**: Rendered document content
   - Scrollable container (max 600px height)
   - Full HTML rendering with styles
   - Border and padding for visual separation

**Right Sidebar (4-width):**
1. **Actions Card**: Primary user actions
   - Download in multiple formats
   - Approve document (conditional)
   - Delete document (destructive, auth required)

2. **Versions Card**: Version history
   - List of all versions
   - Current version highlighted
   - Clickable links to view other versions

3. **Activity History Card**: Audit trail
   - Chronological timeline
   - Activity type and timestamp
   - User attribution
   - Optional descriptions

### Document Lifecycle Visualization

```
┌────────┐    ┌────────┐    ┌─────────┐    ┌───────────┐    ┌──────────┐
│ Draft  │ → │ Review │ → │Approved │ → │ Published │ → │ Archived │
└────────┘    └────────┘    └─────────┘    └───────────┘    └──────────┘
   Gray         Amber         Green            Blue            Dark Gray

User Actions at Each Stage:
• Draft: Edit, Delete, Submit for Review
• Review: Approve, Reject (return to Draft), Delete
• Approved: Publish, Archive, Create New Version
• Published: Archive, Create New Version
• Archived: Restore (return to Published), Delete
```

### Version Tracking UX

**Version Creation:**
- Automatic versioning when document is modified
- Parent-child relationship maintained
- Version number increments sequentially

**Version Display:**
- Sidebar shows all versions in reverse chronological order
- Current version highlighted with Bootstrap `.active` class
- Each version shows: version number, creation date
- Clicking a version loads that version's detail page

**Version Comparison:**
- Future enhancement: Side-by-side diff view
- Currently: Navigate between versions manually

### Activity History Timeline

**Events Tracked:**
- Document created
- Submitted for review
- Approved/rejected
- Status changed
- Downloaded (format specified)
- Deleted

**Timeline Display:**
```html
<div class="list-group-item">
    <div class="d-flex justify-content-between">
        <strong>{{ activity_type }}</strong>
        <small class="text-muted">{{ timestamp }}</small>
    </div>
    <small class="text-muted">by {{ user }}</small>
    <p class="mb-0 mt-1"><small>{{ description }}</small></p>
</div>
```

---

## Admin Interface

### Django Admin Customizations

BMAD-FORGE extends Django's admin interface with custom features for template and document management.

#### DocumentTemplate Admin

**List View Customizations:**
- **Columns**: Name, Document Type, Template Type, Agent Role, Workflow Phase, Active Status, Timestamps, Document Count
- **Filters**: Document type, template type, agent role, workflow phase, category, active status, creation date
- **Search**: By name, description, source file
- **Custom Column**: "Documents" shows count of generated documents with bold formatting

**Fieldsets Organization:**
1. **Basic Information**: Name, document type, description, active status
2. **BMAD Configuration**: Template type, agent role, agent roles, workflow phase, category, source file
3. **Template Content**: Template content, CSS, JavaScript, variables (wide fields)
4. **Metadata**: Timestamps, creator (collapsed by default)

**Custom Actions:**
- **Import Template**: Custom admin view with file upload form

#### Template Import Wizard

**Purpose:** Streamline template creation from markdown files

**Interface:**
```
┌─────────────────────────────────────────┐
│ Import Template                         │
├─────────────────────────────────────────┤
│ Template File (.md): [Browse]          │
│ If template exists:                     │
│  ○ Skip (keep existing)                 │
│  ○ Overwrite existing                   │
│  ○ Create new with modified name        │
│ New name: [____________]                │
│ (Only for rename option)                │
│                                         │
│ [Cancel] [Import]                       │
└─────────────────────────────────────────┘
```

**Features:**
- File upload with `.md` file type restriction
- Radio button selection for conflict resolution
- Conditional text input for custom naming
- YAML frontmatter parsing
- Validation and error feedback
- Success/warning messages

**Styling:**
```css
.import-form label {
    font-weight: bold;
    margin-top: 1rem;
}

.import-form input[type="radio"] {
    margin-right: 0.5rem;
}

.import-form .help-text {
    display: block;
    margin-top: 0.25rem;
    color: #6c757d;
    font-size: 0.875rem;
}

.instruction-box {
    background-color: #e7f2fa;
    border-left: 4px solid #3498db;
    padding: 1rem;
    margin-bottom: 1.5rem;
}
```

#### GeneratedDocument Admin

**List View Customizations:**
- **Columns**: Title, Template, Status, Version, Created By, Created At, File Size
- **Filters**: Status, template, creation date, update date
- **Search**: By title, template name
- **Date Hierarchy**: By creation date
- **Custom Column**: File size in human-readable format (B, KB, MB, GB)

**Bulk Actions:**
1. **Approve Documents**: Batch approval for multiple documents
2. **Archive Documents**: Batch archiving for cleanup

**Fieldsets Organization:**
1. **Document Information**: Template, title, status, version, parent document
2. **Content**: Content, variables used (collapsed)
3. **File Information**: File name, path, size (collapsed)
4. **Metadata**: Timestamps, creator, reviewer (collapsed)

#### DocumentActivity Admin

**List View:**
- **Columns**: Document, Activity Type, User, Timestamp, Short Description
- **Filters**: Activity type, timestamp
- **Search**: By document title, username, description
- **Date Hierarchy**: By timestamp

**Restrictions:**
- **No Add Permission**: Activity logs created automatically
- **No Edit Permission**: Read-only records
- **No Delete Permission**: Permanent audit trail

---

## Feedback & Messaging

### Django Messages Framework

BMAD-FORGE uses Django's messages framework for user feedback:

```html
{% if messages %}
<div class="container mt-3">
    {% for message in messages %}
    <div class="alert alert-{{ message.tags }} alert-dismissible fade show" role="alert">
        {{ message }}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    {% endfor %}
</div>
{% endif %}
```

### Message Types

#### Success Messages
```python
messages.success(request, 'Document generated successfully!')
messages.success(request, 'Template imported successfully!')
```
- Green alert with checkmark icon
- Used for successful operations

#### Error Messages
```python
messages.error(request, 'Invalid JSON format in template variables.')
messages.error(request, 'Document not found.')
```
- Red alert with X icon
- Used for failures and validation errors

#### Warning Messages
```python
messages.warning(request, 'Template already exists. Import skipped.')
```
- Amber alert with warning icon
- Used for cautionary information

#### Info Messages
```python
messages.info(request, 'Document submitted for review.')
```
- Blue alert with info icon
- Used for informational updates

### Validation Error Display

**Form-Level Errors:**
```html
{% if form.non_field_errors %}
<div class="alert alert-danger">
    {{ form.non_field_errors }}
</div>
{% endif %}
```

**Field-Level Errors:**
```html
{% if field.errors %}
<div class="text-danger mt-1">{{ field.errors }}</div>
{% endif %}
```

### Loading States

**Current Implementation:**
- Browser default loading indicator during navigation
- Form submission disables button (browser default)

**Future Enhancement:**
- Loading spinners for async operations
- Progress indicators for long-running tasks
- Skeleton screens for content loading

---

## Export & Download Features

### Download Format Options

#### 1. HTML Download

**Button:**
```html
<a href="{% url 'forge:document_download' document.id 'html' %}" 
   class="btn btn-primary">
    Download HTML
</a>
```

**Implementation:**
- Returns complete HTML document with embedded styles
- Includes all CSS content from template
- Includes all JavaScript content from template
- Content-Disposition header for file download
- Filename: `{document_title}.html`

**Use Cases:**
- Standalone HTML documents
- Email distribution
- Direct browser viewing
- Archive storage

#### 2. Markdown Export

**Button:**
```html
<a href="{% url 'forge:document_download' document.id 'markdown' %}" 
   class="btn btn-outline-primary">
    Download Markdown
</a>
```

**Implementation:**
- Converts HTML to Markdown using `markdownify`
- Adds YAML frontmatter with metadata
- Preserves document structure
- Filename: `{document_title}.md`

**YAML Frontmatter:**
```yaml
---
title: Document Title
template: Template Name
status: approved
version: 1
created_at: 2026-01-15
created_by: username
---
```

**Use Cases:**
- Version control (Git-friendly)
- Documentation repositories
- Static site generators
- Plain text editing

#### 3. DOCX Export

**Button:**
```html
<a href="{% url 'forge:document_download' document.id 'docx' %}" 
   class="btn btn-outline-primary">
    Download DOCX
</a>
```

**Implementation:**
- Converts HTML to Word document using `htmldocx`
- Preserves basic formatting (headings, lists, tables)
- Filename: `{document_title}.docx`

**Use Cases:**
- Microsoft Word editing
- Corporate document workflows
- Print-ready documents
- Collaborative editing

#### 4. PDF Export (Coming Soon)

**Button:**
```html
<a href="#" class="btn btn-outline-secondary" disabled>
    Download PDF (Coming Soon)
</a>
```

**Planned Implementation:**
- PDF generation using WeasyPrint or similar library
- Print-optimized styling
- Page breaks and headers/footers
- High-quality rendering

**Use Cases:**
- Official documentation
- Archival copies
- Print distribution
- Digital signatures

### Download UX Flow

```
User clicks download button
    ↓
HTTP request to download endpoint
    ↓
Server retrieves document
    ↓
Content conversion (if needed)
    ↓
Response with Content-Disposition header
    ↓
Browser initiates file download
    ↓
Activity logged (download event)
    ↓
User receives file
```

---

## Responsive Design

### Breakpoints

BMAD-FORGE uses Bootstrap 5's standard breakpoints:

```
Extra Small: < 576px    (Mobile)
Small:       ≥ 576px    (Landscape phones)
Medium:      ≥ 768px    (Tablets)
Large:       ≥ 992px    (Desktops)
Extra Large: ≥ 1200px   (Large desktops)
XXL:         ≥ 1400px   (Extra large screens)
```

### Mobile Adaptation

#### Navigation

**Desktop:**
```
┌────────────────────────────────────────────────┐
│ 🔨 BMAD Forge    Home Templates Documents Admin│
└────────────────────────────────────────────────┘
```

**Mobile:**
```
┌────────────────────────────────────────────┐
│ 🔨 BMAD Forge                 [☰ Menu]    │
└────────────────────────────────────────────┘
    ↓ (Collapsed, expands on toggle)
┌────────────────────────────────────────────┐
│ • Home                                     │
│ • Templates                                │
│ • Documents                                │
│ • Admin                                    │
└────────────────────────────────────────────┘
```

**Implementation:**
```html
<button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarNav">
    <span class="navbar-toggler-icon"></span>
</button>
```

#### Grid Layouts

**Homepage Statistics:**
```
Desktop:  [Stat 1] [Stat 2] [Stat 3]  (3 columns)
Tablet:   [Stat 1] [Stat 2]           (2 columns)
          [Stat 3]
Mobile:   [Stat 1]                    (1 column)
          [Stat 2]
          [Stat 3]
```

**Template Cards:**
```
Desktop:  [Card] [Card] [Card]  (3 columns)
Tablet:   [Card] [Card]         (2 columns)
Mobile:   [Card]                (1 column)
```

**Document Detail:**
```
Desktop:  [Content (8)] [Sidebar (4)]
Tablet:   [Content (8)] [Sidebar (4)]
Mobile:   [Content (12)]
          [Sidebar (12)]
```

**CSS Classes:**
```html
<div class="col-12 col-md-6 col-lg-4">  <!-- Responsive card -->
<div class="col-md-8">                   <!-- Content area -->
<div class="col-md-4">                   <!-- Sidebar -->
```

### Tablet Layouts

**768px - 991px:**
- 2-column grid for template/document cards
- Maintained sidebar layout (8/4 split)
- Slightly reduced padding on containers
- Full-width search and filter bars

### Desktop Experience

**≥ 992px:**
- 3-column grid for optimal card display
- Full sidebar functionality
- Maximum readability line lengths
- Hover effects fully visible
- Expanded whitespace for visual comfort

### Touch Optimization

**Button Sizing:**
- Minimum touch target: 44px × 44px (Bootstrap default)
- Increased padding on mobile: `btn-lg` class
- Adequate spacing between interactive elements

**Form Inputs:**
- Native mobile keyboard for input types (email, number, date)
- Large tap areas for checkboxes and radio buttons
- Adequate spacing between form fields

**Gesture Support:**
- Swipe-friendly card interactions
- Tap targets sized for fingers, not cursors
- No hover-dependent functionality

---

## Accessibility

### Semantic HTML

BMAD-FORGE uses semantic HTML5 elements:

```html
<nav>         <!-- Navigation bars -->
<main>        <!-- Main content area -->
<article>     <!-- Document content -->
<aside>       <!-- Sidebar content -->
<header>      <!-- Page/section headers -->
<footer>      <!-- Page footer -->
<section>     <!-- Logical sections -->
```

### ARIA Labels

**Breadcrumb Navigation:**
```html
<nav aria-label="breadcrumb">
    <ol class="breadcrumb">...</ol>
</nav>
```

**Form Labels:**
```html
<label for="id_title">Document Title</label>
<input type="text" id="id_title" name="title">
```

**Alert Messages:**
```html
<div class="alert alert-success" role="alert">
    Document generated successfully!
</div>
```

### Keyboard Navigation

**Tab Order:**
- Logical tab order through interactive elements
- Skip links for keyboard users (future enhancement)
- Focus visible on all interactive elements

**Keyboard Shortcuts:**
- Form submission: Enter key
- Modal dismissal: Escape key (Bootstrap default)
- Navigation: Tab/Shift+Tab

### Color Contrast

**WCAG AA Compliance:**
- Primary text: Dark gray (#212529) on white (21:1 ratio)
- Navbar text: White on dark blue (#2c3e50) (9:1 ratio)
- Warning badges: Dark text on amber background (7:1 ratio)
- Success badges: White on green (4.5:1 ratio)

**Color-Blind Friendly:**
- Status differentiation not solely dependent on color
- Text labels accompany all color-coded elements
- Icons used in addition to colors (future enhancement)

### Screen Reader Support

**Form Fields:**
- All inputs have associated labels
- Help text linked with `aria-describedby`
- Error messages announced on form submission

**Status Changes:**
- Live regions for dynamic content updates (future enhancement)
- Clear announcement of success/error messages

**Navigation:**
- Landmark roles for major page sections
- Descriptive link text (avoiding "click here")
- Breadcrumbs provide context

### Future Accessibility Enhancements

1. **Skip Navigation Links**: Jump to main content
2. **Focus Management**: Automatic focus on error fields
3. **ARIA Live Regions**: Dynamic content announcements
4. **Keyboard Shortcuts**: Power user shortcuts
5. **High Contrast Mode**: Enhanced visibility option
6. **Font Size Control**: User-adjustable text size
7. **Icon Labels**: Visible labels for icon-only buttons

---

## Summary

BMAD-FORGE v3.0.0 delivers a **clean, professional, and intuitive user experience** for document generation and management. The design system leverages Bootstrap 5's robust component library while maintaining a consistent visual language across all pages.

**Key UX Strengths:**
- **Simplicity**: Minimal learning curve for new users
- **Consistency**: Predictable patterns throughout the application
- **Efficiency**: Streamlined workflows for common tasks
- **Flexibility**: Supports diverse document types and variables
- **Professionalism**: Corporate-appropriate styling and terminology

**Design Principles:**
- **Form Follows Function**: Every element serves a clear purpose
- **Progressive Disclosure**: Complexity revealed only when needed
- **Immediate Feedback**: Clear responses to all user actions
- **Forgiving Interfaces**: Easy error recovery and confirmation dialogs

The UX design supports the BMAD framework's goal of empowering teams to create, manage, and collaborate on documentation efficiently while maintaining quality and consistency.

---

**Document Version:** 1.0.0  
**Created:** January 2026  
**Author:** BMAD-FORGE Team  
**Status:** Living Document (subject to updates as features evolve)