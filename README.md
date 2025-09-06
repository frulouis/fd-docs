# Fru Dev Labs (FD Labs) - Data Engineering Tutorials

[![Deploy to GitHub Pages](https://github.com/frulouis/fd-labs/actions/workflows/deploy.yml/badge.svg)](https://github.com/frulouis/fd-labs/actions/workflows/deploy.yml)
[![Live Site](https://img.shields.io/badge/Live%20Site-https://frulouis.github.io/fd-labs-blue)](https://frulouis.github.io/fd-labs)

A comprehensive collection of modern data engineering tutorials, focusing on Snowflake, AI/ML, and hands-on projects.

## 🚀 Live Site

Visit the live site at: **https://frulouis.github.io/fd-labs**

## 📚 What You'll Find

- **Getting Started** - Installation guides and quick setup
- **About** - Our mission and approach to data engineering education
- **Blog** - Community insights and technical deep dives
- **Community** - Guidelines and platforms for collaboration
- **Subscribe** - Newsletter for latest updates

## 🛠️ Technology Stack

- **MkDocs** - Static site generator
- **Material for MkDocs** - Modern documentation theme
- **Python** - Backend and automation scripts
- **GitHub Pages** - Hosting and deployment
- **GitHub Actions** - CI/CD pipeline

## 🏗️ Local Development

### Prerequisites

- Python 3.12+
- pip or uv package manager

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/frulouis/fd-labs.git
   cd fd-labs
   ```

2. **Install dependencies**
   ```bash
   # Using pip
   pip install -r requirements.txt
   
   # Or using uv (recommended)
   uv sync
   ```

3. **Start development server**
   ```bash
   mkdocs serve
   ```

4. **Open in browser**
   ```
   http://127.0.0.1:8000
   ```

### Building

```bash
# Build static site
mkdocs build

# Build and serve
mkdocs serve --dev-addr 127.0.0.1:8000
```

## 📁 Project Structure

```
fd-labs/
├── docs/                    # Documentation content
│   ├── index.md            # Homepage
│   ├── about.md            # About page
│   ├── blog.md             # Blog page
│   ├── subscribe.md        # Newsletter subscription
│   ├── community.md        # Community guidelines
│   ├── getting-started/    # Getting started guides
│   ├── tutorials/          # Tutorial content
│   └── assets/             # Images and static assets
├── overrides/              # Custom theme overrides
│   ├── css/               # Custom CSS
│   └── main.html          # Template overrides
├── scripts/               # Automation scripts
├── .github/workflows/     # GitHub Actions
├── mkdocs.yml            # MkDocs configuration
└── requirements.txt      # Python dependencies
```

## 🎨 Customization

### Theme Customization

- **CSS**: Edit `overrides/css/extra.css`
- **Templates**: Modify `overrides/main.html`
- **Configuration**: Update `mkdocs.yml`

### Adding Content

1. **New Pages**: Add `.md` files to `docs/`
2. **Navigation**: Update `nav` section in `mkdocs.yml`
3. **Images**: Place in `docs/assets/images/`
4. **Styling**: Modify CSS in `overrides/css/`

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow [PEP 8](https://pep8.org/) for Python code
- Use clear, descriptive commit messages
- Test changes locally before submitting
- Update documentation for new features

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [MkDocs](https://www.mkdocs.org/) - Static site generator
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) - Documentation theme
- [GitHub Pages](https://pages.github.com/) - Hosting platform
- Community contributors and feedback

## 📞 Contact

- **Website**: [https://frulouis.github.io/fd-labs](https://frulouis.github.io/fd-labs)
- **GitHub**: [@frulouis](https://github.com/frulouis)
- **Email**: [contact@frudev.com](mailto:contact@frudev.com)

---

**Fru Dev Labs (FD Labs)** - Empowering developers with knowledge and practical skills for the modern data world.