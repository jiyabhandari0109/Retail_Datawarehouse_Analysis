/* RANKING ANALYSIS */

-- Which 5 products Generating the Highest Revenue?

SELECT products.product_key,
       products.product_name,
       SUM(sales_amount) AS total_sales,
       ROW_NUMBER()OVER (ORDER BY SUM(sales_amount) DESC) AS row_num
	FROM products
    LEFT JOIN sales
ON products.product_key = sales.product_key
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 5;

-- What are the 5 worst-performing products in terms of sales?

SELECT products.product_key,
       products.product_name,
       SUM(sales_amount) AS total_sales,
	   ROW_NUMBER()OVER (ORDER BY SUM(sales_amount)) AS row_num
	FROM products
    LEFT JOIN sales
ON products.product_key = sales.product_key
GROUP BY 1, 2
HAVING total_sales IS NOT NULL
ORDER BY 3 
LIMIT 5;

-- Find the top 10 customers who have generated the highest revenue

SELECT *
	FROM
(
SELECT customers.customer_key,
       customers.first_name,
       customers.last_name,
       SUM(sales_amount) AS revenue_generated,
       RANK() OVER (ORDER BY SUM(sales_amount) DESC) AS ranking
	FROM customers
    LEFT JOIN sales
ON customers.customer_key = sales.customer_key
GROUP BY 1, 2, 3
ORDER BY 4 DESC
) sub
WHERE ranking <= 10;

-- Find the 3 customers with the fewest orders placed

SELECT customers.customer_key,
       customers.first_name,
       customers.last_name,
       COUNT(DISTINCT sales.order_number) AS total_orders_placed
	FROM customers
    LEFT JOIN sales
ON customers.customer_key = sales.customer_key
GROUP BY 1, 2, 3
ORDER BY 4
LIMIT 3;