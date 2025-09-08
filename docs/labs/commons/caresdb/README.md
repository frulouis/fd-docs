# CaresDB Data Model

## Overview

The CaresDB data model is a comprehensive healthcare and care management data model designed for Snowflake demonstrations. It includes patient management, caregiver information, care plans, health records, and medication tracking with HIPAA-compliant data governance.

## Features

### Core Data Model
- **Patients Table**: Stores patient demographic and contact information
- **Caregivers Table**: Stores healthcare provider information
- **Care Plans Table**: Stores patient care plans and treatment goals
- **Health Records Table**: Stores patient health records and visit information
- **Medications Table**: Stores patient medication information

### Advanced Features
- **HIPAA Compliance**: PHI (Protected Health Information) tagging for data governance
- **Medical Data Classification**: Medical information tagging for better organization
- **Care Plan Management**: Comprehensive care planning and tracking
- **Medication Tracking**: Medication management and compliance monitoring
- **Views**: Pre-built views for patient care and caregiver workload analysis
- **Sample Data**: Realistic sample data for testing and demonstration

## Database Structure

```
CaresDB
└── healthcare (schema)
    ├── patients
    ├── caregivers
    ├── care_plans
    ├── health_records
    ├── medications
    ├── patient_care_summary (view)
    └── caregiver_workload (view)
```

## Tables

### patients
- **patient_id** (INT, Primary Key): Unique patient identifier
- **first_name** (VARCHAR(50)): Patient's first name
- **last_name** (VARCHAR(50)): Patient's last name
- **date_of_birth** (DATE): Patient's date of birth
- **gender** (VARCHAR(10)): Patient's gender
- **phone** (VARCHAR(20)): Patient's phone number
- **email** (VARCHAR(100)): Patient's email address
- **address** (VARCHAR(200)): Patient's address
- **city** (VARCHAR(50)): Patient's city
- **state** (VARCHAR(2)): Patient's state
- **zip_code** (VARCHAR(10)): Patient's zip code
- **emergency_contact** (VARCHAR(100)): Emergency contact name
- **emergency_phone** (VARCHAR(20)): Emergency contact phone
- **insurance_provider** (VARCHAR(100)): Insurance provider
- **insurance_number** (VARCHAR(50)): Insurance number
- **registration_date** (DATE): Patient registration date
- **load_date** (TIMESTAMP_LTZ): Record creation timestamp

### caregivers
- **caregiver_id** (INT, Primary Key): Unique caregiver identifier
- **first_name** (VARCHAR(50)): Caregiver's first name
- **last_name** (VARCHAR(50)): Caregiver's last name
- **specialization** (VARCHAR(100)): Caregiver's specialization
- **license_number** (VARCHAR(50)): License number
- **phone** (VARCHAR(20)): Caregiver's phone number
- **email** (VARCHAR(100)): Caregiver's email address
- **hire_date** (DATE): Hire date
- **status** (VARCHAR(20)): Current status
- **load_date** (TIMESTAMP_LTZ): Record creation timestamp

### care_plans
- **care_plan_id** (INT, Primary Key): Unique care plan identifier
- **patient_id** (INT, Foreign Key): Reference to patients table
- **caregiver_id** (INT, Foreign Key): Reference to caregivers table
- **plan_type** (VARCHAR(50)): Type of care plan
- **start_date** (DATE): Care plan start date
- **end_date** (DATE): Care plan end date
- **status** (VARCHAR(20)): Current status
- **description** (TEXT): Care plan description
- **goals** (TEXT): Care plan goals
- **load_date** (TIMESTAMP_LTZ): Record creation timestamp

### health_records
- **record_id** (INT, Primary Key): Unique health record identifier
- **patient_id** (INT, Foreign Key): Reference to patients table
- **caregiver_id** (INT, Foreign Key): Reference to caregivers table
- **visit_date** (DATE): Visit date
- **visit_type** (VARCHAR(50)): Type of visit
- **diagnosis** (TEXT): Diagnosis information
- **treatment** (TEXT): Treatment information
- **medications** (TEXT): Medications prescribed
- **vital_signs** (TEXT): Vital signs recorded
- **notes** (TEXT): Additional notes
- **load_date** (TIMESTAMP_LTZ): Record creation timestamp

### medications
- **medication_id** (INT, Primary Key): Unique medication identifier
- **patient_id** (INT, Foreign Key): Reference to patients table
- **medication_name** (VARCHAR(100)): Medication name
- **dosage** (VARCHAR(50)): Dosage information
- **frequency** (VARCHAR(50)): Frequency of administration
- **start_date** (DATE): Start date
- **end_date** (DATE): End date
- **prescribed_by** (VARCHAR(100)): Prescribing healthcare provider
- **status** (VARCHAR(20)): Current status
- **load_date** (TIMESTAMP_LTZ): Record creation timestamp

## Views

### patient_care_summary
Provides a comprehensive summary of patient care including:
- Patient demographic information
- Active care plans count
- Total visits and last visit date
- Active medications count

### caregiver_workload
Shows caregiver workload analysis including:
- Caregiver information and specialization
- Active care plans count
- Total visits and unique patients
- Workload distribution

## Data Governance

### PHI Tags (Protected Health Information)
The following columns are tagged for HIPAA compliance:
- **email**: Tagged as EMAIL
- **phone**: Tagged as PHONE
- **first_name**: Tagged as FIRST_NAME
- **last_name**: Tagged as LAST_NAME
- **date_of_birth**: Tagged as DATE_OF_BIRTH

### Medical Tags
- **diagnosis**: Tagged as DIAGNOSIS
- **treatment**: Tagged as TREATMENT
- **medication_name**: Tagged as MEDICATION

## Sample Data

The model includes realistic sample data for:
- 5 patients with complete demographic information
- 5 caregivers across different specializations
- 5 care plans with various types and goals
- 5 health records with different visit types
- 5 medications with various dosages and frequencies

## Usage Examples

### Patient Care Summary
```sql
SELECT * FROM healthcare.patient_care_summary
ORDER BY total_visits DESC;
```

### Caregiver Workload Analysis
```sql
SELECT * FROM healthcare.caregiver_workload
ORDER BY active_care_plans DESC;
```

### Patients with Multiple Medications
```sql
SELECT 
    p.first_name || ' ' || p.last_name as patient_name,
    COUNT(m.medication_id) as medication_count
FROM healthcare.patients p
JOIN healthcare.medications m ON p.patient_id = m.patient_id
WHERE m.status = 'Active'
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(m.medication_id) > 1
ORDER BY medication_count DESC;
```

## Setup Instructions

1. Run the complete `caresdb_data_model.sql` script in Snowflake
2. The script will create:
   - Database and schema
   - All tables with relationships
   - Sample data
   - Tags for HIPAA compliance
   - Views for analysis
   - Appropriate permissions

## Cleanup

To reset the demo environment, uncomment and run the cleanup section at the end of the SQL script.

## Version History

- **Version 1.2.7** (05/28/2024): Complete healthcare data model with HIPAA compliance
- Based on DemoHub CaresDB Data Model

## Related Resources

- DemoHub CaresDB Data Model: Healthcare and care management data model 