# MARKETINGDB - Marketing Database

## Overview

The MARKETINGDB data model is a comprehensive marketing management system designed for Snowflake demonstrations. It includes customer segmentation, campaign management, lead tracking, digital marketing metrics, website analytics, and multi-channel marketing performance analysis.

## Features

### Core Marketing Functions
- **Customer Management**: Complete customer profiles with segmentation and loyalty tiers
- **Campaign Management**: Multi-channel campaign planning and execution
- **Lead Management**: Lead generation, qualification, and conversion tracking
- **Digital Marketing**: Social media, email, and advertising campaign metrics
- **Website Analytics**: Visitor behavior and conversion tracking
- **Customer Journey**: Multi-touchpoint interaction tracking
- **ROI Analysis**: Campaign performance and return on investment measurement

### Advanced Features
- **Multi-channel Integration**: Unified view across all marketing channels
- **Customer Segmentation**: Advanced customer profiling and targeting
- **Real-time Analytics**: Live campaign performance monitoring
- **Predictive Analytics**: Customer behavior and campaign performance forecasting
- **Views**: Pre-built marketing analytics views
- **Stored Procedures**: Business logic for marketing analysis and reporting
- **Sample Data**: Realistic marketing data for testing and demonstration

## Database Structure

```
MARKETINGDB
└── marketing (schema)
    ├── customers
    ├── campaigns
    ├── leads
    ├── website_activity
    ├── social_media_metrics
    ├── ad_spend
    ├── email_campaigns
    ├── customer_interactions
    ├── customer_segmentation (view)
    ├── campaign_performance (view)
    ├── digital_marketing_roi (view)
    ├── customer_journey (view)
    ├── get_high_value_customers() (stored procedure)
    └── get_campaign_roi() (stored procedure)
```

## Tables

### customers
- **customer_id** (INT, Primary Key): Unique customer identifier
- **first_name** (VARCHAR(50)): Customer's first name
- **last_name** (VARCHAR(50)): Customer's last name
- **email** (VARCHAR(100)): Customer email address
- **phone** (VARCHAR(20)): Customer phone number
- **date_of_birth** (DATE): Customer date of birth
- **gender** (VARCHAR(10)): Customer gender
- **address** (VARCHAR(200)): Customer address
- **city** (VARCHAR(50)): Customer city
- **state** (VARCHAR(2)): Customer state
- **zip_code** (VARCHAR(10)): Customer zip code
- **country** (VARCHAR(50)): Customer country
- **income_level** (VARCHAR(20)): Customer income level
- **education_level** (VARCHAR(50)): Customer education level
- **occupation** (VARCHAR(100)): Customer occupation
- **company** (VARCHAR(100)): Customer company
- **industry** (VARCHAR(100)): Customer industry
- **customer_segment** (VARCHAR(50)): Customer segment classification
- **loyalty_tier** (VARCHAR(20)): Customer loyalty tier
- **registration_date** (DATE): Customer registration date
- **last_purchase_date** (DATE): Last purchase date
- **total_purchases** (DECIMAL(10,2)): Total purchase amount
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### campaigns
- **campaign_id** (INT, Primary Key): Unique campaign identifier
- **campaign_name** (VARCHAR(100)): Campaign name
- **campaign_type** (VARCHAR(50)): Campaign type
- **campaign_category** (VARCHAR(50)): Campaign category
- **start_date** (DATE): Campaign start date
- **end_date** (DATE): Campaign end date
- **budget** (DECIMAL(12,2)): Campaign budget
- **actual_spend** (DECIMAL(12,2)): Actual campaign spend
- **target_audience** (VARCHAR(200)): Target audience description
- **campaign_objective** (TEXT): Campaign objective
- **status** (VARCHAR(20)): Campaign status
- **created_by** (VARCHAR(100)): Campaign creator
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_date** (TIMESTAMP_LTZ): Record update timestamp

### leads
- **lead_id** (INT, Primary Key): Unique lead identifier
- **first_name** (VARCHAR(50)): Lead's first name
- **last_name** (VARCHAR(50)): Lead's last name
- **email** (VARCHAR(100)): Lead email address
- **phone** (VARCHAR(20)): Lead phone number
- **company** (VARCHAR(100)): Lead company
- **job_title** (VARCHAR(100)): Lead job title
- **industry** (VARCHAR(100)): Lead industry
- **lead_source** (VARCHAR(50)): Lead source
- **lead_status** (VARCHAR(20)): Lead status
- **qualification_score** (INT): Lead qualification score
- **assigned_to** (VARCHAR(100)): Assigned sales representative
- **campaign_id** (INT, Foreign Key): Reference to campaigns table
- **created_date** (DATE): Lead creation date
- **converted_date** (DATE): Lead conversion date
- **converted_to_customer_id** (INT): Converted customer ID
- **created_timestamp** (TIMESTAMP_LTZ): Record creation timestamp
- **updated_timestamp** (TIMESTAMP_LTZ): Record update timestamp

### website_activity
- **activity_id** (INT, Primary Key): Unique activity identifier
- **customer_id** (INT, Foreign Key): Reference to customers table
- **session_id** (VARCHAR(100)): Session identifier
- **page_url** (VARCHAR(500)): Page URL
- **page_title** (VARCHAR(200)): Page title
- **referrer_url** (VARCHAR(500)): Referrer URL
- **user_agent** (TEXT): User agent string
- **ip_address** (VARCHAR(45)): IP address
- **device_type** (VARCHAR(20)): Device type
- **browser** (VARCHAR(50)): Browser type
- **operating_system** (VARCHAR(50)): Operating system
- **country** (VARCHAR(50)): Visitor country
- **city** (VARCHAR(50)): Visitor city
- **time_on_page** (INT): Time spent on page (seconds)
- **bounce_rate** (BOOLEAN): Bounce indicator
- **conversion_goal** (VARCHAR(100)): Conversion goal
- **activity_timestamp** (TIMESTAMP_LTZ): Activity timestamp
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

### social_media_metrics
- **metric_id** (INT, Primary Key): Unique metric identifier
- **platform** (VARCHAR(50)): Social media platform
- **campaign_id** (INT, Foreign Key): Reference to campaigns table
- **metric_date** (DATE): Metric date
- **metric_type** (VARCHAR(50)): Metric type
- **metric_value** (INT): Metric value
- **engagement_rate** (DECIMAL(5,4)): Engagement rate
- **reach_count** (INT): Reach count
- **impressions_count** (INT): Impressions count
- **clicks_count** (INT): Clicks count
- **shares_count** (INT): Shares count
- **likes_count** (INT): Likes count
- **comments_count** (INT): Comments count
- **sentiment_score** (DECIMAL(3,2)): Sentiment analysis score
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

### ad_spend
- **ad_spend_id** (INT, Primary Key): Unique ad spend identifier
- **campaign_id** (INT, Foreign Key): Reference to campaigns table
- **channel** (VARCHAR(50)): Advertising channel
- **platform** (VARCHAR(50)): Advertising platform
- **ad_type** (VARCHAR(50)): Advertisement type
- **spend_date** (DATE): Spend date
- **daily_budget** (DECIMAL(10,2)): Daily budget
- **actual_spend** (DECIMAL(10,2)): Actual spend
- **impressions** (INT): Impressions count
- **clicks** (INT): Clicks count
- **conversions** (INT): Conversions count
- **ctr** (DECIMAL(5,4)): Click-through rate
- **cpc** (DECIMAL(8,2)): Cost per click
- **cpm** (DECIMAL(8,2)): Cost per thousand impressions
- **conversion_rate** (DECIMAL(5,4)): Conversion rate
- **roi** (DECIMAL(5,2)): Return on investment
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

### email_campaigns
- **email_campaign_id** (INT, Primary Key): Unique email campaign identifier
- **campaign_id** (INT, Foreign Key): Reference to campaigns table
- **email_subject** (VARCHAR(200)): Email subject line
- **sender_name** (VARCHAR(100)): Sender name
- **sender_email** (VARCHAR(100)): Sender email
- **template_name** (VARCHAR(100)): Email template name
- **send_date** (TIMESTAMP_LTZ): Send date and time
- **total_sent** (INT): Total emails sent
- **delivered** (INT): Delivered emails
- **opened** (INT): Opened emails
- **clicked** (INT): Clicked emails
- **bounced** (INT): Bounced emails
- **unsubscribed** (INT): Unsubscribed emails
- **open_rate** (DECIMAL(5,4)): Open rate
- **click_rate** (DECIMAL(5,4)): Click rate
- **bounce_rate** (DECIMAL(5,4)): Bounce rate
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

### customer_interactions
- **interaction_id** (INT, Primary Key): Unique interaction identifier
- **customer_id** (INT, Foreign Key): Reference to customers table
- **campaign_id** (INT, Foreign Key): Reference to campaigns table
- **interaction_type** (VARCHAR(50)): Interaction type
- **interaction_channel** (VARCHAR(50)): Interaction channel
- **interaction_date** (TIMESTAMP_LTZ): Interaction date and time
- **interaction_duration** (INT): Interaction duration (seconds)
- **interaction_outcome** (VARCHAR(50)): Interaction outcome
- **notes** (TEXT): Interaction notes
- **created_date** (TIMESTAMP_LTZ): Record creation timestamp

## Views

### customer_segmentation
Provides customer segmentation analysis including:
- Customer count by segment and loyalty tier
- Average purchases and revenue by segment
- Customer lifecycle metrics

### campaign_performance
Shows campaign performance metrics including:
- Budget utilization and spend analysis
- Lead generation and conversion metrics
- Campaign effectiveness indicators

### digital_marketing_roi
Provides digital marketing ROI analysis including:
- Campaign performance across channels
- Cost metrics and conversion rates
- Return on investment calculations

### customer_journey
Shows customer journey analysis including:
- Multi-channel interaction tracking
- Campaign engagement patterns
- Customer lifecycle stages

## Stored Procedures

### get_high_value_customers(min_purchases DECIMAL)
Returns high-value customers, including:
- Customer details and segmentation
- Purchase history and loyalty information
- Customer lifecycle metrics

### get_campaign_roi(campaign_id_param INT)
Returns campaign ROI analysis, including:
- Campaign performance metrics
- Revenue and cost analysis
- Conversion rates and effectiveness

## Data Governance

### PII Tags
The following columns are tagged for Personally Identifiable Information:
- **email**: Tagged as EMAIL
- **phone**: Tagged as PHONE
- **date_of_birth**: Tagged as DATE_OF_BIRTH

### Comments and Documentation
- Comprehensive table and column comments
- Clear documentation of marketing relationships
- Usage examples and best practices

## Sample Data

The model includes realistic sample data for:
- 10 customers across different segments and loyalty tiers
- 5 marketing campaigns across different types and categories
- 5 leads with various qualification scores and statuses
- 5 website activity records with visitor behavior data
- 5 social media metrics across different platforms
- 5 ad spend records with performance metrics
- 5 email campaigns with engagement metrics
- 5 customer interactions across different channels

## Usage Examples

### Customer Analysis
```sql
-- Get customer segmentation
SELECT * FROM marketing.customer_segmentation
ORDER BY total_revenue DESC;
```

### Campaign Performance
```sql
-- Analyze campaign performance
SELECT * FROM marketing.campaign_performance
ORDER BY budget_utilization_percent DESC;
```

### Digital Marketing ROI
```sql
-- Analyze digital marketing ROI
SELECT * FROM marketing.digital_marketing_roi
ORDER BY roi DESC;
```

### Using Stored Procedures
```sql
-- Get high-value customers
CALL marketing.get_high_value_customers(5000.00);

-- Get campaign ROI
CALL marketing.get_campaign_roi(1);
```

## Demo Scenarios

### 1. Customer Segmentation
- Analyze customer segments and loyalty tiers
- Identify high-value customer characteristics
- Plan targeted marketing strategies

### 2. Campaign Management
- Track campaign performance across channels
- Analyze budget utilization and ROI
- Optimize campaign effectiveness

### 3. Lead Management
- Monitor lead generation and qualification
- Track conversion rates and sales pipeline
- Optimize lead nurturing processes

### 4. Digital Marketing Analytics
- Analyze social media campaign performance
- Track advertising ROI and effectiveness
- Monitor email campaign engagement

### 5. Customer Journey Analysis
- Map customer touchpoints across channels
- Identify conversion optimization opportunities
- Personalize customer experiences

## Setup Instructions

1. Run the complete `marketingdb_data_model.sql` script in Snowflake
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

- **Version 1.0.0** (12/2024): Complete marketing data model with comprehensive features
- Based on enterprise marketing management best practices

## Related Resources

- Snowflake Marketing Analytics: https://docs.snowflake.com/
- Marketing Data Governance Best Practices: https://docs.snowflake.com/ 