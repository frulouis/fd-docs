# Installation

This guide will help you set up your development environment for following our tutorials.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Python 3.8+**: Download from [python.org](https://www.python.org/downloads/)
- **Git**: Download from [git-scm.com](https://git-scm.com/downloads)
- **Code Editor**: We recommend [VS Code](https://code.visualstudio.com/) or [PyCharm](https://www.jetbrains.com/pycharm/)

## Python Environment Setup

We recommend using a virtual environment to manage dependencies:

=== "venv"

    ```bash
    # Create virtual environment
    python -m venv fd-tutorials-env
    
    # Activate (Windows)
    fd-tutorials-env\Scripts\activate
    
    # Activate (macOS/Linux)
    source fd-tutorials-env/bin/activate
    ```

=== "conda"

    ```bash
    # Create conda environment
    conda create -n fd-tutorials python=3.11
    conda activate fd-tutorials
    ```

=== "uv (Recommended)"

    ```bash
    # Install uv
    pip install uv
    
    # Create and activate environment
    uv venv fd-tutorials-env
    source fd-tutorials-env/bin/activate  # On Windows: fd-tutorials-env\Scripts\activate
    ```

## Install Dependencies

Once your environment is activated, install the required packages:

```bash
# Using pip
pip install -r requirements.txt

# Using uv (faster)
uv pip install -r requirements.txt
```

## Verify Installation

Test your installation by running:

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

print("✅ All packages installed successfully!")
print(f"Python version: {pd.__version__}")
print(f"NumPy version: {np.__version__}")
print(f"Matplotlib version: {plt.matplotlib.__version__}")
print(f"Seaborn version: {sns.__version__}")
```

## Development Tools

For the best experience, we recommend installing these VS Code extensions:

- **Python** - Python language support
- **Jupyter** - Jupyter notebook support
- **Python Docstring Generator** - Auto-generate docstrings
- **autoDocstring** - Python docstring generator
- **GitLens** - Git supercharged

## Next Steps

Now that you have everything set up, you're ready to start learning! Check out our [Python Basics tutorial](../tutorials/data-science/python-basics.md) to begin your journey.

## Troubleshooting

### Common Issues

**Issue**: `pip` command not found
**Solution**: Make sure Python is installed and added to your PATH

**Issue**: Permission denied errors
**Solution**: Use `--user` flag with pip or activate your virtual environment

**Issue**: Package installation fails
**Solution**: Update pip: `python -m pip install --upgrade pip`

### Getting Help

If you encounter any issues:

1. Search existing [GitHub Issues](https://github.com/frunde/fd-docs/issues)
2. Create a new issue with detailed error information
