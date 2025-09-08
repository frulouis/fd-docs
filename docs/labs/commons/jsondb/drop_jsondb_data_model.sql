-- Drop tables
DROP TABLE IF EXISTS json_data.ecommerce_orders;
DROP TABLE IF EXISTS json_data.product_catalog;
DROP TABLE IF EXISTS json_data.user_profiles;
DROP TABLE IF EXISTS json_data.api_logs;
DROP TABLE IF EXISTS json_data.configurations;

-- Drop tags
DROP TAG IF EXISTS json_data.JSON_DATA_TAG;
DROP TAG IF EXISTS json_data.PERSONAL_DATA_TAG;
DROP TAG IF EXISTS json_data.FINANCIAL_DATA_TAG;
DROP TAG IF EXISTS json_data.CONFIGURATION_DATA_TAG;

-- Drop schema and database
DROP SCHEMA IF EXISTS json_data;
DROP DATABASE IF EXISTS JSONDB; 