-- =====================================================
-- LEGALDB - Legal and Contracts Database
-- Comprehensive legal data model for Snowflake demonstrations
-- Version: 1.0.0
-- Last Updated: December 2024
-- =====================================================

-- Create database and schema
CREATE OR REPLACE DATABASE LEGALDB;
USE DATABASE LEGALDB;
CREATE OR REPLACE SCHEMA legal;

-- =====================================================
-- TABLES
-- =====================================================

-- Contracts table
CREATE OR REPLACE TABLE legal.contracts (
    contract_id INT PRIMARY KEY,
    contract_number VARCHAR(50) UNIQUE NOT NULL,
    contract_title VARCHAR(200) NOT NULL,
    contract_type VARCHAR(100),
    contract_category VARCHAR(100),
    party_a_name VARCHAR(200),
    party_a_type VARCHAR(50),
    party_b_name VARCHAR(200),
    party_b_type VARCHAR(50),
    contract_value DECIMAL(15,2),
    currency VARCHAR(3) DEFAULT 'USD',
    start_date DATE,
    end_date DATE,
    renewal_date DATE,
    auto_renewal BOOLEAN DEFAULT FALSE,
    contract_status VARCHAR(50) DEFAULT 'DRAFT',
    approval_status VARCHAR(50) DEFAULT 'PENDING',
    contract_manager VARCHAR(100),
    legal_reviewer VARCHAR(100),
    business_owner VARCHAR(100),
    department VARCHAR(100),
    contract_terms TEXT,
    key_obligations TEXT,
    risk_level VARCHAR(20),
    compliance_requirements TEXT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Contract Amendments table
CREATE OR REPLACE TABLE legal.contract_amendments (
    amendment_id INT PRIMARY KEY,
    contract_id INT REFERENCES legal.contracts(contract_id),
    amendment_number VARCHAR(50),
    amendment_type VARCHAR(100),
    amendment_date DATE,
    effective_date DATE,
    amendment_description TEXT,
    changes_made TEXT,
    approval_status VARCHAR(50) DEFAULT 'PENDING',
    approved_by VARCHAR(100),
    approval_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Legal Cases table
CREATE OR REPLACE TABLE legal.legal_cases (
    case_id INT PRIMARY KEY,
    case_number VARCHAR(50) UNIQUE NOT NULL,
    case_title VARCHAR(200) NOT NULL,
    case_type VARCHAR(100),
    case_category VARCHAR(100),
    filing_date DATE,
    court_name VARCHAR(200),
    court_location VARCHAR(200),
    case_status VARCHAR(50) DEFAULT 'OPEN',
    priority_level VARCHAR(20),
    assigned_attorney VARCHAR(100),
    opposing_party VARCHAR(200),
    opposing_counsel VARCHAR(200),
    case_description TEXT,
    legal_issues TEXT,
    potential_liability DECIMAL(15,2),
    settlement_amount DECIMAL(15,2),
    judgment_amount DECIMAL(15,2),
    case_outcome VARCHAR(100),
    closed_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Case Documents table
CREATE OR REPLACE TABLE legal.case_documents (
    document_id INT PRIMARY KEY,
    case_id INT REFERENCES legal.legal_cases(case_id),
    document_name VARCHAR(200),
    document_type VARCHAR(100),
    document_category VARCHAR(100),
    filing_date DATE,
    document_url VARCHAR(500),
    file_size_bytes INT,
    confidentiality_level VARCHAR(50),
    attorney_work_product BOOLEAN DEFAULT FALSE,
    privileged_communication BOOLEAN DEFAULT FALSE,
    created_by VARCHAR(100),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Regulations table
CREATE OR REPLACE TABLE legal.regulations (
    regulation_id INT PRIMARY KEY,
    regulation_name VARCHAR(200) NOT NULL,
    regulation_code VARCHAR(100),
    regulatory_body VARCHAR(200),
    jurisdiction VARCHAR(100),
    effective_date DATE,
    compliance_deadline DATE,
    regulation_type VARCHAR(100),
    regulation_category VARCHAR(100),
    description TEXT,
    requirements TEXT,
    penalties TEXT,
    compliance_status VARCHAR(50) DEFAULT 'PENDING',
    responsible_department VARCHAR(100),
    compliance_officer VARCHAR(100),
    last_review_date DATE,
    next_review_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Compliance Audits table
CREATE OR REPLACE TABLE legal.compliance_audits (
    audit_id INT PRIMARY KEY,
    audit_name VARCHAR(200) NOT NULL,
    audit_type VARCHAR(100),
    audit_scope TEXT,
    audit_period_start DATE,
    audit_period_end DATE,
    audit_date DATE,
    auditor_name VARCHAR(100),
    auditor_company VARCHAR(200),
    audit_status VARCHAR(50) DEFAULT 'PLANNED',
    findings TEXT,
    recommendations TEXT,
    risk_level VARCHAR(20),
    compliance_score DECIMAL(5,2),
    follow_up_required BOOLEAN DEFAULT FALSE,
    follow_up_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Intellectual Property table
CREATE OR REPLACE TABLE legal.intellectual_property (
    ip_id INT PRIMARY KEY,
    ip_name VARCHAR(200) NOT NULL,
    ip_type VARCHAR(100),
    ip_category VARCHAR(100),
    description TEXT,
    filing_date DATE,
    registration_date DATE,
    registration_number VARCHAR(100),
    jurisdiction VARCHAR(100),
    status VARCHAR(50) DEFAULT 'PENDING',
    owner VARCHAR(200),
    inventor_creator VARCHAR(200),
    renewal_date DATE,
    expiration_date DATE,
    estimated_value DECIMAL(15,2),
    licensing_agreements TEXT,
    infringement_cases TEXT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Legal Expenses table
CREATE OR REPLACE TABLE legal.legal_expenses (
    expense_id INT PRIMARY KEY,
    case_id INT REFERENCES legal.legal_cases(case_id),
    contract_id INT REFERENCES legal.contracts(contract_id),
    expense_date DATE,
    expense_category VARCHAR(100),
    expense_type VARCHAR(100),
    description TEXT,
    amount DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    vendor_name VARCHAR(200),
    invoice_number VARCHAR(100),
    payment_status VARCHAR(50) DEFAULT 'PENDING',
    approved_by VARCHAR(100),
    approval_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Legal Calendar table
CREATE OR REPLACE TABLE legal.legal_calendar (
    calendar_id INT PRIMARY KEY,
    case_id INT REFERENCES legal.legal_cases(case_id),
    contract_id INT REFERENCES legal.contracts(contract_id),
    event_type VARCHAR(100),
    event_title VARCHAR(200),
    event_date DATE,
    event_time TIME,
    event_location VARCHAR(200),
    event_description TEXT,
    priority_level VARCHAR(20),
    assigned_to VARCHAR(100),
    reminder_days INT,
    completed BOOLEAN DEFAULT FALSE,
    completion_notes TEXT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Insert contracts
INSERT INTO legal.contracts (contract_id, contract_number, contract_title, contract_type, contract_category, party_a_name, party_a_type, party_b_name, party_b_type, contract_value, start_date, end_date, contract_status, approval_status, contract_manager, legal_reviewer, business_owner, department, risk_level) VALUES
(1, 'CTR-2024-001', 'Software License Agreement', 'License', 'Technology', 'TechCorp Inc.', 'Customer', 'Software Solutions Ltd.', 'Vendor', 500000.00, '2024-01-01', '2024-12-31', 'ACTIVE', 'APPROVED', 'John Smith', 'Sarah Johnson', 'Mike Davis', 'IT', 'MEDIUM'),
(2, 'CTR-2024-002', 'Office Lease Agreement', 'Lease', 'Real Estate', 'OfficeSpace LLC', 'Landlord', 'TechCorp Inc.', 'Tenant', 120000.00, '2024-03-01', '2027-02-28', 'ACTIVE', 'APPROVED', 'Lisa Anderson', 'David Wilson', 'Jennifer Brown', 'Facilities', 'LOW'),
(3, 'CTR-2024-003', 'Consulting Services Agreement', 'Service', 'Professional Services', 'TechCorp Inc.', 'Client', 'Consulting Partners', 'Consultant', 250000.00, '2024-06-01', '2024-11-30', 'ACTIVE', 'APPROVED', 'Robert Taylor', 'Emily Davis', 'Chris Garcia', 'Operations', 'MEDIUM'),
(4, 'CTR-2024-004', 'Employment Agreement', 'Employment', 'HR', 'TechCorp Inc.', 'Employer', 'Alex Thompson', 'Employee', 85000.00, '2024-08-01', '2027-07-31', 'ACTIVE', 'APPROVED', 'HR Manager', 'Legal Team', 'Department Head', 'HR', 'LOW'),
(5, 'CTR-2024-005', 'Non-Disclosure Agreement', 'NDA', 'Confidentiality', 'TechCorp Inc.', 'Disclosing Party', 'Potential Partner', 'Receiving Party', 0.00, '2024-09-01', '2026-08-31', 'ACTIVE', 'APPROVED', 'Legal Team', 'Sarah Johnson', 'Business Development', 'Legal', 'HIGH');

-- Insert contract amendments
INSERT INTO legal.contract_amendments (amendment_id, contract_id, amendment_number, amendment_type, amendment_date, effective_date, amendment_description, changes_made, approval_status, approved_by) VALUES
(1, 1, 'AMEND-001', 'Extension', '2024-11-15', '2024-12-01', 'Extend contract for additional 6 months', 'Extended end date from 2024-12-31 to 2025-06-30', 'APPROVED', 'Sarah Johnson'),
(2, 2, 'AMEND-002', 'Rent Increase', '2024-10-01', '2025-03-01', 'Annual rent increase of 3%', 'Monthly rent increased from $10,000 to $10,300', 'PENDING', NULL),
(3, 3, 'AMEND-003', 'Scope Change', '2024-09-15', '2024-10-01', 'Additional consulting services', 'Added 100 hours of additional consulting work', 'APPROVED', 'Emily Davis');

-- Insert legal cases
INSERT INTO legal.legal_cases (case_id, case_number, case_title, case_type, case_category, filing_date, court_name, court_location, case_status, priority_level, assigned_attorney, opposing_party, case_description, potential_liability) VALUES
(1, 'CASE-2024-001', 'Smith v. TechCorp - Employment Discrimination', 'Civil', 'Employment', '2024-02-15', 'Superior Court', 'San Francisco, CA', 'OPEN', 'HIGH', 'Sarah Johnson', 'Jane Smith', 'Employment discrimination claim alleging wrongful termination', 500000.00),
(2, 'CASE-2024-002', 'TechCorp v. Competitor - Patent Infringement', 'Civil', 'Intellectual Property', '2024-04-20', 'Federal District Court', 'San Jose, CA', 'OPEN', 'HIGH', 'David Wilson', 'Competitor Corp', 'Patent infringement lawsuit regarding software technology', 2000000.00),
(3, 'CASE-2024-003', 'TechCorp v. Vendor - Breach of Contract', 'Civil', 'Contract', '2024-06-10', 'Superior Court', 'Los Angeles, CA', 'SETTLEMENT', 'MEDIUM', 'Emily Davis', 'Vendor Solutions', 'Breach of contract claim for failed software delivery', 300000.00),
(4, 'CASE-2024-004', 'Regulatory Investigation - Data Privacy', 'Administrative', 'Regulatory', '2024-08-05', 'State Attorney General', 'Sacramento, CA', 'OPEN', 'HIGH', 'Sarah Johnson', 'State of California', 'Data privacy compliance investigation', 1000000.00),
(5, 'CASE-2024-005', 'TechCorp v. Former Employee - Trade Secret Theft', 'Civil', 'Trade Secrets', '2024-09-15', 'Federal District Court', 'San Francisco, CA', 'OPEN', 'HIGH', 'David Wilson', 'John Doe', 'Alleged theft of trade secrets by former employee', 750000.00);

-- Insert case documents
INSERT INTO legal.case_documents (document_id, case_id, document_name, document_type, document_category, filing_date, file_size_bytes, confidentiality_level, attorney_work_product, privileged_communication) VALUES
(1, 1, 'Complaint - Employment Discrimination', 'Pleading', 'Court Filing', '2024-02-15', 250000, 'PUBLIC', FALSE, FALSE),
(2, 1, 'Internal Investigation Report', 'Report', 'Internal', '2024-02-10', 150000, 'CONFIDENTIAL', TRUE, TRUE),
(3, 2, 'Patent Registration Certificate', 'Certificate', 'Evidence', '2020-05-15', 50000, 'PUBLIC', FALSE, FALSE),
(4, 2, 'Expert Witness Report', 'Report', 'Evidence', '2024-05-01', 300000, 'CONFIDENTIAL', TRUE, FALSE),
(5, 3, 'Settlement Agreement', 'Agreement', 'Resolution', '2024-11-01', 200000, 'CONFIDENTIAL', TRUE, TRUE);

-- Insert regulations
INSERT INTO legal.regulations (regulation_id, regulation_name, regulation_code, regulatory_body, jurisdiction, effective_date, compliance_deadline, regulation_type, regulation_category, description, requirements, compliance_status, responsible_department, compliance_officer) VALUES
(1, 'California Consumer Privacy Act', 'CCPA', 'California Attorney General', 'California', '2020-01-01', '2024-12-31', 'Privacy', 'Data Protection', 'Consumer privacy protection law', 'Data subject rights, privacy notices, opt-out mechanisms', 'COMPLIANT', 'Legal', 'Sarah Johnson'),
(2, 'General Data Protection Regulation', 'GDPR', 'European Commission', 'European Union', '2018-05-25', '2024-12-31', 'Privacy', 'Data Protection', 'EU data protection regulation', 'Data processing principles, individual rights, breach notification', 'COMPLIANT', 'Legal', 'Sarah Johnson'),
(3, 'Sarbanes-Oxley Act', 'SOX', 'SEC', 'United States', '2002-07-30', '2024-12-31', 'Financial', 'Corporate Governance', 'Corporate accountability and financial reporting', 'Internal controls, financial reporting, whistleblower protection', 'COMPLIANT', 'Finance', 'David Wilson'),
(4, 'Health Insurance Portability and Accountability Act', 'HIPAA', 'HHS', 'United States', '1996-08-21', '2024-12-31', 'Healthcare', 'Privacy', 'Healthcare data protection', 'Patient privacy, security safeguards, breach notification', 'PENDING', 'Legal', 'Sarah Johnson'),
(5, 'Americans with Disabilities Act', 'ADA', 'DOJ', 'United States', '1990-07-26', '2024-12-31', 'Civil Rights', 'Accessibility', 'Disability rights and accessibility', 'Reasonable accommodations, accessibility requirements', 'COMPLIANT', 'HR', 'Emily Davis');

-- Insert compliance audits
INSERT INTO legal.compliance_audits (audit_id, audit_name, audit_type, audit_scope, audit_period_start, audit_period_end, audit_date, auditor_name, auditor_company, audit_status, findings, recommendations, risk_level, compliance_score) VALUES
(1, 'CCPA Compliance Audit 2024', 'Privacy', 'Data handling practices and consumer rights', '2024-01-01', '2024-12-31', '2024-11-15', 'Privacy Audit Partners', 'Audit Solutions Inc.', 'COMPLETED', 'Minor gaps in data subject request processing', 'Implement automated request tracking system', 'LOW', 92.5),
(2, 'SOX Internal Controls Review', 'Financial', 'Financial reporting and internal controls', '2024-01-01', '2024-12-31', '2024-10-20', 'Financial Audit Group', 'Audit Solutions Inc.', 'COMPLETED', 'Controls operating effectively', 'Continue monitoring and testing', 'LOW', 95.0),
(3, 'GDPR Compliance Assessment', 'Privacy', 'EU data processing activities', '2024-01-01', '2024-12-31', '2024-09-30', 'European Privacy Consultants', 'Privacy Audit Partners', 'IN_PROGRESS', 'Pending review of data processing agreements', 'Update vendor contracts with GDPR clauses', 'MEDIUM', 85.0),
(4, 'ADA Accessibility Review', 'Accessibility', 'Website and application accessibility', '2024-01-01', '2024-12-31', '2024-08-15', 'Accessibility Experts', 'Compliance Consultants', 'COMPLETED', 'Several accessibility issues identified', 'Implement WCAG 2.1 AA compliance', 'HIGH', 75.0),
(5, 'HIPAA Security Assessment', 'Healthcare', 'Protected health information security', '2024-01-01', '2024-12-31', '2024-07-20', 'Healthcare Security Group', 'Security Audit Partners', 'PLANNED', 'Assessment not yet started', 'Schedule comprehensive security review', 'MEDIUM', 0.0);

-- Insert intellectual property
INSERT INTO legal.intellectual_property (ip_id, ip_name, ip_type, ip_category, description, filing_date, registration_date, registration_number, jurisdiction, status, owner, inventor_creator, renewal_date, expiration_date, estimated_value) VALUES
(1, 'Advanced AI Algorithm for Data Processing', 'Patent', 'Technology', 'Machine learning algorithm for real-time data analysis', '2023-03-15', '2024-01-20', 'US-12345678', 'United States', 'REGISTERED', 'TechCorp Inc.', 'Dr. John Smith', '2028-01-20', '2044-01-20', 5000000.00),
(2, 'TechCorp Logo', 'Trademark', 'Branding', 'Company logo and brand identity', '2022-06-10', '2023-02-15', 'TM-87654321', 'United States', 'REGISTERED', 'TechCorp Inc.', 'Design Team', '2033-02-15', '2033-02-15', 100000.00),
(3, 'Cloud Security Software', 'Patent', 'Technology', 'Cybersecurity software for cloud environments', '2023-09-20', '2024-07-10', 'US-23456789', 'United States', 'REGISTERED', 'TechCorp Inc.', 'Sarah Johnson', '2029-07-10', '2045-07-10', 3000000.00),
(4, 'Customer Management System', 'Copyright', 'Software', 'Proprietary customer relationship management software', '2023-12-01', '2023-12-01', 'CO-34567890', 'United States', 'REGISTERED', 'TechCorp Inc.', 'Development Team', '2068-12-01', '2068-12-01', 2000000.00),
(5, 'Data Analytics Platform', 'Trade Secret', 'Technology', 'Confidential data analytics methodology', '2022-01-01', NULL, NULL, 'United States', 'ACTIVE', 'TechCorp Inc.', 'Analytics Team', NULL, NULL, 10000000.00);

-- Insert legal expenses
INSERT INTO legal.legal_expenses (expense_id, case_id, contract_id, expense_date, expense_category, expense_type, description, amount, vendor_name, invoice_number, payment_status, approved_by) VALUES
(1, 1, NULL, '2024-03-15', 'Legal Services', 'Attorney Fees', 'Initial case review and strategy', 5000.00, 'Law Firm Partners', 'INV-001', 'PAID', 'Sarah Johnson'),
(2, 2, NULL, '2024-05-20', 'Expert Witness', 'Expert Fees', 'Patent expert witness consultation', 3000.00, 'Patent Experts Inc.', 'INV-002', 'PAID', 'David Wilson'),
(3, NULL, 1, '2024-02-10', 'Contract Review', 'Legal Services', 'Contract negotiation and review', 2500.00, 'Contract Law Associates', 'INV-003', 'PAID', 'Sarah Johnson'),
(4, 3, NULL, '2024-07-15', 'Mediation', 'Mediation Services', 'Settlement mediation session', 2000.00, 'Mediation Services', 'INV-004', 'PENDING', NULL),
(5, 4, NULL, '2024-09-20', 'Compliance', 'Consulting', 'Regulatory compliance assessment', 4000.00, 'Compliance Consultants', 'INV-005', 'PAID', 'Sarah Johnson');

-- Insert legal calendar
INSERT INTO legal.legal_calendar (calendar_id, case_id, contract_id, event_type, event_title, event_date, event_time, event_location, event_description, priority_level, assigned_to, reminder_days) VALUES
(1, 1, NULL, 'Court Hearing', 'Motion Hearing - Employment Case', '2024-12-15', '09:00:00', 'Superior Court, San Francisco', 'Hearing on motion to dismiss', 'HIGH', 'Sarah Johnson', 7),
(2, 2, NULL, 'Discovery Deadline', 'Patent Case Discovery Cutoff', '2024-12-20', NULL, 'Federal Court', 'Deadline for completing discovery', 'HIGH', 'David Wilson', 14),
(3, NULL, 2, 'Contract Review', 'Lease Renewal Review', '2024-12-10', '14:00:00', 'Conference Room A', 'Review lease renewal terms', 'MEDIUM', 'Lisa Anderson', 3),
(4, 3, NULL, 'Settlement Conference', 'Settlement Discussion', '2024-12-05', '10:00:00', 'Mediation Center', 'Final settlement negotiations', 'HIGH', 'Emily Davis', 2),
(5, 4, NULL, 'Compliance Deadline', 'GDPR Assessment Due', '2024-12-31', NULL, 'Office', 'Annual GDPR compliance assessment', 'HIGH', 'Sarah Johnson', 30);

-- =====================================================
-- VIEWS
-- =====================================================

-- Contract Summary View
CREATE OR REPLACE VIEW legal.contract_summary AS
SELECT 
    c.contract_id,
    c.contract_number,
    c.contract_title,
    c.contract_type,
    c.contract_status,
    c.approval_status,
    c.contract_value,
    c.currency,
    c.start_date,
    c.end_date,
    c.risk_level,
    c.contract_manager,
    c.department,
    COUNT(ca.amendment_id) as amendment_count,
    CASE 
        WHEN c.end_date < CURRENT_DATE() THEN 'EXPIRED'
        WHEN c.end_date <= DATEADD('month', 3, CURRENT_DATE()) THEN 'EXPIRING_SOON'
        ELSE 'ACTIVE'
    END as expiration_status
FROM legal.contracts c
LEFT JOIN legal.contract_amendments ca ON c.contract_id = ca.contract_id
GROUP BY c.contract_id, c.contract_number, c.contract_title, c.contract_type, c.contract_status, 
         c.approval_status, c.contract_value, c.currency, c.start_date, c.end_date, c.risk_level, 
         c.contract_manager, c.department;

-- Case Summary View
CREATE OR REPLACE VIEW legal.case_summary AS
SELECT 
    lc.case_id,
    lc.case_number,
    lc.case_title,
    lc.case_type,
    lc.case_status,
    lc.priority_level,
    lc.assigned_attorney,
    lc.filing_date,
    lc.potential_liability,
    lc.settlement_amount,
    lc.judgment_amount,
    lc.case_outcome,
    COUNT(cd.document_id) as document_count,
    SUM(le.amount) as total_expenses,
    DATEDIFF('day', lc.filing_date, CURRENT_DATE()) as days_open
FROM legal.legal_cases lc
LEFT JOIN legal.case_documents cd ON lc.case_id = cd.case_id
LEFT JOIN legal.legal_expenses le ON lc.case_id = le.case_id
GROUP BY lc.case_id, lc.case_number, lc.case_title, lc.case_type, lc.case_status, 
         lc.priority_level, lc.assigned_attorney, lc.filing_date, lc.potential_liability, 
         lc.settlement_amount, lc.judgment_amount, lc.case_outcome;

-- Compliance Dashboard View
CREATE OR REPLACE VIEW legal.compliance_dashboard AS
SELECT 
    r.regulation_id,
    r.regulation_name,
    r.regulation_code,
    r.regulatory_body,
    r.compliance_status,
    r.compliance_deadline,
    r.responsible_department,
    r.compliance_officer,
    ca.audit_name,
    ca.audit_status,
    ca.compliance_score,
    ca.risk_level,
    DATEDIFF('day', CURRENT_DATE(), r.compliance_deadline) as days_to_deadline
FROM legal.regulations r
LEFT JOIN legal.compliance_audits ca ON r.regulation_id = ca.audit_id
ORDER BY r.compliance_deadline;

-- Legal Expenses Summary View
CREATE OR REPLACE VIEW legal.legal_expenses_summary AS
SELECT 
    le.expense_id,
    COALESCE(lc.case_title, c.contract_title) as matter_title,
    le.expense_category,
    le.expense_type,
    le.amount,
    le.currency,
    le.expense_date,
    le.vendor_name,
    le.payment_status,
    le.approved_by,
    CASE 
        WHEN lc.case_id IS NOT NULL THEN 'CASE'
        WHEN c.contract_id IS NOT NULL THEN 'CONTRACT'
        ELSE 'OTHER'
    END as expense_type_category
FROM legal.legal_expenses le
LEFT JOIN legal.legal_cases lc ON le.case_id = lc.case_id
LEFT JOIN legal.contracts c ON le.contract_id = c.contract_id
ORDER BY le.expense_date DESC;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Get contracts by risk level
CREATE OR REPLACE PROCEDURE legal.get_contracts_by_risk(risk_level_param VARCHAR)
RETURNS TABLE (
    contract_id INT,
    contract_number VARCHAR,
    contract_title VARCHAR,
    contract_type VARCHAR,
    contract_value DECIMAL(15,2),
    risk_level VARCHAR,
    expiration_status VARCHAR
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            c.contract_id,
            c.contract_number,
            c.contract_title,
            c.contract_type,
            c.contract_value,
            c.risk_level,
            CASE 
                WHEN c.end_date < CURRENT_DATE() THEN 'EXPIRED'
                WHEN c.end_date <= DATEADD('month', 3, CURRENT_DATE()) THEN 'EXPIRING_SOON'
                ELSE 'ACTIVE'
            END as expiration_status
        FROM legal.contracts c
        WHERE c.risk_level = risk_level_param
        ORDER BY c.contract_value DESC
    );
END;
$$;

-- Get high-value cases
CREATE OR REPLACE PROCEDURE legal.get_high_value_cases(min_liability DECIMAL)
RETURNS TABLE (
    case_id INT,
    case_number VARCHAR,
    case_title VARCHAR,
    case_type VARCHAR,
    case_status VARCHAR,
    potential_liability DECIMAL(15,2),
    total_expenses DECIMAL(10,2),
    assigned_attorney VARCHAR
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            lc.case_id,
            lc.case_number,
            lc.case_title,
            lc.case_type,
            lc.case_status,
            lc.potential_liability,
            COALESCE(SUM(le.amount), 0) as total_expenses,
            lc.assigned_attorney
        FROM legal.legal_cases lc
        LEFT JOIN legal.legal_expenses le ON lc.case_id = le.case_id
        WHERE lc.potential_liability >= min_liability
        GROUP BY lc.case_id, lc.case_number, lc.case_title, lc.case_type, 
                 lc.case_status, lc.potential_liability, lc.assigned_attorney
        ORDER BY lc.potential_liability DESC
    );
END;
$$;

-- =====================================================
-- TAGS FOR DATA GOVERNANCE
-- =====================================================

-- Create tags
CREATE OR REPLACE TAG legal.CONFIDENTIAL_DATA_TAG;
CREATE OR REPLACE TAG legal.PRIVILEGED_DATA_TAG;
CREATE OR REPLACE TAG legal.PII_TAG;
CREATE OR REPLACE TAG legal.FINANCIAL_DATA_TAG;

-- Apply tags to sensitive columns
ALTER TABLE legal.contracts MODIFY COLUMN contract_terms SET TAG legal.CONFIDENTIAL_DATA_TAG = 'CONTRACT_TERMS';
ALTER TABLE legal.contracts MODIFY COLUMN contract_value SET TAG legal.FINANCIAL_DATA_TAG = 'CONTRACT_VALUE';
ALTER TABLE legal.legal_cases MODIFY COLUMN case_description SET TAG legal.CONFIDENTIAL_DATA_TAG = 'CASE_DESCRIPTION';
ALTER TABLE legal.legal_cases MODIFY COLUMN potential_liability SET TAG legal.FINANCIAL_DATA_TAG = 'POTENTIAL_LIABILITY';
ALTER TABLE legal.case_documents MODIFY COLUMN attorney_work_product SET TAG legal.PRIVILEGED_DATA_TAG = 'ATTORNEY_WORK_PRODUCT';
ALTER TABLE legal.case_documents MODIFY COLUMN privileged_communication SET TAG legal.PRIVILEGED_DATA_TAG = 'PRIVILEGED_COMMUNICATION';

-- =====================================================
-- COMMENTS
-- =====================================================

-- Table comments
COMMENT ON TABLE legal.contracts IS 'Contract management and lifecycle tracking';
COMMENT ON TABLE legal.contract_amendments IS 'Contract amendments and modifications';
COMMENT ON TABLE legal.legal_cases IS 'Legal case management and tracking';
COMMENT ON TABLE legal.case_documents IS 'Legal case document management';
COMMENT ON TABLE legal.regulations IS 'Regulatory compliance tracking';
COMMENT ON TABLE legal.compliance_audits IS 'Compliance audit management';
COMMENT ON TABLE legal.intellectual_property IS 'Intellectual property portfolio management';
COMMENT ON TABLE legal.legal_expenses IS 'Legal expense tracking and management';
COMMENT ON TABLE legal.legal_calendar IS 'Legal calendar and deadline management';

-- Column comments
COMMENT ON COLUMN legal.contracts.contract_status IS 'Contract status: DRAFT, ACTIVE, EXPIRED, TERMINATED';
COMMENT ON COLUMN legal.contracts.approval_status IS 'Approval status: PENDING, APPROVED, REJECTED';
COMMENT ON COLUMN legal.contracts.risk_level IS 'Risk level: LOW, MEDIUM, HIGH';
COMMENT ON COLUMN legal.legal_cases.case_status IS 'Case status: OPEN, SETTLEMENT, CLOSED, APPEALED';
COMMENT ON COLUMN legal.legal_cases.priority_level IS 'Priority level: LOW, MEDIUM, HIGH, CRITICAL';
COMMENT ON COLUMN legal.regulations.compliance_status IS 'Compliance status: PENDING, COMPLIANT, NON_COMPLIANT';
COMMENT ON COLUMN legal.compliance_audits.audit_status IS 'Audit status: PLANNED, IN_PROGRESS, COMPLETED';

-- =====================================================
-- CLEANUP (UNCOMMENT TO RESET)
-- =====================================================

/*
-- Drop all objects
DROP DATABASE IF EXISTS LEGALDB CASCADE;
*/ 