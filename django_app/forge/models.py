"""
BMAD Forge Models
Database models for document generation and management
"""
from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
import json


class DocumentTemplate(models.Model):
    """
    Document templates for generation
    """
    DOCUMENT_TYPES = [
        ('memorandum', 'Memorandum'),
        ('letter', 'Letter'),
        ('report', 'Report'),
        ('form', 'Form'),
        ('other', 'Other'),
    ]

    AGENT_ROLES = [
        ('orchestrator', 'Orchestrator'),
        ('analyst', 'Analyst'),
        ('pm', 'Project Manager'),
        ('architect', 'Architect'),
        ('scrum_master', 'Scrum Master'),
        ('developer', 'Developer'),
        ('qa', 'QA Engineer'),
    ]

    WORKFLOW_PHASES = [
        ('planning', 'Planning'),
        ('development', 'Development'),
    ]

    TEMPLATE_TYPES = [
        ('template', 'Document Template'),
        ('agent', 'Agent Prompt'),
    ]

    name = models.CharField(max_length=200, unique=True)
    document_type = models.CharField(max_length=50, choices=DOCUMENT_TYPES, default='other')
    description = models.TextField(blank=True)
    template_content = models.TextField(help_text="HTML template content")
    css_content = models.TextField(blank=True, help_text="CSS styling")
    js_content = models.TextField(blank=True, help_text="JavaScript for interactivity")

    # BMAD fields
    agent_role = models.CharField(max_length=50, choices=AGENT_ROLES, blank=True)
    agent_roles = models.JSONField(default=list, blank=True)
    workflow_phase = models.CharField(max_length=50, choices=WORKFLOW_PHASES, blank=True)
    category = models.CharField(max_length=100, blank=True)
    template_type = models.CharField(max_length=20, choices=TEMPLATE_TYPES, default='template')
    source_file = models.CharField(max_length=255, blank=True, unique=True, null=True)

    # Metadata
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='templates_created')
    is_active = models.BooleanField(default=True)

    # Template variables (JSON format)
    template_variables = models.TextField(
        blank=True,
        help_text="JSON object defining required variables"
    )

    class Meta:
        ordering = ['name']
        verbose_name = 'Document Template'
        verbose_name_plural = 'Document Templates'
        indexes = [
            models.Index(fields=['agent_role', 'workflow_phase']),
        ]
    
    def __str__(self):
        return f"{self.name} ({self.get_document_type_display()})"

    def has_role(self, role):
        """Check if template is associated with a given agent role"""
        return role == self.agent_role or role in (self.agent_roles or [])

    def get_roles_display(self):
        """Return comma-separated display names for all roles"""
        role_map = dict(self.AGENT_ROLES)
        return ', '.join(role_map.get(r, r) for r in self.get_roles_list())

    def get_roles_list(self):
        """Return deduplicated list of all associated roles"""
        roles = list(self.agent_roles or [])
        if self.agent_role and self.agent_role not in roles:
            roles.insert(0, self.agent_role)
        return roles

    def get_variables(self):
        """Parse and return template variables as dict"""
        if self.template_variables:
            try:
                return json.loads(self.template_variables)
            except json.JSONDecodeError:
                return {}
        return {}
    
    def set_variables(self, variables_dict):
        """Set template variables from dict"""
        self.template_variables = json.dumps(variables_dict, indent=2)


class GeneratedDocument(models.Model):
    """
    Documents generated from templates
    """
    STATUS_CHOICES = [
        ('draft', 'Draft'),
        ('review', 'Under Review'),
        ('approved', 'Approved'),
        ('published', 'Published'),
        ('archived', 'Archived'),
    ]
    
    template = models.ForeignKey(
        DocumentTemplate,
        on_delete=models.PROTECT,
        related_name='generated_documents'
    )
    title = models.CharField(max_length=300)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='draft')
    
    # Content
    content = models.TextField(help_text="Generated HTML content")
    variables_used = models.TextField(
        blank=True,
        help_text="JSON object with variables used in generation"
    )
    
    # File management
    file_name = models.CharField(max_length=255, blank=True)
    file_path = models.CharField(max_length=500, blank=True)
    file_size = models.IntegerField(null=True, blank=True, help_text="Size in bytes")
    
    # Metadata
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='documents_created'
    )
    reviewed_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='documents_reviewed'
    )
    review_date = models.DateTimeField(null=True, blank=True)
    
    # Versioning
    version = models.IntegerField(default=1)
    parent_document = models.ForeignKey(
        'self',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='versions'
    )
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = 'Generated Document'
        verbose_name_plural = 'Generated Documents'
        indexes = [
            models.Index(fields=['status', 'created_at']),
            models.Index(fields=['template', 'status']),
        ]
    
    def __str__(self):
        return f"{self.title} (v{self.version})"
    
    def get_variables(self):
        """Parse and return variables used as dict"""
        if self.variables_used:
            try:
                return json.loads(self.variables_used)
            except json.JSONDecodeError:
                return {}
        return {}
    
    def set_variables(self, variables_dict):
        """Set variables from dict"""
        self.variables_used = json.dumps(variables_dict, indent=2)
    
    def approve(self, user):
        """Approve document"""
        self.status = 'approved'
        self.reviewed_by = user
        self.review_date = timezone.now()
        self.save()
    
    def create_new_version(self):
        """Create a new version of this document"""
        new_version = GeneratedDocument.objects.create(
            template=self.template,
            title=self.title,
            content=self.content,
            variables_used=self.variables_used,
            created_by=self.created_by,
            version=self.version + 1,
            parent_document=self.parent_document or self
        )
        return new_version


class DocumentActivity(models.Model):
    """
    Audit log for document activities
    """
    ACTIVITY_TYPES = [
        ('created', 'Created'),
        ('updated', 'Updated'),
        ('reviewed', 'Reviewed'),
        ('approved', 'Approved'),
        ('published', 'Published'),
        ('archived', 'Archived'),
        ('downloaded', 'Downloaded'),
        ('deleted', 'Deleted'),
    ]
    
    document = models.ForeignKey(
        GeneratedDocument,
        on_delete=models.CASCADE,
        related_name='activities'
    )
    activity_type = models.CharField(max_length=20, choices=ACTIVITY_TYPES)
    description = models.TextField(blank=True)
    
    # User tracking
    user = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='document_activities'
    )
    timestamp = models.DateTimeField(auto_now_add=True)
    
    # Additional context
    metadata = models.TextField(
        blank=True,
        help_text="JSON object with additional activity context"
    )
    
    class Meta:
        ordering = ['-timestamp']
        verbose_name = 'Document Activity'
        verbose_name_plural = 'Document Activities'
        indexes = [
            models.Index(fields=['document', 'timestamp']),
            models.Index(fields=['user', 'timestamp']),
        ]
    
    def __str__(self):
        return f"{self.get_activity_type_display()} - {self.document.title} by {self.user}"
    
    def get_metadata(self):
        """Parse and return metadata as dict"""
        if self.metadata:
            try:
                return json.loads(self.metadata)
            except json.JSONDecodeError:
                return {}
        return {}
    
    def set_metadata(self, metadata_dict):
        """Set metadata from dict"""
        self.metadata = json.dumps(metadata_dict, indent=2)
