# Snowflake Embeddings and Vector Search

Implement semantic search and RAG (Retrieval-Augmented Generation) using Snowflake's vector capabilities.

## Overview

Snowflake's vector search enables:
- Semantic similarity search
- RAG implementations
- Document embeddings
- Multi-modal search capabilities

## Prerequisites

- Snowflake account with Cortex AI enabled
- Understanding of vector embeddings
- Basic knowledge of RAG patterns

## Getting Started

### Enable Vector Search

```sql
-- Enable vector search for your account
ALTER ACCOUNT SET ENABLE_VECTOR_SEARCH = TRUE;

-- Create a vector database
CREATE OR REPLACE DATABASE vector_db;
USE DATABASE vector_db;

-- Create schema for vector data
CREATE OR REPLACE SCHEMA embeddings;
USE SCHEMA embeddings;
```

### Create Vector Tables

```sql
-- Create table for document embeddings
CREATE OR REPLACE TABLE document_embeddings (
    doc_id VARCHAR,
    content TEXT,
    embedding VECTOR(FLOAT, 1536),  -- OpenAI embedding dimension
    metadata VARIANT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create table for product embeddings
CREATE OR REPLACE TABLE product_embeddings (
    product_id VARCHAR,
    product_name VARCHAR,
    description TEXT,
    embedding VECTOR(FLOAT, 1536),
    category VARCHAR,
    price FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);
```

## Generating Embeddings

### Using Snowflake Cortex

```sql
-- Generate embeddings using Snowflake Cortex
INSERT INTO document_embeddings (doc_id, content, embedding, metadata)
SELECT 
    'doc_' || seq4() as doc_id,
    content,
    SNOWFLAKE.CORTEX.EMBED_TEXT('snowflake-arctic-embed-m', content) as embedding,
    PARSE_JSON('{"source": "manual", "category": "tutorial"}') as metadata
FROM VALUES 
    ('Introduction to machine learning and its applications in modern business.'),
    ('Advanced SQL techniques for data analysis and reporting.'),
    ('Building scalable data pipelines with cloud technologies.'),
    ('Best practices for data governance and security.'),
    ('Implementing real-time analytics and monitoring systems.')
AS t(content);
```

### Batch Embedding Generation

```sql
-- Generate embeddings for product descriptions
INSERT INTO product_embeddings (product_id, product_name, description, embedding, category, price)
SELECT 
    product_id,
    product_name,
    description,
    SNOWFLAKE.CORTEX.EMBED_TEXT('snowflake-arctic-embed-m', 
        product_name || ': ' || description
    ) as embedding,
    category,
    price
FROM products
WHERE description IS NOT NULL;
```

## Vector Search Operations

### Similarity Search

```sql
-- Find similar documents
CREATE OR REPLACE FUNCTION find_similar_documents(
    query_text TEXT,
    top_k INTEGER DEFAULT 5
)
RETURNS TABLE (
    doc_id VARCHAR,
    content TEXT,
    similarity FLOAT,
    metadata VARIANT
)
LANGUAGE SQL
AS
$$
    WITH query_embedding AS (
        SELECT SNOWFLAKE.CORTEX.EMBED_TEXT('snowflake-arctic-embed-m', query_text) as embedding
    )
    SELECT 
        d.doc_id,
        d.content,
        VECTOR_COSINE_SIMILARITY(d.embedding, q.embedding) as similarity,
        d.metadata
    FROM document_embeddings d
    CROSS JOIN query_embedding q
    ORDER BY similarity DESC
    LIMIT top_k
$$;

-- Use the function
SELECT * FROM TABLE(find_similar_documents('data analysis techniques', 3));
```

### Advanced Search with Filters

```sql
-- Search with metadata filters
CREATE OR REPLACE FUNCTION search_products(
    query_text TEXT,
    category_filter VARCHAR DEFAULT NULL,
    max_price FLOAT DEFAULT NULL,
    top_k INTEGER DEFAULT 10
)
RETURNS TABLE (
    product_id VARCHAR,
    product_name VARCHAR,
    description TEXT,
    similarity FLOAT,
    category VARCHAR,
    price FLOAT
)
LANGUAGE SQL
AS
$$
    WITH query_embedding AS (
        SELECT SNOWFLAKE.CORTEX.EMBED_TEXT('snowflake-arctic-embed-m', query_text) as embedding
    )
    SELECT 
        p.product_id,
        p.product_name,
        p.description,
        VECTOR_COSINE_SIMILARITY(p.embedding, q.embedding) as similarity,
        p.category,
        p.price
    FROM product_embeddings p
    CROSS JOIN query_embedding q
    WHERE (category_filter IS NULL OR p.category = category_filter)
      AND (max_price IS NULL OR p.price <= max_price)
    ORDER BY similarity DESC
    LIMIT top_k
$$;

-- Search for electronics under $500
SELECT * FROM TABLE(search_products('wireless headphones', 'Electronics', 500.0, 5));
```

## RAG Implementation

### Document Retrieval for RAG

```sql
-- RAG retrieval function
CREATE OR REPLACE FUNCTION rag_retrieve_context(
    question TEXT,
    context_limit INTEGER DEFAULT 3
)
RETURNS TABLE (
    context_text TEXT,
    similarity FLOAT,
    source_doc VARCHAR
)
LANGUAGE SQL
AS
$$
    WITH question_embedding AS (
        SELECT SNOWFLAKE.CORTEX.EMBED_TEXT('snowflake-arctic-embed-m', question) as embedding
    ),
    ranked_docs AS (
        SELECT 
            content,
            VECTOR_COSINE_SIMILARITY(embedding, q.embedding) as similarity,
            doc_id
        FROM document_embeddings d
        CROSS JOIN question_embedding q
        ORDER BY similarity DESC
        LIMIT context_limit
    )
    SELECT 
        content as context_text,
        similarity,
        doc_id as source_doc
    FROM ranked_docs
$$;

-- Use RAG retrieval
SELECT * FROM TABLE(rag_retrieve_context('How do I optimize SQL queries?', 3));
```

### Complete RAG Pipeline

```sql
-- Complete RAG implementation
CREATE OR REPLACE FUNCTION rag_answer_question(
    question TEXT,
    context_limit INTEGER DEFAULT 3
)
RETURNS STRING
LANGUAGE SQL
AS
$$
    WITH retrieved_context AS (
        SELECT 
            LISTAGG(context_text, '\n\n') WITHIN GROUP (ORDER BY similarity DESC) as context
        FROM TABLE(rag_retrieve_context(question, context_limit))
    ),
    prompt AS (
        SELECT 
            'Based on the following context, answer the question. If the answer is not in the context, say "I don\'t have enough information to answer this question."\n\n' ||
            'Context:\n' || context || '\n\n' ||
            'Question: ' || question || '\n\n' ||
            'Answer:' as full_prompt
        FROM retrieved_context
    )
    SELECT SNOWFLAKE.CORTEX.COMPLETE(
        'snowflake-arctic-large',
        full_prompt,
        OBJECT_CONSTRUCT(
            'temperature', 0.1,
            'max_tokens', 500
        )
    ) as answer
    FROM prompt
$$;

-- Ask a question using RAG
SELECT rag_answer_question('What are the best practices for data governance?') as answer;
```

## Multi-Modal Search

### Image and Text Search

```sql
-- Create table for multi-modal embeddings
CREATE OR REPLACE TABLE product_multimodal (
    product_id VARCHAR,
    product_name VARCHAR,
    description TEXT,
    image_url VARCHAR,
    text_embedding VECTOR(FLOAT, 1536),
    image_embedding VECTOR(FLOAT, 1024),  -- Different dimension for image embeddings
    category VARCHAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Search by text and image similarity
CREATE OR REPLACE FUNCTION multimodal_search(
    text_query TEXT,
    image_url VARCHAR DEFAULT NULL,
    text_weight FLOAT DEFAULT 0.7,
    image_weight FLOAT DEFAULT 0.3,
    top_k INTEGER DEFAULT 10
)
RETURNS TABLE (
    product_id VARCHAR,
    product_name VARCHAR,
    combined_similarity FLOAT,
    text_similarity FLOAT,
    image_similarity FLOAT
)
LANGUAGE SQL
AS
$$
    WITH text_embedding AS (
        SELECT SNOWFLAKE.CORTEX.EMBED_TEXT('snowflake-arctic-embed-m', text_query) as embedding
    ),
    image_embedding AS (
        SELECT SNOWFLAKE.CORTEX.EMBED_IMAGE('snowflake-arctic-embed-m', image_url) as embedding
        WHERE image_url IS NOT NULL
    ),
    similarities AS (
        SELECT 
            p.product_id,
            p.product_name,
            VECTOR_COSINE_SIMILARITY(p.text_embedding, t.embedding) as text_sim,
            CASE 
                WHEN i.embedding IS NOT NULL 
                THEN VECTOR_COSINE_SIMILARITY(p.image_embedding, i.embedding)
                ELSE 0
            END as image_sim
        FROM product_multimodal p
        CROSS JOIN text_embedding t
        LEFT JOIN image_embedding i ON 1=1
    )
    SELECT 
        product_id,
        product_name,
        (text_sim * text_weight + image_sim * image_weight) as combined_similarity,
        text_sim as text_similarity,
        image_sim as image_similarity
    FROM similarities
    ORDER BY combined_similarity DESC
    LIMIT top_k
$$;
```

## Performance Optimization

### Vector Indexing

```sql
-- Create vector search index for better performance
CREATE OR REPLACE SEARCH INDEX vector_index ON document_embeddings(embedding)
FOR VECTOR;

-- Create index on product embeddings
CREATE OR REPLACE SEARCH INDEX product_vector_index ON product_embeddings(embedding)
FOR VECTOR;

-- Monitor index status
SELECT 
    table_name,
    index_name,
    status,
    created_on
FROM information_schema.search_indexes
WHERE table_schema = 'EMBEDDINGS';
```

### Batch Processing

```sql
-- Batch process embeddings for large datasets
CREATE OR REPLACE PROCEDURE batch_generate_embeddings(
    source_table STRING,
    text_column STRING,
    target_table STRING,
    batch_size INTEGER DEFAULT 1000
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    total_rows INTEGER;
    processed_rows INTEGER := 0;
    batch_count INTEGER;
    sql_stmt STRING;
BEGIN
    -- Get total row count
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || source_table INTO total_rows;
    
    -- Calculate number of batches
    batch_count := CEIL(total_rows / batch_size);
    
    -- Process in batches
    FOR i IN 1 TO batch_count DO
        sql_stmt := '
            INSERT INTO ' || target_table || ' (doc_id, content, embedding)
            SELECT 
                ''doc_'' || ROW_NUMBER() OVER (ORDER BY ' || text_column || ') as doc_id,
                ' || text_column || ' as content,
                SNOWFLAKE.CORTEX.EMBED_TEXT(''snowflake-arctic-embed-m'', ' || text_column || ') as embedding
            FROM ' || source_table || '
            LIMIT ' || batch_size || ' OFFSET ' || ((i-1) * batch_size);
        
        EXECUTE IMMEDIATE sql_stmt;
        processed_rows := processed_rows + batch_size;
        
        -- Log progress
        IF (i % 10 = 0) THEN
            RAISE INFO('Processed % rows of %', processed_rows, total_rows);
        END IF;
    END FOR;
    
    RETURN 'Successfully processed ' || total_rows || ' rows in ' || batch_count || ' batches';
END;
$$;

-- Use the procedure
CALL batch_generate_embeddings('large_text_table', 'content', 'document_embeddings', 500);
```

## Monitoring and Maintenance

### Search Performance Monitoring

```sql
-- Monitor search performance
CREATE OR REPLACE VIEW search_performance AS
SELECT 
    DATE_TRUNC('hour', query_time) as hour_bucket,
    COUNT(*) as query_count,
    AVG(execution_time_ms) as avg_execution_time,
    MAX(execution_time_ms) as max_execution_time,
    COUNT(CASE WHEN execution_time_ms > 5000 THEN 1 END) as slow_queries
FROM search_logs
WHERE query_time >= CURRENT_TIMESTAMP() - INTERVAL '24 hours'
GROUP BY DATE_TRUNC('hour', query_time)
ORDER BY hour_bucket DESC;

-- Check embedding quality
SELECT 
    AVG(VECTOR_L2_NORM(embedding)) as avg_embedding_norm,
    STDDEV(VECTOR_L2_NORM(embedding)) as stddev_embedding_norm,
    COUNT(*) as total_embeddings
FROM document_embeddings;
```

### Cost Analysis

```sql
-- Analyze embedding generation costs
SELECT 
    DATE_TRUNC('day', created_at) as date,
    COUNT(*) as embeddings_generated,
    COUNT(*) * 0.0001 as estimated_cost_usd  -- Approximate cost per embedding
FROM document_embeddings
WHERE created_at >= CURRENT_TIMESTAMP() - INTERVAL '30 days'
GROUP BY DATE_TRUNC('day', created_at)
ORDER BY date DESC;
```

## Best Practices

### 1. Embedding Quality
- Use appropriate embedding models for your domain
- Normalize text before generating embeddings
- Handle different languages appropriately

### 2. Search Optimization
- Create vector indexes for better performance
- Use appropriate similarity thresholds
- Implement caching for frequent queries

### 3. RAG Implementation
- Retrieve relevant context chunks
- Implement proper prompt engineering
- Monitor answer quality and relevance

## Exercises

### Exercise 1: Document Search System
Build a semantic search system for a document collection.

### Exercise 2: Product Recommendation Engine
Create a vector-based product recommendation system.

### Exercise 3: RAG Chatbot
Implement a complete RAG chatbot for customer support.

## Next Steps

- Learn about [Document AI](document-ai.md)
- Explore [Cortex Finetuning](cortex-finetuning.md)
- Check out [Snowpark ML](snowpark-ml.md)

## Additional Resources

- [Vector Search Documentation](https://docs.snowflake.com/en/user-guide/vector-search.html)
- [Cortex AI Functions](https://docs.snowflake.com/en/sql-reference/functions/cortex.html)
- [RAG Best Practices](https://docs.snowflake.com/en/user-guide/vector-search-rag.html)
