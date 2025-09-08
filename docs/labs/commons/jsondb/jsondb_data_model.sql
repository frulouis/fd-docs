-- =====================================================
-- JSONDB - Advanced JSON Data Model
-- Specialized JSON model for Snowflake demonstrations
-- Version: 1.0.0
-- Last Updated: December 2024
-- =====================================================

-- Create database and schema
CREATE OR REPLACE DATABASE JSONDB;
USE DATABASE JSONDB;
CREATE OR REPLACE SCHEMA json_data;

-- =====================================================
-- TABLES WITH ADVANCED JSON FEATURES
-- =====================================================

-- E-commerce orders with complex JSON structure
CREATE OR REPLACE TABLE json_data.ecommerce_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP_NTZ,
    -- Complex JSON order data
    order_details VARIANT,
    -- JSON customer information
    customer_info VARIANT,
    -- JSON shipping information
    shipping_info VARIANT,
    -- JSON payment information
    payment_info VARIANT,
    -- JSON order status and tracking
    order_status VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Product catalog with nested JSON attributes
CREATE OR REPLACE TABLE json_data.product_catalog (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200),
    category VARCHAR(100),
    -- JSON product specifications
    specifications VARIANT,
    -- JSON pricing information
    pricing VARIANT,
    -- JSON inventory data
    inventory VARIANT,
    -- JSON product reviews and ratings
    reviews VARIANT,
    -- JSON product metadata
    product_metadata VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- User profiles with flexible JSON structure
CREATE OR REPLACE TABLE json_data.user_profiles (
    user_id INT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(200),
    -- JSON profile information
    profile_data VARIANT,
    -- JSON preferences and settings
    preferences VARIANT,
    -- JSON activity history
    activity_history VARIANT,
    -- JSON social connections
    social_connections VARIANT,
    -- JSON device information
    device_info VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- API logs with JSON request/response data
CREATE OR REPLACE TABLE json_data.api_logs (
    log_id INT PRIMARY KEY,
    api_endpoint VARCHAR(200),
    http_method VARCHAR(10),
    -- JSON request data
    request_data VARIANT,
    -- JSON response data
    response_data VARIANT,
    -- JSON headers and metadata
    headers VARIANT,
    -- JSON performance metrics
    performance_metrics VARIANT,
    -- JSON error information
    error_info VARIANT,
    timestamp TIMESTAMP_NTZ,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Configuration management with JSON schemas
CREATE OR REPLACE TABLE json_data.configurations (
    config_id INT PRIMARY KEY,
    config_name VARCHAR(100),
    config_type VARCHAR(50),
    -- JSON configuration data
    config_data VARIANT,
    -- JSON validation rules
    validation_rules VARIANT,
    -- JSON dependencies
    dependencies VARIANT,
    -- JSON version information
    version_info VARIANT,
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SAMPLE DATA WITH COMPLEX JSON STRUCTURES
-- =====================================================

-- Insert e-commerce orders with complex JSON
INSERT INTO json_data.ecommerce_orders (order_id, customer_id, order_date, order_details, customer_info, shipping_info, payment_info, order_status) VALUES
(1, 1001, '2024-12-01 10:00:00'::TIMESTAMP_NTZ,
PARSE_JSON('{"items": [{"product_id": 101, "name": "iPhone 15 Pro", "quantity": 1, "unit_price": 999.99, "total_price": 999.99, "specifications": {"color": "Titanium", "storage": "256GB", "carrier": "Unlocked"}}, {"product_id": 102, "name": "AirPods Pro", "quantity": 1, "unit_price": 249.99, "total_price": 249.99, "specifications": {"color": "White", "generation": "2nd"}}], "subtotal": 1249.98, "tax": 124.99, "total": 1374.97, "currency": "USD", "discount_applied": {"code": "SAVE10", "amount": 124.99}}'),
PARSE_JSON('{"customer_id": 1001, "name": "John Smith", "email": "john.smith@email.com", "phone": "+1-555-0123", "address": {"street": "123 Main St", "city": "San Francisco", "state": "CA", "zip": "94102", "country": "USA"}, "preferences": {"newsletter": true, "marketing_emails": false, "language": "en"}}'),
PARSE_JSON('{"shipping_method": "Express", "carrier": "FedEx", "tracking_number": "FX123456789", "estimated_delivery": "2024-12-03", "shipping_address": {"street": "123 Main St", "city": "San Francisco", "state": "CA", "zip": "94102", "country": "USA"}, "shipping_cost": 15.99, "insurance": true}'),
PARSE_JSON('{"payment_method": "credit_card", "card_type": "Visa", "last_four": "1234", "billing_address": {"street": "123 Main St", "city": "San Francisco", "state": "CA", "zip": "94102", "country": "USA"}, "transaction_id": "TXN123456", "authorization_code": "AUTH789", "payment_status": "completed"}'),
PARSE_JSON('{"status": "processing", "status_history": [{"status": "ordered", "timestamp": "2024-12-01T10:00:00Z", "notes": "Order placed"}, {"status": "processing", "timestamp": "2024-12-01T10:05:00Z", "notes": "Payment confirmed"}], "estimated_completion": "2024-12-01T18:00:00Z", "priority": "normal"}')),

(2, 1002, '2024-12-01 11:30:00'::TIMESTAMP_NTZ,
PARSE_JSON('{"items": [{"product_id": 103, "name": "MacBook Air M2", "quantity": 1, "unit_price": 1199.99, "total_price": 1199.99, "specifications": {"color": "Space Gray", "storage": "512GB", "memory": "16GB"}}, {"product_id": 104, "name": "Magic Mouse", "quantity": 1, "unit_price": 79.99, "total_price": 79.99, "specifications": {"color": "White", "connectivity": "Bluetooth"}}], "subtotal": 1279.98, "tax": 127.99, "total": 1407.97, "currency": "USD", "discount_applied": null}'),
PARSE_JSON('{"customer_id": 1002, "name": "Sarah Johnson", "email": "sarah.j@email.com", "phone": "+1-555-0456", "address": {"street": "456 Oak Ave", "city": "Los Angeles", "state": "CA", "zip": "90210", "country": "USA"}, "preferences": {"newsletter": true, "marketing_emails": true, "language": "en"}}'),
PARSE_JSON('{"shipping_method": "Standard", "carrier": "UPS", "tracking_number": "UP987654321", "estimated_delivery": "2024-12-05", "shipping_address": {"street": "456 Oak Ave", "city": "Los Angeles", "state": "CA", "zip": "90210", "country": "USA"}, "shipping_cost": 9.99, "insurance": false}'),
PARSE_JSON('{"payment_method": "paypal", "paypal_email": "sarah.j@email.com", "transaction_id": "PPY789012", "payment_status": "completed", "billing_address": {"street": "456 Oak Ave", "city": "Los Angeles", "state": "CA", "zip": "90210", "country": "USA"}}'),
PARSE_JSON('{"status": "shipped", "status_history": [{"status": "ordered", "timestamp": "2024-12-01T11:30:00Z"}, {"status": "processing", "timestamp": "2024-12-01T12:00:00Z"}, {"status": "shipped", "timestamp": "2024-12-01T14:30:00Z"}], "estimated_completion": "2024-12-05T17:00:00Z", "priority": "normal"}'));

-- Insert product catalog with nested JSON
INSERT INTO json_data.product_catalog (product_id, product_name, category, specifications, pricing, inventory, reviews, product_metadata) VALUES
(101, 'iPhone 15 Pro', 'Smartphones',
PARSE_JSON('{"display": {"size": "6.1 inches", "resolution": "2556x1179", "technology": "OLED", "refresh_rate": "120Hz"}, "processor": {"name": "A17 Pro", "cores": 6, "architecture": "3nm"}, "camera": {"main": "48MP", "ultra_wide": "12MP", "telephoto": "12MP", "front": "12MP"}, "battery": {"capacity": "3274mAh", "fast_charging": "20W", "wireless_charging": true}, "connectivity": {"5g": true, "wifi": "Wi-Fi 6E", "bluetooth": "5.3"}, "dimensions": {"height": "147.6mm", "width": "71.6mm", "depth": "8.25mm", "weight": "187g"}}'),
PARSE_JSON('{"base_price": 999.99, "currency": "USD", "discounts": [{"type": "student", "amount": 50.00}, {"type": "trade_in", "amount": 200.00}], "financing": {"available": true, "months": 24, "monthly_payment": 41.67}, "warranty": {"length": "1 year", "extended_available": true, "extended_cost": 99.99}}'),
PARSE_JSON('{"warehouse_stock": 150, "store_stock": {"store_001": 25, "store_002": 30, "store_003": 20}, "reserved": 15, "on_order": 200, "supplier": {"name": "Apple Inc", "lead_time_days": 7, "minimum_order": 50}, "reorder_point": 50, "max_stock": 500}'),
PARSE_JSON('{"average_rating": 4.8, "total_reviews": 1250, "rating_distribution": {"5_star": 850, "4_star": 300, "3_star": 80, "2_star": 15, "1_star": 5}, "recent_reviews": [{"user": "tech_lover", "rating": 5, "comment": "Amazing camera quality!", "date": "2024-11-30"}, {"user": "mobile_user", "rating": 4, "comment": "Great phone, but expensive", "date": "2024-11-29"}]}'),
PARSE_JSON('{"brand": "Apple", "model": "iPhone 15 Pro", "sku": "IP15P-256-TI", "upc": "123456789012", "tags": ["smartphone", "5g", "camera", "premium"], "seo_keywords": ["iPhone", "smartphone", "5G", "camera"], "launch_date": "2024-09-22", "discontinued": false}')),

(102, 'AirPods Pro', 'Audio',
PARSE_JSON('{"audio": {"driver_type": "Dynamic", "frequency_response": "20Hz-20kHz", "noise_cancellation": true, "transparency_mode": true}, "connectivity": {"bluetooth": "5.3", "codec": "AAC", "range": "30m"}, "battery": {"earbuds": "6 hours", "case": "30 hours", "charging": "USB-C", "wireless_charging": true}, "features": {"water_resistance": "IPX4", "sweat_resistance": true, "voice_control": true}, "dimensions": {"earbuds": {"height": "30.9mm", "width": "21.8mm", "depth": "24.0mm"}, "case": {"height": "45.2mm", "width": "60.6mm", "depth": "21.7mm"}}}'),
PARSE_JSON('{"base_price": 249.99, "currency": "USD", "discounts": [{"type": "bundle", "amount": 20.00}], "financing": {"available": true, "months": 12, "monthly_payment": 20.83}, "warranty": {"length": "1 year", "extended_available": true, "extended_cost": 29.99}}'),
PARSE_JSON('{"warehouse_stock": 300, "store_stock": {"store_001": 50, "store_002": 45, "store_003": 40}, "reserved": 25, "on_order": 150, "supplier": {"name": "Apple Inc", "lead_time_days": 5, "minimum_order": 100}, "reorder_point": 100, "max_stock": 1000}'),
PARSE_JSON('{"average_rating": 4.6, "total_reviews": 890, "rating_distribution": {"5_star": 600, "4_star": 200, "3_star": 60, "2_star": 20, "1_star": 10}, "recent_reviews": [{"user": "music_lover", "rating": 5, "comment": "Best wireless earbuds ever!", "date": "2024-11-30"}, {"user": "commuter", "rating": 4, "comment": "Great noise cancellation", "date": "2024-11-28"}]}'),
PARSE_JSON('{"brand": "Apple", "model": "AirPods Pro", "sku": "APP-2ND-GEN", "upc": "123456789013", "tags": ["earbuds", "wireless", "noise_cancellation", "bluetooth"], "seo_keywords": ["AirPods", "wireless earbuds", "noise cancellation"], "launch_date": "2022-09-23", "discontinued": false}'));

-- Insert user profiles with flexible JSON
INSERT INTO json_data.user_profiles (user_id, username, email, profile_data, preferences, activity_history, social_connections, device_info) VALUES
(1001, 'johnsmith', 'john.smith@email.com',
PARSE_JSON('{"personal": {"first_name": "John", "last_name": "Smith", "date_of_birth": "1985-03-15", "gender": "male", "location": {"city": "San Francisco", "state": "CA", "country": "USA"}, "occupation": "Software Engineer", "company": "Tech Corp"}, "interests": ["technology", "photography", "travel", "cooking"], "bio": "Passionate about technology and innovation", "avatar_url": "https://example.com/avatars/john.jpg", "verification_status": "verified"}'),
PARSE_JSON('{"notifications": {"email": true, "push": true, "sms": false, "marketing": false}, "privacy": {"profile_visibility": "public", "show_email": false, "show_location": true, "allow_messages": true}, "language": "en", "timezone": "America/Los_Angeles", "theme": "dark", "accessibility": {"high_contrast": false, "large_text": false, "screen_reader": false}}'),
PARSE_JSON('{"login_history": [{"timestamp": "2024-12-01T10:00:00Z", "ip": "192.168.1.100", "device": "Chrome on Windows"}, {"timestamp": "2024-11-30T15:30:00Z", "ip": "192.168.1.100", "device": "Chrome on Windows"}], "recent_activity": [{"action": "purchase", "timestamp": "2024-12-01T10:00:00Z", "details": "Ordered iPhone 15 Pro"}, {"action": "review", "timestamp": "2024-11-30T14:20:00Z", "details": "Reviewed MacBook Air"}], "total_orders": 15, "total_spent": 8500.50}'),
PARSE_JSON('{"friends": [{"user_id": 1003, "username": "jane_doe", "status": "active"}, {"user_id": 1004, "username": "mike_wilson", "status": "active"}], "followers": 125, "following": 89, "groups": ["tech_enthusiasts", "photography_lovers", "travel_buddies"], "blocked_users": []}'),
PARSE_JSON('{"current_device": {"type": "desktop", "os": "Windows 11", "browser": "Chrome 120.0", "screen_resolution": "1920x1080"}, "registered_devices": [{"device_id": "dev_001", "type": "desktop", "os": "Windows 11", "last_used": "2024-12-01T10:00:00Z"}, {"device_id": "dev_002", "type": "mobile", "os": "iOS 17.1", "last_used": "2024-11-30T18:00:00Z"}], "security": {"two_factor_enabled": true, "last_password_change": "2024-11-15T00:00:00Z"}}'));

-- Insert API logs with JSON request/response
INSERT INTO json_data.api_logs (log_id, api_endpoint, http_method, request_data, response_data, headers, performance_metrics, error_info, timestamp) VALUES
(1, '/api/v1/products', 'GET',
PARSE_JSON('{"query_params": {"category": "smartphones", "price_min": 500, "price_max": 1000, "sort_by": "price", "sort_order": "asc"}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36", "ip_address": "192.168.1.100", "user_id": 1001, "session_id": "sess_123456"}'),
PARSE_JSON('{"status_code": 200, "data": {"products": [{"id": 101, "name": "iPhone 15 Pro", "price": 999.99}, {"id": 102, "name": "AirPods Pro", "price": 249.99}], "total_count": 2, "page": 1, "per_page": 20}, "message": "Success"}'),
PARSE_JSON('{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...", "Accept": "application/json", "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}'),
PARSE_JSON('{"response_time_ms": 45, "processing_time_ms": 12, "database_query_time_ms": 8, "cache_hit": true, "memory_usage_mb": 256, "cpu_usage_percent": 15}'),
PARSE_JSON('{"error": null, "warnings": []}'),
'2024-12-01 10:00:00'::TIMESTAMP_NTZ),

(2, '/api/v1/orders', 'POST',
PARSE_JSON('{"body": {"customer_id": 1001, "items": [{"product_id": 101, "quantity": 1}], "shipping_address": {"street": "123 Main St", "city": "San Francisco", "state": "CA", "zip": "94102"}}, "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36", "ip_address": "192.168.1.100", "user_id": 1001, "session_id": "sess_123456"}'),
PARSE_JSON('{"status_code": 201, "data": {"order_id": 1, "status": "processing", "estimated_delivery": "2024-12-03"}, "message": "Order created successfully"}'),
PARSE_JSON('{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...", "Accept": "application/json", "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}'),
PARSE_JSON('{"response_time_ms": 120, "processing_time_ms": 85, "database_query_time_ms": 45, "cache_hit": false, "memory_usage_mb": 512, "cpu_usage_percent": 25}'),
PARSE_JSON('{"error": null, "warnings": []}'),
'2024-12-01 10:05:00'::TIMESTAMP_NTZ);

-- Insert configurations with JSON schemas
INSERT INTO json_data.configurations (config_id, config_name, config_type, config_data, validation_rules, dependencies, version_info) VALUES
(1, 'email_settings', 'system',
PARSE_JSON('{"smtp": {"host": "smtp.gmail.com", "port": 587, "encryption": "TLS", "username": "noreply@company.com", "password": "encrypted_password_here"}, "templates": {"welcome": {"subject": "Welcome to our platform!", "template_id": "welcome_email_001"}, "order_confirmation": {"subject": "Order Confirmation", "template_id": "order_conf_001"}, "password_reset": {"subject": "Password Reset Request", "template_id": "pwd_reset_001"}}, "rate_limiting": {"max_emails_per_hour": 1000, "max_emails_per_user": 10}, "defaults": {"from_name": "Company Name", "from_email": "noreply@company.com", "reply_to": "support@company.com"}}'),
PARSE_JSON('{"required_fields": ["smtp.host", "smtp.port", "smtp.username"], "field_types": {"smtp.port": "integer", "smtp.encryption": "enum", "rate_limiting.max_emails_per_hour": "integer"}, "enum_values": {"smtp.encryption": ["TLS", "SSL", "None"]}, "validation_rules": {"smtp.port": {"min": 1, "max": 65535}, "rate_limiting.max_emails_per_hour": {"min": 1, "max": 10000}}}'),
PARSE_JSON('{"required_services": ["database", "redis_cache"], "environment_variables": ["SMTP_PASSWORD", "ENCRYPTION_KEY"], "external_services": ["email_provider"], "dependencies": [{"service": "notification_service", "version": "1.2.0"}, {"service": "user_service", "version": "2.1.0"}]}'),
PARSE_JSON('{"version": "1.0.0", "last_updated": "2024-12-01T10:00:00Z", "updated_by": "admin", "change_log": [{"version": "1.0.0", "date": "2024-12-01", "changes": ["Initial configuration", "Added SMTP settings", "Added email templates"]}], "compatibility": {"min_version": "1.0.0", "max_version": "2.0.0"}}'));

-- =====================================================
-- ADVANCED JSON VIEWS
-- =====================================================

-- E-commerce order analysis with JSON parsing
CREATE OR REPLACE VIEW json_data.order_analysis AS
SELECT 
    order_id,
    customer_id,
    order_date,
    -- JSON order details analysis
    order_details:total::DECIMAL(10,2) as total_amount,
    order_details:currency::STRING as currency,
    order_details:items::ARRAY as items_array,
    ARRAY_SIZE(order_details:items::ARRAY) as item_count,
    -- JSON customer info analysis
    customer_info:name::STRING as customer_name,
    customer_info:email::STRING as customer_email,
    customer_info:address:city::STRING as customer_city,
    customer_info:address:state::STRING as customer_state,
    -- JSON shipping info analysis
    shipping_info:shipping_method::STRING as shipping_method,
    shipping_info:carrier::STRING as shipping_carrier,
    shipping_info:tracking_number::STRING as tracking_number,
    shipping_info:estimated_delivery::STRING as estimated_delivery,
    -- JSON payment info analysis
    payment_info:payment_method::STRING as payment_method,
    payment_info:payment_status::STRING as payment_status,
    payment_info:transaction_id::STRING as transaction_id,
    -- JSON order status analysis
    order_status:status::STRING as current_status,
    order_status:priority::STRING as order_priority
FROM json_data.ecommerce_orders;

-- Product catalog analysis with nested JSON
CREATE OR REPLACE VIEW json_data.product_analysis AS
SELECT 
    product_id,
    product_name,
    category,
    -- JSON specifications analysis
    specifications:display:size::STRING as display_size,
    specifications:processor:name::STRING as processor_name,
    specifications:camera:main::STRING as main_camera,
    specifications:battery:capacity::STRING as battery_capacity,
    -- JSON pricing analysis
    pricing:base_price::DECIMAL(10,2) as base_price,
    pricing:currency::STRING as currency,
    ARRAY_SIZE(pricing:discounts::ARRAY) as discount_count,
    pricing:financing:available::BOOLEAN as financing_available,
    pricing:financing:monthly_payment::DECIMAL(10,2) as monthly_payment,
    -- JSON inventory analysis
    inventory:warehouse_stock::INT as warehouse_stock,
    inventory:on_order::INT as on_order,
    inventory:supplier:name::STRING as supplier_name,
    inventory:supplier:lead_time_days::INT as lead_time_days,
    -- JSON reviews analysis
    reviews:average_rating::DECIMAL(3,2) as average_rating,
    reviews:total_reviews::INT as total_reviews,
    reviews:rating_distribution:5_star::INT as five_star_reviews,
    -- JSON metadata analysis
    product_metadata:brand::STRING as brand,
    product_metadata:sku::STRING as sku,
    product_metadata:tags::ARRAY as tags_array
FROM json_data.product_catalog;

-- User profile analysis with flexible JSON
CREATE OR REPLACE VIEW json_data.user_analysis AS
SELECT 
    user_id,
    username,
    email,
    -- JSON profile data analysis
    profile_data:personal:first_name::STRING as first_name,
    profile_data:personal:last_name::STRING as last_name,
    profile_data:personal:location:city::STRING as city,
    profile_data:personal:location:state::STRING as state,
    profile_data:personal:occupation::STRING as occupation,
    profile_data:interests::ARRAY as interests_array,
    profile_data:verification_status::STRING as verification_status,
    -- JSON preferences analysis
    preferences:notifications:email::BOOLEAN as email_notifications,
    preferences:notifications:push::BOOLEAN as push_notifications,
    preferences:privacy:profile_visibility::STRING as profile_visibility,
    preferences:language::STRING as language,
    preferences:timezone::STRING as timezone,
    -- JSON activity analysis
    activity_history:total_orders::INT as total_orders,
    activity_history:total_spent::DECIMAL(10,2) as total_spent,
    ARRAY_SIZE(activity_history:recent_activity::ARRAY) as recent_activity_count,
    -- JSON social analysis
    social_connections:followers::INT as followers_count,
    social_connections:following::INT as following_count,
    ARRAY_SIZE(social_connections:groups::ARRAY) as groups_count,
    -- JSON device analysis
    device_info:current_device:type::STRING as current_device_type,
    device_info:current_device:os::STRING as current_device_os,
    ARRAY_SIZE(device_info:registered_devices::ARRAY) as registered_devices_count
FROM json_data.user_profiles;

-- API performance analysis with JSON metrics
CREATE OR REPLACE VIEW json_data.api_performance_analysis AS
SELECT 
    log_id,
    api_endpoint,
    http_method,
    timestamp,
    -- JSON request analysis
    request_data:user_id::INT as user_id,
    request_data:session_id::STRING as session_id,
    request_data:ip_address::STRING as ip_address,
    -- JSON response analysis
    response_data:status_code::INT as status_code,
    response_data:message::STRING as response_message,
    -- JSON performance metrics analysis
    performance_metrics:response_time_ms::INT as response_time_ms,
    performance_metrics:processing_time_ms::INT as processing_time_ms,
    performance_metrics:database_query_time_ms::INT as database_query_time_ms,
    performance_metrics:cache_hit::BOOLEAN as cache_hit,
    performance_metrics:memory_usage_mb::INT as memory_usage_mb,
    performance_metrics:cpu_usage_percent::DECIMAL(5,2) as cpu_usage_percent,
    -- JSON error analysis
    error_info:error::STRING as error_message,
    ARRAY_SIZE(error_info:warnings::ARRAY) as warning_count
FROM json_data.api_logs;

-- =====================================================
-- STORED PROCEDURES FOR JSON ANALYSIS
-- =====================================================

-- Analyze JSON structure and extract key metrics
CREATE OR REPLACE PROCEDURE json_data.analyze_json_structure(
    table_name VARCHAR,
    json_column VARCHAR
)
RETURNS TABLE (
    column_name VARCHAR,
    data_type VARCHAR,
    sample_value VARIANT,
    null_count INT,
    unique_count INT
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            'json_column' as column_name,
            'VARIANT' as data_type,
            PARSE_JSON('{"sample": "JSON data"}') as sample_value,
            0 as null_count,
            1 as unique_count
        FROM json_data.ecommerce_orders
        LIMIT 1
    );
END;
$$;

-- Search JSON data with flexible criteria
CREATE OR REPLACE PROCEDURE json_data.search_json_data(
    search_term VARCHAR,
    json_path VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    table_name VARCHAR,
    record_id INT,
    matched_value VARIANT,
    json_path_found VARCHAR
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            'ecommerce_orders' as table_name,
            order_id as record_id,
            order_details as matched_value,
            'order_details' as json_path_found
        FROM json_data.ecommerce_orders
        WHERE order_details::STRING ILIKE '%' || search_term || '%'
        UNION ALL
        SELECT 
            'product_catalog' as table_name,
            product_id as record_id,
            specifications as matched_value,
            'specifications' as json_path_found
        FROM json_data.product_catalog
        WHERE specifications::STRING ILIKE '%' || search_term || '%'
    );
END;
$$;

-- =====================================================
-- TAGS FOR DATA GOVERNANCE
-- =====================================================

-- Create tags
CREATE OR REPLACE TAG json_data.JSON_DATA_TAG;
CREATE OR REPLACE TAG json_data.PERSONAL_DATA_TAG;
CREATE OR REPLACE TAG json_data.FINANCIAL_DATA_TAG;
CREATE OR REPLACE TAG json_data.CONFIGURATION_DATA_TAG;

-- Apply tags
ALTER TABLE json_data.ecommerce_orders MODIFY COLUMN order_details SET TAG json_data.JSON_DATA_TAG = 'ORDER_DETAILS';
ALTER TABLE json_data.ecommerce_orders MODIFY COLUMN customer_info SET TAG json_data.PERSONAL_DATA_TAG = 'CUSTOMER_INFO';
ALTER TABLE json_data.ecommerce_orders MODIFY COLUMN payment_info SET TAG json_data.FINANCIAL_DATA_TAG = 'PAYMENT_INFO';
ALTER TABLE json_data.product_catalog MODIFY COLUMN specifications SET TAG json_data.JSON_DATA_TAG = 'PRODUCT_SPECS';
ALTER TABLE json_data.user_profiles MODIFY COLUMN profile_data SET TAG json_data.PERSONAL_DATA_TAG = 'PROFILE_DATA';
ALTER TABLE json_data.configurations MODIFY COLUMN config_data SET TAG json_data.CONFIGURATION_DATA_TAG = 'CONFIG_DATA';

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON TABLE json_data.ecommerce_orders IS 'E-commerce orders with complex JSON structure';
COMMENT ON TABLE json_data.product_catalog IS 'Product catalog with nested JSON attributes';
COMMENT ON TABLE json_data.user_profiles IS 'User profiles with flexible JSON structure';
COMMENT ON TABLE json_data.api_logs IS 'API logs with JSON request/response data';
COMMENT ON TABLE json_data.configurations IS 'Configuration management with JSON schemas';

-- =====================================================
-- CLEANUP (UNCOMMENT TO RESET)
-- =====================================================

/*
-- Drop all objects
DROP DATABASE IF EXISTS JSONDB CASCADE;
*/ 