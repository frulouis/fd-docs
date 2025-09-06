# SalesDB Data Model

A comprehensive sales data model for Snowflake demos and tutorials, featuring customer, buyer, client, and opportunity data with advanced security and governance features.

## Overview

The SalesDB data model provides a realistic sales environment for learning Snowflake capabilities including:
- **Data Quality Metrics** - Built-in data validation and quality monitoring
- **Data Classification** - PII tagging and masking policies
- **RBAC Security** - Role-based access control implementation
- **Universal Search** - Enhanced search capabilities with comments and tags
- **Stored Procedures** - Business logic and data manipulation functions

## Prerequisites

- Snowflake account with appropriate privileges
- Understanding of SQL and database concepts
- Basic knowledge of data governance principles

## Data Model Architecture

![SalesDB Data Model Architecture](../../assets/images/salesdb-architecture.png)

*Figure 1: SalesDB Data Model - Complete database schema showing relationships between Customer, Buyer, Client, and Opportunities tables*

## Data Model Structure

### Core Tables

#### Customer Table
```sql
CREATE OR REPLACE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    VarNumber VARCHAR(20),
    Email VARCHAR(100),
    HomeLocation VARCHAR(200),
    ZipCode VARCHAR(10),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()  
);
```

#### Buyer Table
```sql
CREATE OR REPLACE TABLE Buyer (
    BuyerID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Address VARCHAR(200),
    PostalCode VARCHAR(10),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()  
);
```

#### Client Table
```sql
CREATE OR REPLACE TABLE Client (
    ClientID INT PRIMARY KEY,
    BuyerID INT REFERENCES Buyer(BuyerID),
    ContractStartDate DATE,
    ContractValue DECIMAL(10, 2),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()  
);
```

#### Opportunities Table
```sql
CREATE OR REPLACE TABLE Opportunities (
    OpportunityID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    BuyerID INT REFERENCES Buyer(BuyerID),
    LeadSource VARCHAR(50),
    SalesStage VARCHAR(20),
    ExpectedCloseDate DATE,
    Amount DECIMAL(10, 2),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()  
);
```

## Data Quality Features

### Sample Data with Quality Issues
The model includes intentionally flawed data to demonstrate data quality monitoring:

![Data Quality Issues Dashboard](../../assets/images/salesdb-data-quality.png)

*Figure 2: Data Quality Dashboard - Visual representation of data quality issues including invalid emails, missing values, and duplicate data*

- **Invalid Emails** - `'invalid_email'` entries
- **Missing Values** - NULL first names and addresses
- **Duplicate Data** - Duplicate email addresses
- **Stale Data** - Old load dates for testing freshness
- **Inconsistent Formats** - Various data format issues

### Data Quality Validation
```sql
-- Check for invalid email formats
SELECT CustomerID, Email
FROM Customer
WHERE Email NOT LIKE '%@%.%' OR Email = 'invalid_email';

-- Find missing required fields
SELECT CustomerID, FirstName, LastName
FROM Customer
WHERE FirstName IS NULL OR LastName IS NULL;

-- Identify duplicate emails
SELECT Email, COUNT(*) as duplicate_count
FROM Customer
GROUP BY Email
HAVING COUNT(*) > 1;
```

## Security and Governance

### PII Tagging
```sql
-- Create PII tag
CREATE OR REPLACE TAG PII 
ALLOWED_VALUES 'Name', 'Email', 'Address' 
COMMENT = 'Indicates personally identifiable information';

-- Apply tags to sensitive columns
ALTER TABLE Customer MODIFY COLUMN FirstName SET TAG PII = 'Name';
ALTER TABLE Customer MODIFY COLUMN LastName SET TAG PII = 'Name';
ALTER TABLE Customer MODIFY COLUMN Email SET TAG PII = 'Email';
```

![PII Tagging Implementation](../../assets/images/salesdb-pii-tagging.png)

*Figure 3: PII Tagging Implementation - Visual guide showing how to apply PII tags to sensitive data columns*

### Lead Source and Sales Stage Tags
```sql
-- Lead Source Tag
CREATE OR REPLACE TAG Lead_Source 
ALLOWED_VALUES 'Partner Referral', 'Web Form', 'Outbound Call', 'Trade Show' 
COMMENT = 'Indicates the source of the lead or opportunity';

-- Sales Stage Tag
CREATE OR REPLACE TAG Sales_Stage 
ALLOWED_VALUES 'Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost' 
COMMENT = 'Indicates the current stage of the sales opportunity';
```

### Data Masking Policies
```sql
-- Create masking policy for PII
CREATE OR REPLACE MASKING POLICY mask_pii AS (val string) RETURNS string ->
    CASE
        WHEN current_role() IN ('SalesManager') THEN val
        ELSE '***MASKED***'
    END;

-- Apply masking to PII tagged columns
ALTER TAG PII SET MASKING POLICY mask_pii;
```

![Data Masking Policy Flow](../../assets/images/salesdb-masking-policy.png)

*Figure 4: Data Masking Policy Flow - Diagram showing how masking policies work with different user roles*

## Business Logic Functions

### Customer Value Calculation
```sql
CREATE OR REPLACE FUNCTION customer_closed_won_value(customer_id INT)
RETURNS DECIMAL(10, 2)
LANGUAGE SQL
AS $$
    SELECT COALESCE(SUM(Amount), 0)
    FROM Opportunities
    WHERE CustomerID = customer_id
    AND SalesStage = 'Closed Won'
$$;
```

### Customer Categorization
```sql
CREATE OR REPLACE FUNCTION categorize_customer(customer_id INT)
RETURNS STRING
LANGUAGE SQL
AS $$
    SELECT CASE
        WHEN customer_closed_won_value(customer_id) >= 100000 THEN 'High Value'
        WHEN customer_closed_won_value(customer_id) >= 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END
$$;
```

### Stored Procedures
```sql
-- Update opportunity stage
CREATE OR REPLACE PROCEDURE update_opportunity_stage(opportunity_id INT, new_stage VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS $$
BEGIN
    UPDATE Opportunities
    SET SalesStage = new_stage
    WHERE OpportunityID = opportunity_id;
    RETURN 'Success';
END;
$$;

-- Assign buyer to customer
CREATE OR REPLACE PROCEDURE assign_buyer_to_customer(customer_id INT, buyer_id INT)
RETURNS STRING
LANGUAGE SQL
AS $$
BEGIN
    UPDATE Customer
    SET BuyerID = buyer_id
    WHERE CustomerID = customer_id;
    RETURN 'Success';
END;
$$;
```

## Analytical Views

### High Value Customers View
```sql
CREATE OR REPLACE VIEW high_value_customers AS
SELECT c.*, customer_closed_won_value(c.CustomerID) AS TotalValue
FROM Customer c
WHERE categorize_customer(c.CustomerID) = 'High Value';
```

### Opportunities Likely to Close
```sql
CREATE OR REPLACE VIEW opportunities_likely_to_close AS
SELECT *
FROM Opportunities
WHERE SalesStage IN ('Negotiation', 'Proposal')
AND ExpectedCloseDate BETWEEN CURRENT_DATE AND DATEADD(month, 1, CURRENT_DATE);
```

![Sales Analytics Dashboard](../../assets/images/salesdb-analytics-dashboard.png)

*Figure 5: Sales Analytics Dashboard - Visual representation of high-value customers and opportunities analysis*

## Role-Based Access Control

### Role Creation
```sql
-- Create roles
CREATE OR REPLACE ROLE SalesRep;
CREATE OR REPLACE ROLE SalesManager;

-- Grant database access
GRANT USAGE ON DATABASE SalesDB TO ROLE SalesRep;
GRANT USAGE ON DATABASE SalesDB TO ROLE SalesManager;

-- Grant schema access
GRANT USAGE ON SCHEMA SalesDB.customer TO ROLE SalesRep;
GRANT USAGE ON SCHEMA SalesDB.customer TO ROLE SalesManager;

-- Grant table permissions
GRANT SELECT ON TABLE Customer TO ROLE SalesRep;
GRANT SELECT ON ALL TABLES IN SCHEMA customer TO ROLE SalesManager;
```

![RBAC Architecture Diagram](../../assets/images/salesdb-rbac-architecture.png)

*Figure 6: RBAC Architecture - Diagram showing role-based access control implementation for different user types*

## Usage in Tutorials

This data model serves as the foundation for:

- **Data Quality Metrics** - Testing quality monitoring functions
- **Data Classification** - Implementing governance and compliance
- **Higher Order Functions** - Advanced data transformations
- **Dynamic Tables** - Real-time data processing
- **Snowpark ML** - Machine learning model training
- **Cortex AI** - Natural language processing and forecasting
- **Streamlit Apps** - Interactive data visualization

## Setup Instructions

### 1. Create Database and Schema
```sql
CREATE OR REPLACE DATABASE SalesDB;
USE DATABASE SalesDB;
CREATE OR REPLACE SCHEMA customer;
USE SCHEMA customer;
```

### 2. Run Complete Setup Script
The full setup script includes:
- Table creation
- Sample data insertion
- Tag and masking policy setup
- Function and procedure creation
- View creation
- RBAC configuration

### 3. Verify Setup
```sql
-- Check table counts
SELECT 'Customer' as table_name, COUNT(*) as row_count FROM Customer
UNION ALL
SELECT 'Buyer', COUNT(*) FROM Buyer
UNION ALL
SELECT 'Client', COUNT(*) FROM Client
UNION ALL
SELECT 'Opportunities', COUNT(*) FROM Opportunities;
```

## Data Model Benefits

### For Learning
- **Realistic Data** - Based on actual business scenarios
- **Quality Issues** - Built-in data problems for testing
- **Security Features** - Complete governance implementation
- **Business Logic** - Practical functions and procedures

### For Demos
- **Comprehensive Coverage** - All major Snowflake features
- **Scalable Design** - Easy to extend and modify
- **Documentation** - Well-commented and explained
- **Consistent Structure** - Follows best practices

## Next Steps

- [CaresDB Data Model](caresdb-data-model.md) - Healthcare data model
- [OrdersDB Data Model](ordersdb-data-model.md) - E-commerce data model
- [IoTDB Data Model](iotdb-data-model.md) - Internet of Things data model
- [MediSnowDB Data Model](medisnowdb-data-model.md) - Medical data model

## Resources

- [SalesDB Setup Script](https://complex-teammates-374480.framer.app/demo/salesdb-data-model) - Complete implementation
- [Data Quality Metrics Tutorial](../advanced-warehousing/data-quality-metrics.md) - Quality monitoring
- [Data Classification Tutorial](../advanced-warehousing/data-classification.md) - Governance implementation