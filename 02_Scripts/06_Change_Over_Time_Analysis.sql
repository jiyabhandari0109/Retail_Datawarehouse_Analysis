/* CHANGE OVER TIME ANALYSIS */

-- What is the sales performance over months?

SELECT order_date,
       SUM(sales_amount) AS total_sales
	FROM sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(sales_amount) AS total_sales,
       COUNT(DISTINCT customer_key) AS total_customers,
       SUM(quantity) AS total_qty
	FROM sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;
