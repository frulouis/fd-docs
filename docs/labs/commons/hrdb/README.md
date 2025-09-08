# HRDB - Human Resources Database

## Overview

The HRDB data model is a comprehensive human resources management system designed for Snowflake demonstrations. It includes complete employee lifecycle management, payroll processing, benefits administration, performance management, and organizational structure tracking.

## Features

### Core HR Functions
- **Employee Management**: Complete employee records with personal and employment information
- **Organizational Structure**: Department hierarchy and reporting relationships
- **Payroll Processing**: Detailed payroll records with tax and benefit deductions
- **Benefits Administration**: Health, dental, vision, and other benefit plans
- **Performance Management**: Performance reviews, ratings, and goal tracking
- **Time Off Management**: Vacation, sick leave, and other time off requests
- **Skills Management**: Employee skills, certifications, and competency tracking

### Advanced Features
- **Hierarchical Data**: Manager-employee relationships and organizational charts
- **Time Series Data**: Historical payroll, performance, and employment data
- **PII Protection**: Comprehensive data governance with sensitive data tagging
- **Geographic Data**: Employee locations for workforce analytics
- **Views**: Pre-built analytical views for HR reporting
- **Stored Procedures**: Business logic for employee analysis and reporting
- **Sample Data**: Realistic HR data for testing and demonstration

## Database Structure

```
HRDB
└── hr (schema)
    ├── departments
    ├── employees
    ├── payroll
    ├── benefits
    ├── performance_reviews
    ├── time_off
    ├── skills
    ├── employee_skills
    ├── employee_summary (view)
    ├── department_performance (view)
    ├── payroll_analysis (view)
    ├── get_employees_by_department() (stored procedure)
    └── get_high_performers() (stored procedure)
```

## Tables

### departments
- **department_id** (INT, Primary Key): Unique department identifier
- **department_name** (VARCHAR(100)): Department name
- **manager_id** (INT, Foreign Key): Reference to employees table
- **location** (VARCHAR(100)): Department location
- **budget** (DECIMAL(12,2)): Department budget
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### employees
- **employee_id** (INT, Primary Key): Unique employee identifier
- **first_name** (VARCHAR(50)): Employee's first name
- **last_name** (VARCHAR(50)): Employee's last name
- **email** (VARCHAR(100)): Employee email address
- **phone** (VARCHAR(20)): Employee phone number
- **hire_date** (DATE): Employee hire date
- **job_title** (VARCHAR(100)): Employee job title
- **department_id** (INT, Foreign Key): Reference to departments table
- **manager_id** (INT, Foreign Key): Self-reference to employees table
- **salary** (DECIMAL(10,2)): Annual salary
- **hourly_rate** (DECIMAL(8,2)): Hourly rate for hourly employees
- **employment_status** (VARCHAR(20)): Current employment status
- **location** (VARCHAR(100)): Employee work location
- **address** (VARCHAR(200)): Employee address
- **city** (VARCHAR(50)): Employee city
- **state** (VARCHAR(2)): Employee state
- **zip_code** (VARCHAR(10)): Employee zip code
- **country** (VARCHAR(50)): Employee country

### payroll
- **payroll_id** (INT, Primary Key): Unique payroll record identifier
- **employee_id** (INT, Foreign Key): Reference to employees table
- **pay_period_start** (DATE): Pay period start date
- **pay_period_end** (DATE): Pay period end date
- **gross_pay** (DECIMAL(10,2)): Gross pay amount
- **net_pay** (DECIMAL(10,2)): Net pay after deductions
- **federal_tax** (DECIMAL(10,2)): Federal tax withholding
- **state_tax** (DECIMAL(10,2)): State tax withholding
- **social_security** (DECIMAL(10,2)): Social security tax
- **medicare** (DECIMAL(10,2)): Medicare tax
- **benefits_deduction** (DECIMAL(10,2)): Benefits deduction
- **other_deductions** (DECIMAL(10,2)): Other deductions
- **hours_worked** (DECIMAL(5,2)): Hours worked in pay period
- **overtime_hours** (DECIMAL(5,2)): Overtime hours worked

### benefits
- **benefit_id** (INT, Primary Key): Unique benefit record identifier
- **employee_id** (INT, Foreign Key): Reference to employees table
- **benefit_type** (VARCHAR(50)): Type of benefit
- **plan_name** (VARCHAR(100)): Benefit plan name
- **coverage_start_date** (DATE): Coverage start date
- **coverage_end_date** (DATE): Coverage end date
- **monthly_premium** (DECIMAL(8,2)): Monthly premium amount
- **employer_contribution** (DECIMAL(8,2)): Employer contribution
- **employee_contribution** (DECIMAL(8,2)): Employee contribution
- **status** (VARCHAR(20)): Benefit status

### performance_reviews
- **review_id** (INT, Primary Key): Unique review identifier
- **employee_id** (INT, Foreign Key): Reference to employees table
- **reviewer_id** (INT, Foreign Key): Reference to employees table
- **review_date** (DATE): Review date
- **review_period_start** (DATE): Review period start
- **review_period_end** (DATE): Review period end
- **overall_rating** (DECIMAL(3,1)): Overall performance rating
- **communication_rating** (DECIMAL(3,1)): Communication skills rating
- **teamwork_rating** (DECIMAL(3,1)): Teamwork skills rating
- **leadership_rating** (DECIMAL(3,1)): Leadership skills rating
- **technical_skills_rating** (DECIMAL(3,1)): Technical skills rating
- **comments** (TEXT): Review comments
- **goals** (TEXT): Performance goals
- **next_review_date** (DATE): Next review date

### time_off
- **time_off_id** (INT, Primary Key): Unique time off request identifier
- **employee_id** (INT, Foreign Key): Reference to employees table
- **request_date** (DATE): Request submission date
- **start_date** (DATE): Time off start date
- **end_date** (DATE): Time off end date
- **days_requested** (DECIMAL(3,1)): Number of days requested
- **leave_type** (VARCHAR(50)): Type of leave
- **reason** (TEXT): Reason for time off
- **status** (VARCHAR(20)): Request status
- **approved_by** (INT, Foreign Key): Reference to employees table
- **approval_date** (DATE): Approval date

### skills
- **skill_id** (INT, Primary Key): Unique skill identifier
- **skill_name** (VARCHAR(100)): Skill name
- **skill_category** (VARCHAR(50)): Skill category
- **description** (TEXT): Skill description

### employee_skills
- **employee_skill_id** (INT, Primary Key): Unique employee skill record
- **employee_id** (INT, Foreign Key): Reference to employees table
- **skill_id** (INT, Foreign Key): Reference to skills table
- **proficiency_level** (VARCHAR(20)): Skill proficiency level
- **certification_name** (VARCHAR(100)): Certification name
- **certification_date** (DATE): Certification date
- **expiration_date** (DATE): Certification expiration date

## Views

### employee_summary
Provides a comprehensive summary of employee information including:
- Employee details and department information
- Manager relationships
- Skill count and average performance rating

### department_performance
Shows department performance metrics including:
- Employee count and average salary
- Average performance rating
- Total payroll and pending time off requests

### payroll_analysis
Provides detailed payroll analysis including:
- Employee and department information
- Pay period details
- Tax breakdowns and hourly rate calculations

## Stored Procedures

### get_employees_by_department(department_name VARCHAR)
Returns employees in a specific department, including:
- Employee details
- Job titles and hire dates
- Salary information

### get_high_performers(min_rating DECIMAL)
Returns high-performing employees, including:
- Employee details
- Department information
- Performance ratings and review dates

## Data Governance

### PII Tags
The following columns are tagged for Personally Identifiable Information:
- **email**: Tagged as EMAIL
- **phone**: Tagged as PHONE
- **salary**: Tagged as SALARY
- **first_name**: Tagged as FIRST_NAME
- **last_name**: Tagged as LAST_NAME

### Comments and Documentation
- Comprehensive table and column comments
- Clear documentation of data relationships
- Usage examples and best practices

## Sample Data

The model includes realistic sample data for:
- 8 departments across different business functions
- 15 employees with complete information
- 5 payroll records with detailed tax breakdowns
- 5 benefit enrollments across different plan types
- 5 performance reviews with detailed ratings
- 5 time off requests with various statuses
- 10 skills across different categories
- 10 employee skill associations with certifications

## Usage Examples

### Employee Analysis
```sql
-- Get employee summary
SELECT * FROM hr.employee_summary
ORDER BY avg_performance_rating DESC;
```

### Department Performance
```sql
-- Analyze department performance
SELECT * FROM hr.department_performance
ORDER BY avg_performance_rating DESC;
```

### Payroll Analysis
```sql
-- Analyze payroll data
SELECT * FROM hr.payroll_analysis
WHERE pay_period_start >= '2024-01-01'
ORDER BY gross_pay DESC;
```

### Using Stored Procedures
```sql
-- Get employees by department
CALL hr.get_employees_by_department('Engineering');

-- Get high performers
CALL hr.get_high_performers(4.0);
```

## Demo Scenarios

### 1. Workforce Analytics
- Analyze employee distribution across departments
- Track performance trends over time
- Monitor salary distributions and equity

### 2. Organizational Planning
- Review department budgets and headcount
- Analyze manager-employee ratios
- Plan organizational changes

### 3. Performance Management
- Track performance review completion rates
- Identify high performers and development needs
- Monitor goal achievement

### 4. Compensation Analysis
- Analyze salary distributions by department
- Review payroll costs and trends
- Monitor benefit utilization

### 5. Compliance and Reporting
- Track employment status changes
- Monitor time off patterns
- Ensure data governance compliance

## Setup Instructions

1. Run the complete `hrdb_data_model.sql` script in Snowflake
2. The script will create:
   - Database and schema
   - All tables with relationships
   - Sample data
   - Tags for data governance
   - Stored procedures and views
   - Appropriate permissions

## Cleanup

To reset the demo environment, uncomment and run the cleanup section at the end of the SQL script.

## Version History

- **Version 1.0.0** (12/2024): Complete HR data model with comprehensive features
- Based on enterprise HR management best practices

## Related Resources

- Snowflake HR Analytics: https://docs.snowflake.com/
- HR Data Governance Best Practices: https://docs.snowflake.com/ 