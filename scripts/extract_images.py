#!/usr/bin/env python3
"""
Image Extraction Script for Fru Dev Tutorials

This script extracts images and diagrams from the original DemoHub tutorial sites
and saves them locally for use in the Fru Dev documentation.

Usage:
    python scripts/extract_images.py
"""

import requests
import os
import re
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
import time

# Source URLs for each data model
SOURCE_URLS = {
    'salesdb': 'https://complex-teammates-374480.framer.app/demo/salesdb-data-model',
    'caresdb': 'https://complex-teammates-374480.framer.app/demo/caresdb-data-model',
    'ordersdb': 'https://complex-teammates-374480.framer.app/demo/ordersdb-data-model',
    'iotdb': 'https://complex-teammates-374480.framer.app/demo/iotdb',
    'medisnowdb': 'https://complex-teammates-374480.framer.app/demo/medisnowdb'
}

# Image types to extract
IMAGE_TYPES = [
    'architecture',
    'data-quality',
    'pii-tagging',
    'masking-policy',
    'analytics-dashboard',
    'rbac-architecture',
    'workflow-diagram',
    'ecommerce-flow',
    'sensor-network',
    'clinical-workflow',
    'hipaa-compliance',
    'data-classification'
]

def create_assets_directory():
    """Create the assets directory structure if it doesn't exist."""
    assets_dir = 'docs/assets/images'
    os.makedirs(assets_dir, exist_ok=True)
    print(f"✅ Created assets directory: {assets_dir}")

def extract_images_from_url(url, model_name):
    """Extract images from a specific URL."""
    try:
        print(f"🔍 Extracting images from {url}...")
        
        # Add headers to mimic a real browser
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Find all image elements
        images = soup.find_all('img')
        print(f"📸 Found {len(images)} images on the page")
        
        extracted_count = 0
        
        for i, img in enumerate(images):
            try:
                # Get image source
                src = img.get('src') or img.get('data-src')
                if not src:
                    continue
                
                # Convert relative URLs to absolute
                img_url = urljoin(url, src)
                
                # Generate filename
                parsed_url = urlparse(img_url)
                filename = os.path.basename(parsed_url.path)
                
                # If no filename, generate one
                if not filename or '.' not in filename:
                    filename = f"{model_name}-image-{i+1}.png"
                
                # Ensure PNG extension
                if not filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.svg')):
                    filename += '.png'
                
                # Download image
                img_response = requests.get(img_url, headers=headers, timeout=30)
                img_response.raise_for_status()
                
                # Save image
                filepath = f"docs/assets/images/{filename}"
                with open(filepath, 'wb') as f:
                    f.write(img_response.content)
                
                print(f"  ✅ Downloaded: {filename}")
                extracted_count += 1
                
                # Rate limiting
                time.sleep(0.5)
                
            except Exception as e:
                print(f"  ❌ Error downloading image {i+1}: {e}")
                continue
        
        print(f"🎉 Successfully extracted {extracted_count} images from {model_name}")
        return extracted_count
        
    except Exception as e:
        print(f"❌ Error extracting images from {url}: {e}")
        return 0

def create_placeholder_images():
    """Create placeholder images for missing diagrams."""
    print("🎨 Creating placeholder images...")
    
    # Create a simple placeholder image using PIL if available
    try:
        from PIL import Image, ImageDraw, ImageFont
        
        for model in SOURCE_URLS.keys():
            for img_type in IMAGE_TYPES:
                filename = f"docs/assets/images/{model}-{img_type}.png"
                
                if not os.path.exists(filename):
                    # Create placeholder image
                    img = Image.new('RGB', (800, 600), color='#f0f0f0')
                    draw = ImageDraw.Draw(img)
                    
                    # Add text
                    text = f"{model.upper()} {img_type.replace('-', ' ').title()}"
                    try:
                        font = ImageFont.truetype("/System/Library/Fonts/Arial.ttf", 24)
                    except:
                        font = ImageFont.load_default()
                    
                    # Center text
                    bbox = draw.textbbox((0, 0), text, font=font)
                    text_width = bbox[2] - bbox[0]
                    text_height = bbox[3] - bbox[1]
                    x = (800 - text_width) // 2
                    y = (600 - text_height) // 2
                    
                    draw.text((x, y), text, fill='#333333', font=font)
                    
                    # Save placeholder
                    img.save(filename)
                    print(f"  📝 Created placeholder: {filename}")
        
        print("✅ Placeholder images created successfully")
        
    except ImportError:
        print("⚠️  PIL not available, skipping placeholder creation")
        print("   Install with: pip install Pillow")

def main():
    """Main function to extract all images."""
    print("🚀 Starting image extraction for Fru Dev tutorials...")
    
    # Create assets directory
    create_assets_directory()
    
    # Extract images from each source URL
    total_extracted = 0
    for model_name, url in SOURCE_URLS.items():
        print(f"\n📊 Processing {model_name.upper()} data model...")
        extracted = extract_images_from_url(url, model_name)
        total_extracted += extracted
    
    # Create placeholder images for missing diagrams
    create_placeholder_images()
    
    print(f"\n🎉 Image extraction complete!")
    print(f"📈 Total images extracted: {total_extracted}")
    print(f"📁 Images saved to: docs/assets/images/")
    
    # List all images
    print("\n📋 Extracted images:")
    for root, dirs, files in os.walk('docs/assets/images'):
        for file in files:
            if file.endswith(('.png', '.jpg', '.jpeg', '.gif', '.svg')):
                print(f"  - {file}")

if __name__ == "__main__":
    main()
