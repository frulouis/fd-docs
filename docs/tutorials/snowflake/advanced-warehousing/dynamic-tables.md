# Snowflake Dynamic Tables

Build real-time data pipelines with Snowflake Dynamic Tables for streaming and batch processing.

## Overview

Dynamic Tables provide:
- Real-time data transformation
- Automatic dependency management
- Incremental processing
- Cost-effective streaming

## Prerequisites

- Snowflake account with Dynamic Tables enabled
- Understanding of data pipelines
- Basic SQL knowledge

## Creating Dynamic Tables

### Basic Dynamic Table

```sql
-- Create a simple dynamic table
CREATE OR REPLACE DYNAMIC TABLE customer_summary
TARGET_LAG = '1 minute'
WAREHOUSE = 'COMPUTE_WH'
AS
SELECT 
    customer_id,
    customer_name,
    COUNT(*) as total_orders,
    SUM(order_amount) as total_spent,
    AVG(order_amount) as avg_order_value,
    MAX(order_date) as last_order_date
FROM orders
GROUP BY customer_id, customer_name;
```

### Advanced Configuration

```sql
-- Dynamic table with advanced settings
CREATE OR REPLACE DYNAMIC TABLE real_time_analytics
TARGET_LAG = '30 seconds'
WAREHOUSE = 'ANALYTICS_WH'
REFRESH_MODE = 'AUTO'
AS
SELECT 
    DATE_TRUNC('hour', order_timestamp) as hour_bucket,
    product_category,
    COUNT(*) as order_count,
    SUM(order_amount) as revenue,
    AVG(order_amount) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
WHERE order_timestamp >= CURRENT_TIMESTAMP() - INTERVAL '24 hours'
GROUP BY 
    DATE_TRUNC('hour', order_timestamp),
    product_category;
```

## Incremental Processing

### Change Data Capture

```sql
-- Track changes using timestamps
CREATE OR REPLACE DYNAMIC TABLE customer_changes
TARGET_LAG = '2 minutes'
WAREHOUSE = 'COMPUTE_WH'
AS
SELECT 
    customer_id,
    customer_name,
    email,
    phone,
    address,
    updated_at,
    'INSERT' as change_type,
    CURRENT_TIMESTAMP() as processed_at
FROM customers
WHERE updated_at >= CURRENT_TIMESTAMP() - INTERVAL '1 hour'

UNION ALL

SELECT 
    customer_id,
    customer_name,
    email,
    phone,
    address,
    updated_at,
    'UPDATE' as change_type,
    CURRENT_TIMESTAMP() as processed_at
FROM customers_history
WHERE updated_at >= CURRENT_TIMESTAMP() - INTERVAL '1 hour';
```

### Delta Processing

```sql
-- Process only new or changed records
CREATE OR REPLACE DYNAMIC TABLE incremental_sales
TARGET_LAG = '5 minutes'
WAREHOUSE = 'COMPUTE_WH'
AS
WITH latest_orders AS (
    SELECT *
    FROM orders
    WHERE order_date >= CURRENT_DATE() - INTERVAL '7 days'
),
existing_sales AS (
    SELECT DISTINCT order_id
    FROM sales_summary
    WHERE processed_date = CURRENT_DATE()
)
SELECT 
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_amount,
    o.order_date,
    CURRENT_TIMESTAMP() as processed_at
FROM latest_orders o
LEFT JOIN existing_sales e ON o.order_id = e.order_id
WHERE e.order_id IS NULL;
```

## Complex Transformations

### Multi-Table Joins

```sql
-- Complex transformation with multiple sources
CREATE OR REPLACE DYNAMIC TABLE customer_360
TARGET_LAG = '10 minutes'
WAREHOUSE = 'ANALYTICS_WH'
AS
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.registration_date,
    
    -- Order metrics
    COALESCE(o.total_orders, 0) as total_orders,
    COALESCE(o.total_spent, 0) as total_spent,
    COALESCE(o.avg_order_value, 0) as avg_order_value,
    COALESCE(o.last_order_date, c.registration_date) as last_order_date,
    
    -- Product preferences
    p.favorite_category,
    p.products_purchased,
    
    -- Support interactions
    COALESCE(s.support_tickets, 0) as support_tickets,
    COALESCE(s.last_support_date, c.registration_date) as last_support_date,
    
    -- Calculated fields
    DATEDIFF('day', c.registration_date, CURRENT_DATE()) as customer_age_days,
    CASE 
        WHEN o.total_spent > 1000 THEN 'VIP'
        WHEN o.total_spent > 500 THEN 'Premium'
        WHEN o.total_spent > 100 THEN 'Standard'
        ELSE 'New'
    END as customer_tier,
    
    CURRENT_TIMESTAMP() as last_updated

FROM customers c
LEFT JOIN (
    SELECT 
        customer_id,
        COUNT(*) as total_orders,
        SUM(order_amount) as total_spent,
        AVG(order_amount) as avg_order_value,
        MAX(order_date) as last_order_date
    FROM orders
    GROUP BY customer_id
) o ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT 
        customer_id,
        MODE(product_category) as favorite_category,
        COUNT(DISTINCT product_id) as products_purchased
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY customer_id
) p ON c.customer_id = p.customer_id
LEFT JOIN (
    SELECT 
        customer_id,
        COUNT(*) as support_tickets,
        MAX(created_date) as last_support_date
    FROM support_tickets
    GROUP BY customer_id
) s ON c.customer_id = s.customer_id;
```

### Aggregation and Windowing

```sql
-- Time-series analysis with window functions
CREATE OR REPLACE DYNAMIC TABLE hourly_metrics
TARGET_LAG = '1 minute'
WAREHOUSE = 'COMPUTE_WH'
AS
SELECT 
    hour_bucket,
    product_category,
    order_count,
    revenue,
    avg_order_value,
    unique_customers,
    
    -- Rolling calculations
    SUM(order_count) OVER (
        PARTITION BY product_category 
        ORDER BY hour_bucket 
        ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
    ) as orders_24h_rolling,
    
    AVG(revenue) OVER (
        PARTITION BY product_category 
        ORDER BY hour_bucket 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as avg_revenue_7h,
    
    -- Growth calculations
    LAG(revenue, 1) OVER (
        PARTITION BY product_category 
        ORDER BY hour_bucket
    ) as prev_hour_revenue,
    
    CASE 
        WHEN LAG(revenue, 1) OVER (PARTITION BY product_category ORDER BY hour_bucket) > 0
        THEN (revenue - LAG(revenue, 1) OVER (PARTITION BY product_category ORDER BY hour_bucket)) 
             / LAG(revenue, 1) OVER (PARTITION BY product_category ORDER BY hour_bucket) * 100
        ELSE NULL
    END as revenue_growth_pct

FROM (
    SELECT 
        DATE_TRUNC('hour', order_timestamp) as hour_bucket,
        product_category,
        COUNT(*) as order_count,
        SUM(order_amount) as revenue,
        AVG(order_amount) as avg_order_value,
        COUNT(DISTINCT customer_id) as unique_customers
    FROM orders
    WHERE order_timestamp >= CURRENT_TIMESTAMP() - INTERVAL '48 hours'
    GROUP BY 
        DATE_TRUNC('hour', order_timestamp),
        product_category
);
```

## Monitoring and Management

### Dynamic Table Status

```sql
-- Monitor dynamic table status
SELECT 
    name,
    target_lag,
    refresh_mode,
    warehouse,
    state,
    last_refresh,
    next_scheduled_refresh,
    refresh_frequency,
    refresh_progress
FROM information_schema.dynamic_tables
WHERE schema_name = 'PUBLIC'
ORDER BY last_refresh DESC;
```

### Performance Monitoring

```sql
-- Monitor refresh performance
SELECT 
    table_name,
    refresh_start_time,
    refresh_end_time,
    DATEDIFF('second', refresh_start_time, refresh_end_time) as refresh_duration_seconds,
    rows_processed,
    bytes_processed,
    CASE 
        WHEN DATEDIFF('second', refresh_start_time, refresh_end_time) > 300 
        THEN 'SLOW'
        WHEN DATEDIFF('second', refresh_start_time, refresh_end_time) > 60 
        THEN 'MEDIUM'
        ELSE 'FAST'
    END as performance_category
FROM snowflake.account_usage.dynamic_table_refresh_history
WHERE refresh_start_time >= CURRENT_TIMESTAMP() - INTERVAL '24 hours'
ORDER BY refresh_start_time DESC;
```

### Cost Analysis

```sql
-- Analyze compute costs
SELECT 
    warehouse_name,
    table_name,
    SUM(credits_used) as total_credits,
    AVG(credits_used) as avg_credits_per_refresh,
    COUNT(*) as refresh_count,
    SUM(credits_used) / COUNT(*) as credits_per_refresh
FROM snowflake.account_usage.dynamic_table_refresh_history
WHERE refresh_start_time >= CURRENT_TIMESTAMP() - INTERVAL '7 days'
GROUP BY warehouse_name, table_name
ORDER BY total_credits DESC;
```

## Best Practices

### 1. Lag Configuration
- Set appropriate TARGET_LAG based on business requirements
- Balance freshness with cost
- Consider data volume and complexity

### 2. Warehouse Selection
- Use appropriate warehouse sizes
- Consider concurrent refresh patterns
- Monitor resource utilization

### 3. Query Optimization
- Optimize source queries for performance
- Use appropriate filters and aggregations
- Minimize data movement

### 4. Dependency Management
- Design clear dependency chains
- Avoid circular dependencies
- Monitor refresh cascades

## Troubleshooting

### Common Issues

```sql
-- Check for refresh failures
SELECT 
    table_name,
    refresh_start_time,
    refresh_end_time,
    error_message,
    error_code
FROM snowflake.account_usage.dynamic_table_refresh_history
WHERE refresh_end_time IS NULL 
   OR error_message IS NOT NULL
ORDER BY refresh_start_time DESC;

-- Identify long-running refreshes
SELECT 
    table_name,
    DATEDIFF('minute', refresh_start_time, COALESCE(refresh_end_time, CURRENT_TIMESTAMP())) as duration_minutes,
    state
FROM snowflake.account_usage.dynamic_table_refresh_history
WHERE refresh_start_time >= CURRENT_TIMESTAMP() - INTERVAL '24 hours'
  AND DATEDIFF('minute', refresh_start_time, COALESCE(refresh_end_time, CURRENT_TIMESTAMP())) > 30
ORDER BY duration_minutes DESC;
```

### Performance Tuning

```sql
-- Analyze query performance
EXPLAIN USING TABULAR
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(order_amount) as total_spent
FROM orders
WHERE order_date >= CURRENT_DATE() - INTERVAL '30 days'
GROUP BY customer_id;

-- Check for data skew
SELECT 
    customer_id,
    COUNT(*) as order_count,
    PERCENT_RANK() OVER (ORDER BY COUNT(*)) as percentile
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 10;
```

## Exercises

### Exercise 1: Real-time Dashboard
Create a dynamic table that provides real-time metrics for a business dashboard.

### Exercise 2: Change Tracking
Build a system to track and process customer data changes in real-time.

### Exercise 3: Performance Optimization
Optimize a slow dynamic table by analyzing and improving its query performance.

## Next Steps

- Learn about [Database Change Management](database-change-management.md)
- Explore [Data Quality Metrics](data-quality-metrics.md)
- Check out [Higher Order Functions](higher-order-functions.md)

## Additional Resources

- [Dynamic Tables Documentation](https://docs.snowflake.com/en/user-guide/dynamic-tables.html)
- [Dynamic Tables Best Practices](https://docs.snowflake.com/en/user-guide/dynamic-tables-best-practices.html)
- [Performance Tuning Guide](https://docs.snowflake.com/en/user-guide/dynamic-tables-performance.html)
