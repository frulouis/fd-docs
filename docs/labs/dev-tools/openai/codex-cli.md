# OpenAI Codex CLI

## Overview
A comprehensive guide to using OpenAI's Codex CLI for building applications with AI-powered code generation, multimodal inputs, and advanced development workflows.

## Topics Covered
- Installation and configuration
- Interactive and command-line modes
- Multimodal development with images
- Building applications with Codex
- Advanced features and troubleshooting
- Best practices for AI-assisted development

## Getting Started

OpenAI Codex CLI is a powerful command-line tool that brings AI-powered code generation directly to your terminal. It supports both text and image inputs, making it ideal for UI-to-code workflows and visual development.

### Key Features
- **Natural Language Code Generation**: Build applications using conversational prompts
- **Multimodal Support**: Work with both text and image inputs
- **Multiple Usage Modes**: Interactive, one-liner, and quiet modes
- **Shell Completion**: Auto-complete for streamlined command-line experience
- **Approval Modes**: Flexible control over code changes and execution

---

## Installation and Setup

### Prerequisites
- **Node.js and npm**: Codex CLI is distributed via npm
- **OpenAI API Key**: Required to authenticate with OpenAI services
- **Git**: For version control integration

### Installation Steps

1. **Install Node.js and npm**

   **macOS:**
   ```bash
   brew install node
   ```

   **Ubuntu/Debian:**
   ```bash
   sudo apt update
   sudo apt install nodejs npm
   ```

2. **Install Codex CLI**
   ```bash
   npm install -g @openai/codex
   ```

3. **Set Your OpenAI API Key**
   ```bash
   export OPENAI_API_KEY="your-api-key-here"
   ```
   
   To make this permanent, add the above line to your shell config (e.g., `.bashrc`, `.zshrc`).

---

## Usage Modes

### Interactive Mode
Launches an interactive prompt for conversational development:

```bash
codex
```

Use this when you want to iterate on ideas and see conversational history.

### One-Liner Prompt
Run a single instruction directly from the command line:

```bash
codex "Generate a Flask route for the home page"
```

Perfect for quick edits or script-like usage.

### Quiet Mode
Suppresses interactive prompts and outputs only results:

```bash
codex -q "Create a requirements.txt based on the current project"
```

Ideal for scripting or CI/CD tasks.

### Shell Completion
Enable auto-complete for Codex commands:

```bash
codex completion bash
codex completion zsh
codex completion fish
```

Add the output to your shell config file to streamline your command-line experience.

---

## Approval Modes

Codex CLI operates in three approval modes:

- **Suggest (default)**: Proposes edits/commands and waits for your approval
- **Auto Edit**: Automatically edits files but confirms before executing shell commands
- **Full Auto**: Makes and runs changes without asking for confirmation

Use the `--approval-mode` flag to specify a mode:

```bash
codex --approval-mode auto-edit
```

---

## Building Applications with Codex

### Basic Application Development

1. **Initialize a New Project**
   ```bash
   mkdir my-app
   cd my-app
   git init
   echo "# My App" > README.md
   ```

2. **Scaffold with Codex**
   ```bash
   codex "Create a basic Python Flask app with a single route that returns 'Hello, World!'"
   ```

3. **Enhance the Application**
   ```bash
   # Add routes
   codex "Add a '/about' route to the Flask app that returns 'About Page'"
   
   # Add API endpoints
   codex "Add an '/api/status' route that returns a JSON response with uptime and status"
   
   # Improve structure
   codex "Refactor the Flask routes into a Blueprint in a new 'routes.py' file"
   ```

### Multimodal Development

Codex CLI supports **image + text multimodal inputs**, making it ideal for UI-to-code workflows:

```bash
# Generate code from UI screenshot
codex "Create a Flask route to handle this form submission and generate the corresponding HTML" --image form_design.png
```

**What Codex does:**
- Analyzes the image (form layout, fields)
- Understands the structure and intent
- Generates appropriate routes and templates
- Maintains visual consistency

### Code Organization & Structure

```bash
# Improve code modularity
codex "Refactor the Flask routes into a Blueprint in a new 'routes.py' file"

# Set up environment configuration
codex "Add support for environment variables using python-dotenv and create a .env file for config"
```

### Testing & Logging

```bash
# Add unit tests
codex "Write unit tests for the Flask app's '/' and '/about' routes using pytest"

# Set up logging
codex "Add logging to the Flask app that logs requests and errors to 'logs/app.log'"
```

### Security & Best Practices

```bash
# Review and improve code quality
codex "Review this Flask app and suggest improvements to naming conventions and file organization"

# Enhance security
codex "Check this Flask app for common security issues like debug mode, CSRF protection, and unsafe inputs"
```

---

## Advanced Features

### Context Management
Codex maintains context across your entire project, allowing it to:
- Understand relationships between different files
- Suggest changes that maintain consistency
- Generate code that follows your project's patterns

### Custom Workflows
Create custom workflows for common tasks:
- Code review templates
- Documentation generation
- Test case creation
- Bug fix patterns

### Integration with External Tools
Codex works seamlessly with:
- **Docker**: Container management and deployment
- **Kubernetes**: Orchestration and scaling
- **Cloud Platforms**: AWS, Azure, GCP integration
- **CI/CD Pipelines**: Automated testing and deployment

---

## Best Practices

### Effective Prompting
- Be specific about what you want to achieve
- Provide context about your project's requirements
- Use clear, descriptive language
- Break complex tasks into smaller steps

### Code Quality
- Review AI-generated code before committing
- Test thoroughly, especially for critical functionality
- Maintain consistent coding standards
- Document complex logic and decisions

### Security Considerations
- Never include sensitive information in prompts
- Review generated code for security vulnerabilities
- Use environment variables for configuration
- Implement proper authentication and authorization

### Multimodal Best Practices
- Use high-quality, clear images
- Provide descriptive text prompts with images
- Ensure images are relevant to the code you want to generate
- Test generated code thoroughly

---

## Troubleshooting

### Common Issues
- **API Key Issues**: Ensure your API key is correctly set and has sufficient permissions
- **Node Version**: Ensure you're using Node.js version 14 or higher
- **Image Processing**: For multimodal features, verify your CLI version supports image inputs
- **Model Availability**: Check model availability with `codex config`

### Getting Help
- Check the [Official Documentation](https://platform.openai.com/docs/guides/codex)
- Visit the [GitHub Repository](https://github.com/openai/codex)
- Use `codex --help` for command-line help

---

## Next Steps

Once you're comfortable with Codex CLI basics, explore:
- Advanced multimodal features and image processing
- Integration with your preferred development stack
- Team collaboration and shared workflows
- Performance optimization and debugging techniques

---

## Next Article

[:octicons-arrow-right-24: JMeter Testing](../jmeter/snowflake-load-testing.md){ .md-button .md-button--primary }

Learn how to perform comprehensive load and concurrency testing on Snowflake using Apache JMeter for performance validation and optimization.
