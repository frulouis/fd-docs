# Python Basics for Data Science

Learn the essential Python concepts you need for data science and analysis.

## Overview

This tutorial covers the fundamental Python programming concepts that form the foundation of data science work. By the end, you'll be comfortable with:

- Variables and data types
- Control structures
- Functions and classes
- Working with libraries
- Data structures for analysis

## Prerequisites

- Basic programming knowledge (any language)
- Python 3.8+ installed
- Code editor set up

## Variables and Data Types

Python is dynamically typed, meaning you don't need to declare variable types explicitly.

```python
# Numbers
age = 25
height = 5.9
is_student = True

# Strings
name = "Alice"
message = 'Hello, World!'

# Check types
print(type(age))        # <class 'int'>
print(type(height))     # <class 'float'>
print(type(is_student)) # <class 'bool'>
print(type(name))       # <class 'str'>
```

### Numeric Operations

```python
# Basic arithmetic
a, b = 10, 3
print(a + b)    # 13
print(a - b)    # 7
print(a * b)    # 30
print(a / b)    # 3.333...
print(a // b)   # 3 (floor division)
print(a % b)    # 1 (modulo)
print(a ** b)   # 1000 (exponentiation)
```

## Data Structures

### Lists

Lists are ordered, mutable collections:

```python
# Creating lists
numbers = [1, 2, 3, 4, 5]
mixed = [1, "hello", 3.14, True]
empty = []

# List operations
numbers.append(6)           # Add to end
numbers.insert(0, 0)        # Insert at index
numbers.remove(3)           # Remove first occurrence
last = numbers.pop()        # Remove and return last
length = len(numbers)       # Get length

# List slicing
first_three = numbers[:3]   # [0, 1, 2]
last_two = numbers[-2:]     # [4, 5]
middle = numbers[1:4]       # [1, 2, 4]
```

### Dictionaries

Dictionaries store key-value pairs:

```python
# Creating dictionaries
person = {
    "name": "Alice",
    "age": 25,
    "city": "New York"
}

# Accessing values
name = person["name"]           # "Alice"
age = person.get("age", 0)      # 25 (with default)
city = person.get("country", "Unknown")  # "Unknown"

# Modifying dictionaries
person["age"] = 26              # Update
person["country"] = "USA"       # Add new key
del person["city"]              # Remove key

# Dictionary methods
keys = person.keys()            # dict_keys(['name', 'age', 'country'])
values = person.values()        # dict_values(['Alice', 26, 'USA'])
items = person.items()          # dict_items([('name', 'Alice'), ...])
```

### Tuples and Sets

```python
# Tuples (immutable)
coordinates = (10, 20)
point = (x, y, z) = (1, 2, 3)

# Sets (unique elements)
unique_numbers = {1, 2, 3, 4, 5}
unique_numbers.add(6)
unique_numbers.remove(1)
```

## Control Structures

### Conditional Statements

```python
# if-elif-else
score = 85

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
else:
    grade = "F"

print(f"Grade: {grade}")  # Grade: B
```

### Loops

```python
# for loops
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)

# with enumerate
for i, fruit in enumerate(fruits):
    print(f"{i}: {fruit}")

# range
for i in range(5):        # 0, 1, 2, 3, 4
    print(i)

for i in range(1, 6):     # 1, 2, 3, 4, 5
    print(i)

# while loops
count = 0
while count < 5:
    print(count)
    count += 1
```

### List Comprehensions

```python
# Traditional approach
squares = []
for i in range(10):
    squares.append(i ** 2)

# List comprehension
squares = [i ** 2 for i in range(10)]

# With conditions
even_squares = [i ** 2 for i in range(10) if i % 2 == 0]

# Dictionary comprehension
square_dict = {i: i ** 2 for i in range(5)}
```

## Functions

Functions help organize and reuse code:

```python
# Basic function
def greet(name):
    return f"Hello, {name}!"

# Function with default parameters
def calculate_area(length, width=1):
    return length * width

# Function with multiple return values
def get_stats(numbers):
    return min(numbers), max(numbers), sum(numbers) / len(numbers)

# Lambda functions (anonymous)
square = lambda x: x ** 2
numbers = [1, 2, 3, 4, 5]
squared = list(map(square, numbers))
```

### Function Documentation

```python
def calculate_bmi(weight, height):
    """
    Calculate Body Mass Index (BMI).
    
    Args:
        weight (float): Weight in kilograms
        height (float): Height in meters
    
    Returns:
        float: BMI value
    """
    return weight / (height ** 2)
```

## Working with Libraries

### Importing Libraries

```python
# Standard library imports
import math
import random
from datetime import datetime

# Third-party imports
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Aliasing
import matplotlib.pyplot as plt
import seaborn as sns
```

### Common Data Science Libraries

```python
# NumPy for numerical computing
import numpy as np

# Create arrays
arr = np.array([1, 2, 3, 4, 5])
matrix = np.array([[1, 2], [3, 4]])

# Array operations
mean_val = np.mean(arr)
std_val = np.std(arr)
max_val = np.max(arr)

# Pandas for data manipulation
import pandas as pd

# Create DataFrame
data = {
    'name': ['Alice', 'Bob', 'Charlie'],
    'age': [25, 30, 35],
    'city': ['NYC', 'LA', 'Chicago']
}
df = pd.DataFrame(data)

# Basic operations
print(df.head())
print(df.describe())
print(df['age'].mean())
```

## Error Handling

```python
# try-except blocks
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero!")
except Exception as e:
    print(f"An error occurred: {e}")
else:
    print("No errors occurred")
finally:
    print("This always runs")

# Raising exceptions
def validate_age(age):
    if age < 0:
        raise ValueError("Age cannot be negative")
    return age
```

## File Operations

```python
# Reading files
with open('data.txt', 'r') as file:
    content = file.read()

# Writing files
with open('output.txt', 'w') as file:
    file.write("Hello, World!")

# Working with CSV files
import csv

# Reading CSV
with open('data.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        print(row)

# Writing CSV
data = [['Name', 'Age'], ['Alice', 25], ['Bob', 30]]
with open('output.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(data)
```

## Best Practices

1. **Use meaningful variable names**
2. **Write docstrings for functions**
3. **Follow PEP 8 style guidelines**
4. **Use virtual environments**
5. **Handle errors gracefully**
6. **Write modular, reusable code**

## Exercises

### Exercise 1: Temperature Converter
Create a function that converts between Celsius and Fahrenheit.

### Exercise 2: List Statistics
Write a function that calculates mean, median, and mode of a list of numbers.

### Exercise 3: Word Counter
Create a function that counts the frequency of words in a text string.

## Next Steps

Now that you understand Python basics, you're ready to dive into data analysis! More tutorials are coming soon.

## Additional Resources

- [Python Official Documentation](https://docs.python.org/3/)
- [PEP 8 Style Guide](https://pep8.org/)
- [Python Tutor](http://pythontutor.com/) - Visualize code execution
- [Real Python](https://realpython.com/) - In-depth Python tutorials
