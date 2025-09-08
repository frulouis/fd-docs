/*
------------------------------------------------------------------------------
-- Snowflake Demo Script: IoT Data Model 
-- 
-- Description: 
-- This script sets up an IoT data model in Snowflake, loads data from an
-- external stage, and prepares the environment for future predictive 
-- maintenance demos.
--
-- DemoHub - IoTDB Data Model - Version 1.2.7 (updated 05/28/2024)
--
-- Features:
-- - IoT sensor data model for predictive maintenance
-- - External stage integration with S3
-- - Schema inference for automatic table creation
-- - Sensor data loading from external sources
-- - File format configuration for CSV data
-- - Ready for ML/AI analysis and predictive modeling
------------------------------------------------------------------------------
*/

-- =====================================================
-- SensorsDB - Enhanced IoT Data Model with Advanced Features
-- Comprehensive IoT data model with geospatial, JSON, time series, and streaming
-- Version: 2.0.0
-- Last Updated: December 2024
-- =====================================================

-- Create database and schema
CREATE OR REPLACE DATABASE SensorsDB;
USE DATABASE SensorsDB;
CREATE OR REPLACE SCHEMA iot;

-- =====================================================
-- TABLES WITH ADVANCED FEATURES
-- =====================================================

-- Enhanced Devices table with geospatial data
CREATE OR REPLACE TABLE iot.devices (
    device_id INT PRIMARY KEY,
    device_name VARCHAR(100) NOT NULL,
    device_type VARCHAR(50),
    device_category VARCHAR(50),
    manufacturer VARCHAR(100),
    model_number VARCHAR(50),
    serial_number VARCHAR(100) UNIQUE,
    installation_date DATE,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    -- Geospatial data
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    altitude DECIMAL(8,2),
    location_description VARCHAR(200),
    -- JSON metadata
    device_metadata VARIANT,
    -- Time series clustering
    cluster_key TIMESTAMP_NTZ,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Enhanced Sensors table with JSON configuration
CREATE OR REPLACE TABLE iot.sensors (
    sensor_id INT PRIMARY KEY,
    device_id INT REFERENCES iot.devices(device_id),
    sensor_name VARCHAR(100),
    sensor_type VARCHAR(50),
    sensor_category VARCHAR(50),
    unit_of_measurement VARCHAR(20),
    min_threshold DECIMAL(10,4),
    max_threshold DECIMAL(10,4),
    -- JSON configuration
    sensor_config VARIANT,
    calibration_data VARIANT,
    -- Geospatial offset from device
    offset_latitude DECIMAL(10,8),
    offset_longitude DECIMAL(11,8),
    offset_altitude DECIMAL(8,2),
    -- Time series clustering
    cluster_key TIMESTAMP_NTZ,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Enhanced Sensor Data with JSON readings and geospatial
CREATE OR REPLACE TABLE iot.sensor_data (
    reading_id INT PRIMARY KEY,
    sensor_id INT REFERENCES iot.sensors(sensor_id),
    device_id INT REFERENCES iot.devices(device_id),
    -- Time series with clustering
    timestamp TIMESTAMP_NTZ,
    cluster_key TIMESTAMP_NTZ,
    -- JSON sensor readings
    sensor_readings VARIANT,
    -- Computed geospatial location
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    altitude DECIMAL(8,2),
    -- Aggregated metrics
    avg_value DECIMAL(10,4),
    min_value DECIMAL(10,4),
    max_value DECIMAL(10,4),
    std_dev DECIMAL(10,4),
    -- Quality indicators
    data_quality_score DECIMAL(3,2),
    confidence_level DECIMAL(3,2),
    -- Metadata
    reading_metadata VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Geospatial Zones table
CREATE OR REPLACE TABLE iot.geospatial_zones (
    zone_id INT PRIMARY KEY,
    zone_name VARCHAR(100),
    zone_type VARCHAR(50),
    zone_category VARCHAR(50),
    -- Geospatial polygon (GeoJSON format)
    zone_boundary VARIANT,
    -- Center point
    center_latitude DECIMAL(10,8),
    center_longitude DECIMAL(11,8),
    radius_meters DECIMAL(10,2),
    -- Zone metadata
    zone_metadata VARIANT,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Device Zones mapping
CREATE OR REPLACE TABLE iot.device_zones (
    mapping_id INT PRIMARY KEY,
    device_id INT REFERENCES iot.devices(device_id),
    zone_id INT REFERENCES iot.geospatial_zones(zone_id),
    relationship_type VARCHAR(50),
    -- Geospatial relationship data
    distance_from_center DECIMAL(10,2),
    zone_position VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Enhanced Alerts with geospatial context
CREATE OR REPLACE TABLE iot.alerts (
    alert_id INT PRIMARY KEY,
    device_id INT REFERENCES iot.devices(device_id),
    sensor_id INT REFERENCES iot.sensors(sensor_id),
    zone_id INT REFERENCES iot.geospatial_zones(zone_id),
    alert_type VARCHAR(50),
    alert_severity VARCHAR(20),
    alert_message TEXT,
    -- Geospatial alert context
    alert_location VARIANT,
    affected_area VARIANT,
    -- JSON alert data
    alert_data VARIANT,
    -- Time series clustering
    timestamp TIMESTAMP_NTZ,
    cluster_key TIMESTAMP_NTZ,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    resolved_date TIMESTAMP_NTZ,
    resolved_by VARCHAR(100),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Time Series Aggregations
CREATE OR REPLACE TABLE iot.time_series_aggregations (
    aggregation_id INT PRIMARY KEY,
    sensor_id INT REFERENCES iot.sensors(sensor_id),
    device_id INT REFERENCES iot.devices(device_id),
    zone_id INT REFERENCES iot.geospatial_zones(zone_id),
    -- Time granularity
    time_granularity VARCHAR(20), -- minute, hour, day, week, month
    time_bucket TIMESTAMP_NTZ,
    cluster_key TIMESTAMP_NTZ,
    -- Aggregated metrics
    reading_count INT,
    avg_value DECIMAL(10,4),
    min_value DECIMAL(10,4),
    max_value DECIMAL(10,4),
    std_dev DECIMAL(10,4),
    -- Geospatial aggregation
    avg_latitude DECIMAL(10,8),
    avg_longitude DECIMAL(11,8),
    avg_altitude DECIMAL(8,2),
    -- JSON aggregated data
    aggregated_data VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SAMPLE DATA WITH ADVANCED FEATURES
-- =====================================================

-- Insert devices with geospatial data and JSON metadata
INSERT INTO iot.devices (device_id, device_name, device_type, device_category, manufacturer, model_number, serial_number, installation_date, latitude, longitude, altitude, location_description, device_metadata, cluster_key) VALUES
(1, 'Smart Factory Sensor Hub 01', 'Sensor Hub', 'Manufacturing', 'IoT Solutions Inc.', 'SH-2024-001', 'SN001234567', '2024-01-15', 37.7749, -122.4194, 15.5, 'Factory Floor - Building A', 
PARSE_JSON('{"facility": "Main Factory", "building": "A", "floor": "1", "department": "Production", "power_consumption": 45.2, "network_protocol": "WiFi", "firmware_version": "2.1.3"}'),
'2024-01-01 00:00:00'::TIMESTAMP_NTZ),

(2, 'Warehouse Temperature Monitor 02', 'Temperature Monitor', 'Logistics', 'ClimateTech Corp.', 'TM-2024-002', 'SN002345678', '2024-02-20', 37.7849, -122.4094, 12.0, 'Warehouse - Cold Storage',
PARSE_JSON('{"facility": "Distribution Center", "building": "B", "section": "Cold Storage", "temperature_range": {"min": -20, "max": 5}, "humidity_control": true, "alarm_thresholds": {"low": -25, "high": 10}}'),
'2024-01-01 00:00:00'::TIMESTAMP_NTZ),

(3, 'Office Building HVAC Controller 03', 'HVAC Controller', 'Facilities', 'ClimateTech Corp.', 'HVAC-2024-003', 'SN003456789', '2024-03-10', 37.7949, -122.3994, 25.0, 'Office Building - Floor 3',
PARSE_JSON('{"facility": "Corporate Office", "building": "C", "floor": "3", "zone": "Engineering", "heating_capacity": 50000, "cooling_capacity": 60000, "energy_efficiency": "A+", "maintenance_schedule": "monthly"}'),
'2024-01-01 00:00:00'::TIMESTAMP_NTZ),

(4, 'Parking Lot Security Camera 04', 'Security Camera', 'Security', 'SecureVision Inc.', 'SC-2024-004', 'SN004567890', '2024-04-05', 37.8049, -122.3894, 8.0, 'Parking Lot - North Entrance',
PARSE_JSON('{"facility": "Main Campus", "area": "Parking", "camera_type": "PTZ", "resolution": "4K", "night_vision": true, "motion_detection": true, "storage_days": 30, "ai_analytics": true}'),
'2024-01-01 00:00:00'::TIMESTAMP_NTZ),

(5, 'Solar Panel Array Monitor 05', 'Solar Monitor', 'Energy', 'SolarTech Ltd.', 'SM-2024-005', 'SN005678901', '2024-05-12', 37.8149, -122.3794, 5.0, 'Solar Farm - Array A',
PARSE_JSON('{"facility": "Solar Farm", "array": "A", "panel_count": 1000, "max_capacity_kw": 500, "efficiency": 0.22, "tracking_system": "dual-axis", "weather_resistant": true, "maintenance_required": false}'),
'2024-01-01 00:00:00'::TIMESTAMP_NTZ);

-- Insert sensors with JSON configuration
INSERT INTO iot.sensors (sensor_id, device_id, sensor_name, sensor_type, sensor_category, unit_of_measurement, min_threshold, max_threshold, sensor_config, calibration_data, offset_latitude, offset_longitude, offset_altitude, cluster_key) VALUES
(1, 1, 'Temperature Sensor 1', 'Temperature', 'Environmental', '°C', -40.0, 85.0, 
PARSE_JSON('{"accuracy": "±0.5°C", "response_time": "2s", "sampling_rate": "1Hz", "calibration_date": "2024-01-10", "next_calibration": "2024-07-10"}'),
PARSE_JSON('{"calibration_points": [{"temp": 0, "reading": 0.1}, {"temp": 25, "reading": 25.0}, {"temp": 50, "reading": 50.2}], "drift_rate": "0.1°C/year"}'),
0.0001, 0.0001, 0.5, '2024-01-01 00:00:00'::TIMESTAMP_NTZ),

(2, 1, 'Humidity Sensor 1', 'Humidity', 'Environmental', '%RH', 0.0, 100.0,
PARSE_JSON('{"accuracy": "±2%RH", "response_time": "5s", "sampling_rate": "0.5Hz", "calibration_date": "2024-01-10", "next_calibration": "2024-07-10"}'),
PARSE_JSON('{"calibration_points": [{"humidity": 20, "reading": 20.5}, {"humidity": 50, "reading": 50.0}, {"humidity": 80, "reading": 79.8}], "drift_rate": "1%RH/year"}'),
0.0002, 0.0002, 0.5, '2024-01-01 00:00:00'::TIMESTAMP_NTZ),

(3, 2, 'Temperature Sensor 2', 'Temperature', 'Environmental', '°C', -50.0, 50.0,
PARSE_JSON('{"accuracy": "±0.2°C", "response_time": "1s", "sampling_rate": "2Hz", "calibration_date": "2024-02-15", "next_calibration": "2024-08-15", "cryogenic_rated": true}'),
PARSE_JSON('{"calibration_points": [{"temp": -40, "reading": -40.1}, {"temp": 0, "reading": 0.0}, {"temp": 25, "reading": 25.0}], "drift_rate": "0.05°C/year"}'),
0.0001, 0.0001, 0.3, '2024-01-01 00:00:00'::TIMESTAMP_NTZ),

(4, 3, 'Air Quality Sensor 1', 'Air Quality', 'Environmental', 'ppm', 0.0, 1000.0,
PARSE_JSON('{"accuracy": "±5ppm", "response_time": "10s", "sampling_rate": "0.2Hz", "calibration_date": "2024-03-05", "next_calibration": "2024-09-05", "gases_detected": ["CO2", "VOC", "PM2.5"]}'),
PARSE_JSON('{"calibration_points": [{"gas": "CO2", "concentration": 400, "reading": 402}, {"gas": "VOC", "concentration": 100, "reading": 98}], "drift_rate": "2ppm/year"}'),
0.0003, 0.0003, 0.8, '2024-01-01 00:00:00'::TIMESTAMP_NTZ),

(5, 4, 'Motion Sensor 1', 'Motion', 'Security', 'count', 0, 999999,
PARSE_JSON('{"sensitivity": "high", "detection_range": "10m", "field_of_view": "120°", "sampling_rate": "5Hz", "calibration_date": "2024-04-01", "next_calibration": "2024-10-01"}'),
PARSE_JSON('{"calibration_points": [{"distance": 1, "detection": true}, {"distance": 5, "detection": true}, {"distance": 10, "detection": true}], "false_positive_rate": "0.1%"}'),
0.0004, 0.0004, 1.2, '2024-01-01 00:00:00'::TIMESTAMP_NTZ);

-- Insert sensor data with JSON readings and geospatial data
INSERT INTO iot.sensor_data (reading_id, sensor_id, device_id, timestamp, cluster_key, sensor_readings, latitude, longitude, altitude, avg_value, min_value, max_value, std_dev, data_quality_score, confidence_level, reading_metadata) VALUES
(1, 1, 1, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ,
PARSE_JSON('{"temperature": 23.5, "humidity": 45.2, "pressure": 1013.25, "light_level": 850, "battery_level": 95.5, "signal_strength": -45}'),
37.7749, -122.4194, 16.0, 23.5, 23.5, 23.5, 0.0, 0.98, 0.95,
PARSE_JSON('{"weather": {"condition": "sunny", "wind_speed": 5.2, "wind_direction": "NW"}, "environment": {"noise_level": 65.3, "air_quality": "good"}}')),

(2, 2, 1, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ,
PARSE_JSON('{"humidity": 45.2, "dew_point": 11.8, "absolute_humidity": 8.9, "relative_humidity": 45.2, "battery_level": 94.8, "signal_strength": -42}'),
37.7749, -122.4194, 16.0, 45.2, 45.2, 45.2, 0.0, 0.97, 0.94,
PARSE_JSON('{"environment": {"comfort_level": "comfortable", "mold_risk": "low"}, "calibration": {"last_calibration": "2024-01-10", "drift": 0.1}}')),

(3, 3, 2, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ,
PARSE_JSON('{"temperature": -18.5, "humidity": 85.3, "frost_formation": false, "defrost_cycle": false, "battery_level": 87.2, "signal_strength": -38}'),
37.7849, -122.4094, 12.3, -18.5, -18.5, -18.5, 0.0, 0.99, 0.96,
PARSE_JSON('{"storage": {"product_type": "frozen_foods", "capacity_utilization": 75.5}, "energy": {"compressor_status": "running", "efficiency": 0.85}}')),

(4, 4, 3, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ,
PARSE_JSON('{"co2_level": 450, "voc_level": 125, "pm25_level": 12.5, "air_quality_index": 45, "ventilation_status": "normal", "battery_level": 92.1, "signal_strength": -41}'),
37.7949, -122.3994, 25.8, 450.0, 450.0, 450.0, 0.0, 0.96, 0.93,
PARSE_JSON('{"occupancy": {"people_count": 15, "activity_level": "moderate"}, "hvac": {"filter_status": "good", "last_filter_change": "2024-11-15"}}')),

(5, 5, 4, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ,
PARSE_JSON('{"motion_detected": true, "motion_count": 3, "detection_confidence": 0.92, "object_size": "medium", "object_speed": 2.5, "battery_level": 89.7, "signal_strength": -35}'),
37.8049, -122.3894, 9.2, 3.0, 3.0, 3.0, 0.0, 0.94, 0.92,
PARSE_JSON('{"security": {"threat_level": "low", "alert_sent": false}, "camera": {"recording": true, "storage_remaining": "85%"}}'));

-- Insert geospatial zones
INSERT INTO iot.geospatial_zones (zone_id, zone_name, zone_type, zone_category, zone_boundary, center_latitude, center_longitude, radius_meters, zone_metadata, status) VALUES
(1, 'Factory Floor Zone A', 'Production', 'Manufacturing',
PARSE_JSON('{"type": "Polygon", "coordinates": [[[-122.4199, 37.7744], [-122.4189, 37.7744], [-122.4189, 37.7754], [-122.4199, 37.7754], [-122.4199, 37.7744]]]}'),
37.7749, -122.4194, 50.0,
PARSE_JSON('{"facility": "Main Factory", "building": "A", "floor": "1", "department": "Production", "capacity": 100, "safety_requirements": ["PPE", "Temperature Monitoring"]}'),
'ACTIVE'),

(2, 'Cold Storage Zone B', 'Storage', 'Logistics',
PARSE_JSON('{"type": "Polygon", "coordinates": [[[-122.4099, 37.7844], [-122.4089, 37.7844], [-122.4089, 37.7854], [-122.4099, 37.7854], [-122.4099, 37.7844]]]}'),
37.7849, -122.4094, 30.0,
PARSE_JSON('{"facility": "Distribution Center", "building": "B", "section": "Cold Storage", "temperature_range": {"min": -25, "max": 5}, "capacity": 5000, "safety_requirements": ["Cold Weather Gear", "Temperature Alerts"]}'),
'ACTIVE'),

(3, 'Office Zone C', 'Workspace', 'Administrative',
PARSE_JSON('{"type": "Polygon", "coordinates": [[[-122.3999, 37.7944], [-122.3989, 37.7944], [-122.3989, 37.7954], [-122.3999, 37.7954], [-122.3999, 37.7944]]]}'),
37.7949, -122.3994, 40.0,
PARSE_JSON('{"facility": "Corporate Office", "building": "C", "floor": "3", "zone": "Engineering", "occupancy": 50, "comfort_requirements": ["Temperature: 20-24°C", "Humidity: 40-60%", "Air Quality: Good"]}'),
'ACTIVE'),

(4, 'Parking Zone D', 'Security', 'Facilities',
PARSE_JSON('{"type": "Polygon", "coordinates": [[[-122.3899, 37.8044], [-122.3889, 37.8044], [-122.3889, 37.8054], [-122.3899, 37.8054], [-122.3899, 37.8044]]]}'),
37.8049, -122.3894, 60.0,
PARSE_JSON('{"facility": "Main Campus", "area": "Parking", "capacity": 200, "security_level": "medium", "monitoring": ["Motion Detection", "Video Recording", "Access Control"]}'),
'ACTIVE'),

(5, 'Solar Farm Zone E', 'Energy', 'Renewable',
PARSE_JSON('{"type": "Polygon", "coordinates": [[[-122.3799, 37.8144], [-122.3789, 37.8144], [-122.3789, 37.8154], [-122.3799, 37.8154], [-122.3799, 37.8144]]]}'),
37.8149, -122.3794, 100.0,
PARSE_JSON('{"facility": "Solar Farm", "array": "A", "panel_count": 1000, "max_capacity_kw": 500, "monitoring": ["Performance", "Weather", "Maintenance"]}'),
'ACTIVE');

-- Insert device-zone mappings
INSERT INTO iot.device_zones (mapping_id, device_id, zone_id, relationship_type, distance_from_center, zone_position) VALUES
(1, 1, 1, 'PRIMARY', 5.2, PARSE_JSON('{"x": 5.2, "y": 3.1, "z": 0.5}')),
(2, 2, 2, 'PRIMARY', 2.8, PARSE_JSON('{"x": 2.8, "y": 1.5, "z": 0.3}')),
(3, 3, 3, 'PRIMARY', 4.1, PARSE_JSON('{"x": 4.1, "y": 2.8, "z": 0.8}')),
(4, 4, 4, 'PRIMARY', 8.5, PARSE_JSON('{"x": 8.5, "y": 6.2, "z": 1.2}')),
(5, 5, 5, 'PRIMARY', 12.3, PARSE_JSON('{"x": 12.3, "y": 8.9, "z": 0.5}'));

-- Insert alerts with geospatial context
INSERT INTO iot.alerts (alert_id, device_id, sensor_id, zone_id, alert_type, alert_severity, alert_message, alert_location, affected_area, alert_data, timestamp, cluster_key, status) VALUES
(1, 1, 1, 1, 'TEMPERATURE_HIGH', 'MEDIUM', 'Temperature exceeded normal range in Factory Zone A',
PARSE_JSON('{"latitude": 37.7749, "longitude": -122.4194, "altitude": 16.0}'),
PARSE_JSON('{"zone_id": 1, "zone_name": "Factory Floor Zone A", "affected_devices": [1, 2]}'),
PARSE_JSON('{"threshold": 25.0, "current_value": 26.8, "duration": "15 minutes", "trend": "increasing"}'),
'2024-12-01 10:15:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 'ACTIVE'),

(2, 2, 3, 2, 'TEMPERATURE_CRITICAL', 'HIGH', 'Critical temperature drop in Cold Storage Zone B',
PARSE_JSON('{"latitude": 37.7849, "longitude": -122.4094, "altitude": 12.3}'),
PARSE_JSON('{"zone_id": 2, "zone_name": "Cold Storage Zone B", "affected_devices": [2]}'),
PARSE_JSON('{"threshold": -20.0, "current_value": -22.5, "duration": "5 minutes", "trend": "decreasing", "product_risk": "high"}'),
'2024-12-01 10:20:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 'ACTIVE'),

(3, 4, 5, 4, 'MOTION_DETECTED', 'LOW', 'Motion detected in Parking Zone D during off-hours',
PARSE_JSON('{"latitude": 37.8049, "longitude": -122.3894, "altitude": 9.2}'),
PARSE_JSON('{"zone_id": 4, "zone_name": "Parking Zone D", "affected_devices": [4]}'),
PARSE_JSON('{"motion_count": 3, "detection_confidence": 0.92, "time_of_day": "22:15", "security_level": "medium"}'),
'2024-12-01 22:15:00'::TIMESTAMP_NTZ, '2024-12-01 22:00:00'::TIMESTAMP_NTZ, 'RESOLVED');

-- Insert time series aggregations
INSERT INTO iot.time_series_aggregations (aggregation_id, sensor_id, device_id, zone_id, time_granularity, time_bucket, cluster_key, reading_count, avg_value, min_value, max_value, std_dev, avg_latitude, avg_longitude, avg_altitude, aggregated_data) VALUES
(1, 1, 1, 1, 'hour', '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 3600, 23.8, 22.1, 25.3, 0.8, 37.7749, -122.4194, 16.0,
PARSE_JSON('{"temperature_stats": {"mean": 23.8, "median": 23.7, "percentiles": {"25": 23.2, "75": 24.3}}, "quality_metrics": {"data_completeness": 0.98, "outlier_count": 12}}')),

(2, 3, 2, 2, 'hour', '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 7200, -18.2, -19.8, -16.5, 0.9, 37.7849, -122.4094, 12.3,
PARSE_JSON('{"temperature_stats": {"mean": -18.2, "median": -18.1, "percentiles": {"25": -18.8, "75": -17.5}}, "quality_metrics": {"data_completeness": 0.99, "outlier_count": 5}}')),

(3, 4, 3, 3, 'hour', '2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 10:00:00'::TIMESTAMP_NTZ, 720, 445.5, 420.0, 480.0, 15.2, 37.7949, -122.3994, 25.8,
PARSE_JSON('{"air_quality_stats": {"co2_mean": 445.5, "voc_mean": 125.3, "pm25_mean": 12.8}, "quality_metrics": {"data_completeness": 0.97, "outlier_count": 8}}'));

-- =====================================================
-- ADVANCED VIEWS WITH GEOSPATIAL AND JSON ANALYSIS
-- =====================================================

-- Geospatial Device Analysis View
CREATE OR REPLACE VIEW iot.geospatial_device_analysis AS
SELECT 
    d.device_id,
    d.device_name,
    d.device_type,
    d.latitude,
    d.longitude,
    d.altitude,
    -- Geospatial calculations
    ST_POINT(d.longitude, d.latitude) as device_point,
    ST_DISTANCE(ST_POINT(d.longitude, d.latitude), ST_POINT(z.center_longitude, z.center_latitude)) as distance_from_zone_center,
    -- JSON analysis
    d.device_metadata:facility::STRING as facility,
    d.device_metadata:building::STRING as building,
    d.device_metadata:department::STRING as department,
    -- Zone information
    z.zone_name,
    z.zone_type,
    z.radius_meters,
    -- Device status
    d.status,
    d.last_maintenance_date,
    d.next_maintenance_date
FROM iot.devices d
LEFT JOIN iot.device_zones dz ON d.device_id = dz.device_id
LEFT JOIN iot.geospatial_zones z ON dz.zone_id = z.zone_id;

-- JSON Sensor Data Analysis View
CREATE OR REPLACE VIEW iot.json_sensor_analysis AS
SELECT 
    sd.reading_id,
    sd.sensor_id,
    sd.device_id,
    sd.timestamp,
    -- JSON sensor readings analysis
    sd.sensor_readings:temperature::DECIMAL(10,4) as temperature,
    sd.sensor_readings:humidity::DECIMAL(10,4) as humidity,
    sd.sensor_readings:pressure::DECIMAL(10,4) as pressure,
    sd.sensor_readings:light_level::INT as light_level,
    sd.sensor_readings:battery_level::DECIMAL(5,2) as battery_level,
    sd.sensor_readings:signal_strength::INT as signal_strength,
    -- JSON metadata analysis
    sd.reading_metadata:weather:condition::STRING as weather_condition,
    sd.reading_metadata:weather:wind_speed::DECIMAL(5,2) as wind_speed,
    sd.reading_metadata:environment:noise_level::DECIMAL(5,2) as noise_level,
    sd.reading_metadata:environment:air_quality::STRING as air_quality,
    -- Quality metrics
    sd.data_quality_score,
    sd.confidence_level,
    -- Geospatial data
    sd.latitude,
    sd.longitude,
    sd.altitude
FROM iot.sensor_data sd
WHERE sd.sensor_readings IS NOT NULL;

-- Time Series Analysis View
CREATE OR REPLACE VIEW iot.time_series_analysis AS
SELECT 
    tsa.aggregation_id,
    tsa.sensor_id,
    tsa.device_id,
    tsa.zone_id,
    tsa.time_granularity,
    tsa.time_bucket,
    tsa.reading_count,
    tsa.avg_value,
    tsa.min_value,
    tsa.max_value,
    tsa.std_dev,
    -- JSON aggregated data analysis
    tsa.aggregated_data:temperature_stats:mean::DECIMAL(10,4) as temp_mean,
    tsa.aggregated_data:temperature_stats:median::DECIMAL(10,4) as temp_median,
    tsa.aggregated_data:quality_metrics:data_completeness::DECIMAL(5,4) as data_completeness,
    tsa.aggregated_data:quality_metrics:outlier_count::INT as outlier_count,
    -- Geospatial aggregation
    tsa.avg_latitude,
    tsa.avg_longitude,
    tsa.avg_altitude,
    -- Device and sensor info
    d.device_name,
    s.sensor_name,
    z.zone_name
FROM iot.time_series_aggregations tsa
JOIN iot.devices d ON tsa.device_id = d.device_id
JOIN iot.sensors s ON tsa.sensor_id = s.sensor_id
LEFT JOIN iot.geospatial_zones z ON tsa.zone_id = z.zone_id;

-- Alert Analysis with Geospatial Context
CREATE OR REPLACE VIEW iot.alert_geospatial_analysis AS
SELECT 
    a.alert_id,
    a.alert_type,
    a.alert_severity,
    a.alert_message,
    a.timestamp,
    a.status,
    -- Geospatial alert data
    a.alert_location:latitude::DECIMAL(10,8) as alert_latitude,
    a.alert_location:longitude::DECIMAL(11,8) as alert_longitude,
    a.alert_location:altitude::DECIMAL(8,2) as alert_altitude,
    -- JSON alert data analysis
    a.alert_data:threshold::DECIMAL(10,4) as threshold,
    a.alert_data:current_value::DECIMAL(10,4) as current_value,
    a.alert_data:duration::STRING as duration,
    a.alert_data:trend::STRING as trend,
    -- Affected area analysis
    a.affected_area:zone_name::STRING as affected_zone,
    a.affected_area:affected_devices::ARRAY as affected_devices,
    -- Device and zone info
    d.device_name,
    d.device_type,
    z.zone_name,
    z.zone_type
FROM iot.alerts a
JOIN iot.devices d ON a.device_id = d.device_id
LEFT JOIN iot.geospatial_zones z ON a.zone_id = z.zone_id;

-- =====================================================
-- STORED PROCEDURES FOR ADVANCED ANALYSIS
-- =====================================================

-- Get devices within geospatial radius
CREATE OR REPLACE PROCEDURE iot.get_devices_in_radius(
    center_lat DECIMAL(10,8), 
    center_lon DECIMAL(11,8), 
    radius_meters DECIMAL(10,2)
)
RETURNS TABLE (
    device_id INT,
    device_name VARCHAR,
    device_type VARCHAR,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    distance_meters DECIMAL(10,2),
    zone_name VARCHAR
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            d.device_id,
            d.device_name,
            d.device_type,
            d.latitude,
            d.longitude,
            ST_DISTANCE(
                ST_POINT(d.longitude, d.latitude), 
                ST_POINT(center_lon, center_lat)
            ) as distance_meters,
            z.zone_name
        FROM iot.devices d
        LEFT JOIN iot.device_zones dz ON d.device_id = dz.device_id
        LEFT JOIN iot.geospatial_zones z ON dz.zone_id = z.zone_id
        WHERE ST_DISTANCE(
            ST_POINT(d.longitude, d.latitude), 
            ST_POINT(center_lon, center_lat)
        ) <= radius_meters
        ORDER BY distance_meters
    );
END;
$$;

-- Analyze JSON sensor data trends
CREATE OR REPLACE PROCEDURE iot.analyze_sensor_trends(
    sensor_id_param INT,
    hours_back INT
)
RETURNS TABLE (
    timestamp TIMESTAMP_NTZ,
    temperature DECIMAL(10,4),
    humidity DECIMAL(10,4),
    battery_level DECIMAL(5,2),
    signal_strength INT,
    data_quality_score DECIMAL(3,2)
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            sd.timestamp,
            sd.sensor_readings:temperature::DECIMAL(10,4) as temperature,
            sd.sensor_readings:humidity::DECIMAL(10,4) as humidity,
            sd.sensor_readings:battery_level::DECIMAL(5,2) as battery_level,
            sd.sensor_readings:signal_strength::INT as signal_strength,
            sd.data_quality_score
        FROM iot.sensor_data sd
        WHERE sd.sensor_id = sensor_id_param
        AND sd.timestamp >= DATEADD('hour', -hours_back, CURRENT_TIMESTAMP())
        ORDER BY sd.timestamp DESC
    );
END;
$$;

-- =====================================================
-- TAGS FOR DATA GOVERNANCE
-- =====================================================

-- Create tags
CREATE OR REPLACE TAG iot.GEOSPATIAL_DATA_TAG;
CREATE OR REPLACE TAG iot.JSON_DATA_TAG;
CREATE OR REPLACE TAG iot.TIME_SERIES_DATA_TAG;
CREATE OR REPLACE TAG iot.SENSOR_DATA_TAG;

-- Apply tags to sensitive columns
ALTER TABLE iot.devices MODIFY COLUMN latitude SET TAG iot.GEOSPATIAL_DATA_TAG = 'LATITUDE';
ALTER TABLE iot.devices MODIFY COLUMN longitude SET TAG iot.GEOSPATIAL_DATA_TAG = 'LONGITUDE';
ALTER TABLE iot.devices MODIFY COLUMN device_metadata SET TAG iot.JSON_DATA_TAG = 'DEVICE_METADATA';
ALTER TABLE iot.sensor_data MODIFY COLUMN sensor_readings SET TAG iot.JSON_DATA_TAG = 'SENSOR_READINGS';
ALTER TABLE iot.sensor_data MODIFY COLUMN timestamp SET TAG iot.TIME_SERIES_DATA_TAG = 'TIMESTAMP';
ALTER TABLE iot.sensor_data MODIFY COLUMN avg_value SET TAG iot.SENSOR_DATA_TAG = 'SENSOR_VALUE';

-- =====================================================
-- COMMENTS
-- =====================================================

-- Table comments
COMMENT ON TABLE iot.devices IS 'IoT devices with geospatial data and JSON metadata';
COMMENT ON TABLE iot.sensors IS 'Sensors with JSON configuration and geospatial positioning';
COMMENT ON TABLE iot.sensor_data IS 'Time series sensor data with JSON readings and geospatial context';
COMMENT ON TABLE iot.geospatial_zones IS 'Geospatial zones with GeoJSON boundaries';
COMMENT ON TABLE iot.device_zones IS 'Device-zone relationships with geospatial positioning';
COMMENT ON TABLE iot.alerts IS 'Alerts with geospatial context and JSON data';
COMMENT ON TABLE iot.time_series_aggregations IS 'Time series aggregations with JSON analytics';

-- Column comments
COMMENT ON COLUMN iot.devices.device_metadata IS 'JSON metadata containing device configuration and operational data';
COMMENT ON COLUMN iot.sensors.sensor_config IS 'JSON configuration for sensor parameters and calibration';
COMMENT ON COLUMN iot.sensor_data.sensor_readings IS 'JSON object containing all sensor readings and measurements';
COMMENT ON COLUMN iot.sensor_data.reading_metadata IS 'JSON metadata about environmental conditions and context';
COMMENT ON COLUMN iot.geospatial_zones.zone_boundary IS 'GeoJSON polygon defining zone boundaries';
COMMENT ON COLUMN iot.alerts.alert_location IS 'JSON object containing geospatial alert location';
COMMENT ON COLUMN iot.alerts.alert_data IS 'JSON object containing alert details and thresholds';

-- =====================================================
-- CLEANUP (UNCOMMENT TO RESET)
-- =====================================================

/*
-- Drop all objects
DROP DATABASE IF EXISTS SensorsDB CASCADE;
*/ 