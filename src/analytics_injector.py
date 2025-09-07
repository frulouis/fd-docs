#!/usr/bin/env python3
"""
Google Analytics Injector for MkDocs
Loads analytics configuration and injects tracking code into the site.
"""

import yaml
import os
from pathlib import Path

def load_analytics_config():
    """Load analytics configuration from YAML file."""
    config_path = Path(__file__).parent.parent / "configs" / "analytics.yaml"
    
    if not config_path.exists():
        print("⚠️  Analytics config not found. Analytics will be disabled.")
        return None
    
    try:
        with open(config_path, 'r') as file:
            config = yaml.safe_load(file)
        return config
    except Exception as e:
        print(f"❌ Error loading analytics config: {e}")
        return None

def generate_analytics_script(config):
    """Generate Google Analytics tracking script."""
    if not config or not config.get('google_analytics', {}).get('enabled'):
        return ""
    
    analytics = config['google_analytics']
    measurement_id = analytics['measurement_id']
    script_url = analytics['script_url']
    
    # Privacy settings
    anonymize_ip = config.get('tracking', {}).get('anonymize_ip', True)
    respect_dnt = config.get('tracking', {}).get('respect_dnt', True)
    
    script = f"""<!-- Google Analytics (gtag.js) -->
<script async src="{script_url}?id={measurement_id}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){{dataLayer.push(arguments);}}
  gtag('js', new Date());
  
  gtag('config', '{measurement_id}', {{
    'anonymize_ip': {str(anonymize_ip).lower()},
    'respect_dnt': {str(respect_dnt).lower()}
  }});
</script>"""
    
    return script

def main():
    """Main function to generate analytics script."""
    config = load_analytics_config()
    script = generate_analytics_script(config)
    
    if script:
        print("✅ Google Analytics script generated successfully")
        print(f"📊 Measurement ID: {config['google_analytics']['measurement_id']}")
    else:
        print("ℹ️  No analytics script generated")
    
    return script

if __name__ == "__main__":
    main()
