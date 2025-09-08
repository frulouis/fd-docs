# TIMESERIESDB - Advanced Time Series Data Model

## Overview

TIMESERIESDB is a specialized data model designed to demonstrate Snowflake's advanced time series capabilities. This model showcases temporal data analysis, time-based clustering, window functions, and real-time analytics for financial markets, IoT sensors, and web analytics.

## Key Features

### ⏰ **Advanced Time Series Analysis**
- **Temporal Clustering**: Optimize queries with time-based clustering keys
- **Window Functions**: Moving averages, trends, and temporal patterns
- **Time Granularities**: Minute, hour, day, week, month aggregations
- **Real-time Analytics**: Live data processing and analysis

### 📈 **Financial Market Data**
- **Stock Price Analysis**: OHLC data with technical indicators
- **Market Trends**: Price changes, moving averages, volatility
- **Trading Analytics**: Volume analysis, market patterns
- **JSON Market Metadata**: Flexible market data storage

### 🔍 **IoT Sensor Time Series**
- **Multi-sensor Data**: Temperature, humidity, pressure readings
- **Data Quality Metrics**: Quality scores and confidence levels
- **Sensor Metadata**: JSON configuration and calibration data
- **Real-time Monitoring**: Live sensor data analysis

### 🌐 **Web Analytics Time Series**
- **User Behavior Tracking**: Page views, sessions, events
- **Performance Metrics**: Response times, error rates
- **Conversion Analysis**: Purchase patterns, funnel analysis
- **Device Analytics**: Browser, OS, device type tracking

## Database Schema

### Core Tables

| Table | Description | Key Features |
|-------|-------------|--------------|
| `market_data` | Financial market time series | OHLC data, clustering, JSON metadata |
| `sensor_time_series` | IoT sensor readings | Multi-sensor data, quality metrics |
| `web_analytics` | Web analytics events | User behavior, performance metrics |
| `time_series_aggregations` | Pre-computed aggregations | Multiple granularities, metrics |

### Advanced Views

| View | Purpose | Key Capabilities |
|------|---------|------------------|
| `market_time_series_analysis` | Financial market analysis | Price trends, moving averages, volatility |
| `sensor_trend_analysis` | IoT sensor trends | Temperature trends, quality analysis |
| `web_analytics_time_series` | Web analytics patterns | User behavior, session analysis |

## Sample Data

### Financial Market Data
```sql
-- Apple stock data with time series clustering
INSERT INTO ts.market_data (symbol, timestamp, cluster_key, open_price, high_price, low_price, close_price, volume) VALUES
('AAPL', '2024-12-01 09:30:00'::TIMESTAMP_NTZ, '2024-12-01 09:00:00'::TIMESTAMP_NTZ, 150.25, 152.80, 149.90, 151.75, 12500000);
```

### IoT Sensor Data
```sql
-- Temperature sensor reading with quality metrics
INSERT INTO ts.sensor_time_series (sensor_id, timestamp, cluster_key, temperature, humidity, data_quality_score) VALUES
(101, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 23.5, 45.2, 0.98);
```

### Web Analytics Data
```sql
-- Page view event with user behavior data
INSERT INTO ts.web_analytics (session_id, timestamp, cluster_key, page_url, event_type, session_duration_seconds) VALUES
('SESS001', '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '/home', 'page_view', 120);
```

## Use Cases & Demonstrations

### 1. **Financial Market Analysis**
```sql
-- Analyze stock price trends with moving averages
SELECT 
    symbol,
    timestamp,
    close_price,
    LAG(close_price, 1) OVER (PARTITION BY symbol ORDER BY timestamp) as prev_close,
    AVG(close_price) OVER (PARTITION BY symbol ORDER BY timestamp ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) as ma_5
FROM ts.market_data
WHERE symbol = 'AAPL';
```

### 2. **IoT Sensor Trend Analysis**
```sql
-- Analyze temperature trends with quality metrics
SELECT 
    sensor_id,
    timestamp,
    temperature,
    AVG(temperature) OVER (PARTITION BY sensor_id ORDER BY timestamp ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) as temp_ma_6,
    data_quality_score
FROM ts.sensor_time_series
WHERE sensor_id = 101;
```

### 3. **Web Analytics Patterns**
```sql
-- Analyze user session behavior
SELECT 
    session_id,
    timestamp,
    page_url,
    ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY timestamp) as page_sequence,
    session_duration_seconds
FROM ts.web_analytics
WHERE session_id = 'SESS001';
```

### 4. **Time Series Aggregations**
```sql
-- View pre-computed aggregations
SELECT 
    time_granularity,
    time_bucket,
    record_count,
    avg_value,
    min_value,
    max_value
FROM ts.time_series_aggregations
WHERE source_table = 'market_data';
```

## Advanced Time Series Features

### Temporal Functions
- **Window Functions**: `LAG()`, `LEAD()`, `ROW_NUMBER()`, `RANK()`
- **Moving Averages**: `AVG() OVER (ROWS BETWEEN n PRECEDING AND CURRENT ROW)`
- **Time Aggregations**: `DATE_TRUNC()`, `DATEADD()`, `DATEDIFF()`
- **Temporal Joins**: Time-based table joins and correlations

### Clustering Strategy
- **Time-based Clustering**: Optimize queries by timestamp ranges
- **Hybrid Clustering**: Combine time with other dimensions
- **Granular Clustering**: Different clustering for different time periods

### Performance Optimizations
- **Temporal Partitioning**: Partition by time periods
- **Materialized Views**: Pre-compute time-based aggregations
- **Query Optimization**: Optimize temporal queries

## Integration Examples

### With Geospatial Data
```sql
-- Combine time series with location data
SELECT 
    DATE_TRUNC('hour', timestamp) as hour,
    AVG(temperature) as avg_temp,
    ST_CENTROID(ST_COLLECT(location)) as center_point
FROM geospatialdb.geo.location_tracking
GROUP BY hour;
```

### With JSON Data
```sql
-- Extract time series data from JSON
SELECT 
    timestamp,
    sensor_readings:temperature::DECIMAL(8,4) as temperature,
    sensor_readings:battery_level::DECIMAL(5,2) as battery_level
FROM ts.sensor_time_series
WHERE sensor_readings IS NOT NULL;
```

### With IoT Data
```sql
-- Correlate sensor data with device information
SELECT 
    s.timestamp,
    s.temperature,
    d.device_name,
    d.device_type
FROM ts.sensor_time_series s
JOIN iotdb.iot.devices d ON s.device_id = d.device_id;
```

## Stored Procedures

### Time Series Trend Analysis
```sql
-- Analyze trends across different data sources
CALL ts.analyze_time_series_trends('market_data', 'symbol', 'close_price', 24);
```

## Best Practices

### Data Modeling
- **Clustering Keys**: Use appropriate time-based clustering
- **Granularity**: Choose appropriate time granularities
- **Partitioning**: Partition large time series datasets

### Performance
- **Indexing**: Create indexes on timestamp columns
- **Aggregations**: Pre-compute common aggregations
- **Query Patterns**: Optimize for common time-based queries

### Data Quality
- **Timestamp Validation**: Ensure consistent timestamp formats
- **Data Completeness**: Handle missing time periods
- **Outlier Detection**: Identify and handle temporal outliers

## Demonstration Scenarios

### 1. **Financial Trading Analytics**
- Real-time stock price monitoring
- Technical indicator calculations
- Market trend analysis
- Portfolio performance tracking

### 2. **IoT Predictive Maintenance**
- Sensor trend analysis
- Anomaly detection
- Predictive maintenance scheduling
- Equipment health monitoring

### 3. **Web Analytics & Marketing**
- User behavior analysis
- Conversion funnel optimization
- A/B testing analysis
- Campaign performance tracking

### 4. **Real-time Monitoring**
- Live data streaming
- Alert generation
- Performance monitoring
- Capacity planning

## File Structure

```
timeseriesdb/
├── timeseriesdb_data_model.sql    # Complete SQL data model
├── README.md                      # This documentation
└── ERD_README.md                  # Entity relationship documentation
```

## Getting Started

1. **Execute the SQL Script**:
   ```sql
   -- Run the complete data model
   @timeseriesdb_data_model.sql
   ```

2. **Explore Sample Data**:
   ```sql
   -- View market data
   SELECT * FROM ts.market_data;
   
   -- Analyze sensor trends
   SELECT * FROM ts.sensor_trend_analysis;
   ```

3. **Run Demonstrations**:
   ```sql
   -- Analyze time series trends
   CALL ts.analyze_time_series_trends('market_data', 'symbol', 'close_price', 24);
   ```

## Related Models

- **GEOSPATIALDB**: Geospatial data with temporal components
- **SENSORSDB**: IoT sensor data with time series features
- **JSONDB**: JSON data with temporal attributes
- **FINANCEDB**: Financial data with time series analysis

## Support

For questions or issues with the time series data model, refer to:
- Snowflake Time Series Documentation
- Window Functions Reference
- Temporal SQL Best Practices

---

*This time series data model is designed for Snowflake demonstrations and showcases advanced temporal analytics capabilities.* 