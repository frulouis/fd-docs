# DevicesDB - Medical Device Company Data Model

## Overview

MediSnow is a leading medical device company specializing in innovative technology for healthcare providers. Their product line ranges from state-of-the-art surgical robots to advanced patient monitoring systems. MediSnow's focus is on improving patient outcomes and increasing efficiency in healthcare settings.

## Entity Relationship Diagram

![DevicesDB ERD](erd_devices.png)

## Data Model Description

The DevicesDB database provides a comprehensive foundation for tracking and analyzing essential aspects of MediSnow's medical device business:

### Core Tables

1. **Devices Table** - Stores detailed information about each medical device, including:
   - Device specifications (name, type, manufacturer, model, serial number)
   - Maintenance records (last/next service dates)
   - Warranty information
   - Regulatory approvals
   - Financial details (purchase date, price)
   - Business unit assignment

2. **Customer Complaints Table** - Captures customer feedback, including:
   - Complaint date
   - Customer name
   - Device involved
   - Detailed description of the complaint

## Features

### Medical Device Management
- **Device Inventory**: Complete tracking of medical devices with specifications
- **Maintenance Scheduling**: Automated maintenance date tracking and alerts
- **Warranty Management**: Warranty period monitoring and expiration tracking
- **Regulatory Compliance**: FDA and CE Mark approval status tracking
- **Business Unit Organization**: Device categorization by business units

### Customer Experience Analytics
- **Complaint Tracking**: Comprehensive customer feedback collection
- **Satisfaction Analysis**: Sentiment analysis of customer complaints
- **Device Performance**: Correlation between device types and customer satisfaction
- **Trend Analysis**: Temporal analysis of complaint patterns

### Financial Analysis
- **Investment Tracking**: Total device investment by business unit
- **Cost Analysis**: Average device costs and pricing strategies
- **ROI Measurement**: Device performance vs. investment analysis

### Regulatory Compliance
- **Approval Status**: Real-time regulatory approval tracking
- **Expiration Monitoring**: Proactive expiration date alerts
- **Compliance Reporting**: Automated compliance status reports

## Data Model Structure

### Tables

#### `medical_devices.devices`
| Column | Type | Description |
|--------|------|-------------|
| DeviceID | INT | Primary key, auto-increment |
| DeviceName | VARCHAR(100) | Name of the medical device |
| DeviceType | VARCHAR(100) | Type/category of device |
| Manufacturer | VARCHAR(100) | Device manufacturer |
| ModelNumber | VARCHAR(50) | Model number |
| SerialNumber | VARCHAR(50) | Unique serial number |
| ManufacturingDate | DATE | Manufacturing date |
| ExpirationDate | DATE | Device expiration date |
| DeviceStatus | VARCHAR(50) | Current device status |
| DeviceVersion | VARCHAR(50) | Hardware version |
| SoftwareVersion | VARCHAR(50) | Software version |
| RegulatoryApproval | VARCHAR(100) | Regulatory approval status |
| ApprovalDate | DATE | Regulatory approval date |
| LastMaintenanceDate | DATE | Last maintenance date |
| NextMaintenanceDate | DATE | Next scheduled maintenance |
| WarrantyStartDate | DATE | Warranty start date |
| WarrantyEndDate | DATE | Warranty end date |
| PurchaseDate | DATE | Purchase date |
| PurchasePrice | DECIMAL(10,2) | Device purchase price |
| BusinessUnit | VARCHAR(50) | Business unit assignment |

#### `medical_devices.customer_complaints`
| Column | Type | Description |
|--------|------|-------------|
| ComplaintID | INT | Primary key, auto-increment |
| DeviceID | INT | Foreign key to devices table |
| ComplaintDate | DATE | Date of complaint |
| CustomerName | VARCHAR(100) | Customer name |
| DeviceName | VARCHAR(100) | Device name |
| ComplaintDetails | TEXT | Detailed complaint description |

### Views

#### `device_performance_summary`
Comprehensive device performance metrics including complaint counts, satisfaction rates, and maintenance status.

#### `business_unit_analysis`
Business unit performance analysis with investment totals, device counts, and customer satisfaction metrics.

#### `regulatory_compliance`
Regulatory compliance dashboard showing approval status, expiration tracking, and compliance metrics.

### Stored Procedures

#### `GetDevicesRequiringMaintenance()`
Returns devices that are overdue for maintenance with detailed maintenance information.

#### `GetCustomerSatisfactionAnalysis()`
Analyzes customer satisfaction by device with positive/negative feedback categorization.

## Sample Data

The model includes comprehensive sample data:

- **31 Medical Devices** across various categories:
  - Cardiovascular Devices
  - Renal Care
  - Neuromodulation
  - Medical-Surgical Solutions
  - Orthopedics
  - Vascular Therapy
  - Diagnostic Imaging
  - Endoscopy
  - Critical Care
  - Diabetes Care
  - Physical Therapy

- **31 Customer Complaints** with realistic feedback scenarios covering:
  - Positive experiences and satisfaction
  - Technical issues and concerns
  - Performance feedback
  - Reliability assessments

## Usage Examples

### Device Performance Analysis
```sql
-- Get device performance summary
SELECT * FROM medical_devices.device_performance_summary
ORDER BY complaint_count DESC;
```

### Business Unit Investment Analysis
```sql
-- Analyze business unit performance
SELECT * FROM medical_devices.business_unit_analysis
ORDER BY total_investment DESC;
```

### Regulatory Compliance Monitoring
```sql
-- Check regulatory compliance status
SELECT * FROM medical_devices.regulatory_compliance
ORDER BY device_count DESC;
```

### Maintenance Scheduling
```sql
-- Get devices requiring maintenance
CALL GetDevicesRequiringMaintenance();
```

### Customer Satisfaction Analysis
```sql
-- Analyze customer satisfaction
CALL GetCustomerSatisfactionAnalysis();
```

## Demo Scenarios

### 1. Device Performance Monitoring
- Track device reliability and customer satisfaction
- Identify devices with high complaint rates
- Monitor maintenance schedules and compliance

### 2. Business Unit Analysis
- Compare investment across business units
- Analyze customer satisfaction by business unit
- Identify high-performing and underperforming units

### 3. Regulatory Compliance
- Monitor FDA and CE Mark approval status
- Track expiration dates and renewal requirements
- Ensure regulatory compliance across all devices

### 4. Customer Experience Optimization
- Analyze customer feedback patterns
- Identify common issues and improvement opportunities
- Measure customer satisfaction trends

### 5. Financial Planning
- Track total device investment
- Analyze cost per business unit
- Plan future device acquisitions

## Data Governance

### Tags and Classification
- **MEDICAL_DEVICE_TAG**: Classifies device-related data
- **CUSTOMER_DATA_TAG**: Protects customer information
- **REGULATORY_TAG**: Identifies regulatory compliance data

### Comments and Documentation
- Comprehensive table and column comments
- Clear documentation of data relationships
- Usage examples and best practices

## Setup Instructions

1. **Create Database and Schema**:
   ```sql
   CREATE OR REPLACE DATABASE DevicesDB;
   USE DATABASE DevicesDB;
   CREATE OR REPLACE SCHEMA medical_devices;
   ```

2. **Run the Complete Script**:
   ```sql
   -- Execute the medisnowdb_data_model.sql script
   ```

3. **Verify Setup**:
   ```sql
   -- Check table creation
   SHOW TABLES IN medical_devices;
   
   -- Verify sample data
   SELECT COUNT(*) FROM medical_devices.devices;
   SELECT COUNT(*) FROM medical_devices.customer_complaints;
   ```

## Best Practices

### Data Management
- Regularly update maintenance schedules
- Monitor regulatory expiration dates
- Track customer feedback trends
- Maintain accurate device specifications

### Analytics
- Use views for consistent reporting
- Leverage stored procedures for complex analysis
- Monitor key performance indicators
- Implement automated alerts for critical issues

### Compliance
- Regular regulatory status reviews
- Proactive expiration date monitoring
- Comprehensive audit trails
- Data classification and protection

## Troubleshooting

### Common Issues
1. **Maintenance Alerts**: Check `GetDevicesRequiringMaintenance()` procedure
2. **Compliance Issues**: Review `regulatory_compliance` view
3. **Performance Problems**: Analyze `device_performance_summary` view
4. **Customer Satisfaction**: Use `GetCustomerSatisfactionAnalysis()` procedure

### Performance Optimization
- Index frequently queried columns
- Use appropriate data types
- Monitor query performance
- Optimize view definitions

## Version Information

- **Version**: 1.2.7
- **Last Updated**: 05/28/2024
- **Source**: DemoHub - DevicesDB Data Model
- **Compatibility**: Snowflake 8.0+

## Related Resources

- [DemoHub DevicesDB Tutorial](https://complex-teammates-374480.framer.app/demo/medisnowdb)
- [Snowflake Medical Device Analytics](https://docs.snowflake.com/)
- [Healthcare Data Governance Best Practices](https://docs.snowflake.com/)

## Support

For questions or issues with this data model:
- Review the DemoHub documentation
- Check Snowflake documentation for syntax updates
- Verify data types and constraints
- Test queries in a development environment first 