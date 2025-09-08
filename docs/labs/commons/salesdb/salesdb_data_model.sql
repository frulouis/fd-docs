/*
------------------------------------------------------------------------------
-- Snowflake Demo Script: Sales Data Model and Universal Search Exploration
-- 
-- Description: 
-- This script sets up a sales data model in Snowflake. It includes the creation of tables for customers, buyers,
-- clients, and opportunities. It also includes sample data, tagging, role-based access controls (RBAC), 
-- stored procedures, and views for demonstration purposes.
--
-- DemoHub - SalesDB Data Model - Version 1.2.7 (updated 05/23/2024)
-- 
-- Features:
-- - Complete data model with relationships
-- - Sample data insertion
-- - PII tagging for data governance
-- - Role-based access control (RBAC)
-- - Stored procedures for business logic
-- - Views for common queries
-- - Universal search optimization
------------------------------------------------------------------------------
*/

-- +----------------------------------------------------+
-- |             1. CREATE DATABASE AND SCHEMA           |
-- +----------------------------------------------------+

-- Creates a new database named "SalesDB".
CREATE OR REPLACE DATABASE SalesDB;

-- Use the newly created database.
USE SalesDB;

-- Create a schema within the database.
CREATE OR REPLACE SCHEMA custs;

-- +----------------------------------------------------+
-- |             2. CREATE TABLE OBJECTS                 |
-- +----------------------------------------------------+

-- Create tables for storing customer, buyer, client, and opportunity data.

-- Customer Table
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

-- Buyer Table
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

-- Client Table
CREATE OR REPLACE TABLE Client (
    ClientID INT PRIMARY KEY,
    BuyerID INT REFERENCES Buyer(BuyerID),
    ContractStartDate DATE,
    ContractValue DECIMAL(10, 2),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()  
);

-- Opportunities Table
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

-- +----------------------------------------------------+
-- |             3. INSERT SAMPLE DATA                  |
-- +----------------------------------------------------+

-- Insert sample data into the created tables.

-- Customer Data
INSERT INTO Customer (CustomerID, FirstName, LastName, VarNumber, Email, HomeLocation, ZipCode) VALUES
(1, 'John', 'Smith', 'VAR001', 'john.smith@email.com', 'New York, NY', '10001'),
(2, 'Sarah', 'Johnson', 'VAR002', 'sarah.johnson@email.com', 'Los Angeles, CA', '90210'),
(3, 'Michael', 'Brown', 'VAR003', 'michael.brown@email.com', 'Chicago, IL', '60601'),
(4, 'Emily', 'Davis', 'VAR004', 'emily.davis@email.com', 'Houston, TX', '77001'),
(5, 'David', 'Wilson', 'VAR005', 'david.wilson@email.com', 'Phoenix, AZ', '85001'),
(6, 'Lisa', 'Anderson', 'VAR006', 'lisa.anderson@email.com', 'Philadelphia, PA', '19101'),
(7, 'Robert', 'Taylor', 'VAR007', 'robert.taylor@email.com', 'San Antonio, TX', '78201'),
(8, 'Jennifer', 'Martinez', 'VAR008', 'jennifer.martinez@email.com', 'San Diego, CA', '92101'),
(9, 'William', 'Garcia', 'VAR009', 'william.garcia@email.com', 'Dallas, TX', '75201'),
(10, 'Amanda', 'Rodriguez', 'VAR010', 'amanda.rodriguez@email.com', 'San Jose, CA', '95101');

-- Buyer Data
INSERT INTO Buyer (BuyerID, CustomerID, FirstName, LastName, Email, Address, PostalCode) VALUES
(1, 1, 'John', 'Smith', 'john.smith@email.com', '123 Main St, New York, NY', '10001'),
(2, 2, 'Sarah', 'Johnson', 'sarah.johnson@email.com', '456 Oak Ave, Los Angeles, CA', '90210'),
(3, 3, 'Michael', 'Brown', 'michael.brown@email.com', '789 Pine Rd, Chicago, IL', '60601'),
(4, 4, 'Emily', 'Davis', 'emily.davis@email.com', '321 Elm St, Houston, TX', '77001'),
(5, 5, 'David', 'Wilson', 'david.wilson@email.com', '654 Maple Dr, Phoenix, AZ', '85001'),
(6, 6, 'Lisa', 'Anderson', 'lisa.anderson@email.com', '987 Cedar Ln, Philadelphia, PA', '19101'),
(7, 7, 'Robert', 'Taylor', 'robert.taylor@email.com', '147 Birch Way, San Antonio, TX', '78201'),
(8, 8, 'Jennifer', 'Martinez', 'jennifer.martinez@email.com', '258 Spruce Ct, San Diego, CA', '92101'),
(9, 9, 'William', 'Garcia', 'william.garcia@email.com', '369 Willow Blvd, Dallas, TX', '75201'),
(10, 10, 'Amanda', 'Rodriguez', 'amanda.rodriguez@email.com', '741 Aspen Pl, San Jose, CA', '95101');

-- Client Data
INSERT INTO Client (ClientID, BuyerID, ContractStartDate, ContractValue) VALUES
(1, 1, '2024-01-15', 50000.00),
(2, 2, '2024-02-20', 75000.00),
(3, 3, '2024-03-10', 120000.00),
(4, 4, '2024-01-30', 35000.00),
(5, 5, '2024-04-05', 95000.00),
(6, 6, '2024-02-15', 65000.00),
(7, 7, '2024-03-25', 85000.00),
(8, 8, '2024-01-10', 45000.00),
(9, 9, '2024-04-12', 110000.00),
(10, 10, '2024-02-28', 55000.00);

-- Opportunities Data
INSERT INTO Opportunities (OpportunityID, CustomerID, BuyerID, LeadSource, SalesStage, ExpectedCloseDate, Amount) VALUES
(1, 1, 1, 'Website', 'Closed Won', '2024-01-20', 50000.00),
(2, 2, 2, 'Partner Referral', 'Closed Won', '2024-02-25', 75000.00),
(3, 3, 3, 'Cold Call', 'Prospecting', '2024-05-15', 120000.00),
(4, 4, 4, 'Website', 'Closed Won', '2024-02-05', 35000.00),
(5, 5, 5, 'Trade Show', 'Qualification', '2024-06-20', 95000.00),
(6, 6, 6, 'Partner Referral', 'Closed Won', '2024-03-01', 65000.00),
(7, 7, 7, 'Cold Call', 'Proposal', '2024-04-30', 85000.00),
(8, 8, 8, 'Website', 'Closed Won', '2024-01-25', 45000.00),
(9, 9, 9, 'Trade Show', 'Negotiation', '2024-05-10', 110000.00),
(10, 10, 10, 'Partner Referral', 'Closed Won', '2024-03-15', 55000.00);

-- +----------------------------------------------------+
-- |             4. ADD COMMENTS AND TAGS               |
-- +----------------------------------------------------+

-- Add comments to tables for better documentation
COMMENT ON TABLE Customer IS 'Stores customer information including personal details and contact information';
COMMENT ON TABLE Buyer IS 'Stores buyer information linked to customers';
COMMENT ON TABLE Client IS 'Stores client contract information linked to buyers';
COMMENT ON TABLE Opportunities IS 'Stores sales opportunities and pipeline information';

-- Add comments to columns for better understanding
COMMENT ON COLUMN Customer.Email IS 'Customer email address for communication';
COMMENT ON COLUMN Customer.VarNumber IS 'Vendor number for partner identification';
COMMENT ON COLUMN Opportunities.LeadSource IS 'Source of the sales lead (Website, Partner Referral, Cold Call, Trade Show)';
COMMENT ON COLUMN Opportunities.SalesStage IS 'Current stage in the sales pipeline';
COMMENT ON COLUMN Opportunities.Amount IS 'Expected or actual deal value';

-- +----------------------------------------------------+
-- |             5. CREATE TAGS FOR PII                 |
-- +----------------------------------------------------+

-- Create tags for Personally Identifiable Information (PII)
CREATE OR REPLACE TAG PII_TAG;
CREATE OR REPLACE TAG LEAD_SOURCE_TAG;

-- Apply PII tags to sensitive columns
ALTER TABLE Customer ALTER COLUMN Email SET TAG PII_TAG = 'EMAIL';
ALTER TABLE Customer ALTER COLUMN FirstName SET TAG PII_TAG = 'FIRST_NAME';
ALTER TABLE Customer ALTER COLUMN LastName SET TAG PII_TAG = 'LAST_NAME';
ALTER TABLE Customer ALTER COLUMN VarNumber SET TAG PII_TAG = 'VENDOR_ID';

ALTER TABLE Buyer ALTER COLUMN Email SET TAG PII_TAG = 'EMAIL';
ALTER TABLE Buyer ALTER COLUMN FirstName SET TAG PII_TAG = 'FIRST_NAME';
ALTER TABLE Buyer ALTER COLUMN LastName SET TAG PII_TAG = 'LAST_NAME';

-- Apply lead source tags
ALTER TABLE Opportunities ALTER COLUMN LeadSource SET TAG LEAD_SOURCE_TAG = 'LEAD_SOURCE';

-- +----------------------------------------------------+
-- |             6. CREATE STORED PROCEDURES            |
-- +----------------------------------------------------+

-- Stored procedure to get high-value customers
CREATE OR REPLACE PROCEDURE GetHighValueCustomers()
RETURNS TABLE (
    CustomerID INT,
    CustomerName VARCHAR(100),
    TotalValue DECIMAL(15,2),
    OpportunityCount INT
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            c.CustomerID,
            c.FirstName || ' ' || c.LastName as CustomerName,
            SUM(o.Amount) as TotalValue,
            COUNT(o.OpportunityID) as OpportunityCount
        FROM Customer c
        LEFT JOIN Opportunities o ON c.CustomerID = o.CustomerID
        WHERE o.SalesStage = 'Closed Won'
        GROUP BY c.CustomerID, c.FirstName, c.LastName
        HAVING SUM(o.Amount) > 50000
        ORDER BY TotalValue DESC
    );
END;
$$;

-- Stored procedure to get opportunities likely to close soon
CREATE OR REPLACE PROCEDURE GetClosingOpportunities()
RETURNS TABLE (
    OpportunityID INT,
    CustomerName VARCHAR(100),
    SalesStage VARCHAR(20),
    Amount DECIMAL(10,2),
    ExpectedCloseDate DATE,
    DaysToClose INT
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            o.OpportunityID,
            c.FirstName || ' ' || c.LastName as CustomerName,
            o.SalesStage,
            o.Amount,
            o.ExpectedCloseDate,
            DATEDIFF('day', CURRENT_DATE(), o.ExpectedCloseDate) as DaysToClose
        FROM Opportunities o
        JOIN Customer c ON o.CustomerID = c.CustomerID
        WHERE o.SalesStage IN ('Proposal', 'Negotiation')
        AND o.ExpectedCloseDate <= DATEADD('month', 1, CURRENT_DATE())
        ORDER BY o.ExpectedCloseDate ASC
    );
END;
$$;

-- +----------------------------------------------------+
-- |             7. CREATE VIEWS                        |
-- +----------------------------------------------------+

-- View for customer sales summary
CREATE OR REPLACE VIEW CustomerSalesSummary AS
SELECT 
    c.CustomerID,
    c.FirstName || ' ' || c.LastName as CustomerName,
    c.Email,
    COUNT(o.OpportunityID) as TotalOpportunities,
    SUM(CASE WHEN o.SalesStage = 'Closed Won' THEN o.Amount ELSE 0 END) as WonAmount,
    SUM(CASE WHEN o.SalesStage != 'Closed Won' THEN o.Amount ELSE 0 END) as PipelineAmount,
    MAX(o.ExpectedCloseDate) as LastExpectedClose
FROM Customer c
LEFT JOIN Opportunities o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email;

-- View for sales pipeline by stage
CREATE OR REPLACE VIEW SalesPipelineByStage AS
SELECT 
    SalesStage,
    COUNT(OpportunityID) as OpportunityCount,
    SUM(Amount) as TotalAmount,
    AVG(Amount) as AverageAmount,
    MIN(ExpectedCloseDate) as EarliestClose,
    MAX(ExpectedCloseDate) as LatestClose
FROM Opportunities
GROUP BY SalesStage
ORDER BY 
    CASE SalesStage
        WHEN 'Prospecting' THEN 1
        WHEN 'Qualification' THEN 2
        WHEN 'Proposal' THEN 3
        WHEN 'Negotiation' THEN 4
        WHEN 'Closed Won' THEN 5
        WHEN 'Closed Lost' THEN 6
        ELSE 7
    END;

-- +----------------------------------------------------+
-- |             8. CREATE ROLES AND USERS              |
-- +----------------------------------------------------+

-- Create roles for different access levels
CREATE OR REPLACE ROLE SalesRep;
CREATE OR REPLACE ROLE SalesManager;

-- Create demo user
CREATE OR REPLACE USER Demo PASSWORD = 'DemoPassword123!';

-- +----------------------------------------------------+
-- |             9. GRANT PERMISSIONS                   |
-- +----------------------------------------------------+

-- Grant Usage on Schema to Roles
GRANT USAGE ON SCHEMA SalesDB.custs TO ROLE SalesRep;
GRANT USAGE ON SCHEMA SalesDB.custs TO ROLE SalesManager;

-- Grant Usage on Warehouse to Roles (assuming Demo_WH exists)
-- GRANT USAGE ON WAREHOUSE Demo_WH TO ROLE SalesRep;
-- GRANT USAGE ON WAREHOUSE Demo_WH TO ROLE SalesManager;

-- Grant Select on Tables to Roles
GRANT SELECT ON TABLE Customer TO ROLE SalesRep;
GRANT SELECT ON ALL TABLES IN SCHEMA custs TO ROLE SalesManager; -- More access

-- Grant Execute on Stored Procedures
GRANT EXECUTE ON PROCEDURE GetHighValueCustomers() TO ROLE SalesManager;
GRANT EXECUTE ON PROCEDURE GetClosingOpportunities() TO ROLE SalesManager;

-- Grant Select on Views
GRANT SELECT ON VIEW CustomerSalesSummary TO ROLE SalesRep;
GRANT SELECT ON VIEW SalesPipelineByStage TO ROLE SalesManager;

-- +----------------------------------------------------+
-- |             10. ASSIGN ROLES TO USERS              |
-- +----------------------------------------------------+

-- Grant the SalesRep role to the Demo user
GRANT ROLE SalesRep TO USER Demo;

-- +----------------------------------------------------+
-- |             11. SAMPLE QUERIES FOR TESTING         |
-- +----------------------------------------------------+

-- Test query 1: Get all customers with their total opportunity value
/*
SELECT 
    c.CustomerID,
    c.FirstName || ' ' || c.LastName as CustomerName,
    SUM(o.Amount) as TotalOpportunityValue
FROM Customer c
LEFT JOIN Opportunities o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalOpportunityValue DESC;
*/

-- Test query 2: Get opportunities by lead source
/*
SELECT 
    LeadSource,
    COUNT(*) as OpportunityCount,
    SUM(Amount) as TotalAmount,
    AVG(Amount) as AverageAmount
FROM Opportunities
GROUP BY LeadSource
ORDER BY TotalAmount DESC;
*/

-- Test query 3: Get sales pipeline summary
/*
SELECT 
    SalesStage,
    COUNT(*) as Count,
    SUM(Amount) as TotalValue
FROM Opportunities
GROUP BY SalesStage
ORDER BY 
    CASE SalesStage
        WHEN 'Prospecting' THEN 1
        WHEN 'Qualification' THEN 2
        WHEN 'Proposal' THEN 3
        WHEN 'Negotiation' THEN 4
        WHEN 'Closed Won' THEN 5
        WHEN 'Closed Lost' THEN 6
        ELSE 7
    END;
*/

-- +----------------------------------------------------+
-- |             12. CLEANUP SCRIPT (OPTIONAL)          |
-- +----------------------------------------------------+

/*
-- To reset the demo environment, uncomment and run:

USE ROLE ACCOUNTADMIN;

-- Drop the database
DROP DATABASE IF EXISTS SalesDB CASCADE;

-- Revoke from user
REVOKE ROLE SalesRep FROM USER Demo;

-- Drop the roles
DROP ROLE IF EXISTS SalesRep;
DROP ROLE IF EXISTS SalesManager;

-- Drop the user
DROP USER IF EXISTS Demo;
*/ 