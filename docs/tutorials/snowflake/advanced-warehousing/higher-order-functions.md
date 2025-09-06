# Snowflake Higher Order Functions (HoF)

Master Snowflake's powerful higher-order functions for advanced data transformations and array processing.

## Overview

Higher-order functions in Snowflake allow you to:
- Transform arrays and objects
- Apply functions to collections
- Perform complex data manipulations
- Optimize query performance

## Prerequisites

- Snowflake account with appropriate privileges
- Intermediate SQL knowledge
- Understanding of arrays and objects in SQL

## Array Functions

### ARRAY_AGG and ARRAY_CONSTRUCT

```sql
-- Basic array creation and aggregation
SELECT 
    customer_id,
    ARRAY_AGG(order_id) as order_ids,
    ARRAY_CONSTRUCT('pending', 'shipped', 'delivered') as status_options
FROM orders
GROUP BY customer_id;

-- Array with conditional elements
SELECT 
    customer_id,
    ARRAY_CONSTRUCT_COMPACT(
        CASE WHEN total_orders > 10 THEN 'high_value' END,
        CASE WHEN last_order_date > DATEADD('day', -30, CURRENT_DATE()) THEN 'recent' END,
        CASE WHEN avg_order_value > 100 THEN 'premium' END
    ) as customer_tags
FROM customer_summary;
```

### ARRAY_SIZE and ARRAY_LENGTH

```sql
-- Array size operations
SELECT 
    customer_id,
    order_ids,
    ARRAY_SIZE(order_ids) as order_count,
    ARRAY_LENGTH(order_ids) as array_length
FROM customer_orders;

-- Filter arrays by size
SELECT *
FROM customer_orders
WHERE ARRAY_SIZE(order_ids) > 5;
```

## Transform Functions

### ARRAY_TRANSFORM

```sql
-- Transform array elements
SELECT 
    customer_id,
    order_amounts,
    ARRAY_TRANSFORM(order_amounts, x -> x * 1.1) as amounts_with_tax,
    ARRAY_TRANSFORM(order_amounts, x -> CASE WHEN x > 100 THEN 'high' ELSE 'low' END) as amount_categories
FROM customer_orders;

-- Complex transformations
SELECT 
    product_ids,
    ARRAY_TRANSFORM(product_ids, 
        id -> (SELECT product_name FROM products WHERE product_id = id)
    ) as product_names
FROM order_items;
```

### ARRAY_FILTER

```sql
-- Filter array elements
SELECT 
    customer_id,
    order_amounts,
    ARRAY_FILTER(order_amounts, x -> x > 50) as high_value_orders,
    ARRAY_FILTER(order_amounts, x -> x BETWEEN 20 AND 100) as medium_value_orders
FROM customer_orders;

-- Filter with complex conditions
SELECT 
    customer_id,
    order_dates,
    ARRAY_FILTER(order_dates, 
        date -> DATEDIFF('day', date, CURRENT_DATE()) <= 30
    ) as recent_orders
FROM customer_orders;
```

## Reduce Functions

### ARRAY_REDUCE

```sql
-- Reduce array to single value
SELECT 
    customer_id,
    order_amounts,
    ARRAY_REDUCE(order_amounts, 0, (acc, x) -> acc + x) as total_amount,
    ARRAY_REDUCE(order_amounts, 0, (acc, x) -> GREATEST(acc, x)) as max_amount,
    ARRAY_REDUCE(order_amounts, 999999, (acc, x) -> LEAST(acc, x)) as min_amount
FROM customer_orders;

-- Custom reduction logic
SELECT 
    customer_id,
    order_amounts,
    ARRAY_REDUCE(order_amounts, 0, 
        (acc, x) -> CASE 
            WHEN x > 100 THEN acc + x * 0.1  -- 10% bonus for high value
            ELSE acc + x * 0.05              -- 5% for regular orders
        END
    ) as bonus_points
FROM customer_orders;
```

## Object Functions

### OBJECT_CONSTRUCT and OBJECT_INSERT

```sql
-- Create and manipulate objects
SELECT 
    customer_id,
    OBJECT_CONSTRUCT(
        'name', customer_name,
        'email', email,
        'total_orders', order_count,
        'avg_order_value', avg_order_value
    ) as customer_profile
FROM customer_summary;

-- Insert into objects
SELECT 
    customer_id,
    OBJECT_INSERT(
        OBJECT_CONSTRUCT('name', customer_name),
        'loyalty_tier', 
        CASE 
            WHEN total_orders > 50 THEN 'platinum'
            WHEN total_orders > 20 THEN 'gold'
            WHEN total_orders > 5 THEN 'silver'
            ELSE 'bronze'
        END
    ) as enhanced_profile
FROM customer_summary;
```

### OBJECT_KEYS and OBJECT_VALUES

```sql
-- Extract keys and values from objects
SELECT 
    customer_profile,
    OBJECT_KEYS(customer_profile) as profile_keys,
    OBJECT_VALUES(customer_profile) as profile_values
FROM customer_profiles;

-- Work with object arrays
SELECT 
    customer_id,
    ARRAY_TRANSFORM(
        OBJECT_KEYS(customer_profile),
        key -> OBJECT_GET(customer_profile, key)
    ) as all_values
FROM customer_profiles;
```

## Advanced Patterns

### Nested Array Operations

```sql
-- Process nested arrays
WITH nested_data AS (
    SELECT 
        customer_id,
        ARRAY_CONSTRUCT(
            ARRAY_CONSTRUCT('order1', 'order2'),
            ARRAY_CONSTRUCT('order3', 'order4', 'order5')
        ) as order_groups
    FROM sample_data
)
SELECT 
    customer_id,
    ARRAY_TRANSFORM(
        order_groups,
        group -> ARRAY_SIZE(group)
    ) as group_sizes,
    ARRAY_REDUCE(
        ARRAY_TRANSFORM(
            order_groups,
            group -> ARRAY_SIZE(group)
        ),
        0,
        (acc, size) -> acc + size
    ) as total_orders
FROM nested_data;
```

### Conditional Array Building

```sql
-- Build arrays conditionally
SELECT 
    customer_id,
    ARRAY_CONSTRUCT_COMPACT(
        CASE WHEN is_premium THEN 'premium' END,
        CASE WHEN has_recent_orders THEN 'active' END,
        CASE WHEN total_spent > 1000 THEN 'high_value' END,
        CASE WHEN referral_count > 5 THEN 'influencer' END
    ) as customer_segments
FROM customer_analysis;
```

## Performance Optimization

### Efficient Array Processing

```sql
-- Use ARRAY_SIZE for early filtering
SELECT *
FROM large_table
WHERE ARRAY_SIZE(important_array) > 0;

-- Pre-filter before transformations
SELECT 
    customer_id,
    ARRAY_TRANSFORM(
        ARRAY_FILTER(order_amounts, x -> x > 0),
        x -> x * 1.1
    ) as valid_amounts_with_tax
FROM customer_orders;
```

### Memory-Efficient Patterns

```sql
-- Process arrays in chunks for large datasets
CREATE OR REPLACE PROCEDURE process_large_arrays()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    chunk_size INTEGER := 1000;
    total_processed INTEGER := 0;
BEGIN
    -- Process in batches to avoid memory issues
    FOR record IN (
        SELECT customer_id, large_array
        FROM large_customer_data
        WHERE ARRAY_SIZE(large_array) > 0
    ) DO
        -- Process chunk
        total_processed := total_processed + ARRAY_SIZE(record.large_array);
        
        -- Break if memory limit reached
        IF (total_processed > 10000) THEN
            BREAK;
        END IF;
    END FOR;
    
    RETURN 'Processed ' || total_processed || ' array elements';
END;
$$;
```

## Real-World Examples

### Customer Segmentation

```sql
-- Advanced customer segmentation using HoF
CREATE OR REPLACE VIEW customer_segments AS
SELECT 
    customer_id,
    customer_name,
    ARRAY_CONSTRUCT_COMPACT(
        CASE WHEN total_orders > 50 THEN 'high_frequency' END,
        CASE WHEN avg_order_value > 200 THEN 'high_value' END,
        CASE WHEN DATEDIFF('day', last_order_date, CURRENT_DATE()) <= 30 THEN 'recent' END,
        CASE WHEN referral_count > 10 THEN 'influencer' END
    ) as segments,
    ARRAY_REDUCE(
        ARRAY_CONSTRUCT(total_orders, avg_order_value, referral_count),
        0,
        (acc, val) -> acc + val
    ) as composite_score
FROM customer_summary;
```

### Product Recommendation Engine

```sql
-- Build product recommendations using array functions
CREATE OR REPLACE VIEW product_recommendations AS
SELECT 
    customer_id,
    ARRAY_TRANSFORM(
        ARRAY_FILTER(
            ARRAY_AGG(DISTINCT product_id),
            product_id -> product_id NOT IN (
                SELECT product_id 
                FROM customer_orders 
                WHERE customer_id = customer_orders.customer_id
            )
        ),
        product_id -> (
            SELECT product_name 
            FROM products 
            WHERE products.product_id = product_id
        )
    ) as recommended_products
FROM order_items
GROUP BY customer_id;
```

## Best Practices

### 1. Use ARRAY_CONSTRUCT_COMPACT
- Automatically removes NULL values
- Reduces array size
- Improves performance

### 2. Filter Before Transform
- Reduce data volume early
- Improve transformation performance
- Minimize memory usage

### 3. Leverage Type Safety
- Use proper data types
- Validate array contents
- Handle edge cases

## Exercises

### Exercise 1: Array Statistics
Create a function that calculates mean, median, and standard deviation for an array of numbers.

### Exercise 2: Object Transformation
Build a function that transforms a customer object by adding calculated fields.

### Exercise 3: Nested Processing
Process a nested array structure to find the maximum value in each sub-array.

## Next Steps

- Learn about [Data Classification and Tagging](data-classification.md)
- Explore [ASOF JOIN techniques](asof-join.md)
- Check out [Fuzzy Matching methods](fuzzy-matching.md)

## Additional Resources

- [Snowflake Array Functions Documentation](https://docs.snowflake.com/en/sql-reference/functions-array.html)
- [Higher-Order Functions Guide](https://docs.snowflake.com/en/sql-reference/functions-hof.html)
- [Performance Tuning for Arrays](https://docs.snowflake.com/en/user-guide/performance-tuning-arrays.html)
