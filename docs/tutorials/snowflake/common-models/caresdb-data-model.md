# CaresDB Data Model

A healthcare-focused data model for Snowflake demos and tutorials, featuring patient, provider, and care data with HIPAA compliance and medical analytics capabilities.

## Overview

The CaresDB data model provides a realistic healthcare environment for learning Snowflake capabilities including:

![CaresDB Healthcare Architecture](../../assets/images/caresdb-architecture.png)

*Figure 1: CaresDB Healthcare Data Model - Complete healthcare database schema showing relationships between Patient, Provider, Facility, and Visit tables*
- **HIPAA Compliance** - Patient data protection and privacy controls
- **Medical Analytics** - Healthcare-specific data analysis patterns
- **Provider Management** - Healthcare provider and facility data
- **Care Tracking** - Patient care journey and outcomes
- **Clinical Data** - Medical records and treatment information

## Prerequisites

- Snowflake account with appropriate privileges
- Understanding of healthcare data privacy requirements
- Basic knowledge of medical data structures

## Data Model Structure

### Core Tables

#### Patient Table
```sql
CREATE OR REPLACE TABLE Patient (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    SSN VARCHAR(11),
    Address VARCHAR(200),
    Phone VARCHAR(20),
    EmergencyContact VARCHAR(100),
    InsuranceProvider VARCHAR(100),
    PolicyNumber VARCHAR(50),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Provider Table
```sql
CREATE OR REPLACE TABLE Provider (
    ProviderID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(100),
    LicenseNumber VARCHAR(50),
    Department VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Facility Table
```sql
CREATE OR REPLACE TABLE Facility (
    FacilityID INT PRIMARY KEY,
    FacilityName VARCHAR(200),
    FacilityType VARCHAR(50),
    Address VARCHAR(200),
    City VARCHAR(100),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Phone VARCHAR(20),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Visit Table
```sql
CREATE OR REPLACE TABLE Visit (
    VisitID INT PRIMARY KEY,
    PatientID INT REFERENCES Patient(PatientID),
    ProviderID INT REFERENCES Provider(ProviderID),
    FacilityID INT REFERENCES Facility(FacilityID),
    VisitDate DATE,
    VisitType VARCHAR(50),
    ChiefComplaint VARCHAR(500),
    Diagnosis VARCHAR(500),
    Treatment VARCHAR(500),
    Prescription VARCHAR(500),
    FollowUpDate DATE,
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

## HIPAA Compliance Features

![HIPAA Compliance Workflow](../../assets/images/caresdb-hipaa-compliance.png)

*Figure 2: HIPAA Compliance Workflow - Visual guide showing healthcare data protection and privacy controls*

### PHI (Protected Health Information) Tagging
```sql
-- Create PHI tag for healthcare data
CREATE OR REPLACE TAG PHI 
ALLOWED_VALUES 'Patient Name', 'SSN', 'DOB', 'Address', 'Phone', 'Medical Record' 
COMMENT = 'Protected Health Information under HIPAA';

-- Apply PHI tags to sensitive columns
ALTER TABLE Patient MODIFY COLUMN FirstName SET TAG PHI = 'Patient Name';
ALTER TABLE Patient MODIFY COLUMN LastName SET TAG PHI = 'Patient Name';
ALTER TABLE Patient MODIFY COLUMN SSN SET TAG PHI = 'SSN';
ALTER TABLE Patient MODIFY COLUMN DateOfBirth SET TAG PHI = 'DOB';
```

### Medical Data Classification
```sql
-- Create medical data classification tag
CREATE OR REPLACE TAG Medical_Data 
ALLOWED_VALUES 'Diagnosis', 'Treatment', 'Prescription', 'Lab Results', 'Vital Signs' 
COMMENT = 'Medical and clinical data classification';

-- Apply medical data tags
ALTER TABLE Visit MODIFY COLUMN Diagnosis SET TAG Medical_Data = 'Diagnosis';
ALTER TABLE Visit MODIFY COLUMN Treatment SET TAG Medical_Data = 'Treatment';
ALTER TABLE Visit MODIFY COLUMN Prescription SET TAG Medical_Data = 'Prescription';
```

### Enhanced Masking for Healthcare
```sql
-- Create HIPAA-compliant masking policy
CREATE OR REPLACE MASKING POLICY mask_phi AS (val string) RETURNS string ->
    CASE
        WHEN current_role() IN ('Physician', 'Nurse', 'Admin') THEN val
        WHEN current_role() = 'Researcher' THEN '***REDACTED***'
        ELSE '***MASKED***'
    END;

-- Apply masking to PHI tagged columns
ALTER TAG PHI SET MASKING POLICY mask_phi;
```

## Healthcare Analytics Functions

### Patient Age Calculation
```sql
CREATE OR REPLACE FUNCTION calculate_patient_age(patient_id INT)
RETURNS INT
LANGUAGE SQL
AS $$
    SELECT DATEDIFF('year', DateOfBirth, CURRENT_DATE())
    FROM Patient
    WHERE PatientID = patient_id
$$;
```

### Risk Score Calculation
```sql
CREATE OR REPLACE FUNCTION calculate_risk_score(patient_id INT)
RETURNS DECIMAL(3,2)
LANGUAGE SQL
AS $$
    SELECT CASE
        WHEN calculate_patient_age(patient_id) > 65 THEN 0.8
        WHEN calculate_patient_age(patient_id) > 50 THEN 0.6
        WHEN calculate_patient_age(patient_id) > 30 THEN 0.4
        ELSE 0.2
    END
$$;
```

### Visit Frequency Analysis
```sql
CREATE OR REPLACE FUNCTION get_visit_frequency(patient_id INT, months_back INT)
RETURNS INT
LANGUAGE SQL
AS $$
    SELECT COUNT(*)
    FROM Visit
    WHERE PatientID = patient_id
    AND VisitDate >= DATEADD('month', -months_back, CURRENT_DATE())
$$;
```

## Clinical Views

### High-Risk Patients
```sql
CREATE OR REPLACE VIEW high_risk_patients AS
SELECT 
    p.*,
    calculate_patient_age(p.PatientID) as age,
    calculate_risk_score(p.PatientID) as risk_score,
    get_visit_frequency(p.PatientID, 12) as visits_last_year
FROM Patient p
WHERE calculate_risk_score(p.PatientID) > 0.6
ORDER BY risk_score DESC;
```

### Provider Performance
```sql
CREATE OR REPLACE VIEW provider_performance AS
SELECT 
    pr.ProviderID,
    pr.FirstName,
    pr.LastName,
    pr.Specialty,
    COUNT(v.VisitID) as total_visits,
    COUNT(DISTINCT v.PatientID) as unique_patients,
    AVG(calculate_risk_score(v.PatientID)) as avg_patient_risk
FROM Provider pr
LEFT JOIN Visit v ON pr.ProviderID = v.ProviderID
GROUP BY pr.ProviderID, pr.FirstName, pr.LastName, pr.Specialty
ORDER BY total_visits DESC;
```

### Facility Utilization
```sql
CREATE OR REPLACE VIEW facility_utilization AS
SELECT 
    f.FacilityName,
    f.FacilityType,
    COUNT(v.VisitID) as total_visits,
    COUNT(DISTINCT v.PatientID) as unique_patients,
    COUNT(DISTINCT v.ProviderID) as active_providers
FROM Facility f
LEFT JOIN Visit v ON f.FacilityID = v.FacilityID
WHERE v.VisitDate >= DATEADD('month', -6, CURRENT_DATE())
GROUP BY f.FacilityID, f.FacilityName, f.FacilityType
ORDER BY total_visits DESC;
```

## Healthcare-Specific Stored Procedures

### Patient Registration
```sql
CREATE OR REPLACE PROCEDURE register_patient(
    first_name VARCHAR,
    last_name VARCHAR,
    dob DATE,
    gender VARCHAR,
    ssn VARCHAR,
    address VARCHAR,
    phone VARCHAR,
    insurance_provider VARCHAR
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    new_patient_id INT;
BEGIN
    -- Generate new patient ID
    SELECT COALESCE(MAX(PatientID), 0) + 1 INTO new_patient_id FROM Patient;
    
    -- Insert new patient
    INSERT INTO Patient (PatientID, FirstName, LastName, DateOfBirth, Gender, 
                        SSN, Address, Phone, InsuranceProvider)
    VALUES (new_patient_id, first_name, last_name, dob, gender, 
            ssn, address, phone, insurance_provider);
    
    RETURN 'Patient registered with ID: ' || new_patient_id;
END;
$$;
```

### Schedule Follow-up
```sql
CREATE OR REPLACE PROCEDURE schedule_followup(
    patient_id INT,
    provider_id INT,
    facility_id INT,
    followup_days INT
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    new_visit_id INT;
    followup_date DATE;
BEGIN
    -- Generate new visit ID
    SELECT COALESCE(MAX(VisitID), 0) + 1 INTO new_visit_id FROM Visit;
    
    -- Calculate follow-up date
    SET followup_date = DATEADD('day', followup_days, CURRENT_DATE());
    
    -- Insert follow-up visit
    INSERT INTO Visit (VisitID, PatientID, ProviderID, FacilityID, 
                      VisitDate, VisitType, ChiefComplaint)
    VALUES (new_visit_id, patient_id, provider_id, facility_id, 
            followup_date, 'Follow-up', 'Scheduled follow-up visit');
    
    RETURN 'Follow-up scheduled for ' || followup_date;
END;
$$;
```

## Role-Based Access Control for Healthcare

### Healthcare Roles
```sql
-- Create healthcare-specific roles
CREATE OR REPLACE ROLE Physician;
CREATE OR REPLACE ROLE Nurse;
CREATE OR REPLACE ROLE Admin;
CREATE OR REPLACE ROLE Researcher;

-- Grant database access
GRANT USAGE ON DATABASE CaresDB TO ROLE Physician;
GRANT USAGE ON DATABASE CaresDB TO ROLE Nurse;
GRANT USAGE ON DATABASE CaresDB TO ROLE Admin;
GRANT USAGE ON DATABASE CaresDB TO ROLE Researcher;

-- Grant schema access
GRANT USAGE ON SCHEMA CaresDB.healthcare TO ROLE Physician;
GRANT USAGE ON SCHEMA CaresDB.healthcare TO ROLE Nurse;
GRANT USAGE ON SCHEMA CaresDB.healthcare TO ROLE Admin;
GRANT USAGE ON SCHEMA CaresDB.healthcare TO ROLE Researcher;

-- Grant table permissions based on role
GRANT SELECT ON ALL TABLES IN SCHEMA healthcare TO ROLE Physician;
GRANT SELECT ON Patient, Visit TO ROLE Nurse;
GRANT ALL ON ALL TABLES IN SCHEMA healthcare TO ROLE Admin;
GRANT SELECT ON high_risk_patients, provider_performance TO ROLE Researcher;
```

## Usage in Tutorials

This data model serves as the foundation for:

- **Data Quality Metrics** - Healthcare data validation
- **Data Classification** - HIPAA compliance implementation
- **Cortex AI** - Medical text analysis and forecasting
- **Snowpark ML** - Patient risk prediction models
- **Streamlit Apps** - Clinical dashboards and patient portals
- **Vector Search** - Medical document search and retrieval

## Setup Instructions

### 1. Create Database and Schema
```sql
CREATE OR REPLACE DATABASE CaresDB;
USE DATABASE CaresDB;
CREATE OR REPLACE SCHEMA healthcare;
USE SCHEMA healthcare;
```

### 2. Run Complete Setup Script
The full setup script includes:
- Healthcare table creation
- Sample medical data insertion
- HIPAA-compliant tagging
- Medical data masking policies
- Healthcare-specific functions
- Clinical views and procedures
- Healthcare RBAC configuration

### 3. Verify Setup
```sql
-- Check healthcare data counts
SELECT 'Patient' as table_name, COUNT(*) as row_count FROM Patient
UNION ALL
SELECT 'Provider', COUNT(*) FROM Provider
UNION ALL
SELECT 'Facility', COUNT(*) FROM Facility
UNION ALL
SELECT 'Visit', COUNT(*) FROM Visit;
```

## Data Model Benefits

### For Healthcare Learning
- **HIPAA Compliance** - Real-world privacy requirements
- **Medical Analytics** - Healthcare-specific analysis patterns
- **Clinical Workflows** - Realistic healthcare processes
- **Provider Management** - Healthcare staff and facility data

### For Demos
- **Privacy Controls** - Advanced data masking and tagging
- **Medical Context** - Healthcare-specific use cases
- **Compliance Features** - HIPAA and healthcare regulations
- **Clinical Insights** - Patient care and outcomes analysis

## Next Steps

- [OrdersDB Data Model](ordersdb-data-model.md) - E-commerce data model
- [IoTDB Data Model](iotdb-data-model.md) - Internet of Things data model
- [MediSnowDB Data Model](medisnowdb-data-model.md) - Medical data model
- [SalesDB Data Model](salesdb-data-model.md) - Sales data model

## Resources

- [CaresDB Setup Script](https://complex-teammates-374480.framer.app/demo/caresdb-data-model) - Complete implementation
- [Data Classification Tutorial](../advanced-warehousing/data-classification.md) - HIPAA compliance
- [Cortex AI Tutorial](../gen-ai-llms/cortex-ai.md) - Medical text analysis
