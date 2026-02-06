"""
BMAD Forge Admin Configuration
"""
from django.contrib import admin
from django.utils.html import format_html
from django.shortcuts import render, redirect
from django.urls import path
from django.contrib import messages
from django import forms
from .models import DocumentTemplate, GeneratedDocument, DocumentActivity
import yaml
import os


class TemplateImportForm(forms.Form):
    """Form for importing templates"""
    template_file = forms.FileField(
        label='Template File (.md)',
        help_text='Select a Markdown template file to import',
        widget=forms.FileInput(attrs={'accept': '.md'})
    )
    overwrite = forms.ChoiceField(
        label='If template exists',
        choices=[
            ('skip', 'Skip (keep existing)'),
            ('overwrite', 'Overwrite existing'),
            ('rename', 'Create new with modified name'),
        ],
        initial='skip',
        widget=forms.RadioSelect
    )
    new_name = forms.CharField(
        label='New name (for rename option)',
        required=False,
        help_text='Only used if "Create new with modified name" is selected',
        widget=forms.TextInput(attrs={'placeholder': 'Leave empty for auto-generated name'})
    )


@admin.register(DocumentTemplate)
class DocumentTemplateAdmin(admin.ModelAdmin):
    """
    Admin interface for DocumentTemplate
    """
    list_display = ['name', 'document_type', 'template_type', 'agent_role', 'workflow_phase', 'is_active', 'created_at', 'updated_at', 'documents_count']
    list_filter = ['document_type', 'template_type', 'agent_role', 'workflow_phase', 'category', 'is_active', 'created_at']
    search_fields = ['name', 'description', 'source_file']
    readonly_fields = ['created_at', 'updated_at', 'created_by', 'source_file']

    fieldsets = (
        ('Basic Information', {
            'fields': ('name', 'document_type', 'description', 'is_active')
        }),
        ('BMAD Configuration', {
            'fields': ('template_type', 'agent_role', 'agent_roles', 'workflow_phase', 'category', 'source_file'),
        }),
        ('Template Content', {
            'fields': ('template_content', 'css_content', 'js_content', 'template_variables'),
            'classes': ('wide',)
        }),
        ('Metadata', {
            'fields': ('created_at', 'updated_at', 'created_by'),
            'classes': ('collapse',)
        }),
    )
    
    def documents_count(self, obj):
        """Display count of documents generated from this template"""
        count = obj.generated_documents.count()
        return format_html('<strong>{}</strong>', count)
    documents_count.short_description = 'Documents'
    
    def save_model(self, request, obj, form, change):
        """Set created_by on creation"""
        if not change:
            obj.created_by = request.user
        super().save_model(request, obj, form, change)
    
    def get_urls(self):
        """Add custom URL for template import"""
        urls = super().get_urls()
        custom_urls = [
            path('import-template/', self.admin_site.admin_view(self.import_template_view), name='forge_documenttemplate_import'),
        ]
        return custom_urls + urls
    
    def changelist_view(self, request, extra_context=None):
        """Add import button to changelist"""
        extra_context = extra_context or {}
        extra_context['show_import_button'] = True
        return super().changelist_view(request, extra_context)
    
    def import_template_view(self, request):
        """View for importing templates"""
        if request.method == 'POST':
            form = TemplateImportForm(request.POST, request.FILES)
            if form.is_valid():
                template_file = request.FILES['template_file']
                overwrite_option = form.cleaned_data['overwrite']
                new_name = form.cleaned_data.get('new_name', '').strip()
                
                try:
                    # Read and parse the file
                    content = template_file.read().decode('utf-8')
                    
                    # Parse YAML frontmatter
                    if content.startswith('---'):
                        parts = content.split('---', 2)
                        if len(parts) >= 3:
                            frontmatter_text = parts[1]
                            template_body = parts[2].strip()
                            frontmatter = yaml.safe_load(frontmatter_text)
                        else:
                            raise ValueError("Invalid YAML frontmatter format")
                    else:
                        raise ValueError("File must contain YAML frontmatter")
                    
                    # Extract template data
                    template_name = frontmatter.get('name', template_file.name.replace('.md', ''))
                    template_type = frontmatter.get('type', 'template')
                    
                    # Check if template exists
                    existing_template = DocumentTemplate.objects.filter(
                        name=template_name,
                        template_type=template_type
                    ).first()
                    
                    if existing_template and overwrite_option == 'skip':
                        messages.warning(
                            request,
                            f'Template "{template_name}" already exists. Import skipped. '
                            f'Choose "Overwrite" or "Rename" option to import anyway.'
                        )
                        return redirect('admin:forge_documenttemplate_changelist')
                    
                    # Handle rename option
                    if existing_template and overwrite_option == 'rename':
                        if new_name:
                            template_name = new_name
                        else:
                            # Auto-generate new name
                            base_name = template_name
                            counter = 1
                            while DocumentTemplate.objects.filter(name=template_name, template_type=template_type).exists():
                                template_name = f"{base_name} ({counter})"
                                counter += 1
                    
                    # Prepare template data
                    template_data = {
                        'name': template_name,
                        'template_type': template_type,
                        'document_type': frontmatter.get('document_type', 'technical'),
                        'description': frontmatter.get('description', ''),
                        'agent_role': frontmatter.get('agent_role', frontmatter.get('role')),
                        'agent_roles': frontmatter.get('agent_roles', frontmatter.get('roles', [])),
                        'workflow_phase': frontmatter.get('workflow_phase', frontmatter.get('phase')),
                        'category': frontmatter.get('category', 'general'),
                        'template_content': template_body,
                        'template_variables': frontmatter.get('variables', {}),
                        'source_file': template_file.name,
                        'is_active': True,
                    }
                    
                    # Create or update template
                    if existing_template and overwrite_option == 'overwrite':
                        for key, value in template_data.items():
                            if key != 'created_by':  # Don't change creator
                                setattr(existing_template, key, value)
                        existing_template.save()
                        messages.success(
                            request,
                            f'Template "{template_name}" updated successfully!'
                        )
                    else:
                        template_data['created_by'] = request.user
                        DocumentTemplate.objects.create(**template_data)
                        messages.success(
                            request,
                            f'Template "{template_name}" imported successfully!'
                        )
                    
                    return redirect('admin:forge_documenttemplate_changelist')
                    
                except yaml.YAMLError as e:
                    messages.error(request, f'YAML parsing error: {str(e)}')
                except ValueError as e:
                    messages.error(request, f'Import error: {str(e)}')
                except Exception as e:
                    messages.error(request, f'Unexpected error during import: {str(e)}')
        else:
            form = TemplateImportForm()
        
        context = {
            'form': form,
            'title': 'Import Template',
            'site_title': 'BMAD Forge Admin',
            'has_permission': True,
            'opts': self.model._meta,
        }
        
        return render(request, 'admin/forge/import_template.html', context)


@admin.register(GeneratedDocument)
class GeneratedDocumentAdmin(admin.ModelAdmin):
    """
    Admin interface for GeneratedDocument
    """
    list_display = ['title', 'template', 'status', 'version', 'created_by', 'created_at', 'file_size_display']
    list_filter = ['status', 'template', 'created_at', 'updated_at']
    search_fields = ['title', 'template__name']
    readonly_fields = ['created_at', 'updated_at', 'created_by', 'reviewed_by', 'review_date', 'version']
    date_hierarchy = 'created_at'
    
    fieldsets = (
        ('Document Information', {
            'fields': ('template', 'title', 'status', 'version', 'parent_document')
        }),
        ('Content', {
            'fields': ('content', 'variables_used'),
            'classes': ('collapse',)
        }),
        ('File Information', {
            'fields': ('file_name', 'file_path', 'file_size'),
            'classes': ('collapse',)
        }),
        ('Metadata', {
            'fields': ('created_at', 'created_by', 'updated_at', 'reviewed_by', 'review_date'),
            'classes': ('collapse',)
        }),
    )
    
    actions = ['approve_documents', 'archive_documents']
    
    def file_size_display(self, obj):
        """Display file size in human-readable format"""
        if obj.file_size:
            size = obj.file_size
            for unit in ['B', 'KB', 'MB', 'GB']:
                if size < 1024.0:
                    return f"{size:.1f} {unit}"
                size /= 1024.0
        return '-'
    file_size_display.short_description = 'File Size'
    
    def approve_documents(self, request, queryset):
        """Bulk approve documents"""
        count = 0
        for doc in queryset:
            doc.approve(request.user)
            count += 1
        self.message_user(request, f'{count} document(s) approved successfully.')
    approve_documents.short_description = 'Approve selected documents'
    
    def archive_documents(self, request, queryset):
        """Bulk archive documents"""
        count = queryset.update(status='archived')
        self.message_user(request, f'{count} document(s) archived successfully.')
    archive_documents.short_description = 'Archive selected documents'


@admin.register(DocumentActivity)
class DocumentActivityAdmin(admin.ModelAdmin):
    """
    Admin interface for DocumentActivity
    """
    list_display = ['document', 'activity_type', 'user', 'timestamp', 'description_short']
    list_filter = ['activity_type', 'timestamp']
    search_fields = ['document__title', 'user__username', 'description']
    readonly_fields = ['document', 'activity_type', 'user', 'timestamp', 'description', 'metadata']
    date_hierarchy = 'timestamp'
    
    def description_short(self, obj):
        """Display truncated description"""
        if len(obj.description) > 50:
            return obj.description[:50] + '...'
        return obj.description
    description_short.short_description = 'Description'
    
    def has_add_permission(self, request):
        """Disable manual creation of activity logs"""
        return False
    
    def has_change_permission(self, request, obj=None):
        """Make activity logs read-only"""
        return False
    
    def has_delete_permission(self, request, obj=None):
        """Prevent deletion of activity logs"""
        return False
