-- Drop tables
DROP TABLE IF EXISTS marketing.customers;
DROP TABLE IF EXISTS marketing.campaigns;
DROP TABLE IF EXISTS marketing.leads;

-- Drop tags
DROP TAG IF EXISTS marketing.PII_TAG;
DROP TAG IF EXISTS marketing.CUSTOMER_DATA_TAG;
DROP TAG IF EXISTS marketing.MARKETING_DATA_TAG;

-- Drop schema and database
DROP SCHEMA IF EXISTS marketing;
DROP DATABASE IF EXISTS marketingdb; 