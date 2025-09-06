# Snowflake Data Classification

Learn how to implement comprehensive data classification and governance in Snowflake using built-in classification features and custom policies.

## Overview

This tutorial covers Snowflake's data classification capabilities, including:
- Automatic data classification
- Custom classification policies
- Data governance frameworks
- Privacy and compliance controls
- Classification reporting and monitoring

## Prerequisites

- Snowflake account with appropriate privileges
- Understanding of data governance concepts
- Basic knowledge of SQL and Snowflake security

## Getting Started

### Enable Data Classification

```sql
-- Enable data classification for your account
ALTER ACCOUNT SET DATA_CLASSIFICATION = TRUE;

-- Check current classification status
SHOW PARAMETERS LIKE 'DATA_CLASSIFICATION';
```

### Automatic Classification

```sql
-- Create a table with sensitive data
CREATE OR REPLACE TABLE customer_data (
    customer_id NUMBER,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(20),
    ssn VARCHAR(11),
    credit_score NUMBER,
    annual_income NUMBER
);

-- Insert sample data
INSERT INTO customer_data VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '555-1234', '123-45-6789', 750, 75000),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '555-5678', '987-65-4321', 800, 85000);

-- Run automatic classification
CALL SYSTEM$CLASSIFY('CUSTOMER_DATA');
```

### Custom Classification Policies

```sql
-- Create a custom classification policy
CREATE OR REPLACE CLASSIFICATION POLICY email_policy
AS (
    COLUMN email IS 'PII' LEVEL 'SENSITIVE'
    COLUMN phone IS 'PII' LEVEL 'SENSITIVE'
    COLUMN ssn IS 'PII' LEVEL 'HIGHLY_SENSITIVE'
    COLUMN credit_score IS 'FINANCIAL' LEVEL 'SENSITIVE'
    COLUMN annual_income IS 'FINANCIAL' LEVEL 'SENSITIVE'
);

-- Apply the policy to a table
ALTER TABLE customer_data SET CLASSIFICATION POLICY email_policy;
```

## Classification Levels

### Standard Classification Levels

- **PUBLIC**: Non-sensitive data
- **INTERNAL**: Internal business data
- **CONFIDENTIAL**: Sensitive business data
- **RESTRICTED**: Highly sensitive data

### Data Types

- **PII**: Personally Identifiable Information
- **FINANCIAL**: Financial and payment data
- **HEALTH**: Health and medical information
- **BUSINESS**: Business confidential data

## Advanced Classification

### Conditional Classification

```sql
-- Create conditional classification based on data values
CREATE OR REPLACE CLASSIFICATION POLICY conditional_policy
AS (
    COLUMN email IS 'PII' LEVEL 'SENSITIVE'
    COLUMN phone IS 'PII' LEVEL 'SENSITIVE'
    COLUMN ssn IS 'PII' LEVEL 'HIGHLY_SENSITIVE'
    COLUMN credit_score IS 'FINANCIAL' LEVEL 'SENSITIVE'
    COLUMN annual_income IS 'FINANCIAL' LEVEL 'SENSITIVE'
    WHERE annual_income > 100000 THEN LEVEL 'RESTRICTED'
);
```

### Dynamic Classification

```sql
-- Create a function for dynamic classification
CREATE OR REPLACE FUNCTION classify_sensitivity(income NUMBER)
RETURNS STRING
LANGUAGE SQL
AS $$
    CASE 
        WHEN income > 200000 THEN 'RESTRICTED'
        WHEN income > 100000 THEN 'CONFIDENTIAL'
        WHEN income > 50000 THEN 'INTERNAL'
        ELSE 'PUBLIC'
    END
$$;

-- Apply dynamic classification
CREATE OR REPLACE CLASSIFICATION POLICY dynamic_policy
AS (
    COLUMN annual_income IS 'FINANCIAL' LEVEL classify_sensitivity(annual_income)
);
```

## Monitoring and Reporting

### Classification Reports

```sql
-- View classification summary
SELECT 
    table_name,
    column_name,
    classification_level,
    data_type,
    classification_reason
FROM SNOWFLAKE.ACCOUNT_USAGE.CLASSIFICATION_RESULTS
WHERE table_name = 'CUSTOMER_DATA'
ORDER BY classification_level DESC;

-- Get classification statistics
SELECT 
    classification_level,
    COUNT(*) as column_count,
    COUNT(DISTINCT table_name) as table_count
FROM SNOWFLAKE.ACCOUNT_USAGE.CLASSIFICATION_RESULTS
GROUP BY classification_level
ORDER BY column_count DESC;
```

### Compliance Monitoring

```sql
-- Monitor access to sensitive data
SELECT 
    query_id,
    user_name,
    query_text,
    start_time,
    end_time
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE '%customer_data%'
AND start_time >= DATEADD(day, -7, CURRENT_TIMESTAMP())
ORDER BY start_time DESC;
```

## Best Practices

### 1. Consistent Classification

- Use standardized classification levels across your organization
- Document classification rationale and business rules
- Regular review and updates of classification policies

### 2. Automated Classification

- Leverage automatic classification for common data types
- Create custom policies for business-specific requirements
- Implement continuous monitoring and validation

### 3. Access Controls

- Align access controls with classification levels
- Implement role-based access based on data sensitivity
- Regular access reviews and audits

### 4. Compliance Integration

- Map classification levels to regulatory requirements
- Implement data retention policies based on classification
- Maintain audit trails for compliance reporting

## Troubleshooting

### Common Issues

**Classification Not Applied**
```sql
-- Check if classification is enabled
SHOW PARAMETERS LIKE 'DATA_CLASSIFICATION';

-- Verify policy is applied
SHOW TABLES LIKE 'CUSTOMER_DATA';
```

**Performance Impact**
```sql
-- Monitor query performance after classification
SELECT 
    query_id,
    execution_time,
    bytes_scanned,
    rows_produced
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE '%customer_data%'
ORDER BY execution_time DESC;
```

## Next Steps

- [Fuzzy Matching](fuzzy-matching.md) - Advanced data matching techniques
- [ASOF JOIN](asof-join.md) - Time-based joins for data warehousing
- [Data Quality Metrics](../common-models/data-quality-metrics.md) - Comprehensive data quality monitoring

## Resources

- [Snowflake Data Classification Documentation](https://docs.snowflake.com/en/user-guide/classification.html)
- [Data Governance Best Practices](https://docs.snowflake.com/en/user-guide/governance.html)
- [Compliance and Security](https://docs.snowflake.com/en/user-guide/security.html)
