# Building Streamlit Apps with Snowflake

Create interactive data applications using Streamlit and Snowflake for data visualization, analysis, and user interaction.

## Overview

This tutorial covers:
- Setting up Streamlit with Snowflake
- Building interactive dashboards
- Creating data visualization apps
- Implementing user authentication
- Deploying Streamlit applications

## Prerequisites

- Snowflake account with appropriate privileges
- Python environment with Streamlit installed
- Basic knowledge of Python and SQL
- Understanding of web application concepts

## Getting Started

### Installation

```bash
# Install Streamlit and Snowflake connector
pip install streamlit snowflake-connector-python

# Install additional packages for data visualization
pip install plotly pandas numpy
```

### Basic Setup

```python
# app.py
import streamlit as st
import snowflake.connector
import pandas as pd
import plotly.express as px

# Page configuration
st.set_page_config(
    page_title="Snowflake Analytics Dashboard",
    page_icon="❄️",
    layout="wide"
)

# Initialize connection
@st.cache_resource
def init_connection():
    return snowflake.connector.connect(
        user=st.secrets["snowflake"]["user"],
        password=st.secrets["snowflake"]["password"],
        account=st.secrets["snowflake"]["account"],
        warehouse=st.secrets["snowflake"]["warehouse"],
        database=st.secrets["snowflake"]["database"],
        schema=st.secrets["snowflake"]["schema"]
    )

conn = init_connection()

# Main app
st.title("❄️ Snowflake Analytics Dashboard")
st.markdown("Interactive data analysis and visualization")
```

## Basic Data Visualization

### Simple Query and Display

```python
# Query data from Snowflake
@st.cache_data
def load_data(query):
    return pd.read_sql(query, conn)

# Sample query
query = """
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(*) as order_count,
    SUM(order_amount) as total_revenue
FROM orders
WHERE order_date >= DATEADD(year, -1, CURRENT_DATE())
GROUP BY month
ORDER BY month
"""

df = load_data(query)

# Display data
st.subheader("Monthly Sales Data")
st.dataframe(df)

# Create visualization
fig = px.line(df, x='MONTH', y='TOTAL_REVENUE', title='Monthly Revenue Trend')
st.plotly_chart(fig, use_container_width=True)
```

### Interactive Filters

```python
# Sidebar filters
st.sidebar.header("Filters")

# Date range filter
date_range = st.sidebar.date_input(
    "Select Date Range",
    value=(df['MONTH'].min(), df['MONTH'].max()),
    min_value=df['MONTH'].min(),
    max_value=df['MONTH'].max()
)

# Category filter
categories = st.sidebar.multiselect(
    "Select Categories",
    options=['Electronics', 'Clothing', 'Books', 'Home'],
    default=['Electronics', 'Clothing']
)

# Dynamic query based on filters
filtered_query = f"""
SELECT 
    DATE_TRUNC('month', order_date) as month,
    category,
    COUNT(*) as order_count,
    SUM(order_amount) as total_revenue
FROM orders
WHERE order_date BETWEEN '{date_range[0]}' AND '{date_range[1]}'
AND category IN ({','.join([f"'{cat}'" for cat in categories])})
GROUP BY month, category
ORDER BY month, category
"""

filtered_df = load_data(filtered_query)

# Display filtered results
st.subheader("Filtered Sales Data")
st.dataframe(filtered_df)
```

## Advanced Visualizations

### Multi-Chart Dashboard

```python
# Create tabs for different views
tab1, tab2, tab3, tab4 = st.tabs(["Overview", "Trends", "Distribution", "Correlations"])

with tab1:
    # Revenue by category
    category_revenue = filtered_df.groupby('CATEGORY')['TOTAL_REVENUE'].sum().reset_index()
    fig1 = px.pie(category_revenue, values='TOTAL_REVENUE', names='CATEGORY', 
                  title='Revenue by Category')
    st.plotly_chart(fig1, use_container_width=True)

with tab2:
    # Time series with multiple lines
    fig2 = px.line(filtered_df, x='MONTH', y='TOTAL_REVENUE', color='CATEGORY',
                   title='Revenue Trends by Category')
    st.plotly_chart(fig2, use_container_width=True)

with tab3:
    # Distribution of order amounts
    order_dist_query = """
    SELECT order_amount
    FROM orders
    WHERE order_date >= DATEADD(month, -6, CURRENT_DATE())
    """
    order_dist_df = load_data(order_dist_query)
    
    fig3 = px.histogram(order_dist_df, x='ORDER_AMOUNT', nbins=50,
                       title='Distribution of Order Amounts')
    st.plotly_chart(fig3, use_container_width=True)

with tab4:
    # Correlation matrix
    numeric_cols = ['ORDER_COUNT', 'TOTAL_REVENUE']
    corr_matrix = filtered_df[numeric_cols].corr()
    
    fig4 = px.imshow(corr_matrix, text_auto=True, aspect="auto",
                     title='Correlation Matrix')
    st.plotly_chart(fig4, use_container_width=True)
```

### Real-time Data Updates

```python
# Auto-refresh functionality
if st.button("🔄 Refresh Data"):
    st.cache_data.clear()
    st.rerun()

# Auto-refresh every 5 minutes
if st.checkbox("Auto-refresh (5 minutes)"):
    st.info("Auto-refresh enabled. Data will update every 5 minutes.")
    time.sleep(300)
    st.rerun()

# Real-time metrics
col1, col2, col3, col4 = st.columns(4)

with col1:
    total_orders = filtered_df['ORDER_COUNT'].sum()
    st.metric("Total Orders", f"{total_orders:,}")

with col2:
    total_revenue = filtered_df['TOTAL_REVENUE'].sum()
    st.metric("Total Revenue", f"${total_revenue:,.2f}")

with col3:
    avg_order_value = total_revenue / total_orders if total_orders > 0 else 0
    st.metric("Average Order Value", f"${avg_order_value:.2f}")

with col4:
    growth_rate = ((filtered_df['TOTAL_REVENUE'].iloc[-1] - 
                   filtered_df['TOTAL_REVENUE'].iloc[0]) / 
                   filtered_df['TOTAL_REVENUE'].iloc[0] * 100) if len(filtered_df) > 1 else 0
    st.metric("Growth Rate", f"{growth_rate:.1f}%")
```

## User Authentication

### Basic Authentication

```python
# Simple authentication
def check_password():
    """Returns `True` if the user had the correct password."""
    
    def password_entered():
        """Checks whether a password entered by the user is correct."""
        if st.session_state["password"] == st.secrets["app"]["password"]:
            st.session_state["password_correct"] = True
            del st.session_state["password"]  # don't store password
        else:
            st.session_state["password_correct"] = False

    if "password_correct" not in st.session_state:
        # First run, show input for password.
        st.text_input("Password", type="password", on_change=password_entered, key="password")
        return False
    elif not st.session_state["password_correct"]:
        # Password not correct, show input + error.
        st.text_input("Password", type="password", on_change=password_entered, key="password")
        st.error("😕 Password incorrect")
        return False
    else:
        # Password correct.
        return True

if check_password():
    st.write("Here's your app!")
    # Your app code here
```

### Advanced Authentication with Snowflake

```python
# Snowflake-based authentication
def authenticate_user(username, password):
    """Authenticate user against Snowflake user database."""
    try:
        # Create a separate connection for authentication
        auth_conn = snowflake.connector.connect(
            user=username,
            password=password,
            account=st.secrets["snowflake"]["account"],
            warehouse=st.secrets["snowflake"]["warehouse"],
            database=st.secrets["snowflake"]["database"]
        )
        
        # Check if user has access to the app schema
        cursor = auth_conn.cursor()
        cursor.execute("SELECT CURRENT_USER()")
        current_user = cursor.fetchone()[0]
        
        # Check user permissions
        cursor.execute("""
            SELECT COUNT(*) 
            FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES 
            WHERE GRANTEE = ? AND TABLE_SCHEMA = 'APP_DATA'
        """, (current_user,))
        
        has_access = cursor.fetchone()[0] > 0
        cursor.close()
        auth_conn.close()
        
        return has_access, current_user
        
    except Exception as e:
        st.error(f"Authentication failed: {str(e)}")
        return False, None

# Login form
if "authenticated" not in st.session_state:
    st.title("🔐 Login")
    
    with st.form("login_form"):
        username = st.text_input("Username")
        password = st.text_input("Password", type="password")
        submitted = st.form_submit_button("Login")
        
        if submitted:
            has_access, current_user = authenticate_user(username, password)
            if has_access:
                st.session_state["authenticated"] = True
                st.session_state["user"] = current_user
                st.success(f"Welcome, {current_user}!")
                st.rerun()
            else:
                st.error("Invalid credentials or insufficient permissions")
else:
    st.write(f"Welcome, {st.session_state['user']}!")
    # Your authenticated app code here
```

## Data Input and Forms

### Data Entry Forms

```python
# Data entry form
st.subheader("📝 Add New Order")

with st.form("order_form"):
    col1, col2 = st.columns(2)
    
    with col1:
        customer_id = st.text_input("Customer ID")
        product_id = st.text_input("Product ID")
        order_amount = st.number_input("Order Amount", min_value=0.0, step=0.01)
    
    with col2:
        order_date = st.date_input("Order Date")
        category = st.selectbox("Category", 
                               ["Electronics", "Clothing", "Books", "Home"])
        status = st.selectbox("Status", 
                             ["Pending", "Shipped", "Delivered", "Cancelled"])
    
    submitted = st.form_submit_button("Add Order")
    
    if submitted:
        # Insert data into Snowflake
        cursor = conn.cursor()
        try:
            cursor.execute("""
                INSERT INTO orders (customer_id, product_id, order_amount, 
                                  order_date, category, status)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (customer_id, product_id, order_amount, order_date, 
                  category, status))
            conn.commit()
            st.success("Order added successfully!")
        except Exception as e:
            st.error(f"Error adding order: {str(e)}")
        finally:
            cursor.close()
```

### File Upload and Processing

```python
# File upload functionality
st.subheader("📁 Upload Data File")

uploaded_file = st.file_uploader("Choose a CSV file", type="csv")

if uploaded_file is not None:
    # Read uploaded file
    df_upload = pd.read_csv(uploaded_file)
    st.write("Preview of uploaded data:")
    st.dataframe(df_upload.head())
    
    # Process and upload to Snowflake
    if st.button("Upload to Snowflake"):
        try:
            # Create temporary table
            cursor = conn.cursor()
            cursor.execute("""
                CREATE OR REPLACE TEMPORARY TABLE temp_upload AS
                SELECT * FROM VALUES (?, ?, ?, ?, ?, ?)
                AS t(customer_id, product_id, order_amount, order_date, category, status)
            """)
            
            # Insert data
            for _, row in df_upload.iterrows():
                cursor.execute("""
                    INSERT INTO temp_upload VALUES (?, ?, ?, ?, ?, ?)
                """, tuple(row))
            
            # Move to main table
            cursor.execute("""
                INSERT INTO orders 
                SELECT * FROM temp_upload
            """)
            
            conn.commit()
            st.success(f"Successfully uploaded {len(df_upload)} records!")
            
        except Exception as e:
            st.error(f"Upload failed: {str(e)}")
        finally:
            cursor.close()
```

## Advanced Features

### Caching and Performance

```python
# Advanced caching strategies
@st.cache_data(ttl=300)  # Cache for 5 minutes
def get_expensive_data(query):
    return pd.read_sql(query, conn)

@st.cache_resource
def get_connection():
    return snowflake.connector.connect(
        user=st.secrets["snowflake"]["user"],
        password=st.secrets["snowflake"]["password"],
        account=st.secrets["snowflake"]["account"],
        warehouse=st.secrets["snowflake"]["warehouse"],
        database=st.secrets["snowflake"]["database"]
    )

# Progress bars for long operations
def long_running_query():
    progress_bar = st.progress(0)
    status_text = st.empty()
    
    # Simulate long-running query
    for i in range(100):
        progress_bar.progress(i + 1)
        status_text.text(f"Processing... {i+1}%")
        time.sleep(0.01)
    
    status_text.text("Complete!")
    return "Query completed"
```

### Error Handling and Logging

```python
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def safe_query_execution(query, params=None):
    """Execute query with error handling and logging."""
    try:
        cursor = conn.cursor()
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        
        result = cursor.fetchall()
        cursor.close()
        
        logger.info(f"Query executed successfully: {query[:50]}...")
        return result
        
    except Exception as e:
        logger.error(f"Query failed: {str(e)}")
        st.error(f"Database error: {str(e)}")
        return None

# Usage
query = "SELECT * FROM orders WHERE order_date >= ?"
params = [st.date_input("Select date")]
result = safe_query_execution(query, params)

if result:
    st.dataframe(pd.DataFrame(result))
```

## Deployment

### Streamlit Cloud Deployment

```yaml
# .streamlit/secrets.toml
[snowflake]
user = "your_username"
password = "your_password"
account = "your_account"
warehouse = "your_warehouse"
database = "your_database"
schema = "your_schema"

[app]
password = "your_app_password"
```

### Docker Deployment

```dockerfile
# Dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8501

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  streamlit-app:
    build: .
    ports:
      - "8501:8501"
    environment:
      - SNOWFLAKE_USER=${SNOWFLAKE_USER}
      - SNOWFLAKE_PASSWORD=${SNOWFLAKE_PASSWORD}
      - SNOWFLAKE_ACCOUNT=${SNOWFLAKE_ACCOUNT}
    volumes:
      - ./secrets.toml:/app/.streamlit/secrets.toml
```

## Best Practices

### 1. Performance Optimization

- Use `@st.cache_data` for expensive operations
- Implement pagination for large datasets
- Use connection pooling for multiple users
- Optimize SQL queries before displaying

### 2. User Experience

- Provide clear loading indicators
- Implement error handling and user feedback
- Use consistent styling and layout
- Add help text and tooltips

### 3. Security

- Never hardcode credentials
- Use environment variables or secrets
- Implement proper authentication
- Validate all user inputs

### 4. Code Organization

- Separate concerns into different files
- Use functions for reusable components
- Implement proper error handling
- Add logging for debugging

## Troubleshooting

### Common Issues

**Connection Errors**
```python
# Test connection
def test_connection():
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT CURRENT_VERSION()")
        version = cursor.fetchone()[0]
        st.success(f"Connected to Snowflake {version}")
        cursor.close()
        return True
    except Exception as e:
        st.error(f"Connection failed: {str(e)}")
        return False
```

**Memory Issues**
```python
# Clear cache when needed
if st.button("Clear Cache"):
    st.cache_data.clear()
    st.success("Cache cleared!")
```

## Next Steps

- [Universal Search](universal-search.md) - Implementing search functionality
- [Co-Pilot Integration](co-pilot-integration.md) - AI-powered assistance
- [Data Sharing](../collaboration-sharing/data-sharing.md) - Sharing data across organizations

## Resources

- [Streamlit Documentation](https://docs.streamlit.io/)
- [Snowflake Python Connector](https://docs.snowflake.com/en/user-guide/python-connector.html)
- [Streamlit Cloud](https://streamlit.io/cloud)
- [Deployment Guide](https://docs.streamlit.io/streamlit-community-cloud)
