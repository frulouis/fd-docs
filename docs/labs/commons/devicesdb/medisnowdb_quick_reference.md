# DevicesDB Quick Reference Guide

## Overview
DevicesDB is a medical device company data model for tracking devices, customer complaints, maintenance, and regulatory compliance.

## Database Structure
```
DevicesDB
└── medical_devices (schema)
    ├── devices (table)
    ├── customer_complaints (table)
    ├── device_performance_summary (view)
    ├── business_unit_analysis (view)
    ├── regulatory_compliance (view)
    ├── GetDevicesRequiringMaintenance() (procedure)
    └── GetCustomerSatisfactionAnalysis() (procedure)
```

## Key Tables

### devices
**Purpose**: Medical device inventory and specifications
**Key Columns**:
- `DeviceID` (PK)
- `DeviceName`, `DeviceType`, `Manufacturer`
- `RegulatoryApproval`, `ApprovalDate`
- `LastMaintenanceDate`, `NextMaintenanceDate`
- `PurchasePrice`, `BusinessUnit`

### customer_complaints
**Purpose**: Customer feedback and complaint tracking
**Key Columns**:
- `ComplaintID` (PK)
- `DeviceID` (FK to devices)
- `CustomerName`, `ComplaintDetails`
- `ComplaintDate`

## Business Units
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

## Device Types
- Heart Monitor, Dialysis Machine, Neurostimulator
- Surgical Robot, Joint Implant, Vascular Scanner
- Diagnostic Imaging, Endoscopy, Patient Monitor
- Insulin Pump, Bone Scanner, Cryotherapy Unit
- Vital Signs Monitor, Evolution Scanner

## Regulatory Approvals
- FDA (Food and Drug Administration)
- CE Mark (European Conformity)

## Quick Queries

### Device Inventory
```sql
SELECT DeviceName, DeviceType, BusinessUnit, PurchasePrice 
FROM medical_devices.devices 
ORDER BY BusinessUnit, PurchasePrice DESC;
```

### Maintenance Due
```sql
CALL GetDevicesRequiringMaintenance();
```

### Customer Satisfaction
```sql
CALL GetCustomerSatisfactionAnalysis();
```

### Business Unit Performance
```sql
SELECT * FROM medical_devices.business_unit_analysis;
```

### Regulatory Status
```sql
SELECT * FROM medical_devices.regulatory_compliance;
```

## Sample Data Summary
- **31 Devices** across 11 business units
- **31 Customer Complaints** with sentiment analysis
- **Price Range**: $2,800 - $15,000 per device
- **Regulatory Mix**: FDA and CE Mark approvals
- **Maintenance**: Scheduled maintenance tracking

## Key Metrics
- Device performance and reliability
- Customer satisfaction rates
- Business unit investment analysis
- Regulatory compliance status
- Maintenance scheduling efficiency

## Data Governance Tags
- `MEDICAL_DEVICE_TAG`: Device-related data
- `CUSTOMER_DATA_TAG`: Customer information
- `REGULATORY_TAG`: Compliance data

## Demo Scenarios
1. **Device Performance Monitoring**
2. **Business Unit Analysis**
3. **Regulatory Compliance**
4. **Customer Experience Optimization**
5. **Financial Planning**

## Setup Instructions
```sql
-- Create database and schema
CREATE OR REPLACE DATABASE DevicesDB;
USE DATABASE DevicesDB;
CREATE OR REPLACE SCHEMA medical_devices;

-- Execute medisnowdb_data_model.sql
```

## Version
- **Version**: 1.2.7
- **Source**: DemoHub DevicesDB
- **Last Updated**: 05/28/2024 

## Related Resources

- **Source**: DemoHub DevicesDB
- **Tutorial**: https://complex-teammates-374480.framer.app/demo/medisnowdb 