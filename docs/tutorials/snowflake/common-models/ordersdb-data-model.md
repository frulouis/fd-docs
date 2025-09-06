# OrdersDB Data Model

An e-commerce focused data model for Snowflake demos and tutorials, featuring customer orders, products, inventory, and payment data with retail analytics capabilities.

## Overview

The OrdersDB data model provides a realistic e-commerce environment for learning Snowflake capabilities including:

![OrdersDB E-commerce Architecture](../../assets/images/ordersdb-architecture.png)

*Figure 1: OrdersDB E-commerce Data Model - Complete e-commerce database schema showing relationships between Customer, Product, Order, and Inventory tables*
- **Retail Analytics** - Sales performance and customer behavior analysis
- **Inventory Management** - Product stock and supply chain tracking
- **Payment Processing** - Transaction and financial data handling
- **Customer Journey** - Order history and purchase patterns
- **Product Catalog** - Comprehensive product information management

## Prerequisites

- Snowflake account with appropriate privileges
- Understanding of e-commerce data structures
- Basic knowledge of retail analytics concepts

## Data Model Structure

### Core Tables

#### Customer Table
```sql
CREATE OR REPLACE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(200),
    City VARCHAR(100),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Country VARCHAR(50),
    RegistrationDate DATE,
    CustomerTier VARCHAR(20),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Product Table
```sql
CREATE OR REPLACE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(200),
    Category VARCHAR(100),
    SubCategory VARCHAR(100),
    Brand VARCHAR(100),
    Price DECIMAL(10, 2),
    Cost DECIMAL(10, 2),
    SKU VARCHAR(50),
    Description TEXT,
    Weight DECIMAL(8, 2),
    Dimensions VARCHAR(100),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Inventory Table
```sql
CREATE OR REPLACE TABLE Inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT REFERENCES Product(ProductID),
    WarehouseID INT,
    QuantityOnHand INT,
    QuantityReserved INT,
    ReorderPoint INT,
    MaxStockLevel INT,
    LastRestocked DATE,
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### Order Table
```sql
CREATE OR REPLACE TABLE Order (
    OrderID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    OrderDate TIMESTAMP_LTZ,
    OrderStatus VARCHAR(20),
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(20),
    ShippingAddress VARCHAR(200),
    BillingAddress VARCHAR(200),
    SubTotal DECIMAL(10, 2),
    TaxAmount DECIMAL(10, 2),
    ShippingCost DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

#### OrderItem Table
```sql
CREATE OR REPLACE TABLE OrderItem (
    OrderItemID INT PRIMARY KEY,
    OrderID INT REFERENCES Order(OrderID),
    ProductID INT REFERENCES Product(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    TotalPrice DECIMAL(10, 2),
    LoadDate TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

## E-commerce Analytics Functions

### Customer Lifetime Value
```sql
CREATE OR REPLACE FUNCTION calculate_customer_lifetime_value(customer_id INT)
RETURNS DECIMAL(10, 2)
LANGUAGE SQL
AS $$
    SELECT COALESCE(SUM(TotalAmount), 0)
    FROM Order
    WHERE CustomerID = customer_id
    AND OrderStatus = 'Completed'
$$;
```

### Product Profitability
```sql
CREATE OR REPLACE FUNCTION calculate_product_profit(product_id INT)
RETURNS DECIMAL(10, 2)
LANGUAGE SQL
AS $$
    SELECT (p.Price - p.Cost) * COALESCE(SUM(oi.Quantity), 0)
    FROM Product p
    LEFT JOIN OrderItem oi ON p.ProductID = oi.ProductID
    LEFT JOIN Order o ON oi.OrderID = o.OrderID
    WHERE p.ProductID = product_id
    AND o.OrderStatus = 'Completed'
    GROUP BY p.ProductID, p.Price, p.Cost
$$;
```

### Inventory Turnover
```sql
CREATE OR REPLACE FUNCTION calculate_inventory_turnover(product_id INT, months_back INT)
RETURNS DECIMAL(8, 2)
LANGUAGE SQL
AS $$
    SELECT COALESCE(SUM(oi.Quantity), 0) / NULLIF(MAX(i.QuantityOnHand), 0)
    FROM Inventory i
    LEFT JOIN OrderItem oi ON i.ProductID = oi.ProductID
    LEFT JOIN Order o ON oi.OrderID = o.OrderID
    WHERE i.ProductID = product_id
    AND o.OrderDate >= DATEADD('month', -months_back, CURRENT_DATE())
    GROUP BY i.ProductID
$$;
```

## Retail Analytics Views

### Top Selling Products
```sql
CREATE OR REPLACE VIEW top_selling_products AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Brand,
    SUM(oi.Quantity) as total_quantity_sold,
    SUM(oi.TotalPrice) as total_revenue,
    calculate_product_profit(p.ProductID) as total_profit
FROM Product p
JOIN OrderItem oi ON p.ProductID = oi.ProductID
JOIN Order o ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Completed'
GROUP BY p.ProductID, p.ProductName, p.Category, p.Brand
ORDER BY total_revenue DESC;
```

### Customer Segmentation
```sql
CREATE OR REPLACE VIEW customer_segments AS
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    calculate_customer_lifetime_value(c.CustomerID) as lifetime_value,
    COUNT(o.OrderID) as total_orders,
    MAX(o.OrderDate) as last_order_date,
    CASE
        WHEN calculate_customer_lifetime_value(c.CustomerID) >= 1000 THEN 'VIP'
        WHEN calculate_customer_lifetime_value(c.CustomerID) >= 500 THEN 'High Value'
        WHEN calculate_customer_lifetime_value(c.CustomerID) >= 100 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_segment
FROM Customer c
LEFT JOIN Order o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email
ORDER BY lifetime_value DESC;
```

### Inventory Alerts
```sql
CREATE OR REPLACE VIEW inventory_alerts AS
SELECT 
    i.InventoryID,
    p.ProductName,
    p.SKU,
    i.QuantityOnHand,
    i.QuantityReserved,
    i.ReorderPoint,
    i.MaxStockLevel,
    CASE
        WHEN i.QuantityOnHand <= i.ReorderPoint THEN 'Reorder Needed'
        WHEN i.QuantityOnHand >= i.MaxStockLevel THEN 'Overstocked'
        ELSE 'Normal'
    END as alert_status
FROM Inventory i
JOIN Product p ON i.ProductID = p.ProductID
WHERE i.QuantityOnHand <= i.ReorderPoint OR i.QuantityOnHand >= i.MaxStockLevel
ORDER BY alert_status, i.QuantityOnHand;
```

## E-commerce Stored Procedures

### Process Order
```sql
CREATE OR REPLACE PROCEDURE process_order(
    customer_id INT,
    product_ids ARRAY,
    quantities ARRAY,
    payment_method VARCHAR,
    shipping_address VARCHAR
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    new_order_id INT;
    total_amount DECIMAL(10, 2) := 0;
    i INT;
BEGIN
    -- Generate new order ID
    SELECT COALESCE(MAX(OrderID), 0) + 1 INTO new_order_id FROM Order;
    
    -- Calculate total amount
    FOR i IN 1 TO ARRAY_SIZE(product_ids) DO
        SET total_amount = total_amount + (
            SELECT Price * quantities[i] 
            FROM Product 
            WHERE ProductID = product_ids[i]
        );
    END FOR;
    
    -- Create order
    INSERT INTO Order (OrderID, CustomerID, OrderDate, OrderStatus, 
                      PaymentMethod, PaymentStatus, ShippingAddress, 
                      SubTotal, TotalAmount)
    VALUES (new_order_id, customer_id, CURRENT_TIMESTAMP(), 'Pending', 
            payment_method, 'Pending', shipping_address, 
            total_amount, total_amount);
    
    -- Add order items
    FOR i IN 1 TO ARRAY_SIZE(product_ids) DO
        INSERT INTO OrderItem (OrderItemID, OrderID, ProductID, Quantity, 
                              UnitPrice, TotalPrice)
        SELECT 
            COALESCE(MAX(OrderItemID), 0) + i,
            new_order_id,
            product_ids[i],
            quantities[i],
            Price,
            Price * quantities[i]
        FROM Product 
        WHERE ProductID = product_ids[i];
    END FOR;
    
    RETURN 'Order ' || new_order_id || ' created successfully';
END;
$$;
```

### Update Inventory
```sql
CREATE OR REPLACE PROCEDURE update_inventory(
    product_id INT,
    quantity_change INT,
    operation VARCHAR
)
RETURNS STRING
LANGUAGE SQL
AS $$
DECLARE
    current_quantity INT;
    new_quantity INT;
BEGIN
    -- Get current quantity
    SELECT QuantityOnHand INTO current_quantity
    FROM Inventory
    WHERE ProductID = product_id;
    
    -- Calculate new quantity
    IF operation = 'ADD' THEN
        SET new_quantity = current_quantity + quantity_change;
    ELSIF operation = 'SUBTRACT' THEN
        SET new_quantity = GREATEST(0, current_quantity - quantity_change);
    ELSE
        RETURN 'Invalid operation. Use ADD or SUBTRACT';
    END IF;
    
    -- Update inventory
    UPDATE Inventory
    SET QuantityOnHand = new_quantity,
        LastRestocked = CURRENT_DATE()
    WHERE ProductID = product_id;
    
    RETURN 'Inventory updated. New quantity: ' || new_quantity;
END;
$$;
```

## Data Classification for E-commerce

### Customer Data Tags
```sql
-- Create customer data classification
CREATE OR REPLACE TAG Customer_Data 
ALLOWED_VALUES 'PII', 'Contact', 'Financial', 'Behavioral' 
COMMENT = 'Customer data classification for e-commerce';

-- Apply customer data tags
ALTER TABLE Customer MODIFY COLUMN FirstName SET TAG Customer_Data = 'PII';
ALTER TABLE Customer MODIFY COLUMN LastName SET TAG Customer_Data = 'PII';
ALTER TABLE Customer MODIFY COLUMN Email SET TAG Customer_Data = 'Contact';
ALTER TABLE Customer MODIFY COLUMN Phone SET TAG Customer_Data = 'Contact';
```

### Financial Data Tags
```sql
-- Create financial data classification
CREATE OR REPLACE TAG Financial_Data 
ALLOWED_VALUES 'Payment', 'Transaction', 'Pricing', 'Revenue' 
COMMENT = 'Financial data classification for e-commerce';

-- Apply financial data tags
ALTER TABLE Order MODIFY COLUMN TotalAmount SET TAG Financial_Data = 'Transaction';
ALTER TABLE Order MODIFY COLUMN PaymentMethod SET TAG Financial_Data = 'Payment';
ALTER TABLE Product MODIFY COLUMN Price SET TAG Financial_Data = 'Pricing';
ALTER TABLE Product MODIFY COLUMN Cost SET TAG Financial_Data = 'Pricing';
```

## Role-Based Access Control for E-commerce

### E-commerce Roles
```sql
-- Create e-commerce specific roles
CREATE OR REPLACE ROLE SalesManager;
CREATE OR REPLACE ROLE InventoryManager;
CREATE OR REPLACE ROLE CustomerService;
CREATE OR REPLACE ROLE Analyst;

-- Grant database access
GRANT USAGE ON DATABASE OrdersDB TO ROLE SalesManager;
GRANT USAGE ON DATABASE OrdersDB TO ROLE InventoryManager;
GRANT USAGE ON DATABASE OrdersDB TO ROLE CustomerService;
GRANT USAGE ON DATABASE OrdersDB TO ROLE Analyst;

-- Grant schema access
GRANT USAGE ON SCHEMA OrdersDB.ecommerce TO ROLE SalesManager;
GRANT USAGE ON SCHEMA OrdersDB.ecommerce TO ROLE InventoryManager;
GRANT USAGE ON SCHEMA OrdersDB.ecommerce TO ROLE CustomerService;
GRANT USAGE ON SCHEMA OrdersDB.ecommerce TO ROLE Analyst;

-- Grant table permissions based on role
GRANT ALL ON ALL TABLES IN SCHEMA ecommerce TO ROLE SalesManager;
GRANT SELECT ON Product, Inventory TO ROLE InventoryManager;
GRANT SELECT ON Customer, Order TO ROLE CustomerService;
GRANT SELECT ON top_selling_products, customer_segments TO ROLE Analyst;
```

## Usage in Tutorials

This data model serves as the foundation for:

- **Data Quality Metrics** - E-commerce data validation
- **Dynamic Tables** - Real-time inventory and sales tracking
- **Snowpark ML** - Customer behavior prediction and recommendation systems
- **Cortex AI** - Product description analysis and customer sentiment
- **Streamlit Apps** - E-commerce dashboards and admin panels
- **Vector Search** - Product search and recommendation engines

## Setup Instructions

### 1. Create Database and Schema
```sql
CREATE OR REPLACE DATABASE OrdersDB;
USE DATABASE OrdersDB;
CREATE OR REPLACE SCHEMA ecommerce;
USE SCHEMA ecommerce;
```

### 2. Run Complete Setup Script
The full setup script includes:
- E-commerce table creation
- Sample retail data insertion
- Product catalog setup
- Inventory management configuration
- E-commerce-specific functions
- Retail analytics views
- E-commerce RBAC configuration

### 3. Verify Setup
```sql
-- Check e-commerce data counts
SELECT 'Customer' as table_name, COUNT(*) as row_count FROM Customer
UNION ALL
SELECT 'Product', COUNT(*) FROM Product
UNION ALL
SELECT 'Inventory', COUNT(*) FROM Inventory
UNION ALL
SELECT 'Order', COUNT(*) FROM Order
UNION ALL
SELECT 'OrderItem', COUNT(*) FROM OrderItem;
```

## Data Model Benefits

### For E-commerce Learning
- **Retail Analytics** - Real-world sales and customer analysis
- **Inventory Management** - Supply chain and stock tracking
- **Customer Journey** - Purchase patterns and behavior analysis
- **Financial Data** - Revenue, profit, and transaction analysis

### For Demos
- **Scalable Design** - Handles large product catalogs and order volumes
- **Realistic Data** - Based on actual e-commerce scenarios
- **Analytics Ready** - Pre-built views and functions for analysis
- **Multi-tenant** - Supports multiple warehouses and customer segments

## Next Steps

- [IoTDB Data Model](iotdb-data-model.md) - Internet of Things data model
- [MediSnowDB Data Model](medisnowdb-data-model.md) - Medical data model
- [SalesDB Data Model](salesdb-data-model.md) - Sales data model
- [CaresDB Data Model](caresdb-data-model.md) - Healthcare data model

## Resources

- [OrdersDB Setup Script](https://complex-teammates-374480.framer.app/demo/ordersdb-data-model) - Complete implementation
- [Dynamic Tables Tutorial](../engineering-lake/dynamic-tables.md) - Real-time inventory tracking
- [Snowpark ML Tutorial](../classic-ai-ml/snowpark-ml.md) - Recommendation systems
