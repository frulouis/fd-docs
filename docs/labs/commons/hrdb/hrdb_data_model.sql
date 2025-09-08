-- =====================================================
-- HRDB - Human Resources Database
-- Comprehensive HR data model for Snowflake demonstrations
-- Version: 1.0.0
-- Last Updated: December 2024
-- =====================================================

-- Create database and schema
CREATE OR REPLACE DATABASE HRDB;
USE DATABASE HRDB;
CREATE OR REPLACE SCHEMA hr;

-- =====================================================
-- TABLES
-- =====================================================

-- Departments table
CREATE OR REPLACE TABLE hr.departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    manager_id INT,
    location VARCHAR(100),
    budget DECIMAL(12,2),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Employees table
CREATE OR REPLACE TABLE hr.employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100),
    department_id INT REFERENCES hr.departments(department_id),
    manager_id INT REFERENCES hr.employees(employee_id),
    salary DECIMAL(10,2),
    hourly_rate DECIMAL(8,2),
    employment_status VARCHAR(20) DEFAULT 'ACTIVE',
    location VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    country VARCHAR(50),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Payroll table
CREATE OR REPLACE TABLE hr.payroll (
    payroll_id INT PRIMARY KEY,
    employee_id INT REFERENCES hr.employees(employee_id),
    pay_period_start DATE,
    pay_period_end DATE,
    gross_pay DECIMAL(10,2),
    net_pay DECIMAL(10,2),
    federal_tax DECIMAL(10,2),
    state_tax DECIMAL(10,2),
    social_security DECIMAL(10,2),
    medicare DECIMAL(10,2),
    benefits_deduction DECIMAL(10,2),
    other_deductions DECIMAL(10,2),
    hours_worked DECIMAL(5,2),
    overtime_hours DECIMAL(5,2),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Benefits table
CREATE OR REPLACE TABLE hr.benefits (
    benefit_id INT PRIMARY KEY,
    employee_id INT REFERENCES hr.employees(employee_id),
    benefit_type VARCHAR(50),
    plan_name VARCHAR(100),
    coverage_start_date DATE,
    coverage_end_date DATE,
    monthly_premium DECIMAL(8,2),
    employer_contribution DECIMAL(8,2),
    employee_contribution DECIMAL(8,2),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Performance Reviews table
CREATE OR REPLACE TABLE hr.performance_reviews (
    review_id INT PRIMARY KEY,
    employee_id INT REFERENCES hr.employees(employee_id),
    reviewer_id INT REFERENCES hr.employees(employee_id),
    review_date DATE,
    review_period_start DATE,
    review_period_end DATE,
    overall_rating DECIMAL(3,1),
    communication_rating DECIMAL(3,1),
    teamwork_rating DECIMAL(3,1),
    leadership_rating DECIMAL(3,1),
    technical_skills_rating DECIMAL(3,1),
    comments TEXT,
    goals TEXT,
    next_review_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Time Off table
CREATE OR REPLACE TABLE hr.time_off (
    time_off_id INT PRIMARY KEY,
    employee_id INT REFERENCES hr.employees(employee_id),
    request_date DATE,
    start_date DATE,
    end_date DATE,
    days_requested DECIMAL(3,1),
    leave_type VARCHAR(50),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'PENDING',
    approved_by INT REFERENCES hr.employees(employee_id),
    approval_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Skills table
CREATE OR REPLACE TABLE hr.skills (
    skill_id INT PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE,
    skill_category VARCHAR(50),
    description TEXT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Employee Skills table (junction table)
CREATE OR REPLACE TABLE hr.employee_skills (
    employee_skill_id INT PRIMARY KEY,
    employee_id INT REFERENCES hr.employees(employee_id),
    skill_id INT REFERENCES hr.skills(skill_id),
    proficiency_level VARCHAR(20),
    certification_name VARCHAR(100),
    certification_date DATE,
    expiration_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Insert departments
INSERT INTO hr.departments (department_id, department_name, location, budget) VALUES
(1, 'Engineering', 'San Francisco', 5000000.00),
(2, 'Sales', 'New York', 3000000.00),
(3, 'Marketing', 'Los Angeles', 2000000.00),
(4, 'Human Resources', 'Chicago', 800000.00),
(5, 'Finance', 'Boston', 1200000.00),
(6, 'Operations', 'Seattle', 1500000.00),
(7, 'Customer Support', 'Austin', 1000000.00),
(8, 'Product Management', 'Denver', 1800000.00);

-- Insert employees
INSERT INTO hr.employees (employee_id, first_name, last_name, email, phone, hire_date, job_title, department_id, salary, employment_status, location) VALUES
(1, 'John', 'Smith', 'john.smith@company.com', '555-0101', '2020-01-15', 'Senior Software Engineer', 1, 120000.00, 'ACTIVE', 'San Francisco'),
(2, 'Sarah', 'Johnson', 'sarah.johnson@company.com', '555-0102', '2019-03-20', 'Sales Director', 2, 95000.00, 'ACTIVE', 'New York'),
(3, 'Michael', 'Brown', 'michael.brown@company.com', '555-0103', '2021-06-10', 'Marketing Manager', 3, 85000.00, 'ACTIVE', 'Los Angeles'),
(4, 'Emily', 'Davis', 'emily.davis@company.com', '555-0104', '2020-11-05', 'HR Manager', 4, 75000.00, 'ACTIVE', 'Chicago'),
(5, 'David', 'Wilson', 'david.wilson@company.com', '555-0105', '2018-09-12', 'Financial Analyst', 5, 70000.00, 'ACTIVE', 'Boston'),
(6, 'Lisa', 'Anderson', 'lisa.anderson@company.com', '555-0106', '2021-02-28', 'Operations Manager', 6, 80000.00, 'ACTIVE', 'Seattle'),
(7, 'Robert', 'Taylor', 'robert.taylor@company.com', '555-0107', '2020-07-15', 'Support Specialist', 7, 55000.00, 'ACTIVE', 'Austin'),
(8, 'Jennifer', 'Martinez', 'jennifer.martinez@company.com', '555-0108', '2019-12-01', 'Product Manager', 8, 90000.00, 'ACTIVE', 'Denver'),
(9, 'Christopher', 'Garcia', 'christopher.garcia@company.com', '555-0109', '2021-04-18', 'Software Engineer', 1, 95000.00, 'ACTIVE', 'San Francisco'),
(10, 'Amanda', 'Rodriguez', 'amanda.rodriguez@company.com', '555-0110', '2020-08-22', 'Sales Representative', 2, 65000.00, 'ACTIVE', 'New York'),
(11, 'James', 'Miller', 'james.miller@company.com', '555-0111', '2021-01-10', 'Marketing Specialist', 3, 60000.00, 'ACTIVE', 'Los Angeles'),
(12, 'Jessica', 'Moore', 'jessica.moore@company.com', '555-0112', '2019-05-14', 'HR Specialist', 4, 55000.00, 'ACTIVE', 'Chicago'),
(13, 'Daniel', 'Jackson', 'daniel.jackson@company.com', '555-0113', '2020-10-30', 'Accountant', 5, 65000.00, 'ACTIVE', 'Boston'),
(14, 'Ashley', 'Martin', 'ashley.martin@company.com', '555-0114', '2021-03-25', 'Operations Analyst', 6, 60000.00, 'ACTIVE', 'Seattle'),
(15, 'Matthew', 'Lee', 'matthew.lee@company.com', '555-0115', '2020-12-08', 'Support Manager', 7, 70000.00, 'ACTIVE', 'Austin');

-- Update department managers
UPDATE hr.departments SET manager_id = 1 WHERE department_id = 1;
UPDATE hr.departments SET manager_id = 2 WHERE department_id = 2;
UPDATE hr.departments SET manager_id = 3 WHERE department_id = 3;
UPDATE hr.departments SET manager_id = 4 WHERE department_id = 4;
UPDATE hr.departments SET manager_id = 5 WHERE department_id = 5;
UPDATE hr.departments SET manager_id = 6 WHERE department_id = 6;
UPDATE hr.departments SET manager_id = 14 WHERE department_id = 7;
UPDATE hr.departments SET manager_id = 8 WHERE department_id = 8;

-- Update employee managers
UPDATE hr.employees SET manager_id = 1 WHERE employee_id IN (9);
UPDATE hr.employees SET manager_id = 2 WHERE employee_id IN (10);
UPDATE hr.employees SET manager_id = 3 WHERE employee_id IN (11);
UPDATE hr.employees SET manager_id = 4 WHERE employee_id IN (12);
UPDATE hr.employees SET manager_id = 5 WHERE employee_id IN (13);
UPDATE hr.employees SET manager_id = 6 WHERE employee_id IN (14);
UPDATE hr.employees SET manager_id = 14 WHERE employee_id IN (7);
UPDATE hr.employees SET manager_id = 8 WHERE employee_id IN ();

-- Insert payroll data
INSERT INTO hr.payroll (payroll_id, employee_id, pay_period_start, pay_period_end, gross_pay, net_pay, federal_tax, state_tax, social_security, medicare, benefits_deduction, hours_worked) VALUES
(1, 1, '2024-01-01', '2024-01-15', 5000.00, 3750.00, 750.00, 300.00, 310.00, 72.50, 167.50, 80.00),
(2, 2, '2024-01-01', '2024-01-15', 3958.33, 2968.75, 593.75, 237.50, 245.42, 57.40, 142.50, 80.00),
(3, 3, '2024-01-01', '2024-01-15', 3541.67, 2656.25, 531.25, 212.50, 219.58, 51.35, 127.50, 80.00),
(4, 4, '2024-01-01', '2024-01-15', 3125.00, 2343.75, 468.75, 187.50, 193.75, 45.31, 112.50, 80.00),
(5, 5, '2024-01-01', '2024-01-15', 2916.67, 2187.50, 437.50, 175.00, 180.83, 42.29, 105.00, 80.00);

-- Insert benefits data
INSERT INTO hr.benefits (benefit_id, employee_id, benefit_type, plan_name, coverage_start_date, monthly_premium, employer_contribution, employee_contribution) VALUES
(1, 1, 'Health Insurance', 'Premium Health Plan', '2024-01-01', 500.00, 400.00, 100.00),
(2, 1, 'Dental Insurance', 'Standard Dental', '2024-01-01', 50.00, 40.00, 10.00),
(3, 1, 'Vision Insurance', 'Basic Vision', '2024-01-01', 25.00, 20.00, 5.00),
(4, 2, 'Health Insurance', 'Premium Health Plan', '2024-01-01', 500.00, 400.00, 100.00),
(5, 2, 'Dental Insurance', 'Standard Dental', '2024-01-01', 50.00, 40.00, 10.00);

-- Insert performance reviews
INSERT INTO hr.performance_reviews (review_id, employee_id, reviewer_id, review_date, review_period_start, review_period_end, overall_rating, communication_rating, teamwork_rating, leadership_rating, technical_skills_rating, comments, goals) VALUES
(1, 1, 4, '2024-01-15', '2023-07-01', '2023-12-31', 4.5, 4.0, 4.5, 4.0, 5.0, 'Excellent technical skills and strong team collaboration.', 'Lead a new project initiative and mentor junior developers.'),
(2, 2, 4, '2024-01-15', '2023-07-01', '2023-12-31', 4.2, 4.5, 4.0, 4.5, 3.5, 'Strong leadership and communication skills.', 'Increase sales team performance by 15% and implement new sales processes.'),
(3, 3, 4, '2024-01-15', '2023-07-01', '2023-12-31', 4.0, 4.0, 4.0, 4.0, 4.0, 'Consistent performance across all areas.', 'Launch two new marketing campaigns and improve ROI by 20%.'),
(4, 4, 2, '2024-01-15', '2023-07-01', '2023-12-31', 4.3, 4.5, 4.5, 4.0, 4.0, 'Excellent HR management and employee relations.', 'Implement new employee engagement program and reduce turnover by 10%.'),
(5, 5, 4, '2024-01-15', '2023-07-01', '2023-12-31', 4.1, 4.0, 4.0, 3.5, 4.5, 'Strong analytical skills and attention to detail.', 'Streamline financial reporting processes and improve accuracy.');

-- Insert time off requests
INSERT INTO hr.time_off (time_off_id, employee_id, request_date, start_date, end_date, days_requested, leave_type, reason, status, approved_by) VALUES
(1, 1, '2024-01-05', '2024-02-15', '2024-02-19', 5.0, 'Vacation', 'Family vacation', 'APPROVED', 4),
(2, 2, '2024-01-10', '2024-03-01', '2024-03-05', 5.0, 'Vacation', 'Personal time', 'PENDING', NULL),
(3, 3, '2024-01-12', '2024-01-20', '2024-01-20', 1.0, 'Sick Leave', 'Medical appointment', 'APPROVED', 4),
(4, 4, '2024-01-15', '2024-04-10', '2024-04-12', 3.0, 'Vacation', 'Conference attendance', 'APPROVED', 2),
(5, 5, '2024-01-18', '2024-02-01', '2024-02-01', 1.0, 'Personal Leave', 'Personal matter', 'PENDING', NULL);

-- Insert skills
INSERT INTO hr.skills (skill_id, skill_name, skill_category, description) VALUES
(1, 'Python', 'Programming', 'Python programming language'),
(2, 'JavaScript', 'Programming', 'JavaScript programming language'),
(3, 'SQL', 'Database', 'Structured Query Language'),
(4, 'Sales Management', 'Sales', 'Sales team management and strategy'),
(5, 'Digital Marketing', 'Marketing', 'Digital marketing strategies and tools'),
(6, 'Employee Relations', 'HR', 'Human resources and employee relations'),
(7, 'Financial Analysis', 'Finance', 'Financial analysis and reporting'),
(8, 'Project Management', 'Management', 'Project planning and execution'),
(9, 'Customer Service', 'Support', 'Customer service and support'),
(10, 'Data Analysis', 'Analytics', 'Data analysis and visualization');

-- Insert employee skills
INSERT INTO hr.employee_skills (employee_skill_id, employee_id, skill_id, proficiency_level, certification_name, certification_date) VALUES
(1, 1, 1, 'EXPERT', 'Python Developer Certification', '2023-06-15'),
(2, 1, 2, 'ADVANCED', 'JavaScript Developer Certification', '2023-08-20'),
(3, 1, 3, 'EXPERT', 'SQL Master Certification', '2023-05-10'),
(4, 2, 4, 'EXPERT', 'Sales Management Certification', '2023-03-12'),
(5, 3, 5, 'ADVANCED', 'Digital Marketing Certification', '2023-07-25'),
(6, 4, 6, 'EXPERT', 'HR Professional Certification', '2023-04-18'),
(7, 5, 7, 'ADVANCED', 'Financial Analyst Certification', '2023-09-30'),
(8, 6, 8, 'ADVANCED', 'PMP Certification', '2023-11-05'),
(9, 7, 9, 'INTERMEDIATE', 'Customer Service Certification', '2023-10-15'),
(10, 8, 8, 'EXPERT', 'Product Management Certification', '2023-12-01);

-- =====================================================
-- VIEWS
-- =====================================================

-- Employee Summary View
CREATE OR REPLACE VIEW hr.employee_summary AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name as employee_name,
    e.email,
    e.job_title,
    d.department_name,
    e.hire_date,
    e.salary,
    e.employment_status,
    e.location,
    m.first_name || ' ' || m.last_name as manager_name,
    COUNT(es.skill_id) as skill_count,
    AVG(pr.overall_rating) as avg_performance_rating
FROM hr.employees e
LEFT JOIN hr.departments d ON e.department_id = d.department_id
LEFT JOIN hr.employees m ON e.manager_id = m.employee_id
LEFT JOIN hr.employee_skills es ON e.employee_id = es.employee_id
LEFT JOIN hr.performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.email, e.job_title, d.department_name, 
         e.hire_date, e.salary, e.employment_status, e.location, m.first_name, m.last_name;

-- Department Performance View
CREATE OR REPLACE VIEW hr.department_performance AS
SELECT 
    d.department_id,
    d.department_name,
    d.location,
    d.budget,
    COUNT(e.employee_id) as employee_count,
    AVG(e.salary) as avg_salary,
    AVG(pr.overall_rating) as avg_performance_rating,
    SUM(p.gross_pay) as total_payroll,
    COUNT(to.time_off_id) as pending_time_off_requests
FROM hr.departments d
LEFT JOIN hr.employees e ON d.department_id = e.department_id
LEFT JOIN hr.performance_reviews pr ON e.employee_id = pr.employee_id
LEFT JOIN hr.payroll p ON e.employee_id = p.employee_id
LEFT JOIN hr.time_off to ON e.employee_id = to.employee_id AND to.status = 'PENDING'
GROUP BY d.department_id, d.department_name, d.location, d.budget;

-- Payroll Analysis View
CREATE OR REPLACE VIEW hr.payroll_analysis AS
SELECT 
    p.payroll_id,
    e.first_name || ' ' || e.last_name as employee_name,
    d.department_name,
    p.pay_period_start,
    p.pay_period_end,
    p.gross_pay,
    p.net_pay,
    p.federal_tax + p.state_tax + p.social_security + p.medicare as total_taxes,
    p.benefits_deduction,
    p.hours_worked,
    p.overtime_hours,
    (p.gross_pay / p.hours_worked) as hourly_rate_calculated
FROM hr.payroll p
JOIN hr.employees e ON p.employee_id = e.employee_id
JOIN hr.departments d ON e.department_id = d.department_id;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Get employees by department
CREATE OR REPLACE PROCEDURE hr.get_employees_by_department(department_name VARCHAR)
RETURNS TABLE (
    employee_id INT,
    employee_name VARCHAR,
    job_title VARCHAR,
    hire_date DATE,
    salary DECIMAL(10,2)
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            e.employee_id,
            e.first_name || ' ' || e.last_name as employee_name,
            e.job_title,
            e.hire_date,
            e.salary
        FROM hr.employees e
        JOIN hr.departments d ON e.department_id = d.department_id
        WHERE d.department_name = department_name
        ORDER BY e.salary DESC
    );
END;
$$;

-- Get high performers
CREATE OR REPLACE PROCEDURE hr.get_high_performers(min_rating DECIMAL)
RETURNS TABLE (
    employee_id INT,
    employee_name VARCHAR,
    department_name VARCHAR,
    overall_rating DECIMAL(3,1),
    review_date DATE
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            e.employee_id,
            e.first_name || ' ' || e.last_name as employee_name,
            d.department_name,
            pr.overall_rating,
            pr.review_date
        FROM hr.employees e
        JOIN hr.departments d ON e.department_id = d.department_id
        JOIN hr.performance_reviews pr ON e.employee_id = pr.employee_id
        WHERE pr.overall_rating >= min_rating
        ORDER BY pr.overall_rating DESC, pr.review_date DESC
    );
END;
$$;

-- =====================================================
-- TAGS FOR DATA GOVERNANCE
-- =====================================================

-- Create tags
CREATE OR REPLACE TAG hr.EMAIL_TAG;
CREATE OR REPLACE TAG hr.PHONE_TAG;
CREATE OR REPLACE TAG hr.SSN_TAG;
CREATE OR REPLACE TAG hr.SALARY_TAG;
CREATE OR REPLACE TAG hr.PII_TAG;

-- Apply tags to sensitive columns
ALTER TABLE hr.employees MODIFY COLUMN email SET TAG hr.EMAIL_TAG = 'EMAIL';
ALTER TABLE hr.employees MODIFY COLUMN phone SET TAG hr.PHONE_TAG = 'PHONE';
ALTER TABLE hr.employees MODIFY COLUMN salary SET TAG hr.SALARY_TAG = 'SALARY';
ALTER TABLE hr.employees MODIFY COLUMN first_name SET TAG hr.PII_TAG = 'FIRST_NAME';
ALTER TABLE hr.employees MODIFY COLUMN last_name SET TAG hr.PII_TAG = 'LAST_NAME';

-- =====================================================
-- COMMENTS
-- =====================================================

-- Table comments
COMMENT ON TABLE hr.departments IS 'Organizational departments and their details';
COMMENT ON TABLE hr.employees IS 'Employee master data including personal and employment information';
COMMENT ON TABLE hr.payroll IS 'Payroll records for each pay period';
COMMENT ON TABLE hr.benefits IS 'Employee benefits enrollment and plan details';
COMMENT ON TABLE hr.performance_reviews IS 'Employee performance review records';
COMMENT ON TABLE hr.time_off IS 'Employee time off requests and approvals';
COMMENT ON TABLE hr.skills IS 'Master list of skills and competencies';
COMMENT ON TABLE hr.employee_skills IS 'Employee skill associations and certifications';

-- Column comments
COMMENT ON COLUMN hr.employees.employment_status IS 'Current employment status: ACTIVE, INACTIVE, TERMINATED';
COMMENT ON COLUMN hr.payroll.gross_pay IS 'Total pay before deductions';
COMMENT ON COLUMN hr.payroll.net_pay IS 'Take-home pay after all deductions';
COMMENT ON COLUMN hr.performance_reviews.overall_rating IS 'Overall performance rating (1.0-5.0 scale)';
COMMENT ON COLUMN hr.time_off.status IS 'Request status: PENDING, APPROVED, REJECTED';

-- =====================================================
-- CLEANUP (UNCOMMENT TO RESET)
-- =====================================================

/*
-- Drop all objects
DROP DATABASE IF EXISTS HRDB CASCADE;
*/ 