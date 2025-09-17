/* DATA EXPLORATION */

/* Dimensions Exploration */

SELECT * 
	FROM customers; 

-- Retreive unique countries from which customers originate

SELECT country, COUNT(*) AS total_count
FROM customers
GROUP BY country
ORDER BY 2 DESC;

-- Retreive categories and number of subcategories in categories

SELECT category, subcategory, COUNT(subcategory)
	FROM products
GROUP BY 1, 2
ORDER BY 1; 

-- Retreive categories, subcategories and product lines

SELECT DISTINCT category, subcategory, product_line
FROM products
ORDER BY 1, 2, 3;
    
-- Retreive distinct product lines

SELECT product_line
	FROM products
GROUP BY 1;

/* Date Exploration */

-- Find range of orders

SELECT MIN(order_date) AS first_order_date,
       MAX(order_date) AS last_order_date,
       TIMESTAMPDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_in_years,
	   TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS order_range_in_months
	FROM sales;
    
-- Find the youngest and the oldest customers

SELECT 
    MAX(TIMESTAMPDIFF(YEAR, birthdate, CURDATE())) AS oldest_age,
    MIN(TIMESTAMPDIFF(YEAR, birthdate, CURDATE())) AS youngest_age
FROM customers;

/* Measures Exploration */

-- Find the total sales

SELECT SUM(sales_amount) AS total_sales
	FROM sales;
    
-- Find the number of items sold

SELECT SUM(quantity) AS total_items_sold
	FROM sales;
    
-- Find average seeling price

SELECT AVG(price) AS avg_selling_price
	FROM sales;

-- Find total orders, products and customers

SELECT COUNT(DISTINCT order_number) AS total_orders
	FROM sales;
    
SELECT COUNT(DISTINCT product_id) AS total_products
	FROM products;
    
SELECT COUNT(DISTINCT customer_id) AS total_customers
	FROM customers;
    
/* Report that shows all metrics */

SELECT 'total sales' AS measure_name, SUM(sales_amount) AS measure_value FROM sales 
UNION ALL
SELECT 'items sold', SUM(quantity) FROM sales
UNION ALL
SELECT 'avg selling price', AVG(price) FROM sales
UNION ALL
SELECT 'total orders', COUNT(DISTINCT order_number) FROM sales
UNION ALL
SELECT 'total products', COUNT(DISTINCT product_id) FROM products
UNION ALL
SELECT 'total customers', COUNT(DISTINCT customer_id) FROM customers
