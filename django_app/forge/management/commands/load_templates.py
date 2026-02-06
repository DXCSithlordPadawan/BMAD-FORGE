"""
Management command to load BMAD markdown templates and agent prompts into the database.
"""
import os
import json
import yaml
from pathlib import Path

from django.core.management.base import BaseCommand

from forge.models import DocumentTemplate


class Command(BaseCommand):
    help = 'Load BMAD markdown templates and agent prompts into the database'

    def add_arguments(self, parser):
        parser.add_argument(
            '--dry-run',
            action='store_true',
            help='Parse and validate files without saving to database',
        )
        parser.add_argument(
            '--templates-dir',
            type=str,
            default=None,
            help='Path to templates directory (default: <project_root>/templates)',
        )
        parser.add_argument(
            '--agents-dir',
            type=str,
            default=None,
            help='Path to agents directory (default: <project_root>/agents)',
        )

    def handle(self, *args, **options):
        dry_run = options['dry_run']
        project_root = Path(__file__).resolve().parent.parent.parent.parent.parent

        templates_dir = Path(options['templates_dir']) if options['templates_dir'] else project_root / 'templates'
        agents_dir = Path(options['agents_dir']) if options['agents_dir'] else project_root / 'agents'

        if dry_run:
            self.stdout.write(self.style.WARNING('DRY RUN — no database changes will be made'))

        created = 0
        updated = 0
        errors = 0

        for directory, template_type in [(templates_dir, 'template'), (agents_dir, 'agent')]:
            if not directory.exists():
                self.stdout.write(self.style.WARNING(f'Directory not found: {directory}'))
                continue

            md_files = sorted(directory.glob('*.md'))
            self.stdout.write(f'Found {len(md_files)} .md files in {directory}')

            for md_file in md_files:
                try:
                    result = self._process_file(md_file, template_type, dry_run)
                    if result == 'created':
                        created += 1
                    elif result == 'updated':
                        updated += 1
                except Exception as e:
                    errors += 1
                    self.stdout.write(self.style.ERROR(f'  ERROR processing {md_file.name}: {e}'))

        self.stdout.write('')
        self.stdout.write(self.style.SUCCESS(
            f'Done: {created} created, {updated} updated, {errors} errors'
        ))

    def _process_file(self, md_file, template_type, dry_run):
        """Parse a single markdown file and load into database."""
        content = md_file.read_text(encoding='utf-8')
        frontmatter, body = self._parse_frontmatter(content)

        if not frontmatter:
            self.stdout.write(self.style.WARNING(f'  SKIP {md_file.name}: no YAML frontmatter'))
            return None

        name = frontmatter.get('name', md_file.stem)
        description = frontmatter.get('description', '')

        # Normalize roles
        agent_roles = self._normalize_roles(frontmatter)
        agent_role = agent_roles[0] if agent_roles else ''

        workflow_phase = frontmatter.get('workflow_phase', '')
        category = frontmatter.get('category', '')

        # Normalize variables
        raw_vars = frontmatter.get('variables', {})
        normalized_vars = self._normalize_variables(raw_vars) if raw_vars else {}

        source_file = f'{md_file.parent.name}/{md_file.name}'

        # Handle duplicate names: if another record already has this name
        # (with a different source_file), append the file stem to disambiguate.
        existing = DocumentTemplate.objects.filter(name=name).exclude(source_file=source_file).first()
        if existing:
            name = f'{name}-{md_file.stem}'
            self.stdout.write(self.style.WARNING(
                f'  {md_file.name}: duplicate name detected, using "{name}"'
            ))

        self.stdout.write(
            f'  {md_file.name}: name={name}, roles={agent_roles}, '
            f'phase={workflow_phase}, vars={len(normalized_vars)}'
        )

        if dry_run:
            return 'created'

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
        self.stdout.write(self.style.SUCCESS(f'    -> {status}: {obj.name}'))
        return status

    def _parse_frontmatter(self, content):
        """Split content into YAML frontmatter dict and markdown body."""
        content = content.strip()
        if not content.startswith('---'):
            return None, content

        # Find the closing ---
        end = content.find('---', 3)
        if end == -1:
            return None, content

        yaml_str = content[3:end].strip()
        body = content[end + 3:].strip()

        try:
            frontmatter = yaml.safe_load(yaml_str)
        except yaml.YAMLError as e:
            raise ValueError(f'Invalid YAML frontmatter: {e}')

        if not isinstance(frontmatter, dict):
            return None, content

        return frontmatter, body

    def _normalize_roles(self, frontmatter):
        """Extract and normalize roles from frontmatter.

        Handles both singular `role: pm` and plural `roles: [pm, analyst]`.
        """
        roles = []

        # Plural form takes precedence
        if 'roles' in frontmatter:
            raw = frontmatter['roles']
            if isinstance(raw, list):
                roles = [str(r) for r in raw]
            else:
                roles = [str(raw)]

        # Singular form
        if 'role' in frontmatter:
            role = str(frontmatter['role'])
            if role not in roles:
                roles.insert(0, role)

        return roles

    def _normalize_variables(self, raw_vars):
        """Normalize YAML variable definitions to the JSON format expected by GenerateDocumentForm.

        Mapping:
          YAML `description` -> JSON `label`
          YAML `options` -> JSON `choices`
          YAML `input_type` -> JSON `type` (fallback when `type` is absent)
        """
        normalized = {}

        for var_name, var_config in raw_vars.items():
            if not isinstance(var_config, dict):
                continue

            norm = {}

            # Label: prefer description
            if 'description' in var_config:
                norm['label'] = var_config['description']

            # Type: prefer `type`, fall back to `input_type`, default `text`
            var_type = var_config.get('type') or var_config.get('input_type') or 'text'
            norm['type'] = str(var_type)

            # Required
            if 'required' in var_config:
                norm['required'] = bool(var_config['required'])

            # Choices: YAML `options` -> JSON `choices`
            if 'options' in var_config:
                norm['choices'] = var_config['options']
            elif 'choices' in var_config:
                norm['choices'] = var_config['choices']

            # Default value
            if 'default' in var_config:
                norm['default'] = var_config['default']

            # Help text
            if 'help_text' in var_config:
                norm['help_text'] = var_config['help_text']

            # Placeholder
            if 'placeholder' in var_config:
                norm['placeholder'] = var_config['placeholder']

            normalized[var_name] = norm

        return normalized
