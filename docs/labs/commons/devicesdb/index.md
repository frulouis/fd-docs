# MediSnowDB Data Model

A comprehensive medical data model for Snowflake demos and tutorials, featuring patient records, medical imaging, clinical trials, and pharmaceutical data with advanced healthcare analytics capabilities.

## Overview

The MediSnowDB data model provides a realistic medical environment for learning Snowflake capabilities including:

![MediSnowDB Medical Architecture](../assets/images/medisnowdb-architecture.png)

*Figure 1: MediSnowDB Medical Data Model - Complete medical database schema showing relationships between Patient, MedicalRecord, MedicalImage, Drug, and ClinicalTrial tables*
- **Clinical Data Management** - Patient records and medical history
- **Medical Imaging** - Radiology and diagnostic image metadata
- **Pharmaceutical Data** - Drug information and clinical trials
- **Healthcare Analytics** - Medical research and outcome analysis
- **HIPAA Compliance** - Advanced healthcare data protection

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
    BloodType VARCHAR(5),
    Allergies TEXT,
    MedicalHistory TEXT,
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### MedicalRecord Table
```sql
CREATE OR REPLACE TABLE MedicalRecord (
    RecordID INT PRIMARY KEY,
    PatientID INT REFERENCES Patient(PatientID),
    ProviderID INT,
    RecordDate DATE,
    RecordType VARCHAR(50),
    Diagnosis VARCHAR(500),
    Symptoms TEXT,
    Treatment TEXT,
    Prescription VARCHAR(500),
    Notes TEXT,
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### MedicalImage Table
```sql
CREATE OR REPLACE TABLE MedicalImage (
    ImageID INT PRIMARY KEY,
    PatientID INT REFERENCES Patient(PatientID),
    ImageType VARCHAR(50),
    BodyPart VARCHAR(100),
    ImagePath VARCHAR(500),
    ImageSize BIGINT,
    ImageFormat VARCHAR(20),
    ImageDate DATE,
    RadiologistID INT,
    Findings TEXT,
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Drug Table
```sql
CREATE OR REPLACE TABLE Drug (
    DrugID INT PRIMARY KEY,
    DrugName VARCHAR(200),
    GenericName VARCHAR(200),
    DrugClass VARCHAR(100),
    Indication VARCHAR(500),
    Dosage VARCHAR(100),
    SideEffects TEXT,
    Contraindications TEXT,
    FDAApprovalDate DATE,
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### ClinicalTrial Table
```sql
CREATE OR REPLACE TABLE ClinicalTrial (
    TrialID INT PRIMARY KEY,
    TrialName VARCHAR(200),
    DrugID INT REFERENCES Drug(DrugID),
    Phase VARCHAR(20),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50),
    PrimaryEndpoint VARCHAR(500),
    SecondaryEndpoint VARCHAR(500),
    InclusionCriteria TEXT,
    ExclusionCriteria TEXT,
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

## Medical Analytics Functions

### Patient Risk Assessment
```sql
CREATE OR REPLACE FUNCTION calculate_patient_risk_score(patient_id INT)
RETURNS DECIMAL(3, 2)
LANGUAGE SQL
AS $$
    WITH risk_factors AS (
        SELECT 
            DATEDIFF('year', DateOfBirth, CURRENT_DATE()) as age,
            CASE WHEN Gender = 'Male' THEN 1.2 ELSE 1.0 END as gender_risk,
            CASE WHEN BloodType IN ('A', 'B', 'AB') THEN 1.1 ELSE 1.0 END as blood_type_risk,
            CASE WHEN Allergies IS NOT NULL THEN 1.3 ELSE 1.0 END as allergy_risk
        FROM Patient
        WHERE PatientID = patient_id
    ),
    medical_history_risk AS (
        SELECT 
            COUNT(*) * 0.1 as history_risk
        FROM MedicalRecord
        WHERE PatientID = patient_id
        AND RecordType = 'Chronic Condition'
    )
    SELECT 
        (rf.age / 100.0) * rf.gender_risk * rf.blood_type_risk * rf.allergy_risk * 
        (1 + COALESCE(mhr.history_risk, 0))
    FROM risk_factors rf
    CROSS JOIN medical_history_risk mhr
$$;
```

### Drug Interaction Check
```sql
CREATE OR REPLACE FUNCTION check_drug_interaction(drug1_id INT, drug2_id INT)
RETURNS BOOLEAN
LANGUAGE SQL
AS $$
    WITH drug_classes AS (
        SELECT DrugClass
        FROM Drug
        WHERE DrugID IN (drug1_id, drug2_id)
    )
    SELECT COUNT(DISTINCT DrugClass) < 2
    FROM drug_classes
$$;
```

### Treatment Effectiveness
```sql
CREATE OR REPLACE FUNCTION calculate_treatment_effectiveness(patient_id INT, treatment_period_months INT)
RETURNS DECIMAL(3, 2)
LANGUAGE SQL
AS $$
    WITH treatment_outcomes AS (
        SELECT 
            COUNT(CASE WHEN RecordType = 'Follow-up' AND Diagnosis LIKE '%Improved%' THEN 1 END) as improved,
            COUNT(CASE WHEN RecordType = 'Follow-up' THEN 1 END) as total_followups
        FROM MedicalRecord
        WHERE PatientID = patient_id
        AND RecordDate >= DATEADD('month', -treatment_period_months, CURRENT_DATE())
    )
    SELECT 
        CASE 
            WHEN total_followups = 0 THEN 0.0
            ELSE improved::DECIMAL / total_followups
        END
    FROM treatment_outcomes
$$;
```

## Medical Analytics Views

### Patient Health Dashboard
```sql
CREATE OR REPLACE VIEW patient_health_dashboard AS
SELECT 
    p.PatientID,
    p.FirstName,
    p.LastName,
    p.DateOfBirth,
    DATEDIFF('year', p.DateOfBirth, CURRENT_DATE()) as age,
    p.BloodType,
    calculate_patient_risk_score(p.PatientID) as risk_score,
    COUNT(mr.RecordID) as total_records,
    MAX(mr.RecordDate) as last_visit,
    COUNT(DISTINCT mi.ImageID) as total_images
FROM Patient p
LEFT JOIN MedicalRecord mr ON p.PatientID = mr.PatientID
LEFT JOIN MedicalImage mi ON p.PatientID = mi.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName, p.DateOfBirth, p.BloodType
ORDER BY risk_score DESC;
```

### Clinical Trial Progress
```sql
CREATE OR REPLACE VIEW clinical_trial_progress AS
SELECT 
    ct.TrialID,
    ct.TrialName,
    d.DrugName,
    ct.Phase,
    ct.Status,
    ct.StartDate,
    ct.EndDate,
    DATEDIFF('day', ct.StartDate, CURRENT_DATE()) as days_running,
    DATEDIFF('day', ct.StartDate, ct.EndDate) as total_duration,
    CASE 
        WHEN ct.EndDate IS NULL THEN 'Ongoing'
        WHEN CURRENT_DATE() > ct.EndDate THEN 'Completed'
        ELSE 'In Progress'
    END as trial_status
FROM ClinicalTrial ct
JOIN Drug d ON ct.DrugID = d.DrugID
ORDER BY ct.StartDate DESC;
```

### Medical Image Analysis
```sql
CREATE OR REPLACE VIEW medical_image_analysis AS
SELECT 
    mi.ImageID,
    p.FirstName,
    p.LastName,
    mi.ImageType,
    mi.BodyPart,
    mi.ImageDate,
    mi.Findings,
    CASE 
        WHEN mi.Findings LIKE '%Normal%' THEN 'Normal'
        WHEN mi.Findings LIKE '%Abnormal%' THEN 'Abnormal'
        WHEN mi.Findings LIKE '%Suspicious%' THEN 'Suspicious'
        ELSE 'Pending Review'
    END as analysis_result
FROM MedicalImage mi
JOIN Patient p ON mi.PatientID = p.PatientID
WHERE mi.ImageDate >= DATEADD('month', -6, CURRENT_DATE())
ORDER BY mi.ImageDate DESC;
```

## Medical Stored Procedures

### Register Patient
```sql
CREATE OR REPLACE PROCEDURE register_patient(
    first_name VARCHAR,
    last_name VARCHAR,
    dob DATE,
    gender VARCHAR,
    ssn VARCHAR,
    blood_type VARCHAR,
    allergies TEXT
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
                        SSN, BloodType, Allergies)
    VALUES (new_patient_id, first_name, last_name, dob, gender, 
            ssn, blood_type, allergies);
    
    RETURN 'Patient registered with ID: ' || new_patient_id;
END;
$$;
```

### Schedule Follow-up
```sql
CREATE OR REPLACE PROCEDURE schedule_followup(
    patient_id INT,
    provider_id INT,
    followup_days INT,
    reason VARCHAR
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    new_record_id INT;
    followup_date DATE;
BEGIN
    -- Generate new record ID
    SELECT COALESCE(MAX(RecordID), 0) + 1 INTO new_record_id FROM MedicalRecord;
    
    -- Calculate follow-up date
    SET followup_date = DATEADD('day', followup_days, CURRENT_DATE());
    
    -- Insert follow-up record
    INSERT INTO MedicalRecord (RecordID, PatientID, ProviderID, RecordDate, 
                              RecordType, Notes)
    VALUES (new_record_id, patient_id, provider_id, followup_date, 
            'Follow-up', reason);
    
    RETURN 'Follow-up scheduled for ' || followup_date;
END;
$$;
```

### Prescribe Medication
```sql
CREATE OR REPLACE PROCEDURE prescribe_medication(
    patient_id INT,
    drug_id INT,
    dosage VARCHAR,
    duration_days INT,
    provider_id INT
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    new_record_id INT;
    drug_name VARCHAR;
BEGIN
    -- Get drug name
    SELECT DrugName INTO drug_name FROM Drug WHERE DrugID = drug_id;
    
    -- Generate new record ID
    SELECT COALESCE(MAX(RecordID), 0) + 1 INTO new_record_id FROM MedicalRecord;
    
    -- Insert prescription record
    INSERT INTO MedicalRecord (RecordID, PatientID, ProviderID, RecordDate, 
                              RecordType, Prescription)
    VALUES (new_record_id, patient_id, provider_id, CURRENT_DATE(), 
            'Prescription', drug_name || ' - ' || dosage || ' for ' || duration_days || ' days');
    
    RETURN 'Prescription recorded: ' || drug_name;
END;
$$;
```

## Medical Data Classification

### PHI (Protected Health Information) Tags
```sql
-- Create comprehensive PHI tags for medical data
CREATE OR REPLACE TAG Medical_PHI 
ALLOWED_VALUES 'Patient Name', 'SSN', 'DOB', 'Address', 'Phone', 'Medical Record', 'Diagnosis', 'Prescription' 
COMMENT = 'Protected Health Information under HIPAA for medical data';

-- Apply PHI tags to sensitive medical columns
ALTER TABLE Patient MODIFY COLUMN FirstName SET TAG Medical_PHI = 'Patient Name';
ALTER TABLE Patient MODIFY COLUMN LastName SET TAG Medical_PHI = 'Patient Name';
ALTER TABLE Patient MODIFY COLUMN SSN SET TAG Medical_PHI = 'SSN';
ALTER TABLE Patient MODIFY COLUMN DateOfBirth SET TAG Medical_PHI = 'DOB';
ALTER TABLE MedicalRecord MODIFY COLUMN Diagnosis SET TAG Medical_PHI = 'Diagnosis';
ALTER TABLE MedicalRecord MODIFY COLUMN Prescription SET TAG Medical_PHI = 'Prescription';
```

### Medical Data Classification
```sql
-- Create medical data classification tags
CREATE OR REPLACE TAG Medical_Data_Type 
ALLOWED_VALUES 'Clinical', 'Imaging', 'Pharmaceutical', 'Research', 'Administrative' 
COMMENT = 'Medical data type classification';

-- Apply medical data type tags
ALTER TABLE MedicalRecord MODIFY COLUMN RecordType SET TAG Medical_Data_Type = 'Clinical';
ALTER TABLE MedicalImage MODIFY COLUMN ImageType SET TAG Medical_Data_Type = 'Imaging';
ALTER TABLE Drug MODIFY COLUMN DrugClass SET TAG Medical_Data_Type = 'Pharmaceutical';
ALTER TABLE ClinicalTrial MODIFY COLUMN Phase SET TAG Medical_Data_Type = 'Research';
```

## Role-Based Access Control for Medical

### Medical Roles
```sql
-- Create medical specific roles
CREATE OR REPLACE ROLE Physician;
CREATE OR REPLACE ROLE Radiologist;
CREATE OR REPLACE ROLE Pharmacist;
CREATE OR REPLACE ROLE Researcher;
CREATE OR REPLACE ROLE Admin;

-- Grant database access
GRANT USAGE ON DATABASE MediSnowDB TO ROLE Physician;
GRANT USAGE ON DATABASE MediSnowDB TO ROLE Radiologist;
GRANT USAGE ON DATABASE MediSnowDB TO ROLE Pharmacist;
GRANT USAGE ON DATABASE MediSnowDB TO ROLE Researcher;
GRANT USAGE ON DATABASE MediSnowDB TO ROLE Admin;

-- Grant schema access
GRANT USAGE ON SCHEMA MediSnowDB.medical TO ROLE Physician;
GRANT USAGE ON SCHEMA MediSnowDB.medical TO ROLE Radiologist;
GRANT USAGE ON DATABASE MediSnowDB TO ROLE Pharmacist;
GRANT USAGE ON DATABASE MediSnowDB TO ROLE Researcher;
GRANT USAGE ON DATABASE MediSnowDB TO ROLE Admin;

-- Grant table permissions based on role
GRANT SELECT ON Patient, MedicalRecord TO ROLE Physician;
GRANT SELECT ON Patient, MedicalImage TO ROLE Radiologist;
GRANT SELECT ON Drug, MedicalRecord TO ROLE Pharmacist;
GRANT SELECT ON ClinicalTrial, Drug TO ROLE Researcher;
GRANT ALL ON ALL TABLES IN SCHEMA medical TO ROLE Admin;
```

## Usage in Tutorials

This data model serves as the foundation for:

- **Data Quality Metrics** - Medical data validation and quality monitoring
- **Data Classification** - HIPAA compliance and medical data governance
- **Cortex AI** - Medical text analysis, diagnosis prediction, and drug interaction analysis
- **Snowpark ML** - Patient risk prediction, treatment outcome modeling, and clinical trial analysis
- **Streamlit Apps** - Medical dashboards, patient portals, and clinical trial management
- **Vector Search** - Medical document search, drug information retrieval, and clinical research

## Setup Instructions

### 1. Create Database and Schema
```sql
CREATE OR REPLACE DATABASE MediSnowDB;
USE DATABASE MediSnowDB;
CREATE OR REPLACE SCHEMA medical;
USE SCHEMA medical;
```

### 2. Run Complete Setup Script
The full setup script includes:
- Medical table creation
- Sample healthcare data insertion
- PHI tagging and masking policies
- Medical-specific functions
- Clinical analytics views
- Medical RBAC configuration

### 3. Verify Setup
```sql
-- Check medical data counts
SELECT 'Patient' as table_name, COUNT(*) as row_count FROM Patient
UNION ALL
SELECT 'MedicalRecord', COUNT(*) FROM MedicalRecord
UNION ALL
SELECT 'MedicalImage', COUNT(*) FROM MedicalImage
UNION ALL
SELECT 'Drug', COUNT(*) FROM Drug
UNION ALL
SELECT 'ClinicalTrial', COUNT(*) FROM ClinicalTrial;
```

## Data Model Benefits

### For Medical Learning
- **HIPAA Compliance** - Advanced healthcare data protection
- **Clinical Workflows** - Realistic medical processes and procedures
- **Medical Analytics** - Healthcare-specific analysis patterns
- **Research Capabilities** - Clinical trial and pharmaceutical data

### For Demos
- **Comprehensive Coverage** - All major medical data types
- **Privacy Controls** - Advanced PHI masking and tagging
- **Medical Context** - Healthcare-specific use cases and scenarios
- **Research Ready** - Clinical trial and drug development data

## Next Steps

- [SalesDB Data Model](salesdb-data-model.md) - Sales data model
- [CaresDB Data Model](caresdb-data-model.md) - Healthcare data model
- [OrdersDB Data Model](ordersdb-data-model.md) - E-commerce data model
- [IoTDB Data Model](iotdb-data-model.md) - Internet of Things data model

## Resources

- [MediSnowDB Setup Script](https://complex-teammates-374480.framer.app/demo/medisnowdb) - Complete implementation
- [Data Classification Tutorial](../advanced-warehousing/data-classification.md) - HIPAA compliance
- [Cortex AI Tutorial](../gen-ai-llms/cortex-ai.md) - Medical text analysis

---

## Next Article

[:octicons-arrow-right-24: OrdersDB Data Model](ordersdb-data-model.md){ .md-button .md-button--primary }

Explore e-commerce data management with our comprehensive OrdersDB implementation, featuring order processing and customer analytics.
