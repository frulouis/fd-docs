-- Drop views
DROP VIEW IF EXISTS sales_analytics;
DROP VIEW IF EXISTS inventory_analytics;

-- Drop procedures
DROP PROCEDURE IF EXISTS calculate_customer_lifetime_value();
DROP PROCEDURE IF EXISTS update_inventory_levels();
DROP PROCEDURE IF EXISTS generate_reorder_recommendations();
DROP PROCEDURE IF EXISTS cleanup_old_data(INTEGER);

-- Drop tables
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS "order";
DROP TABLE IF EXISTS inventory;

-- Drop tags
DROP TAG IF EXISTS data_owner;
DROP TAG IF EXISTS data_classification;
DROP TAG IF EXISTS retention_policy;

-- Drop schema and database (if created)
-- DROP SCHEMA IF EXISTS retail;
-- DROP DATABASE IF EXISTS retaildb; 