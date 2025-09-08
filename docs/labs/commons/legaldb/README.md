# LEGALDB - Legal and Contracts Database

## Overview

The LEGALDB data model is a comprehensive legal management system designed for Snowflake demonstrations. It includes contract lifecycle management, legal case tracking, regulatory compliance monitoring, intellectual property management, and legal expense tracking with advanced features for enterprise legal operations.

## Features

### Core Legal Functions
- **Contract Management**: Complete contract lifecycle from drafting to expiration
- **Legal Case Management**: Case tracking, document management, and outcome tracking
- **Regulatory Compliance**: Regulation tracking, compliance audits, and deadline management
- **Intellectual Property**: Patent, trademark, copyright, and trade secret management
- **Legal Expenses**: Expense tracking, vendor management, and budget control
- **Legal Calendar**: Deadline tracking, court dates, and event management
- **Document Management**: Case documents with confidentiality and privilege tracking

### Advanced Features
- **Risk Management**: Contract and case risk assessment and monitoring
- **Compliance Automation**: Regulatory deadline tracking and audit management
- **Financial Tracking**: Legal expense analysis and budget management
- **Privilege Management**: Attorney-client privilege and work product protection
- **Views**: Pre-built legal analytics and reporting views
- **Stored Procedures**: Business logic for legal analysis and reporting
- **Sample Data**: Realistic legal data for testing and demonstration

## Database Structure

```
LEGALDB
└── legal (schema)
    ├── contracts
    ├── contract_amendments
    ├── legal_cases
    ├── case_documents
    ├── regulations
    ├── compliance_audits
    ├── intellectual_property
    ├── legal_expenses
    ├── legal_calendar
    ├── contract_summary (view)
    ├── case_summary (view)
    ├── compliance_dashboard (view)
    ├── legal_expenses_summary (view)
    ├── get_contracts_by_risk() (stored procedure)
    └── get_high_value_cases() (stored procedure)
```

## Tables

### contracts
- **contract_id** (INT, Primary Key): Unique contract identifier
- **contract_number** (VARCHAR(50)): Contract number for tracking
- **contract_title** (VARCHAR(200)): Contract title
- **contract_type** (VARCHAR(100)): Type of contract
- **contract_category** (VARCHAR(100)): Contract category
- **party_a_name** (VARCHAR(200)): First party name
- **party_a_type** (VARCHAR(50)): First party type
- **party_b_name** (VARCHAR(200)): Second party name
- **party_b_type** (VARCHAR(50)): Second party type
- **contract_value** (DECIMAL(15,2)): Contract value
- **currency** (VARCHAR(3)): Currency code
- **start_date** (DATE): Contract start date
- **end_date** (DATE): Contract end date
- **renewal_date** (DATE): Contract renewal date
- **auto_renewal** (BOOLEAN): Auto-renewal flag
- **contract_status** (VARCHAR(50)): Contract status
- **approval_status** (VARCHAR(50)): Approval status
- **contract_manager** (VARCHAR(100)): Contract manager
- **legal_reviewer** (VARCHAR(100)): Legal reviewer
- **business_owner** (VARCHAR(100)): Business owner
- **department** (VARCHAR(100)): Responsible department
- **contract_terms** (TEXT): Contract terms
- **key_obligations** (TEXT): Key obligations
- **risk_level** (VARCHAR(20)): Risk level
- **compliance_requirements** (TEXT): Compliance requirements
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### contract_amendments
- **amendment_id** (INT, Primary Key): Unique amendment identifier
- **contract_id** (INT, Foreign Key): Reference to contracts table
- **amendment_number** (VARCHAR(50)): Amendment number
- **amendment_type** (VARCHAR(100)): Type of amendment
- **amendment_date** (DATE): Amendment date
- **effective_date** (DATE): Effective date
- **amendment_description** (TEXT): Amendment description
- **changes_made** (TEXT): Changes made
- **approval_status** (VARCHAR(50)): Approval status
- **approved_by** (VARCHAR(100)): Approved by
- **approval_date** (DATE): Approval date
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

### legal_cases
- **case_id** (INT, Primary Key): Unique case identifier
- **case_number** (VARCHAR(50)): Case number
- **case_title** (VARCHAR(200)): Case title
- **case_type** (VARCHAR(100)): Type of case
- **case_category** (VARCHAR(100)): Case category
- **filing_date** (DATE): Filing date
- **court_name** (VARCHAR(200)): Court name
- **court_location** (VARCHAR(200)): Court location
- **case_status** (VARCHAR(50)): Case status
- **priority_level** (VARCHAR(20)): Priority level
- **assigned_attorney** (VARCHAR(100)): Assigned attorney
- **opposing_party** (VARCHAR(200)): Opposing party
- **opposing_counsel** (VARCHAR(200)): Opposing counsel
- **case_description** (TEXT): Case description
- **legal_issues** (TEXT): Legal issues
- **potential_liability** (DECIMAL(15,2)): Potential liability
- **settlement_amount** (DECIMAL(15,2)): Settlement amount
- **judgment_amount** (DECIMAL(15,2)): Judgment amount
- **case_outcome** (VARCHAR(100)): Case outcome
- **closed_date** (DATE): Closed date
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### case_documents
- **document_id** (INT, Primary Key): Unique document identifier
- **case_id** (INT, Foreign Key): Reference to legal_cases table
- **document_name** (VARCHAR(200)): Document name
- **document_type** (VARCHAR(100)): Document type
- **document_category** (VARCHAR(100)): Document category
- **filing_date** (DATE): Filing date
- **document_url** (VARCHAR(500)): Document URL
- **file_size_bytes** (INT): File size in bytes
- **confidentiality_level** (VARCHAR(50)): Confidentiality level
- **attorney_work_product** (BOOLEAN): Attorney work product flag
- **privileged_communication** (BOOLEAN): Privileged communication flag
- **created_by** (VARCHAR(100)): Created by
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

### regulations
- **regulation_id** (INT, Primary Key): Unique regulation identifier
- **regulation_name** (VARCHAR(200)): Regulation name
- **regulation_code** (VARCHAR(100)): Regulation code
- **regulatory_body** (VARCHAR(200)): Regulatory body
- **jurisdiction** (VARCHAR(100)): Jurisdiction
- **effective_date** (DATE): Effective date
- **compliance_deadline** (DATE): Compliance deadline
- **regulation_type** (VARCHAR(100)): Regulation type
- **regulation_category** (VARCHAR(100)): Regulation category
- **description** (TEXT): Regulation description
- **requirements** (TEXT): Requirements
- **penalties** (TEXT): Penalties
- **compliance_status** (VARCHAR(50)): Compliance status
- **responsible_department** (VARCHAR(100)): Responsible department
- **compliance_officer** (VARCHAR(100)): Compliance officer
- **last_review_date** (DATE): Last review date
- **next_review_date** (DATE): Next review date
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### compliance_audits
- **audit_id** (INT, Primary Key): Unique audit identifier
- **audit_name** (VARCHAR(200)): Audit name
- **audit_type** (VARCHAR(100)): Audit type
- **audit_scope** (TEXT): Audit scope
- **audit_period_start** (DATE): Audit period start
- **audit_period_end** (DATE): Audit period end
- **audit_date** (DATE): Audit date
- **auditor_name** (VARCHAR(100)): Auditor name
- **auditor_company** (VARCHAR(200)): Auditor company
- **audit_status** (VARCHAR(50)): Audit status
- **findings** (TEXT): Audit findings
- **recommendations** (TEXT): Recommendations
- **risk_level** (VARCHAR(20)): Risk level
- **compliance_score** (DECIMAL(5,2)): Compliance score
- **follow_up_required** (BOOLEAN): Follow-up required flag
- **follow_up_date** (DATE): Follow-up date
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### intellectual_property
- **ip_id** (INT, Primary Key): Unique IP identifier
- **ip_name** (VARCHAR(200)): IP name
- **ip_type** (VARCHAR(100)): IP type
- **ip_category** (VARCHAR(100)): IP category
- **description** (TEXT): IP description
- **filing_date** (DATE): Filing date
- **registration_date** (DATE): Registration date
- **registration_number** (VARCHAR(100)): Registration number
- **jurisdiction** (VARCHAR(100)): Jurisdiction
- **status** (VARCHAR(50)): IP status
- **owner** (VARCHAR(200)): IP owner
- **inventor_creator** (VARCHAR(200)): Inventor/creator
- **renewal_date** (DATE): Renewal date
- **expiration_date** (DATE): Expiration date
- **estimated_value** (DECIMAL(15,2)): Estimated value
- **licensing_agreements** (TEXT): Licensing agreements
- **infringement_cases** (TEXT): Infringement cases
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### legal_expenses
- **expense_id** (INT, Primary Key): Unique expense identifier
- **case_id** (INT, Foreign Key): Reference to legal_cases table
- **contract_id** (INT, Foreign Key): Reference to contracts table
- **expense_date** (DATE): Expense date
- **expense_category** (VARCHAR(100)): Expense category
- **expense_type** (VARCHAR(100)): Expense type
- **description** (TEXT): Expense description
- **amount** (DECIMAL(10,2)): Expense amount
- **currency** (VARCHAR(3)): Currency code
- **vendor_name** (VARCHAR(200)): Vendor name
- **invoice_number** (VARCHAR(100)): Invoice number
- **payment_status** (VARCHAR(50)): Payment status
- **approved_by** (VARCHAR(100)): Approved by
- **approval_date** (DATE): Approval date
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

### legal_calendar
- **calendar_id** (INT, Primary Key): Unique calendar event identifier
- **case_id** (INT, Foreign Key): Reference to legal_cases table
- **contract_id** (INT, Foreign Key): Reference to contracts table
- **event_type** (VARCHAR(100)): Event type
- **event_title** (VARCHAR(200)): Event title
- **event_date** (DATE): Event date
- **event_time** (TIME): Event time
- **event_location** (VARCHAR(200)): Event location
- **event_description** (TEXT): Event description
- **priority_level** (VARCHAR(20)): Priority level
- **assigned_to** (VARCHAR(100)): Assigned to
- **reminder_days** (INT): Reminder days
- **completed** (BOOLEAN): Completed flag
- **completion_notes** (TEXT): Completion notes
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

## Views

### contract_summary
Provides comprehensive contract analysis including:
- Contract details and status
- Amendment tracking
- Expiration status and risk assessment
- Financial value and approval status

### case_summary
Shows legal case analysis including:
- Case details and status
- Document counts and expense tracking
- Potential liability and outcomes
- Days open and priority levels

### compliance_dashboard
Provides compliance monitoring including:
- Regulation status and deadlines
- Audit results and compliance scores
- Risk levels and responsible parties
- Days to compliance deadlines

### legal_expenses_summary
Shows legal expense analysis including:
- Expense categorization and tracking
- Vendor management and payment status
- Case and contract expense allocation
- Approval workflow tracking

## Stored Procedures

### get_contracts_by_risk(risk_level_param VARCHAR)
Returns contracts by risk level, including:
- Contract details and financial information
- Risk assessment and expiration status
- Management and approval information

### get_high_value_cases(min_liability DECIMAL)
Returns high-value legal cases, including:
- Case details and status
- Potential liability and expense tracking
- Attorney assignments and outcomes

## Data Governance

### Legal Data Tags
The following columns are tagged for legal data classification:
- **contract_terms**: Tagged as CONTRACT_TERMS
- **contract_value**: Tagged as CONTRACT_VALUE
- **case_description**: Tagged as CASE_DESCRIPTION
- **potential_liability**: Tagged as POTENTIAL_LIABILITY
- **attorney_work_product**: Tagged as ATTORNEY_WORK_PRODUCT
- **privileged_communication**: Tagged as PRIVILEGED_COMMUNICATION

### Comments and Documentation
- Comprehensive table and column comments
- Clear documentation of legal relationships
- Usage examples and best practices

## Sample Data

The model includes realistic sample data for:
- 5 contracts across different types and risk levels
- 3 contract amendments with approval workflows
- 5 legal cases with various types and statuses
- 5 case documents with confidentiality levels
- 5 regulations with compliance requirements
- 5 compliance audits with findings and scores
- 5 intellectual property assets with valuations
- 5 legal expenses with vendor tracking
- 5 calendar events with deadline management

## Usage Examples

### Contract Analysis
```sql
-- Get contract summary
SELECT * FROM legal.contract_summary
ORDER BY contract_value DESC;
```

### Case Management
```sql
-- Analyze legal cases
SELECT * FROM legal.case_summary
WHERE case_status = 'OPEN'
ORDER BY potential_liability DESC;
```

### Compliance Monitoring
```sql
-- Monitor compliance status
SELECT * FROM legal.compliance_dashboard
WHERE compliance_status = 'PENDING'
ORDER BY days_to_deadline;
```

### Using Stored Procedures
```sql
-- Get high-risk contracts
CALL legal.get_contracts_by_risk('HIGH');

-- Get high-value cases
CALL legal.get_high_value_cases(500000.00);
```

## Demo Scenarios

### 1. Contract Lifecycle Management
- Track contract creation, approval, and execution
- Monitor contract amendments and renewals
- Analyze contract risk and compliance requirements

### 2. Legal Case Management
- Manage case progression and document tracking
- Monitor case expenses and potential liabilities
- Track case outcomes and settlement amounts

### 3. Regulatory Compliance
- Monitor regulatory deadlines and requirements
- Track compliance audit results and scores
- Manage compliance officer assignments

### 4. Intellectual Property Management
- Track patent, trademark, and copyright portfolios
- Monitor IP valuations and licensing agreements
- Manage IP renewal deadlines and infringement cases

### 5. Legal Expense Management
- Track legal expenses by case and contract
- Monitor vendor performance and payment status
- Analyze legal spend and budget management

## Setup Instructions

1. Run the complete `legaldb_data_model.sql` script in Snowflake
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

- **Version 1.0.0** (12/2024): Complete legal data model with comprehensive features
- Based on enterprise legal management best practices

## Related Resources

- Snowflake Legal Analytics: https://docs.snowflake.com/
- Legal Data Governance Best Practices: https://docs.snowflake.com/ 