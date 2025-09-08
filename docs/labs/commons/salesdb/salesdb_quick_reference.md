# SalesDB Quick Reference Guide

## Quick Setup
```sql
-- Run the complete setup
SOURCE 'salesdb_data_model.sql';

-- Or run sections individually:
-- 1. Create database and schema
-- 2. Create tables
-- 3. Insert sample data
-- 4. Add comments and tags
-- 5. Create stored procedures and views
-- 6. Set up roles and permissions
```

## Key Tables & Relationships

```
Customer (1) ←→ (1) Buyer (1) ←→ (1) Client
     ↓
     (1) ←→ (M) Opportunities
```

## Common Queries

### Customer Analysis
```sql
-- All customers with total opportunity value
SELECT 
    c.CustomerID,
    c.FirstName || ' ' || c.LastName as CustomerName,
    SUM(o.Amount) as TotalOpportunityValue
FROM Customer c
LEFT JOIN Opportunities o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalOpportunityValue DESC;
```

### Sales Pipeline
```sql
-- Pipeline by stage
SELECT 
    SalesStage,
    COUNT(*) as Count,
    SUM(Amount) as TotalValue
FROM Opportunities
GROUP BY SalesStage;
```

### Lead Source Analysis
```sql
-- Opportunities by lead source
SELECT 
    LeadSource,
    COUNT(*) as OpportunityCount,
    SUM(Amount) as TotalAmount
FROM Opportunities
GROUP BY LeadSource
ORDER BY TotalAmount DESC;
```

## Stored Procedures

### Get High-Value Customers
```sql
CALL GetHighValueCustomers();
-- Returns customers with >$50K in won opportunities
```

### Get Closing Opportunities
```sql
CALL GetClosingOpportunities();
-- Returns opportunities closing within 30 days
```

## Views

### Customer Sales Summary
```sql
SELECT * FROM CustomerSalesSummary;
-- Complete customer performance overview
```

### Sales Pipeline by Stage
```sql
SELECT * FROM SalesPipelineByStage;
-- Pipeline analysis by sales stage
```

## Roles & Access

### SalesRep Role
- Access: Customer table, CustomerSalesSummary view
- Use: Basic customer queries and sales summaries

### SalesManager Role
- Access: All tables, views, and stored procedures
- Use: Full analytics and management capabilities

## Data Governance

### PII Tags
- **Email**: Tagged as EMAIL
- **FirstName**: Tagged as FIRST_NAME  
- **LastName**: Tagged as LAST_NAME
- **VarNumber**: Tagged as VENDOR_ID

### Lead Source Tags
- **LeadSource**: Tagged for tracking

## Sample Data Summary

| Table | Records | Key Fields |
|-------|---------|------------|
| Customer | 10 | CustomerID, FirstName, LastName, Email |
| Buyer | 10 | BuyerID, CustomerID, FirstName, LastName |
| Client | 10 | ClientID, BuyerID, ContractValue |
| Opportunities | 10 | OpportunityID, CustomerID, Amount, SalesStage |

## Sales Stages
1. **Prospecting** - Initial contact
2. **Qualification** - Evaluating fit
3. **Proposal** - Formal proposal sent
4. **Negotiation** - Terms discussion
5. **Closed Won** - Deal completed
6. **Closed Lost** - Deal lost

## Lead Sources
- **Website** - Company website
- **Partner Referral** - Partner recommendations
- **Cold Call** - Outbound prospecting
- **Trade Show** - Event leads

## Quick Reset
```sql
-- Reset demo environment
USE ROLE ACCOUNTADMIN;
DROP DATABASE IF EXISTS SalesDB CASCADE;
DROP ROLE IF EXISTS SalesRep;
DROP ROLE IF EXISTS SalesManager;
DROP USER IF EXISTS Demo;
```

## Demo Scenarios

### 1. Basic Customer Query
```sql
USE ROLE SalesRep;
SELECT * FROM CustomerSalesSummary;
```

### 2. Pipeline Analysis
```sql
USE ROLE SalesManager;
SELECT * FROM SalesPipelineByStage;
```

### 3. High-Value Customer Analysis
```sql
USE ROLE SalesManager;
CALL GetHighValueCustomers();
```

### 4. Universal Search Demo
- Search for "customers with high value"
- Search for "opportunities closing soon"
- Search for "sales pipeline"

## Troubleshooting

### Common Issues
1. **Permission Denied**: Ensure correct role is active
2. **Table Not Found**: Verify database and schema are selected
3. **Procedure Not Found**: Check if stored procedures were created successfully

### Verification Queries
```sql
-- Check if tables exist
SHOW TABLES IN SalesDB.custs;

-- Check if procedures exist
SHOW PROCEDURES IN SalesDB.custs;

-- Check if views exist
SHOW VIEWS IN SalesDB.custs;

-- Check current role
SELECT CURRENT_ROLE();
``` 