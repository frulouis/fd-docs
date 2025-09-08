# JSONDB - Advanced JSON Data Model

## Overview

JSONDB is a specialized data model designed to demonstrate Snowflake's advanced JSON capabilities. This model showcases semi-structured data analysis, nested JSON objects, JSON functions, and flexible schema design for e-commerce, user profiles, API logs, and configuration management.

## Key Features

### 📄 **Advanced JSON Processing**
- **Nested JSON Objects**: Complex hierarchical data structures
- **JSON Arrays**: Array processing and analysis
- **JSON Functions**: Path extraction, validation, and transformation
- **Semi-structured Analytics**: Flexible schema analysis

### 🛒 **E-commerce JSON Data**
- **Complex Order Structures**: Nested items, pricing, shipping data
- **Customer Information**: Flexible customer profiles and preferences
- **Payment Processing**: Secure payment data with JSON metadata
- **Order Tracking**: Status history and tracking information

### 👤 **User Profile Management**
- **Flexible Profiles**: Dynamic user attributes and preferences
- **Activity History**: JSON-based activity tracking
- **Social Connections**: Network relationships and groups
- **Device Management**: Multi-device user experiences

### 🔌 **API Logging & Analytics**
- **Request/Response Data**: Complete API interaction logging
- **Performance Metrics**: JSON-based performance analysis
- **Error Tracking**: Structured error information and debugging
- **Header Analysis**: HTTP headers and metadata processing

### ⚙️ **Configuration Management**
- **Dynamic Configurations**: Flexible system configuration storage
- **Validation Rules**: JSON schema validation and rules
- **Dependency Management**: Service dependencies and versions
- **Version Control**: Configuration versioning and history

## Database Schema

### Core Tables

| Table | Description | Key Features |
|-------|-------------|--------------|
| `ecommerce_orders` | Complex order data | Nested items, customer info, shipping, payment |
| `product_catalog` | Product specifications | Nested specs, pricing, inventory, reviews |
| `user_profiles` | Flexible user data | Profile data, preferences, activity, social |
| `api_logs` | API interaction logs | Request/response, headers, performance, errors |
| `configurations` | System configurations | Config data, validation, dependencies, versions |

### Advanced Views

| View | Purpose | Key Capabilities |
|------|---------|------------------|
| `order_analysis` | Order data analysis | JSON path extraction, order metrics |
| `product_analysis` | Product data analysis | Specs analysis, pricing, inventory |
| `user_analysis` | User profile analysis | Profile data, preferences, activity |
| `api_performance_analysis` | API performance | Response times, errors, metrics |

## Sample Data

### E-commerce Orders with Complex JSON
```sql
-- Order with nested items, customer info, and payment data
INSERT INTO json_data.ecommerce_orders (order_id, order_details, customer_info, payment_info) VALUES
(1, 
PARSE_JSON('{"items": [{"product_id": 101, "name": "iPhone 15 Pro", "quantity": 1, "unit_price": 999.99}], "total": 1374.97}'),
PARSE_JSON('{"customer_id": 1001, "name": "John Smith", "email": "john.smith@email.com"}'),
PARSE_JSON('{"payment_method": "credit_card", "status": "completed", "transaction_id": "TXN123456"}')
);
```

### Product Catalog with Nested Specifications
```sql
-- Product with detailed specifications and pricing
INSERT INTO json_data.product_catalog (product_id, specifications, pricing, reviews) VALUES
(101,
PARSE_JSON('{"display": {"size": "6.1 inches", "resolution": "2556x1179"}, "processor": {"name": "A17 Pro", "cores": 6}}'),
PARSE_JSON('{"base_price": 999.99, "currency": "USD", "financing": {"available": true, "monthly_payment": 41.67}}'),
PARSE_JSON('{"average_rating": 4.8, "total_reviews": 1250, "rating_distribution": {"5_star": 850, "4_star": 300}}')
);
```

### User Profiles with Flexible Data
```sql
-- User profile with dynamic attributes and activity
INSERT INTO json_data.user_profiles (user_id, profile_data, preferences, activity_history) VALUES
(1001,
PARSE_JSON('{"personal": {"first_name": "John", "last_name": "Smith", "occupation": "Software Engineer"}, "interests": ["technology", "photography"]}'),
PARSE_JSON('{"notifications": {"email": true, "push": true}, "privacy": {"profile_visibility": "public"}}'),
PARSE_JSON('{"total_orders": 15, "total_spent": 8500.50, "recent_activity": [{"action": "purchase", "timestamp": "2024-12-01T10:00:00Z"}]}')
);
```

## Use Cases & Demonstrations

### 1. **E-commerce Order Analysis**
```sql
-- Extract order details and customer information
SELECT 
    order_id,
    order_details:total::DECIMAL(10,2) as total_amount,
    order_details:items::ARRAY as items_array,
    ARRAY_SIZE(order_details:items::ARRAY) as item_count,
    customer_info:name::STRING as customer_name,
    customer_info:email::STRING as customer_email
FROM json_data.ecommerce_orders;
```

### 2. **Product Specification Analysis**
```sql
-- Analyze product specifications and pricing
SELECT 
    product_id,
    product_name,
    specifications:display:size::STRING as display_size,
    specifications:processor:name::STRING as processor_name,
    pricing:base_price::DECIMAL(10,2) as base_price,
    pricing:financing:monthly_payment::DECIMAL(10,2) as monthly_payment,
    reviews:average_rating::DECIMAL(3,2) as average_rating
FROM json_data.product_catalog;
```

### 3. **User Profile Analysis**
```sql
-- Analyze user profiles and preferences
SELECT 
    user_id,
    username,
    profile_data:personal:first_name::STRING as first_name,
    profile_data:personal:occupation::STRING as occupation,
    profile_data:interests::ARRAY as interests_array,
    preferences:notifications:email::BOOLEAN as email_notifications,
    activity_history:total_orders::INT as total_orders
FROM json_data.user_profiles;
```

### 4. **API Performance Analysis**
```sql
-- Analyze API performance and errors
SELECT 
    api_endpoint,
    http_method,
    response_data:status_code::INT as status_code,
    performance_metrics:response_time_ms::INT as response_time_ms,
    performance_metrics:cache_hit::BOOLEAN as cache_hit,
    error_info:error::STRING as error_message
FROM json_data.api_logs;
```

## Advanced JSON Features

### JSON Functions
- **Path Extraction**: `:` operator for JSON path access
- **Type Casting**: `::` operator for JSON type conversion
- **Array Functions**: `ARRAY_SIZE()`, `ARRAY_CONTAINS()`
- **JSON Validation**: `IS_JSON()`, `JSON_VALID()`

### JSON Analysis
- **Nested Object Access**: Deep JSON path navigation
- **Array Processing**: JSON array analysis and manipulation
- **Conditional Logic**: JSON-based conditional queries
- **Aggregation**: JSON field aggregation and statistics

### Performance Optimizations
- **JSON Clustering**: Optimize JSON column queries
- **Path Indexing**: Index specific JSON paths
- **Materialized Views**: Pre-compute JSON aggregations
- **Query Optimization**: Optimize JSON function usage

## Integration Examples

### With Time Series Data
```sql
-- Extract temporal data from JSON
SELECT 
    timestamp,
    sensor_readings:temperature::DECIMAL(8,4) as temperature,
    sensor_readings:battery_level::DECIMAL(5,2) as battery_level
FROM timeseriesdb.ts.sensor_time_series
WHERE sensor_readings IS NOT NULL;
```

### With Geospatial Data
```sql
-- Extract spatial data from JSON
SELECT 
    poi_name,
    location,
    poi_metadata:rating::DECIMAL(3,2) as rating,
    poi_metadata:tags::ARRAY as tags
FROM geospatialdb.geo.points_of_interest;
```

### With IoT Data
```sql
-- Combine JSON device data with sensor readings
SELECT 
    d.device_name,
    d.device_metadata:facility::STRING as facility,
    s.temperature,
    s.sensor_readings:battery_level::DECIMAL(5,2) as battery_level
FROM iotdb.iot.devices d
JOIN iotdb.iot.sensor_data s ON d.device_id = s.device_id;
```

## Stored Procedures

### JSON Structure Analysis
```sql
-- Analyze JSON structure and extract metrics
CALL json_data.analyze_json_structure('ecommerce_orders', 'order_details');
```

### JSON Data Search
```sql
-- Search JSON data with flexible criteria
CALL json_data.search_json_data('iPhone', 'specifications');
```

## Best Practices

### JSON Design
- **Consistent Structure**: Maintain consistent JSON schemas
- **Path Optimization**: Use efficient JSON paths
- **Type Safety**: Validate JSON data types
- **Schema Evolution**: Plan for JSON schema changes

### Performance
- **Clustering**: Use appropriate clustering for JSON columns
- **Indexing**: Index frequently accessed JSON paths
- **Query Patterns**: Optimize common JSON query patterns
- **Caching**: Cache JSON aggregation results

### Data Quality
- **Validation**: Validate JSON structure and content
- **Error Handling**: Handle JSON parsing errors gracefully
- **Documentation**: Document JSON schema and paths
- **Testing**: Test JSON queries and transformations

## Demonstration Scenarios

### 1. **E-commerce Analytics**
- Order pattern analysis
- Customer behavior insights
- Product performance tracking
- Payment processing analytics

### 2. **User Experience Analytics**
- User profile analysis
- Preference tracking
- Activity pattern recognition
- Personalization insights

### 3. **API Monitoring & Analytics**
- Performance monitoring
- Error tracking and analysis
- Usage pattern analysis
- Service optimization

### 4. **Configuration Management**
- Dynamic system configuration
- Configuration validation
- Dependency management
- Version control and rollback

## File Structure

```
jsondb/
├── jsondb_data_model.sql          # Complete SQL data model
├── README.md                      # This documentation
└── ERD_README.md                  # Entity relationship documentation
```

## Getting Started

1. **Execute the SQL Script**:
   ```sql
   -- Run the complete data model
   @jsondb_data_model.sql
   ```

2. **Explore Sample Data**:
   ```sql
   -- View order analysis
   SELECT * FROM json_data.order_analysis;
   
   -- Analyze product data
   SELECT * FROM json_data.product_analysis;
   ```

3. **Run Demonstrations**:
   ```sql
   -- Analyze JSON structure
   CALL json_data.analyze_json_structure('ecommerce_orders', 'order_details');
   
   -- Search JSON data
   CALL json_data.search_json_data('iPhone');
   ```

## Related Models

- **TIMESERIESDB**: Time series data with JSON attributes
- **GEOSPATIALDB**: Geospatial data with JSON metadata
- **SENSORSDB**: IoT data with JSON configuration
- **SALESDB**: Sales data with JSON analytics

## Support

For questions or issues with the JSON data model, refer to:
- Snowflake JSON Documentation
- JSON Functions Reference
- Semi-structured Data Best Practices

---

*This JSON data model is designed for Snowflake demonstrations and showcases advanced semi-structured data analytics capabilities.* 