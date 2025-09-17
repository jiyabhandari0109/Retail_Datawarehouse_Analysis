-- Change Date Format

UPDATE customers
SET birthdate = NULL
WHERE birthdate = '';
  
ALTER TABLE customers
MODIFY COLUMN create_date DATE,
MODIFY COLUMN birthdate DATE;

ALTER TABLE products
MODIFY COLUMN start_date DATE;

UPDATE sales
SET order_date = NULL
WHERE order_date = '';

ALTER TABLE sales 
MODIFY COLUMN order_date DATE,
MODIFY COLUMN shipping_date DATE,
MODIFY COLUMN due_date DATE;

-- Change Data Type

UPDATE sales
SET sales_amount = NULL
WHERE sales_amount = 0;

UPDATE sales
SET price = NULL
WHERE price = 0;

ALTER TABLE sales
MODIFY COLUMN sales_amount INT,
MODIFY COLUMN price INT;

UPDATE products
SET cost = NULL
WHERE cost = 0;

ALTER TABLE products
MODIFY COLUMN cost INT;

-- Change Column Name

ALTER TABLE customers 
CHANGE COLUMN customer_name customer_number VARCHAR(255);
