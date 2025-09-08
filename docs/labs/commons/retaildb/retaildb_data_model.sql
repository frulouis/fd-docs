-- =====================================================
-- RETAILDB - Comprehensive Retail Data Model
-- =====================================================
-- This data model provides a complete retail analytics platform
-- covering customers, products, orders, inventory, and business operations
-- =====================================================

-- Create database and schema
CREATE DATABASE IF NOT EXISTS retaildb;
USE DATABASE retaildb;
CREATE SCHEMA IF NOT EXISTS retail;
USE SCHEMA retail;

-- =====================================================
-- CORE TABLES
-- =====================================================

-- Customer master data
CREATE TABLE customer (
    customer_id VARCHAR(50) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(10),
    preferred_language VARCHAR(10),
    acquisition_source VARCHAR(50),
    acquisition_campaign VARCHAR(100),
    
    -- Location Data
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    timezone VARCHAR(50),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    
    -- Account Details
    registration_date TIMESTAMP_NTZ,
    last_login_date TIMESTAMP_NTZ,
    login_count INTEGER,
    password_last_changed TIMESTAMP_NTZ,
    account_status VARCHAR(20),
    email_verified BOOLEAN,
    phone_verified BOOLEAN,
    two_factor_enabled BOOLEAN,
    
    -- Communication Preferences
    email_subscribed BOOLEAN,
    sms_subscribed BOOLEAN,
    push_notifications_enabled BOOLEAN,
    preferred_contact_method VARCHAR(20),
    
    -- Customer Segments
    lifecycle_stage VARCHAR(20),
    customer_segment VARCHAR(50),
    persona_type VARCHAR(50),
    
    -- Financial Data
    credit_score_range VARCHAR(20),
    preferred_payment_method VARCHAR(50),
    average_order_value DECIMAL(15,2),
    lifetime_value DECIMAL(15,2),
    total_revenue_generated DECIMAL(15,2),
    bad_debt_amount DECIMAL(15,2),
    currency_preference VARCHAR(3),
    
    -- Loyalty Program
    loyalty_tier VARCHAR(20),
    loyalty_points INTEGER,
    points_earned_total INTEGER,
    points_redeemed_total INTEGER,
    tier_qualification_date DATE,
    next_tier_progress DECIMAL(5,2),
    referral_count INTEGER,
    rewards_redeemed_count INTEGER,
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (customer_id)
) COMMENT = 'Customer master data including profile, preferences, and loyalty information';

-- Product master data
CREATE TABLE product (
    product_id VARCHAR(50) NOT NULL,
    sku VARCHAR(100),
    name VARCHAR(255),
    description TEXT,
    brand_id VARCHAR(50),
    manufacturer_id VARCHAR(50),
    model_number VARCHAR(100),
    release_date DATE,
    discontinuation_date DATE,
    
    -- Categorization
    category_id VARCHAR(50),
    subcategory_id VARCHAR(50),
    product_type VARCHAR(50),
    tags ARRAY,
    search_keywords ARRAY,
    
    -- Pricing
    base_price DECIMAL(15,2),
    cost_price DECIMAL(15,2),
    msrp DECIMAL(15,2),
    map_price DECIMAL(15,2),
    bulk_pricing_tiers VARIANT,
    price_history VARIANT,
    margin_percentage DECIMAL(5,2),
    discount_eligible BOOLEAN,
    
    -- Tax & Regulatory
    tax_category VARCHAR(50),
    tax_rate DECIMAL(5,2),
    harmonized_code VARCHAR(20),
    country_of_origin VARCHAR(50),
    regulatory_certificates ARRAY,
    
    -- Physical Attributes
    weight_kg DECIMAL(10,3),
    length_cm DECIMAL(10,2),
    width_cm DECIMAL(10,2),
    height_cm DECIMAL(10,2),
    color VARCHAR(50),
    materials ARRAY,
    package_type VARCHAR(50),
    
    -- Inventory Management
    stock_level INTEGER,
    reorder_point INTEGER,
    economic_order_quantity INTEGER,
    lead_time_days INTEGER,
    safety_stock_level INTEGER,
    abc_classification VARCHAR(10),
    inventory_turnover_ratio DECIMAL(10,2),
    seasonal_flag BOOLEAN,
    
    -- Performance Metrics
    average_rating DECIMAL(3,2),
    review_count INTEGER,
    view_count INTEGER,
    conversion_rate DECIMAL(5,2),
    add_to_cart_rate DECIMAL(5,2),
    stockout_frequency DECIMAL(5,2),
    return_rate DECIMAL(5,2),
    defect_rate DECIMAL(5,2),
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (product_id)
) COMMENT = 'Product master data including attributes, pricing, and performance metrics';

-- Order master data
CREATE TABLE "order" (
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50),
    order_date TIMESTAMP_NTZ,
    order_source VARCHAR(50),
    channel VARCHAR(50),
    
    -- Status Information
    status VARCHAR(50),
    status_history VARIANT,
    estimated_delivery_date DATE,
    actual_delivery_date DATE,
    delivery_attempts INTEGER,
    
    -- Financial Details
    subtotal DECIMAL(15,2),
    tax_amount DECIMAL(15,2),
    shipping_cost DECIMAL(15,2),
    handling_cost DECIMAL(15,2),
    insurance_cost DECIMAL(15,2),
    discount_amount DECIMAL(15,2),
    total_amount DECIMAL(15,2),
    currency VARCHAR(3),
    exchange_rate DECIMAL(10,6),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    payment_attempts INTEGER,
    refund_amount DECIMAL(15,2),
    chargeback_amount DECIMAL(15,2),
    
    -- Items Details
    total_items INTEGER,
    total_quantity INTEGER,
    distinct_items INTEGER,
    average_item_price DECIMAL(15,2),
    highest_priced_item DECIMAL(15,2),
    weight_total_kg DECIMAL(10,3),
    
    -- Fulfillment
    warehouse_id VARCHAR(50),
    shipping_carrier VARCHAR(50),
    shipping_method VARCHAR(50),
    tracking_number VARCHAR(100),
    shipping_zone VARCHAR(50),
    handling_time_minutes INTEGER,
    processing_time_minutes INTEGER,
    
    -- Customer Interaction
    cart_creation_date TIMESTAMP_NTZ,
    checkout_start_date TIMESTAMP_NTZ,
    checkout_completion_date TIMESTAMP_NTZ,
    abandonment_date TIMESTAMP_NTZ,
    cart_recovery_email_sent BOOLEAN,
    customer_notes TEXT,
    gift_wrap BOOLEAN,
    gift_message TEXT,
    
    -- Marketing Attribution
    utm_source VARCHAR(100),
    utm_medium VARCHAR(100),
    utm_campaign VARCHAR(100),
    coupon_code VARCHAR(50),
    promotion_ids ARRAY,
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
) COMMENT = 'Order master data including financial details and fulfillment information';

-- Order items detail
CREATE TABLE order_item (
    order_item_id VARCHAR(50) NOT NULL,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INTEGER,
    unit_price DECIMAL(15,2),
    total_price DECIMAL(15,2),
    discount_amount DECIMAL(15,2),
    tax_amount DECIMAL(15,2),
    shipping_cost DECIMAL(15,2),
    weight_kg DECIMAL(10,3),
    
    -- Product details at time of order
    product_name VARCHAR(255),
    product_sku VARCHAR(100),
    product_category VARCHAR(100),
    product_brand VARCHAR(100),
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (order_item_id),
    FOREIGN KEY (order_id) REFERENCES "order"(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
) COMMENT = 'Order line items with product details at time of purchase';

-- Store locations
CREATE TABLE store (
    store_id VARCHAR(50) NOT NULL,
    store_name VARCHAR(255),
    store_type VARCHAR(50),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(255),
    
    -- Location data
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    timezone VARCHAR(50),
    region VARCHAR(50),
    district VARCHAR(50),
    
    -- Store details
    square_footage INTEGER,
    opening_date DATE,
    closing_date DATE,
    store_manager VARCHAR(100),
    store_status VARCHAR(20),
    
    -- Performance metrics
    daily_sales_target DECIMAL(15,2),
    monthly_sales_target DECIMAL(15,2),
    year_to_date_sales DECIMAL(15,2),
    customer_satisfaction_score DECIMAL(3,2),
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (store_id)
) COMMENT = 'Store locations and performance data';

-- Inventory tracking
CREATE TABLE inventory (
    inventory_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50),
    store_id VARCHAR(50),
    warehouse_id VARCHAR(50),
    location_type VARCHAR(20),
    
    -- Stock levels
    current_stock INTEGER,
    available_stock INTEGER,
    reserved_stock INTEGER,
    damaged_stock INTEGER,
    expired_stock INTEGER,
    
    -- Inventory management
    reorder_point INTEGER,
    reorder_quantity INTEGER,
    lead_time_days INTEGER,
    safety_stock INTEGER,
    max_stock_level INTEGER,
    
    -- Cost tracking
    average_cost DECIMAL(15,2),
    last_cost DECIMAL(15,2),
    total_cost DECIMAL(15,2),
    
    -- Movement tracking
    last_received_date DATE,
    last_sold_date DATE,
    last_adjusted_date DATE,
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (inventory_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
) COMMENT = 'Inventory tracking across stores and warehouses';

-- =====================================================
-- SUPPORTING TABLES
-- =====================================================

-- Categories hierarchy
CREATE TABLE category (
    category_id VARCHAR(50) NOT NULL,
    parent_category_id VARCHAR(50),
    category_name VARCHAR(100),
    category_description TEXT,
    category_level INTEGER,
    sort_order INTEGER,
    is_active BOOLEAN,
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (category_id),
    FOREIGN KEY (parent_category_id) REFERENCES category(category_id)
) COMMENT = 'Product category hierarchy';

-- Brands
CREATE TABLE brand (
    brand_id VARCHAR(50) NOT NULL,
    brand_name VARCHAR(100),
    brand_description TEXT,
    website_url VARCHAR(255),
    logo_url VARCHAR(255),
    is_active BOOLEAN,
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (brand_id)
) COMMENT = 'Product brands and manufacturers';

-- Promotions and discounts
CREATE TABLE promotion (
    promotion_id VARCHAR(50) NOT NULL,
    promotion_name VARCHAR(255),
    promotion_description TEXT,
    promotion_type VARCHAR(50),
    discount_type VARCHAR(20),
    discount_value DECIMAL(10,2),
    discount_percentage DECIMAL(5,2),
    
    -- Validity
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN,
    
    -- Usage limits
    max_uses INTEGER,
    max_uses_per_customer INTEGER,
    current_uses INTEGER,
    
    -- Applicability
    applicable_products ARRAY,
    applicable_categories ARRAY,
    applicable_customers ARRAY,
    minimum_order_value DECIMAL(15,2),
    
    -- Audit fields
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    
    PRIMARY KEY (promotion_id)
) COMMENT = 'Promotions and discount campaigns';

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Insert sample categories
INSERT INTO category (category_id, parent_category_id, category_name, category_description, category_level, sort_order, is_active) VALUES
('CAT001', NULL, 'Electronics', 'Electronic devices and accessories', 1, 1, TRUE),
('CAT002', 'CAT001', 'Smartphones', 'Mobile phones and accessories', 2, 1, TRUE),
('CAT003', 'CAT001', 'Laptops', 'Portable computers', 2, 2, TRUE),
('CAT004', NULL, 'Clothing', 'Apparel and fashion items', 1, 2, TRUE),
('CAT005', 'CAT004', 'Men''s Clothing', 'Clothing for men', 2, 1, TRUE),
('CAT006', 'CAT004', 'Women''s Clothing', 'Clothing for women', 2, 2, TRUE);

-- Insert sample brands
INSERT INTO brand (brand_id, brand_name, brand_description, website_url, logo_url, is_active) VALUES
('BRAND001', 'TechCorp', 'Leading technology manufacturer', 'https://techcorp.com', 'https://techcorp.com/logo.png', TRUE),
('BRAND002', 'FashionStyle', 'Premium fashion brand', 'https://fashionstyle.com', 'https://fashionstyle.com/logo.png', TRUE),
('BRAND003', 'HomeGoods', 'Home and lifestyle products', 'https://homegoods.com', 'https://homegoods.com/logo.png', TRUE);

-- Insert sample customers
INSERT INTO customer (customer_id, email, phone, first_name, last_name, date_of_birth, gender, preferred_language, acquisition_source, acquisition_campaign, street, city, state, postal_code, country, timezone, latitude, longitude, registration_date, last_login_date, login_count, account_status, email_verified, phone_verified, two_factor_enabled, email_subscribed, sms_subscribed, push_notifications_enabled, preferred_contact_method, lifecycle_stage, customer_segment, persona_type, credit_score_range, preferred_payment_method, average_order_value, lifetime_value, total_revenue_generated, loyalty_tier, loyalty_points, points_earned_total, points_redeemed_total, tier_qualification_date, next_tier_progress, referral_count, rewards_redeemed_count) VALUES
('CUST001', 'john.doe@email.com', '+1-555-0101', 'John', 'Doe', '1985-03-15', 'Male', 'EN', 'Search', 'Google Ads Q1', '123 Main St', 'New York', 'NY', '10001', 'USA', 'America/New_York', 40.7128, -74.0060, '2023-01-15 10:30:00', '2024-01-15 14:20:00', 45, 'Active', TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, 'Email', 'Active', 'High Value', 'Tech Enthusiast', 'Good', 'Credit Card', 150.00, 2500.00, 2500.00, 'Gold', 1250, 2000, 750, '2023-06-15', 75.5, 3, 5),
('CUST002', 'jane.smith@email.com', '+1-555-0102', 'Jane', 'Smith', '1990-07-22', 'Female', 'EN', 'Social', 'Facebook Campaign', '456 Oak Ave', 'Los Angeles', 'CA', '90210', 'USA', 'America/Los_Angeles', 34.0522, -118.2437, '2023-02-20 09:15:00', '2024-01-14 16:45:00', 32, 'Active', TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, 'SMS', 'Active', 'Price Sensitive', 'Fashion Forward', 'Fair', 'PayPal', 85.00, 1200.00, 1200.00, 'Silver', 800, 1200, 400, '2023-08-20', 60.0, 1, 2),
('CUST003', 'mike.wilson@email.com', '+1-555-0103', 'Mike', 'Wilson', '1978-11-08', 'Male', 'EN', 'Referral', 'Customer Referral Program', '789 Pine St', 'Chicago', 'IL', '60601', 'USA', 'America/Chicago', 41.8781, -87.6298, '2023-03-10 11:00:00', '2024-01-10 12:30:00', 18, 'Active', TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, 'SMS', 'At Risk', 'Mid Value', 'Busy Professional', 'Good', 'Credit Card', 200.00, 1800.00, 1800.00, 'Silver', 600, 1000, 400, '2023-09-10', 40.0, 0, 3);

-- Insert sample products
INSERT INTO product (product_id, sku, name, description, brand_id, manufacturer_id, model_number, release_date, category_id, subcategory_id, product_type, tags, search_keywords, base_price, cost_price, msrp, map_price, margin_percentage, discount_eligible, tax_category, tax_rate, weight_kg, length_cm, width_cm, height_cm, color, materials, package_type, stock_level, reorder_point, economic_order_quantity, lead_time_days, safety_stock_level, abc_classification, inventory_turnover_ratio, seasonal_flag, average_rating, review_count, view_count, conversion_rate, add_to_cart_rate, stockout_frequency, return_rate, defect_rate) VALUES
('PROD001', 'SMART-001', 'TechCorp Galaxy Phone', 'Latest smartphone with advanced features', 'BRAND001', 'BRAND001', 'TC-GP-2024', '2024-01-01', 'CAT002', 'CAT002', 'Smartphone', ARRAY_CONSTRUCT('5G', 'Camera', 'Battery'), ARRAY_CONSTRUCT('phone', 'smartphone', 'mobile', '5G'), 899.99, 450.00, 999.99, 899.99, 50.0, TRUE, 'Electronics', 8.5, 0.180, 15.0, 7.5, 0.8, 'Black', ARRAY_CONSTRUCT('Glass', 'Aluminum'), 'Box', 150, 20, 50, 14, 10, 'A', 12.5, FALSE, 4.5, 1250, 8500, 3.2, 8.5, 2.1, 1.5, 0.5),
('PROD002', 'LAPTOP-001', 'TechCorp Ultra Laptop', 'High-performance laptop for professionals', 'BRAND001', 'BRAND001', 'TC-UL-2024', '2024-01-15', 'CAT003', 'CAT003', 'Laptop', ARRAY_CONSTRUCT('Performance', 'Battery', 'Display'), ARRAY_CONSTRUCT('laptop', 'computer', 'ultrabook', 'performance'), 1299.99, 650.00, 1499.99, 1299.99, 50.0, TRUE, 'Electronics', 8.5, 1.500, 32.0, 22.0, 1.5, 'Silver', ARRAY_CONSTRUCT('Aluminum', 'Plastic'), 'Box', 75, 15, 25, 21, 8, 'A', 8.2, FALSE, 4.7, 890, 6200, 4.1, 9.2, 1.8, 1.2, 0.3),
('PROD003', 'SHIRT-001', 'FashionStyle Men''s Shirt', 'Premium cotton dress shirt', 'BRAND002', 'BRAND002', 'FS-MS-2024', '2024-01-01', 'CAT005', 'CAT005', 'Shirt', ARRAY_CONSTRUCT('Cotton', 'Dress', 'Formal'), ARRAY_CONSTRUCT('shirt', 'dress shirt', 'cotton', 'formal'), 89.99, 35.00, 99.99, 89.99, 61.1, TRUE, 'Clothing', 7.0, 0.250, 30.0, 20.0, 0.5, 'Blue', ARRAY_CONSTRUCT('Cotton'), 'Plastic Bag', 300, 50, 100, 7, 25, 'B', 15.8, FALSE, 4.3, 450, 3200, 2.8, 6.5, 3.2, 2.1, 0.8);

-- Insert sample stores
INSERT INTO store (store_id, store_name, store_type, address_line1, address_line2, city, state, postal_code, country, phone, email, latitude, longitude, timezone, region, district, square_footage, opening_date, store_manager, store_status, daily_sales_target, monthly_sales_target, year_to_date_sales, customer_satisfaction_score) VALUES
('STORE001', 'TechCorp NYC Flagship', 'Flagship', '123 Tech Street', 'Floor 1', 'New York', 'NY', '10001', 'USA', '+1-555-1001', 'nyc@techcorp.com', 40.7128, -74.0060, 'America/New_York', 'Northeast', 'Manhattan', 5000, '2020-01-15', 'Sarah Johnson', 'Active', 15000.00, 450000.00, 5200000.00, 4.6),
('STORE002', 'TechCorp LA Store', 'Standard', '456 Innovation Blvd', NULL, 'Los Angeles', 'CA', '90210', 'USA', '+1-555-1002', 'la@techcorp.com', 34.0522, -118.2437, 'America/Los_Angeles', 'West', 'Beverly Hills', 3500, '2021-03-20', 'Michael Chen', 'Active', 12000.00, 360000.00, 4200000.00, 4.4),
('STORE003', 'TechCorp Chicago Store', 'Standard', '789 Tech Plaza', 'Suite 100', 'Chicago', 'IL', '60601', 'USA', '+1-555-1003', 'chicago@techcorp.com', 41.8781, -87.6298, 'America/Chicago', 'Midwest', 'Loop', 4000, '2021-06-10', 'David Wilson', 'Active', 13500.00, 405000.00, 4800000.00, 4.5);

-- Insert sample orders
INSERT INTO "order" (order_id, customer_id, order_date, order_source, channel, status, subtotal, tax_amount, shipping_cost, discount_amount, total_amount, currency, payment_method, payment_status, total_items, total_quantity, distinct_items, average_item_price, weight_total_kg, warehouse_id, shipping_carrier, shipping_method, tracking_number, cart_creation_date, checkout_start_date, checkout_completion_date, utm_source, utm_medium, utm_campaign) VALUES
('ORD001', 'CUST001', '2024-01-15 14:30:00', 'Web', 'Direct', 'Delivered', 899.99, 76.50, 15.00, 50.00, 941.49, 'USD', 'Credit Card', 'Paid', 1, 1, 1, 899.99, 0.180, 'WH001', 'FedEx', 'Ground', 'FDX123456789', '2024-01-15 14:25:00', '2024-01-15 14:28:00', '2024-01-15 14:30:00', 'google', 'cpc', 'Q1_Campaign'),
('ORD002', 'CUST002', '2024-01-16 10:15:00', 'Mobile App', 'Direct', 'Shipped', 1299.99, 110.50, 0.00, 100.00, 1310.49, 'USD', 'PayPal', 'Paid', 1, 1, 1, 1299.99, 1.500, 'WH002', 'UPS', '2-Day', 'UPS987654321', '2024-01-16 10:10:00', '2024-01-16 10:12:00', '2024-01-16 10:15:00', 'facebook', 'social', 'Mobile_App_Promo'),
('ORD003', 'CUST003', '2024-01-17 16:45:00', 'Web', 'Direct', 'Processing', 89.99, 6.30, 8.00, 0.00, 104.29, 'USD', 'Credit Card', 'Paid', 1, 1, 1, 89.99, 0.250, 'WH001', 'USPS', 'Standard', 'USPS456789123', '2024-01-17 16:40:00', '2024-01-17 16:42:00', '2024-01-17 16:45:00', 'direct', 'none', 'Direct_Traffic');

-- Insert sample order items
INSERT INTO order_item (order_item_id, order_id, product_id, quantity, unit_price, total_price, discount_amount, tax_amount, shipping_cost, weight_kg, product_name, product_sku, product_category, product_brand) VALUES
('OI001', 'ORD001', 'PROD001', 1, 899.99, 899.99, 50.00, 76.50, 15.00, 0.180, 'TechCorp Galaxy Phone', 'SMART-001', 'Smartphones', 'TechCorp'),
('OI002', 'ORD002', 'PROD002', 1, 1299.99, 1299.99, 100.00, 110.50, 0.00, 1.500, 'TechCorp Ultra Laptop', 'LAPTOP-001', 'Laptops', 'TechCorp'),
('OI003', 'ORD003', 'PROD003', 1, 89.99, 89.99, 0.00, 6.30, 8.00, 0.250, 'FashionStyle Men''s Shirt', 'SHIRT-001', 'Men''s Clothing', 'FashionStyle');

-- Insert sample inventory
INSERT INTO inventory (inventory_id, product_id, store_id, warehouse_id, location_type, current_stock, available_stock, reserved_stock, damaged_stock, expired_stock, reorder_point, reorder_quantity, lead_time_days, safety_stock, max_stock_level, average_cost, last_cost, total_cost) VALUES
('INV001', 'PROD001', 'STORE001', 'WH001', 'Store', 120, 115, 5, 0, 0, 20, 50, 14, 10, 200, 450.00, 450.00, 54000.00),
('INV002', 'PROD001', NULL, 'WH001', 'Warehouse', 30, 30, 0, 0, 0, 10, 25, 14, 5, 100, 450.00, 450.00, 13500.00),
('INV003', 'PROD002', 'STORE002', 'WH002', 'Store', 60, 58, 2, 0, 0, 15, 25, 21, 8, 150, 650.00, 650.00, 39000.00),
('INV004', 'PROD003', 'STORE003', 'WH001', 'Store', 250, 245, 5, 0, 0, 50, 100, 7, 25, 500, 35.00, 35.00, 8750.00);

-- =====================================================
-- VIEWS
-- =====================================================

-- Customer analytics view
CREATE VIEW customer_analytics AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.customer_segment,
    c.lifecycle_stage,
    c.loyalty_tier,
    c.lifetime_value,
    c.average_order_value,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent,
    AVG(o.total_amount) as avg_order_value,
    MAX(o.order_date) as last_order_date,
    DATEDIFF('day', MAX(o.order_date), CURRENT_DATE()) as days_since_last_order,
    c.loyalty_points,
    c.referral_count
FROM customer c
LEFT JOIN "order" o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.customer_segment, 
         c.lifecycle_stage, c.loyalty_tier, c.lifetime_value, c.average_order_value,
         c.loyalty_points, c.referral_count;

-- Product performance view
CREATE VIEW product_performance AS
SELECT 
    p.product_id,
    p.name,
    p.sku,
    p.category_id,
    c.category_name,
    p.brand_id,
    b.brand_name,
    p.base_price,
    p.cost_price,
    p.margin_percentage,
    p.stock_level,
    p.average_rating,
    p.review_count,
    p.view_count,
    p.conversion_rate,
    p.return_rate,
    COUNT(oi.order_item_id) as times_ordered,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.total_price) as total_revenue,
    AVG(oi.unit_price) as avg_selling_price
FROM product p
LEFT JOIN category c ON p.category_id = c.category_id
LEFT JOIN brand b ON p.brand_id = b.brand_id
LEFT JOIN order_item oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name, p.sku, p.category_id, c.category_name, p.brand_id, 
         b.brand_name, p.base_price, p.cost_price, p.margin_percentage, p.stock_level,
         p.average_rating, p.review_count, p.view_count, p.conversion_rate, p.return_rate;

-- Sales analytics view
CREATE VIEW sales_analytics AS
SELECT 
    o.order_id,
    o.order_date,
    o.customer_id,
    c.first_name,
    c.last_name,
    c.customer_segment,
    o.order_source,
    o.channel,
    o.status,
    o.subtotal,
    o.tax_amount,
    o.shipping_cost,
    o.discount_amount,
    o.total_amount,
    o.total_items,
    o.total_quantity,
    o.payment_method,
    o.payment_status,
    o.utm_source,
    o.utm_medium,
    o.utm_campaign,
    DATEDIFF('day', o.cart_creation_date, o.checkout_completion_date) as days_to_purchase
FROM "order" o
JOIN customer c ON o.customer_id = c.customer_id;

-- Inventory analytics view
CREATE VIEW inventory_analytics AS
SELECT 
    i.inventory_id,
    i.product_id,
    p.name as product_name,
    p.sku,
    i.store_id,
    s.store_name,
    i.location_type,
    i.current_stock,
    i.available_stock,
    i.reserved_stock,
    i.damaged_stock,
    i.expired_stock,
    i.reorder_point,
    i.safety_stock,
    i.max_stock_level,
    i.average_cost,
    (i.current_stock * i.average_cost) as inventory_value,
    CASE 
        WHEN i.current_stock <= i.reorder_point THEN 'Reorder Needed'
        WHEN i.current_stock <= i.safety_stock THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END as stock_status
FROM inventory i
JOIN product p ON i.product_id = p.product_id
LEFT JOIN store s ON i.store_id = s.store_id;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Calculate customer lifetime value
CREATE OR REPLACE PROCEDURE calculate_customer_lifetime_value()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    UPDATE customer 
    SET lifetime_value = (
        SELECT COALESCE(SUM(total_amount), 0)
        FROM "order" 
        WHERE customer_id = customer.customer_id
    );
    
    RETURN 'Customer lifetime values updated successfully';
END;
$$;

-- Update inventory levels
CREATE OR REPLACE PROCEDURE update_inventory_levels()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    UPDATE inventory 
    SET current_stock = available_stock + reserved_stock,
        updated_at = CURRENT_TIMESTAMP();
    
    RETURN 'Inventory levels updated successfully';
END;
$$;

-- Generate reorder recommendations
CREATE OR REPLACE PROCEDURE generate_reorder_recommendations()
RETURNS TABLE(product_id STRING, product_name STRING, current_stock INTEGER, reorder_point INTEGER, recommended_quantity INTEGER)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            i.product_id,
            p.name as product_name,
            i.current_stock,
            i.reorder_point,
            i.reorder_quantity as recommended_quantity
        FROM inventory i
        JOIN product p ON i.product_id = p.product_id
        WHERE i.current_stock <= i.reorder_point
        AND i.location_type = 'Store'
    );
END;
$$;

-- =====================================================
-- DATA GOVERNANCE TAGS
-- =====================================================

-- Apply data governance tags
ALTER TABLE customer SET TAG data_owner = 'Marketing Team';
ALTER TABLE customer SET TAG data_classification = 'PII';
ALTER TABLE customer SET TAG retention_policy = '7 Years';

ALTER TABLE product SET TAG data_owner = 'Product Team';
ALTER TABLE product SET TAG data_classification = 'Business Data';
ALTER TABLE product SET TAG retention_policy = '10 Years';

ALTER TABLE "order" SET TAG data_owner = 'Sales Team';
ALTER TABLE "order" SET TAG data_classification = 'Financial Data';
ALTER TABLE "order" SET TAG retention_policy = '7 Years';

ALTER TABLE inventory SET TAG data_owner = 'Operations Team';
ALTER TABLE inventory SET TAG data_classification = 'Operational Data';
ALTER TABLE inventory SET TAG retention_policy = '5 Years';

-- =====================================================
-- CLEANUP SCRIPTS
-- =====================================================

-- Cleanup function for old data
CREATE OR REPLACE PROCEDURE cleanup_old_data(days_to_keep INTEGER)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Delete old orders (example: older than specified days)
    DELETE FROM order_item 
    WHERE order_id IN (
        SELECT order_id 
        FROM "order" 
        WHERE order_date < DATEADD(day, -days_to_keep, CURRENT_DATE())
    );
    
    DELETE FROM "order" 
    WHERE order_date < DATEADD(day, -days_to_keep, CURRENT_DATE());
    
    RETURN 'Old data cleanup completed';
END;
$$; 