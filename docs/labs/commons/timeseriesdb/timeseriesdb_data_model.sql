-- =====================================================
-- TIMESERIESDB - Advanced Time Series Data Model
-- Specialized time series model for Snowflake demonstrations
-- Version: 1.0.0
-- Last Updated: December 2024
-- =====================================================

-- Create database and schema
CREATE OR REPLACE DATABASE TIMESERIESDB;
USE DATABASE TIMESERIESDB;
CREATE OR REPLACE SCHEMA ts;

-- =====================================================
-- TABLES WITH ADVANCED TIME SERIES FEATURES
-- =====================================================

-- Financial market data with time series clustering
CREATE OR REPLACE TABLE ts.market_data (
    data_id INT PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL,
    exchange VARCHAR(20),
    -- Time series with clustering
    timestamp TIMESTAMP_NTZ,
    cluster_key TIMESTAMP_NTZ,
    -- Market data
    open_price DECIMAL(10,4),
    high_price DECIMAL(10,4),
    low_price DECIMAL(10,4),
    close_price DECIMAL(10,4),
    volume BIGINT,
    -- JSON market data
    market_metadata VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- IoT sensor time series with multiple granularities
CREATE OR REPLACE TABLE ts.sensor_time_series (
    reading_id INT PRIMARY KEY,
    sensor_id INT,
    device_id INT,
    -- Time series clustering
    timestamp TIMESTAMP_NTZ,
    cluster_key TIMESTAMP_NTZ,
    -- Sensor readings
    temperature DECIMAL(8,4),
    humidity DECIMAL(8,4),
    pressure DECIMAL(10,4),
    -- JSON sensor data
    sensor_readings VARIANT,
    -- Quality metrics
    data_quality_score DECIMAL(3,2),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Web analytics time series
CREATE OR REPLACE TABLE ts.web_analytics (
    event_id INT PRIMARY KEY,
    session_id VARCHAR(50),
    user_id VARCHAR(50),
    -- Time series clustering
    timestamp TIMESTAMP_NTZ,
    cluster_key TIMESTAMP_NTZ,
    -- Web analytics data
    page_url VARCHAR(500),
    page_title VARCHAR(200),
    event_type VARCHAR(50),
    session_duration_seconds INT,
    -- JSON analytics data
    analytics_metadata VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Time series aggregations at different granularities
CREATE OR REPLACE TABLE ts.time_series_aggregations (
    aggregation_id INT PRIMARY KEY,
    source_table VARCHAR(50),
    source_id INT,
    -- Time granularity
    time_granularity VARCHAR(20), -- minute, hour, day, week, month
    time_bucket TIMESTAMP_NTZ,
    cluster_key TIMESTAMP_NTZ,
    -- Aggregated metrics
    record_count INT,
    avg_value DECIMAL(15,4),
    min_value DECIMAL(15,4),
    max_value DECIMAL(15,4),
    std_dev DECIMAL(15,4),
    -- JSON aggregated data
    aggregated_metrics VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SAMPLE DATA WITH TIME SERIES FEATURES
-- =====================================================

-- Insert market data with time series clustering
INSERT INTO ts.market_data (data_id, symbol, exchange, timestamp, cluster_key, open_price, high_price, low_price, close_price, volume, market_metadata) VALUES
(1, 'AAPL', 'NASDAQ', '2024-12-01 09:30:00'::TIMESTAMP_NTZ, '2024-12-01 09:00:00'::TIMESTAMP_NTZ, 150.25, 152.80, 149.90, 151.75, 12500000,
PARSE_JSON('{"market_cap": 2400000000000, "pe_ratio": 28.5, "dividend_yield": 0.5, "beta": 1.2, "sector": "Technology"}')),

(2, 'AAPL', 'NASDAQ', '2024-12-01 09:31:00'::TIMESTAMP_NTZ, '2024-12-01 09:00:00'::TIMESTAMP_NTZ, 151.75, 153.20, 151.50, 152.90, 8500000,
PARSE_JSON('{"market_cap": 2400000000000, "pe_ratio": 28.5, "dividend_yield": 0.5, "beta": 1.2, "sector": "Technology"}')),

(3, 'GOOGL', 'NASDAQ', '2024-12-01 09:30:00'::TIMESTAMP_NTZ, '2024-12-01 09:00:00'::TIMESTAMP_NTZ, 2750.00, 2775.50, 2745.25, 2768.90, 3200000,
PARSE_JSON('{"market_cap": 1800000000000, "pe_ratio": 25.8, "dividend_yield": 0.0, "beta": 1.1, "sector": "Technology"}')),

(4, 'MSFT', 'NASDAQ', '2024-12-01 09:30:00'::TIMESTAMP_NTZ, '2024-12-01 09:00:00'::TIMESTAMP_NTZ, 380.50, 382.75, 379.80, 381.25, 5800000,
PARSE_JSON('{"market_cap": 2800000000000, "pe_ratio": 32.1, "dividend_yield": 0.8, "beta": 0.9, "sector": "Technology"}')),

(5, 'TSLA', 'NASDAQ', '2024-12-01 09:30:00'::TIMESTAMP_NTZ, '2024-12-01 09:00:00'::TIMESTAMP_NTZ, 245.75, 248.90, 244.50, 247.30, 8900000,
PARSE_JSON('{"market_cap": 780000000000, "pe_ratio": 65.2, "dividend_yield": 0.0, "beta": 2.1, "sector": "Automotive"}'));

-- Insert sensor time series data
INSERT INTO ts.sensor_time_series (reading_id, sensor_id, device_id, timestamp, cluster_key, temperature, humidity, pressure, sensor_readings, data_quality_score) VALUES
(1, 101, 1001, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 23.5, 45.2, 1013.25,
PARSE_JSON('{"battery_level": 95.5, "signal_strength": -45, "calibration_status": "good"}'), 0.98),

(2, 101, 1001, '2024-12-01 10:01:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 23.7, 45.5, 1013.30,
PARSE_JSON('{"battery_level": 95.3, "signal_strength": -44, "calibration_status": "good"}'), 0.97),

(3, 102, 1002, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, -18.5, 85.3, 1012.80,
PARSE_JSON('{"battery_level": 87.2, "signal_strength": -38, "calibration_status": "good"}'), 0.99),

(4, 103, 1003, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 22.1, 52.8, 1014.15,
PARSE_JSON('{"battery_level": 92.1, "signal_strength": -41, "calibration_status": "good"}'), 0.96),

(5, 104, 1004, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 18.9, 38.5, 1015.20,
PARSE_JSON('{"battery_level": 89.7, "signal_strength": -35, "calibration_status": "good"}'), 0.94);

-- Insert web analytics time series
INSERT INTO ts.web_analytics (event_id, session_id, user_id, timestamp, cluster_key, page_url, page_title, event_type, session_duration_seconds, analytics_metadata) VALUES
(1, 'SESS001', 'USER001', '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '/home', 'Homepage', 'page_view', 120,
PARSE_JSON('{"device_type": "desktop", "browser": "Chrome", "os": "Windows", "referrer": "google.com"}')),

(2, 'SESS001', 'USER001', '2024-12-01 10:02:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '/products', 'Products', 'page_view', 180,
PARSE_JSON('{"device_type": "desktop", "browser": "Chrome", "os": "Windows", "referrer": "google.com"}')),

(3, 'SESS002', 'USER002', '2024-12-01 10:05:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '/home', 'Homepage', 'page_view', 90,
PARSE_JSON('{"device_type": "mobile", "browser": "Safari", "os": "iOS", "referrer": "facebook.com"}')),

(4, 'SESS003', 'USER003', '2024-12-01 10:10:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '/checkout', 'Checkout', 'purchase', 300,
PARSE_JSON('{"device_type": "desktop", "browser": "Firefox", "os": "macOS", "referrer": "email", "purchase_amount": 299.99}')),

(5, 'SESS004', 'USER004', '2024-12-01 10:15:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '/support', 'Support', 'page_view', 240,
PARSE_JSON('{"device_type": "tablet", "browser": "Safari", "os": "iOS", "referrer": "direct"}'));

-- Insert time series aggregations
INSERT INTO ts.time_series_aggregations (aggregation_id, source_table, source_id, time_granularity, time_bucket, cluster_key, record_count, avg_value, min_value, max_value, std_dev, aggregated_metrics) VALUES
(1, 'market_data', 1, 'hour', '2024-12-01 09:00:00'::TIMESTAMP_NTZ, '2024-12-01 09:00:00'::TIMESTAMP_NTZ, 60, 151.25, 149.90, 153.20, 0.85,
PARSE_JSON('{"volume_weighted_avg": 151.15, "price_change": 1.50, "price_change_pct": 1.0, "volatility": 0.56}')),

(2, 'sensor_time_series', 101, 'hour', '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 3600, 23.6, 22.1, 25.3, 0.8,
PARSE_JSON('{"temperature_trend": "stable", "humidity_avg": 45.8, "pressure_avg": 1013.4, "data_completeness": 0.98}')),

(3, 'web_analytics', 1, 'hour', '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 1500, 180.5, 30, 600, 120.5,
PARSE_JSON('{"unique_users": 1200, "unique_sessions": 1500, "conversion_rate": 0.15, "bounce_rate": 0.35, "avg_page_views": 3.2}'));

-- =====================================================
-- ADVANCED TIME SERIES VIEWS
-- =====================================================

-- Market data time series analysis
CREATE OR REPLACE VIEW ts.market_time_series_analysis AS
SELECT 
    symbol,
    timestamp,
    cluster_key,
    open_price,
    high_price,
    low_price,
    close_price,
    volume,
    -- Time series calculations
    LAG(close_price, 1) OVER (PARTITION BY symbol ORDER BY timestamp) as prev_close,
    close_price - LAG(close_price, 1) OVER (PARTITION BY symbol ORDER BY timestamp) as price_change,
    (close_price - LAG(close_price, 1) OVER (PARTITION BY symbol ORDER BY timestamp)) / LAG(close_price, 1) OVER (PARTITION BY symbol ORDER BY timestamp) * 100 as price_change_pct,
    -- Moving averages
    AVG(close_price) OVER (PARTITION BY symbol ORDER BY timestamp ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) as ma_5,
    AVG(close_price) OVER (PARTITION BY symbol ORDER BY timestamp ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) as ma_20,
    -- JSON market data analysis
    market_metadata:market_cap::DECIMAL(15,2) as market_cap,
    market_metadata:pe_ratio::DECIMAL(5,2) as pe_ratio,
    market_metadata:sector::STRING as sector
FROM ts.market_data
ORDER BY symbol, timestamp;

-- Sensor time series with trend analysis
CREATE OR REPLACE VIEW ts.sensor_trend_analysis AS
SELECT 
    sensor_id,
    device_id,
    timestamp,
    cluster_key,
    temperature,
    humidity,
    pressure,
    -- Time series trend analysis
    LAG(temperature, 1) OVER (PARTITION BY sensor_id ORDER BY timestamp) as prev_temperature,
    temperature - LAG(temperature, 1) OVER (PARTITION BY sensor_id ORDER BY timestamp) as temp_change,
    -- Moving averages for trend detection
    AVG(temperature) OVER (PARTITION BY sensor_id ORDER BY timestamp ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) as temp_ma_6,
    AVG(humidity) OVER (PARTITION BY sensor_id ORDER BY timestamp ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) as humidity_ma_6,
    -- JSON sensor data analysis
    sensor_readings:battery_level::DECIMAL(5,2) as battery_level,
    sensor_readings:signal_strength::INT as signal_strength,
    data_quality_score
FROM ts.sensor_time_series
ORDER BY sensor_id, timestamp;

-- Web analytics time series with user behavior
CREATE OR REPLACE VIEW ts.web_analytics_time_series AS
SELECT 
    session_id,
    user_id,
    timestamp,
    cluster_key,
    page_url,
    page_title,
    event_type,
    session_duration_seconds,
    -- Time series analysis
    LAG(session_duration_seconds, 1) OVER (PARTITION BY session_id ORDER BY timestamp) as prev_duration,
    -- Session progression
    ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY timestamp) as page_sequence,
    -- JSON analytics analysis
    analytics_metadata:device_type::STRING as device_type,
    analytics_metadata:browser::STRING as browser,
    analytics_metadata:os::STRING as operating_system,
    analytics_metadata:purchase_amount::DECIMAL(10,2) as purchase_amount
FROM ts.web_analytics
ORDER BY session_id, timestamp;

-- =====================================================
-- STORED PROCEDURES FOR TIME SERIES ANALYSIS
-- =====================================================

-- Analyze time series trends
CREATE OR REPLACE PROCEDURE ts.analyze_time_series_trends(
    table_name VARCHAR,
    id_column VARCHAR,
    value_column VARCHAR,
    hours_back INT DEFAULT 24
)
RETURNS TABLE (
    id_value INT,
    trend_direction VARCHAR,
    avg_value DECIMAL(15,4),
    trend_strength DECIMAL(5,2),
    volatility DECIMAL(10,4)
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            id_value,
            CASE 
                WHEN trend_slope > 0.01 THEN 'INCREASING'
                WHEN trend_slope < -0.01 THEN 'DECREASING'
                ELSE 'STABLE'
            END as trend_direction,
            avg_value,
            ABS(trend_slope) as trend_strength,
            std_dev as volatility
        FROM (
            SELECT 
                id_value,
                AVG(value) as avg_value,
                STDDEV(value) as std_dev,
                (MAX(value) - MIN(value)) / COUNT(*) as trend_slope
            FROM (
                SELECT 
                    CASE 
                        WHEN table_name = 'market_data' THEN symbol::INT
                        WHEN table_name = 'sensor_time_series' THEN sensor_id
                        ELSE 0
                    END as id_value,
                    CASE 
                        WHEN table_name = 'market_data' THEN close_price
                        WHEN table_name = 'sensor_time_series' THEN temperature
                        ELSE 0
                    END as value
                FROM ts.market_data
                WHERE timestamp >= DATEADD('hour', -hours_back, CURRENT_TIMESTAMP())
                UNION ALL
                SELECT 
                    sensor_id as id_value,
                    temperature as value
                FROM ts.sensor_time_series
                WHERE timestamp >= DATEADD('hour', -hours_back, CURRENT_TIMESTAMP())
            )
            GROUP BY id_value
        )
    );
END;
$$;

-- =====================================================
-- TAGS FOR DATA GOVERNANCE
-- =====================================================

-- Create tags
CREATE OR REPLACE TAG ts.TIME_SERIES_DATA_TAG;
CREATE OR REPLACE TAG ts.FINANCIAL_DATA_TAG;
CREATE OR REPLACE TAG ts.SENSOR_DATA_TAG;
CREATE OR REPLACE TAG ts.JSON_DATA_TAG;

-- Apply tags
ALTER TABLE ts.market_data MODIFY COLUMN timestamp SET TAG ts.TIME_SERIES_DATA_TAG = 'MARKET_TIMESTAMP';
ALTER TABLE ts.market_data MODIFY COLUMN close_price SET TAG ts.FINANCIAL_DATA_TAG = 'STOCK_PRICE';
ALTER TABLE ts.sensor_time_series MODIFY COLUMN timestamp SET TAG ts.TIME_SERIES_DATA_TAG = 'SENSOR_TIMESTAMP';
ALTER TABLE ts.sensor_time_series MODIFY COLUMN temperature SET TAG ts.SENSOR_DATA_TAG = 'TEMPERATURE_READING';
ALTER TABLE ts.market_data MODIFY COLUMN market_metadata SET TAG ts.JSON_DATA_TAG = 'MARKET_METADATA';

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON TABLE ts.market_data IS 'Financial market time series data with clustering';
COMMENT ON TABLE ts.sensor_time_series IS 'IoT sensor time series data with multiple granularities';
COMMENT ON TABLE ts.web_analytics IS 'Web analytics time series data';
COMMENT ON TABLE ts.time_series_aggregations IS 'Time series aggregations at different granularities';

-- =====================================================
-- CLEANUP (UNCOMMENT TO RESET)
-- =====================================================

/*
-- Drop all objects
DROP DATABASE IF EXISTS TIMESERIESDB CASCADE;
*/ 