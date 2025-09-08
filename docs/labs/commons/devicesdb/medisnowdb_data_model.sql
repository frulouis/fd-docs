/*
------------------------------------------------------------------------------
-- Snowflake Demo Script: MediSnowDB Data Model
-- 
-- Description: 
-- This script sets up a medical device company data model in Snowflake.
-- MediSnow is a leading medical device company specializing in innovative 
-- technology for healthcare providers. Their product line ranges from 
-- state-of-the-art surgical robots to advanced patient monitoring systems.
--
-- DemoHub - MediSnowDB Data Model - Version 1.2.7 (updated 05/28/2024)
--
-- Features:
-- - Medical device inventory and specifications
-- - Customer complaint tracking and analysis
-- - Device maintenance and warranty management
-- - Regulatory compliance tracking
-- - Financial analysis and business unit management
-- - Ready for medical device analytics and reporting
------------------------------------------------------------------------------
*/

-- +----------------------------------------------------+
-- |             1. DATABASE AND SCHEMA SETUP           |
-- +----------------------------------------------------+

-- Create or replace the database
CREATE OR REPLACE DATABASE MediSnowDB;

-- Use the database
USE DATABASE MediSnowDB;

-- Create a schema for medical device data
CREATE OR REPLACE SCHEMA medical_devices;

-- +----------------------------------------------------+
-- |             2. CREATE TABLE STRUCTURES             |
-- +----------------------------------------------------+

-- Devices table - Stores detailed information about medical devices
CREATE OR REPLACE TABLE medical_devices.devices (
    DeviceID INT AUTOINCREMENT PRIMARY KEY,
    DeviceName VARCHAR(100),
    DeviceType VARCHAR(100),
    Manufacturer VARCHAR(100),
    ModelNumber VARCHAR(50),
    SerialNumber VARCHAR(50),
    ManufacturingDate DATE,
    ExpirationDate DATE,
    DeviceStatus VARCHAR(50),
    DeviceVersion VARCHAR(50),
    SoftwareVersion VARCHAR(50),
    RegulatoryApproval VARCHAR(100),
    ApprovalDate DATE,
    LastMaintenanceDate DATE,
    NextMaintenanceDate DATE,
    WarrantyStartDate DATE,
    WarrantyEndDate DATE,
    PurchaseDate DATE,
    PurchasePrice DECIMAL(10,2),
    BusinessUnit VARCHAR(50),
    load_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Customer complaints table - Captures customer feedback and issues
CREATE OR REPLACE TABLE medical_devices.customer_complaints (
    ComplaintID INT AUTOINCREMENT PRIMARY KEY,
    DeviceID INT REFERENCES medical_devices.devices(DeviceID),
    ComplaintDate DATE,
    CustomerName VARCHAR(100),
    DeviceName VARCHAR(100),
    ComplaintDetails TEXT,
    load_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- +----------------------------------------------------+
-- |             3. INSERT SAMPLE DATA                  |
-- +----------------------------------------------------+

-- Insert sample device data
INSERT INTO medical_devices.devices (DeviceName, DeviceType, Manufacturer, ModelNumber, SerialNumber, ManufacturingDate, ExpirationDate, DeviceStatus, DeviceVersion, SoftwareVersion, RegulatoryApproval, ApprovalDate, LastMaintenanceDate, NextMaintenanceDate, WarrantyStartDate, WarrantyEndDate, PurchaseDate, PurchasePrice, BusinessUnit) VALUES
('GloboMedic 5000', 'Heart Monitor', 'MediHealth', 'GM5000', 'GH123456', '2022-05-15', '2025-05-15', 'Active', '2.1', '3.0', 'FDA', '2022-04-20', '2023-04-20', '2024-04-20', '2022-05-15', '2025-05-15', '2022-04-20', 2500.00, 'Cardiovascular Devices'),
('roScan Plus', 'Dialysis Machine', 'RenalTech', 'NSP1000', 'RNT789012', '2022-06-20', '2026-06-20', 'Active', '1.5', '2.0', 'CE Mark', '2022-06-01', '2023-06-01', '2024-06-01', '2022-06-20', '2026-06-20', '2022-06-01', 5000.00, 'Renal Care'),
('NeuroSync Pro', 'Neurostimulator', 'NeuroLife Inc.', 'NSP2000', 'NL456789', '2022-07-10', '2027-07-10', 'Active', '3.0', '3.5', 'FDA', '2022-07-01', '2023-07-01', '2024-07-01', '2022-07-10', '2027-07-10', '2022-07-01', 7500.00, 'Neuromodulation'),
('ApexCore 3000', 'Surgical Robot', 'SurgiTech', 'SBX3000', 'ST234567', '2022-08-15', '2028-08-15', 'Active', '2.0', '2.5', 'FDA', '2022-08-01', '2023-08-01', '2024-08-01', '2022-08-15', '2028-08-15', '2022-08-01', 10000.00, 'Medical-Surgical Solutions'),
('OrthoFlex 2000', 'Joint Implant', 'OrthoTech', 'OF2000', 'OT123456', '2022-09-20', '2029-09-20', 'Active', '1.8', '2.2', 'CE Mark', '2022-09-01', '2023-09-01', '2024-09-01', '2022-09-20', '2029-09-20', '2022-09-01', 6000.00, 'Orthopedics'),
('QuantumNova X5', 'Vascular Scanner', 'VascuTech', 'VSU4000', 'VT789012', '2022-10-25', '2028-10-25', 'Active', '1.5', '2.0', 'FDA', '2022-10-01', '2023-10-01', '2024-10-01', '2022-10-25', '2028-10-25', '2022-10-01', 4500.00, 'Vascular Therapy'),
('MediScan Pro', 'Diagnostic Imaging', 'MediTech', 'MDP500', 'MT567890', '2022-11-05', '2027-11-05', 'Active', '2.2', '3.0', 'FDA', '2022-11-01', '2023-11-01', '2024-11-01', '2022-11-05', '2027-11-05', '2022-11-01', 8500.00, 'Diagnostic Imaging'),
('EndoView 3000', 'Endoscopy', 'EndoTech', 'EV3000', 'ET234567', '2022-12-10', '2028-12-10', 'Active', '1.0', '1.5', 'CE Mark', '2022-12-01', '2023-12-01', '2024-12-01', '2022-12-10', '2028-12-10', '2022-12-01', 7000.00, 'Endoscopy'),
('NeoSync 7G', 'Patient Monitor', 'CareTech', 'CCP1000', 'CT123456', '2023-01-15', '2029-01-15', 'Active', '2.5', '3.0', 'FDA', '2023-01-01', '2024-01-01', '2025-01-01', '2023-01-15', '2029-01-15', '2023-01-01', 9500.00, 'Critical Care'),
('VitaFlex 6000', 'Insulin Pump', 'VitaLife', 'VF6000', 'VL567890', '2023-02-20', '2028-02-20', 'Active', '1.8', '2.2', 'CE Mark', '2023-02-01', '2024-02-01', '2025-02-01', '2023-02-20', '2028-02-20', '2023-02-01', 3000.00, 'Diabetes Care'),
('NanoGlow 4.2', 'Bone Scanner', 'OsteoTech', 'NGS420', 'OS234567', '2023-03-10', '2028-03-10', 'Active', '1.2', '1.8', 'FDA', '2023-03-01', '2024-03-01', '2025-03-01', '2023-03-10', '2028-03-10', '2023-03-01', 5500.00, 'Orthopedics'),
('CryoTech 4000', 'Cryotherapy Unit', 'CryoLife', 'CT4000', 'CL789012', '2023-04-15', '2029-04-15', 'Active', '2.0', '2.5', 'CE Mark', '2023-04-01', '2024-04-01', '2025-04-01', '2023-04-15', '2029-04-15', '2023-04-01', 4000.00, 'Physical Therapy'),
('VitaScan 1000', 'Vital Signs Monitor', 'VitaTech', 'VSM1000', 'VT345678', '2023-05-20', '2028-05-20', 'Active', '1.5', '2.0', 'FDA', '2023-05-01', '2024-05-01', '2025-05-01', '2023-05-20', '2028-05-20', '2023-05-01', 3500.00, 'Critical Care'),
('EvoTech 7000', 'Evolution Scanner', 'EvoTech', 'EV7000', 'EV456789', '2023-06-25', '2029-06-25', 'Active', '3.0', '3.5', 'FDA', '2023-06-01', '2024-06-01', '2025-06-01', '2023-06-25', '2029-06-25', '2023-06-01', 12000.00, 'Diagnostic Imaging'),
('NebulaSync', 'Nebula System', 'NebulaTech', 'NS1000', 'NT567890', '2023-07-30', '2028-07-30', 'Active', '1.8', '2.2', 'CE Mark', '2023-07-01', '2024-07-01', '2025-07-01', '2023-07-30', '2028-07-30', '2023-07-01', 6500.00, 'Neuromodulation'),
('SynthraSys 9000', 'Synthetic System', 'SynthraTech', 'SS9000', 'ST678901', '2023-08-05', '2029-08-05', 'Active', '2.5', '3.0', 'FDA', '2023-08-01', '2024-08-01', '2025-08-01', '2023-08-05', '2029-08-05', '2023-08-01', 8000.00, 'Medical-Surgical Solutions'),
('TechVision Pro', 'Technology Vision', 'TechVision', 'TVP1000', 'TV789012', '2023-09-10', '2028-09-10', 'Active', '2.0', '2.5', 'CE Mark', '2023-09-01', '2024-09-01', '2025-09-01', '2023-09-10', '2028-09-10', '2023-09-01', 7500.00, 'Diagnostic Imaging'),
('MediSync 6000', 'Medical Sync', 'MediSync', 'MS6000', 'MS890123', '2023-10-15', '2029-10-15', 'Active', '1.5', '2.0', 'FDA', '2023-10-01', '2024-10-01', '2025-10-01', '2023-10-15', '2029-10-15', '2023-10-01', 5000.00, 'Critical Care'),
('AquaSense 2000', 'Aqua Sensor', 'AquaTech', 'AS2000', 'AT901234', '2023-11-20', '2028-11-20', 'Active', '1.2', '1.8', 'CE Mark', '2023-11-01', '2024-11-01', '2025-11-01', '2023-11-20', '2028-11-20', '2023-11-01', 2800.00, 'Physical Therapy'),
('Xerocore 2000', 'Xero Core', 'XeroTech', 'XC2000', 'XC012345', '2023-12-25', '2029-12-25', 'Active', '2.8', '3.2', 'FDA', '2023-12-01', '2024-12-01', '2025-12-01', '2023-12-25', '2029-12-25', '2023-12-01', 9000.00, 'Cardiovascular Devices'),
('FlexiCore 600', 'Flexi Core', 'FlexiTech', 'FC600', 'FC123456', '2024-01-30', '2029-01-30', 'Active', '1.0', '1.5', 'CE Mark', '2024-01-01', '2025-01-01', '2026-01-01', '2024-01-30', '2029-01-30', '2024-01-01', 3200.00, 'Orthopedics'),
('MediPulse 7000', 'Medical Pulse', 'MediPulse', 'MP7000', 'MP234567', '2024-02-05', '2029-02-05', 'Active', '2.2', '2.8', 'FDA', '2024-02-01', '2025-02-01', '2026-02-01', '2024-02-05', '2029-02-05', '2024-02-01', 6800.00, 'Critical Care'),
('TechNova 3000', 'Technology Nova', 'TechNova', 'TN3000', 'TN345678', '2024-03-10', '2029-03-10', 'Active', '1.8', '2.3', 'CE Mark', '2024-03-01', '2025-03-01', '2026-03-01', '2024-03-10', '2029-03-10', '2024-03-01', 4200.00, 'Diagnostic Imaging'),
('SynthoGen 4000', 'Synthetic Generator', 'SynthoGen', 'SG4000', 'SG456789', '2024-04-15', '2029-04-15', 'Active', '2.5', '3.0', 'FDA', '2024-04-01', '2025-04-01', '2026-04-01', '2024-04-15', '2029-04-15', '2024-04-01', 11000.00, 'Medical-Surgical Solutions'),
('NeuraScan 1000', 'Neural Scanner', 'NeuraScan', 'NS1000', 'NS567890', '2024-05-20', '2029-05-20', 'Active', '1.6', '2.1', 'CE Mark', '2024-05-01', '2025-05-01', '2026-05-01', '2024-05-20', '2029-05-20', '2024-05-01', 3800.00, 'Neuromodulation'),
('BioSpectra 8000', 'Biological Spectra', 'BioSpectra', 'BS8000', 'BS678901', '2024-06-25', '2029-06-25', 'Active', '3.2', '3.8', 'FDA', '2024-06-01', '2025-06-01', '2026-06-01', '2024-06-25', '2029-06-25', '2024-06-01', 15000.00, 'Diagnostic Imaging'),
('EcoView 6000', 'Eco View', 'EcoView', 'EV6000', 'EV789012', '2024-07-30', '2029-07-30', 'Active', '2.0', '2.6', 'CE Mark', '2024-07-01', '2025-07-01', '2026-07-01', '2024-07-30', '2029-07-30', '2024-07-01', 7200.00, 'Endoscopy'),
('MediLink Pro', 'Medical Link Pro', 'MediLink', 'MLP1000', 'ML890123', '2024-08-05', '2029-08-05', 'Active', '1.4', '2.0', 'FDA', '2024-08-01', '2025-08-01', '2026-08-01', '2024-08-05', '2029-08-05', '2024-08-01', 4500.00, 'Critical Care'),
('TechSync 2000', 'Technology Sync', 'TechSync', 'TS2000', 'TS901234', '2024-09-10', '2029-09-10', 'Active', '1.9', '2.4', 'CE Mark', '2024-09-01', '2025-09-01', '2026-09-01', '2024-09-10', '2029-09-10', '2024-09-01', 5800.00, 'Vascular Therapy'),
('SynthoPulse 3000', 'Synthetic Pulse', 'SynthoPulse', 'SP3000', 'SP012345', '2024-10-15', '2029-10-15', 'Active', '2.3', '2.9', 'FDA', '2024-10-01', '2025-10-01', '2026-10-01', '2024-10-15', '2029-10-15', '2024-10-01', 8200.00, 'Cardiovascular Devices'),
('NeuraSync 4000', 'Neural Sync', 'NeuraSync', 'NS4000', 'NS123456', '2024-11-20', '2029-11-20', 'Active', '1.7', '2.3', 'CE Mark', '2024-11-01', '2025-11-01', '2026-11-01', '2024-11-20', '2029-11-20', '2024-11-01', 5200.00, 'Neuromodulation');

-- Insert sample customer complaints data
INSERT INTO medical_devices.customer_complaints (DeviceID, ComplaintDate, CustomerName, DeviceName, ComplaintDetails) VALUES
(1, '2024-01-15', 'John Smith', 'GloboMedic 5000', 'The device has been working well overall, but I noticed some minor calibration issues during the last use.'),
(2, '2024-02-20', 'Sarah Johnson', 'roScan Plus', 'Excellent performance and reliability. The device has exceeded my expectations in terms of efficiency.'),
(3, '2024-03-10', 'Michael Brown', 'NeuroSync Pro', 'I have experienced some connectivity issues with the device, which has been frustrating during critical procedures.'),
(4, '2024-04-05', 'Emily Davis', 'ApexCore 3000', 'The surgical robot has been performing exceptionally well. Its precision and accuracy have improved our surgical outcomes significantly.'),
(5, '2024-05-12', 'David Wilson', 'OrthoFlex 2000', 'The joint implant has been functioning as expected. No issues reported so far.'),
(6, '2024-06-18', 'Lisa Anderson', 'QuantumNova X5', 'The vascular scanner has been reliable and provides clear, accurate images. Very satisfied with the performance.'),
(7, '2024-07-25', 'Robert Taylor', 'MediScan Pro', 'I have encountered some software glitches that occasionally affect the diagnostic imaging quality.'),
(8, '2024-08-30', 'Jennifer Garcia', 'EndoView 3000', 'The endoscopy device has been working perfectly. The image quality and maneuverability are excellent.'),
(9, '2024-09-15', 'William Martinez', 'NeoSync 7G', 'The patient monitor has been consistently reliable and provides accurate readings. Highly recommended.'),
(10, '2024-10-22', 'Amanda Rodriguez', 'VitaFlex 6000', 'The insulin pump has been working well, but I noticed some battery life issues that could be improved.'),
(11, '2024-11-08', 'Christopher Lee', 'NanoGlow 4.2', 'The bone scanner has been performing excellently. The resolution and accuracy are outstanding.'),
(12, '2024-12-15', 'Jessica White', 'CryoTech 4000', 'The CryoTech 4000 has been instrumental in my recovery process. Its effectiveness has exceeded my expectations.'),
(13, '2024-12-30', 'Emma Martinez', 'VitaScan 1000', 'I have had a positive experience using the VitaScan 1000. It has helped me track my health accurately and efficiently.'),
(14, '2025-07-05', 'Liam Brown', 'EvoTech 7000', 'I am extremely satisfied with the EvoTech 7000. It has revolutionized the way I monitor my health, and I couldnt be happier with the results.'),
(15, '2025-08-10', 'Emma Wilson', 'NebulaSync', 'The NebulaSync has been a disappointment. Despite my high hopes, it has not met my expectations, and I am left feeling frustrated.'),
(16, '2025-09-15', 'Oliver Garcia', 'SynthraSys 9000', 'The SynthraSys 9000 has been an invaluable tool in managing my health. Its accuracy and reliability have provided me with peace of mind.'),
(17, '2025-10-20', 'Sophia Smith', 'TechVision Pro', 'I recently underwent a procedure with the TechVision Pro healthcare system, and I am pleased with the outcome. The process was smooth, and I felt well taken care of.'),
(18, '2025-11-25', 'Noah Johnson', 'MediSync 6000', 'The MediSync 6000 has exceeded my expectations. It has helped me manage my condition effectively, and I am grateful for its impact on my life.'),
(19, '2025-12-30', 'Ava Martinez', 'AquaSense 2000', 'The AquaSense 2000 has been a lifesaver for me. Its accuracy and ease of use have made it an essential part of my daily routine.'),
(20, '2025-08-01', 'Ethan Harris', 'Xerocore 2000', 'I am quite satisfied with the performance of the Xerocore 2000. It has been reliable and efficient in monitoring my health.'),
(21, '2025-08-15', 'Olivia Clark', 'FlexiCore 600', 'Unfortunately, the FlexiCore 600 has not lived up to my expectations. It seems to have technical issues frequently, causing inconvenience.'),
(22, '2025-09-01', 'William Young', 'MediPulse 7000', 'The MediPulse 7000 is an exceptional device. Its accuracy and ease of use have been incredibly helpful in managing my health condition.'),
(23, '2025-09-15', 'Sophia Rodriguez', 'TechNova 3000', 'I had a positive experience with the TechNova 3000. It is intuitive and provides accurate data that I can rely on.'),
(24, '2025-10-01', 'Daniel Martinez', 'SynthoGen 4000', 'Unfortunately, the SynthoGen 4000 has been a disappointment. It seems to have compatibility issues with other devices, making it unreliable.'),
(25, '2025-10-15', 'Isabella Hernandez', 'NeuraScan 1000', 'The NeuraScan 1000 has been instrumental in monitoring my health. It is user-friendly and provides comprehensive data that I find valuable.'),
(26, '2025-11-01', 'Alexander Lopez', 'BioSpectra 8000', 'I am extremely satisfied with the BioSpectra 8000. It has exceeded my expectations and has become an essential part of my daily routine.'),
(27, '2025-11-15', 'Mia Gonzalez', 'EcoView 6000', 'The EcoView 6000 has been a letdown. Despite its promising features, it seems to have reliability issues, which is concerning.'),
(28, '2025-12-01', 'Michael Perez', 'MediLink Pro', 'The MediLink Pro is a reliable device. It has helped me manage my health effectively, and I appreciate its performance.'),
(29, '2025-12-15', 'Charlotte Carter', 'TechSync 2000', 'Unfortunately, the TechSync 2000 has not met my expectations. It seems to have technical glitches that affect its performance.'),
(30, '2026-01-01', 'Benjamin Torres', 'SynthoPulse 3000', 'The SynthoPulse 3000 has been a game-changer for me. Its effectiveness in managing my health condition has been remarkable.'),
(31, '2026-01-15', 'Amelia Flores', 'NeuraSync 4000', 'I am quite satisfied with the NeuraSync 4000. It has been reliable and efficient in monitoring my health.');

-- +----------------------------------------------------+
-- |             4. ADD COMMENTS AND TAGS               |
-- +----------------------------------------------------+

-- Add comments to tables for better documentation
COMMENT ON TABLE medical_devices.devices IS 'Stores detailed information about medical devices including specifications, maintenance, and regulatory compliance';
COMMENT ON TABLE medical_devices.customer_complaints IS 'Stores customer feedback and complaint information linked to specific devices';

-- Add comments to key columns
COMMENT ON COLUMN medical_devices.devices.DeviceName IS 'Name of the medical device';
COMMENT ON COLUMN medical_devices.devices.DeviceType IS 'Type or category of medical device';
COMMENT ON COLUMN medical_devices.devices.RegulatoryApproval IS 'Regulatory approval status (FDA, CE Mark, etc.)';
COMMENT ON COLUMN medical_devices.devices.BusinessUnit IS 'Business unit responsible for the device';
COMMENT ON COLUMN medical_devices.customer_complaints.ComplaintDetails IS 'Detailed description of the customer complaint';

-- +----------------------------------------------------+
-- |             5. CREATE TAGS FOR DATA GOVERNANCE     |
-- +----------------------------------------------------+

-- Create tags for data classification
CREATE OR REPLACE TAG MEDICAL_DEVICE_TAG;
CREATE OR REPLACE TAG CUSTOMER_DATA_TAG;
CREATE OR REPLACE TAG REGULATORY_TAG;

-- Apply medical device tags
ALTER TABLE medical_devices.devices ALTER COLUMN DeviceName SET TAG MEDICAL_DEVICE_TAG = 'DEVICE_NAME';
ALTER TABLE medical_devices.devices ALTER COLUMN DeviceType SET TAG MEDICAL_DEVICE_TAG = 'DEVICE_TYPE';
ALTER TABLE medical_devices.devices ALTER COLUMN PurchasePrice SET TAG MEDICAL_DEVICE_TAG = 'DEVICE_COST';

-- Apply customer data tags
ALTER TABLE medical_devices.customer_complaints ALTER COLUMN CustomerName SET TAG CUSTOMER_DATA_TAG = 'CUSTOMER_NAME';
ALTER TABLE medical_devices.customer_complaints ALTER COLUMN ComplaintDetails SET TAG CUSTOMER_DATA_TAG = 'COMPLAINT_TEXT';

-- Apply regulatory tags
ALTER TABLE medical_devices.devices ALTER COLUMN RegulatoryApproval SET TAG REGULATORY_TAG = 'APPROVAL_STATUS';
ALTER TABLE medical_devices.devices ALTER COLUMN ApprovalDate SET TAG REGULATORY_TAG = 'APPROVAL_DATE';

-- +----------------------------------------------------+
-- |             6. CREATE VIEWS                        |
-- +----------------------------------------------------+

-- Device performance summary view
CREATE OR REPLACE VIEW medical_devices.device_performance_summary AS
SELECT 
    d.DeviceID,
    d.DeviceName,
    d.DeviceType,
    d.Manufacturer,
    d.BusinessUnit,
    d.DeviceStatus,
    d.PurchasePrice,
    COUNT(cc.ComplaintID) as complaint_count,
    AVG(CASE WHEN cc.ComplaintDetails LIKE '%satisfied%' OR cc.ComplaintDetails LIKE '%excellent%' OR cc.ComplaintDetails LIKE '%good%' THEN 1 ELSE 0 END) as satisfaction_rate,
    MAX(cc.ComplaintDate) as last_complaint_date,
    DATEDIFF('day', d.LastMaintenanceDate, CURRENT_DATE()) as days_since_maintenance,
    DATEDIFF('day', CURRENT_DATE(), d.NextMaintenanceDate) as days_until_next_maintenance
FROM medical_devices.devices d
LEFT JOIN medical_devices.customer_complaints cc ON d.DeviceID = cc.DeviceID
GROUP BY d.DeviceID, d.DeviceName, d.DeviceType, d.Manufacturer, d.BusinessUnit, d.DeviceStatus, d.PurchasePrice, d.LastMaintenanceDate, d.NextMaintenanceDate;

-- Business unit analysis view
CREATE OR REPLACE VIEW medical_devices.business_unit_analysis AS
SELECT 
    d.BusinessUnit,
    COUNT(d.DeviceID) as device_count,
    SUM(d.PurchasePrice) as total_investment,
    AVG(d.PurchasePrice) as avg_device_cost,
    COUNT(cc.ComplaintID) as total_complaints,
    COUNT(DISTINCT cc.CustomerName) as unique_customers,
    AVG(CASE WHEN cc.ComplaintDetails LIKE '%satisfied%' OR cc.ComplaintDetails LIKE '%excellent%' OR cc.ComplaintDetails LIKE '%good%' THEN 1 ELSE 0 END) as overall_satisfaction_rate
FROM medical_devices.devices d
LEFT JOIN medical_devices.customer_complaints cc ON d.DeviceID = cc.DeviceID
GROUP BY d.BusinessUnit
ORDER BY total_investment DESC;

-- Regulatory compliance view
CREATE OR REPLACE VIEW medical_devices.regulatory_compliance AS
SELECT 
    d.RegulatoryApproval,
    COUNT(d.DeviceID) as device_count,
    COUNT(CASE WHEN d.ApprovalDate IS NOT NULL THEN 1 END) as approved_devices,
    COUNT(CASE WHEN d.ApprovalDate IS NULL THEN 1 END) as pending_approval,
    COUNT(CASE WHEN d.ExpirationDate <= CURRENT_DATE() THEN 1 END) as expired_devices,
    COUNT(CASE WHEN d.ExpirationDate <= DATEADD('month', 6, CURRENT_DATE()) THEN 1 END) as expiring_soon,
    AVG(d.PurchasePrice) as avg_device_cost
FROM medical_devices.devices d
GROUP BY d.RegulatoryApproval
ORDER BY device_count DESC;

-- +----------------------------------------------------+
-- |             7. CREATE STORED PROCEDURES            |
-- +----------------------------------------------------+

-- Stored procedure to get devices requiring maintenance
CREATE OR REPLACE PROCEDURE GetDevicesRequiringMaintenance()
RETURNS TABLE (
    device_id INT,
    device_name VARCHAR(100),
    device_type VARCHAR(100),
    business_unit VARCHAR(50),
    days_overdue INT,
    last_maintenance_date DATE,
    next_maintenance_date DATE
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            d.DeviceID as device_id,
            d.DeviceName as device_name,
            d.DeviceType as device_type,
            d.BusinessUnit as business_unit,
            DATEDIFF('day', d.NextMaintenanceDate, CURRENT_DATE()) as days_overdue,
            d.LastMaintenanceDate as last_maintenance_date,
            d.NextMaintenanceDate as next_maintenance_date
        FROM medical_devices.devices d
        WHERE d.NextMaintenanceDate <= CURRENT_DATE()
        ORDER BY days_overdue DESC
    );
END;
$$;

-- Stored procedure to get customer satisfaction analysis
CREATE OR REPLACE PROCEDURE GetCustomerSatisfactionAnalysis()
RETURNS TABLE (
    device_name VARCHAR(100),
    device_type VARCHAR(100),
    total_complaints INT,
    positive_feedback INT,
    negative_feedback INT,
    satisfaction_rate DECIMAL(5,2)
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            d.DeviceName as device_name,
            d.DeviceType as device_type,
            COUNT(cc.ComplaintID) as total_complaints,
            COUNT(CASE WHEN cc.ComplaintDetails LIKE '%satisfied%' OR cc.ComplaintDetails LIKE '%excellent%' OR cc.ComplaintDetails LIKE '%good%' OR cc.ComplaintDetails LIKE '%well%' THEN 1 END) as positive_feedback,
            COUNT(CASE WHEN cc.ComplaintDetails LIKE '%disappointment%' OR cc.ComplaintDetails LIKE '%issue%' OR cc.ComplaintDetails LIKE '%problem%' OR cc.ComplaintDetails LIKE '%frustrated%' THEN 1 END) as negative_feedback,
            ROUND(COUNT(CASE WHEN cc.ComplaintDetails LIKE '%satisfied%' OR cc.ComplaintDetails LIKE '%excellent%' OR cc.ComplaintDetails LIKE '%good%' OR cc.ComplaintDetails LIKE '%well%' THEN 1 END) * 100.0 / COUNT(cc.ComplaintID), 2) as satisfaction_rate
        FROM medical_devices.devices d
        LEFT JOIN medical_devices.customer_complaints cc ON d.DeviceID = cc.DeviceID
        GROUP BY d.DeviceName, d.DeviceType
        HAVING COUNT(cc.ComplaintID) > 0
        ORDER BY satisfaction_rate DESC
    );
END;
$$;

-- +----------------------------------------------------+
-- |             8. SAMPLE QUERIES FOR TESTING          |
-- +----------------------------------------------------+

-- Test query 1: Get device performance summary
/*
SELECT * FROM medical_devices.device_performance_summary
ORDER BY complaint_count DESC;
*/

-- Test query 2: Get business unit analysis
/*
SELECT * FROM medical_devices.business_unit_analysis
ORDER BY total_investment DESC;
*/

-- Test query 3: Get regulatory compliance
/*
SELECT * FROM medical_devices.regulatory_compliance
ORDER BY device_count DESC;
*/

-- Test query 4: Get devices requiring maintenance
/*
CALL GetDevicesRequiringMaintenance();
*/

-- Test query 5: Get customer satisfaction analysis
/*
CALL GetCustomerSatisfactionAnalysis();
*/

-- +----------------------------------------------------+
-- |             9. CLEANUP SCRIPT (OPTIONAL)           |
-- +----------------------------------------------------+

/*
-- To reset the demo environment, uncomment and run:

USE ROLE ACCOUNTADMIN;

-- Drop the database
DROP DATABASE IF EXISTS MediSnowDB CASCADE;
*/ 