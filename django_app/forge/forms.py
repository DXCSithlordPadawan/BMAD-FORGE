"""
BMAD Forge Forms
Forms for template and document management
"""
from django import forms
from .models import DocumentTemplate, GeneratedDocument
import json


class DocumentTemplateForm(forms.ModelForm):
    """
    Form for creating/editing document templates
    """
    class Meta:
        model = DocumentTemplate
        fields = [
            'name',
            'document_type',
            'template_type',
            'description',
            'template_content',
            'css_content',
            'js_content',
            'template_variables',
            'agent_role',
            'workflow_phase',
            'category',
            'is_active'
        ]
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'document_type': forms.Select(attrs={'class': 'form-control'}),
            'template_type': forms.Select(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 3}),
            'template_content': forms.Textarea(attrs={'class': 'form-control', 'rows': 15}),
            'css_content': forms.Textarea(attrs={'class': 'form-control', 'rows': 10}),
            'js_content': forms.Textarea(attrs={'class': 'form-control', 'rows': 10}),
            'template_variables': forms.Textarea(attrs={'class': 'form-control', 'rows': 10}),
            'agent_role': forms.Select(attrs={'class': 'form-control'}),
            'workflow_phase': forms.Select(attrs={'class': 'form-control'}),
            'category': forms.TextInput(attrs={'class': 'form-control'}),
            'is_active': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
        }
    
    def clean_template_variables(self):
        """Validate JSON format for template variables"""
        variables = self.cleaned_data.get('template_variables')
        if variables:
            try:
                json.loads(variables)
            except json.JSONDecodeError as e:
                raise forms.ValidationError(f"Invalid JSON format: {str(e)}")
        return variables


class GenerateDocumentForm(forms.Form):
    """
    Dynamic form for document generation based on template variables
    """
    title = forms.CharField(
        max_length=300,
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Enter document title'
        })
    )
    
    def __init__(self, *args, template=None, **kwargs):
        super().__init__(*args, **kwargs)
        
        if template:
            self.template = template
            variables = template.get_variables()
            
            # Dynamically add fields based on template variables
            for var_name, var_config in variables.items():
                field_type = var_config.get('type', 'text')
                required = var_config.get('required', False)
                label = var_config.get('label', var_name)
                help_text = var_config.get('help_text', '')
                default = var_config.get('default', '')
                
                field_kwargs = {
                    'required': required,
                    'label': label,
                    'help_text': help_text,
                    'initial': default,
                }
                
                # Create appropriate field based on type
                if field_type == 'text':
                    self.fields[var_name] = forms.CharField(
                        widget=forms.TextInput(attrs={'class': 'form-control'}),
                        **field_kwargs
                    )
                
                elif field_type == 'textarea':
                    self.fields[var_name] = forms.CharField(
                        widget=forms.Textarea(attrs={'class': 'form-control', 'rows': 4}),
                        **field_kwargs
                    )
                
                elif field_type == 'email':
                    self.fields[var_name] = forms.EmailField(
                        widget=forms.EmailInput(attrs={'class': 'form-control'}),
                        **field_kwargs
                    )
                
                elif field_type == 'number':
                    self.fields[var_name] = forms.IntegerField(
                        widget=forms.NumberInput(attrs={'class': 'form-control'}),
                        **field_kwargs
                    )
                
                elif field_type == 'date':
                    self.fields[var_name] = forms.DateField(
                        widget=forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
                        **field_kwargs
                    )
                
                elif field_type == 'select':
                    choices = var_config.get('choices', [])
                    choice_tuples = [(c, c) for c in choices]
                    self.fields[var_name] = forms.ChoiceField(
                        choices=choice_tuples,
                        widget=forms.Select(attrs={'class': 'form-control'}),
                        **field_kwargs
                    )

                elif field_type == 'multiselect':
                    choices = var_config.get('choices', [])
                    choice_tuples = [(c, c) for c in choices]
                    self.fields[var_name] = forms.MultipleChoiceField(
                        choices=choice_tuples,
                        widget=forms.SelectMultiple(attrs={'class': 'form-control'}),
                        **field_kwargs
                    )

                elif field_type == 'checkbox':
                    field_kwargs.pop('initial', None)  # Remove initial for boolean
                    self.fields[var_name] = forms.BooleanField(
                        widget=forms.CheckboxInput(attrs={'class': 'form-check-input'}),
                        initial=default == 'true' or default is True,
                        **field_kwargs
                    )
                
                else:
                    # Default to text field
                    self.fields[var_name] = forms.CharField(
                        widget=forms.TextInput(attrs={'class': 'form-control'}),
                        **field_kwargs
                    )
    
    def get_variables(self):
        """
        Extract variable values from cleaned data
        """
        if not hasattr(self, 'template'):
            return {}
        
        variables = {}
        template_vars = self.template.get_variables()
        
        for var_name in template_vars.keys():
            if var_name in self.cleaned_data:
                variables[var_name] = self.cleaned_data[var_name]
        
        return variables


class DocumentStatusForm(forms.ModelForm):
    """
    Form for updating document status
    """
    class Meta:
        model = GeneratedDocument
        fields = ['status']
        widgets = {
            'status': forms.Select(attrs={'class': 'form-control'}),
        }


class DocumentSearchForm(forms.Form):
    """
    Form for searching documents
    """
    search = forms.CharField(
        required=False,
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Search documents...'
        })
    )
    
    status = forms.ChoiceField(
        required=False,
        choices=[('', 'All Statuses')] + GeneratedDocument.STATUS_CHOICES,
        widget=forms.Select(attrs={'class': 'form-control'})
    )
    
    template = forms.ModelChoiceField(
        required=False,
        queryset=DocumentTemplate.objects.filter(is_active=True),
        empty_label='All Templates',
        widget=forms.Select(attrs={'class': 'form-control'})
    )
    
    date_from = forms.DateField(
        required=False,
        widget=forms.DateInput(attrs={
            'class': 'form-control',
            'type': 'date'
        })
    )
    
    date_to = forms.DateField(
        required=False,
        widget=forms.DateInput(attrs={
            'class': 'form-control',
            'type': 'date'
        })
    )
