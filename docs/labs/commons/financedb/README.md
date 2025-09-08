# FINANCEDB - Finance Database

## Overview

The FINANCEDB data model is a comprehensive financial management system designed for Snowflake demonstrations. It includes complete general ledger functionality, accounts payable/receivable management, budgeting and forecasting, expense tracking, fixed asset management, and cash flow analysis.

## Features

### Core Financial Functions
- **General Ledger**: Complete double-entry bookkeeping with chart of accounts
- **Accounts Payable**: Vendor invoice management and payment tracking
- **Accounts Receivable**: Customer invoice management and collection tracking
- **Budgeting**: Budget planning, variance analysis, and forecasting
- **Expense Management**: Employee expense tracking and approval workflows
- **Fixed Assets**: Asset register, depreciation tracking, and lifecycle management
- **Cash Flow**: Cash flow statement and working capital analysis

### Advanced Features
- **Hierarchical Accounts**: Parent-child account relationships for detailed reporting
- **Time Series Data**: Historical financial data for trend analysis and forecasting
- **Multi-dimensional Analysis**: Department, location, and project-based reporting
- **Compliance Ready**: Audit trails and regulatory reporting capabilities
- **Views**: Pre-built financial reporting views
- **Stored Procedures**: Business logic for financial analysis and reporting
- **Sample Data**: Realistic financial data for testing and demonstration

## Database Structure

```
FINANCEDB
└── finance (schema)
    ├── chart_of_accounts
    ├── general_ledger
    ├── accounts_payable
    ├── accounts_receivable
    ├── budgets
    ├── expenses
    ├── fixed_assets
    ├── cash_flow
    ├── trial_balance (view)
    ├── budget_vs_actual (view)
    ├── ap_aging (view)
    ├── ar_aging (view)
    ├── get_account_balance() (stored procedure)
    └── get_overdue_invoices() (stored procedure)
```

## Tables

### chart_of_accounts
- **account_id** (INT, Primary Key): Unique account identifier
- **account_number** (VARCHAR(20)): Account number for reporting
- **account_name** (VARCHAR(100)): Account name
- **account_type** (VARCHAR(50)): Account type (Asset, Liability, Equity, Revenue, Expense)
- **account_category** (VARCHAR(50)): Account category for grouping
- **parent_account_id** (INT, Foreign Key): Reference to parent account
- **is_active** (BOOLEAN): Account active status
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### general_ledger
- **transaction_id** (INT, Primary Key): Unique transaction identifier
- **account_id** (INT, Foreign Key): Reference to chart of accounts
- **transaction_date** (DATE): Transaction date
- **posting_date** (DATE): GL posting date
- **reference_number** (VARCHAR(50)): Reference number for tracking
- **description** (TEXT): Transaction description
- **debit_amount** (DECIMAL(15,2)): Debit amount
- **credit_amount** (DECIMAL(15,2)): Credit amount
- **balance** (DECIMAL(15,2)): Running balance
- **journal_entry_id** (INT): Journal entry identifier
- **created_by** (VARCHAR(100)): User who created the transaction
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

### accounts_payable
- **invoice_id** (INT, Primary Key): Unique invoice identifier
- **vendor_id** (INT): Vendor identifier
- **vendor_name** (VARCHAR(100)): Vendor name
- **invoice_number** (VARCHAR(50)): Vendor invoice number
- **invoice_date** (DATE): Invoice date
- **due_date** (DATE): Payment due date
- **amount** (DECIMAL(15,2)): Invoice amount
- **tax_amount** (DECIMAL(15,2)): Tax amount
- **total_amount** (DECIMAL(15,2)): Total invoice amount
- **paid_amount** (DECIMAL(15,2)): Amount paid to date
- **balance** (DECIMAL(15,2)): Outstanding balance
- **status** (VARCHAR(20)): Invoice status
- **payment_terms** (VARCHAR(50)): Payment terms
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### accounts_receivable
- **invoice_id** (INT, Primary Key): Unique invoice identifier
- **customer_id** (INT): Customer identifier
- **customer_name** (VARCHAR(100)): Customer name
- **invoice_number** (VARCHAR(50)): Customer invoice number
- **invoice_date** (DATE): Invoice date
- **due_date** (DATE): Payment due date
- **amount** (DECIMAL(15,2)): Invoice amount
- **tax_amount** (DECIMAL(15,2)): Tax amount
- **total_amount** (DECIMAL(15,2)): Total invoice amount
- **paid_amount** (DECIMAL(15,2)): Amount received to date
- **balance** (DECIMAL(15,2)): Outstanding balance
- **status** (VARCHAR(20)): Invoice status
- **payment_terms** (VARCHAR(50)): Payment terms
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### budgets
- **budget_id** (INT, Primary Key): Unique budget identifier
- **account_id** (INT, Foreign Key): Reference to chart of accounts
- **budget_year** (INT): Budget year
- **budget_period** (VARCHAR(20)): Budget period (Q1, Q2, etc.)
- **budget_amount** (DECIMAL(15,2)): Budgeted amount
- **actual_amount** (DECIMAL(15,2)): Actual amount
- **variance** (DECIMAL(15,2)): Budget variance
- **variance_percentage** (DECIMAL(5,2)): Variance percentage
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### expenses
- **expense_id** (INT, Primary Key): Unique expense identifier
- **employee_id** (INT): Employee identifier
- **employee_name** (VARCHAR(100)): Employee name
- **expense_date** (DATE): Expense date
- **expense_category** (VARCHAR(50)): Expense category
- **description** (TEXT): Expense description
- **amount** (DECIMAL(10,2)): Expense amount
- **tax_amount** (DECIMAL(10,2)): Tax amount
- **total_amount** (DECIMAL(10,2)): Total expense amount
- **status** (VARCHAR(20)): Expense status
- **approved_by** (VARCHAR(100)): Approver name
- **approval_date** (DATE): Approval date
- **reimbursement_date** (DATE): Reimbursement date
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### fixed_assets
- **asset_id** (INT, Primary Key): Unique asset identifier
- **asset_number** (VARCHAR(50)): Asset number
- **asset_name** (VARCHAR(100)): Asset name
- **asset_category** (VARCHAR(50)): Asset category
- **asset_type** (VARCHAR(50)): Asset type
- **purchase_date** (DATE): Purchase date
- **purchase_cost** (DECIMAL(15,2)): Purchase cost
- **current_value** (DECIMAL(15,2)): Current market value
- **depreciation_method** (VARCHAR(50)): Depreciation method
- **useful_life_years** (INT): Useful life in years
- **salvage_value** (DECIMAL(15,2)): Salvage value
- **accumulated_depreciation** (DECIMAL(15,2)): Accumulated depreciation
- **net_book_value** (DECIMAL(15,2)): Net book value
- **location** (VARCHAR(100)): Asset location
- **department** (VARCHAR(100)): Responsible department
- **status** (VARCHAR(20)): Asset status
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### cash_flow
- **cash_flow_id** (INT, Primary Key): Unique cash flow identifier
- **period_start** (DATE): Period start date
- **period_end** (DATE): Period end date
- **cash_flow_type** (VARCHAR(50)): Cash flow type (Operating, Investing, Financing)
- **category** (VARCHAR(100)): Cash flow category
- **amount** (DECIMAL(15,2)): Cash flow amount
- **description** (TEXT): Cash flow description
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

## Views

### trial_balance
Provides a complete trial balance including:
- Account details and classifications
- Total debits and credits
- Account balances by type

### budget_vs_actual
Shows budget performance analysis including:
- Budget vs actual amounts
- Variance calculations
- Budget status indicators

### ap_aging
Provides accounts payable aging analysis including:
- Vendor invoice details
- Days overdue calculations
- Aging bucket classifications

### ar_aging
Provides accounts receivable aging analysis including:
- Customer invoice details
- Days overdue calculations
- Aging bucket classifications

## Stored Procedures

### get_account_balance(account_number VARCHAR)
Returns current balance for a specific account, including:
- Account details
- Account type and classification
- Current balance

### get_overdue_invoices()
Returns all overdue invoices from both AP and AR, including:
- Invoice details
- Days overdue
- Outstanding amounts

## Data Governance

### Financial Data Tags
The following columns are tagged for financial data classification:
- **employee_name**: Tagged as EMPLOYEE_NAME
- **customer_name**: Tagged as CUSTOMER_NAME
- **vendor_name**: Tagged as VENDOR_NAME

### Comments and Documentation
- Comprehensive table and column comments
- Clear documentation of financial relationships
- Usage examples and best practices

## Sample Data

The model includes realistic sample data for:
- 23 chart of accounts across all major categories
- 10 general ledger transactions with proper double-entry
- 5 accounts payable invoices with aging
- 5 accounts receivable invoices with aging
- 5 budget records with variance analysis
- 5 employee expense records
- 5 fixed assets with depreciation tracking
- 5 cash flow entries across operating, investing, and financing

## Usage Examples

### Financial Reporting
```sql
-- Get trial balance
SELECT * FROM finance.trial_balance
ORDER BY account_number;
```

### Budget Analysis
```sql
-- Analyze budget performance
SELECT * FROM finance.budget_vs_actual
WHERE budget_year = 2024
ORDER BY variance_percentage DESC;
```

### Accounts Receivable Aging
```sql
-- Analyze AR aging
SELECT * FROM finance.ar_aging
ORDER BY days_overdue DESC;
```

### Using Stored Procedures
```sql
-- Get account balance
CALL finance.get_account_balance('1000');

-- Get overdue invoices
CALL finance.get_overdue_invoices();
```

## Demo Scenarios

### 1. Financial Reporting
- Generate trial balance and financial statements
- Analyze account balances and trends
- Review journal entries and audit trails

### 2. Budget Management
- Compare budget vs actual performance
- Identify budget variances and trends
- Plan and forecast future budgets

### 3. Cash Flow Analysis
- Monitor cash flow from operations
- Analyze working capital management
- Track cash flow trends over time

### 4. Accounts Receivable Management
- Monitor customer payment patterns
- Identify overdue accounts
- Optimize collection strategies

### 5. Fixed Asset Management
- Track asset depreciation and book values
- Monitor asset utilization and performance
- Plan capital expenditure requirements

## Setup Instructions

1. Run the complete `financdb_data_model.sql` script in Snowflake
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

- **Version 1.0.0** (12/2024): Complete finance data model with comprehensive features
- Based on enterprise financial management best practices

## Related Resources

- Snowflake Financial Analytics: https://docs.snowflake.com/
- Financial Data Governance Best Practices: https://docs.snowflake.com/ 