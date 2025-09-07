# IoTDB Data Model

An Internet of Things (IoT) focused data model for Snowflake demos and tutorials, featuring sensor data, device management, and real-time analytics capabilities.

## Overview

The IoTDB data model provides a realistic IoT environment for learning Snowflake capabilities including:

![IoTDB Sensor Network Architecture](../assets/images/iotdb-architecture.png)

*Figure 1: IoTDB Sensor Network Architecture - Complete IoT database schema showing relationships between Device, Sensor, SensorData, and Alert tables*
- **Sensor Data Management** - High-volume time-series data handling
- **Device Management** - IoT device registration and monitoring
- **Real-time Analytics** - Streaming data processing and alerts
- **Predictive Maintenance** - Machine learning for device health
- **Geospatial Data** - Location-based IoT analytics

## Prerequisites

- Snowflake account with appropriate privileges
- Understanding of time-series data concepts
- Basic knowledge of IoT data structures

## Data Model Structure

### Core Tables

#### Device Table
```sql
CREATE OR REPLACE TABLE Device (
    DeviceID INT PRIMARY KEY,
    DeviceName VARCHAR(100),
    DeviceType VARCHAR(50),
    Manufacturer VARCHAR(100),
    Model VARCHAR(100),
    SerialNumber VARCHAR(100),
    Location VARCHAR(200),
    Latitude DECIMAL(10, 8),
    Longitude DECIMAL(11, 8),
    InstallationDate DATE,
    LastMaintenanceDate DATE,
    Status VARCHAR(20),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Sensor Table
```sql
CREATE OR REPLACE TABLE Sensor (
    SensorID INT PRIMARY KEY,
    DeviceID INT REFERENCES Device(DeviceID),
    SensorName VARCHAR(100),
    SensorType VARCHAR(50),
    Unit VARCHAR(20),
    MinValue DECIMAL(10, 4),
    MaxValue DECIMAL(10, 4),
    CalibrationDate DATE,
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### SensorData Table
```sql
CREATE OR REPLACE TABLE SensorData (
    DataID BIGINT PRIMARY KEY,
    SensorID INT REFERENCES Sensor(SensorID),
    DeviceID INT REFERENCES Device(DeviceID),
    Timestamp TIMESTAMP_LTZ,
    Value DECIMAL(15, 6),
    Quality VARCHAR(20),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Alert Table
```sql
CREATE OR REPLACE TABLE Alert (
    AlertID INT PRIMARY KEY,
    DeviceID INT REFERENCES Device(DeviceID),
    SensorID INT REFERENCES Sensor(SensorID),
    AlertType VARCHAR(50),
    Severity VARCHAR(20),
    Message VARCHAR(500),
    ThresholdValue DECIMAL(15, 6),
    ActualValue DECIMAL(15, 6),
    AlertTime TIMESTAMP_LTZ,
    ResolvedTime TIMESTAMP_LTZ,
    Status VARCHAR(20),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

## IoT Analytics Functions

### Device Health Score
```sql
CREATE OR REPLACE FUNCTION calculate_device_health_score(device_id INT, hours_back INT)
RETURNS DECIMAL(3, 2)
LANGUAGE SQL
AS $$
    WITH recent_data AS (
        SELECT 
            sd.Value,
            s.MinValue,
            s.MaxValue,
            s.SensorType
        FROM SensorData sd
        JOIN Sensor s ON sd.SensorID = s.SensorID
        WHERE sd.DeviceID = device_id
        AND sd.Timestamp >= DATEADD('hour', -hours_back, CURRENT_TIMESTAMP())
    ),
    health_metrics AS (
        SELECT 
            SensorType,
            AVG(CASE 
                WHEN Value BETWEEN MinValue AND MaxValue THEN 1.0
                ELSE 0.0
            END) as health_ratio
        FROM recent_data
        GROUP BY SensorType
    )
    SELECT AVG(health_ratio)
    FROM health_metrics
$$;
```

### Anomaly Detection
```sql
CREATE OR REPLACE FUNCTION detect_sensor_anomaly(sensor_id INT, hours_back INT)
RETURNS BOOLEAN
LANGUAGE SQL
AS $$
    WITH sensor_stats AS (
        SELECT 
            AVG(Value) as mean_value,
            STDDEV(Value) as std_dev
        FROM SensorData
        WHERE SensorID = sensor_id
        AND Timestamp >= DATEADD('hour', -hours_back, CURRENT_TIMESTAMP())
    ),
    recent_value AS (
        SELECT Value
        FROM SensorData
        WHERE SensorID = sensor_id
        ORDER BY Timestamp DESC
        LIMIT 1
    )
    SELECT ABS(rv.Value - ss.mean_value) > (ss.std_dev * 3)
    FROM recent_value rv
    CROSS JOIN sensor_stats ss
$$;
```

### Data Quality Score
```sql
CREATE OR REPLACE FUNCTION calculate_data_quality_score(device_id INT, hours_back INT)
RETURNS DECIMAL(3, 2)
LANGUAGE SQL
AS $$
    WITH quality_metrics AS (
        SELECT 
            COUNT(*) as total_readings,
            COUNT(CASE WHEN Quality = 'Good' THEN 1 END) as good_readings,
            COUNT(CASE WHEN Value IS NULL THEN 1 END) as null_readings,
            COUNT(CASE WHEN Value < 0 AND SensorType = 'Temperature' THEN 1 END) as invalid_readings
        FROM SensorData sd
        JOIN Sensor s ON sd.SensorID = s.SensorID
        WHERE sd.DeviceID = device_id
        AND sd.Timestamp >= DATEADD('hour', -hours_back, CURRENT_TIMESTAMP())
    )
    SELECT 
        (good_readings::DECIMAL / NULLIF(total_readings, 0)) * 
        (1 - (null_readings::DECIMAL / NULLIF(total_readings, 0))) *
        (1 - (invalid_readings::DECIMAL / NULLIF(total_readings, 0)))
    FROM quality_metrics
$$;
```

## IoT Analytics Views

### Device Performance Dashboard
```sql
CREATE OR REPLACE VIEW device_performance_dashboard AS
SELECT 
    d.DeviceID,
    d.DeviceName,
    d.DeviceType,
    d.Location,
    d.Status,
    calculate_device_health_score(d.DeviceID, 24) as health_score_24h,
    calculate_device_health_score(d.DeviceID, 168) as health_score_7d,
    calculate_data_quality_score(d.DeviceID, 24) as data_quality_24h,
    COUNT(DISTINCT s.SensorID) as sensor_count,
    COUNT(sd.DataID) as total_readings_24h,
    MAX(sd.Timestamp) as last_reading_time
FROM Device d
LEFT JOIN Sensor s ON d.DeviceID = s.DeviceID
LEFT JOIN SensorData sd ON d.DeviceID = sd.DeviceID 
    AND sd.Timestamp >= DATEADD('hour', -24, CURRENT_TIMESTAMP())
GROUP BY d.DeviceID, d.DeviceName, d.DeviceType, d.Location, d.Status
ORDER BY health_score_24h DESC;
```

### Sensor Anomaly Alerts
```sql
CREATE OR REPLACE VIEW sensor_anomaly_alerts AS
SELECT 
    s.SensorID,
    s.SensorName,
    s.SensorType,
    d.DeviceName,
    d.Location,
    sd.Value as current_value,
    s.MinValue,
    s.MaxValue,
    sd.Timestamp as reading_time,
    detect_sensor_anomaly(s.SensorID, 24) as is_anomaly
FROM Sensor s
JOIN Device d ON s.DeviceID = d.DeviceID
JOIN SensorData sd ON s.SensorID = sd.SensorID
WHERE sd.Timestamp >= DATEADD('hour', -1, CURRENT_TIMESTAMP())
AND detect_sensor_anomaly(s.SensorID, 24) = TRUE
ORDER BY sd.Timestamp DESC;
```

### Geospatial Device Map
```sql
CREATE OR REPLACE VIEW geospatial_device_map AS
SELECT 
    d.DeviceID,
    d.DeviceName,
    d.DeviceType,
    d.Latitude,
    d.Longitude,
    d.Status,
    calculate_device_health_score(d.DeviceID, 24) as health_score,
    COUNT(s.SensorID) as sensor_count,
    COUNT(a.AlertID) as active_alerts
FROM Device d
LEFT JOIN Sensor s ON d.DeviceID = s.DeviceID
LEFT JOIN Alert a ON d.DeviceID = a.DeviceID 
    AND a.Status = 'Active'
WHERE d.Latitude IS NOT NULL 
AND d.Longitude IS NOT NULL
GROUP BY d.DeviceID, d.DeviceName, d.DeviceType, d.Latitude, d.Longitude, d.Status
ORDER BY health_score DESC;
```

## IoT Stored Procedures

### Register Device
```sql
CREATE OR REPLACE PROCEDURE register_device(
    device_name VARCHAR,
    device_type VARCHAR,
    manufacturer VARCHAR,
    model VARCHAR,
    serial_number VARCHAR,
    location VARCHAR,
    latitude DECIMAL,
    longitude DECIMAL
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    new_device_id INT;
BEGIN
    -- Generate new device ID
    SELECT COALESCE(MAX(DeviceID), 0) + 1 INTO new_device_id FROM Device;
    
    -- Insert new device
    INSERT INTO Device (DeviceID, DeviceName, DeviceType, Manufacturer, 
                       Model, SerialNumber, Location, Latitude, Longitude, 
                       InstallationDate, Status)
    VALUES (new_device_id, device_name, device_type, manufacturer, 
            model, serial_number, location, latitude, longitude, 
            CURRENT_DATE(), 'Active');
    
    RETURN 'Device registered with ID: ' || new_device_id;
END;
$$;
```

### Add Sensor to Device
```sql
CREATE OR REPLACE PROCEDURE add_sensor_to_device(
    device_id INT,
    sensor_name VARCHAR,
    sensor_type VARCHAR,
    unit VARCHAR,
    min_value DECIMAL,
    max_value DECIMAL
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    new_sensor_id INT;
BEGIN
    -- Generate new sensor ID
    SELECT COALESCE(MAX(SensorID), 0) + 1 INTO new_sensor_id FROM Sensor;
    
    -- Insert new sensor
    INSERT INTO Sensor (SensorID, DeviceID, SensorName, SensorType, 
                       Unit, MinValue, MaxValue, CalibrationDate)
    VALUES (new_sensor_id, device_id, sensor_name, sensor_type, 
            unit, min_value, max_value, CURRENT_DATE());
    
    RETURN 'Sensor added with ID: ' || new_sensor_id;
END;
$$;
```

### Generate Alert
```sql
CREATE OR REPLACE PROCEDURE generate_alert(
    device_id INT,
    sensor_id INT,
    alert_type VARCHAR,
    severity VARCHAR,
    message VARCHAR,
    threshold_value DECIMAL,
    actual_value DECIMAL
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    new_alert_id INT;
BEGIN
    -- Generate new alert ID
    SELECT COALESCE(MAX(AlertID), 0) + 1 INTO new_alert_id FROM Alert;
    
    -- Insert new alert
    INSERT INTO Alert (AlertID, DeviceID, SensorID, AlertType, Severity, 
                      Message, ThresholdValue, ActualValue, AlertTime, Status)
    VALUES (new_alert_id, device_id, sensor_id, alert_type, severity, 
            message, threshold_value, actual_value, CURRENT_TIMESTAMP(), 'Active');
    
    RETURN 'Alert generated with ID: ' || new_alert_id;
END;
$$;
```

## IoT Data Classification

### Sensor Data Tags
```sql
-- Create sensor data classification
CREATE OR REPLACE TAG Sensor_Data 
ALLOWED_VALUES 'Temperature', 'Humidity', 'Pressure', 'Motion', 'Location', 'Status' 
COMMENT = 'Sensor data classification for IoT';

-- Apply sensor data tags
ALTER TABLE SensorData MODIFY COLUMN Value SET TAG Sensor_Data = 'Temperature';
ALTER TABLE Device MODIFY COLUMN Latitude SET TAG Sensor_Data = 'Location';
ALTER TABLE Device MODIFY COLUMN Longitude SET TAG Sensor_Data = 'Location';
```

### Alert Data Tags
```sql
-- Create alert data classification
CREATE OR REPLACE TAG Alert_Data 
ALLOWED_VALUES 'Critical', 'Warning', 'Info', 'Maintenance' 
COMMENT = 'Alert data classification for IoT';

-- Apply alert data tags
ALTER TABLE Alert MODIFY COLUMN AlertType SET TAG Alert_Data = 'Critical';
ALTER TABLE Alert MODIFY COLUMN Severity SET TAG Alert_Data = 'Warning';
```

## Role-Based Access Control for IoT

### IoT Roles
```sql
-- Create IoT specific roles
CREATE OR REPLACE ROLE IoTAdmin;
CREATE OR REPLACE ROLE DeviceManager;
CREATE OR REPLACE ROLE DataAnalyst;
CREATE OR REPLACE ROLE MaintenanceTech;

-- Grant database access
GRANT USAGE ON DATABASE IoTDB TO ROLE IoTAdmin;
GRANT USAGE ON DATABASE IoTDB TO ROLE DeviceManager;
GRANT USAGE ON DATABASE IoTDB TO ROLE DataAnalyst;
GRANT USAGE ON DATABASE IoTDB TO ROLE MaintenanceTech;

-- Grant schema access
GRANT USAGE ON SCHEMA IoTDB.iot TO ROLE IoTAdmin;
GRANT USAGE ON SCHEMA IoTDB.iot TO ROLE DeviceManager;
GRANT USAGE ON SCHEMA IoTDB.iot TO ROLE DataAnalyst;
GRANT USAGE ON SCHEMA IoTDB.iot TO ROLE MaintenanceTech;

-- Grant table permissions based on role
GRANT ALL ON ALL TABLES IN SCHEMA iot TO ROLE IoTAdmin;
GRANT SELECT ON Device, Sensor, SensorData TO ROLE DeviceManager;
GRANT SELECT ON device_performance_dashboard, sensor_anomaly_alerts TO ROLE DataAnalyst;
GRANT SELECT ON Device, Alert TO ROLE MaintenanceTech;
```

## Usage in Tutorials

This data model serves as the foundation for:

- **Dynamic Tables** - Real-time sensor data streaming
- **Snowpark ML** - Predictive maintenance and anomaly detection
- **Cortex AI** - Sensor data forecasting and analysis
- **Streamlit Apps** - IoT dashboards and monitoring interfaces
- **Vector Search** - Device and sensor documentation search
- **Data Quality Metrics** - IoT data validation and quality monitoring

## Setup Instructions

### 1. Create Database and Schema
```sql
CREATE OR REPLACE DATABASE IoTDB;
USE DATABASE IoTDB;
CREATE OR REPLACE SCHEMA iot;
USE SCHEMA iot;
```

### 2. Run Complete Setup Script
The full setup script includes:
- IoT table creation
- Sample sensor data insertion
- Device and sensor registration
- IoT-specific functions
- Analytics views
- IoT RBAC configuration

### 3. Verify Setup
```sql
-- Check IoT data counts
SELECT 'Device' as table_name, COUNT(*) as row_count FROM Device
UNION ALL
SELECT 'Sensor', COUNT(*) FROM Sensor
UNION ALL
SELECT 'SensorData', COUNT(*) FROM SensorData
UNION ALL
SELECT 'Alert', COUNT(*) FROM Alert;
```

## Data Model Benefits

### For IoT Learning
- **Time-Series Data** - High-volume sensor data handling
- **Real-time Analytics** - Streaming data processing
- **Geospatial Analysis** - Location-based IoT insights
- **Predictive Maintenance** - Machine learning for device health

### For Demos
- **Scalable Design** - Handles millions of sensor readings
- **Realistic Scenarios** - Based on actual IoT use cases
- **Analytics Ready** - Pre-built views for common IoT analytics
- **Multi-Device** - Supports diverse IoT device types

## Next Steps

- [MediSnowDB Data Model](medisnowdb-data-model.md) - Medical data model
- [SalesDB Data Model](salesdb-data-model.md) - Sales data model
- [CaresDB Data Model](caresdb-data-model.md) - Healthcare data model
- [OrdersDB Data Model](ordersdb-data-model.md) - E-commerce data model

## Resources

- [IoTDB Setup Script](https://complex-teammates-374480.framer.app/demo/iotdb) - Complete implementation
- [Dynamic Tables Tutorial](../engineering-lake/dynamic-tables.md) - Real-time data streaming
- [Snowpark ML Tutorial](../classic-ai-ml/snowpark-ml.md) - Predictive maintenance models

---

## Next Article

[:octicons-arrow-right-24: MediSnowDB Data Model](medisnowdb-data-model.md){ .md-button .md-button--primary }

Dive deeper into medical data warehousing with our advanced MediSnowDB implementation, featuring comprehensive healthcare analytics.
