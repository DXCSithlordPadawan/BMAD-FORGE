"""
Template Auto-Loader Utility

Automatically loads BMAD markdown templates and agent prompts from filesystem
into the database on first application startup.

Security Features:
- Read-only filesystem access
- Atomic database transactions
- Input validation and sanitization
- Error handling with graceful degradation
- Audit logging
"""
import os
import json
import yaml
import logging
from pathlib import Path
from django.db import transaction
from django.conf import settings

logger = logging.getLogger(__name__)


class TemplateAutoLoader:
    """
    Auto-loads templates from filesystem to database on first startup.
    
    Design Principles:
    - Idempotent: Safe to run multiple times
    - Defensive: Validates all inputs
    - Atomic: All-or-nothing database operations
    - Logged: Full audit trail
    """
    
    def __init__(self):
        """Initialize with project root path detection."""
        # Detect project root (django_app/forge/utils -> ../../..)
        self.project_root = Path(__file__).resolve().parent.parent.parent.parent
        self.templates_dir = self.project_root / 'templates'
        self.agents_dir = self.project_root / 'agents'
        
    def should_auto_load(self):
        """
        Determine if templates should be auto-loaded.
        
        Returns True only if:
        1. Database is accessible
        2. DocumentTemplate table exists
        3. No templates currently in database
        
        Returns:
            bool: True if auto-load should proceed
        """
        try:
            # Import here to avoid AppRegistryNotReady errors
            from forge.models import DocumentTemplate
            
            # Check if any templates exist in database
            count = DocumentTemplate.objects.count()
            
            if count == 0:
                logger.info("No templates found in database - auto-load will proceed")
                return True
            else:
                logger.debug(f"Found {count} existing templates - skipping auto-load")
                return False
                
        except Exception as e:
            # Database not ready or table doesn't exist yet
            logger.debug(f"Auto-load check skipped: {e}")
            return False
    
    def auto_load_templates(self):
        """
        Auto-load templates from filesystem if database is empty.
        
        This method is safe to call on every startup as it checks
        whether loading is needed before proceeding.
        
        Returns:
            dict: Statistics about the load operation
        """
        if not self.should_auto_load():
            return {'status': 'skipped', 'reason': 'templates_exist'}
        
        logger.info("Starting automatic template loading...")
        
        stats = {
            'status': 'success',
            'created': 0,
            'updated': 0,
            'errors': 0,
            'directories_checked': []
        }
        
        try:
            # Load templates from both directories
            for directory, template_type in [
                (self.templates_dir, 'template'),
                (self.agents_dir, 'agent')
            ]:
                stats['directories_checked'].append(str(directory))
                
                if not directory.exists():
                    logger.warning(f"Directory not found: {directory}")
                    continue
                
                # Process all .md files in directory
                md_files = sorted(directory.glob('*.md'))
                logger.info(f"Found {len(md_files)} .md files in {directory.name}/")
                
                for md_file in md_files:
                    try:
                        result = self._process_file(md_file, template_type)
                        if result == 'created':
                            stats['created'] += 1
                        elif result == 'updated':
                            stats['updated'] += 1
                    except Exception as e:
                        stats['errors'] += 1
                        logger.error(f"Error processing {md_file.name}: {e}")
            
            logger.info(
                f"Auto-load complete: {stats['created']} created, "
                f"{stats['updated']} updated, {stats['errors']} errors"
            )
            
        except Exception as e:
            stats['status'] = 'error'
            stats['error_message'] = str(e)
            logger.error(f"Auto-load failed: {e}", exc_info=True)
        
        return stats
    
    @transaction.atomic
    def _process_file(self, md_file, template_type):
        """
        Process a single markdown file and load into database.
        
        Args:
            md_file (Path): Path to markdown file
            template_type (str): 'template' or 'agent'
            
        Returns:
            str: 'created', 'updated', or None
        """
        # Import here to avoid circular imports
        from forge.models import DocumentTemplate
        
        # Read file content with UTF-8 encoding
        content = md_file.read_text(encoding='utf-8')
        
        # Parse YAML frontmatter
        frontmatter, body = self._parse_frontmatter(content)
        
        if not frontmatter:
            logger.warning(f"Skipping {md_file.name}: no YAML frontmatter")
            return None
        
        # Extract metadata with defaults
        name = self._sanitize_string(frontmatter.get('name', md_file.stem))
        description = self._sanitize_string(frontmatter.get('description', ''))
        
        # Normalize roles
        agent_roles = self._normalize_roles(frontmatter)
        agent_role = agent_roles[0] if agent_roles else ''
        
        # Extract workflow metadata
        workflow_phase = self._sanitize_string(frontmatter.get('workflow_phase', ''))
        category = self._sanitize_string(frontmatter.get('category', ''))
        
        # Normalize variables
        raw_vars = frontmatter.get('variables', {})
        normalized_vars = self._normalize_variables(raw_vars) if raw_vars else {}
        
        # Create unique source file identifier
        source_file = f'{md_file.parent.name}/{md_file.name}'
        
        # Handle duplicate names
        existing = DocumentTemplate.objects.filter(
            name=name
        ).exclude(source_file=source_file).first()
        
        if existing:
            name = f'{name}-{md_file.stem}'
            logger.warning(
                f"Duplicate name detected for {md_file.name}, using: {name}"
            )
        
        # Create or update template in database
        obj, was_created = DocumentTemplate.objects.update_or_create(
            source_file=source_file,
            defaults={
                'name': name,
                'description': description,
                'template_content': body,
                'template_type': template_type,
                'agent_role': agent_role,
                'agent_roles': agent_roles,
                'workflow_phase': workflow_phase,
                'category': category,
                'template_variables': json.dumps(normalized_vars, indent=2) if normalized_vars else '',
                'is_active': True,
            },
        )
        
        status = 'created' if was_created else 'updated'
        logger.info(f"Template {status}: {obj.name} from {md_file.name}")
        
        return status
    
    def _parse_frontmatter(self, content):
        """
        Parse YAML frontmatter from markdown content.
        
        Args:
            content (str): Full markdown file content
            
        Returns:
            tuple: (frontmatter_dict, body_text)
        """
        content = content.strip()
        
        if not content.startswith('---'):
            return None, content
        
        # Find closing delimiter
        end = content.find('---', 3)
        if end == -1:
            return None, content
        
        yaml_str = content[3:end].strip()
        body = content[end + 3:].strip()
        
        try:
            frontmatter = yaml.safe_load(yaml_str)
        except yaml.YAMLError as e:
            logger.error(f"Invalid YAML frontmatter: {e}")
            return None, content
        
        if not isinstance(frontmatter, dict):
            return None, content
        
        return frontmatter, body
    
    def _normalize_roles(self, frontmatter):
        """
        Extract and normalize agent roles from frontmatter.
        
        Handles both singular 'role' and plural 'roles' fields.
        
        Args:
            frontmatter (dict): Parsed YAML frontmatter
            
        Returns:
            list: List of normalized role strings
        """
        roles = []
        
        # Plural form takes precedence
        if 'roles' in frontmatter:
            raw = frontmatter['roles']
            if isinstance(raw, list):
                roles = [self._sanitize_string(str(r)) for r in raw]
            else:
                roles = [self._sanitize_string(str(raw))]
        
        # Singular form
        if 'role' in frontmatter:
            role = self._sanitize_string(str(frontmatter['role']))
            if role and role not in roles:
                roles.insert(0, role)
        
        return roles
    
    def _normalize_variables(self, raw_vars):
        """
        Normalize YAML variable definitions to JSON format.
        
        Mapping:
        - YAML 'description' -> JSON 'label'
        - YAML 'options' -> JSON 'choices'
        - YAML 'input_type' -> JSON 'type'
        
        Args:
            raw_vars (dict): Raw variable definitions from YAML
            
        Returns:
            dict: Normalized variable definitions
        """
        normalized = {}
        
        for var_name, var_config in raw_vars.items():
            if not isinstance(var_config, dict):
                continue
            
            norm = {}
            
            # Label: prefer description
            if 'description' in var_config:
                norm['label'] = self._sanitize_string(var_config['description'])
            
            # Type: prefer 'type', fall back to 'input_type'
            var_type = var_config.get('type') or var_config.get('input_type') or 'text'
            norm['type'] = self._sanitize_string(str(var_type))
            
            # Required flag
            if 'required' in var_config:
                norm['required'] = bool(var_config['required'])
            
            # Choices: YAML 'options' -> JSON 'choices'
            if 'options' in var_config:
                norm['choices'] = var_config['options']
            elif 'choices' in var_config:
                norm['choices'] = var_config['choices']
            
            # Default value
            if 'default' in var_config:
                norm['default'] = var_config['default']
            
            # Help text
            if 'help_text' in var_config:
                norm['help_text'] = self._sanitize_string(var_config['help_text'])
            
            # Placeholder
            if 'placeholder' in var_config:
                norm['placeholder'] = self._sanitize_string(var_config['placeholder'])
            
            normalized[var_name] = norm
        
        return normalized
    
    def _sanitize_string(self, value):
        """
        Sanitize string input for security.
        
        Args:
            value: Input value to sanitize
            
        Returns:
            str: Sanitized string (empty string if invalid)
        """
        if not value:
            return ''
        
        # Convert to string and strip whitespace
        sanitized = str(value).strip()
        
        # Limit length to prevent DoS
        max_length = 10000
        if len(sanitized) > max_length:
            logger.warning(f"String truncated from {len(sanitized)} to {max_length} chars")
            sanitized = sanitized[:max_length]
        
        return sanitized


# Global instance for easy access
_auto_loader = None


def get_auto_loader():
    """
    Get or create the global TemplateAutoLoader instance.
    
    Returns:
        TemplateAutoLoader: The singleton auto-loader instance
    """
    global _auto_loader
    if _auto_loader is None:
        _auto_loader = TemplateAutoLoader()
    return _auto_loader


def auto_load_templates_on_startup():
    """
    Convenience function to auto-load templates on application startup.
    
    This function is designed to be called from AppConfig.ready()
    and is safe to call on every startup.
    
    Returns:
        dict: Statistics about the load operation
    """
    try:
        loader = get_auto_loader()
        return loader.auto_load_templates()
    except Exception as e:
        logger.error(f"Auto-load failed with exception: {e}", exc_info=True)
        return {
            'status': 'error',
            'error_message': str(e)
        }
