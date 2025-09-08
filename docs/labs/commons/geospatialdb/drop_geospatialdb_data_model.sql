-- Drop views
DROP VIEW IF EXISTS geo.analytics_results;

-- Drop tables
DROP TABLE IF EXISTS geo.cities;
DROP TABLE IF EXISTS geo.points_of_interest;
DROP TABLE IF EXISTS geo.spatial_events;
DROP TABLE IF EXISTS geo.spatial_analytics;

-- Drop procedures
DROP PROCEDURE IF EXISTS geo.find_pois_in_radius(DECIMAL, DECIMAL, DECIMAL, VARCHAR);
DROP PROCEDURE IF EXISTS geo.analyze_spatial_clustering(DECIMAL);

-- Drop tags
DROP TAG IF EXISTS geo.GEOSPATIAL_DATA_TAG;
DROP TAG IF EXISTS geo.LOCATION_DATA_TAG;
DROP TAG IF EXISTS geo.JSON_DATA_TAG;
DROP TAG IF EXISTS geo.TIME_SERIES_DATA_TAG;

-- Drop schema and database
DROP SCHEMA IF EXISTS geo;
DROP DATABASE IF EXISTS geospatialdb; 