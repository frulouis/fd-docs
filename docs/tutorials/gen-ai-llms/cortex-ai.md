# Snowflake Cortex AI

Leverage Snowflake's built-in AI capabilities with Cortex AI for machine learning, natural language processing, and advanced analytics.

## Overview

Snowflake Cortex AI provides:
- Pre-trained AI models for common use cases
- Natural language processing capabilities
- Time series forecasting
- Anomaly detection
- Document AI and text extraction
- Vector search and embeddings

## Prerequisites

- Snowflake account with Cortex AI enabled
- Understanding of AI/ML concepts
- Basic knowledge of SQL and Snowflake functions

## Getting Started

### Enable Cortex AI

```sql
-- Check if Cortex AI is enabled
SHOW PARAMETERS LIKE 'ENABLE_CORTEX';

-- Enable Cortex AI (requires account admin privileges)
ALTER ACCOUNT SET ENABLE_CORTEX = TRUE;

-- Verify Cortex AI functions are available
SHOW FUNCTIONS LIKE '%CORTEX%';
```

### Basic Cortex AI Functions

```sql
-- List available Cortex AI functions
SELECT FUNCTION_NAME, FUNCTION_DESCRIPTION
FROM SNOWFLAKE.INFORMATION_SCHEMA.FUNCTIONS
WHERE FUNCTION_NAME LIKE '%CORTEX%'
ORDER BY FUNCTION_NAME;
```

## Natural Language Processing

### Text Analysis

```sql
-- Sentiment analysis
SELECT 
    review_text,
    SNOWFLAKE.CORTEX.SENTIMENT(review_text) as sentiment_score,
    SNOWFLAKE.CORTEX.SENTIMENT(review_text, 'en') as sentiment_english
FROM product_reviews
LIMIT 10;

-- Text summarization
SELECT 
    article_text,
    SNOWFLAKE.CORTEX.SUMMARIZE(article_text, 'en') as summary
FROM news_articles
WHERE LENGTH(article_text) > 1000
LIMIT 5;

-- Text translation
SELECT 
    original_text,
    SNOWFLAKE.CORTEX.TRANSLATE(original_text, 'en', 'es') as spanish_text,
    SNOWFLAKE.CORTEX.TRANSLATE(original_text, 'en', 'fr') as french_text
FROM multilingual_content
LIMIT 10;
```

### Text Classification

```sql
-- Classify text into categories
SELECT 
    email_subject,
    email_body,
    SNOWFLAKE.CORTEX.CLASSIFY(email_subject || ' ' || email_body, 'en') as classification
FROM customer_emails
WHERE email_body IS NOT NULL
LIMIT 20;

-- Custom classification with examples
SELECT 
    support_ticket,
    SNOWFLAKE.CORTEX.CLASSIFY(
        support_ticket, 
        'en',
        'urgent, billing, technical, general'
    ) as ticket_category
FROM support_tickets
LIMIT 15;
```

## Time Series Forecasting

### Basic Forecasting

```sql
-- Create a time series forecast
SELECT 
    date_col,
    value_col,
    SNOWFLAKE.CORTEX.FORECAST(
        value_col, 
        date_col, 
        30  -- forecast 30 periods ahead
    ) as forecast_value
FROM sales_data
WHERE date_col >= DATEADD(month, -12, CURRENT_DATE())
ORDER BY date_col;

-- Advanced forecasting with seasonality
SELECT 
    date_col,
    sales_amount,
    SNOWFLAKE.CORTEX.FORECAST(
        sales_amount,
        date_col,
        90,  -- forecast 90 days
        'seasonal'  -- enable seasonality detection
    ) as seasonal_forecast
FROM daily_sales
WHERE date_col >= DATEADD(year, -2, CURRENT_DATE())
ORDER BY date_col;
```

### Anomaly Detection

```sql
-- Detect anomalies in time series data
SELECT 
    timestamp_col,
    metric_value,
    SNOWFLAKE.CORTEX.ANOMALY_DETECTION(metric_value, timestamp_col) as is_anomaly,
    SNOWFLAKE.CORTEX.ANOMALY_DETECTION(metric_value, timestamp_col, 0.05) as anomaly_score
FROM system_metrics
WHERE timestamp_col >= DATEADD(day, -30, CURRENT_TIMESTAMP())
ORDER BY timestamp_col;

-- Batch anomaly detection
SELECT 
    customer_id,
    transaction_amount,
    transaction_date,
    SNOWFLAKE.CORTEX.ANOMALY_DETECTION(
        transaction_amount, 
        transaction_date,
        0.1  -- sensitivity threshold
    ) as is_fraudulent
FROM transactions
WHERE transaction_date >= DATEADD(month, -6, CURRENT_DATE())
ORDER BY transaction_date DESC;
```

## Document AI

### Text Extraction

```sql
-- Extract text from documents
SELECT 
    document_id,
    document_url,
    SNOWFLAKE.CORTEX.EXTRACT_TEXT(document_url) as extracted_text
FROM document_storage
WHERE document_type = 'PDF'
LIMIT 10;

-- Extract structured data from documents
SELECT 
    invoice_id,
    invoice_url,
    SNOWFLAKE.CORTEX.EXTRACT_STRUCTURED_DATA(
        invoice_url,
        'invoice'  -- document type
    ) as invoice_data
FROM invoice_documents
WHERE invoice_date >= DATEADD(month, -3, CURRENT_DATE())
LIMIT 5;
```

### Document Classification

```sql
-- Classify document types
SELECT 
    document_name,
    document_url,
    SNOWFLAKE.CORTEX.CLASSIFY_DOCUMENT(document_url) as document_type
FROM document_storage
WHERE document_url IS NOT NULL
LIMIT 20;

-- Extract key information from contracts
SELECT 
    contract_id,
    contract_url,
    SNOWFLAKE.CORTEX.EXTRACT_STRUCTURED_DATA(
        contract_url,
        'contract'
    ) as contract_terms
FROM legal_documents
WHERE contract_type = 'SERVICE_AGREEMENT'
LIMIT 10;
```

## Vector Search and Embeddings

### Generate Embeddings

```sql
-- Generate embeddings for text data
SELECT 
    product_id,
    product_description,
    SNOWFLAKE.CORTEX.EMBED_TEXT(product_description, 'en') as embedding
FROM product_catalog
WHERE product_description IS NOT NULL
LIMIT 100;

-- Generate embeddings for multiple languages
SELECT 
    content_id,
    content_text,
    language_code,
    SNOWFLAKE.CORTEX.EMBED_TEXT(content_text, language_code) as embedding
FROM multilingual_content
WHERE content_text IS NOT NULL
LIMIT 50;
```

### Vector Similarity Search

```sql
-- Create a vector table for similarity search
CREATE OR REPLACE TABLE product_embeddings AS
SELECT 
    product_id,
    product_name,
    product_description,
    SNOWFLAKE.CORTEX.EMBED_TEXT(product_description, 'en') as embedding
FROM product_catalog
WHERE product_description IS NOT NULL;

-- Find similar products
SELECT 
    p1.product_name as query_product,
    p2.product_name as similar_product,
    SNOWFLAKE.CORTEX.VECTOR_SIMILARITY(
        p1.embedding, 
        p2.embedding
    ) as similarity_score
FROM product_embeddings p1
CROSS JOIN product_embeddings p2
WHERE p1.product_id != p2.product_id
AND SNOWFLAKE.CORTEX.VECTOR_SIMILARITY(p1.embedding, p2.embedding) > 0.8
ORDER BY similarity_score DESC
LIMIT 10;
```

## Advanced Use Cases

### Customer Support Automation

```sql
-- Automatically categorize support tickets
CREATE OR REPLACE VIEW categorized_tickets AS
SELECT 
    ticket_id,
    customer_id,
    ticket_subject,
    ticket_description,
    SNOWFLAKE.CORTEX.CLASSIFY(
        ticket_subject || ' ' || ticket_description,
        'en',
        'technical, billing, account, general'
    ) as category,
    SNOWFLAKE.CORTEX.SENTIMENT(ticket_description) as sentiment_score
FROM support_tickets
WHERE ticket_status = 'OPEN';

-- Route tickets based on classification and sentiment
SELECT 
    ticket_id,
    category,
    sentiment_score,
    CASE 
        WHEN sentiment_score < -0.5 AND category = 'billing' THEN 'URGENT_BILLING'
        WHEN sentiment_score < -0.3 THEN 'HIGH_PRIORITY'
        WHEN category = 'technical' THEN 'TECHNICAL_TEAM'
        ELSE 'GENERAL_SUPPORT'
    END as routing_decision
FROM categorized_tickets;
```

### Content Recommendation

```sql
-- Generate content recommendations
CREATE OR REPLACE VIEW content_recommendations AS
SELECT 
    user_id,
    content_id,
    content_title,
    SNOWFLAKE.CORTEX.VECTOR_SIMILARITY(
        user_embedding,
        content_embedding
    ) as relevance_score
FROM user_preferences u
CROSS JOIN content_embeddings c
WHERE SNOWFLAKE.CORTEX.VECTOR_SIMILARITY(u.user_embedding, c.content_embedding) > 0.7
ORDER BY user_id, relevance_score DESC;

-- Get top recommendations per user
SELECT 
    user_id,
    LISTAGG(content_title, ', ') WITHIN GROUP (ORDER BY relevance_score DESC) as top_recommendations
FROM content_recommendations
GROUP BY user_id
LIMIT 10;
```

## Performance Optimization

### Batch Processing

```sql
-- Process large datasets in batches
CREATE OR REPLACE PROCEDURE process_embeddings_batch()
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    batch_size INTEGER DEFAULT 1000;
    processed_count INTEGER DEFAULT 0;
    total_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM raw_content WHERE embedding IS NULL;
    
    WHILE processed_count < total_count DO
        INSERT INTO content_embeddings (content_id, content_text, embedding)
        SELECT 
            content_id,
            content_text,
            SNOWFLAKE.CORTEX.EMBED_TEXT(content_text, 'en')
        FROM raw_content
        WHERE embedding IS NULL
        LIMIT batch_size;
        
        processed_count := processed_count + batch_size;
    END WHILE;
    
    RETURN 'Processed ' || processed_count || ' records';
END;
$$;
```

### Caching Strategies

```sql
-- Create a cache table for frequently used embeddings
CREATE OR REPLACE TABLE embedding_cache (
    text_hash VARCHAR(64),
    embedding VARIANT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Use cached embeddings when available
CREATE OR REPLACE FUNCTION get_embedding(text_input STRING)
RETURNS VARIANT
LANGUAGE SQL
AS $$
    DECLARE
        text_hash VARCHAR(64) := SHA2(text_input);
        cached_embedding VARIANT;
    BEGIN
        SELECT embedding INTO cached_embedding
        FROM embedding_cache
        WHERE text_hash = text_hash
        AND created_at > DATEADD(hour, -24, CURRENT_TIMESTAMP());
        
        IF cached_embedding IS NOT NULL THEN
            RETURN cached_embedding;
        ELSE
            cached_embedding := SNOWFLAKE.CORTEX.EMBED_TEXT(text_input, 'en');
            INSERT INTO embedding_cache (text_hash, embedding) 
            VALUES (text_hash, cached_embedding);
            RETURN cached_embedding;
        END IF;
    END;
$$;
```

## Monitoring and Costs

### Usage Monitoring

```sql
-- Monitor Cortex AI usage
SELECT 
    function_name,
    COUNT(*) as call_count,
    SUM(credits_used) as total_credits,
    AVG(credits_used) as avg_credits_per_call
FROM SNOWFLAKE.ACCOUNT_USAGE.FUNCTION_USAGE_HISTORY
WHERE function_name LIKE '%CORTEX%'
AND start_time >= DATEADD(day, -7, CURRENT_TIMESTAMP())
GROUP BY function_name
ORDER BY total_credits DESC;

-- Monitor costs by user
SELECT 
    user_name,
    function_name,
    COUNT(*) as calls,
    SUM(credits_used) as credits_used
FROM SNOWFLAKE.ACCOUNT_USAGE.FUNCTION_USAGE_HISTORY
WHERE function_name LIKE '%CORTEX%'
AND start_time >= DATEADD(day, -30, CURRENT_TIMESTAMP())
GROUP BY user_name, function_name
ORDER BY credits_used DESC;
```

## Best Practices

### 1. Cost Management

- Use caching for frequently accessed embeddings
- Batch process large datasets
- Monitor usage and costs regularly
- Implement cost controls and limits

### 2. Performance Optimization

- Use appropriate batch sizes for processing
- Implement retry logic for failed calls
- Cache results when possible
- Monitor query performance

### 3. Data Quality

- Validate input data before processing
- Handle errors gracefully
- Implement data quality checks
- Regular testing and validation

## Troubleshooting

### Common Issues

**Function Not Found**
```sql
-- Check if Cortex AI is enabled
SHOW PARAMETERS LIKE 'ENABLE_CORTEX';

-- Verify function availability
SHOW FUNCTIONS LIKE '%CORTEX%';
```

**Rate Limiting**
```sql
-- Implement retry logic with exponential backoff
CREATE OR REPLACE PROCEDURE safe_cortex_call(text_input STRING)
RETURNS VARIANT
LANGUAGE SQL
AS $$
DECLARE
    result VARIANT;
    retry_count INTEGER DEFAULT 0;
    max_retries INTEGER DEFAULT 3;
BEGIN
    WHILE retry_count < max_retries DO
        BEGIN
            result := SNOWFLAKE.CORTEX.EMBED_TEXT(text_input, 'en');
            RETURN result;
        EXCEPTION
            WHEN OTHER THEN
                retry_count := retry_count + 1;
                IF retry_count < max_retries THEN
                    SYSTEM$WAIT(retry_count * 2);  -- Exponential backoff
                END IF;
        END;
    END WHILE;
    RETURN NULL;
END;
$$;
```

## Next Steps

- [Embeddings & Vector Search](embeddings-vector-search.md) - Advanced vector search techniques
- [Document AI](document-ai.md) - Document processing and extraction
- [Snowpark ML](../classic-ai-ml/snowpark-ml.md) - Custom machine learning models

## Resources

- [Snowflake Cortex AI Documentation](https://docs.snowflake.com/en/user-guide/cortex.html)
- [AI/ML Functions Reference](https://docs.snowflake.com/en/sql-reference/functions/cortex.html)
- [Cortex AI Best Practices](https://docs.snowflake.com/en/user-guide/cortex-best-practices.html)
