-- Drop tables
DROP TABLE IF EXISTS finance.chart_of_accounts;
DROP TABLE IF EXISTS finance.general_ledger;
DROP TABLE IF EXISTS finance.accounts_payable;
DROP TABLE IF EXISTS finance.accounts_receivable;
DROP TABLE IF EXISTS finance.expenses;

-- Drop tags
DROP TAG IF EXISTS finance.FINANCIAL_DATA_TAG;
DROP TAG IF EXISTS finance.SENSITIVE_DATA_TAG;
DROP TAG IF EXISTS finance.PII_TAG;

-- Drop schema and database
DROP SCHEMA IF EXISTS finance;
DROP DATABASE IF EXISTS financedb; 