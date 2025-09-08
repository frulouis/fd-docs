# IoTDB - Advanced IoT Data Model

## Overview

IoTDB is a comprehensive data model designed to demonstrate Snowflake's advanced IoT capabilities. This model showcases sensor data management, device tracking, predictive maintenance, and real-time analytics with enhanced geospatial, JSON, and time series features.

## Key Features

### 🔍 **Advanced IoT Sensor Management**
- **Multi-sensor Data**: Temperature, humidity, pressure, air quality, motion sensors
- **Device Lifecycle**: Installation, maintenance, calibration tracking
- **Geospatial Integration**: Device locations with spatial relationships
- **JSON Configuration**: Flexible sensor configuration and metadata

### 📊 **Real-time Analytics**
- **Time Series Clustering**: Optimized temporal data analysis
- **Data Quality Metrics**: Quality scores and confidence levels
- **Real-time Monitoring**: Live sensor data processing
- **Predictive Analytics**: Trend analysis and anomaly detection

### 🗺️ **Geospatial IoT Features**
- **Device Positioning**: Latitude, longitude, altitude tracking
- **Zone Management**: Geospatial zones and device-zone relationships
- **Spatial Analytics**: Proximity analysis and spatial clustering
- **Location-based Alerts**: Geospatial event detection and notifications

### 📈 **Advanced Time Series**
- **Temporal Patterns**: Moving averages, trends, and seasonal analysis
- **Multi-granularity**: Minute, hour, day, week, month aggregations
- **Real-time Streaming**: Live data ingestion and processing
- **Historical Analysis**: Long-term trend analysis and forecasting

### 🔧 **Device Management**
- **Device Categories**: Manufacturing, logistics, facilities, security, energy
- **Maintenance Tracking**: Scheduled and predictive maintenance
- **Performance Monitoring**: Device health and efficiency metrics
- **Alert Management**: Real-time alerts and notifications

## Database Schema

### Core Tables

| Table | Description | Key Features |
|-------|-------------|--------------|
| `devices` | IoT devices with geospatial data | Device metadata, location, maintenance |
| `sensors` | Sensor configuration and calibration | Sensor specs, JSON config, geospatial offset |
| `sensor_data` | Time series sensor readings | JSON readings, geospatial context, quality metrics |
| `geospatial_zones` | Geospatial zones and boundaries | GeoJSON polygons, zone metadata |
| `device_zones` | Device-zone relationships | Spatial positioning, distance calculations |
| `alerts` | Real-time alerts and notifications | Geospatial context, JSON alert data |
| `time_series_aggregations` | Pre-computed temporal aggregations | Multiple granularities, spatial aggregations |

### Advanced Views

| View | Purpose | Key Capabilities |
|------|---------|------------------|
| `geospatial_device_analysis` | Device spatial analysis | Distance calculations, zone relationships |
| `json_sensor_analysis` | JSON sensor data analysis | Path extraction, metadata analysis |
| `time_series_analysis` | Temporal pattern analysis | Trend detection, quality metrics |
| `alert_geospatial_analysis` | Alert spatial analysis | Impact assessment, affected areas |

## Sample Data

### IoT Devices with Geospatial Data
```sql
-- Smart factory sensor hub with geospatial data
INSERT INTO iot.devices (device_id, device_name, device_type, latitude, longitude, altitude, device_metadata) VALUES
(1, 'Smart Factory Sensor Hub 01', 'Sensor Hub', 37.7749, -122.4194, 15.5, 
PARSE_JSON('{"facility": "Main Factory", "building": "A", "floor": "1", "department": "Production"}'));
```

### Sensor Data with JSON Readings
```sql
-- Temperature sensor reading with JSON data
INSERT INTO iot.sensor_data (sensor_id, device_id, timestamp, sensor_readings, latitude, longitude, data_quality_score) VALUES
(1, 1, '2024-12-01 10:00:00'::TIMESTAMP_NTZ,
PARSE_JSON('{"temperature": 23.5, "humidity": 45.2, "pressure": 1013.25, "battery_level": 95.5}'),
37.7749, -122.4194, 0.98);
```

### Geospatial Zones
```sql
-- Factory floor zone with polygon geometry
INSERT INTO iot.geospatial_zones (zone_id, zone_name, zone_boundary, center_latitude, center_longitude) VALUES
(1, 'Factory Floor Zone A',
PARSE_JSON('{"type": "Polygon", "coordinates": [[[-122.4199, 37.7744], [-122.4189, 37.7744], [-122.4189, 37.7754], [-122.4199, 37.7754], [-122.4199, 37.7744]]]}'),
37.7749, -122.4194);
```

## Use Cases & Demonstrations

### 1. **Smart Factory Analytics**
```sql
-- Analyze factory sensor data with geospatial context
SELECT 
    d.device_name,
    d.device_metadata:facility::STRING as facility,
    s.temperature,
    s.humidity,
    ST_DISTANCE(d.location, ST_POINT(-122.4194, 37.7749)) as distance_from_center
FROM iot.devices d
JOIN iot.sensor_data s ON d.device_id = s.device_id
WHERE d.device_type = 'Sensor Hub';
```

### 2. **Predictive Maintenance**
```sql
-- Analyze sensor trends for predictive maintenance
SELECT 
    sensor_id,
    device_id,
    timestamp,
    temperature,
    AVG(temperature) OVER (PARTITION BY sensor_id ORDER BY timestamp ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) as temp_ma_6,
    data_quality_score
FROM iot.sensor_data
WHERE data_quality_score > 0.95;
```

### 3. **Geospatial Alert Analysis**
```sql
-- Analyze alerts with spatial context
SELECT 
    alert_type,
    alert_severity,
    alert_location:latitude::DECIMAL(10,8) as alert_latitude,
    alert_location:longitude::DECIMAL(11,8) as alert_longitude,
    affected_area:zone_name::STRING as affected_zone
FROM iot.alerts
WHERE status = 'ACTIVE';
```

### 4. **Real-time Sensor Monitoring**
```sql
-- Monitor real-time sensor data
SELECT 
    s.sensor_id,
    s.timestamp,
    s.sensor_readings:temperature::DECIMAL(8,4) as temperature,
    s.sensor_readings:battery_level::DECIMAL(5,2) as battery_level,
    s.data_quality_score
FROM iot.sensor_data s
WHERE s.timestamp >= DATEADD('hour', -1, CURRENT_TIMESTAMP())
ORDER BY s.timestamp DESC;
```

## Advanced IoT Features

### Geospatial Functions
- **Spatial Relationships**: `ST_CONTAINS()`, `ST_INTERSECTS()`, `ST_DWITHIN()`
- **Distance Calculations**: `ST_DISTANCE()` for proximity analysis
- **Spatial Clustering**: Group devices by geographic regions
- **Zone Management**: Geofencing and spatial event detection

### Time Series Analysis
- **Temporal Clustering**: Optimize queries with time-based clustering
- **Window Functions**: Moving averages, trends, and patterns
- **Real-time Processing**: Live data ingestion and analysis
- **Historical Analysis**: Long-term trend analysis and forecasting

### JSON Processing
- **Sensor Configuration**: Flexible JSON-based sensor setup
- **Metadata Management**: Device and sensor metadata in JSON
- **Alert Data**: Rich alert information with JSON structure
- **Path Extraction**: Efficient JSON data access and analysis

### Performance Optimizations
- **Hybrid Clustering**: Combine time and spatial clustering
- **Spatial Indexing**: Optimize geospatial queries
- **JSON Path Indexing**: Index frequently accessed JSON paths
- **Materialized Views**: Pre-compute complex aggregations

## Integration Examples

### With Geospatial Data
```sql
-- Combine IoT data with geospatial analysis
SELECT 
    d.device_name,
    d.location,
    s.temperature,
    z.zone_name,
    ST_DISTANCE(d.location, z.zone_boundary) as distance_to_zone
FROM iot.devices d
JOIN iot.sensor_data s ON d.device_id = s.device_id
JOIN iot.geospatial_zones z ON ST_CONTAINS(z.zone_boundary, d.location);
```

### With Time Series Data
```sql
-- Analyze temporal patterns in IoT data
SELECT 
    DATE_TRUNC('hour', timestamp) as hour,
    AVG(temperature) as avg_temp,
    COUNT(*) as reading_count,
    AVG(data_quality_score) as avg_quality
FROM iot.sensor_data
GROUP BY hour
ORDER BY hour;
```

### With JSON Data
```sql
-- Extract and analyze JSON sensor data
SELECT 
    sensor_id,
    sensor_readings:temperature::DECIMAL(8,4) as temperature,
    sensor_readings:humidity::DECIMAL(8,4) as humidity,
    sensor_readings:battery_level::DECIMAL(5,2) as battery_level,
    reading_metadata:weather:condition::STRING as weather_condition
FROM iot.sensor_data
WHERE sensor_readings IS NOT NULL;
```

## Stored Procedures

### Geospatial Device Analysis
```sql
-- Find devices within geospatial radius
CALL iot.get_devices_in_radius(37.7749, -122.4194, 5.0);
```

### Sensor Trend Analysis
```sql
-- Analyze sensor trends over time
CALL iot.analyze_sensor_trends(101, 24);
```

## Best Practices

### Data Quality
- **Sensor Calibration**: Regular calibration tracking and validation
- **Data Validation**: Quality scores and confidence levels
- **Outlier Detection**: Identify and handle sensor anomalies
- **Completeness Checks**: Monitor data completeness and gaps

### Performance
- **Clustering Strategy**: Use appropriate time and spatial clustering
- **Indexing**: Create indexes for geospatial and JSON queries
- **Partitioning**: Partition large sensor datasets by time
- **Caching**: Cache frequently accessed aggregations

### Security
- **Device Authentication**: Secure device registration and authentication
- **Data Encryption**: Encrypt sensitive sensor data
- **Access Control**: Role-based access to IoT data
- **Audit Logging**: Track all IoT data access and modifications

## Demonstration Scenarios

### 1. **Smart Manufacturing**
- Real-time production monitoring
- Predictive maintenance scheduling
- Quality control automation
- Energy efficiency optimization

### 2. **Smart Cities**
- Environmental monitoring
- Traffic pattern analysis
- Public safety monitoring
- Infrastructure health tracking

### 3. **Healthcare IoT**
- Medical device monitoring
- Patient vital signs tracking
- Equipment maintenance
- Compliance monitoring

### 4. **Energy Management**
- Smart grid monitoring
- Renewable energy optimization
- Consumption analytics
- Predictive maintenance

## File Structure

```
iotdb/
├── iotdb_data_model.sql           # Complete SQL data model
├── README.md                      # This documentation
├── iotdb_quick_reference.md       # Quick reference guide
└── erd_sensors.png                # Entity relationship diagram
```

## Getting Started

1. **Execute the SQL Script**:
   ```sql
   -- Run the complete data model
   @iotdb_data_model.sql
   ```

2. **Explore Sample Data**:
   ```sql
   -- View IoT devices
   SELECT * FROM iot.devices;
   
   -- Analyze sensor data
   SELECT * FROM iot.json_sensor_analysis;
   ```

3. **Run Demonstrations**:
   ```sql
   -- Find devices in radius
   CALL iot.get_devices_in_radius(37.7749, -122.4194, 5.0);
   
   -- Analyze sensor trends
   CALL iot.analyze_sensor_trends(101, 24);
   ```

## Related Models

- **GEOSPATIALDB**: Advanced geospatial analytics
- **TIMESERIESDB**: Time series analysis and patterns
- **JSONDB**: Semi-structured data processing
- **DevicesDB**: Medical device management
- **SALESDB**: Sales data with location-based analytics

## Support

For questions or issues with the IoT data model, refer to:
- Snowflake IoT Documentation
- Geospatial Functions Reference
- Time Series Analysis Guide
- JSON Processing Best Practices

---

*This IoT data model is designed for Snowflake demonstrations and showcases advanced IoT analytics capabilities with geospatial, temporal, and semi-structured data integration.* 