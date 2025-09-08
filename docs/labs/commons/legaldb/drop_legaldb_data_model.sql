-- Drop tables
DROP TABLE IF EXISTS legal.contracts;
DROP TABLE IF EXISTS legal.legal_cases;
DROP TABLE IF EXISTS legal.legal_expenses;
DROP TABLE IF EXISTS legal.case_documents;

-- Drop tags
DROP TAG IF EXISTS legal.CONFIDENTIAL_DATA_TAG;
DROP TAG IF EXISTS legal.PRIVILEGED_DATA_TAG;
DROP TAG IF EXISTS legal.PII_TAG;
DROP TAG IF EXISTS legal.FINANCIAL_DATA_TAG;

-- Drop schema and database
DROP SCHEMA IF EXISTS legal;
DROP DATABASE IF EXISTS legaldb; 