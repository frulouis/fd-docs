/*
------------------------------------------------------------------------------
-- Snowflake Demo Script: CaresDB Data Model
-- 
-- Description: 
-- This script sets up a healthcare/care management data model in Snowflake.
-- It includes tables for patients, caregivers, care plans, and health records.
--
-- DemoHub - CaresDB Data Model - Version 1.2.7 (updated 05/28/2024)
--
-- Features:
-- - Healthcare/care management data model
-- - Patient and caregiver information
-- - Care plans and health records
-- - Medication and treatment tracking
-- - HIPAA-compliant data governance
-- - Ready for healthcare analytics and reporting
------------------------------------------------------------------------------
*/

-- +----------------------------------------------------+
-- |             1. DATABASE AND SCHEMA SETUP           |
-- +----------------------------------------------------+

-- Create or replace the database
CREATE OR REPLACE DATABASE CaresDB;

-- Use the database
USE CaresDB;

-- Create a schema for healthcare data
CREATE OR REPLACE SCHEMA healthcare;

-- +----------------------------------------------------+
-- |             2. CREATE TABLE STRUCTURES             |
-- +----------------------------------------------------+

-- Patients table
CREATE OR REPLACE TABLE healthcare.patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    emergency_contact VARCHAR(100),
    emergency_phone VARCHAR(20),
    insurance_provider VARCHAR(100),
    insurance_number VARCHAR(50),
    registration_date DATE,
    load_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Caregivers table
CREATE OR REPLACE TABLE healthcare.caregivers (
    caregiver_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    license_number VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE,
    status VARCHAR(20),
    load_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Care plans table
CREATE OR REPLACE TABLE healthcare.care_plans (
    care_plan_id INT PRIMARY KEY,
    patient_id INT REFERENCES healthcare.patients(patient_id),
    caregiver_id INT REFERENCES healthcare.caregivers(caregiver_id),
    plan_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    description TEXT,
    goals TEXT,
    load_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Health records table
CREATE OR REPLACE TABLE healthcare.health_records (
    record_id INT PRIMARY KEY,
    patient_id INT REFERENCES healthcare.patients(patient_id),
    caregiver_id INT REFERENCES healthcare.caregivers(caregiver_id),
    visit_date DATE,
    visit_type VARCHAR(50),
    diagnosis TEXT,
    treatment TEXT,
    medications TEXT,
    vital_signs TEXT,
    notes TEXT,
    load_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Medications table
CREATE OR REPLACE TABLE healthcare.medications (
    medication_id INT PRIMARY KEY,
    patient_id INT REFERENCES healthcare.patients(patient_id),
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    start_date DATE,
    end_date DATE,
    prescribed_by VARCHAR(100),
    status VARCHAR(20),
    load_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- +----------------------------------------------------+
-- |             3. INSERT SAMPLE DATA                  |
-- +----------------------------------------------------+

-- Insert sample patients
INSERT INTO healthcare.patients (patient_id, first_name, last_name, date_of_birth, gender, phone, email, address, city, state, zip_code, emergency_contact, emergency_phone, insurance_provider, insurance_number, registration_date) VALUES
(1, 'John', 'Smith', '1980-05-15', 'Male', '555-0101', 'john.smith@email.com', '123 Main St', 'New York', 'NY', '10001', 'Jane Smith', '555-0102', 'Blue Cross', 'BC123456789', '2024-01-15'),
(2, 'Sarah', 'Johnson', '1975-08-22', 'Female', '555-0103', 'sarah.johnson@email.com', '456 Oak Ave', 'Los Angeles', 'CA', '90210', 'Mike Johnson', '555-0104', 'Aetna', 'AE987654321', '2024-01-20'),
(3, 'Michael', 'Brown', '1990-03-10', 'Male', '555-0105', 'michael.brown@email.com', '789 Pine Rd', 'Chicago', 'IL', '60601', 'Lisa Brown', '555-0106', 'Cigna', 'CI456789123', '2024-02-01'),
(4, 'Emily', 'Davis', '1985-12-05', 'Female', '555-0107', 'emily.davis@email.com', '321 Elm St', 'Houston', 'TX', '77001', 'Robert Davis', '555-0108', 'UnitedHealth', 'UH789123456', '2024-02-10'),
(5, 'David', 'Wilson', '1978-07-18', 'Male', '555-0109', 'david.wilson@email.com', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'Amanda Wilson', '555-0110', 'Humana', 'HU321654987', '2024-02-15');

-- Insert sample caregivers
INSERT INTO healthcare.caregivers (caregiver_id, first_name, last_name, specialization, license_number, phone, email, hire_date, status) VALUES
(1, 'Dr. Jennifer', 'Martinez', 'Primary Care', 'MD123456', '555-0201', 'dr.martinez@clinic.com', '2020-01-15', 'Active'),
(2, 'Dr. Robert', 'Taylor', 'Cardiology', 'MD789012', '555-0202', 'dr.taylor@clinic.com', '2019-03-20', 'Active'),
(3, 'Nurse Sarah', 'Anderson', 'Registered Nurse', 'RN345678', '555-0203', 'nurse.anderson@clinic.com', '2021-06-10', 'Active'),
(4, 'Dr. William', 'Garcia', 'Pediatrics', 'MD901234', '555-0204', 'dr.garcia@clinic.com', '2018-09-15', 'Active'),
(5, 'Nurse Lisa', 'Rodriguez', 'Registered Nurse', 'RN567890', '555-0205', 'nurse.rodriguez@clinic.com', '2022-02-28', 'Active');

-- Insert sample care plans
INSERT INTO healthcare.care_plans (care_plan_id, patient_id, caregiver_id, plan_type, start_date, end_date, status, description, goals) VALUES
(1, 1, 1, 'Chronic Disease Management', '2024-01-20', '2024-12-31', 'Active', 'Diabetes management plan', 'Maintain blood sugar levels, regular monitoring'),
(2, 2, 2, 'Cardiac Care', '2024-02-01', '2024-08-01', 'Active', 'Post-heart attack recovery plan', 'Improve heart health, reduce risk factors'),
(3, 3, 3, 'Preventive Care', '2024-02-15', '2024-12-31', 'Active', 'Annual wellness plan', 'Maintain overall health, preventive screenings'),
(4, 4, 4, 'Pediatric Care', '2024-03-01', '2024-12-31', 'Active', 'Child wellness plan', 'Growth monitoring, vaccinations'),
(5, 5, 5, 'Geriatric Care', '2024-03-15', '2024-12-31', 'Active', 'Senior health management', 'Maintain independence, manage chronic conditions');

-- Insert sample health records
INSERT INTO healthcare.health_records (record_id, patient_id, caregiver_id, visit_date, visit_type, diagnosis, treatment, medications, vital_signs, notes) VALUES
(1, 1, 1, '2024-03-01', 'Follow-up', 'Type 2 Diabetes', 'Blood sugar monitoring', 'Metformin 500mg twice daily', 'BP: 130/85, HR: 72, Temp: 98.6', 'Patient reports good compliance with diet'),
(2, 2, 2, '2024-03-05', 'Cardiac Checkup', 'Hypertension', 'Lifestyle modifications', 'Lisinopril 10mg daily', 'BP: 140/90, HR: 68, Temp: 98.4', 'Recommended salt reduction'),
(3, 3, 3, '2024-03-10', 'Annual Physical', 'Healthy', 'Preventive care', 'None', 'BP: 120/80, HR: 70, Temp: 98.6', 'All screenings normal'),
(4, 4, 4, '2024-03-12', 'Well Child Visit', 'Healthy', 'Vaccination', 'None', 'HR: 85, Temp: 98.8', 'Received flu vaccine'),
(5, 5, 5, '2024-03-15', 'Geriatric Assessment', 'Arthritis', 'Physical therapy', 'Ibuprofen as needed', 'BP: 135/88, HR: 65, Temp: 98.5', 'Referred to physical therapy');

-- Insert sample medications
INSERT INTO healthcare.medications (medication_id, patient_id, medication_name, dosage, frequency, start_date, end_date, prescribed_by, status) VALUES
(1, 1, 'Metformin', '500mg', 'Twice daily', '2024-01-20', '2024-12-31', 'Dr. Martinez', 'Active'),
(2, 2, 'Lisinopril', '10mg', 'Once daily', '2024-02-01', '2024-08-01', 'Dr. Taylor', 'Active'),
(3, 5, 'Ibuprofen', '400mg', 'As needed', '2024-03-15', '2024-06-15', 'Nurse Rodriguez', 'Active'),
(4, 1, 'Glipizide', '5mg', 'Once daily', '2024-02-15', '2024-12-31', 'Dr. Martinez', 'Active'),
(5, 2, 'Amlodipine', '5mg', 'Once daily', '2024-02-15', '2024-08-01', 'Dr. Taylor', 'Active');

-- +----------------------------------------------------+
-- |             4. ADD COMMENTS AND TAGS               |
-- +----------------------------------------------------+

-- Add comments to tables for better documentation
COMMENT ON TABLE healthcare.patients IS 'Stores patient demographic and contact information';
COMMENT ON TABLE healthcare.caregivers IS 'Stores healthcare provider information';
COMMENT ON TABLE healthcare.care_plans IS 'Stores patient care plans and treatment goals';
COMMENT ON TABLE healthcare.health_records IS 'Stores patient health records and visit information';
COMMENT ON TABLE healthcare.medications IS 'Stores patient medication information';

-- +----------------------------------------------------+
-- |             5. CREATE TAGS FOR HIPAA COMPLIANCE    |
-- +----------------------------------------------------+

-- Create tags for HIPAA-protected information
CREATE OR REPLACE TAG PHI_TAG;
CREATE OR REPLACE TAG MEDICAL_TAG;

-- Apply PHI tags to sensitive columns
ALTER TABLE healthcare.patients ALTER COLUMN email SET TAG PHI_TAG = 'EMAIL';
ALTER TABLE healthcare.patients ALTER COLUMN phone SET TAG PHI_TAG = 'PHONE';
ALTER TABLE healthcare.patients ALTER COLUMN first_name SET TAG PHI_TAG = 'FIRST_NAME';
ALTER TABLE healthcare.patients ALTER COLUMN last_name SET TAG PHI_TAG = 'LAST_NAME';
ALTER TABLE healthcare.patients ALTER COLUMN date_of_birth SET TAG PHI_TAG = 'DATE_OF_BIRTH';

-- Apply medical tags
ALTER TABLE healthcare.health_records ALTER COLUMN diagnosis SET TAG MEDICAL_TAG = 'DIAGNOSIS';
ALTER TABLE healthcare.health_records ALTER COLUMN treatment SET TAG MEDICAL_TAG = 'TREATMENT';
ALTER TABLE healthcare.medications ALTER COLUMN medication_name SET TAG MEDICAL_TAG = 'MEDICATION';

-- +----------------------------------------------------+
-- |             6. CREATE VIEWS                        |
-- +----------------------------------------------------+

-- Patient care summary view
CREATE OR REPLACE VIEW healthcare.patient_care_summary AS
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name as patient_name,
    p.date_of_birth,
    COUNT(cp.care_plan_id) as active_care_plans,
    COUNT(hr.record_id) as total_visits,
    MAX(hr.visit_date) as last_visit,
    COUNT(m.medication_id) as active_medications
FROM healthcare.patients p
LEFT JOIN healthcare.care_plans cp ON p.patient_id = cp.patient_id AND cp.status = 'Active'
LEFT JOIN healthcare.health_records hr ON p.patient_id = hr.patient_id
LEFT JOIN healthcare.medications m ON p.patient_id = m.patient_id AND m.status = 'Active'
GROUP BY p.patient_id, p.first_name, p.last_name, p.date_of_birth;

-- Caregiver workload view
CREATE OR REPLACE VIEW healthcare.caregiver_workload AS
SELECT 
    c.caregiver_id,
    c.first_name || ' ' || c.last_name as caregiver_name,
    c.specialization,
    COUNT(cp.care_plan_id) as active_care_plans,
    COUNT(hr.record_id) as total_visits,
    COUNT(DISTINCT p.patient_id) as unique_patients
FROM healthcare.caregivers c
LEFT JOIN healthcare.care_plans cp ON c.caregiver_id = cp.caregiver_id AND cp.status = 'Active'
LEFT JOIN healthcare.health_records hr ON c.caregiver_id = hr.caregiver_id
LEFT JOIN healthcare.patients p ON cp.patient_id = p.patient_id OR hr.patient_id = p.patient_id
GROUP BY c.caregiver_id, c.first_name, c.last_name, c.specialization;

-- +----------------------------------------------------+
-- |             7. SAMPLE QUERIES FOR TESTING          |
-- +----------------------------------------------------+

-- Test query 1: Get patient care summary
/*
SELECT * FROM healthcare.patient_care_summary
ORDER BY total_visits DESC;
*/

-- Test query 2: Get caregiver workload
/*
SELECT * FROM healthcare.caregiver_workload
ORDER BY active_care_plans DESC;
*/

-- Test query 3: Get patients with multiple medications
/*
SELECT 
    p.first_name || ' ' || p.last_name as patient_name,
    COUNT(m.medication_id) as medication_count
FROM healthcare.patients p
JOIN healthcare.medications m ON p.patient_id = m.patient_id
WHERE m.status = 'Active'
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(m.medication_id) > 1
ORDER BY medication_count DESC;
*/

-- +----------------------------------------------------+
-- |             8. CLEANUP SCRIPT (OPTIONAL)           |
-- +----------------------------------------------------+

/*
-- To reset the demo environment, uncomment and run:

USE ROLE ACCOUNTADMIN;

-- Drop the database
DROP DATABASE IF EXISTS CaresDB CASCADE;
*/ 