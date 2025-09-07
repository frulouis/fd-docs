# Tab Test Page

This is a test page to verify that the collapsible sections work correctly with multiple content types.

## Overview

This page demonstrates a 3-section layout with different content types using collapsible sections for better organization and user experience.

## Step-by-Step Guide

<details>
<summary>Click to expand step-by-step instructions</summary>

### Getting Started

Follow these steps to set up your environment:

#### Step 1: Install Dependencies

First, you need to install the required packages:

```bash
pip install pandas numpy matplotlib
```

#### Step 2: Import Libraries

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
```

#### Step 3: Create Sample Data

```python
# Create sample data
data = {
    'name': ['Alice', 'Bob', 'Charlie'],
    'age': [25, 30, 35],
    'city': ['New York', 'London', 'Tokyo']
}

df = pd.DataFrame(data)
print(df)
```

#### Step 4: Create Visualization

```python
# Create a simple plot
plt.figure(figsize=(10, 6))
df.plot(x='name', y='age', kind='bar')
plt.title('Age by Name')
plt.show()
```

</details>

## Complete Code

<details>
<summary>Click to expand complete implementation</summary>

Here's the complete code that you can copy and run:

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Create sample data
data = {
    'name': ['Alice', 'Bob', 'Charlie'],
    'age': [25, 30, 35],
    'city': ['New York', 'London', 'Tokyo']
}

df = pd.DataFrame(data)
print(df)

# Create a simple plot
plt.figure(figsize=(10, 6))
df.plot(x='name', y='age', kind='bar')
plt.title('Age by Name')
plt.show()

# Save the plot
plt.savefig('age_chart.png', dpi=300, bbox_inches='tight')
print("Chart saved as age_chart.png")
```

### Expected Output

When you run this code, you should see:

1. A DataFrame printed to the console
2. A bar chart displayed
3. A confirmation message that the chart was saved

</details>

## LLM Prompt

<details>
<summary>Click to expand LLM prompt</summary>

Here's a prompt you can use with an LLM to generate similar code:

```
Create a Python script that:
1. Imports pandas, numpy, and matplotlib
2. Creates a sample dataset with names, ages, and cities
3. Displays the data in a DataFrame
4. Creates a bar chart showing age by name
5. Saves the plot as an image

Make the code well-commented and include error handling.
```

### Additional Context

You can also add context like:

```
The dataset should have at least 3 people with different ages and cities.
The bar chart should be professional-looking with proper labels.
Include error handling for file operations.
The script should be runnable without additional setup.
```

</details>

## Testing the Implementation

This page tests:

1. **Collapsible sections** - Each section can be expanded/collapsed independently
2. **Code syntax highlighting** - Python code blocks are properly formatted
3. **Nested content** - Multiple levels of headings within collapsible sections
4. **Mixed content** - Code, text, and instructions in the same section
5. **User experience** - Clean, organized layout that's easy to navigate

## Benefits of This Approach

- ✅ **Reliable** - Works consistently with MkDocs Material
- ✅ **Clean** - Organized, easy to read layout
- ✅ **Flexible** - Users can expand only what they need
- ✅ **Maintainable** - Easy to update and modify
- ✅ **Accessible** - Works well with screen readers and keyboard navigation