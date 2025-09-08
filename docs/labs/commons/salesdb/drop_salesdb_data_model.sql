-- Drop views
DROP VIEW IF EXISTS SalesDB.custs.CustomerSalesSummary;
DROP VIEW IF EXISTS SalesDB.custs.SalesPipelineByStage;

-- Drop procedures
DROP PROCEDURE IF EXISTS SalesDB.custs.GetHighValueCustomers();
DROP PROCEDURE IF EXISTS SalesDB.custs.GetClosingOpportunities();

-- Drop tables
DROP TABLE IF EXISTS SalesDB.custs.Customer;
DROP TABLE IF EXISTS SalesDB.custs.Buyer;
DROP TABLE IF EXISTS SalesDB.custs.Client;
DROP TABLE IF EXISTS SalesDB.custs.Opportunities;

-- Drop tags
DROP TAG IF EXISTS SalesDB.custs.PII_TAG;
DROP TAG IF EXISTS SalesDB.custs.LEAD_SOURCE_TAG;

-- Drop roles and users
DROP ROLE IF EXISTS SalesRep;
DROP ROLE IF EXISTS SalesManager;
DROP USER IF EXISTS Demo;

-- Drop schema and database
DROP SCHEMA IF EXISTS SalesDB.custs;
DROP DATABASE IF EXISTS SalesDB; 