"""
BMAD Forge Document Generator
Core document generation engine
"""
from jinja2 import Template, Environment, BaseLoader
from django.utils.html import escape
import re
import logging

try:
    import markdown as md_lib
except ImportError:
    md_lib = None

logger = logging.getLogger(__name__)


class DocumentGenerator:
    """
    Generate documents from templates with variable substitution
    """

    def __init__(self, template_obj):
        """
        Initialize generator with a DocumentTemplate object

        Args:
            template_obj: DocumentTemplate instance
        """
        self.template = template_obj
        self._is_markdown = bool(template_obj.source_file)
        self.env = Environment(loader=BaseLoader())
        self.env.filters['escape_html'] = escape
    
    def generate(self, variables):
        """
        Generate document content from template and variables

        Args:
            variables: dict of variable name -> value mappings

        Returns:
            str: Generated HTML content
        """
        try:
            # Validate required variables
            self._validate_variables(variables)

            if self._is_markdown:
                return self._process_markdown_template(
                    self.template.template_content, variables
                )

            # Jinja2/HTML path
            html_content = self._process_template(
                self.template.template_content,
                variables
            )

            # Wrap with CSS if provided
            if self.template.css_content:
                html_content = self._wrap_with_styling(html_content)

            # Add JavaScript if provided
            if self.template.js_content:
                html_content = self._add_javascript(html_content)

            return html_content

        except Exception as e:
            logger.error(f"Document generation failed: {str(e)}")
            raise
    
    def _validate_variables(self, variables):
        """
        Validate that all required variables are provided
        
        Args:
            variables: dict of variables
            
        Raises:
            ValueError: if required variables are missing
        """
        template_vars = self.template.get_variables()
        missing = []
        
        for var_name, var_config in template_vars.items():
            if var_config.get('required', False):
                if var_name not in variables or not variables[var_name]:
                    missing.append(var_name)
        
        if missing:
            raise ValueError(f"Missing required variables: {', '.join(missing)}")
    
    def _process_template(self, template_content, variables):
        """
        Process template content with Jinja2
        
        Args:
            template_content: str HTML template
            variables: dict of variables
            
        Returns:
            str: Processed HTML
        """
        try:
            # Create Jinja2 template
            jinja_template = self.env.from_string(template_content)
            
            # Render with variables
            rendered = jinja_template.render(**variables)
            
            return rendered
            
        except Exception as e:
            logger.error(f"Template processing failed: {str(e)}")
            raise ValueError(f"Template processing error: {str(e)}")
    
    def _process_markdown_template(self, content, variables):
        """
        Process a markdown template with variable substitution and render to HTML.

        Supports both [VAR_NAME] bracket syntax and {{VAR_NAME}} brace syntax.
        List values (from multiselect) are joined with commas.
        """
        result = content

        for var_name, value in variables.items():
            # Handle list values from multiselect fields
            if isinstance(value, list):
                value = ', '.join(str(v) for v in value)
            else:
                value = str(value)

            # Bracket substitution: [VAR_NAME]
            result = result.replace(f'[{var_name}]', value)

            # Brace substitution: {{VAR_NAME}} (simple regex, not Jinja2)
            result = re.sub(
                r'\{\{\s*' + re.escape(var_name) + r'\s*\}\}',
                value,
                result,
            )

        # Render markdown to HTML
        if md_lib is not None:
            result = md_lib.markdown(
                result,
                extensions=['tables', 'fenced_code', 'toc'],
            )
        else:
            # Fallback: wrap raw markdown in <pre> if library not installed
            result = f'<pre>{escape(result)}</pre>'

        return result

    def _wrap_with_styling(self, html_content):
        """
        Wrap HTML content with CSS styling
        
        Args:
            html_content: str HTML content
            
        Returns:
            str: HTML with embedded CSS
        """
        css = self.template.css_content
        
        wrapped = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{escape(self.template.name)}</title>
    <style>
{css}
    </style>
</head>
<body>
{html_content}
</body>
</html>"""
        
        return wrapped
    
    def _add_javascript(self, html_content):
        """
        Add JavaScript to HTML content
        
        Args:
            html_content: str HTML content
            
        Returns:
            str: HTML with embedded JavaScript
        """
        js = self.template.js_content
        
        # Find closing </body> tag and insert JS before it
        if '</body>' in html_content:
            js_block = f"""
    <script>
{js}
    </script>
</body>"""
            html_content = html_content.replace('</body>', js_block)
        else:
            # If no body tag, append at end
            html_content += f"""
<script>
{js}
</script>"""
        
        return html_content
    
    def preview(self, variables, max_length=500):
        """
        Generate a preview of the document
        
        Args:
            variables: dict of variables
            max_length: max characters for preview
            
        Returns:
            str: Preview text
        """
        try:
            content = self.generate(variables)
            
            # Strip HTML tags for preview
            text = re.sub(r'<[^>]+>', '', content)
            
            # Clean up whitespace
            text = ' '.join(text.split())
            
            # Truncate
            if len(text) > max_length:
                text = text[:max_length] + '...'
            
            return text
            
        except Exception as e:
            logger.error(f"Preview generation failed: {str(e)}")
            return f"Preview unavailable: {str(e)}"


class TemplateValidator:
    """
    Validate template content and structure
    """
    
    @staticmethod
    def validate_template_syntax(template_content):
        """
        Validate Jinja2 template syntax
        
        Args:
            template_content: str template content
            
        Returns:
            tuple: (is_valid, error_message)
        """
        try:
            env = Environment(loader=BaseLoader())
            env.from_string(template_content)
            return (True, None)
        except Exception as e:
            return (False, str(e))
    
    @staticmethod
    def validate_css(css_content):
        """
        Basic CSS validation
        
        Args:
            css_content: str CSS content
            
        Returns:
            tuple: (is_valid, error_message)
        """
        # Basic check for balanced braces
        if css_content.count('{') != css_content.count('}'):
            return (False, "Unbalanced CSS braces")
        
        return (True, None)
    
    @staticmethod
    def validate_variables(variables_json):
        """
        Validate template variables JSON structure
        
        Args:
            variables_json: dict of variables configuration
            
        Returns:
            tuple: (is_valid, error_message)
        """
        if not isinstance(variables_json, dict):
            return (False, "Variables must be a dictionary")
        
        valid_types = ['text', 'textarea', 'email', 'number', 'date', 'select', 'checkbox', 'multiselect']
        
        for var_name, var_config in variables_json.items():
            if not isinstance(var_config, dict):
                return (False, f"Variable '{var_name}' configuration must be a dictionary")
            
            var_type = var_config.get('type', 'text')
            if var_type not in valid_types:
                return (False, f"Invalid type '{var_type}' for variable '{var_name}'")
            
            if var_type in ('select', 'multiselect') and 'choices' not in var_config:
                return (False, f"Variable '{var_name}' with type '{var_type}' must have 'choices'")
        
        return (True, None)
    
    @staticmethod
    def extract_variables_from_template(template_content):
        """
        Extract variable names used in template
        
        Args:
            template_content: str Jinja2 template
            
        Returns:
            set: Variable names found in template
        """
        # Match Jinja2 variable syntax: {{ variable_name }}
        brace_pattern = r'\{\{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\}\}'
        # Match bracket variable syntax: [VARIABLE_NAME]
        bracket_pattern = r'\[([A-Z][A-Z0-9_]*)\]'
        matches = set(re.findall(brace_pattern, template_content))
        matches.update(re.findall(bracket_pattern, template_content))
        return matches
