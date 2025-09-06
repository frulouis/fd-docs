# Fru Dev

A comprehensive tutorial site built with Material for MkDocs, inspired by madewithml.com. This site provides step-by-step tutorials for data science, AI, and development topics.

## Features

- 🎨 **Modern Design**: Clean, responsive Material Design theme
- 📚 **Comprehensive Content**: Tutorials covering data science, AI, and development
- 🔍 **Advanced Search**: Full-text search with instant suggestions
- 📱 **Mobile Friendly**: Responsive design that works on all devices
- 🌙 **Dark Mode**: Automatic dark/light mode switching
- ⚡ **Fast Loading**: Optimized for performance
- 🔧 **Easy Customization**: Simple configuration and theming

## Quick Start

### Prerequisites

- Python 3.8 or higher
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/frunde/fd-docs.git
   cd fd-docs
   ```

2. **Set up virtual environment**
   ```bash
   # Using uv (recommended)
   uv venv fd-tutorials-env
   source fd-tutorials-env/bin/activate  # On Windows: fd-tutorials-env\Scripts\activate
   
   # Or using venv
   python -m venv fd-tutorials-env
   source fd-tutorials-env/bin/activate  # On Windows: fd-tutorials-env\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   # Using uv (faster)
   uv pip install -r requirements.txt
   
   # Or using pip
   pip install -r requirements.txt
   ```

4. **Start development server**
   ```bash
   mkdocs serve
   ```

5. **Open your browser**
   Navigate to `http://localhost:8000` to view the site.

## Project Structure

```
fd-docs/
├── assets/                 # Static assets (images, videos, etc.)
├── configs/               # Configuration files
├── data/                  # Data files and databases
├── docs/                  # Documentation source files
│   ├── getting-started/   # Getting started guides
│   ├── tutorials/         # Tutorial content
│   │   ├── data-science/  # Data science tutorials
│   │   ├── ai-ml/         # AI/ML tutorials
│   │   └── development/   # Development tutorials
│   ├── guides/            # Best practices and guides
│   └── reference/         # API reference and glossary
├── src/                   # Source code
│   ├── tests/             # Test files
│   ├── utilities/         # Utility functions
│   ├── pipelines/         # Data processing pipelines
│   └── mcp/               # MCP server code
├── overrides/             # Custom theme overrides
│   ├── css/               # Custom CSS
│   └── partials/          # Custom HTML partials
├── mkdocs.yml             # MkDocs configuration
├── pyproject.toml         # Python project configuration
├── requirements.txt       # Python dependencies
└── README.md              # This file
```

## Configuration

The site is configured through `mkdocs.yml`. Key configuration options:

- **Theme**: Material for MkDocs with custom styling
- **Navigation**: Hierarchical navigation structure
- **Plugins**: Search, git integration, minification
- **Extensions**: Enhanced markdown features

## Customization

### Adding New Tutorials

1. Create a new markdown file in the appropriate directory under `docs/tutorials/`
2. Add the tutorial to the navigation in `mkdocs.yml`
3. Use the existing tutorial templates as a guide

### Styling

- Custom CSS: `overrides/css/extra.css`
- Custom HTML: `overrides/partials/`
- Theme configuration: `mkdocs.yml` under `theme:`

### Content Structure

Each tutorial should include:
- Clear learning objectives
- Prerequisites
- Step-by-step instructions
- Code examples
- Exercises
- Next steps

## Development

### Running Tests

```bash
pytest
```

### Code Formatting

```bash
# Format code
black src/
isort src/

# Check code quality
flake8 src/
mypy src/
```

### Building for Production

```bash
mkdocs build
```

The built site will be in the `site/` directory.

## Deployment

### GitHub Pages

1. Enable GitHub Pages in repository settings
2. Set source to GitHub Actions
3. Push changes to trigger deployment

### Other Hosting

1. Build the site: `mkdocs build`
2. Upload the `site/` directory to your hosting provider

## Contributing

We welcome contributions! Please see our [Contributing Guide](docs/guides/contributing.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) for the excellent theme
- [Made With ML](https://madewithml.com/) for inspiration
- The open-source community for amazing tools and libraries

## Support

- 📖 [Documentation](https://fd-tutorials.com)
- 🐛 [Issues](https://github.com/frunde/fd-docs/issues)
- 💬 [Discussions](https://github.com/frunde/fd-docs/discussions)

---

**Happy Learning! 🚀**

---

*Built with ❤️ by Fru Dev*
