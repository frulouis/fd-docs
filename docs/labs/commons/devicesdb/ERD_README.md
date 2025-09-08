# DevicesDB Entity Relationship Diagram (ERD)

## Overview

The Entity Relationship Diagram for DevicesDB can be found on the DemoHub site:

**Source**: [DemoHub DevicesDB Tutorial](https://complex-teammates-374480.framer.app/demo/medisnowdb)

## Database Relationships

The DevicesDB ERD shows the relationship between the two main tables:

### Primary Entities

1. **devices** (Primary Table)
   - Contains all medical device information
   - Primary Key: DeviceID
   - Includes device specifications, maintenance, regulatory, and financial data

2. **customer_complaints** (Related Table)
   - Contains customer feedback and complaints
   - Primary Key: ComplaintID
   - Foreign Key: DeviceID (references devices.DeviceID)

### Relationship

- **One-to-Many**: One device can have multiple customer complaints
- **Foreign Key Constraint**: customer_complaints.DeviceID → devices.DeviceID

## ERD Components

### devices Table Fields
- DeviceID (PK)
- DeviceName
- DeviceType
- Manufacturer
- ModelNumber
- SerialNumber
- ManufacturingDate
- ExpirationDate
- DeviceStatus
- DeviceVersion
- SoftwareVersion
- RegulatoryApproval
- ApprovalDate
- LastMaintenanceDate
- NextMaintenanceDate
- WarrantyStartDate
- WarrantyEndDate
- PurchaseDate
- PurchasePrice
- BusinessUnit

### customer_complaints Table Fields
- ComplaintID (PK)
- DeviceID (FK)
- ComplaintDate
- CustomerName
- DeviceName
- ComplaintDetails

## Visual Representation

```
┌─────────────────┐         ┌──────────────────────┐
│     devices     │         │  customer_complaints │
├─────────────────┤         ├──────────────────────┤
│ DeviceID (PK)   │◄────────│ ComplaintID (PK)     │
│ DeviceName      │         │ DeviceID (FK)        │
│ DeviceType      │         │ ComplaintDate        │
│ Manufacturer    │         │ CustomerName         │
│ ModelNumber     │         │ DeviceName           │
│ SerialNumber    │         │ ComplaintDetails     │
│ ManufacturingDate│         └──────────────────────┘
│ ExpirationDate  │
│ DeviceStatus    │
│ DeviceVersion   │
│ SoftwareVersion │
│ RegulatoryApproval│
│ ApprovalDate    │
│ LastMaintenanceDate│
│ NextMaintenanceDate│
│ WarrantyStartDate│
│ WarrantyEndDate │
│ PurchaseDate    │
│ PurchasePrice   │
│ BusinessUnit    │
└─────────────────┘
```

## Notes

- The ERD image is available on the DemoHub site
- The relationship is straightforward: devices → customer_complaints
- This simple but effective design allows for comprehensive medical device analytics
- The model supports device performance analysis, customer satisfaction tracking, and regulatory compliance monitoring

## How to Access the ERD

1. Visit the DemoHub DevicesDB page

The ERD helps understand:
- How devices and complaints are related
- The data flow between tables
- The structure for building queries and reports 