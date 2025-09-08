-- =====================================================
-- FINANCEDB - Finance Database
-- Comprehensive finance data model for Snowflake demonstrations
-- Version: 1.0.0
-- Last Updated: December 2024
-- =====================================================

-- Create database and schema
CREATE OR REPLACE DATABASE FINANCEDB;
USE DATABASE FINANCEDB;
CREATE OR REPLACE SCHEMA finance;

-- =====================================================
-- TABLES
-- =====================================================

-- Chart of Accounts
CREATE OR REPLACE TABLE finance.chart_of_accounts (
    account_id INT PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    account_category VARCHAR(50),
    parent_account_id INT REFERENCES finance.chart_of_accounts(account_id),
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- General Ledger
CREATE OR REPLACE TABLE finance.general_ledger (
    transaction_id INT PRIMARY KEY,
    account_id INT REFERENCES finance.chart_of_accounts(account_id),
    transaction_date DATE NOT NULL,
    posting_date DATE NOT NULL,
    reference_number VARCHAR(50),
    description TEXT,
    debit_amount DECIMAL(15,2) DEFAULT 0,
    credit_amount DECIMAL(15,2) DEFAULT 0,
    balance DECIMAL(15,2),
    journal_entry_id INT,
    created_by VARCHAR(100),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Accounts Payable
CREATE OR REPLACE TABLE finance.accounts_payable (
    invoice_id INT PRIMARY KEY,
    vendor_id INT,
    vendor_name VARCHAR(100),
    invoice_number VARCHAR(50),
    invoice_date DATE,
    due_date DATE,
    amount DECIMAL(15,2),
    tax_amount DECIMAL(15,2),
    total_amount DECIMAL(15,2),
    paid_amount DECIMAL(15,2) DEFAULT 0,
    balance DECIMAL(15,2),
    status VARCHAR(20) DEFAULT 'OPEN',
    payment_terms VARCHAR(50),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Accounts Receivable
CREATE OR REPLACE TABLE finance.accounts_receivable (
    invoice_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    invoice_number VARCHAR(50),
    invoice_date DATE,
    due_date DATE,
    amount DECIMAL(15,2),
    tax_amount DECIMAL(15,2),
    total_amount DECIMAL(15,2),
    paid_amount DECIMAL(15,2) DEFAULT 0,
    balance DECIMAL(15,2),
    status VARCHAR(20) DEFAULT 'OPEN',
    payment_terms VARCHAR(50),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Budgets
CREATE OR REPLACE TABLE finance.budgets (
    budget_id INT PRIMARY KEY,
    account_id INT REFERENCES finance.chart_of_accounts(account_id),
    budget_year INT NOT NULL,
    budget_period VARCHAR(20),
    budget_amount DECIMAL(15,2),
    actual_amount DECIMAL(15,2) DEFAULT 0,
    variance DECIMAL(15,2),
    variance_percentage DECIMAL(5,2),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Expenses
CREATE OR REPLACE TABLE finance.expenses (
    expense_id INT PRIMARY KEY,
    employee_id INT,
    employee_name VARCHAR(100),
    expense_date DATE,
    expense_category VARCHAR(50),
    description TEXT,
    amount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'PENDING',
    approved_by VARCHAR(100),
    approval_date DATE,
    reimbursement_date DATE,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Fixed Assets
CREATE OR REPLACE TABLE finance.fixed_assets (
    asset_id INT PRIMARY KEY,
    asset_number VARCHAR(50) UNIQUE,
    asset_name VARCHAR(100),
    asset_category VARCHAR(50),
    asset_type VARCHAR(50),
    purchase_date DATE,
    purchase_cost DECIMAL(15,2),
    current_value DECIMAL(15,2),
    depreciation_method VARCHAR(50),
    useful_life_years INT,
    salvage_value DECIMAL(15,2),
    accumulated_depreciation DECIMAL(15,2) DEFAULT 0,
    net_book_value DECIMAL(15,2),
    location VARCHAR(100),
    department VARCHAR(100),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Cash Flow
CREATE OR REPLACE TABLE finance.cash_flow (
    cash_flow_id INT PRIMARY KEY,
    period_start DATE,
    period_end DATE,
    cash_flow_type VARCHAR(50),
    category VARCHAR(100),
    amount DECIMAL(15,2),
    description TEXT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Insert Chart of Accounts
INSERT INTO finance.chart_of_accounts (account_id, account_number, account_name, account_type, account_category) VALUES
(1, '1000', 'Cash', 'Asset', 'Current Assets'),
(2, '1100', 'Accounts Receivable', 'Asset', 'Current Assets'),
(3, '1200', 'Inventory', 'Asset', 'Current Assets'),
(4, '1300', 'Prepaid Expenses', 'Asset', 'Current Assets'),
(5, '1500', 'Fixed Assets', 'Asset', 'Fixed Assets'),
(6, '1600', 'Accumulated Depreciation', 'Asset', 'Fixed Assets'),
(7, '2000', 'Accounts Payable', 'Liability', 'Current Liabilities'),
(8, '2100', 'Accrued Expenses', 'Liability', 'Current Liabilities'),
(9, '2200', 'Notes Payable', 'Liability', 'Current Liabilities'),
(10, '3000', 'Common Stock', 'Equity', 'Stockholders Equity'),
(11, '3100', 'Retained Earnings', 'Equity', 'Stockholders Equity'),
(12, '4000', 'Revenue', 'Revenue', 'Income'),
(13, '4100', 'Sales Revenue', 'Revenue', 'Income'),
(14, '4200', 'Service Revenue', 'Revenue', 'Income'),
(15, '5000', 'Cost of Goods Sold', 'Expense', 'Cost of Sales'),
(16, '5100', 'Direct Labor', 'Expense', 'Cost of Sales'),
(17, '5200', 'Direct Materials', 'Expense', 'Cost of Sales'),
(18, '6000', 'Operating Expenses', 'Expense', 'Operating Expenses'),
(19, '6100', 'Salaries and Wages', 'Expense', 'Operating Expenses'),
(20, '6200', 'Rent Expense', 'Expense', 'Operating Expenses'),
(21, '6300', 'Utilities', 'Expense', 'Operating Expenses'),
(22, '6400', 'Marketing', 'Expense', 'Operating Expenses'),
(23, '6500', 'Depreciation', 'Expense', 'Operating Expenses');

-- Insert General Ledger transactions
INSERT INTO finance.general_ledger (transaction_id, account_id, transaction_date, posting_date, reference_number, description, debit_amount, credit_amount, balance) VALUES
(1, 1, '2024-01-01', '2024-01-01', 'JE001', 'Initial cash investment', 100000.00, 0, 100000.00),
(2, 10, '2024-01-01', '2024-01-01', 'JE001', 'Initial cash investment', 0, 100000.00, -100000.00),
(3, 13, '2024-01-15', '2024-01-15', 'INV001', 'Sales revenue', 0, 50000.00, -50000.00),
(4, 1, '2024-01-15', '2024-01-15', 'INV001', 'Sales revenue', 50000.00, 0, 150000.00),
(5, 15, '2024-01-20', '2024-01-20', 'COGS001', 'Cost of goods sold', 30000.00, 0, 30000.00),
(6, 3, '2024-01-20', '2024-01-20', 'COGS001', 'Cost of goods sold', 0, 30000.00, -30000.00),
(7, 19, '2024-01-31', '2024-01-31', 'PAY001', 'Salary expense', 25000.00, 0, 25000.00),
(8, 1, '2024-01-31', '2024-01-31', 'PAY001', 'Salary expense', 0, 25000.00, 125000.00),
(9, 20, '2024-01-31', '2024-01-31', 'RENT001', 'Rent expense', 5000.00, 0, 5000.00),
(10, 1, '2024-01-31', '2024-01-31', 'RENT001', 'Rent expense', 0, 5000.00, 120000.00);

-- Insert Accounts Payable
INSERT INTO finance.accounts_payable (invoice_id, vendor_id, vendor_name, invoice_number, invoice_date, due_date, amount, tax_amount, total_amount, balance, status, payment_terms) VALUES
(1, 101, 'ABC Supplies', 'INV-2024-001', '2024-01-05', '2024-02-05', 10000.00, 1000.00, 11000.00, 11000.00, 'OPEN', 'Net 30'),
(2, 102, 'XYZ Services', 'INV-2024-002', '2024-01-10', '2024-02-10', 5000.00, 500.00, 5500.00, 5500.00, 'OPEN', 'Net 30'),
(3, 103, 'Tech Solutions', 'INV-2024-003', '2024-01-15', '2024-02-15', 15000.00, 1500.00, 16500.00, 0.00, 'PAID', 'Net 30'),
(4, 104, 'Office Plus', 'INV-2024-004', '2024-01-20', '2024-02-20', 3000.00, 300.00, 3300.00, 3300.00, 'OPEN', 'Net 30'),
(5, 105, 'Marketing Pro', 'INV-2024-005', '2024-01-25', '2024-02-25', 8000.00, 800.00, 8800.00, 8800.00, 'OPEN', 'Net 30');

-- Insert Accounts Receivable
INSERT INTO finance.accounts_receivable (invoice_id, customer_id, customer_name, invoice_number, invoice_date, due_date, amount, tax_amount, total_amount, balance, status, payment_terms) VALUES
(1, 201, 'Customer A', 'AR-2024-001', '2024-01-05', '2024-02-05', 20000.00, 2000.00, 22000.00, 22000.00, 'OPEN', 'Net 30'),
(2, 202, 'Customer B', 'AR-2024-002', '2024-01-10', '2024-02-10', 15000.00, 1500.00, 16500.00, 0.00, 'PAID', 'Net 30'),
(3, 203, 'Customer C', 'AR-2024-003', '2024-01-15', '2024-02-15', 12000.00, 1200.00, 13200.00, 13200.00, 'OPEN', 'Net 30'),
(4, 204, 'Customer D', 'AR-2024-004', '2024-01-20', '2024-02-20', 18000.00, 1800.00, 19800.00, 19800.00, 'OPEN', 'Net 30'),
(5, 205, 'Customer E', 'AR-2024-005', '2024-01-25', '2024-02-25', 10000.00, 1000.00, 11000.00, 11000.00, 'OPEN', 'Net 30');

-- Insert Budgets
INSERT INTO finance.budgets (budget_id, account_id, budget_year, budget_period, budget_amount, actual_amount, variance, variance_percentage) VALUES
(1, 19, 2024, 'Q1', 75000.00, 25000.00, -50000.00, -66.67),
(2, 20, 2024, 'Q1', 15000.00, 5000.00, -10000.00, -66.67),
(3, 21, 2024, 'Q1', 9000.00, 3000.00, -6000.00, -66.67),
(4, 22, 2024, 'Q1', 30000.00, 10000.00, -20000.00, -66.67),
(5, 13, 2024, 'Q1', 150000.00, 50000.00, -100000.00, -66.67);

-- Insert Expenses
INSERT INTO finance.expenses (expense_id, employee_id, employee_name, expense_date, expense_category, description, amount, tax_amount, total_amount, status, approved_by) VALUES
(1, 1, 'John Smith', '2024-01-15', 'Travel', 'Business trip to client site', 500.00, 0.00, 500.00, 'APPROVED', 'Sarah Johnson'),
(2, 2, 'Sarah Johnson', '2024-01-18', 'Meals', 'Client dinner meeting', 150.00, 0.00, 150.00, 'APPROVED', 'Michael Brown'),
(3, 3, 'Michael Brown', '2024-01-20', 'Office Supplies', 'Printer cartridges and paper', 200.00, 20.00, 220.00, 'PENDING', NULL),
(4, 4, 'Emily Davis', '2024-01-22', 'Training', 'Professional certification course', 1000.00, 0.00, 1000.00, 'APPROVED', 'David Wilson'),
(5, 5, 'David Wilson', '2024-01-25', 'Equipment', 'New laptop for work', 1200.00, 120.00, 1320.00, 'PENDING', NULL);

-- Insert Fixed Assets
INSERT INTO finance.fixed_assets (asset_id, asset_number, asset_name, asset_category, asset_type, purchase_date, purchase_cost, current_value, depreciation_method, useful_life_years, salvage_value, accumulated_depreciation, net_book_value, location, department) VALUES
(1, 'FA001', 'Office Building', 'Real Estate', 'Building', '2020-01-01', 500000.00, 500000.00, 'Straight Line', 30, 50000.00, 50000.00, 450000.00, 'Main Campus', 'Administration'),
(2, 'FA002', 'Delivery Truck', 'Transportation', 'Vehicle', '2021-06-15', 45000.00, 45000.00, 'Straight Line', 5, 5000.00, 13500.00, 31500.00, 'Warehouse', 'Operations'),
(3, 'FA003', 'Computer Server', 'Technology', 'Equipment', '2022-03-10', 25000.00, 25000.00, 'Straight Line', 5, 2500.00, 10000.00, 15000.00, 'Data Center', 'IT'),
(4, 'FA004', 'Office Furniture', 'Furniture', 'Equipment', '2021-09-01', 15000.00, 15000.00, 'Straight Line', 7, 1500.00, 4285.71, 10714.29, 'Main Office', 'Administration'),
(5, 'FA005', 'Manufacturing Equipment', 'Machinery', 'Equipment', '2020-12-01', 100000.00, 100000.00, 'Straight Line', 10, 10000.00, 30000.00, 70000.00, 'Factory', 'Manufacturing');

-- Insert Cash Flow
INSERT INTO finance.cash_flow (cash_flow_id, period_start, period_end, cash_flow_type, category, amount, description) VALUES
(1, '2024-01-01', '2024-01-31', 'Operating', 'Cash from Operations', 25000.00, 'Net cash from operating activities'),
(2, '2024-01-01', '2024-01-31', 'Operating', 'Accounts Receivable', -22000.00, 'Increase in accounts receivable'),
(3, '2024-01-01', '2024-01-31', 'Operating', 'Accounts Payable', 11000.00, 'Increase in accounts payable'),
(4, '2024-01-01', '2024-01-31', 'Investing', 'Capital Expenditures', -50000.00, 'Purchase of fixed assets'),
(5, '2024-01-01', '2024-01-31', 'Financing', 'Equity Investment', 100000.00, 'Initial equity investment');

-- =====================================================
-- VIEWS
-- =====================================================

-- Trial Balance View
CREATE OR REPLACE VIEW finance.trial_balance AS
SELECT 
    coa.account_id,
    coa.account_number,
    coa.account_name,
    coa.account_type,
    coa.account_category,
    SUM(gl.debit_amount) as total_debits,
    SUM(gl.credit_amount) as total_credits,
    CASE 
        WHEN coa.account_type IN ('Asset', 'Expense') THEN SUM(gl.debit_amount) - SUM(gl.credit_amount)
        ELSE SUM(gl.credit_amount) - SUM(gl.debit_amount)
    END as account_balance
FROM finance.chart_of_accounts coa
LEFT JOIN finance.general_ledger gl ON coa.account_id = gl.account_id
WHERE coa.is_active = TRUE
GROUP BY coa.account_id, coa.account_number, coa.account_name, coa.account_type, coa.account_category
ORDER BY coa.account_number;

-- Budget vs Actual View
CREATE OR REPLACE VIEW finance.budget_vs_actual AS
SELECT 
    b.budget_id,
    coa.account_number,
    coa.account_name,
    b.budget_year,
    b.budget_period,
    b.budget_amount,
    b.actual_amount,
    b.variance,
    b.variance_percentage,
    CASE 
        WHEN b.variance_percentage > 0 THEN 'OVER_BUDGET'
        WHEN b.variance_percentage < 0 THEN 'UNDER_BUDGET'
        ELSE 'ON_BUDGET'
    END as budget_status
FROM finance.budgets b
JOIN finance.chart_of_accounts coa ON b.account_id = coa.account_id
ORDER BY b.budget_year, b.budget_period, coa.account_number;

-- Accounts Payable Aging View
CREATE OR REPLACE VIEW finance.ap_aging AS
SELECT 
    vendor_name,
    invoice_number,
    invoice_date,
    due_date,
    total_amount,
    balance,
    DATEDIFF('day', due_date, CURRENT_DATE()) as days_overdue,
    CASE 
        WHEN DATEDIFF('day', due_date, CURRENT_DATE()) <= 0 THEN 'Current'
        WHEN DATEDIFF('day', due_date, CURRENT_DATE()) <= 30 THEN '1-30 Days'
        WHEN DATEDIFF('day', due_date, CURRENT_DATE()) <= 60 THEN '31-60 Days'
        WHEN DATEDIFF('day', due_date, CURRENT_DATE()) <= 90 THEN '61-90 Days'
        ELSE 'Over 90 Days'
    END as aging_bucket
FROM finance.accounts_payable
WHERE status = 'OPEN'
ORDER BY days_overdue DESC;

-- Accounts Receivable Aging View
CREATE OR REPLACE VIEW finance.ar_aging AS
SELECT 
    customer_name,
    invoice_number,
    invoice_date,
    due_date,
    total_amount,
    balance,
    DATEDIFF('day', due_date, CURRENT_DATE()) as days_overdue,
    CASE 
        WHEN DATEDIFF('day', due_date, CURRENT_DATE()) <= 0 THEN 'Current'
        WHEN DATEDIFF('day', due_date, CURRENT_DATE()) <= 30 THEN '1-30 Days'
        WHEN DATEDIFF('day', due_date, CURRENT_DATE()) <= 60 THEN '31-60 Days'
        WHEN DATEDIFF('day', due_date, CURRENT_DATE()) <= 90 THEN '61-90 Days'
        ELSE 'Over 90 Days'
    END as aging_bucket
FROM finance.accounts_receivable
WHERE status = 'OPEN'
ORDER BY days_overdue DESC;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Get account balance
CREATE OR REPLACE PROCEDURE finance.get_account_balance(account_number VARCHAR)
RETURNS TABLE (
    account_id INT,
    account_name VARCHAR,
    account_type VARCHAR,
    current_balance DECIMAL(15,2)
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            coa.account_id,
            coa.account_name,
            coa.account_type,
            CASE 
                WHEN coa.account_type IN ('Asset', 'Expense') THEN SUM(gl.debit_amount) - SUM(gl.credit_amount)
                ELSE SUM(gl.credit_amount) - SUM(gl.debit_amount)
            END as current_balance
        FROM finance.chart_of_accounts coa
        LEFT JOIN finance.general_ledger gl ON coa.account_id = gl.account_id
        WHERE coa.account_number = account_number
        GROUP BY coa.account_id, coa.account_name, coa.account_type
    );
END;
$$;

-- Get overdue invoices
CREATE OR REPLACE PROCEDURE finance.get_overdue_invoices()
RETURNS TABLE (
    invoice_type VARCHAR,
    customer_vendor_name VARCHAR,
    invoice_number VARCHAR,
    due_date DATE,
    amount DECIMAL(15,2),
    days_overdue INT
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            'Accounts Receivable' as invoice_type,
            customer_name as customer_vendor_name,
            invoice_number,
            due_date,
            balance as amount,
            DATEDIFF('day', due_date, CURRENT_DATE()) as days_overdue
        FROM finance.accounts_receivable
        WHERE status = 'OPEN' AND due_date < CURRENT_DATE()
        
        UNION ALL
        
        SELECT 
            'Accounts Payable' as invoice_type,
            vendor_name as customer_vendor_name,
            invoice_number,
            due_date,
            balance as amount,
            DATEDIFF('day', due_date, CURRENT_DATE()) as days_overdue
        FROM finance.accounts_payable
        WHERE status = 'OPEN' AND due_date < CURRENT_DATE()
        
        ORDER BY days_overdue DESC
    );
END;
$$;

-- =====================================================
-- TAGS FOR DATA GOVERNANCE
-- =====================================================

-- Create tags
CREATE OR REPLACE TAG finance.FINANCIAL_DATA_TAG;
CREATE OR REPLACE TAG finance.SENSITIVE_DATA_TAG;
CREATE OR REPLACE TAG finance.PII_TAG;

-- Apply tags to sensitive columns
ALTER TABLE finance.expenses MODIFY COLUMN employee_name SET TAG finance.PII_TAG = 'EMPLOYEE_NAME';
ALTER TABLE finance.accounts_receivable MODIFY COLUMN customer_name SET TAG finance.PII_TAG = 'CUSTOMER_NAME';
ALTER TABLE finance.accounts_payable MODIFY COLUMN vendor_name SET TAG finance.PII_TAG = 'VENDOR_NAME';

-- =====================================================
-- COMMENTS
-- =====================================================

-- Table comments
COMMENT ON TABLE finance.chart_of_accounts IS 'Chart of accounts for financial reporting';
COMMENT ON TABLE finance.general_ledger IS 'General ledger transactions and balances';
COMMENT ON TABLE finance.accounts_payable IS 'Vendor invoices and payment tracking';
COMMENT ON TABLE finance.accounts_receivable IS 'Customer invoices and payment tracking';
COMMENT ON TABLE finance.budgets IS 'Budget planning and variance analysis';
COMMENT ON TABLE finance.expenses IS 'Employee expense tracking and approval';
COMMENT ON TABLE finance.fixed_assets IS 'Fixed asset register and depreciation tracking';
COMMENT ON TABLE finance.cash_flow IS 'Cash flow statement data';

-- Column comments
COMMENT ON COLUMN finance.general_ledger.balance IS 'Running balance after each transaction';
COMMENT ON COLUMN finance.accounts_payable.status IS 'Invoice status: OPEN, PAID, PARTIAL';
COMMENT ON COLUMN finance.accounts_receivable.status IS 'Invoice status: OPEN, PAID, PARTIAL';
COMMENT ON COLUMN finance.expenses.status IS 'Expense status: PENDING, APPROVED, REJECTED';
COMMENT ON COLUMN finance.fixed_assets.status IS 'Asset status: ACTIVE, INACTIVE, SOLD, DISPOSED';

-- =====================================================
-- CLEANUP (UNCOMMENT TO RESET)
-- =====================================================

/*
-- Drop all objects
DROP DATABASE IF EXISTS FINANCEDB CASCADE;
*/ 