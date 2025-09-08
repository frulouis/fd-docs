-- =====================================================
-- GEOSPATIALDB - Advanced Geospatial Data Model
-- Specialized geospatial model for Snowflake demonstrations
-- Version: 1.0.0
-- Last Updated: December 2024
-- =====================================================

-- Create database and schema
CREATE OR REPLACE DATABASE GEOSPATIALDB;
USE DATABASE GEOSPATIALDB;
CREATE OR REPLACE SCHEMA geo;

-- =====================================================
-- TABLES WITH ADVANCED GEOSPATIAL FEATURES
-- =====================================================

-- Cities table with point geometry
CREATE OR REPLACE TABLE geo.cities (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state VARCHAR(50),
    country VARCHAR(50),
    population INT,
    area_sq_km DECIMAL(10,2),
    -- Geospatial point
    location GEOGRAPHY,
    -- Additional coordinates for reference
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    elevation_m DECIMAL(8,2),
    -- JSON metadata
    city_metadata VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Transportation routes with line geometry
CREATE OR REPLACE TABLE geo.transportation_routes (
    route_id INT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    route_type VARCHAR(50), -- highway, railway, subway, bus
    route_number VARCHAR(20),
    start_city_id INT REFERENCES geo.cities(city_id),
    end_city_id INT REFERENCES geo.cities(city_id),
    -- Geospatial line
    route_geometry GEOGRAPHY,
    -- Route properties
    length_km DECIMAL(10,2),
    speed_limit_kmh INT,
    lanes INT,
    -- JSON route data
    route_metadata VARIANT,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Administrative boundaries with polygon geometry
CREATE OR REPLACE TABLE geo.administrative_boundaries (
    boundary_id INT PRIMARY KEY,
    boundary_name VARCHAR(100) NOT NULL,
    boundary_type VARCHAR(50), -- country, state, county, city, district
    parent_boundary_id INT REFERENCES geo.administrative_boundaries(boundary_id),
    -- Geospatial polygon
    boundary_geometry GEOGRAPHY,
    -- Boundary properties
    area_sq_km DECIMAL(12,2),
    population INT,
    -- JSON boundary data
    boundary_metadata VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Points of Interest with enhanced geospatial features
CREATE OR REPLACE TABLE geo.points_of_interest (
    poi_id INT PRIMARY KEY,
    poi_name VARCHAR(200) NOT NULL,
    poi_type VARCHAR(100), -- restaurant, hotel, museum, park, hospital, school
    poi_category VARCHAR(50),
    -- Geospatial point
    location GEOGRAPHY,
    -- Additional coordinates
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    altitude DECIMAL(8,2),
    -- POI properties
    address TEXT,
    phone VARCHAR(20),
    website VARCHAR(200),
    rating DECIMAL(3,2),
    -- JSON POI data
    poi_metadata VARIANT,
    -- Spatial clustering
    cluster_id INT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Real-time location tracking
CREATE OR REPLACE TABLE geo.location_tracking (
    tracking_id INT PRIMARY KEY,
    entity_id INT, -- could be vehicle, person, asset
    entity_type VARCHAR(50),
    -- Geospatial point with timestamp
    location GEOGRAPHY,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    altitude DECIMAL(8,2),
    -- Tracking properties
    timestamp TIMESTAMP_NTZ,
    speed_kmh DECIMAL(6,2),
    heading_degrees DECIMAL(5,2),
    accuracy_m DECIMAL(6,2),
    -- JSON tracking data
    tracking_metadata VARIANT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Geospatial events and incidents
CREATE OR REPLACE TABLE geo.spatial_events (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(200) NOT NULL,
    event_type VARCHAR(100), -- accident, construction, weather, traffic
    event_severity VARCHAR(20), -- low, medium, high, critical
    -- Geospatial point or polygon
    event_geometry GEOGRAPHY,
    -- Event properties
    start_time TIMESTAMP_NTZ,
    end_time TIMESTAMP_NTZ,
    affected_area_sq_km DECIMAL(10,2),
    -- JSON event data
    event_metadata VARIANT,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Geospatial analytics and metrics
CREATE OR REPLACE TABLE geo.spatial_analytics (
    analytics_id INT PRIMARY KEY,
    analysis_type VARCHAR(100), -- density, proximity, accessibility, coverage
    target_geometry GEOGRAPHY,
    -- Analysis parameters
    analysis_parameters VARIANT,
    -- Results
    result_value DECIMAL(15,4),
    result_geometry GEOGRAPHY,
    result_metadata VARIANT,
    -- Analysis metadata
    analysis_date TIMESTAMP_NTZ,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SAMPLE DATA WITH ADVANCED GEOSPATIAL FEATURES
-- =====================================================

-- Insert cities with point geometry
INSERT INTO geo.cities (city_id, city_name, state, country, population, area_sq_km, location, latitude, longitude, elevation_m, city_metadata) VALUES
(1, 'San Francisco', 'California', 'USA', 873965, 121.4, 
ST_POINT(-122.4194, 37.7749), 37.7749, -122.4194, 16.0,
PARSE_JSON('{"timezone": "PST", "climate": "Mediterranean", "landmarks": ["Golden Gate Bridge", "Alcatraz", "Fisherman\'s Wharf"], "economy": {"gdp_billion": 501, "major_industries": ["Technology", "Tourism", "Finance"]}}')),

(2, 'Los Angeles', 'California', 'USA', 3979576, 1302.0,
ST_POINT(-118.2437, 34.0522), 34.0522, -118.2437, 93.0,
PARSE_JSON('{"timezone": "PST", "climate": "Mediterranean", "landmarks": ["Hollywood Sign", "Venice Beach", "Griffith Observatory"], "economy": {"gdp_billion": 1046, "major_industries": ["Entertainment", "Technology", "Tourism"]}}')),

(3, 'New York City', 'New York', 'USA', 8336817, 778.2,
ST_POINT(-74.0060, 40.7128), 40.7128, -74.0060, 10.0,
PARSE_JSON('{"timezone": "EST", "climate": "Humid Subtropical", "landmarks": ["Statue of Liberty", "Times Square", "Central Park"], "economy": {"gdp_billion": 1777, "major_industries": ["Finance", "Media", "Technology"]}}')),

(4, 'Chicago', 'Illinois', 'USA', 2693976, 606.1,
ST_POINT(-87.6298, 41.8781), 41.8781, -87.6298, 179.0,
PARSE_JSON('{"timezone": "CST", "climate": "Humid Continental", "landmarks": ["Millennium Park", "Navy Pier", "Willis Tower"], "economy": {"gdp_billion": 689, "major_industries": ["Finance", "Manufacturing", "Transportation"]}}')),

(5, 'Miami', 'Florida', 'USA', 442241, 143.1,
ST_POINT(-80.1918, 25.7617), 25.7617, -80.1918, 2.0,
PARSE_JSON('{"timezone": "EST", "climate": "Tropical", "landmarks": ["South Beach", "Art Deco District", "Vizcaya Museum"], "economy": {"gdp_billion": 344, "major_industries": ["Tourism", "Real Estate", "International Trade"]}}'));

-- Insert transportation routes with line geometry
INSERT INTO geo.transportation_routes (route_id, route_name, route_type, route_number, start_city_id, end_city_id, route_geometry, length_km, speed_limit_kmh, lanes, route_metadata) VALUES
(1, 'Interstate 5', 'highway', 'I-5', 1, 2,
ST_LINESTRING('LINESTRING(-122.4194 37.7749, -118.2437 34.0522)'), 615.0, 110, 6,
PARSE_JSON('{"construction_year": 1964, "last_renovation": 2020, "toll_road": false, "rest_stops": 15, "emergency_services": true}')),

(2, 'Pacific Coast Highway', 'highway', 'CA-1', 1, 2,
ST_LINESTRING('LINESTRING(-122.4194 37.7749, -122.5000 37.7000, -118.2437 34.0522)'), 1055.0, 90, 4,
PARSE_JSON('{"construction_year": 1937, "last_renovation": 2019, "toll_road": false, "scenic_route": true, "rest_stops": 25}')),

(3, 'Amtrak Coast Starlight', 'railway', 'AMTK-11', 1, 2,
ST_LINESTRING('LINESTRING(-122.4194 37.7749, -121.5000 36.8000, -118.2437 34.0522)'), 1377.0, 130, 2,
PARSE_JSON('{"service_start": 1971, "daily_trains": 1, "scenic_route": true, "dining_car": true, "sleeper_cars": true}')),

(4, 'BART Red Line', 'subway', 'BART-RED', 1, 1,
ST_LINESTRING('LINESTRING(-122.4194 37.7749, -122.4000 37.7500, -122.3800 37.7300)'), 25.0, 80, 2,
PARSE_JSON('{"opening_year": 1972, "stations": 19, "daily_riders": 400000, "electric": true, "automated": true}')),

(5, 'Metro Red Line', 'subway', 'LA-RED', 2, 2,
ST_LINESTRING('LINESTRING(-118.2437 34.0522, -118.2000 34.1000, -118.1500 34.1500)'), 30.0, 70, 2,
PARSE_JSON('{"opening_year": 1993, "stations": 14, "daily_riders": 150000, "electric": true, "underground": true}'));

-- Insert administrative boundaries with polygon geometry
INSERT INTO geo.administrative_boundaries (boundary_id, boundary_name, boundary_type, boundary_geometry, area_sq_km, population, boundary_metadata) VALUES
(1, 'California', 'state',
ST_POLYGON('POLYGON((-124.4096 32.5121, -114.1312 32.5121, -114.1312 42.0095, -124.4096 42.0095, -124.4096 32.5121))'), 423970.0, 39538223,
PARSE_JSON('{"capital": "Sacramento", "governor": "Gavin Newsom", "timezone": "PST", "major_cities": ["Los Angeles", "San Francisco", "San Diego"]}')),

(2, 'San Francisco County', 'county',
ST_POLYGON('POLYGON((-122.5194 37.7074, -122.3194 37.7074, -122.3194 37.8424, -122.5194 37.8424, -122.5194 37.7074))'), 121.4, 873965,
PARSE_JSON('{"county_seat": "San Francisco", "supervisor_count": 11, "incorporated_cities": 1, "unincorporated_areas": 0}')),

(3, 'Los Angeles County', 'county',
ST_POLYGON('POLYGON((-118.9437 33.7522, -117.5437 33.7522, -117.5437 34.3522, -118.9437 34.3522, -118.9437 33.7522))'), 12308.0, 10039107,
PARSE_JSON('{"county_seat": "Los Angeles", "supervisor_count": 5, "incorporated_cities": 88, "unincorporated_areas": 140}')),

(4, 'New York State', 'state',
ST_POLYGON('POLYGON((-79.7620 40.4960, -71.7770 40.4960, -71.7770 45.0159, -79.7620 45.0159, -79.7620 40.4960))'), 141297.0, 20215751,
PARSE_JSON('{"capital": "Albany", "governor": "Kathy Hochul", "timezone": "EST", "major_cities": ["New York City", "Buffalo", "Rochester"]}')),

(5, 'Manhattan', 'borough',
ST_POLYGON('POLYGON((-74.0260 40.7028, -73.9060 40.7028, -73.9060 40.8828, -74.0260 40.8828, -74.0260 40.7028))'), 59.1, 1628706,
PARSE_JSON('{"borough_president": "Mark Levine", "neighborhoods": ["Financial District", "Midtown", "Upper East Side", "Upper West Side"], "landmarks": ["Central Park", "Times Square", "Empire State Building"]}'));

-- Insert points of interest with enhanced geospatial features
INSERT INTO geo.points_of_interest (poi_id, poi_name, poi_type, poi_category, location, latitude, longitude, altitude, address, phone, website, rating, poi_metadata, cluster_id) VALUES
(1, 'Golden Gate Bridge', 'landmark', 'tourist_attraction',
ST_POINT(-122.4794, 37.8199), 37.8199, -122.4794, 67.0,
'Golden Gate Bridge, San Francisco, CA 94129', '+1-415-921-5858', 'https://www.goldengate.org', 4.8,
PARSE_JSON('{"construction_year": 1937, "length_m": 1280, "height_m": 227, "color": "International Orange", "daily_crossings": 110000, "toll": {"southbound_only": true, "amount": 8.75}}'),
1),

(2, 'Disneyland', 'amusement_park', 'entertainment',
ST_POINT(-117.9189, 33.8121), 33.8121, -117.9189, 35.0,
'1313 Disneyland Dr, Anaheim, CA 92802', '+1-714-781-4636', 'https://disneyland.disney.go.com', 4.6,
PARSE_JSON('{"opening_year": 1955, "size_acres": 500, "annual_visitors": 18000000, "rides": 57, "hotels": 3, "ticket_price": {"adult": 159, "child": 150}}'),
2),

(3, 'Times Square', 'landmark', 'tourist_attraction',
ST_POINT(-73.9855, 40.7580), 40.7580, -73.9855, 10.0,
'Times Square, New York, NY 10036', NULL, 'https://www.timessquarenyc.org', 4.4,
PARSE_JSON('{"annual_visitors": 50000000, "billboards": 230, "theaters": 40, "restaurants": 300, "events": ["New Year\'s Eve Ball Drop", "Broadway Shows"]}'),
3),

(4, 'Millennium Park', 'park', 'recreation',
ST_POINT(-87.6236, 41.8825), 41.8825, -87.6236, 179.0,
'201 E Randolph St, Chicago, IL 60602', '+1-312-742-1168', 'https://www.chicago.gov/millenniumpark', 4.7,
PARSE_JSON('{"opening_year": 2004, "size_acres": 24.5, "annual_visitors": 25000000, "attractions": ["Cloud Gate", "Crown Fountain", "Jay Pritzker Pavilion"], "free_events": true}'),
4),

(5, 'South Beach', 'beach', 'recreation',
ST_POINT(-80.1300, 25.7850), 25.7850, -80.1300, 2.0,
'South Beach, Miami Beach, FL 33139', NULL, 'https://www.miamibeachfl.gov', 4.5,
PARSE_JSON('{"length_miles": 2.5, "water_temperature_avg": 78, "activities": ["swimming", "volleyball", "people_watching"], "famous_for": ["Art Deco Architecture", "Nightlife", "Beach Culture"]}'),
5);

-- Insert real-time location tracking data
INSERT INTO geo.location_tracking (tracking_id, entity_id, entity_type, location, latitude, longitude, altitude, timestamp, speed_kmh, heading_degrees, accuracy_m, tracking_metadata) VALUES
(1, 101, 'delivery_vehicle',
ST_POINT(-122.4194, 37.7749), 37.7749, -122.4194, 16.0,
'2024-12-01 10:00:00'::TIMESTAMP_NTZ, 35.0, 180.0, 5.0,
PARSE_JSON('{"driver_id": "D001", "route_id": "R001", "package_count": 15, "fuel_level": 75.5, "engine_status": "running"}')),

(2, 102, 'emergency_vehicle',
ST_POINT(-118.2437, 34.0522), 34.0522, -118.2437, 93.0,
'2024-12-01 10:00:00'::TIMESTAMP_NTZ, 65.0, 90.0, 3.0,
PARSE_JSON('{"vehicle_type": "ambulance", "emergency_code": "code_3", "destination": "Cedars-Sinai Hospital", "eta_minutes": 8}')),

(3, 103, 'public_transit',
ST_POINT(-74.0060, 40.7128), 40.7128, -74.0060, 10.0,
'2024-12-01 10:00:00'::TIMESTAMP_NTZ, 25.0, 270.0, 10.0,
PARSE_JSON('{"bus_number": "M15", "route": "Manhattan", "passenger_count": 45, "next_stop": "Times Square", "delay_minutes": 2}')),

(4, 104, 'fleet_vehicle',
ST_POINT(-87.6298, 41.8781), 41.8781, -87.6298, 179.0,
'2024-12-01 10:00:00'::TIMESTAMP_NTZ, 40.0, 45.0, 8.0,
PARSE_JSON('{"fleet_id": "F001", "driver_id": "D002", "cargo_type": "electronics", "delivery_status": "in_transit"}')),

(5, 105, 'personal_vehicle',
ST_POINT(-80.1918, 25.7617), 25.7617, -80.1918, 2.0,
'2024-12-01 10:00:00'::TIMESTAMP_NTZ, 30.0, 135.0, 15.0,
PARSE_JSON('{"user_id": "U001", "destination": "South Beach", "estimated_arrival": "10:15", "traffic_conditions": "moderate"}'));

-- Insert geospatial events and incidents
INSERT INTO geo.spatial_events (event_id, event_name, event_type, event_severity, event_geometry, start_time, end_time, affected_area_sq_km, event_metadata) VALUES
(1, 'Traffic Accident on I-5', 'accident', 'medium',
ST_POINT(-122.4194, 37.7749),
'2024-12-01 09:30:00'::TIMESTAMP_NTZ, '2024-12-01 11:00:00'::TIMESTAMP_NTZ, 0.5,
PARSE_JSON('{"vehicles_involved": 2, "injuries": 1, "road_closure": true, "detour_available": true, "emergency_services": ["police", "ambulance"]}')),

(2, 'Construction on Pacific Coast Highway', 'construction', 'low',
ST_POLYGON('POLYGON((-122.4194 37.7749, -122.4000 37.7749, -122.4000 37.7800, -122.4194 37.7800, -122.4194 37.7749))'),
'2024-12-01 08:00:00'::TIMESTAMP_NTZ, '2024-12-01 17:00:00'::TIMESTAMP_NTZ, 2.0,
PARSE_JSON('{"project_type": "road_repair", "contractor": "ABC Construction", "estimated_completion": "2024-12-15", "traffic_impact": "moderate"}')),

(3, 'Severe Weather Warning', 'weather', 'high',
ST_POLYGON('POLYGON((-118.2437 34.0522, -118.2000 34.0522, -118.2000 34.1000, -118.2437 34.1000, -118.2437 34.0522))'),
'2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 18:00:00'::TIMESTAMP_NTZ, 25.0,
PARSE_JSON('{"weather_type": "heavy_rain", "wind_speed_mph": 45, "rainfall_inches": 2.5, "flood_warning": true, "evacuation_orders": false}')),

(4, 'Power Outage in Downtown', 'utility', 'medium',
ST_POLYGON('POLYGON((-74.0060 40.7128, -73.9800 40.7128, -73.9800 40.7300, -74.0060 40.7300, -74.0060 40.7128))'),
'2024-12-01 09:45:00'::TIMESTAMP_NTZ, '2024-12-01 12:00:00'::TIMESTAMP_NTZ, 5.0,
PARSE_JSON('{"affected_customers": 5000, "cause": "equipment_failure", "estimated_restoration": "12:00", "backup_generators": true}')),

(5, 'Public Event - Street Festival', 'event', 'low',
ST_POLYGON('POLYGON((-87.6298 41.8781, -87.6200 41.8781, -87.6200 41.8850, -87.6298 41.8850, -87.6298 41.8781))'),
'2024-12-01 10:00:00'::TIMESTAMP_NTZ, '2024-12-01 22:00:00'::TIMESTAMP_NTZ, 1.5,
PARSE_JSON('{"event_type": "street_festival", "expected_attendance": 10000, "road_closures": true, "vendors": 150, "entertainment": ["live_music", "food_trucks", "art_exhibits"]}'));

-- Insert geospatial analytics results
INSERT INTO geo.spatial_analytics (analytics_id, analysis_type, target_geometry, analysis_parameters, result_value, result_geometry, result_metadata, analysis_date) VALUES
(1, 'density_analysis', 
ST_POLYGON('POLYGON((-122.5194 37.7074, -122.3194 37.7074, -122.3194 37.8424, -122.5194 37.8424, -122.5194 37.7074))'),
PARSE_JSON('{"analysis_radius_km": 5, "point_type": "restaurants", "time_period": "daily"}'),
1250.5,
ST_POLYGON('POLYGON((-122.4194 37.7749, -122.4000 37.7749, -122.4000 37.7800, -122.4194 37.7800, -122.4194 37.7749))'),
PARSE_JSON('{"high_density_areas": 3, "average_density": 1250.5, "peak_hours": ["12:00-14:00", "18:00-20:00"]}'),
'2024-12-01 10:00:00'::TIMESTAMP_NTZ),

(2, 'proximity_analysis',
ST_POINT(-118.2437, 34.0522),
PARSE_JSON('{"target_type": "hospitals", "max_distance_km": 10, "analysis_type": "nearest_neighbor"}'),
2.5,
ST_POINT(-118.2400, 34.0500),
PARSE_JSON('{"nearest_hospital": "Cedars-Sinai", "distance_km": 2.5, "travel_time_minutes": 8, "emergency_services": true}'),
'2024-12-01 10:00:00'::TIMESTAMP_NTZ),

(3, 'accessibility_analysis',
ST_POLYGON('POLYGON((-74.0260 40.7028, -73.9060 40.7028, -73.9060 40.8828, -74.0260 40.8828, -74.0260 40.7028))'),
PARSE_JSON('{"transportation_modes": ["subway", "bus", "walking"], "accessibility_threshold_minutes": 15}'),
85.7,
ST_POLYGON('POLYGON((-74.0060 40.7128, -73.9800 40.7128, -73.9800 40.7300, -74.0060 40.7300, -74.0060 40.7128))'),
PARSE_JSON('{"accessible_population": 1628706, "accessibility_score": 85.7, "transportation_hubs": 45, "walking_score": 92}'),
'2024-12-01 10:00:00'::TIMESTAMP_NTZ);

-- =====================================================
-- ADVANCED GEOSPATIAL VIEWS
-- =====================================================

-- Geospatial proximity analysis view
CREATE OR REPLACE VIEW geo.proximity_analysis AS
SELECT 
    c.city_id,
    c.city_name,
    c.location as city_location,
    -- Find nearest POI
    p.poi_id,
    p.poi_name,
    p.location as poi_location,
    ST_DISTANCE(c.location, p.location) as distance_meters,
    -- Find nearest transportation route
    t.route_id,
    t.route_name,
    t.route_geometry,
    ST_DISTANCE(c.location, t.route_geometry) as distance_to_route_meters,
    -- Administrative boundary
    b.boundary_name,
    b.boundary_type,
    ST_CONTAINS(b.boundary_geometry, c.location) as within_boundary
FROM geo.cities c
LEFT JOIN geo.points_of_interest p ON ST_DWITHIN(c.location, p.location, 50000) -- Within 50km
LEFT JOIN geo.transportation_routes t ON ST_DWITHIN(c.location, t.route_geometry, 10000) -- Within 10km
LEFT JOIN geo.administrative_boundaries b ON ST_CONTAINS(b.boundary_geometry, c.location)
ORDER BY c.city_id, distance_meters;

-- Real-time spatial tracking view
CREATE OR REPLACE VIEW geo.real_time_tracking AS
SELECT 
    lt.tracking_id,
    lt.entity_id,
    lt.entity_type,
    lt.location,
    lt.timestamp,
    lt.speed_kmh,
    lt.heading_degrees,
    -- JSON tracking data analysis
    lt.tracking_metadata:driver_id::STRING as driver_id,
    lt.tracking_metadata:route_id::STRING as route_id,
    lt.tracking_metadata:package_count::INT as package_count,
    lt.tracking_metadata:fuel_level::DECIMAL(5,2) as fuel_level,
    -- Geospatial calculations
    ST_ASTEXT(lt.location) as location_text,
    ST_X(lt.location) as longitude,
    ST_Y(lt.location) as latitude,
    -- Time-based analysis
    DATEDIFF('minute', lt.timestamp, CURRENT_TIMESTAMP()) as minutes_ago
FROM geo.location_tracking lt
WHERE lt.timestamp >= DATEADD('hour', -1, CURRENT_TIMESTAMP())
ORDER BY lt.timestamp DESC;

-- Spatial event impact analysis view
CREATE OR REPLACE VIEW geo.event_impact_analysis AS
SELECT 
    se.event_id,
    se.event_name,
    se.event_type,
    se.event_severity,
    se.event_geometry,
    se.start_time,
    se.end_time,
    -- JSON event data analysis
    se.event_metadata:vehicles_involved::INT as vehicles_involved,
    se.event_metadata:injuries::INT as injuries,
    se.event_metadata:road_closure::BOOLEAN as road_closure,
    se.event_metadata:affected_customers::INT as affected_customers,
    -- Geospatial impact analysis
    se.affected_area_sq_km,
    ST_AREA(se.event_geometry) as event_area_sq_meters,
    -- Find affected POIs
    COUNT(p.poi_id) as affected_pois,
    -- Find affected transportation routes
    COUNT(t.route_id) as affected_routes,
    -- Calculate impact radius
    SQRT(se.affected_area_sq_km / PI()) * 1000 as impact_radius_meters
FROM geo.spatial_events se
LEFT JOIN geo.points_of_interest p ON ST_INTERSECTS(se.event_geometry, p.location)
LEFT JOIN geo.transportation_routes t ON ST_INTERSECTS(se.event_geometry, t.route_geometry)
WHERE se.status = 'ACTIVE'
GROUP BY se.event_id, se.event_name, se.event_type, se.event_severity, se.event_geometry, 
         se.start_time, se.end_time, se.event_metadata, se.affected_area_sq_km;

-- Geospatial analytics results view
CREATE OR REPLACE VIEW geo.analytics_results AS
SELECT 
    sa.analytics_id,
    sa.analysis_type,
    sa.target_geometry,
    -- JSON analysis parameters
    sa.analysis_parameters:analysis_radius_km::DECIMAL(10,2) as analysis_radius_km,
    sa.analysis_parameters:point_type::STRING as point_type,
    sa.analysis_parameters:max_distance_km::DECIMAL(10,2) as max_distance_km,
    -- Results
    sa.result_value,
    sa.result_geometry,
    -- JSON result metadata analysis
    sa.result_metadata:high_density_areas::INT as high_density_areas,
    sa.result_metadata:average_density::DECIMAL(10,2) as average_density,
    sa.result_metadata:accessible_population::INT as accessible_population,
    sa.result_metadata:accessibility_score::DECIMAL(5,2) as accessibility_score,
    -- Geospatial properties
    ST_AREA(sa.target_geometry) as target_area_sq_meters,
    ST_AREA(sa.result_geometry) as result_area_sq_meters,
    sa.analysis_date
FROM geo.spatial_analytics sa
ORDER BY sa.analysis_date DESC;

-- =====================================================
-- STORED PROCEDURES FOR ADVANCED GEOSPATIAL ANALYSIS
-- =====================================================

-- Find POIs within radius with spatial analysis
CREATE OR REPLACE PROCEDURE geo.find_pois_in_radius(
    center_lat DECIMAL(10,8), 
    center_lon DECIMAL(11,8), 
    radius_km DECIMAL(10,2),
    poi_type_filter VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    poi_id INT,
    poi_name VARCHAR,
    poi_type VARCHAR,
    distance_km DECIMAL(10,2),
    rating DECIMAL(3,2),
    poi_metadata VARIANT
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            p.poi_id,
            p.poi_name,
            p.poi_type,
            ST_DISTANCE(p.location, ST_POINT(center_lon, center_lat)) / 1000 as distance_km,
            p.rating,
            p.poi_metadata
        FROM geo.points_of_interest p
        WHERE ST_DWITHIN(p.location, ST_POINT(center_lon, center_lat), radius_km * 1000)
        AND (poi_type_filter IS NULL OR p.poi_type = poi_type_filter)
        ORDER BY distance_km
    );
END;
$$;

-- Analyze spatial clustering of POIs
CREATE OR REPLACE PROCEDURE geo.analyze_spatial_clustering(
    cluster_radius_km DECIMAL(10,2) DEFAULT 5.0
)
RETURNS TABLE (
    cluster_id INT,
    cluster_center_lat DECIMAL(10,8),
    cluster_center_lon DECIMAL(11,8),
    poi_count INT,
    avg_rating DECIMAL(3,2),
    dominant_poi_type VARCHAR,
    cluster_area_sq_km DECIMAL(10,2)
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            p.cluster_id,
            AVG(ST_Y(p.location)) as cluster_center_lat,
            AVG(ST_X(p.location)) as cluster_center_lon,
            COUNT(*) as poi_count,
            AVG(p.rating) as avg_rating,
            MODE(p.poi_type) as dominant_poi_type,
            PI() * POWER(cluster_radius_km, 2) as cluster_area_sq_km
        FROM geo.points_of_interest p
        WHERE p.cluster_id IS NOT NULL
        GROUP BY p.cluster_id, cluster_radius_km
        ORDER BY poi_count DESC
    );
END;
$$;

-- =====================================================
-- TAGS FOR DATA GOVERNANCE
-- =====================================================

-- Create tags
CREATE OR REPLACE TAG geo.GEOSPATIAL_DATA_TAG;
CREATE OR REPLACE TAG geo.LOCATION_DATA_TAG;
CREATE OR REPLACE TAG geo.JSON_DATA_TAG;
CREATE OR REPLACE TAG geo.TIME_SERIES_DATA_TAG;

-- Apply tags to sensitive columns
ALTER TABLE geo.cities MODIFY COLUMN location SET TAG geo.GEOSPATIAL_DATA_TAG = 'CITY_LOCATION';
ALTER TABLE geo.cities MODIFY COLUMN city_metadata SET TAG geo.JSON_DATA_TAG = 'CITY_METADATA';
ALTER TABLE geo.location_tracking MODIFY COLUMN location SET TAG geo.GEOSPATIAL_DATA_TAG = 'TRACKING_LOCATION';
ALTER TABLE geo.location_tracking MODIFY COLUMN timestamp SET TAG geo.TIME_SERIES_DATA_TAG = 'TRACKING_TIMESTAMP';
ALTER TABLE geo.points_of_interest MODIFY COLUMN location SET TAG geo.GEOSPATIAL_DATA_TAG = 'POI_LOCATION';
ALTER TABLE geo.points_of_interest MODIFY COLUMN poi_metadata SET TAG geo.JSON_DATA_TAG = 'POI_METADATA';

-- =====================================================
-- COMMENTS
-- =====================================================

-- Table comments
COMMENT ON TABLE geo.cities IS 'Cities with point geometry and JSON metadata';
COMMENT ON TABLE geo.transportation_routes IS 'Transportation routes with line geometry';
COMMENT ON TABLE geo.administrative_boundaries IS 'Administrative boundaries with polygon geometry';
COMMENT ON TABLE geo.points_of_interest IS 'Points of interest with enhanced geospatial features';
COMMENT ON TABLE geo.location_tracking IS 'Real-time location tracking with geospatial data';
COMMENT ON TABLE geo.spatial_events IS 'Geospatial events and incidents with point/polygon geometry';
COMMENT ON TABLE geo.spatial_analytics IS 'Geospatial analytics results and metrics';

-- Column comments
COMMENT ON COLUMN geo.cities.location IS 'Geospatial point representing city center';
COMMENT ON COLUMN geo.cities.city_metadata IS 'JSON metadata containing city information and statistics';
COMMENT ON COLUMN geo.transportation_routes.route_geometry IS 'Geospatial line representing route path';
COMMENT ON COLUMN geo.administrative_boundaries.boundary_geometry IS 'Geospatial polygon representing boundary';
COMMENT ON COLUMN geo.points_of_interest.location IS 'Geospatial point representing POI location';
COMMENT ON COLUMN geo.location_tracking.location IS 'Geospatial point with timestamp for real-time tracking';
COMMENT ON COLUMN geo.spatial_events.event_geometry IS 'Geospatial point or polygon representing event location/area';

-- =====================================================
-- CLEANUP (UNCOMMENT TO RESET)
-- =====================================================

/*
-- Drop all objects
DROP DATABASE IF EXISTS GEOSPATIALDB CASCADE;
*/ 