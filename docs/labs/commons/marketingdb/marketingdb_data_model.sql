-- =====================================================
-- MARKETINGDB - Marketing Database
-- Comprehensive marketing data model for Snowflake demonstrations
-- Version: 1.0.0
-- Last Updated: December 2024
-- =====================================================

-- Create database and schema
CREATE OR REPLACE DATABASE MARKETINGDB;
USE DATABASE MARKETINGDB;
CREATE OR REPLACE SCHEMA marketing;

-- =====================================================
-- TABLES
-- =====================================================

-- Customers table
CREATE OR REPLACE TABLE marketing.customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    country VARCHAR(50),
    income_level VARCHAR(20),
    education_level VARCHAR(50),
    occupation VARCHAR(100),
    company VARCHAR(100),
    industry VARCHAR(100),
    customer_segment VARCHAR(50),
    loyalty_tier VARCHAR(20),
    registration_date DATE,
    last_purchase_date DATE,
    total_purchases DECIMAL(10,2),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Campaigns table
CREATE OR REPLACE TABLE marketing.campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    campaign_type VARCHAR(50),
    campaign_category VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    actual_spend DECIMAL(12,2),
    target_audience VARCHAR(200),
    campaign_objective TEXT,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_by VARCHAR(100),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Leads table
CREATE OR REPLACE TABLE marketing.leads (
    lead_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    company VARCHAR(100),
    job_title VARCHAR(100),
    industry VARCHAR(100),
    lead_source VARCHAR(50),
    lead_status VARCHAR(20) DEFAULT 'NEW',
    qualification_score INT,
    assigned_to VARCHAR(100),
    campaign_id INT REFERENCES marketing.campaigns(campaign_id),
    created_date DATE,
    converted_date DATE,
    converted_to_customer_id INT,
    created_timestamp TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_timestamp TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Website Activity table
CREATE OR REPLACE TABLE marketing.website_activity (
    activity_id INT PRIMARY KEY,
    customer_id INT REFERENCES marketing.customers(customer_id),
    session_id VARCHAR(100),
    page_url VARCHAR(500),
    page_title VARCHAR(200),
    referrer_url VARCHAR(500),
    user_agent TEXT,
    ip_address VARCHAR(45),
    device_type VARCHAR(20),
    browser VARCHAR(50),
    operating_system VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    time_on_page INT,
    bounce_rate BOOLEAN,
    conversion_goal VARCHAR(100),
    activity_timestamp TIMESTAMP_LTZ,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Social Media Metrics table
CREATE OR REPLACE TABLE marketing.social_media_metrics (
    metric_id INT PRIMARY KEY,
    platform VARCHAR(50),
    campaign_id INT REFERENCES marketing.campaigns(campaign_id),
    metric_date DATE,
    metric_type VARCHAR(50),
    metric_value INT,
    engagement_rate DECIMAL(5,4),
    reach_count INT,
    impressions_count INT,
    clicks_count INT,
    shares_count INT,
    likes_count INT,
    comments_count INT,
    sentiment_score DECIMAL(3,2),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Ad Spend table
CREATE OR REPLACE TABLE marketing.ad_spend (
    ad_spend_id INT PRIMARY KEY,
    campaign_id INT REFERENCES marketing.campaigns(campaign_id),
    channel VARCHAR(50),
    platform VARCHAR(50),
    ad_type VARCHAR(50),
    spend_date DATE,
    daily_budget DECIMAL(10,2),
    actual_spend DECIMAL(10,2),
    impressions INT,
    clicks INT,
    conversions INT,
    ctr DECIMAL(5,4),
    cpc DECIMAL(8,2),
    cpm DECIMAL(8,2),
    conversion_rate DECIMAL(5,4),
    roi DECIMAL(5,2),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Email Campaigns table
CREATE OR REPLACE TABLE marketing.email_campaigns (
    email_campaign_id INT PRIMARY KEY,
    campaign_id INT REFERENCES marketing.campaigns(campaign_id),
    email_subject VARCHAR(200),
    sender_name VARCHAR(100),
    sender_email VARCHAR(100),
    template_name VARCHAR(100),
    send_date TIMESTAMP_LTZ,
    total_sent INT,
    delivered INT,
    opened INT,
    clicked INT,
    bounced INT,
    unsubscribed INT,
    open_rate DECIMAL(5,4),
    click_rate DECIMAL(5,4),
    bounce_rate DECIMAL(5,4),
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Customer Interactions table
CREATE OR REPLACE TABLE marketing.customer_interactions (
    interaction_id INT PRIMARY KEY,
    customer_id INT REFERENCES marketing.customers(customer_id),
    campaign_id INT REFERENCES marketing.campaigns(campaign_id),
    interaction_type VARCHAR(50),
    interaction_channel VARCHAR(50),
    interaction_date TIMESTAMP_LTZ,
    interaction_duration INT,
    interaction_outcome VARCHAR(50),
    notes TEXT,
    created_date TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Insert customers
INSERT INTO marketing.customers (customer_id, first_name, last_name, email, phone, date_of_birth, gender, city, state, zip_code, income_level, education_level, occupation, company, industry, customer_segment, loyalty_tier, registration_date, total_purchases) VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '555-0101', '1985-03-15', 'Male', 'New York', 'NY', '10001', 'High', 'Bachelor', 'Software Engineer', 'Tech Corp', 'Technology', 'Premium', 'Gold', '2020-01-15', 5000.00),
(2, 'Sarah', 'Johnson', 'sarah.johnson@email.com', '555-0102', '1990-07-22', 'Female', 'Los Angeles', 'CA', '90210', 'Medium', 'Master', 'Marketing Manager', 'Marketing Inc', 'Marketing', 'Standard', 'Silver', '2021-03-20', 2500.00),
(3, 'Michael', 'Brown', 'michael.brown@email.com', '555-0103', '1988-11-08', 'Male', 'Chicago', 'IL', '60601', 'High', 'Bachelor', 'Financial Analyst', 'Finance Co', 'Finance', 'Premium', 'Gold', '2019-08-10', 7500.00),
(4, 'Emily', 'Davis', 'emily.davis@email.com', '555-0104', '1992-04-30', 'Female', 'Houston', 'TX', '77001', 'Medium', 'Bachelor', 'Teacher', 'School District', 'Education', 'Standard', 'Bronze', '2022-01-05', 1200.00),
(5, 'David', 'Wilson', 'david.wilson@email.com', '555-0105', '1987-09-12', 'Male', 'Phoenix', 'AZ', '85001', 'High', 'PhD', 'Research Scientist', 'Research Lab', 'Healthcare', 'Premium', 'Platinum', '2018-12-01', 12000.00),
(6, 'Lisa', 'Anderson', 'lisa.anderson@email.com', '555-0106', '1991-06-18', 'Female', 'Philadelphia', 'PA', '19101', 'Medium', 'Bachelor', 'Nurse', 'Hospital', 'Healthcare', 'Standard', 'Silver', '2021-07-15', 3000.00),
(7, 'Robert', 'Taylor', 'robert.taylor@email.com', '555-0107', '1986-12-25', 'Male', 'San Antonio', 'TX', '78201', 'Low', 'High School', 'Sales Representative', 'Sales Co', 'Sales', 'Basic', 'Bronze', '2022-05-20', 800.00),
(8, 'Jennifer', 'Martinez', 'jennifer.martinez@email.com', '555-0108', '1993-02-14', 'Female', 'San Diego', 'CA', '92101', 'High', 'Master', 'Product Manager', 'Product Inc', 'Technology', 'Premium', 'Gold', '2020-11-30', 6000.00),
(9, 'Christopher', 'Garcia', 'christopher.garcia@email.com', '555-0109', '1989-08-05', 'Male', 'Dallas', 'TX', '75201', 'Medium', 'Bachelor', 'Accountant', 'Accounting Firm', 'Finance', 'Standard', 'Silver', '2021-09-12', 2800.00),
(10, 'Amanda', 'Rodriguez', 'amanda.rodriguez@email.com', '555-0110', '1994-01-20', 'Female', 'San Jose', 'CA', '95101', 'High', 'Bachelor', 'Data Analyst', 'Data Corp', 'Technology', 'Premium', 'Gold', '2021-12-08', 4500.00);

-- Insert campaigns
INSERT INTO marketing.campaigns (campaign_id, campaign_name, campaign_type, campaign_category, start_date, end_date, budget, actual_spend, target_audience, campaign_objective, status, created_by) VALUES
(1, 'Summer Sale 2024', 'Promotional', 'Sales', '2024-06-01', '2024-08-31', 50000.00, 45000.00, 'All customers', 'Increase sales by 25%', 'ACTIVE', 'Marketing Team'),
(2, 'New Product Launch', 'Product Launch', 'Awareness', '2024-09-01', '2024-10-31', 75000.00, 60000.00, 'Premium customers', 'Generate 1000 new leads', 'ACTIVE', 'Product Team'),
(3, 'Holiday Campaign', 'Seasonal', 'Sales', '2024-11-01', '2024-12-31', 100000.00, 85000.00, 'All segments', 'Boost holiday sales', 'PLANNED', 'Marketing Team'),
(4, 'Customer Retention', 'Retention', 'Loyalty', '2024-01-01', '2024-12-31', 30000.00, 25000.00, 'Gold/Platinum customers', 'Reduce churn by 15%', 'ACTIVE', 'Customer Success'),
(5, 'Social Media Boost', 'Digital', 'Awareness', '2024-07-01', '2024-07-31', 20000.00, 18000.00, 'Young professionals', 'Increase brand awareness', 'COMPLETED', 'Digital Team');

-- Insert leads
INSERT INTO marketing.leads (lead_id, first_name, last_name, email, phone, company, job_title, industry, lead_source, lead_status, qualification_score, assigned_to, campaign_id, created_date) VALUES
(1, 'Alex', 'Thompson', 'alex.thompson@company.com', '555-0201', 'Tech Startup', 'CTO', 'Technology', 'Website', 'QUALIFIED', 85, 'Sales Rep A', 2, '2024-09-15'),
(2, 'Maria', 'Gonzalez', 'maria.gonzalez@company.com', '555-0202', 'Marketing Agency', 'Director', 'Marketing', 'LinkedIn', 'NEW', 65, 'Sales Rep B', 1, '2024-09-20'),
(3, 'James', 'Lee', 'james.lee@company.com', '555-0203', 'Financial Services', 'Manager', 'Finance', 'Referral', 'CONTACTED', 75, 'Sales Rep A', 4, '2024-09-18'),
(4, 'Rachel', 'White', 'rachel.white@company.com', '555-0204', 'Healthcare Org', 'Administrator', 'Healthcare', 'Trade Show', 'QUALIFIED', 90, 'Sales Rep C', 2, '2024-09-22'),
(5, 'Thomas', 'Clark', 'thomas.clark@company.com', '555-0205', 'Manufacturing Co', 'Engineer', 'Manufacturing', 'Website', 'NEW', 55, 'Sales Rep B', 1, '2024-09-25);

-- Insert website activity
INSERT INTO marketing.website_activity (activity_id, customer_id, session_id, page_url, page_title, referrer_url, device_type, browser, country, city, time_on_page, bounce_rate, activity_timestamp) VALUES
(1, 1, 'sess_001', '/products/software', 'Software Products', 'google.com', 'Desktop', 'Chrome', 'United States', 'New York', 180, FALSE, '2024-09-15 10:30:00'),
(2, 2, 'sess_002', '/about-us', 'About Our Company', 'linkedin.com', 'Mobile', 'Safari', 'United States', 'Los Angeles', 45, TRUE, '2024-09-15 14:20:00'),
(3, 3, 'sess_003', '/pricing', 'Pricing Plans', 'facebook.com', 'Desktop', 'Firefox', 'United States', 'Chicago', 300, FALSE, '2024-09-15 16:45:00'),
(4, 4, 'sess_004', '/contact', 'Contact Us', 'direct', 'Tablet', 'Chrome', 'United States', 'Houston', 120, FALSE, '2024-09-16 09:15:00'),
(5, 5, 'sess_005', '/blog', 'Company Blog', 'twitter.com', 'Desktop', 'Edge', 'United States', 'Phoenix', 240, FALSE, '2024-09-16 11:30:00);

-- Insert social media metrics
INSERT INTO marketing.social_media_metrics (metric_id, platform, campaign_id, metric_date, metric_type, metric_value, engagement_rate, reach_count, impressions_count, clicks_count, shares_count, likes_count, comments_count, sentiment_score) VALUES
(1, 'Facebook', 1, '2024-09-15', 'Engagement', 1250, 0.045, 25000, 50000, 500, 75, 800, 375, 0.75),
(2, 'Instagram', 1, '2024-09-15', 'Reach', 15000, 0.032, 15000, 30000, 300, 45, 600, 255, 0.82),
(3, 'Twitter', 2, '2024-09-15', 'Impressions', 8000, 0.028, 8000, 8000, 200, 30, 400, 170, 0.68),
(4, 'LinkedIn', 2, '2024-09-15', 'Clicks', 150, 0.015, 10000, 15000, 150, 20, 300, 130, 0.85),
(5, 'Facebook', 5, '2024-09-15', 'Sentiment', 0.78, 0.038, 12000, 25000, 400, 60, 700, 340, 0.78);

-- Insert ad spend
INSERT INTO marketing.ad_spend (ad_spend_id, campaign_id, channel, platform, ad_type, spend_date, daily_budget, actual_spend, impressions, clicks, conversions, ctr, cpc, cpm, conversion_rate, roi) VALUES
(1, 1, 'Digital', 'Google Ads', 'Search', '2024-09-15', 500.00, 450.00, 50000, 500, 25, 0.010, 0.90, 9.00, 0.050, 2.50),
(2, 1, 'Digital', 'Facebook Ads', 'Display', '2024-09-15', 300.00, 280.00, 75000, 300, 15, 0.004, 0.93, 3.73, 0.050, 1.80),
(3, 2, 'Digital', 'LinkedIn Ads', 'Sponsored Content', '2024-09-15', 400.00, 380.00, 25000, 200, 20, 0.008, 1.90, 15.20, 0.100, 3.20),
(4, 3, 'Digital', 'Google Ads', 'Video', '2024-09-15', 600.00, 550.00, 100000, 800, 40, 0.008, 0.69, 5.50, 0.050, 2.80),
(5, 4, 'Digital', 'Instagram Ads', 'Story', '2024-09-15', 200.00, 180.00, 40000, 250, 12, 0.006, 0.72, 4.50, 0.048, 1.60);

-- Insert email campaigns
INSERT INTO marketing.email_campaigns (email_campaign_id, campaign_id, email_subject, sender_name, sender_email, template_name, send_date, total_sent, delivered, opened, clicked, bounced, unsubscribed, open_rate, click_rate, bounce_rate) VALUES
(1, 1, 'Summer Sale - 50% Off Everything!', 'Marketing Team', 'marketing@company.com', 'Summer Sale Template', '2024-09-15 10:00:00', 10000, 9800, 2450, 490, 200, 50, 0.245, 0.049, 0.020),
(2, 2, 'New Product Launch - Exclusive Preview', 'Product Team', 'product@company.com', 'Product Launch Template', '2024-09-16 09:00:00', 5000, 4900, 1470, 245, 100, 25, 0.294, 0.049, 0.020),
(3, 4, 'Thank You for Being a Valued Customer', 'Customer Success', 'success@company.com', 'Thank You Template', '2024-09-17 14:00:00', 2000, 1980, 792, 158, 20, 10, 0.396, 0.079, 0.010),
(4, 1, 'Last Chance - Summer Sale Ends Tomorrow!', 'Marketing Team', 'marketing@company.com', 'Urgency Template', '2024-09-18 11:00:00', 8000, 7840, 1568, 235, 160, 40, 0.196, 0.029, 0.020),
(5, 3, 'Holiday Special - Early Access for VIP Customers', 'Marketing Team', 'marketing@company.com', 'Holiday Template', '2024-09-19 10:30:00', 3000, 2940, 882, 147, 60, 15, 0.294, 0.049, 0.020);

-- Insert customer interactions
INSERT INTO marketing.customer_interactions (interaction_id, customer_id, campaign_id, interaction_type, interaction_channel, interaction_date, interaction_duration, interaction_outcome) VALUES
(1, 1, 1, 'Email Open', 'Email', '2024-09-15 10:30:00', 0, 'Engaged'),
(2, 2, 1, 'Website Visit', 'Website', '2024-09-15 14:20:00', 180, 'Converted'),
(3, 3, 2, 'Social Media Engagement', 'Facebook', '2024-09-15 16:45:00', 0, 'Engaged'),
(4, 4, 4, 'Email Click', 'Email', '2024-09-16 09:15:00', 0, 'Converted'),
(5, 5, 3, 'Ad Click', 'Google Ads', '2024-09-16 11:30:00', 0, 'Converted');

-- =====================================================
-- VIEWS
-- =====================================================

-- Customer Segmentation View
CREATE OR REPLACE VIEW marketing.customer_segmentation AS
SELECT 
    customer_segment,
    loyalty_tier,
    COUNT(*) as customer_count,
    AVG(total_purchases) as avg_purchases,
    AVG(DATEDIFF('day', registration_date, CURRENT_DATE())) as avg_days_since_registration,
    SUM(total_purchases) as total_revenue
FROM marketing.customers
GROUP BY customer_segment, loyalty_tier
ORDER BY total_revenue DESC;

-- Campaign Performance View
CREATE OR REPLACE VIEW marketing.campaign_performance AS
SELECT 
    c.campaign_id,
    c.campaign_name,
    c.campaign_type,
    c.budget,
    c.actual_spend,
    (c.actual_spend / c.budget) * 100 as budget_utilization_percent,
    COUNT(l.lead_id) as total_leads,
    COUNT(CASE WHEN l.lead_status = 'QUALIFIED' THEN 1 END) as qualified_leads,
    COUNT(CASE WHEN l.lead_status = 'CONVERTED' THEN 1 END) as converted_leads,
    AVG(l.qualification_score) as avg_qualification_score
FROM marketing.campaigns c
LEFT JOIN marketing.leads l ON c.campaign_id = l.campaign_id
GROUP BY c.campaign_id, c.campaign_name, c.campaign_type, c.budget, c.actual_spend
ORDER BY c.actual_spend DESC;

-- Digital Marketing ROI View
CREATE OR REPLACE VIEW marketing.digital_marketing_roi AS
SELECT 
    c.campaign_name,
    ads.channel,
    ads.platform,
    ads.actual_spend,
    ads.impressions,
    ads.clicks,
    ads.conversions,
    ads.ctr,
    ads.cpc,
    ads.cpm,
    ads.conversion_rate,
    ads.roi,
    (ads.conversions * 100) as estimated_revenue
FROM marketing.ad_spend ads
JOIN marketing.campaigns c ON ads.campaign_id = c.campaign_id
ORDER BY ads.roi DESC;

-- Customer Journey View
CREATE OR REPLACE VIEW marketing.customer_journey AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name as customer_name,
    c.customer_segment,
    c.loyalty_tier,
    COUNT(ci.interaction_id) as total_interactions,
    COUNT(DISTINCT ci.campaign_id) as campaigns_engaged,
    COUNT(wa.activity_id) as website_visits,
    MAX(ci.interaction_date) as last_interaction_date
FROM marketing.customers c
LEFT JOIN marketing.customer_interactions ci ON c.customer_id = ci.customer_id
LEFT JOIN marketing.website_activity wa ON c.customer_id = wa.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.customer_segment, c.loyalty_tier
ORDER BY total_interactions DESC;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Get high-value customers
CREATE OR REPLACE PROCEDURE marketing.get_high_value_customers(min_purchases DECIMAL)
RETURNS TABLE (
    customer_id INT,
    customer_name VARCHAR,
    customer_segment VARCHAR,
    loyalty_tier VARCHAR,
    total_purchases DECIMAL(10,2),
    days_since_registration INT
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            c.customer_id,
            c.first_name || ' ' || c.last_name as customer_name,
            c.customer_segment,
            c.loyalty_tier,
            c.total_purchases,
            DATEDIFF('day', c.registration_date, CURRENT_DATE()) as days_since_registration
        FROM marketing.customers c
        WHERE c.total_purchases >= min_purchases
        ORDER BY c.total_purchases DESC
    );
END;
$$;

-- Get campaign ROI analysis
CREATE OR REPLACE PROCEDURE marketing.get_campaign_roi(campaign_id_param INT)
RETURNS TABLE (
    campaign_name VARCHAR,
    total_spend DECIMAL(12,2),
    total_revenue DECIMAL(12,2),
    roi DECIMAL(5,2),
    lead_count INT,
    conversion_count INT,
    conversion_rate DECIMAL(5,4)
)
LANGUAGE SQL
AS
$$
BEGIN
    RETURN TABLE (
        SELECT 
            c.campaign_name,
            c.actual_spend as total_spend,
            (COUNT(l.lead_id) * 100) as total_revenue,
            ((COUNT(l.lead_id) * 100) / c.actual_spend) as roi,
            COUNT(l.lead_id) as lead_count,
            COUNT(CASE WHEN l.lead_status = 'CONVERTED' THEN 1 END) as conversion_count,
            COUNT(CASE WHEN l.lead_status = 'CONVERTED' THEN 1 END) / COUNT(l.lead_id) as conversion_rate
        FROM marketing.campaigns c
        LEFT JOIN marketing.leads l ON c.campaign_id = l.campaign_id
        WHERE c.campaign_id = campaign_id_param
        GROUP BY c.campaign_name, c.actual_spend
    );
END;
$$;

-- =====================================================
-- TAGS FOR DATA GOVERNANCE
-- =====================================================

-- Create tags
CREATE OR REPLACE TAG marketing.PII_TAG;
CREATE OR REPLACE TAG marketing.CUSTOMER_DATA_TAG;
CREATE OR REPLACE TAG marketing.MARKETING_DATA_TAG;

-- Apply tags to sensitive columns
ALTER TABLE marketing.customers MODIFY COLUMN email SET TAG marketing.PII_TAG = 'EMAIL';
ALTER TABLE marketing.customers MODIFY COLUMN phone SET TAG marketing.PII_TAG = 'PHONE';
ALTER TABLE marketing.customers MODIFY COLUMN date_of_birth SET TAG marketing.PII_TAG = 'DATE_OF_BIRTH';
ALTER TABLE marketing.leads MODIFY COLUMN email SET TAG marketing.PII_TAG = 'EMAIL';
ALTER TABLE marketing.leads MODIFY COLUMN phone SET TAG marketing.PII_TAG = 'PHONE';

-- =====================================================
-- COMMENTS
-- =====================================================

-- Table comments
COMMENT ON TABLE marketing.customers IS 'Customer master data with segmentation and loyalty information';
COMMENT ON TABLE marketing.campaigns IS 'Marketing campaign details and performance tracking';
COMMENT ON TABLE marketing.leads IS 'Lead management and qualification tracking';
COMMENT ON TABLE marketing.website_activity IS 'Website visitor activity and behavior tracking';
COMMENT ON TABLE marketing.social_media_metrics IS 'Social media campaign performance metrics';
COMMENT ON TABLE marketing.ad_spend IS 'Digital advertising spend and performance data';
COMMENT ON TABLE marketing.email_campaigns IS 'Email campaign performance and engagement metrics';
COMMENT ON TABLE marketing.customer_interactions IS 'Customer interaction history across all channels';

-- Column comments
COMMENT ON COLUMN marketing.customers.customer_segment IS 'Customer segmentation: Basic, Standard, Premium';
COMMENT ON COLUMN marketing.customers.loyalty_tier IS 'Loyalty tier: Bronze, Silver, Gold, Platinum';
COMMENT ON COLUMN marketing.leads.lead_status IS 'Lead status: NEW, CONTACTED, QUALIFIED, CONVERTED, LOST';
COMMENT ON COLUMN marketing.leads.qualification_score IS 'Lead qualification score (0-100)';
COMMENT ON COLUMN marketing.website_activity.bounce_rate IS 'Whether user left without further interaction';
COMMENT ON COLUMN marketing.social_media_metrics.sentiment_score IS 'Sentiment analysis score (-1 to 1)';

-- =====================================================
-- CLEANUP (UNCOMMENT TO RESET)
-- =====================================================

/*
-- Drop all objects
DROP DATABASE IF EXISTS MARKETINGDB CASCADE;
*/ 