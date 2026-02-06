"""
Django app configuration for BMAD Forge
"""
from django.apps import AppConfig
import logging

logger = logging.getLogger(__name__)


class ForgeConfig(AppConfig):
    """Configuration for the forge application"""
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'forge'
    verbose_name = 'BMAD Forge Document Generator'
    
    def ready(self):
        """
        Application ready hook - runs once when Django starts.
        
        Auto-loads templates from filesystem if database is empty.
        This ensures templates are available immediately after deployment
        without requiring manual intervention.
        
        Security Notes:
        - Only loads if database is empty (idempotent)
        - Uses atomic transactions
        - Comprehensive error handling
        - Fails gracefully if errors occur
        """
        # Import signals here if needed
        
        # Auto-load templates on first startup
        try:
            # Import here to avoid AppRegistryNotReady errors
            from forge.utils.template_loader import auto_load_templates_on_startup
            
            # Only attempt auto-load if we're in a worker process
            # (avoids running during migrations, shell, etc.)
            import sys
            if 'runserver' in sys.argv or 'gunicorn' in sys.argv[0]:
                logger.info("Checking if template auto-load is needed...")
                stats = auto_load_templates_on_startup()
                
                if stats['status'] == 'success' and stats['created'] > 0:
                    logger.info(
                        f"Template auto-load completed: "
                        f"{stats['created']} created, {stats['updated']} updated"
                    )
                elif stats['status'] == 'skipped':
                    logger.debug("Template auto-load skipped (templates already exist)")
                elif stats['status'] == 'error':
                    logger.error(f"Template auto-load failed: {stats.get('error_message')}")
                    
        except Exception as e:
            # Log error but don't crash the application
            logger.error(f"Template auto-load encountered an error: {e}", exc_info=True)
