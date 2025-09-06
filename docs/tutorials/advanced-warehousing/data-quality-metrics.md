# Snowflake Data Quality Metrics & Functions

Learn how to implement comprehensive data quality monitoring in Snowflake using built-in metrics and custom functions.

## Overview

This tutorial covers Snowflake's data quality capabilities, including:
- Built-in data quality metrics
- Custom quality functions
- Data profiling techniques
- Automated quality monitoring
- Quality score calculations

## Prerequisites

- Snowflake account with appropriate privileges
- Basic SQL knowledge
- Understanding of data quality concepts

## Data Quality Metrics

### Built-in Metrics

Snowflake provides several built-in data quality metrics:

```sql
-- Row count validation
SELECT COUNT(*) as row_count 
FROM your_table;

-- Null value percentage
SELECT 
    column_name,
    COUNT(*) as total_rows,
    COUNT(column_name) as non_null_rows,
    (COUNT(*) - COUNT(column_name)) / COUNT(*) * 100 as null_percentage
FROM your_table
GROUP BY column_name;

-- Duplicate detection
SELECT 
    column1, column2, column3,
    COUNT(*) as duplicate_count
FROM your_table
GROUP BY column1, column2, column3
HAVING COUNT(*) > 1;
```

### Custom Quality Functions

Create reusable data quality functions:

```sql
-- Function to check data freshness
CREATE OR REPLACE FUNCTION check_data_freshness(
    table_name STRING,
    timestamp_column STRING,
    max_hours_old INTEGER
)
RETURNS BOOLEAN
AS
$$
    SELECT DATEDIFF('hour', MAX($timestamp_column), CURRENT_TIMESTAMP()) <= $max_hours_old
    FROM IDENTIFIER($table_name)
$$;

-- Function to validate email format
CREATE OR REPLACE FUNCTION is_valid_email(email STRING)
RETURNS BOOLEAN
AS
$$
    SELECT REGEXP_LIKE($email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
$$;

-- Function to check data completeness
CREATE OR REPLACE FUNCTION check_completeness(
    table_name STRING,
    required_columns ARRAY
)
RETURNS FLOAT
AS
$$
    SELECT 
        (SELECT COUNT(*) FROM IDENTIFIER($table_name) WHERE 
            ARRAY_CONSTRUCT_COMPACT(
                CASE WHEN $required_columns[0] IS NOT NULL THEN 1 ELSE 0 END,
                CASE WHEN $required_columns[1] IS NOT NULL THEN 1 ELSE 0 END,
                CASE WHEN $required_columns[2] IS NOT NULL THEN 1 ELSE 0 END
            )[0] = 1
        ) / COUNT(*) * 100
    FROM IDENTIFIER($table_name)
$$;
```

## Data Profiling

### Statistical Analysis

```sql
-- Comprehensive data profiling
CREATE OR REPLACE PROCEDURE profile_table(
    table_name STRING,
    sample_size INTEGER DEFAULT 10000
)
RETURNS TABLE (
    column_name STRING,
    data_type STRING,
    total_rows BIGINT,
    null_count BIGINT,
    null_percentage FLOAT,
    unique_count BIGINT,
    unique_percentage FLOAT,
    min_value STRING,
    max_value STRING,
    avg_length FLOAT
)
LANGUAGE SQL
AS
$$
DECLARE
    sql_stmt STRING;
BEGIN
    -- Get column information
    LET c1 CURSOR FOR 
        SELECT COLUMN_NAME, DATA_TYPE 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = UPPER(table_name);
    
    -- For each column, calculate statistics
    FOR record IN c1 DO
        sql_stmt := 'SELECT 
            ''' || record.COLUMN_NAME || ''' as column_name,
            ''' || record.DATA_TYPE || ''' as data_type,
            COUNT(*) as total_rows,
            COUNT(' || record.COLUMN_NAME || ') as non_null_count,
            (COUNT(*) - COUNT(' || record.COLUMN_NAME || ')) / COUNT(*) * 100 as null_percentage,
            COUNT(DISTINCT ' || record.COLUMN_NAME || ') as unique_count,
            COUNT(DISTINCT ' || record.COLUMN_NAME || ') / COUNT(*) * 100 as unique_percentage,
            MIN(' || record.COLUMN_NAME || ') as min_value,
            MAX(' || record.COLUMN_NAME || ') as max_value,
            AVG(LENGTH(' || record.COLUMN_NAME || ')) as avg_length
        FROM ' || table_name || ' SAMPLE ' || sample_size;
        
        RETURN TABLE(EXECUTE_IMMEDIATE(sql_stmt));
    END FOR;
END;
$$;
```

## Quality Score Calculation

### Comprehensive Quality Assessment

```sql
-- Create a data quality scoring system
CREATE OR REPLACE FUNCTION calculate_quality_score(
    table_name STRING,
    quality_checks ARRAY
)
RETURNS FLOAT
AS
$$
DECLARE
    total_score FLOAT := 0;
    check_weight FLOAT;
    check_result FLOAT;
    i INTEGER;
BEGIN
    -- Initialize scoring
    total_score := 0;
    
    -- Check completeness (30% weight)
    check_weight := 0.3;
    check_result := (SELECT 
        COUNT(*) - COUNT(CASE WHEN column1 IS NULL OR column2 IS NULL THEN 1 END) / COUNT(*) * 100
        FROM IDENTIFIER(table_name)
    );
    total_score := total_score + (check_result * check_weight);
    
    -- Check validity (25% weight)
    check_weight := 0.25;
    check_result := (SELECT 
        COUNT(CASE WHEN is_valid_email(email) THEN 1 END) / COUNT(*) * 100
        FROM IDENTIFIER(table_name)
    );
    total_score := total_score + (check_result * check_weight);
    
    -- Check consistency (25% weight)
    check_weight := 0.25;
    check_result := (SELECT 
        COUNT(DISTINCT country) / COUNT(*) * 100
        FROM IDENTIFIER(table_name)
    );
    total_score := total_score + (check_result * check_weight);
    
    -- Check timeliness (20% weight)
    check_weight := 0.2;
    check_result := (SELECT 
        CASE WHEN DATEDIFF('hour', MAX(updated_at), CURRENT_TIMESTAMP()) <= 24 
             THEN 100 ELSE 0 END
        FROM IDENTIFIER(table_name)
    );
    total_score := total_score + (check_result * check_weight);
    
    RETURN total_score;
END;
$$;
```

## Automated Quality Monitoring

### Quality Dashboard

```sql
-- Create a data quality monitoring dashboard
CREATE OR REPLACE VIEW data_quality_dashboard AS
SELECT 
    'customer_data' as table_name,
    calculate_quality_score('customer_data', ARRAY_CONSTRUCT('completeness', 'validity', 'consistency')) as quality_score,
    check_data_freshness('customer_data', 'updated_at', 24) as is_fresh,
    (SELECT COUNT(*) FROM customer_data WHERE is_valid_email(email) = FALSE) as invalid_emails,
    (SELECT COUNT(*) FROM customer_data WHERE phone IS NULL) as missing_phones,
    CURRENT_TIMESTAMP() as last_checked
UNION ALL
SELECT 
    'order_data' as table_name,
    calculate_quality_score('order_data', ARRAY_CONSTRUCT('completeness', 'validity', 'consistency')) as quality_score,
    check_data_freshness('order_data', 'created_at', 1) as is_fresh,
    (SELECT COUNT(*) FROM order_data WHERE amount < 0) as negative_amounts,
    (SELECT COUNT(*) FROM order_data WHERE customer_id IS NULL) as missing_customers,
    CURRENT_TIMESTAMP() as last_checked;
```

### Quality Alerts

```sql
-- Set up quality alerts
CREATE OR REPLACE PROCEDURE check_quality_alerts()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    alert_message STRING := '';
    quality_score FLOAT;
    table_name STRING;
BEGIN
    -- Check each table's quality score
    FOR record IN (SELECT table_name, quality_score FROM data_quality_dashboard) DO
        IF (record.quality_score < 80) THEN
            alert_message := alert_message || 'ALERT: ' || record.table_name || 
                           ' quality score is ' || record.quality_score || '% (below 80% threshold)\n';
        END IF;
    END FOR;
    
    -- Send alert if any issues found
    IF (alert_message != '') THEN
        -- In a real implementation, you would send an email or notification here
        RETURN 'Quality alerts triggered:\n' || alert_message;
    ELSE
        RETURN 'All tables meet quality standards';
    END IF;
END;
$$;
```

## Best Practices

### 1. Regular Quality Checks
- Schedule daily quality assessments
- Monitor key metrics continuously
- Set up automated alerts for quality degradation

### 2. Data Lineage Tracking
- Track data transformations
- Monitor quality impact of changes
- Maintain quality metadata

### 3. Quality Gates
- Implement quality checks in data pipelines
- Block low-quality data from production
- Require quality approval for critical datasets

## Exercises

### Exercise 1: Basic Quality Metrics
Create a quality assessment for a sample table that checks:
- Completeness (non-null values)
- Uniqueness (duplicate detection)
- Validity (format checking)

### Exercise 2: Custom Quality Function
Build a function that validates phone number formats and returns a quality score.

### Exercise 3: Quality Dashboard
Create a comprehensive dashboard that shows quality metrics for multiple tables.

## Next Steps

- Learn about [Snowflake Higher Order Functions](higher-order-functions.md)
- Explore [Data Classification and Tagging](data-classification.md)
- Check out [Fuzzy Matching techniques](fuzzy-matching.md)

## Additional Resources

- [Snowflake Data Quality Documentation](https://docs.snowflake.com/en/user-guide/data-quality.html)
- [Data Quality Best Practices](https://docs.snowflake.com/en/user-guide/data-quality-best-practices.html)
- [Quality Metrics Reference](https://docs.snowflake.com/en/sql-reference/data-quality-functions.html)
