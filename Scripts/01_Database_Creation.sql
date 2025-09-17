-- Database Creation

DROP DATABASE IF EXISTS DataWarehouseAnalytics;
CREATE DATABASE DataWarehouseAnalytics;
USE DataWarehouseAnalytics;

-- Creation and Insertion of Data into Tables 

DROP TABLE IF EXISTS sales;
CREATE TABLE sales 
(
    order_number    VARCHAR(20),
    product_key     INT,
    customer_key    INT,
    order_date      TEXT,
    shipping_date   TEXT,
    due_date        TEXT,
    sales_amount    DECIMAL(10,2),
    quantity        INT,
    price           DECIMAL(10,2)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_number, product_key, customer_key, order_date, shipping_date, due_date, sales_amount, quantity, price);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers 
(
    customer_key     INT,
    customer_id      VARCHAR(100),
    customer_name    VARCHAR(50),
    first_name       VARCHAR(50),
    last_name        VARCHAR(50),
    country          VARCHAR(100),
    marital_status   VARCHAR(20),
    gender           VARCHAR(10),
    birthdate        TEXT,
    create_date      TEXT
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_key, customer_id, customer_name, first_name, last_name, country, marital_status, gender, birthdate, create_date);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_key     INT,
    product_id      INT,
    product_number  VARCHAR(50),
    product_name    VARCHAR(200),
    category_id     VARCHAR(20),
    category        VARCHAR(50),
    subcategory     VARCHAR(50),
    maintenance     VARCHAR(10),
    cost            DECIMAL(10,2),
    product_line    VARCHAR(50),
    start_date      TEXT
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_key, product_id, product_number, product_name, category_id, category, subcategory, maintenance, cost, product_line, start_date);
