# RETAILDB Quick Reference

## Database & Schema
```sql
USE DATABASE retaildb;
USE SCHEMA retail;
```

## Core Tables Overview

| Table | Purpose | Key Fields | Sample Count |
|-------|---------|------------|--------------|
| `customer` | Customer master data | customer_id, email, loyalty_tier | 3 |
| `product` | Product catalog | product_id, sku, category_id | 3 |
| `order` | Order transactions | order_id, customer_id, total_amount | 3 |
| `order_item` | Order line items | order_item_id, order_id, product_id | 3 |
| `store` | Store locations | store_id, store_name, city | 3 |
| `inventory` | Stock levels | inventory_id, product_id, current_stock | 4 |

## Key Relationships

```
customer (1) ←→ (N) order
order (1) ←→ (N) order_item
product (1) ←→ (N) order_item
product (1) ←→ (N) inventory
store (1) ←→ (N) inventory
category (1) ←→ (N) product
brand (1) ←→ (N) product
```

## Analytics Views

| View | Purpose | Key Metrics |
|------|---------|-------------|
| `customer_analytics` | Customer insights | lifetime_value, total_orders, days_since_last_order |
| `product_performance` | Product metrics | total_revenue, conversion_rate, return_rate |
| `sales_analytics` | Sales analysis | revenue by channel, attribution, purchase funnel |
| `inventory_analytics` | Stock management | stock_status, inventory_value, reorder alerts |

## Common Queries

### Customer Analysis
```sql
-- High-value customers
SELECT customer_id, first_name, last_name, lifetime_value, loyalty_tier
FROM customer_analytics 
WHERE lifetime_value > 2000;

-- Customer segments
SELECT customer_segment, COUNT(*), AVG(lifetime_value)
FROM customer_analytics 
GROUP BY customer_segment;
```

### Product Performance
```sql
-- Top products by revenue
SELECT product_name, total_revenue, times_ordered
FROM product_performance 
ORDER BY total_revenue DESC;

-- Low performing products
SELECT product_name, conversion_rate, return_rate
FROM product_performance 
WHERE conversion_rate < 2.0;
```

### Sales Analysis
```sql
-- Sales by channel
SELECT channel, COUNT(*) as orders, SUM(total_amount) as revenue
FROM sales_analytics 
GROUP BY channel;

-- Marketing attribution
SELECT utm_source, utm_medium, COUNT(*) as orders
FROM sales_analytics 
WHERE utm_source IS NOT NULL
GROUP BY utm_source, utm_medium;
```

### Inventory Management
```sql
-- Low stock alerts
SELECT product_name, store_name, current_stock, reorder_point
FROM inventory_analytics 
WHERE stock_status = 'Reorder Needed';

-- Inventory value by store
SELECT store_name, SUM(inventory_value) as total_value
FROM inventory_analytics 
GROUP BY store_name;
```

## Stored Procedures

| Procedure | Purpose | Parameters |
|-----------|---------|------------|
| `calculate_customer_lifetime_value()` | Update customer LTV | None |
| `update_inventory_levels()` | Update stock counts | None |
| `generate_reorder_recommendations()` | Get reorder alerts | None |
| `cleanup_old_data(days_to_keep)` | Remove old data | days_to_keep (INT) |

## Data Tags

| Table | Data Owner | Classification | Retention |
|-------|------------|----------------|-----------|
| `customer` | Marketing Team | PII | 7 Years |
| `product` | Product Team | Business Data | 10 Years |
| `order` | Sales Team | Financial Data | 7 Years |
| `inventory` | Operations Team | Operational Data | 5 Years |

## Sample Data Summary

### Customers
- **CUST001**: High-value customer, Gold tier, $2,500 LTV
- **CUST002**: Price-sensitive customer, Silver tier, $1,200 LTV  
- **CUST003**: Mid-value customer, Silver tier, $1,800 LTV

### Products
- **PROD001**: TechCorp Galaxy Phone ($899.99)
- **PROD002**: TechCorp Ultra Laptop ($1,299.99)
- **PROD003**: FashionStyle Men's Shirt ($89.99)

### Stores
- **STORE001**: NYC Flagship (5,000 sq ft)
- **STORE002**: LA Store (3,500 sq ft)
- **STORE003**: Chicago Store (4,000 sq ft)

## Performance Tips

1. **Clustering**: Cluster large tables on frequently queried columns
2. **Views**: Use analytics views for complex aggregations
3. **Procedures**: Use stored procedures for automated operations
4. **Tags**: Leverage data tags for governance and access control

## Quick Setup Commands

```sql
-- Create database and schema
CREATE DATABASE IF NOT EXISTS retaildb;
USE DATABASE retaildb;
CREATE SCHEMA IF NOT EXISTS retail;
USE SCHEMA retail;

-- Run the full data model script
-- (Execute retaildb_data_model.sql)

-- Test basic queries
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM product;
SELECT COUNT(*) FROM "order";
``` 