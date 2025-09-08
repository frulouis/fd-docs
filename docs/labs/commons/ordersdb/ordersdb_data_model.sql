/*
------------------------------------------------------------------------------
-- Snowflake Demo Script: Orders Data Model
-- 
-- Description: 
-- This script sets up a sales data model in Snowflake. It includes the creation of tables for customers, device,
-- sales_order, and sales_order_item. The model leverages external data stored in an S3 bucket for demonstration.
--
-- DemoHub - OrdersDB Data Model - Version 1.2.7 (updated 05/26/2024)
--
-- Features:
-- - Complete data model with relationships
-- - External stage integration with S3
-- - Schema inference for automatic table creation
-- - Sample data loading from external sources
-- - File format configuration for CSV data
-- - Ready for advanced Snowflake features exploration
------------------------------------------------------------------------------
*/

USE WAREHOUSE COMPUTE_WH;

-- +----------------------------------------------------+
-- |             1. DATABASE AND SCHEMA SETUP           |
-- +----------------------------------------------------+

-- Create or replace the database
CREATE OR REPLACE DATABASE ordersdb;

-- Use the database
USE ordersdb;

-- Use the public schema explicitly
USE SCHEMA public;


-- +----------------------------------------------------+
-- |             2. CREATE FILE FORMAT                  |
-- +----------------------------------------------------+

-- Create a file format to specify CSV structure
CREATE OR REPLACE FILE FORMAT CSV_SCHEMA_DETECTION
    TYPE = CSV
    SKIP_HEADER = 1
    SKIP_BLANK_LINES = TRUE
    TRIM_SPACE = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

-- +----------------------------------------------------+
-- |             3. CREATE STAGE                        |
-- +----------------------------------------------------+

-- Create a stage to reference external data
CREATE OR REPLACE STAGE FD_S3_INT 
    URL = 's3://demohubpublic/data/'
    DIRECTORY = ( ENABLE = true )
    COMMENT = 'DemoHub S3 datasets';

-- +----------------------------------------------------+
-- |             4. CREATE TABLE STRUCTURES             |
-- +----------------------------------------------------+
CREATE OR REPLACE TABLE customers (
  CUSTOMER_ID         NUMBER,
  CUSTOMER_NAME       STRING,
  CONTACT_NAME        STRING,
  ADDRESS             STRING,
  PHONE_NUMBER        STRING,
  EMAIL               STRING,
  LIFE_TIME_BALANCE   FLOAT,
  COMPLAINTS          STRING
);

-- Device/Product Table
CREATE OR REPLACE TABLE devices (
    DEVICE_ID INT PRIMARY KEY,
    DEVICE_NAME VARCHAR(100),
    MODEL_NUMBER VARCHAR(100),
    SERIAL_NUMBER VARCHAR(100),
    MANUFACTURING_DATE DATE,
    LOT_NUMBER VARCHAR(50),
    TYPE VARCHAR(50),
    SIZE VARCHAR(50),
    CONTAINER VARCHAR(50),
    RETAIL_PRICE DECIMAL(10,2),
    EXPIRATION_DATE DATE
);

CREATE OR REPLACE TABLE sales_order_items (
    ORDER_ID INT,
    ORDER_ITEM_ID INT PRIMARY KEY,
    DEVICE_ID INT,
    QUANTITY NUMBER(38,0),
    EXTENDED_PRICE DECIMAL(12,2),
    DISCOUNT DECIMAL(12,2),
    TAX DECIMAL(12,2),
    RETURN_FLAG VARCHAR(1),
    LINE_STATUS VARCHAR(20),
    SHIP_DATE DATE,
    COMMIT_DATE DATE,
    RECEIPT_DATE DATE,
    SHIP_INSTRUCT VARCHAR(255),
    SHIP_MODE VARCHAR(50),
    ITEM_COMMENT VARCHAR
);

CREATE OR REPLACE TABLE sales_orders (
    ORDER_ID INT PRIMARY KEY,
    CUSTOMER_ID INT,
    ORDER_STATUS VARCHAR(50),
    ORDER_PRICE DECIMAL(12,2),
    ORDER_DATE DATE,
    ORDER_PRIORITY VARCHAR(50),
    SHIP_PRIORITY INT
);

-- +----------------------------------------------------+
-- |             6. COPY DATA INTO TABLES               |
-- +----------------------------------------------------+

-- Load the actual data from the stage into the tables
COPY INTO customers FROM '@FD_S3_INT/orders/customer/'
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1);

COPY INTO devices (
    DEVICE_ID,
    DEVICE_NAME,
    MODEL_NUMBER,
    SERIAL_NUMBER,
    MANUFACTURING_DATE,
    LOT_NUMBER,
    TYPE,
    SIZE,
    CONTAINER,
    RETAIL_PRICE,
    EXPIRATION_DATE
)
FROM '@FD_S3_INT/orders/device/'
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1);

COPY INTO sales_orders FROM '@FD_S3_INT/orders/sales_order/'
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1);

COPY INTO sales_order_items (
    ORDER_ID,
    ORDER_ITEM_ID,
    QUANTITY,
    EXTENDED_PRICE,
    DISCOUNT,
    TAX,
    RETURN_FLAG,
    LINE_STATUS,
    SHIP_DATE,
    COMMIT_DATE,
    RECEIPT_DATE,
    SHIP_INSTRUCT,
    SHIP_MODE,
    ITEM_COMMENT
)
FROM '@FD_S3_INT/orders/sales_order_item/'
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1);

-- +----------------------------------------------------+
-- |             7. ADD COMMENTS AND TAGS               |
-- +----------------------------------------------------+

-- Add comments to tables for better documentation
COMMENT ON TABLE customers IS 'Stores customer information including personal details and contact information';
COMMENT ON TABLE devices IS 'Stores productdevice information including specifications and pricing';
COMMENT ON TABLE sales_orders IS 'Stores order header information including customer, dates, and totals';
COMMENT ON TABLE sales_order_items IS 'Stores order line items including products, quantities, and pricing';

-- Add comments to key columns
COMMENT ON COLUMN customers.CUSTOMER_NAME IS 'Customer full name';
COMMENT ON COLUMN devices.RETAIL_PRICE IS 'Product retail price';
COMMENT ON COLUMN sales_orders.ORDER_STATUS IS 'Current status of the order (Processing, Shipped, Delivered, Cancelled)';
COMMENT ON COLUMN sales_order_items.QUANTITY IS 'Number of units ordered';

-- +----------------------------------------------------+
-- |             8. CREATE TAGS FOR DATA GOVERNANCE     |
-- +----------------------------------------------------+

-- Create tags for Personally Identifiable Information (PII)
CREATE OR REPLACE TAG PII_TAG;
CREATE OR REPLACE TAG PRODUCT_TAG;

-- Apply PII tags to sensitive columns
ALTER TABLE customers ALTER COLUMN CUSTOMER_NAME SET TAG PII_TAG = 'CUSTOMER_NAME';

-- Apply product tags
ALTER TABLE devices ALTER COLUMN DEVICE_NAME SET TAG PRODUCT_TAG = 'DEVICE_NAME';
ALTER TABLE devices ALTER COLUMN TYPE SET TAG PRODUCT_TAG = 'CATEGORY';

-- +----------------------------------------------------+
-- |             9. CREATE VIEWS                       |
-- +----------------------------------------------------+

-- Customer order summary view
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT
    c.CUSTOMER_ID,
    c.CUSTOMER_NAME,
    COUNT(o.ORDER_ID) as total_orders,
    SUM(o.ORDER_PRICE) as total_spent,
    AVG(o.ORDER_PRICE) as avg_order_value,
    MAX(o.ORDER_DATE) as last_order_date
FROM customers c
LEFT JOIN sales_orders o ON c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID, c.CUSTOMER_NAME;

-- Product performance view
CREATE OR REPLACE VIEW product_performance AS
SELECT
    d.DEVICE_ID,
    d.DEVICE_NAME,
    d.TYPE as DEVICE_TYPE,
    COUNT(oi.ORDER_ITEM_ID) as times_ordered,
    SUM(oi.QUANTITY) as total_quantity_sold,
    SUM(oi.EXTENDED_PRICE) as total_revenue
FROM devices d
LEFT JOIN sales_order_items oi ON d.DEVICE_ID = oi.DEVICE_ID
GROUP BY d.DEVICE_ID, d.DEVICE_NAME, d.TYPE
ORDER BY total_revenue DESC;

-- Order details view
CREATE OR REPLACE VIEW order_details AS
SELECT
    o.ORDER_ID,
    c.CUSTOMER_NAME,
    o.ORDER_DATE,
    o.ORDER_STATUS,
    o.ORDER_PRICE,
    LISTAGG(d.DEVICE_NAME, ', ') WITHIN GROUP (ORDER BY d.DEVICE_NAME) as ordered_products,
    COUNT(oi.ORDER_ITEM_ID) as total_items
FROM sales_orders o
JOIN customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN sales_order_items oi ON o.ORDER_ID = oi.ORDER_ID
JOIN devices d ON oi.DEVICE_ID = d.DEVICE_ID
GROUP BY o.ORDER_ID, c.CUSTOMER_NAME, o.ORDER_DATE, o.ORDER_STATUS, o.ORDER_PRICE;

-- +----------------------------------------------------+
-- |             11. SAMPLE QUERIES FOR TESTING         |
-- +----------------------------------------------------+

/*
-- Test query 1: Get customer order summary
SELECT * FROM customer_order_summary
ORDER BY total_spent DESC;
*/

/*
-- Test query 2: Get product performance
-- SELECT * FROM product_performance WHERE total_revenue > 0 ORDER BY total_revenue DESC;
*/

/*
-- Test query 3: Get order details
SELECT * FROM order_details
ORDER BY order_date DESC;
*/
